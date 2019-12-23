create database linkedin

CREATE TABLE MEMBER
(
	Member_id int NOT NULL IDENTITY (1,1),
	Fname nvarchar(20) NOT NULL,
	Lname nvarchar(25) NOT NULL,
	Email nvarchar(50) NOT NULL,
	Password nvarchar(20) NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Member_id),
	Unique (Email),

	
);

CREATE TABLE ORGANIZATION
(
	Organization_id int NOT NULL IDENTITY(1,1),
	Name nvarchar(40) NOT NULL,
	City nvarchar(167) NOT NULL,
	PRIMARY KEY(Organization_id)
);

CREATE TABLE JOB_OFFER
(
	Job_offer_id int NOT NULL IDENTITY(1,1),
	Organization_id int NOT NULL,
	Offer_date date NOT NULL DEFAULT GETDATE(),
	Description nvarchar(500),
	PRIMARY KEY(Job_offer_id),
	FOREIGN KEY(Organization_id) REFERENCES ORGANIZATION(Organization_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE job_application
(
	job_application_id int NOT NULL identity(1,1),
	job_offer_id int NOT NULL,
	member_id int NOT NULL,
	job_app_date date NOT NULL DEFAULT GETDATE(),

	constraint job_application_pk
	primary key(job_application_id),
	constraint job_application_fk
	foreign key (member_id) references member(member_id)
		on update cascade on delete cascade,
	foreign key(job_offer_id) references job_offer(job_offer_id)
		on update cascade on delete cascade,
	 unique(job_offer_id,member_id)
);

CREATE TABLE PROFILE
(
	Profile_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Birth_date date NOT NULL,
	Sex nvarchar(10) NOT NULL CHECK (Sex='Male' OR SEX='Female'),
	Marital_status nvarchar(10) NOT NULL CHECK (Marital_status='Single' OR Marital_status='Married'),
	Organization_id int,
	Phone nvarchar(15),
	
	PRIMARY KEY(Profile_id),
	UNIQUE(Member_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Organization_id) REFERENCES ORGANIZATION(Organization_id)
		ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE HOBBIE
(
	Hobbie_id int NOT NULL IDENTITY(1,1),
	Profile_id int NOT NULL,
	Fav_animal nvarchar(100),
	Fav_artist nvarchar(100),
	Fav_book nvarchar(100),
	Fav_movie nvarchar(100),

	PRIMARY KEY(Hobbie_id),
	FOREIGN KEY(Profile_id) REFERENCES PROFILE(Profile_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE(Profile_id)
);

CREATE TABLE ADDRESS
(
	Address_id int NOT NULL IDENTITY(1,1),
	Profile_id int NOT NULL,
	Address nvarchar(75) NOT NULL,
	City nvarchar(167) NOT NULL,
	Country nvarchar(45) NOT NULL,


	PRIMARY KEY(Address_id),
	FOREIGN KEY(Profile_id) REFERENCES PROFILE(Profile_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE(Profile_id)
);
CREATE TABLE MESSAGE
(
	Message_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	To_user int NOT NULL,
	Message nvarchar(500),
	is_read bit NOT NULL default(0),
	Created_at smalldatetime NOT NULL DEFAULT CAST(GETDATE() as smalldatetime),
	is_spam bit,

	PRIMARY KEY(Message_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(To_user) REFERENCES MEMBER(Member_id),

	CONSTRAINT message_cost check (message.Member_id != message.To_user)
);

CREATE TABLE NOTIFICATION
(
	Notification_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Msg nvarchar(100) NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Notification_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)

);
CREATE TABLE friend
(
	friend_id int NOT NULL identity(1,1),
	member_id int NOT NULL,
	friend_member_id int NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint friend_pk
	primary key(friend_id),
	constraint friend_fk
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	foreign key(friend_member_id) references member(member_id),
	unique(member_id,friend_member_id),

	constraint friend_const check (member_id != friend_member_id)
);

CREATE TABLE RECOMMEND
(
	Member_id int NOT NULL,
	Recommender_id int NOT NULL,
	Being_rec_id int NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Member_id,Recommender_id,Being_rec_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Being_rec_id) REFERENCES MEMBER(Member_id),
	FOREIGN KEY(Recommender_id) REFERENCES MEMBER(Member_id),

	CONSTRAINT Recommend_1 CHECK (Member_id!=Being_rec_id),
	CONSTRAINT Recommend_2 CHECK (Member_id!=Recommender_id),
	CONSTRAINT Recommend_3 CHECK (Being_rec_id != Recommender_id)
);
CREATE TABLE CV
(
	Cv_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Cv_title nvarchar(20) NOT NULL,

	PRIMARY KEY(Cv_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE LANGUAGE_LEVEL
(
	Level_id int NOT NULL IDENTITY(1,1),
	Level_name nvarchar(30) NOT NULL,

	PRIMARY KEY(Level_id)
);

CREATE TABLE LANGUAGE
(
	Language_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	Language nvarchar(30) NOT NULL,
	Level_id int NOT NULL,

	PRIMARY KEY(Language_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Level_id) REFERENCES LANGUAGE_LEVEL(Level_id)
);

CREATE TABLE EDUCATION
(
	Education_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	School_name nvarchar(100),
	Start_date date NOT NULL,
	Ending_date date NOT NULL,

	PRIMARY KEY(Education_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT Date_const CHECK ( Start_date < Ending_date)
);

CREATE TABLE WORK_EXPERIENCE
(
	Work_exp_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	Company_name nvarchar(100) NOT NULL,
	Info_about_work nvarchar(40) NOT NULL,
	Start_date date NOT NULL,
	Leaving_date date,

	PRIMARY KEY(Work_exp_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
	CONSTRAINT Date_work_const CHECK (Start_date < Leaving_date)
);

CREATE TABLE SKILL
(
	Skill_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	Skill nvarchar(40) NOT NULL,

	PRIMARY KEY(Skill_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

delete from MEMBER where Member_id=3

ALTER TABLE member	
ADD CONSTRAINT CHK_password CHECK (len(password)>=8);

ALTER TABLE cv
ADD CONSTRAINT cv_member UNIQUE (member_id);

ALTER TABLE EDUCATION
ADD CONSTRAINT education_cv UNIQUE (cv_id);

Alter Table EDUCATION 
Add department nvarchar(50);

select company_name
from	WORK_EXPERIENCE	
where cv_id=1

select Profile_id,Marital_status
from PROFILE
where sex='male'

select city
from ORGANIZATION
where (name='garanti' or name='akbank')
order by City asc

select city
from ORGANIZATION
where (name='garanti' or name='akbank')
order by City desc

select city
from ORGANIZATION
where (name='garanti' or name='akbank')
group by City 


SELECT Organization_id, Description
FROM JOB_OFFER
where JOB_OFFER.Organization_id>10

SELECT ORGANIZATION.Name, JOB_OFFER.Description
FROM ORGANIZATION
RIGHT JOIN JOB_OFFER ON ORGANIZATION.Organization_id = JOB_OFFER.Organization_id
ORDER BY ORGANIZATION.Organization_id;

SELECT ORGANIZATION.Name, JOB_OFFER.Description
FROM (ORGANIZATION left JOIN JOB_OFFER ON ORGANIZATION.Organization_id = JOB_OFFER.Organization_id)
where (JOB_OFFER.Organization_id=3 or JOB_OFFER.Organization_id=1)
ORDER BY ORGANIZATION.Organization_id;

SELECT fname,lname
FROM MEMBER
WHERE not EXISTS (SELECT cv_title 
				  FROM CV 
				  WHERE MEMBER.Member_id=CV.Member_id AND Cv_title='kariyer');


SELECT fname,lname
FROM MEMBER
WHERE EXISTS (SELECT cv_title 
			  FROM CV 
			  WHERE MEMBER.Member_id=CV.Member_id AND Cv_title='kariyer');

SELECT COUNT(member_id)
FROM MEMBER
where member_id>10

SELECT COUNT(Profile_id)
FROM PROFILE
where Organization_id in (select Organization_id
						  from ORGANIZATION
						  where city='istanbul');

SELECT MEMBER.Email,CV.Cv_id
FROM MEMBER
FULL OUTER JOIN CV ON MEMBER.Member_id=CV.Member_id  


select lname,fname
from MEMBER
where Member_id in (select Member_id
					from CV
					where Cv_title='kariyer' and Cv_id in(select Cv_id
														  from EDUCATION
														  where School_name='ege universitesi'))		

															
select	password
from MEMBER
where Member_id in  (select Member_id
					from PROFILE 
					where  Sex='male' and Profile_id in (select Profile_id
														from ADDRESS
														where Country='turkiye'))
/*
SELECT fname,lname
FROM MEMBER
WHERE not EXISTS ((SELECT cv_title 
				  FROM CV 
				  WHERE MEMBER.Member_id=CV.Member_id AND Cv_title='kariyer')
				  except (select Member_id
						  from CV
						  where MEMBER.Member_id=CV.Member_id and (fname='harun' or lname='gelgel')));*/



select Email
from member
where Member_id in (select  Member_id from job_application where job_application.member_id=MEMBER.Member_id and job_offer_id in 
                (select job_offer_id from JOB_OFFER where Organization_id=1))


INSERT INTO WORK_EXPERIENCE
VALUES (6, 'vestel', 'test engineering', '2013-10-05','2014-12-17');

INSERT INTO MEMBER
VALUES ('emir', 'çiðdem', 'emirçiðdem@hotmail.com', '123456eç','2015-08-01 00:00:00');

INSERT INTO friend
VALUES (17, 10,'2015-08-01 00:00:00');

UPDATE address
SET address = 'bostanlý caddesi', City= 'izmir'
WHERE address_id = 6;


UPDATE HOBBIE
SET Fav_book = 'çocuk kalbi', Fav_movie='iþaretler'
WHERE Hobbie_id = 1;


UPDATE SKILL
SET Skill= 'java'
WHERE Skill_id = 7;



DELETE FROM friend WHERE friend_id=26;

DELETE FROM JOB_OFFER WHERE Job_offer_id=11;

DELETE FROM NOTIFICATION WHERE Notification_id=16;





GO
CREATE TRIGGER trg_assertion_recommend
ON RECOMMEND
FOR INSERT
AS BEGIN
  DECLARE @Mem_id int
  DECLARE @Rec_id int
  DECLARE @Being_id int

  SELECT @Mem_id=Member_id,@Rec_id=Recommender_id,@Being_id=Being_rec_id
  FROM inserted

  IF EXISTS ( SELECT *
			  FROM friend
			  WHERE @Mem_id=friend.member_id AND @Being_id=friend.friend_member_id)
  BEGIN	  
		print 'Önerinin sunuldugu kisiyle önerilen kisi arkadas olmamali'
		rollback transaction
  END
  ELSE IF NOT EXISTS ( SELECT *
				  FROM friend
				  WHERE @Mem_id=friend.member_id AND @Rec_id=friend.friend_member_id)
  BEGIN
	    print 'Önerinin sunuldugu kisiyle öneri yapan arkadas olmali'
		rollback transaction
  END
END;

GO
CREATE TRIGGER trg_assertion_friend
ON friend
FOR INSERT
AS BEGIN
  DECLARE @mem_id int
  DECLARE @fr_mem_id int

  SELECT @mem_id=member_id,@fr_mem_id=friend_member_id
  FROM inserted

  IF EXISTS ( SELECT *
				  FROM friend
				  WHERE @mem_id=friend.friend_member_id AND @fr_mem_id=friend.member_id)
  BEGIN
	    print 'bu kiþiler arkadas'
		rollback transaction
  END
END;

GO
CREATE TRIGGER trg_assertion_Job_Dates
ON job_application
FOR INSERT
AS BEGIN
	DECLARE @offer_date date
	DECLARE @app_date date

	SELECT @offer_date=JOB_OFFER.Offer_date, @app_date=job_application.job_app_date
	FROM JOB_OFFER,inserted,job_application
	WHERE inserted.Job_offer_id=JOB_OFFER.Job_offer_id

	IF(@app_date<@offer_date)
	BEGIN
	 print 'ise basvurma tarihi is ilani tarihinden sonra olmali.'
	 rollback transaction
	END
END;

GO
CREATE TRIGGER TRG_notification_friend
ON friend
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(MEMBER.Fname + ' ' + MEMBER.Lname + ' senin ile arkadas oldu.') 
	FROM inserted,MEMBER
	WHERE inserted.friend_member_id=MEMBER.Member_id

	INSERT INTO NOTIFICATION(Member_id,Msg)
	SELECT friend.Member_id,@Message
	FROM inserted, friend
	WHERE inserted.friend_id=friend.friend_id


END;

GO
CREATE TRIGGER TRG_job_notification
ON job_application
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(MEMBER.Fname + ' ' + MEMBER.Lname + ' bir ise basvuruda bulundun.') 
	FROM inserted,MEMBER
	WHERE inserted.member_id=MEMBER.Member_id 

	INSERT INTO NOTIFICATION(Member_id,Msg)
	SELECT job_application.member_id,@Message
	FROM inserted, job_application
	WHERE inserted.member_id=job_application.member_id

END;

GO
CREATE TRIGGER TRG_member
ON MEMBER
AFTER INSERT
AS BEGIN
	
	INSERT INTO CV(Member_id,Cv_title)
	SELECT MEMBER.member_id,'kariyer'
	FROM inserted, MEMBER
	WHERE inserted.member_id=MEMBER.member_id

END;