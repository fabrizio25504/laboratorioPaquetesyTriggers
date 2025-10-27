-- Tabla Horario
CREATE TABLE Horario (
    dia_semana VARCHAR2(10) NOT NULL,
    turno VARCHAR2(20) NOT NULL,
    hora_inicio TIMESTAMP NOT NULL,
    hora_termino TIMESTAMP NOT NULL,
    CONSTRAINT pk_horario PRIMARY KEY (dia_semana, turno)
);

-- Inserciones en la tabla Horario
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('LUNES', 'MANANA', TIMESTAMP '2025-10-13 08:00:00.000000', TIMESTAMP '2025-10-13 13:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('LUNES', 'TARDE',  TIMESTAMP '2025-10-13 14:00:00.000000', TIMESTAMP '2025-10-13 18:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('MARTES', 'MANANA', TIMESTAMP '2025-10-14 09:00:00.000000', TIMESTAMP '2025-10-14 13:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('MARTES', 'TARDE',  TIMESTAMP '2025-10-14 14:00:00.000000', TIMESTAMP '2025-10-14 19:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('MIERCOLES', 'COMPLETO', TIMESTAMP '2025-10-15 08:00:00.000000', TIMESTAMP '2025-10-15 17:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('JUEVES', 'GUARDIA_M', TIMESTAMP '2025-10-16 07:00:00.000000', TIMESTAMP '2025-10-16 15:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('VIERNES', 'VESPERTINO', TIMESTAMP '2025-10-17 15:00:00.000000', TIMESTAMP '2025-10-17 21:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('SABADO', 'MEDIO',  TIMESTAMP '2025-10-18 09:00:00.000000', TIMESTAMP '2025-10-18 13:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('DOMINGO', 'NOCHE', TIMESTAMP '2025-10-19 22:00:00.000000', TIMESTAMP '2025-10-20 06:00:00.000000');
INSERT INTO Horario (dia_semana, turno, hora_inicio, hora_termino) VALUES ('MARTES', 'NOCHE', TIMESTAMP '2025-10-14 20:00:00.000000', TIMESTAMP '2025-10-15 03:00:00.000000');

-- Tabla Empleado_Horario
CREATE TABLE Empleado_Horario (
    dia_semana VARCHAR2(10) NOT NULL,
    turno VARCHAR2(20) NOT NULL,
    employee_id NUMBER(6) NOT NULL,
    CONSTRAINT pk_emp_horario PRIMARY KEY (dia_semana, turno, employee_id),
    CONSTRAINT fk_emp_horario_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Inserciones en la tabla Empleado_Horario
-- Asignación de LUNES
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('LUNES', 'MANANA', 100);
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('LUNES', 'TARDE', 101);

-- Asignación de MARTES
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('MARTES', 'MANANA', 100);
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('MARTES', 'TARDE', 102);
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('MARTES', 'NOCHE', 103);

-- Asignación de MIÉRCOLES
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('MIERCOLES', 'COMPLETO', 104);

-- Asignación de JUEVES
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('JUEVES', 'GUARDIA_M', 101);

-- Asignación de VIERNES
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('VIERNES', 'VESPERTINO', 102);

-- Asignación de FIN DE SEMANA
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('SABADO', 'MEDIO', 103);
INSERT INTO Empleado_Horario (dia_semana, turno, employee_id) VALUES ('DOMINGO', 'NOCHE', 104);

-- Tabla Asistencia_Empleado
CREATE TABLE Asistencia_Empleado (
    employee_id NUMBER(6) NOT NULL,
    dia_semana VARCHAR2(10) NOT NULL,
    fecha_real DATE NOT NULL,
    hora_inicio_real TIMESTAMP,
    hora_termino_real TIMESTAMP,
    CONSTRAINT pk_asistencia PRIMARY KEY (employee_id, fecha_real),
    CONSTRAINT fk_asistencia_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


-- Inserciones en la tabla Asistencia_Empleado
-- 1. Empleado 100: LUNES (Llega tarde)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (100, 'LUNES', DATE '2025-10-20', TIMESTAMP '2025-10-20 08:15:00.000000', TIMESTAMP '2025-10-20 13:00:00.000000');

-- 2. Empleado 101: LUNES (A tiempo)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (101, 'LUNES', DATE '2025-10-20', TIMESTAMP '2025-10-20 13:58:00.000000', TIMESTAMP '2025-10-20 18:05:00.000000');

-- 3. Empleado 100: MARTES (A tiempo)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (100, 'MARTES', DATE '2025-10-21', TIMESTAMP '2025-10-21 08:55:00.000000', TIMESTAMP '2025-10-21 13:00:00.000000');

-- 4. Empleado 102: MARTES (Salió temprano)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (102, 'MARTES', DATE '2025-10-21', TIMESTAMP '2025-10-21 13:50:00.000000', TIMESTAMP '2025-10-21 17:30:00.000000');

-- 5. Empleado 103: MARTES NOCHE (A tiempo)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (103, 'MARTES', DATE '2025-10-21', TIMESTAMP '2025-10-21 19:55:00.000000', TIMESTAMP '2025-10-22 03:00:00.000000');

-- 6. Empleado 104: MIÉRCOLES (Completo, salida sin marcar - posible error)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (104, 'MIERCOLES', DATE '2025-10-22', TIMESTAMP '2025-10-22 08:00:00.000000', NULL);

-- 7. Empleado 101: JUEVES (Guardia a tiempo)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (101, 'JUEVES', DATE '2025-10-23', TIMESTAMP '2025-10-23 06:58:00.000000', TIMESTAMP '2025-10-23 15:00:00.000000');

-- 8. Empleado 102: VIERNES (Vespertino)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (102, 'VIERNES', DATE '2025-10-24', TIMESTAMP '2025-10-24 14:55:00.000000', TIMESTAMP '2025-10-24 20:50:00.000000');

-- 9. Empleado 103: SÁBADO (Medio)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (103, 'SABADO', DATE '2025-10-25', TIMESTAMP '2025-10-25 09:00:00.000000', TIMESTAMP '2025-10-25 13:00:00.000000');

-- 10. Empleado 104: LUNES (Otra fecha, no coincide con su horario)
INSERT INTO Asistencia_Empleado (employee_id, dia_semana, fecha_real, hora_inicio_real, hora_termino_real) 
VALUES (104, 'LUNES', DATE '2025-10-27', TIMESTAMP '2025-10-27 08:00:00.000000', TIMESTAMP '2025-10-27 17:00:00.000000');
