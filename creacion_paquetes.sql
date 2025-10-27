CREATE OR REPLACE PACKAGE pkg_employee AS
    -- 1.1. Operaciones CRUD básicas
    -- CREATE
    PROCEDURE crear_empleado(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    );
    
    -- READ
    PROCEDURE read_employee(p_employee_id NUMBER);

    -- UPDATE
    PROCEDURE update_employee(p_employee_id NUMBER, p_salary NUMBER);

    -- DELETE
    PROCEDURE delete_employee(p_employee_id NUMBER);
    
    -- 1.1. Rotación de puestos: Los 4 mas rotados
    PROCEDURE mostrar_empleados_mas_rotados;

    -- 1.2. Resumen de contrataciones promedio por mes con respecto a todos los años
    FUNCTION resumen_contrataciones RETURN NUMBER;

    -- 1.3. Gastos en salario y estadística de empleados a nivel regional
    PROCEDURE gastos_salarios_regionales;

    -- 1.4. Calcular tiempo de vacaciones
    FUNCTION calcular_vacaciones RETURN NUMBER;

    -- 1.5. Horas laboradas al mes
    FUNCTION horas_laboradas_mes(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_anio NUMBER
    ) RETURN NUMBER;

    -- 1.6. Horas que falto al mes
    FUNCTION horas_faltantes_mes(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_anio NUMBER
    ) RETURN NUMBER;

    -- 1.7. Calcular el sueldo que recibe al mes
    PROCEDURE calcular_sueldo_mensual(p_mes NUMBER, p_anio NUMBER);

    -- 1.8. Calcular las horas de capacitacion que el empleado ha tomado
    FUNCTION horas_capacitacion_empleado(p_employee_id NUMBER) RETURN NUMBER;

    -- 1.9. Listar las capacitaciones de todos los empleados
    PROCEDURE listar_capacitaciones_empleados;

END pkg_employee;
/

CREATE OR REPLACE PACKAGE BODY pkg_employee AS
    -- Implementación CRUD
    PROCEDURE create_employee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2,
        p_hire_date DATE,
        p_job_id VARCHAR2,
        p_salary NUMBER,
        p_commission_pct NUMBER,
        p_manager_id NUMBER,
        p_department_id NUMBER
    ) IS
    BEGIN
        INSERT INTO employees VALUES (
            p_employee_id, p_first_name, p_last_name, p_email,
            p_phone_number, p_hire_date, p_job_id, p_salary,
            p_commission_pct, p_manager_id, p_department_id
        );
        COMMIT;
    END;

    PROCEDURE read_employee(p_employee_id NUMBER) IS
    BEGIN
        FOR emp IN (SELECT * FROM employees WHERE employee_id = p_employee_id) LOOP
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || emp.first_name || ' ' || emp.last_name);
        END LOOP;
    END;

    PROCEDURE update_employee(p_employee_id NUMBER, p_salary NUMBER) IS
    BEGIN
        UPDATE employees SET salary = p_salary WHERE employee_id = p_employee_id;
        COMMIT;
    END;

    PROCEDURE delete_employee(p_employee_id NUMBER) IS
    BEGIN
        DELETE FROM employees WHERE employee_id = p_employee_id;
        COMMIT;
    END;

    -- 1.1. Implementación de Rotacion de puestos: Los 4 más rotados
    PROCEDURE mostrar_empleados_mas_rotados IS
    BEGIN
        FOR emp IN (
            SELECT e.employee_id, e.last_name, e.first_name, 
                   e.job_id, j.job_title,
                   COUNT(jh.job_id) as cambios_puesto
            FROM employees e
            JOIN jobs j ON e.job_id = j.job_id
            LEFT JOIN job_history jh ON e.employee_id = jh.employee_id
            GROUP BY e.employee_id, e.last_name, e.first_name, e.job_id, j.job_title
            ORDER BY cambios_puesto DESC
            FETCH FIRST 4 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'ID: ' || emp.employee_id || 
                ', Nombre: ' || emp.first_name || ' ' || emp.last_name ||
                ', Puesto Actual: ' || emp.job_id || ' - ' || emp.job_title ||
                ', Cambios: ' || emp.cambios_puesto
            );
        END LOOP;
    END;

    -- 1.2. Implementación de Resumen de contrataciones promedio por mes con respecto a todos los años
    FUNCTION resumen_contrataciones RETURN NUMBER IS
        total_meses NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RESUMEN DE CONTRATACIONES POR MES ===');
        
        FOR mes IN (
            SELECT TO_CHAR(hire_date, 'Month') as nombre_mes,
                   COUNT(*) / COUNT(DISTINCT EXTRACT(YEAR FROM hire_date)) as promedio
            FROM employees
            GROUP BY TO_CHAR(hire_date, 'Month')
            ORDER BY TO_CHAR(TO_DATE(nombre_mes, 'Month'), 'MM')
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Mes: ' || RTRIM(mes.nombre_mes) || 
                ', Promedio: ' || ROUND(mes.promedio, 2)
            );
            total_meses := total_meses + 1;
        END LOOP;
        
        RETURN total_meses;
    END;

    -- 1.3. Implementación de Gastos en salario y estadística de empleados a nivel regional
    PROCEDURE gastos_salarios_regionales IS
    BEGIN
        FOR reg IN (
            SELECT r.region_name,
                   SUM(e.salary) as suma_salarios,
                   COUNT(e.employee_id) as cantidad_empleados,
                   MIN(e.hire_date) as fecha_antiguo
            FROM regions r
            JOIN countries c ON r.region_id = c.region_id
            JOIN locations l ON c.country_id = l.country_id
            JOIN departments d ON l.location_id = d.location_id
            JOIN employees e ON d.department_id = e.department_id
            GROUP BY r.region_name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Región: ' || reg.region_name ||
                ', Suma Salarios: $' || reg.suma_salarios ||
                ', Empleados: ' || reg.cantidad_empleados ||
                ', Empleado más antiguo: ' || TO_CHAR(reg.fecha_antiguo, 'DD/MM/YYYY')
            );
        END LOOP;
    END;

    -- 1.4. Implementación de Calcular tiempo de vacaciones
    FUNCTION calcular_vacaciones RETURN NUMBER IS
        total_monto NUMBER := 0;
    BEGIN
        FOR emp IN (
            SELECT employee_id, first_name, last_name, salary, hire_date,
                   TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) as años_servicio,
                   TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) as meses_vacaciones
            FROM employees
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Empleado: ' || emp.first_name || ' ' || emp.last_name ||
                ', Años servicio: ' || emp.años_servicio ||
                ', Meses vacaciones: ' || emp.meses_vacaciones
            );
            total_monto := total_monto + (emp.salary * emp.meses_vacaciones / 12);
        END LOOP;
        
        RETURN total_monto;
    END;

    -- 1.5. Implementación de Horas laboradas al mes
    FUNCTION horas_laboradas_mes(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_anio NUMBER
    ) RETURN NUMBER IS
        v_total_horas NUMBER := 0;
    BEGIN
        SELECT SUM(EXTRACT(HOUR FROM (hora_termino_real - hora_inicio_real)) * 60 +
                   EXTRACT(MINUTE FROM (hora_termino_real - hora_inicio_real))) / 60
        INTO v_total_horas
        FROM Asistencia_Empleado
        WHERE employee_id = p_employee_id
            AND EXTRACT(MONTH FROM fecha_real) = p_mes
            AND EXTRACT(YEAR FROM fecha_real) = p_anio;
    
        RETURN NVL(v_total_horas, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RETURN 0;
    END;

    -- 1.6. Implementación de Horas faltantes
    FUNCTION horas_faltantes_mes(
        p_employee_id NUMBER,
        p_mes NUMBER,
        p_anio NUMBER
    ) RETURN NUMBER IS
        v_horas_esperadas NUMBER := 0;
        v_horas_realizadas NUMBER := 0;
        v_dias_laborales NUMBER := 0;
    BEGIN
        SELECT COUNT(*) * 8
        INTO v_horas_esperadas
        FROM Empleado_Horario eh
        WHERE eh.employee_id = p_employee_id;
    
        v_horas_realizadas := horas_laboradas_mes(p_employee_id, p_mes, p_anio);
    
        IF v_horas_esperadas > v_horas_realizadas THEN
            RETURN v_horas_esperadas - v_horas_realizadas;
        ELSE
            RETURN 0;
        END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 160;
        WHEN OTHERS THEN
            RETURN 0;
    END;

    -- 1.7 Implementación de Calcular sueldo al mes
    PROCEDURE calcular_sueldo_mensual(p_mes NUMBER, p_anio NUMBER) IS
        v_sueldo_base NUMBER;
        v_sueldo_final NUMBER;
        v_horas_esperadas NUMBER := 160;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== REPORTE DE SUELDOS - MES ' || p_mes || '/' || p_anio || ' ===');
        DBMS_OUTPUT.PUT_LINE('Empleado' || CHR(9) || CHR(9) || 'Salario Base' || CHR(9) || 'Salario Final');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    
        FOR emp IN (
            SELECT e.employee_id, e.first_name, e.last_name, e.salary
            FROM employees e
        ) LOOP
            v_sueldo_base := emp.salary;
            v_sueldo_final := v_sueldo_base;
        
            DECLARE
                v_horas_faltantes NUMBER;
                v_porcentaje_falta NUMBER;
            BEGIN
                v_horas_faltantes := horas_faltantes_mes(emp.employee_id, p_mes, p_anio);
            
                IF v_horas_faltantes > 0 THEN
                    v_porcentaje_falta := (v_horas_faltantes / v_horas_esperadas);
                    v_sueldo_final := v_sueldo_base * (1 - v_porcentaje_falta);
                END IF;

                -- Mostrar resultado
                DBMS_OUTPUT.PUT_LINE(
                    emp.first_name || ' ' || emp.last_name || CHR(9) ||
                    '$' || ROUND(v_sueldo_base, 2) || CHR(9) || CHR(9) ||
                    '$' || ROUND(v_sueldo_final, 2)
                );
            END;
        END LOOP;
    END;

    -- 1.8. Implementación de calcular las horas de capacitación del empleado
    FUNCTION horas_capacitacion_empleado(p_employee_id NUMBER) RETURN NUMBER IS
        v_total_horas NUMBER := 0;
    BEGIN
        SELECT SUM(c.horas_capacitacion)
        INTO v_total_horas
        FROM EmpleadoCapacitacion ec
        JOIN Capacitacion c ON ec.codigo_capacitacion = c.codigo_capacitacion
        WHERE ec.employee_id = p_employee_id;
    
        RETURN NVL(v_total_horas, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RETURN 0;
    END;

    -- 1.9. Implementación de Listar capacitaciones de empleados
    PROCEDURE listar_capacitaciones_empleados IS
    BEGIN
        FOR emp IN (
            SELECT e.employee_id, e.first_name, e.last_name,
                   horas_capacitacion_empleado(e.employee_id) as total_horas
            FROM employees e
            WHERE EXISTS (
                SELECT 1 FROM EmpleadoCapacitacion ec 
                WHERE ec.employee_id = e.employee_id
            )
            ORDER BY total_horas DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                emp.first_name || ' ' || emp.last_name || CHR(9) || CHR(9) ||
                emp.total_horas || ' horas'
            );
        END LOOP;
    END;

END pkg_employee;
/
