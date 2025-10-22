/*

3.	Crear una vista llamada ‘doctors_per_patients’ que muestre los id de los pacientes y los id de doctores de la ciudad donde vive el paciente.

*/

CREATE VIEW doctors_per_patients AS
SELECT DISTINCT p.patient_id, d.doctor_id
FROM patient p
JOIN doctor d ON p.patient_city = d.doctor_city;