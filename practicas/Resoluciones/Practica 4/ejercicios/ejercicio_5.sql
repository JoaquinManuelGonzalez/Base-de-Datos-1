/*

5.	Escribe y ejecute la sentencia correspondiente para crear la siguiente tabla:

APPOINTMENTS_PER_PATIENT
idApP: int(11) PK AI
id_patient: int(11) 
count_appointments: int(11) 
last_update: datetime 
user: varchar(16)

*/

CREATE TABLE appointments_per_patient (
    idApP INT(11) PRIMARY KEY AUTO_INCREMENT,
    id_patient INT(11) NOT NULL,
    count_appointments INT(11) NOT NULL,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    user VARCHAR(16) NOT NULL,
    FOREIGN KEY (id_patient) REFERENCES patient(patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;