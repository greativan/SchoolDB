
--DATA
-- insert student ids, last names and first names in student table
INSERT INTO student VALUES
('0998801234','Headey','Lena'),
('0010784522','Dinklage','Peter'),
('0997733991','Clarke','Emilia'),
('5555555555','Harrington','Kit'),
('1111111111','Turner','Sophie'),
('2222222222','Williams','Maisie');

--class information
INSERT INTO class VALUES
(1, 120, 'Mr Higgins', 8),
(2, 366, 'Sophie Turner', 5);

-- insert the class ids and corresponding student ids that enroll in the classes into
-- table enroll
INSERT INTO enroll VALUES
(1, '0998801234'),
(1, '0010784522'),
(1, '0997733991'),
(1, '5555555555'),
(1, '1111111111'),
(2, '2222222222');

--quiz info
INSERT INTO quiz VALUES
('Pr1-220310', 'Citizenship Test Practise Questions', '2017-10-01', '13:30:00', 1, 't');

-- insert question IDs and corresponding question text into questionbank
INSERT INTO questionbank VALUES
(782, 'What do you promise when you take the oath of citizenship?'),
(566, 'The Prime Minister, Justin Trudeau, is Canada''s Head of State.'),
(601, 'During the ''Quiet Revolution,'' Quebec experienced rapid change. In what decade did this occur?
(Enter the year that began the decade, e.g., 1840.)'),
(625, 'What is the Underground Railroad?'),
(790, 'During the War of 1812 the Americans burned down the Parliament Buildings in
York (now Toronto). What did the British and Canadians do in return?');

-- insert multiple choice question IDs and corresponding answer into mc_answer
INSERT INTO mc_answer VALUES
(782, 'To pledge your loyalty to the Sovereign, Queen Elizabeth II'),
(625, 'A network used by slaves who escaped the United States into Canada'),
(790, 'They burned down the White House in Washington D.C.');

-- insert true/false question IDs and corresponding answer into tf_answer
INSERT INTO tf_answer VALUES
(566, 'f');

-- insert numeric question IDs and corresponding answer into num_answer
INSERT INTO num_answer VALUES
(601, 1960);

-- insert multiple choice question IDs, options and corresponding hints(if exists) into mc_option_hint
INSERT INTO mc_option_hint VALUES
(782, 'To pledge your loyalty to the Sovereign, Queen Elizabeth II', NULL),
(782, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian', 'Think regally.'),
(782, 'To pledge your loyalty to Canada from sea to sea', NULL),
(625, 'The first railway to cross Canada', 'The Underground Railroad was generally south to north, not east-west.'),
(625, 'The CPR''s secret railway line', 'The Underground Railroad was secret, but it had nothing to do with trains.'),
(625, 'The TTC subway system', 'The TTC is relatively recent; the Underground Railroad was in operation over 100 years ago.'),
(625, 'A network used by slaves who escaped the United States into Canada', NULL),
(790, 'They attacked American merchant ships', NULL),
(790, 'They expanded their defence system, including Fort York', NULL),
(790, 'They burned down the White House in Washington D.C.', NULL),
(790, 'They captured Niagara Falls', NULL);

-- insert numeric question IDs, intervals(lower and upper bounds) for wrong answers 
-- and corresponding hints(if exists) into num_hint
INSERT INTO num_hint VALUES
(601,1800,1900,'The Quiet Revolution happened during the 20th Century.'),
(601,2000,2010,'The Quiet Revolution happened some time ago.'),
(601,2020,3000,'The Quiet Revolution has already happened!');



-- insert quiz ids, corresponding question ids and weights into table quiz_question
INSERT INTO quiz_question VALUES
('Pr1-220310',601,2),
('Pr1-220310',566,1),
('Pr1-220310',790,3),
('Pr1-220310',625,2);

--numeric response
INSERT INTO num_response VALUES
('0998801234', 'Pr1-220310', 601, 1950),
('0010784522', 'Pr1-220310', 601, 1960),
('0997733991', 'Pr1-220310', 601, 1960);

--t/f response
INSERT INTO tf_response VALUES
('0998801234', 'Pr1-220310', 566, 'f'),
('0010784522', 'Pr1-220310', 566, 'f'),
('0997733991', 'Pr1-220310', 566, 't'),
('5555555555', 'Pr1-220310', 566, 'f');

--m/c response
INSERT INTO mc_response VALUES
('0998801234', 'Pr1-220310', 790, 'They expanded their defence system, including Fort York'),
('0010784522', 'Pr1-220310', 790, 'They burned down the White House in Washington D.C.'),
('0997733991', 'Pr1-220310', 790, 'They burned down the White House in Washington D.C.'),
('5555555555', 'Pr1-220310', 790, 'They captured Niagara Falls'),
('0998801234', 'Pr1-220310', 625, 'A network used by slaves who escaped the United States into Canada'),
('0010784522', 'Pr1-220310', 625, 'A network used by slaves who escaped the United States into Canada'),
('0997733991', 'Pr1-220310', 625, 'The CPR''s secret railway line');
