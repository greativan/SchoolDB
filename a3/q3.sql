--q3

-- find all the students in grade 8, classroom 120, with teacher Mr Higgins
-- and wrote the quiz Pr1-220310
CREATE VIEW quiz_info AS
SELECT sid
FROM class, enroll, quiz
WHERE class.cid = enroll.cid and class.cid = quiz.class 
	and class.room = '120' and class.grade = 8 and 
	class.teacher = 'Mr Higgins' and quiz.quizid = 'Pr1-220310';

-- find the multiple choice responses of those students
CREATE VIEW student_response_mc AS
SELECT quiz_info.sid, qid, response
FROM quiz_info, mc_response
WHERE quiz_info.sid = mc_response.sid and mc_response.quizid = 'Pr1-220310';

-- find all the true/false responses of those students
CREATE VIEW student_response_tf AS
SELECT quiz_info.sid, qid, response
FROM quiz_info, tf_response
WHERE quiz_info.sid = tf_response.sid and tf_response.quizid = 'Pr1-220310';

-- find all the numeric responses of those students
CREATE VIEW student_response_num AS
SELECT quiz_info.sid, qid, response
FROM quiz_info, num_response
WHERE quiz_info.sid = num_response.sid and num_response.quizid = 'Pr1-220310';

-- record the students and the question ids that 
-- they answer correctly on multiple choice questions
CREATE VIEW correctly_answered_mc AS
SELECT sid, m.qid
FROM student_response_mc s, mc_answer m
WHERE s.qid = m.qid and s.response = m.answer;

-- record the students and the question ids that 
-- they answer correctly on true/false questions
CREATE VIEW correctly_answered_tf AS
SELECT sid, t.qid
FROM student_response_tf s, tf_answer t
WHERE s.qid = t.qid and s.response = t.answer;

-- record the students and the question ids that they answer correctly on numeric questions
CREATE VIEW correctly_answered_num AS
SELECT sid, n.qid
FROM student_response_num s, num_answer n
WHERE s.qid = n.qid and s.response = n.answer;

-- combine the results in correctly_answered to record 
-- the student sids and all their correctly answered question ids 
CREATE VIEW correctly_answered1 AS
SELECT * FROM correctly_answered_mc
UNION
SELECT * FROM correctly_answered_tf;

CREATE VIEW correctly_answered AS
SELECT * FROM correctly_answered1
UNION
SELECT * FROM correctly_answered_num;

-- find and record the student ids and weights for their correctly answered questions
CREATE VIEW partial_mark AS
SELECT sid, sum(weight) as mark
FROM correctly_answered c, quiz_question q
WHERE c.qid = q.qid and quizid = 'Pr1-220310'
GROUP BY sid;

-- find the students who are not in partial_mark
CREATE VIEW zero_mark_student AS
SELECT sid FROM quiz_info
EXCEPT
SELECT sid FROM partial_mark;

-- assign zero mark to students found in zero_mark_student
CREATE VIEW zero_mark AS
SELECT sid, 0 as mark
FROM zero_mark_student;

-- combine zero_mark and partial_mark to get full students mark info
CREATE VIEW q3 AS
SELECT * FROM zero_mark
UNION
SELECT * FROM partial_mark;
