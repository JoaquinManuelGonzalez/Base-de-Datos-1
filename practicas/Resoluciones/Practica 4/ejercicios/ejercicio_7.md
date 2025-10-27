7.	Indique si las siguientes afirmaciones sobre triggers son verdaderas o falsas. Justifique las falsas.

- Un trigger se ejecuta únicamente cuando se inserta una fila en una tabla.

**FALSO**. Un Trigger no se ejecuta únicamente cuando se inserta una fila en una tabla, los triggers pueden ejecutarse cuando se inserta una fila en una tabla, cuando se actualizan los datos de una tabla o cuando se eliminan los datos de una tabla.

- Un trigger puede ejecutarse antes o después de la operación, esto es definido automáticamente según el tipo de la operación (UPDATE, INSERT o DELETE)

**FALSO**. El momento de ejecución (BEFORE o AFTER) no se define automáticamente según el tipo de operación. Debe ser explícitamente especificado al crear el trigger.

- Todo trigger debe asociarse a una tabla en concreto. 

**VERDADERO**. Todo trigger debe estar asociado a una tabla concreta. La sintaxis SQL requiere especificar ``ON table_name`` cuando se crea un trigger.

- NEW y OLD son palabras clave que permiten acceder a los valores de las filas afectadas y se pueden usar ambos independientemente de la operación utilizada.

**FALSO**. En los triggers la operación INSERT no presenta OLD y la operación DELETE no presenta NEW. El UPDATE es la única operación que presenta ambas palabras clave.

- FOR EACH ROW en un trigger se usa para indicar que el trigger se ejecutará una vez por cada fila afectada por la operación.

**VERDADERO**. ``FOR EACH ROW`` indica que el trigger se ejecutará una vez por cada fila afectada por la operación. Esto es particularmente importante cuando una operación afecta múltiples filas.