--
--  CREATE THE  TABLE
--

CREATE TABLE children (
    childno int(11) NOT NULL auto_increment,
    fname varchar(30),
    age int(11),
    PRIMARY KEY (childno)
);

--
--  POPULATE THE TABLE 'CHLDREN'
--

INSERT INTO    children(childno, fname, age) VALUES (1, 'jenny', 21);
INSERT INTO    children(childno, fname, age) VALUES (2, 'honny', 21);
INSERT INTO    children(childno, fname, age) VALUES (3, 'lcuy', 21);
INSERT INTO    children(childno, fname, age) VALUES (4, 'miqi', 21);