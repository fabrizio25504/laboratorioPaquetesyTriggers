-- 2. Creación de triggers

-- 2.1. Verificación de inserción en AsistenciaEmpleado
CREATE OR REPLACE TRIGGER trg_valida_asistencia
    BEFORE INSERT ON Asistencia_Empleado
    FOR EACH ROW
DECLARE
    v_dia_correcto VARCHAR2(10);
    v_hora_inicio_esperada TIMESTAMP;
    v_hora_termino_esperada TIMESTAMP;
BEGIN
    SELECT TO_CHAR(:NEW.fecha_real, 'DAY') INTO v_dia_correcto FROM DUAL;
    
    IF UPPER(:NEW.dia_semana) != UPPER(TRIM(v_dia_correcto)) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El día de la semana no corresponde con la fecha');
    END IF;
    
    SELECT h.hora_inicio, h.hora_termino 
    INTO v_hora_inicio_esperada, v_hora_termino_esperada
    FROM Horario h
    JOIN Empleado_Horario eh ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
    WHERE eh.employee_id = :NEW.employee_id 
    AND eh.dia_semana = :NEW.dia_semana;

    IF :NEW.hora_inicio_real < v_hora_inicio_esperada - INTERVAL '30' MINUTE OR
       :NEW.hora_inicio_real > v_hora_inicio_esperada + INTERVAL '30' MINUTE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Hora de inicio fuera del rango permitido');
    END IF;
    
    IF :NEW.hora_termino_real < v_hora_termino_esperada - INTERVAL '30' MINUTE OR
       :NEW.hora_termino_real > v_hora_termino_esperada + INTERVAL '30' MINUTE THEN
        RAISE_APPLICATION_ERROR(-20003, 'Hora de término fuera del rango permitido');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'No se encontró horario para el empleado');
END;
/

-- 2.2. Trigger para validar salario según puesto
CREATE OR REPLACE TRIGGER trg_valida_salario
    BEFORE INSERT OR UPDATE ON employees
    FOR EACH ROW
DECLARE
    v_min_salary jobs.min_salary%TYPE;
    v_max_salary jobs.max_salary%TYPE;
BEGIN
    SELECT min_salary, max_salary 
    INTO v_min_salary, v_max_salary
    FROM jobs 
    WHERE job_id = :NEW.job_id;
    
    IF :NEW.salary < v_min_salary THEN
        RAISE_APPLICATION_ERROR(-20005, 
            'Salario menor al mínimo permitido para el puesto: ' || v_min_salary);
    ELSIF :NEW.salary > v_max_salary THEN
        RAISE_APPLICATION_ERROR(-20006, 
            'Salario mayor al máximo permitido para el puesto: ' || v_max_salary);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20007, 'Puesto no encontrado en la tabla Jobs');
END;
/

-- 2.3. Trigger para control de acceso e inasistencia
CREATE OR REPLACE TRIGGER trg_control_acceso
    BEFORE INSERT ON Asistencia_Empleado
    FOR EACH ROW
DECLARE
    v_hora_entrada_esperada TIMESTAMP;
    v_diferencia_minutos NUMBER;
BEGIN
    SELECT h.hora_inicio 
    INTO v_hora_entrada_esperada
    FROM Horario h
    JOIN Empleado_Horario eh ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
    WHERE eh.employee_id = :NEW.employee_id 
    AND eh.dia_semana = :NEW.dia_semana;

    v_diferencia_minutos := ABS(EXTRACT(MINUTE FROM (:NEW.hora_inicio_real - v_hora_entrada_esperada)));
    
    IF :NEW.hora_inicio_real > v_hora_entrada_esperada + INTERVAL '30' MINUTE THEN
        INSERT INTO inasistencias (employee_id, fecha, tipo) 
        VALUES (:NEW.employee_id, :NEW.fecha_real, 'TARDANZA_GRAVE');
        
        RAISE_APPLICATION_ERROR(-20008, 
            'Acceso denegado - Empleado marcado como inasistente por llegar tarde');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20009, 'Horario no encontrado para el empleado');
END;
/
