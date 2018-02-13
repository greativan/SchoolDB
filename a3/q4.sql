--q4

-- find all the students in grade 8, classroom 120, with teacher Mr Higgins
-- and wrote the quiz Pr1-220310
CREATE VIEW quiz_info1 AS
SELECT sid
FROM class, enroll, quiz
WHERE class.cid = enroll.cid and class.cid = quiz.class 
	and class.room = '120' and class.grade = 8 and 
	class.teacher = 'Mr Higgins' and quiz.quizid = 'Pr1-220310';

-- find students and qid for multiple choice questions that they responsed
CREATE VIEW student_responded_mc AS
SELECT quiz_info1.sid, qid
FROM quiz_info1, mc_response
WHERE quiz_info1.sid = mc_response.sid and mc_response.quizid = 'Pr1-220310';

-- find students and qid for true/false questions that they responsed
CREATE VIEW student_responded_tf AS
SELECT quiz_info1.sid, qid
FROM quiz_info1, tf_response
WHERE quiz_info1.sid = tf_response.sid and tf_response.quizid = 'Pr1-220310';

-- find students and qid for numeric questions that they responsed
CREATE VIEW student_responded_num AS
SELECT quiz_info1.sid, qid
FROM quiz_info1, num_response
WHERE quiz_info1.sid = num_response.sid and num_response.quizid = 'Pr1-220310';

-- combine the results to record the student sids and all the questions they responded to
CREATE VIEW responded_mc_tf AS
SELECT * FROM student_responded_mc
UNION
SELECT * FROM student_responded_tf;

CREATE VIEW responded AS
SELECT * FROM responded_mc_tf
UNION
SELECT * FROM student_responded_num;

-- create a table to record all combinations assuming each student in the class answers all questions on the quiz
CREATE VIEW all_combinations AS
SELECT sid, qid
FROM quiz_question t1, quiz_info1 t2
WHERE quizid = 'Pr1-220310';

-- find the students and corresponding questions that they did not answer 
-- by using EXCEPT
CREATE VIEW result AS
SELECT * FROM all_combinations
EXCEPT
SELECT * FROM responded;

-- report sid, qid and question content
CREATE VIEW q4 AS
SELECT sid as studentID, result.qid as questionID, question
FROM result, questionbank
WHERE result.qid = questionbank.qid;