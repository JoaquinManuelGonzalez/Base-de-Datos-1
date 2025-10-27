/*

1.	Crea un usuario para las bases de datos usando el nombre ‘appointments_user’. Asigne a estos todos los permisos sobre sus respectivas tablas. Habiendo creado este usuario evitaremos el uso de ‘root’ para el resto del trabajo práctico. Adicionalmente, con respecto a esta base de datos:

a.	Cree un usuario sólo con permisos para realizar consultas de selección, es decir que no puedan realizar cambios en la base. Use el nombre ‘appointments_select’.

b.	Cree un usuario que pueda realizar consultas de selección, inserción,  actualización y eliminación a nivel de filas, pero que no puedan modificar el esquema. Use el nombre ‘appointments_update’.

c.	Cree un usuario que tenga los permisos de los anteriores, pero que además pueda modificar el esquema de la base de datos. Use el nombre 'appointments_schema'.

*/

-- Usuario con todos los permisos sobre la base
CREATE USER 'appointments_user'@'%' IDENTIFIED BY 'userpass123';
GRANT ALL PRIVILEGES ON trabajo_db.* TO 'appointments_user'@'%';

-- Usuario solo lectura (SELECT)
CREATE USER 'appointments_select'@'%' IDENTIFIED BY 'selectpass123';
GRANT SELECT ON trabajo_db.* TO 'appointments_select'@'%';

-- Usuario con SELECT, INSERT, UPDATE, DELETE (no cambia esquema)
CREATE USER 'appointments_update'@'%' IDENTIFIED BY 'updatepass123';
GRANT SELECT, INSERT, UPDATE, DELETE ON trabajo_db.* TO 'appointments_update'@'%';

-- Usuario con permisos completos + modificar esquema (DDL)
CREATE USER 'appointments_schema'@'%' IDENTIFIED BY 'schemapass123';
GRANT ALL PRIVILEGES ON trabajo_db.* TO 'appointments_schema'@'%';

-- Aplicar cambios
FLUSH PRIVILEGES;