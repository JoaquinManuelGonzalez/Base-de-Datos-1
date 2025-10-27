/*

9.	Crear un stored procedure que sirva para agregar un appointment, junto el registro de un doctor que lo atendió (medical_review) y un medicamento que se le recetó (prescribed_medication), dentro de una sola transacción. El stored procedure debe recibir los siguientes parámetros: patient_id, doctor_id, appointment_duration, contact_phone, appointment_address, medication_name. El appointment_date será la fecha actual. Los atributos restantes deben ser obtenidos de la tabla Patient (o dejarse en NULL).

*/

-- Eliminar el procedure si existe
DROP PROCEDURE IF EXISTS ejercicio_9;

DELIMITER //
CREATE PROCEDURE ejercicio_9(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_appointment_duration INT,
    IN p_contact_phone VARCHAR(45),
    IN p_appointment_address VARCHAR(255),
    IN p_medication_name VARCHAR(30)
)
BEGIN
    -- Variables auxiliares
    DECLARE appointment_date DATETIME;
    -- Seguridad ante fallos en la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    -- Obtengo la fecha actual
    SET appointment_date = NOW();
    -- Inicio la transacción
    START TRANSACTION;
    -- Inserto el nuevo appointment
    INSERT INTO appointment (patient_id, appointment_date, appointment_duration, contact_phone, observations, payment_card)
    VALUES (p_patient_id, appointment_date, p_appointment_duration, p_contact_phone, p_appointment_address, NULL);
    -- Inserto el registro en medical_review
    INSERT INTO medical_review (patient_id, appointment_date, doctor_id)
    VALUES (p_patient_id, appointment_date, p_doctor_id);
    -- Inserto el registro en prescribed_medication
    INSERT INTO prescribed_medication (patient_id, appointment_date, medication_name)
    VALUES (p_patient_id, appointment_date, p_medication_name);
    -- Confirmo la transacción
    COMMIT;
END //
DELIMITER ;