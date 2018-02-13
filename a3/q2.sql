--q2
CREATE TABLE q2 (
	qid INT,
	text VARCHAR(1000),
	num_hint INT);

--get the multiple choice hint
CREATE VIEW mchint AS
SELECT questionbank.qid, questionbank.question,
mc_option_hint.hint
FROM questionbank, mc_option_hint
WHERE questionbank.qid = mc_option_hint.qid;

--numeric hint
CREATE VIEW numhint AS
SELECT questionbank.qid, questionbank.question, num_hint.hint
FROM questionbank, num_hint
WHERE questionbank.qid = num_hint.qid;

--add a temporary column of NULL values for intermediate use.
--this column will be dropped later
ALTER TABLE questionbank
ADD hint INT DEFAULT NULL;

--combine mc/num hint
CREATE VIEW hint AS
select * from mchint
UNION
select * from numhint;

--question(mc and numeric) with number of hint
CREATE VIEW num_mc_hint AS
SELECT qid, question, count(hint) as num_hint
FROM hint
GROUP BY qid, question;

--tf hint
CREATE VIEW tf_hint AS
SELECT questionbank.qid, questionbank.question, questionbank.hint
FROM questionbank, tf_answer
WHERE questionbank.qid = tf_answer.qid;

--result
CREATE VIEW result AS
select * from tf_hint
UNION
select * from num_mc_hint;

--insert solution into q3
INSERT INTO q2
select * from result;

--CHANGE BACK TABLE
ALTER TABLE questionbank
DROP COLUMN hint CASCADE;
