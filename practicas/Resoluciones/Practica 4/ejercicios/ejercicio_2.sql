/*

2.	Hallar aquellos pacientes que para todas sus consultas médicas siempre hayan dejado su número de teléfono primario (nunca el teléfono secundario). 

*/

SELECT p.patient_id, p.patient_name
FROM patient p
WHERE NOT EXISTS (
    -- Buscamos citas donde el teléfono de contacto no sea el primario
    SELECT 1
    FROM appointment a
    WHERE a.patient_id = p.patient_id
    AND a.contact_phone <> p.primary_phone
) AND EXISTS (
    -- Aseguramos que el paciente tenga al menos una cita
    SELECT 1
    FROM appointment a
    WHERE a.patient_id = p.patient_id
);

/*

SALIDA DE LA CONSULTA:

+------------+--------------------------------------+
| patient_id | patient_name                         |
+------------+--------------------------------------+
|   10000791 | Joaquin Juan Ignacio Rojas Sanchez   |
|   10003098 | Lucio Dominguez Flores               |
|   10003465 | Sofia Juan Ignacio Gutierrez Navarro |
|   10003927 | Gael Hernandez Garcia                |
|   10009106 | Morena Matias Carrizo                |
|   10009145 | Valentin Nuñez                      |
|   10009148 | Francesca Flores Sosa                |
|   10009316 | Julian Carrizo Arias                 |
|   10013654 | Thiago Dominguez                     |
|   10013904 | Santino Luisana Gonzalez             |
|   10017000 | Lola Juan Sebastian Ojeda            |
|   10028891 | Faustino Tiziano Diaz Romero         |
|   10029073 | Angel Gabriel Tomàs Rodriguez       |
|   10032225 | Amparo Mansilla                      |
|   10039279 | Julieta Vega Gomez                   |
|   10044303 | Thiago Abril Castro                  |
|   10044927 | Joaquin Sofia Diaz Godoy             |
|   10049870 | Lautaro Benjamin Perez Quiroga       |
+------------+--------------------------------------+

*/