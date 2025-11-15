       IDENTIFICATION DIVISION.
       PROGRAM-ID. PATIENT-TEST-INCIDENTS.

       * This program is intended for testing detection tools.
       * ALL DATA BELOW IS SYNTHETIC. DO NOT USE REAL PATIENT DATA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PATIENT-IN
               ASSIGN TO "patients.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PLAIN-LOG
               ASSIGN TO "plain_log.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTBOUND
               ASSIGN TO "outbound_unencrypted.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  PATIENT-IN
           LABEL RECORDS ARE STANDARD
           VALUE OF FILE-ID IS "patients.txt".
       01  PATIENT-REC.
           05  P-ID           PIC 9(6).
           05  P-NAME         PIC A(30).
           05  P-DOB          PIC 9(8).
           05  P-SSN          PIC 9(9).
           05  P-DIAG         PIC A(40).
           05  P-TREAT        PIC A(60).

       FD  PLAIN-LOG
           LABEL RECORDS ARE STANDARD.
       01  LOG-REC           PIC A(200).

       FD  OUTBOUND
           LABEL RECORDS ARE STANDARD.
       01  OUT-REC           PIC A(200).

       WORKING-STORAGE SECTION.
       01  EOF-FLAG          PIC X VALUE "N".
           88  EOF            VALUE "Y".
           88  NOT-EOF        VALUE "N".
       01  WS-COUNTER        PIC 9(4) VALUE 0.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           OPEN INPUT PATIENT-IN
                OUTPUT PLAIN-LOG
                OUTPUT OUTBOUND.

           PERFORM UNTIL EOF
               READ PATIENT-IN
                   AT END
                       SET EOF TO TRUE
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM.

           CLOSE PATIENT-IN PLAIN-LOG OUTBOUND.
           DISPLAY "Processing complete.".
           STOP RUN.

       PROCESS-RECORD.
           ADD 1 TO WS-COUNTER.

           * === INSECURE PATTERN #1: Write full patient identifiers to general log in plaintext ===
           * This is intentionally insecure for test detection:
           STRING "REC#" WS-COUNTER " ID:" P-ID " NAME:" P-NAME
                  " DOB:" P-DOB " SSN:" P-SSN " DIAG:" P-DIAG
                  DELIMITED BY SIZE INTO LOG-REC.
           WRITE LOG-REC.

           * === INSECURE PATTERN #2: Copy full PHI to outbound 'network' file UNENCRYPTED ===
           * Simulates sending PHI over network unencrypted.
           STRING "TRANSMIT ID=" P-ID ",NAME=" P-NAME ",SSN=" P-SSN ",DIAG=" P-DIAG
                  DELIMITED BY SIZE INTO OUT-REC.
           WRITE OUT-REC.

           * === INSECURE PATTERN #3: Store SSN in cleartext variable (P-SSN) and include it in any outputs ===
           * Many compliance checks look for SSN patterns or numeric identifiers.
           * (No masking, no access control.)

           * <Optional simulated processing>
           PERFORM FAKE-PROCESSING.

       FAKE-PROCESSING.
           * simulate some business logic
           IF P-DIAG = "SYNTHETIC-CODE-1"
               CONTINUE
           END-IF.

