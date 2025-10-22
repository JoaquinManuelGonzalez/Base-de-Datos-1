-- Drop tables if they already exist
DROP TABLE IF EXISTS PrescribedMedication;
DROP TABLE IF EXISTS MedicalReview;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Doctor;

-- Table Patient
CREATE TABLE `patient` (
  `patient_id` int(11) NOT NULL,
  `patient_name` varchar(255) NOT NULL,
  `patient_address` varchar(255) NOT NULL,
  `patient_city` varchar(255) DEFAULT NULL,
  `primary_phone` varchar(255) DEFAULT NULL,
  `secondary_phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table Doctor
CREATE TABLE `doctor` (
  `doctor_id` int(11) NOT NULL,
  `doctor_name` varchar(255) NOT NULL,
  `doctor_address` varchar(255) DEFAULT NULL,
  `doctor_city` varchar(255) DEFAULT NULL,
  `doctor_specialty` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table Appointment
CREATE TABLE `appointment` (
  `patient_id` int(11) NOT NULL,
  `appointment_date` datetime NOT NULL,
  `appointment_duration` int(11) DEFAULT NULL,
  `contact_phone` varchar(45) DEFAULT NULL,
  `observations` varchar(255) DEFAULT NULL,
  `payment_card` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`patient_id`, `appointment_date`),
  FOREIGN KEY (`patient_id`) REFERENCES `patient`(`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table Prescribed Medication
CREATE TABLE `prescribed_medication` (
  `patient_id` int(11) NOT NULL,
  `appointment_date` datetime NOT NULL,
  `medication_name` varchar(30) NOT NULL,
  PRIMARY KEY (`patient_id`, `appointment_date`, `medication_name`),
  FOREIGN KEY (`patient_id`, `appointment_date`) REFERENCES `appointment`(`patient_id`, `appointment_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table Medical Review
CREATE TABLE `medical_review` (
  `patient_id` int(11) NOT NULL,
  `appointment_date` datetime NOT NULL,
  `doctor_id` int(11) NOT NULL,
  PRIMARY KEY (`patient_id`, `appointment_date`, `doctor_id`),
  FOREIGN KEY (`patient_id`, `appointment_date`) REFERENCES `appointment`(`patient_id`, `appointment_date`),
  FOREIGN KEY (`doctor_id`) REFERENCES `doctor`(`doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
