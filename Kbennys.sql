-- Benny's By Kamion

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_bennys', 'bennys', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_bennys', 'bennys', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_bennys', 'bennys', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('bennys', 'bennys')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('bennys',0,'recrue','Recrue',12,'{}','{}'),
	('bennys',1,'novice','Novice',24,'{}','{}'),
	('bennys',2,'experimente','Experimente',36,'{}','{}'),
	('bennys',3,'chief',"Chef d\'équipe",48,'{}','{}'),
	('bennys',4,'boss','Patron',0,'{}','{}')
;

