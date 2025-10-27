/*

10.	Ejecutar el stored procedure del punto 9 con los siguientes datos:
patient_id: 10004427
doctor_id: 1003
appointment_duration: 30
contact_phone: +54 15 2913 9963
appointment_address: ‘Hospital Italiano’ 
medication_name: ‘Paracetamol’

*/

CALL ejercicio_9(
    10004427,
    1003,
    30,
    '+54 15 2913 9963',
    'Hospital Italiano',
    'Paracetamol'
);

SELECT * FROM appointment 
WHERE patient_id = 10004427 
ORDER BY appointment_date DESC 
LIMIT 1;

SELECT * FROM medical_review 
WHERE patient_id = 10004427 AND doctor_id = 1003
ORDER BY appointment_date DESC 
LIMIT 1;

SELECT * FROM prescribed_medication 
WHERE patient_id = 10004427 AND medication_name = 'Paracetamol'
ORDER BY appointment_date DESC 
LIMIT 1;

/*

RESULTADOS OBTENIDOS:

+------------+---------------------+----------------------+------------------+-------------------+--------------+
| patient_id | appointment_date    | appointment_duration | contact_phone    | observations      | payment_card |
+------------+---------------------+----------------------+------------------+-------------------+--------------+
|   10004427 | 2025-10-21 18:32:04 |                   30 | +54 15 2913 9963 | Hospital Italiano | NULL         |
+------------+---------------------+----------------------+------------------+-------------------+--------------+
+------------+---------------------+-----------+
| patient_id | appointment_date    | doctor_id |
+------------+---------------------+-----------+
|   10004427 | 2025-10-21 18:32:04 |      1003 |
+------------+---------------------+-----------+
+------------+---------------------+-----------------+
| patient_id | appointment_date    | medication_name |
+------------+---------------------+-----------------+
|   10004427 | 2025-10-21 18:32:04 | Paracetamol     |
+------------+---------------------+-----------------+

*/