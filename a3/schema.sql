-- We cannot enforce the following constraint.
-- 1. Each class must has at least one student
-- 2. Each MC must have more than one option
-- 3. We cannot promise that only wrong answers can have hints.
--    However, we think the user should be responsible for not
--    putting hint next to correct answers

-- The only constraint that we could enforce, but did not enforce
-- is that we fail to constraint a certain student has to be in
-- the designated class to respond to a quiz. We did not enforce
-- because doing so will require us to add an extra column to
-- indicate cid(class id), which cause a lot of redundancy.

drop schema if exists quizschema cascade;
create schema quizschema;
set search_path to quizschema;

-- 1. What constraints from the domain could not be enforced?
--
-- 2. What constraints that could have been enforced were not enforced? Why not?
--

-- Create table student to store student ids(sid), lastnames and firstnames of each student.
-- sid is the primary key of this table, and both lastname and firstname cannot be NULL.
CREATE TABLE student(
	sid VARCHAR(10) primary key,
	lastname VARCHAR(50) NOT NULL,
	firstname VARCHAR(50) NOT NULL);

-- Create table class to store a class id (cid) as primary key.
-- For each cid, there is a room, a teacher, and a grade level, that are all not NULL.
-- A constraint enforced here is that (teacher, room) is unique, since according to the domain,
-- there cannot be multiple classes for the same grade.
-- A constraint in the domain that we did not enforce here is that a room can have two classes in it. ######
CREATE TABLE class(
	cid INT primary key,
	room VARCHAR(20) NOT NULL,
	teacher VARCHAR(50) NOT NULL,
	grade INT NOT NULL,
	UNIQUE(teacher, room));

-- Create table enroll to store enrollment information, which includes attributes cid(class id) and sid(student id).
-- Since a class can have many students, the primary key in this table is (cid, sid).
-- Since in our schema (cid,sid) is primary key, we choose not to enforce a constraint that there is at least one student in
-- each class. (i.e, a class recorded in table class may not appear in enroll, if no student is in that class).
CREATE TABLE enroll(
	cid INT REFERENCES class(cid),
	sid VARCHAR(10) REFERENCES student(sid),
	primary key(cid, sid));

-- Create table questionbank to record question id - qid and corresponding question.
-- The qid is primary key, and we set question content to be unique.######
CREATE TABLE questionbank(
	qid INT primary key,
	question VARCHAR(1000) UNIQUE);

-- Create table mc_answer to record qid and corresponding answer to the corresponding multiple choice question.
-- Answer should not be NULL since a question must have a valid answer.
-- qid should be primary key, also a foreign key referring to qid in table questionbank.
CREATE TABLE mc_answer(
	qid INT primary key REFERENCES questionbank(qid),
	answer VARCHAR(1000) NOT NULL);

-- Create table num_answer to record qid and corresponding answer to the corresponding numeric question.
-- Answer should not be NULL since a question must have a valid answer.
-- qid should be primary key, also a foreign key referring to qid in table questionbank.
CREATE TABLE num_answer(
	qid INT primary key REFERENCES questionbank(qid),
	answer INT NOT NULL);

-- Create table tf_answer to record qid and corresponding answer to the corresponding true/false choice question.
-- Answer should not be NULL since a question must have a valid answer.
-- qid should be primary key, also a foreign key referring to qid in table questionbank.
CREATE TABLE tf_answer(
	qid INT primary key References questionbank(qid),
	answer BOOLEAN NOT NULL);

-- Create table mc_option_hint to store the hints for multiple choice option.
-- (qid, option) is a primary key for this table, and qid should be foreign key referring to qid in questionbank.
-- hint can be NULL. However, we did not enforce the constraint that hints are only possible for wrong answers.
CREATE TABLE mc_option_hint(
	qid INT REFERENCES questionbank(qid),
	option VARCHAR(1000) NOT NULL,
	hint VARCHAR(1000),
	primary key(qid, option));

-- Create table num_hint to store the hints for false numeric response interval.
-- (qid, range_lb, range_ub) is a primary key for this table, and qid should be foreign key referring to qid in questionbank.
-- hint can be NULL. However, we did not enforce the constraint that hints are only possible for wrong answers.
CREATE TABLE num_hint(
	qid INT REFERENCES questionbank(qid),
	range_lb INT NOT NULL,
	range_ub INT NOT NULL,
	hint VARCHAR(1000),
	primary key(qid, range_lb, range_ub));

-- Create table quiz to record quiz id - quizid, title, due date and due time, the class that is assigned this quiz,
-- and a boolean attribute allowhint (all these attributes cannot be NULL.)
-- quizid is the primary key for this table
CREATE TABLE quiz(
	quizid VARCHAR(50) primary key,
	title VARCHAR(100) NOT NULL,
	due_date DATE NOT NULL,
	due_time TIME NOT NULL,
	class INT REFERENCES class(cid) NOT NULL,
	allowhint BOOLEAN NOT NULL);

-- Create table quiz_question to record quizid and qid for questions in corresponding quiz, and weights for these questions.
-- weights for each question in each quiz cannot be NULL.
-- (quizid,qid) is a primary key since questions can appear on different quizzes.
-- This design also allows the same question to have different weights on different quizzes.
CREATE TABLE quiz_question(
	quizid VARCHAR(50) REFERENCES quiz(quizid),
	qid INT REFERENCES questionbank(qid),
	weight INT NOT NULL,
	primary key (quizid, qid));

-- Create table mc_response to record student response for multiple choice questions
-- sid is foreign key referring to sid in student, quizid is foreign key referring to quizid in quiz
-- (sid, quizid, qid) is the primary key. Student response cannot be NULL. Thus students not responding to
-- a question will not be recorded here.
CREATE TABLE mc_response(
	sid VARCHAR(10) REFERENCES student(sid),
	quizid VARCHAR(50) REFERENCES quiz(quizid),
	qid INT REFERENCES questionbank(qid),
	response VARCHAR(1000) NOT NULL,
	primary key(sid, quizid, qid));

-- Create table tf_response to record student response for true/false questions.
-- primary key and foreign key design are similar to in mc_response.
CREATE TABLE tf_response(
        sid VARCHAR(10) REFERENCES student(sid),
        quizid VARCHAR(50) REFERENCES quiz(quizid),
        qid INT REFERENCES questionbank(qid),
        response BOOLEAN NOT NULL,
        primary key(sid, quizid, qid));

-- Create table tf_response to record student response for numeric questions.
-- primary key and foreign key design are similar to in mc_response.
CREATE TABLE num_response(
        sid VARCHAR(10) REFERENCES student(sid),
        quizid VARCHAR(50) REFERENCES quiz(quizid),
        qid INT REFERENCES questionbank(qid),
        response INT NOT NULL,
        primary key(sid, quizid, qid));
