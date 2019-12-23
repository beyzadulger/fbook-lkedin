create database linkedface

CREATE TABLE member
(
	member_id int NOT NULL identity (1,1),
	fname nvarchar(20) NOT NULL,
	lname nvarchar(25) NOT NULL,
	email nvarchar(50) NOT NULL,
	password nvarchar(20) NOT NULL,
	created_at smalldatetime NOT NULL default GETDATE(),

	constraint member_pk
	primary key (member_id),
	Unique (email),

	constraint password_const check(len(password) >= 7)
);

CREATE TABLE organization
(
	organization_id int NOT NULL identity(1,1),
	name nvarchar(40) NOT NULL,
	city nvarchar(167) NOT NULL,
	constraint organization_pk
	primary key(organization_id)
);

CREATE TABLE job_offer
(
	job_offer_id int NOT NULL identity(1,1),
	organization_id int NOT NULL,
	offer_date date NOT NULL DEFAULT GETDATE(),
	description nvarchar(500),
	constraint job_offer_pk
	primary key(job_offer_id),
	constraint job_offer_fk
	foreign key(organization_id) references organization(organization_id)
		on update cascade on delete cascade
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

CREATE TABLE privacy
(
	privacy_id int NOT NULL identity(1,1),
	privacy_status nvarchar(25)
	constraint privacy_fk
	primary key (privacy_id)
);

CREATE TABLE profile
(
	profile_id int NOT NULL identity(1,1),
	member_id int NOT NULL,
	num_of_friends int NOT NULL DEFAULT(0),
	birth_date date NOT NULL,
	sex nvarchar(10) NOT NULL check (Sex='Male' OR SEX='Female'),
	marital_status nvarchar(10) NOT NULL check (Marital_status='Single' OR Marital_status='Married'),
	organization_id int,
	phone nvarchar(15),
	privacy int NOT NULL DEFAULT(2),

	constraint profile_pk
	primary key(Profile_id),
	unique(Member_id),
	constraint profile_fk
	foreign key(privacy) references privacy(privacy_id),
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	foreign key(Organization_id) references organization(organization_id)
		on update cascade on delete set null,
	unique(phone)
);
CREATE TABLE hobbie
(
	hobbie_id int NOT NULL IDENTITY(1,1),
	profil_id int NOT NULL,
	Fav_animal nvarchar(100),
	Fav_artist nvarchar(100),
	Fav_book nvarchar(100),
	Fav_movie nvarchar(100),

	constraint hobbie_pk
	primary key(hobbie_id),
	constraint hobbie_fk
	foreign key(profil_id) references profile(profile_id)
		on update cascade on delete cascade
);
CREATE TABLE address
(
	address_id int NOT NULL identity(1,1),
	profil_id int NOT NULL,
	address nvarchar(75) NOT NULL,
	city nvarchar(167) NOT NULL,
	country nvarchar(45) NOT NULL,

	constraint address_pk
	primary key(Address_id),
	unique(Profil_id),
	constraint adress_fk
	foreign key (profil_id) references profile (profile_id)
		on update cascade on delete cascade
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

CREATE TABLE status
(
	status_id int NOT NULL identity(1,1),
	member_id int NOT NULL,
	thumbs_up int NOT NULL DEFAULT(0),
	thumbs_down int NOT NULL DEFAULT(0),
	message nvarchar(255) NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),
	privacy int NOT NULL DEFAULT(2),

	constraint status_pk
	primary key(status_id),
	constraint status_fk
	foreign key(privacy) references privacy(privacy_id),
	foreign key(member_id) references member(member_id)
);

CREATE TABLE thumb_up_down
(
	thumb_id int NOT NULL identity(1,1),
	status_id int NOT NULL,
	member_id int NOT NULL,
	flag bit NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint thumb_up_down_pk
	primary key(thumb_id),
	constraint thumb_up_down_fk
	foreign key(status_id) references status(status_id)
		on update cascade on delete cascade,
	foreign key(member_id) references member(member_id)
		
);

CREATE TABLE comment
(
	comment_id int NOT NULL identity(1,1),
	status_id int NOT NULL,
	member_id int NOT NULL,
	message nvarchar(100),
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint comment_pk
	primary key(comment_id),
	constraint cooment_fk
	foreign key(status_id) references status(status_id),
	foreign key(member_id) references member(member_id)
);

CREATE TABLE follow
(
	member_id int NOT NULL,
	following_id int NOT NULL,
	following_date smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint follow_pk
	primary key(member_id,following_id),
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	foreign key(following_id) references member(member_id),

	constraint following_const check (member_id!=following_id)
);
CREATE TABLE recommend
(
	member_id int NOT NULL,
	recommender_id int NOT NULL,
	being_rec_id int NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint recommend_pk
	primary key(member_id,recommender_id,being_rec_id),
	constraint recommend_fk
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	foreign key(being_rec_id) references member(member_id),
	foreign key(recommender_id) references member(member_id),

	constraint Recommend_1 check (member_id!=being_rec_id),
	constraint Recommend_2 check (member_id!=recommender_id),
	constraint Recommend_3 check (being_rec_id != recommender_id)
);

CREATE TABLE message
(
	Message_id int NOT NULL identity(1,1),
	member_id int NOT NULL,
	to_user int NOT NULL,
	message nvarchar(500),
	is_read bit NOT NULL default(0),
	created_at smalldatetime NOT NULL DEFAULT CAST(GETDATE() as smalldatetime),

	constraint message_pk
	primary key(message_id),
	constraint message_fk
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	foreign key(to_user) references member(member_id),

	constraint message_const check (member_id!=to_user)
);
CREATE TABLE notification
(
	notification_id int NOT NULL identity(1,1),
	member_id int NOT NULL,
	comment_id int DEFAULT(NULL),
	thumb_id int DEFAULT(NULL),
	msg nvarchar(100) NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint notification_pk
	primary key(notification_id),
	constraint notification_fk
	foreign key(member_id) references member(member_id),
	foreign key(comment_id) references comment(comment_id),
	foreign key(thumb_id) references thumb_up_down(thumb_id)
		on update cascade on delete cascade,
);
CREATE TABLE cv
(
	cv_id int NOT NULL identity(1,1),
	member_id int NOT NULL,
	cv_title nvarchar(20) NOT NULL,

	constraint cv_pk
	primary key(cv_id),
	constraint cv_fk
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
);

CREATE TABLE language_level
(
	level_id int NOT NULL identity(1,1),
	level_name nvarchar(30) NOT NULL,

	constraint language_level_pk
	primary key(level_id)
);

CREATE TABLE language
(
	language_id int NOT NULL identity(1,1),
	cv_id int NOT NULL,
	language nvarchar(30) NOT NULL,
	level_id int NOT NULL,

	constraint language_pk
	primary key(language_id),
	constraint language_fk
	foreign key(Cv_id) references cv(cv_id)
		on update cascade on delete cascade,
	foreign key(Level_id) references language_level(level_id)
);

CREATE TABLE education
(
	education_id int NOT NULL identity(1,1),
	cv_id int NOT NULL,
	school_name nvarchar(100),
	department_name nvarchar(100), 
	start_date date NOT NULL,
	ending_date date NOT NULL,

	constraint education_pk
	primary key(education_id),
	unique(cv_id),
	constraint education_fk
	foreign key(cv_id) references cv(cv_id)
		on update cascade on delete cascade,

	constraint  date_const check ( start_date < ending_date)

);

CREATE TABLE work_experience
(
	work_experience_id int NOT NULL identity(1,1),
	cv_id int NOT NULL,
	company_name nvarchar(100) NOT NULL,
	info_about_work nvarchar(40) NOT NULL,
	start_date date NOT NULL,
	leaving_date date,

	constraint work_experience_pk
	primary key(work_experience_id),
	constraint work_experience_fk
	foreign key(cv_id) references cv(cv_id)
		on update cascade on delete cascade,
    
	constraint date_work_const check (start_date < leaving_date)
);

CREATE TABLE skill_level
(
	level_id int NOT NULL identity(1,1),
	level_name nvarchar(10) NOT NULL check (level_name='low' OR level_name='normal' OR level_name='expert'),

	constraint skill_level_pk
	primary key(level_id),
);

CREATE TABLE skill
(
	skill_id int NOT NULL IDENTITY(1,1),
	cv_id int NOT NULL,
	skill nvarchar(40) NOT NULL,
	level_id int NOT NULL,

	constraint skill_pk
	primary key(skill_id),
	foreign key(cv_id) references cv(cv_id)
		on update cascade on delete cascade,
	foreign key(level_id)references skill_level(level_id),
);
CREATE TABLE bookmark_category
(
	bookmark_category_id int NOT NULL IDENTITY(1,1),
	name nvarchar(30),

	constraint bookmark_category_pk
	primary key(bookmark_category_id),
	unique(name)
);

CREATE TABLE bookmark
(
	bookmark_id int NOT NULL identity(1,1),
	bookmark_category_id int NOT NULL,
	title nvarchar(100) NOT NULL,
	definition nvarchar(100) NOT NULL,
	creater_id int NOT NULL,
	rating int NOT NULL DEFAULT(0),

	constraint bookmark_pk
	primary key(bookmark_id),
	constraint bookmark_fk
	foreign key(bookmark_category_id) references  bookmark_category(bookmark_category_id)
		on update cascade on delete cascade,
	foreign key(creater_id) references member(member_id)
);

CREATE TABLE bookmark_info
(
	bookmark_info_id int NOT NULL identity(1,1),
	bookmark_id int NOT NULL,
	member_id int NOT NULL,
	favorite bit NOT NULL DEFAULT(0),

	constraint bookmark_info_pk
	primary key(bookmark_info_id),
	foreign key(bookmark_id) references bookmark(bookmark_id)
		on update cascade on delete cascade,
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	
	unique(bookmark_id, member_id)
);
CREATE TABLE feed_category
(
	feed_category_id int NOT NULL identity(1,1),
	name nvarchar(30)NOT NULL,

	constraint feed_category_pk
	primary key(feed_category_id),
	unique(name)
);
CREATE TABLE feed_sub_category
(
	feed_sub_category_id int NOT NULL identity(1,1),
	feed_category_id int NOT NULL,
	name nvarchar(30) NOT NULL,

	constraint feed_sub_category_pk
	primary key(feed_sub_category_id),
	constraint feed_sub_category_fk
	foreign key (feed_category_id) references feed_category(feed_category_id),
	
);

CREATE TABLE feed
(
	feed_id int NOT NULL IDENTITY(1,1),
	Feed_category_id int NOT NULL,
	feed_sub_category_id int NOT NULL,
	creater_id int NOT NULL,
	
	constraint feed_pk
	primary key(feed_id),
	constraint feed_fk
	foreign key(feed_category_id) references feed_category(feed_category_id),
	foreign key(feed_sub_category_id) references feed_sub_category(feed_sub_category_id)
		on update cascade on delete cascade,
	foreign key(creater_id) references member(member_id),
);

CREATE TABLE feed_info
(
	feed_info_id int NOT NULL identity(1,1),
	feed_id int NOT NULL,
	member_id int NOT NULL,

	constraint feed_info_pk
	primary key(feed_info_id),
	constraint feed_info_fk
	foreign key(feed_id) references feed(feed_id)
		on update cascade on delete cascade,
	foreign key(member_id) references member(member_id)
		on update cascade on delete cascade,
	unique(feed_id,member_id)
);

ALTER TABLE cv
ADD CONSTRAINT cv_member UNIQUE (member_id);

ALTER TABLE education
ADD CONSTRAINT education_cv UNIQUE (cv_id);

alter table profile
add constraint phone_constraint check(len (phone)=11);

INSERT INTO member 
VALUES ('gencehan', 'adýgüzel', 'gencehanadýguzel@hotmail.com','123456ga' , '2018-10-04');

INSERT INTO cv 
VALUES (39,'cv');

INSERT INTO friend 
VALUES (34, 39, '2018-11-01')


UPDATE organization
SET city='ankara'
WHERE organization_id=1;

UPDATE profile
SET marital_status='single'
WHERE profile_id=5;

UPDATE skill
SET level_id=3
WHERE skill_id=1;

DELETE FROM friend WHERE friend_id=18;


DELETE FROM friend WHERE friend_id=17;

DELETE FROM organization WHERE organization_id=2;

DELETE FROM hobbie WHERE Fav_animal='kuþ';

select lname,fname
from member
where member_id in (select member_id
					from job_application
					where job_offer_id=1)
					

select description
from job_offer
where organization_id >5

select name
from organization
where city='ankara'

select friend_member_id
from friend
where member_id=37
order by friend_member_id desc

select fname,lname
from member 
where member_id in (select friend_member_id from friend where member_id=37)

select fname,lname
from member
where member_id in (select thumb_up_down.member_id from thumb_up_down where flag=1 and status_id=1)

select sex
from profile
where not exists ( select city from address where city='ankara' and profile.profile_id=address.profil_id)

select company_name
from work_experience
where cv_id in (select cv_id from cv where cv_id>1)
group by company_name

select comment.member_id , notification.msg
from notification,comment
where notification.member_id=34 and notification.comment_id=comment.comment_id 
union 
(select thumb_up_down.member_id , notification.msg 
from notification,thumb_up_down 
where notification.member_id=34 and notification.thumb_id=thumb_up_down.thumb_id)

select skill_level.level_name , skill.skill
from skill, skill_level
where cv_id in (select cv_id from cv where cv_id>1 and cv.cv_id=skill.cv_id and skill.level_id=skill_level.level_id)


GO
CREATE TRIGGER TRG_Delete_Friend
ON friend
FOR DELETE
AS BEGIN
	DELETE FROM friend 
	FROM friend,deleted
	WHERE friend.member_id=deleted.friend_member_id AND friend.friend_member_id=deleted.member_id

	UPDATE profile SET profile.num_of_friends = profile.num_of_friends - 1
		           FROM profile,deleted 
				   WHERE profile.member_id = deleted.member_id
	UPDATE profile SET profile.num_of_friends = profile.num_of_friends - 1 
				   FROM profile,deleted WHERE profile.member_id = deleted.friend_member_id
END;

GO
CREATE TRIGGER TRG_insert_Friend
ON friend
AFTER INSERT
AS BEGIN
	UPDATE profile SET profile.num_of_friends =  profile.num_of_friends + 1 
				   FROM profile,inserted 
				   WHERE profile.member_id = inserted.member_id
	UPDATE profile SET profile.num_of_friends =  profile.num_of_friends + 1 
				   FROM profile,inserted WHERE profile.member_id = inserted.friend_member_id

	
END;

insert into friend 
VALUES (38,39,'2018-12-27');
DELETE FROM friend WHERE friend.friend_id=11;

GO
CREATE TRIGGER trg_assertion_friend
ON friend
FOR INSERT
AS BEGIN
  DECLARE @us_id int
  DECLARE @fr_us int

  SELECT @us_id=member_id,@fr_us=friend_member_id
  FROM inserted

  IF EXISTS ( SELECT *
				  FROM friend
				  WHERE @us_id=friend.friend_member_id AND @fr_us=friend.member_id)
  BEGIN
	    print 'bu kiþiler arkadas'
		rollback transaction
  END
END;

GO
CREATE TRIGGER trg_assertion_follow
ON follow
FOR INSERT
AS BEGIN
  DECLARE @mem_id int
  DECLARE @fol_id int

  SELECT @mem_id=member_id,@fol_id=following_id
  FROM inserted

  IF EXISTS ( SELECT *
				  FROM follow
				  WHERE @mem_id=follow.following_id AND @fol_id=follow.member_id)
  BEGIN
	    print 'bu kiþiler takiplesiyor.'
		rollback transaction
  END
END;

GO
CREATE TRIGGER TRG_Thumb
ON thumb_up_down
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(member.fname + ' ' + member.lname) 
	FROM inserted,member
	WHERE inserted.member_id = member.member_id

	IF(SELECT flag FROM inserted)=1
	BEGIN
		SELECT @Message = (@Message + ' ' + 'senin paylasimini begendi.')

		UPDATE status SET status.thumbs_up=status.thumbs_up+1
		FROM status,inserted WHERE status.status_id IN(inserted.status_id)
	END
	ELSE
	BEGIN
		SELECT @Message = (@Message + ' ' + 'senin paylasimini begenmedi.')

		UPDATE status SET status.thumbs_down=status.thumbs_down+1
		FROM status,inserted WHERE status.status_id IN(inserted.status_id)
	END
		
	INSERT INTO notification(member_id,comment_id,thumb_id,msg)
	SELECT status.Member_id,NULL,inserted.Thumb_id,@Message
	FROM inserted,STATUS
	WHERE STATUS.Status_id=inserted.Status_id
	
END;
GO
CREATE TRIGGER TRG_comment
ON comment
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(member.fname + ' ' + member.lname + ' senin paylasimina yorum yapti.') 
	FROM inserted,member
	WHERE inserted.member_id=member.member_id

	INSERT INTO notification(member_id,comment_id,thumb_id,msg)
	SELECT status.member_id,inserted.comment_id,NULL,@Message
	FROM inserted, status
	WHERE inserted.status_id=status.status_id

END;


GO
CREATE TRIGGER TRG_feed_info
ON feed
AFTER INSERT
AS BEGIN
	INSERT INTO feed_info(feed_id,member_id)
	SELECT feed_id,friend.friend_member_id
	FROM inserted,friend
	WHERE inserted.creater_id = friend.member_id
	
	INSERT INTO feed_info(feed_id,member_id)
	SELECT feed_id, follow.following_id
	FROM inserted,follow
	WHERE inserted.creater_id = follow.member_id
END;

GO
CREATE TRIGGER TRG_Status_feed
ON status
AFTER INSERT
AS BEGIN
	INSERT INTO feed(Feed_category_id,feed_sub_category_id,creater_id)
	SELECT 3,2,member.member_id
	FROM inserted,member
	WHERE inserted.member_id = member.member_id
END;

GO 
CREATE TRIGGER TRG_bookmark
ON bookmark
AFTER INSERT
AS BEGIN
	INSERT INTO bookmark_info(bookmark_id,member_id,favorite)
	SELECT inserted.bookmark_id,inserted.creater_id,1
	FROM inserted
END;


GO
CREATE TRIGGER Assertion_check_friendship
ON recommend
FOR INSERT
AS BEGIN
  DECLARE @me_id int
  DECLARE @rec_id int
  DECLARE @being_id int

  SELECT @me_id=member_id,@rec_id=recommender_id,@being_id=being_rec_id
  FROM inserted

  IF EXISTS ( SELECT *
			  FROM friend
			  WHERE @me_id=friend.member_id AND @being_id=friend.friend_member_id)
  BEGIN	  
		print 'Önerinin sunuldugu kisiyle önerilen kisi arkadas olmamali..!'
		rollback transaction
  END
  ELSE IF NOT EXISTS ( SELECT *
				  FROM friend
				  WHERE @me_id=friend.member_id AND @rec_id=friend.friend_member_id)
  BEGIN
	    print 'Önerinin sunuldugu kisiyle öneri yapan arkadas olmali..!'
		rollback transaction
  END
END;


