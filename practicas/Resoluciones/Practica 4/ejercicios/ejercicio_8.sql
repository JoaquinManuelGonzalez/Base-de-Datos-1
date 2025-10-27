/*

8.	Crear un Trigger de modo que al insertar un dato en la tabla Appointment, se actualice la cantidad de appointments del paciente, la fecha de actualización y el usuario responsable de la misma (actualiza la tabla APPOINTMENTS PER PATIENT).

*/

-- Eliminar el trigger si existe
DROP TRIGGER IF EXISTS trg_dsp_de_insertar_appointment;

DELIMITER //
CREATE TRIGGER trg_dsp_de_insertar_appointment
AFTER INSERT ON appointment
FOR EACH ROW
BEGIN
    -- Declaro variables auxiliares
    DECLARE fecha_actual DATETIME;
    DECLARE usuario_actual VARCHAR(16);
    DECLARE cant_citas INT;
    -- Obtengo los valores de fecha y usuario actual
    SET fecha_actual = NOW();
    SET usuario_actual = SUBSTRING(CURRENT_USER(), 1, 16);
    -- Obtengo la cantidad de citas del paciente
    SELECT COUNT(*) INTO cant_citas
    FROM appointment
    WHERE patient_id = NEW.patient_id;
    -- Verificamos si el paciente existe o no
    IF EXISTS (SELECT 1 FROM appointments_per_patient WHERE id_patient = NEW.patient_id) THEN
        -- Si existe, actualizamos el registro
        UPDATE appointments_per_patient
        SET count_appointments = cant_citas,
            last_update = fecha_actual,
            user = usuario_actual
        WHERE id_patient = NEW.patient_id;
    ELSE
        -- Si no existe, insertamos un nuevo registro
        INSERT INTO appointments_per_patient (id_patient, count_appointments, last_update, user)
        VALUES (NEW.patient_id, cant_citas, fecha_actual, usuario_actual);
    END IF;
END //
DELIMITER ;


/*

OTRA VERSIÓN MÁS EFICIENTE PERO ESPECÍFICA DEL MOTOR:

DELIMITER //
CREATE TRIGGER trg_dsp_de_insertar_appointment
AFTER INSERT ON appointment
FOR EACH ROW
BEGIN
    -- Declaro variables auxiliares
    DECLARE fecha_actual DATETIME;
    DECLARE usuario_actual VARCHAR(16);
    -- Obtengo los valores de fecha y usuario actual
    SET fecha_actual = NOW();
    SET usuario_actual = SUBSTRING(CURRENT_USER(), 1, 16);
    -- Usamos INSERT ... ON DUPLICATE KEY UPDATE para actualizar o insertar el registro
    INSERT INTO appointments_per_patient (id_patient, count_appointments, last_update, user)
    SELECT NEW.patient_id, COUNT(*), fecha_actual, usuario_actual
    FROM appointment
    WHERE patient_id = NEW.patient_id
    ON DUPLICATE KEY UPDATE
        count_appointments = VALUES(count_appointments),
        last_update = VALUES(last_update),
        user = VALUES(user);
END //
DELIMITER ;

*/