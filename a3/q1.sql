
-- find the student information
CREATE VIEW q1 AS 
select concat(firstname, ' ', lastname) as fullname, sid as studentnumber
from student;

