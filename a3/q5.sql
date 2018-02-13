
-- find all students in grade 8 class in room 120 with
-- Mr Higgins and wrote quiz Pr1-220310
CREATE VIEW all_students AS
SELECT sid
FROM class, enroll, quiz
WHERE class.cid = enroll.cid and class.cid = quiz.class
	  and class.room = '120' and class.grade = 8 and
	  class.teacher = 'Mr Higgins' and quiz.quizid = 'Pr1-220310';

-- find the multiple chocie response of those students 
CREATE VIEW student_response_mc_q5 AS
SELECT all_students.sid, qid, response
FROM all_students, mc_response
WHERE all_students.sid = mc_response.sid and mc_response.quizid = 'Pr1-220310';

-- find all the true/false responses of those students
CREATE VIEW student_response_tf_q5 AS
SELECT all_students.sid, qid, response
FROM all_students, tf_response
WHERE all_students.sid = tf_response.sid and tf_response.quizid = 'Pr1-220310';

-- find all the numeric responses of those students
CREATE VIEW student_response_num_q5 AS
SELECT all_students.sid, qid, response
FROM all_students, num_response
WHERE all_students.sid = num_response.sid and num_response.quizid = 'Pr1-220310';

-- record the students and the question ids that 
-- they answer correctly on multiple choice questions
CREATE VIEW correctly_answered_mc_q5 AS
SELECT sid, m.qid
FROM student_response_mc_q5 s, mc_answer m
WHERE s.qid = m.qid and s.response = m.answer;

-- record the students and the question ids that 
-- they answer correctly on true/false questions
CREATE VIEW correctly_answered_tf_q5 AS
SELECT sid, t.qid
FROM student_response_tf_q5 s, tf_answer t
WHERE s.qid = t.qid and s.response = t.answer;

-- record the students and the question ids that they answer correctly on numer$
CREATE VIEW correctly_answered_num_q5 AS
SELECT sid, n.qid
FROM student_response_num_q5 s, num_answer n
WHERE s.qid = n.qid and s.response = n.answer;

-- the student sids and all their correctly answered question ids 
CREATE VIEW correctly_answered1_q5 AS
SELECT * FROM correctly_answered_mc_q5
UNION
SELECT * FROM correctly_answered_tf_q5;

CREATE VIEW correctly_answered_q5 AS
SELECT * FROM correctly_answered1_q5
UNION
SELECT * FROM correctly_answered_num_q5;

-- combine to find the students that answered all the questions,
-- record their sid and the corresponding qid
CREATE VIEW all_responses1 AS
SELECT sid, qid FROM student_response_mc_q5
UNION
SELECT sid, qid FROM student_response_tf_q5;

CREATE VIEW all_responses AS
SELECT * FROM all_responses1
UNION
SELECT sid, qid FROM student_response_num_q5;

-- find students sid and corresponding question ids that they answered wrong
CREATE VIEW wrong_responses AS
SELECT * FROM all_responses
EXCEPT
SELECT * FROM correctly_answered_q5;

-- find all the combinations of student and the questions on that quiz
CREATE VIEW all_combinations_q5 AS
SELECT sid, qid
FROM quiz_question, all_students
WHERE quizid = 'Pr1-220310';

-- find students and corresponding question ids that they did not respond to
CREATE VIEW did_not_respond AS
SELECT * FROM all_combinations_q5
EXCEPT
SELECT * FROM all_responses;

CREATE VIEW all_qid AS
SELECT distinct(qid) FROM all_combinations_q5;

-- we form a table to join all the people who 
-- answered the question
-- answered the question wrong
-- did not answer question
CREATE VIEW v1 AS
SELECT t4.qid, t1.sid AS correct
FROM correctly_answered_q5 t1 NATURAL RIGHT JOIN all_qid t4;-- on t1.qid = t4.qid;

CREATE VIEW v2 AS
SELECT v1.qid, v1.correct, t1.sid AS wrong
FROM wrong_responses t1 RIGHT JOIN v1 on t1.qid = v1.qid;

CREATE VIEW v3 AS
SELECT v2.qid, v2.correct, v2.wrong, t1.sid AS didnt_respond
FROM did_not_respond t1 RIGHT JOIN v2 on t1.qid = v2.qid;

-- for each question, return the number of students that answered correctly,
-- wrong and did not answer
CREATE VIEW q5 AS
SELECT v3.qid, count(DISTINCT correct) AS num_correct, count(DISTINCT wrong) AS num_wrong, 
	   count(DISTINCT didnt_respond) AS num_didnt_respond
FROM v3
GROUP BY v3.qid;




























