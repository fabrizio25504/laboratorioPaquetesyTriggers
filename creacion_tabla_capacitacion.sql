-- Tabla Capacitacion
CREATE TABLE Capacitacion (
    codigo_capacitacion NUMBER PRIMARY KEY,
    nombre_capacitacion VARCHAR2(100) NOT NULL,
    horas_capacitacion NUMBER NOT NULL,
    descripcion VARCHAR2(500)
);

-- Inserción en la tabla Capacitación
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (10, 'Liderazgo y Equipos', 20, 'Taller avanzado sobre gestión de equipos de alto rendimiento.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (11, 'Introducción a SQL', 40, 'Curso básico para consultas y manipulación de datos en bases de datos.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (12, 'Seguridad de Redes', 35, 'Conceptos fundamentales y prácticas de ciberseguridad.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (13, 'Marketing Digital Avanzado', 15, 'Estrategias de SEO, SEM y redes sociales.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (14, 'Primeros Auxilios', 8, 'Curso esencial de respuesta a emergencias médicas.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (15, 'Gestión de Proyectos (SCRUM)', 50, 'Metodología ágil para la administración de proyectos.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (16, 'Comunicación Efectiva', 12, 'Técnicas para mejorar la oratoria y la comunicación interna.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (17, 'Contabilidad Básica', 25, 'Introducción a estados financieros y principios contables.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (18, 'Programación Python', 60, 'Desarrollo de scripts y aplicaciones con Python.');
INSERT INTO Capacitacion (codigo_capacitacion, nombre_capacitacion, horas_capacitacion, descripcion) VALUES (19, 'BPM y Optimización', 30, 'Modelado y mejora de procesos de negocio.');

-- Tabla EmpleadoCapacitacion
CREATE TABLE EmpleadoCapacitacion (
    employee_id NUMBER(6) NOT NULL,
    codigo_capacitacion NUMBER NOT NULL,
    CONSTRAINT pk_emp_capac PRIMARY KEY (employee_id, codigo_capacitacion),
    CONSTRAINT fk_emp_capac_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_emp_capac_capac FOREIGN KEY (codigo_capacitacion) REFERENCES Capacitacion(codigo_capacitacion)
);

-- Inserción en la tabla EmpleadoCapacitacion
-- Empleado 100 tiene 3 capacitaciones
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (100, 10); -- Liderazgo
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (100, 11); -- SQL
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (100, 16); -- Comunicación

-- Empleado 101 tiene 2 capacitaciones
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (101, 15); -- SCRUM
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (101, 18); -- Python

-- Empleado 102 tiene 2 capacitaciones
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (102, 12); -- Seguridad
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (102, 19); -- BPM

-- Empleado 103 tiene 1 capacitación
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (103, 17); -- Contabilidad

-- Empleado 104 tiene 2 capacitaciones
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (104, 13); -- Marketing
INSERT INTO EmpleadoCapacitacion (employee_id, codigo_capacitacion) VALUES (104, 14); -- Primeros Auxilios
