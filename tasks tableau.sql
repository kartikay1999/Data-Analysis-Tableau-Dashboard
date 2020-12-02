use employees_mod;

select 
year(d.from_date) as calendar_year,
e.gender,
count(e.emp_no) as num_employees
from t_employees e
join
t_dept_emp d
on d.emp_no=e.emp_no
group by calendar_year,e.gender
having calendar_year>=1990;

SELECT 
    d.dept_name,
    ee.gender,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            YEAR(dm.to_date) > e.calendar_year
                AND YEAR(dm.from_date) <= e.calendar_year
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calendar_year;


SELECT 
    e.gender,
    dm.dept_name,
    YEAR(e.hire_date) AS calendar_year,
    AVG(s.salary)
FROM
    t_employees e
        JOIN
    t_salaries s ON e.emp_no = s.emp_no
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
        JOIN
    t_departments dm ON d.dept_no = dm.dept_no
GROUP BY e.gender , dm.dept_name , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no; 

delimiter $$
create procedure filter_salary(in p_min_salary float,in p_max_salary float)
begin
select
e.gender,d.dept_name,avg(s.salary) as avg_salary
from 
t_salaries s
join
t_employees e on s.emp_no=e.emp_no
join
t_dept_emp de on de.emp_no=e.emp_no
join
t_departments d on d_dept_no=de.dept_no
where s.salary between p_min_salry and p_max_salary
group by d.dept_no,e.gender;
end$$
delimiter ;

