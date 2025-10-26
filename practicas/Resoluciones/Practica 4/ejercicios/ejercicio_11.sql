/*

11.	Considerando la siguiente consulta:

select count(a.patient_id) 
from appointment a, patient p, doctor d, medical_review mr
where    a.patient_id= p.patient_id 
	and a.patient_id= mr.patient_id 
	and a.appointment_date=mr.appointment_date
and mr.doctor_id = d.doctor_id
	and d.doctor_speciality  = ‘Cardiology’
	and p.patient_city =  Rosario

Analice su plan de ejecución mediante el uso de la sentencia EXPLAIN.

a.	¿Qué atributos del plan de ejecución encuentra relevantes para evaluar la performance de la consulta?

b.	Observe en particular el atributo type ¿cómo se están aplicando los JOIN entre las tablas involucradas?

c.	Según lo que observó en los puntos anteriores, ¿qué mejoras se pueden realizar para optimizar la consulta? 

d.	Aplique las mejoras propuestas y vuelva a analizar el plan de ejecución. ¿Qué cambios observa?

*/


EXPLAIN SELECT COUNT(a.patient_id) 
FROM appointment a, patient p, doctor d, medical_review mr
WHERE a.patient_id = p.patient_id 
    AND a.patient_id = mr.patient_id 
    AND a.appointment_date = mr.appointment_date
    AND mr.doctor_id = d.doctor_id
    AND d.doctor_specialty = "Cardiology"
    AND p.patient_city = "Rosario";

/*

SALIDA DEL EXPLAIN:

+----+-------------+-------+------------+--------+-------------------+-----------+---------+---------------------------------------------------------+------+----------+-------------+
| id | select_type | table | partitions | type   | possible_keys     | key       | key_len | ref                                                     | rows | filtered | Extra       |
+----+-------------+-------+------------+--------+-------------------+-----------+---------+---------------------------------------------------------+------+----------+-------------+
|  1 | SIMPLE      | mr    | NULL       | index  | PRIMARY,doctor_id | doctor_id | 4       | NULL                                                    |    1 |   100.00 | Using index |
|  1 | SIMPLE      | p     | NULL       | eq_ref | PRIMARY           | PRIMARY   | 4       | trabajo_db.mr.patient_id                                |    1 |    10.00 | Using where |
|  1 | SIMPLE      | d     | NULL       | eq_ref | PRIMARY           | PRIMARY   | 4       | trabajo_db.mr.doctor_id                                 |    1 |    10.00 | Using where |
|  1 | SIMPLE      | a     | NULL       | eq_ref | PRIMARY           | PRIMARY   | 9       | trabajo_db.mr.patient_id,trabajo_db.mr.appointment_date |    1 |   100.00 | Using index |
+----+-------------+-------+------------+--------+-------------------+-----------+---------+---------------------------------------------------------+------+----------+-------------+

*/

/*

ANÁLISIS DEL PLAN DE EJECUCIÓN:

a.	¿Qué atributos del plan de ejecución encuentra relevantes para evaluar la performance de la consulta?

Los atributos más relevantes en el análisis son:
- type: Nos indica el tipo de join que se está utilizando entre las tablas. Cuanto más cercano a const o eq_ref, mejor.
- key: Muestra qué índice se está utilizando para acceder a los datos.
- rows: Indica la cantidad de filas que MySQL estima que tendrá que examinar.
- Extra: Proporciona información adicional sobre cómo se está ejecutando la consulta, como si se están utilizando índices, where, etc.

b.	Observe en particular el atributo type ¿cómo se están aplicando los JOIN entre las tablas involucradas?

- mr: Se recorre la tabla usando un índice, pero no de manera óptima.
- p, d, a: Se están utilizando joins de tipo eq_ref, lo cual es eficiente ya que cada fila de la tabla principal coincide con una sola fila en las tablas unidas.

c.	Según lo que observó en los puntos anteriores, ¿qué mejoras se pueden realizar para optimizar la consulta?

Podríamos agregar índices en las columnas que son filtradas por WHERE, como doctor(doctor_specialty) y patient(patient_city) mejorando así la selectividad de las condiciones

*/

/*

d.	Aplique las mejoras propuestas y vuelva a analizar el plan de ejecución. ¿Qué cambios observa?

*/

-- Crear índices para los filtros
CREATE INDEX idx_doctor_specialty ON doctor(doctor_specialty);
CREATE INDEX idx_patient_city ON patient(patient_city);

EXPLAIN SELECT COUNT(a.patient_id)
FROM medical_review mr
INNER JOIN doctor d 
    ON mr.doctor_id = d.doctor_id
INNER JOIN patient p 
    ON mr.patient_id = p.patient_id
INNER JOIN appointment a 
    ON a.patient_id = mr.patient_id 
    AND a.appointment_date = mr.appointment_date
WHERE d.doctor_specialty = 'Cardiology'
  AND p.patient_city = 'Rosario';

/*

SALIDA DEL EXPLAIN DESPUÉS DE LAS MEJORAS:

+----+-------------+-------+------------+--------+------------------------------+-----------+---------+---------------------------------------------------------+------+----------+-------------+
| id | select_type | table | partitions | type   | possible_keys                | key       | key_len | ref                                                     | rows | filtered | Extra       |
+----+-------------+-------+------------+--------+------------------------------+-----------+---------+---------------------------------------------------------+------+----------+-------------+
|  1 | SIMPLE      | mr    | NULL       | index  | PRIMARY,doctor_id            | doctor_id | 4       | NULL                                                    |    1 |   100.00 | Using index |
|  1 | SIMPLE      | p     | NULL       | eq_ref | PRIMARY,idx_patient_city     | PRIMARY   | 4       | trabajo_db.mr.patient_id                                |    1 |   100.00 | Using where |
|  1 | SIMPLE      | d     | NULL       | eq_ref | PRIMARY,idx_doctor_specialty | PRIMARY   | 4       | trabajo_db.mr.doctor_id                                 |    1 |    19.00 | Using where |
|  1 | SIMPLE      | a     | NULL       | eq_ref | PRIMARY                      | PRIMARY   | 9       | trabajo_db.mr.patient_id,trabajo_db.mr.appointment_date |    1 |   100.00 | Using index |
+----+-------------+-------+------------+--------+------------------------------+-----------+---------+---------------------------------------------------------+------+----------+-------------+

*/