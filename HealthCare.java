import java.time.LocalDate;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Sample class that simulates patient logging for compliance or privacy agent testing.
 * 
 * ⚠️ NOTE: This is for testing detection of sensitive logs (no real data used).
 * Replace or mask sensitive values before production use.
 */
public class PatientLogger {

    private static final Logger logger = Logger.getLogger(PatientLogger.class.getName());

    // Simple mock patient object
    static class Patient {
        String id;
        String name;
        String email;
        LocalDate dob;
        String diagnosis;

        Patient(String name, String email, LocalDate dob, String diagnosis) {
            this.id = UUID.randomUUID().toString();
            this.name = name;
            this.email = email;
            this.dob = dob;
            this.diagnosis = diagnosis;
        }
    }

    // Simulate logging patient info (this intentionally includes sensitive-looking data for testing)
    public static void logPatient(Patient p) {
        logger.log(Level.INFO, "Processing patient record...");
        logger.log(Level.INFO, "Patient ID: {0}", p.id);
        logger.log(Level.INFO, "Name: {0}", p.name);
        logger.log(Level.INFO, "Email: {0}", p.email);
        logger.log(Level.INFO, "Date of Birth: {0}", p.dob);
        logger.log(Level.INFO, "Diagnosis: {0}", p.diagnosis);

        // Simulate a potential logging issue (PII leak)
        logger.log(Level.WARNING, "DEBUG: Raw patient data = {0}", p.toString());
    }

    public static void main(String[] args) {
        Patient p = new Patient(
                "Alex Mercer",
                "alex.mercer@example.test",
                LocalDate.of(1990, 5, 14),
                "Hypertension (Stage 1)"
        );

        logPatient(p);
    }

    @Override
    public String toString() {
        return "PatientLogger{}";
    }
}
