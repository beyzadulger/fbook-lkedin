create database facebook

CREATE TABLE users
(
	user_id int NOT NULL IDENTITY (1,1),
	fname nvarchar (20) NOT NULL ,
	lname nvarchar (25) NOT NULL ,
	email nvarchar (50) NOT NULL ,
	pword nvarchar (20) NOT NULL check (len(pword)>=7),
	created_at smalldatetime NOT NULL default getdate(),
	constraint users_pk
		primary key (user_id),
		unique (email),
	constraint pword_const check (len(pword)>=7)
	 
);

CREATE TABLE profile
(
	profil_id int NOT NULL IDENTITY(1,1),
	user_id int NOT NULL,
	num_of_friends int NOT NULL DEFAULT(0),
	birth_date date NOT NULL,
	sex nvarchar(10) NOT NULL check (sex='male' OR sex='female'),
	marital_status nvarchar(10) NOT NULL check (marital_status='single' OR marital_status='married'),
	phone nvarchar(15),

	constraint profil_pk
	primary key (profil_id),
	unique(user_id),

	constraint profil_fk
	foreign key(user_id) references users(user_id)
		on update cascade on delete cascade,
	
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
	foreign key (profil_id) references profile (profil_id)
		on update cascade on delete cascade
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
	foreign key(profil_id) references profile(profil_id)
		on update cascade on delete cascade
);

CREATE TABLE friend
(
	friend_id int NOT NULL IDENTITY(1,1),
	user_id int NOT NULL,
	friend_user_id int NOT NULL,
	created_at smalldatetime NOT NULL default getdate(),

	constraint friend_pk
	primary key(friend_id),
	constraint friend_fk
	foreign key(user_id) references users(user_id)
		on update cascade on delete cascade,
	foreign key(friend_user_id) references users(user_id),
	UNIQUE(user_id,friend_user_id),

	CONSTRAINT friend_const CHECK (user_id != friend_user_id)
);
CREATE TABLE status
(
	status_id int NOT NULL IDENTITY(1,1),
	user_id int NOT NULL,
	thumbs_up int NOT NULL DEFAULT(0),
	thumbs_down int NOT NULL DEFAULT(0),
	message nvarchar(300) NOT NULL,
	created_at smalldatetime NOT NULL default getdate(),

	constraint status_pk
	primary key(status_id),
	constraint status_fk
	foreign key(user_id) references users(user_id)
);
CREATE TABLE thumb_up_dawn
(
	thumb_id int NOT NULL IDENTITY(1,1),
	user_id int not null,
	status_id int NOT NULL,
	created_at smalldatetime NOT NULL default getdate(),

	constraint thumb_up_dawn_pk
	primary key(thumb_id),
	constraint thumb_up_dawn_fk
	foreign key(status_id) references status(status_id)
		on update cascade on delete cascade,
	foreign key (user_id) references users(user_id)
		
);
CREATE TABLE comment
(
	comment_id int NOT NULL IDENTITY(1,1),
	status_id int NOT NULL,
	user_id int NOT NULL,
	message nvarchar(100),
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint comment_pk
	PRIMARY KEY(comment_id),
	constraint comment_fk
	foreign key(status_id) references status(status_id),
	foreign key(user_id) references users(user_id)
);

CREATE TABLE follow
(
	user_id int NOT NULL,
	following_id int NOT NULL ,
	following_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint follow_pk
	primary key(following_id,user_id),
	foreign key (user_id) references users(user_id)
		on update cascade on delete cascade,
	foreign key(following_id) references users(user_id),

	constraint following_const check (user_id!=following_id)
);
CREATE TABLE recommend
(
	user_id int NOT NULL,
	recommender_id int NOT NULL,
	being_rec_id int NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	constraint recommend_pk
	primary key(user_id,recommender_id,being_rec_id),
	foreign key(user_id) references users(user_id)
		on update cascade on delete cascade,
	foreign key(being_rec_id) references users(user_id),
	foreign key(recommender_id) references users(user_id),

	constraint recommend1 check (user_id!=being_rec_id),
	constraint recommend2 check (user_id!=recommender_id),
	constraint recommend3 check (being_rec_id != recommender_id)
);

CREATE TABLE message
(
	message_id int NOT NULL IDENTITY(1,1),
	user_id int NOT NULL,
	to_users int NOT NULL,
	message nvarchar(500),
	is_read bit NOT NULL default(0),
	created_at smalldatetime NOT NULL default cast(getdate() as smalldatetime),

	constraint message_pk
	primary key(message_id),
	foreign key (user_id) references users(user_id)
		on update cascade on delete cascade,
	foreign key(to_users) references users(user_id),

	constraint message_const check (message.user_id!=message.to_users)
);

CREATE TABLE notification
(
	notification_id int NOT NULL IDENTITY(1,1),
	user_id int NOT NULL,
	comment_id int DEFAULT(NULL),
	thumb_id int DEFAULT(NULL),
	msg nvarchar(100) NOT NULL,
	created_at smalldatetime NOT NULL DEFAULT GETDATE(),
	
	constraint notification_pk
	primary key(notification_id),
	constraint notification_fk
	foreign key(user_id) references users(user_id),
	foreign key(comment_id) REFERENCES comment(comment_id),
	foreign key(thumb_id) REFERENCES thumb_up_dawn(thumb_id)
		on update cascade on delete cascade,
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
	bookmark_id int NOT NULL IDENTITY(1,1),
	bookmark_category_id int NOT NULL,
	title nvarchar(100) NOT NULL,
	definition nvarchar(100) NOT NULL,
	creater_id int NOT NULL,
	rating int NOT NULL DEFAULT(0),

	constraint bookmark_pk
	primary key(bookmark_id),
	foreign key(bookmark_category_id) references bookmark_category(bookmark_category_id)
		on update cascade on delete cascade,
	foreign key(creater_id) references users(user_id),
	
);

CREATE TABLE bookmark_info
(
	bookmark_info_id int NOT NULL IDENTITY(1,1),
	bookmark_id int NOT NULL,
	user_id int NOT NULL,
	favorite bit NOT NULL DEFAULT(0),

	constraint bookmark_info_pk
	primary key(bookmark_info_id),
	constraint bookmark_info_fk
	foreign key(bookmark_id) references bookmark(bookmark_id),
	foreign key(user_id) references users(user_id)
		on update cascade on delete cascade,
	UNIQUE(bookmark_id, user_id)
);
CREATE TABLE feed_sub_category
(
	feed_sub_category_id int NOT NULL IDENTITY(1,1),
	name nvarchar(30),

	primary key(feed_sub_category_id),
	unique(name)
);
CREATE TABLE feed_category
(
	feed_category_id int NOT NULL IDENTITY(1,1),
	name nvarchar(30),

	primary key(feed_category_id),
	unique(name)
);

CREATE TABLE feed
(
	feed_id int NOT NULL IDENTITY(1,1),
	feed_category_id int NOT NULL,
	feed_sub_category_id int NOT NULL,
	creater_id int not null
	constraint feed_pk
	primary key(feed_id),
	constraint feed_fk
	foreign key(feed_category_id) references feed_category(feed_category_id)
		on update cascade on delete cascade,
	foreign key(feed_sub_category_id) references feed_sub_category(feed_sub_category_id)
		on update cascade on delete cascade,
	foreign key(creater_id) references users(user_id),
);

CREATE TABLE feed_info
(
	feed_info_id int NOT NULL IDENTITY(1,1),
	feed_id int NOT NULL,
	user_id int NOT NULL,

	constraint feed_info_pk
	primary key(feed_info_id),
	constraint feed_info_fk
	foreign key(feed_id) references feed(feed_id)
		on update cascade on delete cascade,
	foreign key(user_id) references users(user_id)
		on update cascade on delete cascade,
	UNIQUE(feed_id,user_id)
);



alter table thumb_up_dawn
add flag bit NOT NULL default (0)

alter table profile
add constraint phone_constraint check (len(phone)=11);

ALTER TABLE users
ADD CONSTRAINT password_constraint CHECK (len(pword)>=8);

ALTER TABLE bookmark
ADD CONSTRAINT rating_constraint CHECK (rating<=10);

ALTER TABLE bookmark_info
ADD CONSTRAINT bookmark_user UNIQUE (user_id);

select profil_id,phone
from profile
where sex='male'

select profil_id,user_id
from profile	
where num_of_friends>25

select status,thumbs_down
from status	
where thumbs_up=4

select status
from status
where  user_id in  (select user_id 
					from profile
					where sex='male'  and status.user_id=profile.user_id)

select status
from status,profile
where  sex='male'  and status.user_id=profile.user_id

select message 
from comment
where user_id in (select user_id from friend where friend_user_id > 4 and comment.user_id = friend.user_id)
order by message asc

select num_of_friends
from profile
where profil_id in (select profil_id from address where country='turkiye' and sex='male')
order by num_of_friends desc

SELECT profil_id,lname,fname
FROM profile
right JOIN users ON users.user_id=profile.user_id
ORDER BY profil_id;

SELECT profil_id,lname,fname
FROM profile
left JOIN users ON users.user_id=profile.user_id
ORDER BY profil_id;

select pword 
from users
where user_id in (select user_id from profile where sex='male' and profil_id in
 (select profil_id from address where country='turkiye'))

select recommender_id
from recommend
where user_id in (select user_id from users where users.user_id=recommend.user_id and  user_id in
(select user_id from profile where marital_status='single' and profile.user_id=users.user_id))

select fname,lname
from users
where user_id in (select user_id from recommend where users.user_id=recommend.user_id and recommend.recommender_id < 4
and user_id in (select user_id from profile where marital_status='single') )

select lname,fname
from users
where user_id in (select friend_user_id from friend where user_id=2 or user_id=3)

select comment_id,thumb_id
from notification
where user_id =7

select count(*) message
from comment
where status_id=8

INSERT INTO friend
VALUES (2 , 16 , '2014-09-10 20:50');

INSERT INTO users
VALUES ('gence' , 'adýguzel' , 'genceadýguzel@hotmail.com', '12345ga', '2018-09-10 20:50');

INSERT INTO profile
VALUES (1012 , 20 , '1991-06-10' , 'male', 'single', '05414180204');



DELETE FROM friend WHERE friend_id=1020;
DELETE FROM friend WHERE friend_id=27;
DELETE FROM friend WHERE friend_id=1025;
DELETE FROM friend WHERE friend_id=23;
DELETE FROM friend WHERE friend_id=1016;

UPDATE address
SET address = 'kazýmpasa caddesi', City= 'malatya'
WHERE address_id = 1;

UPDATE status
SET status = 'huzur'
WHERE status_id = 6;

UPDATE profile
SET phone = '05368569622'
WHERE profil_id = 1;

INSERT INTO users
VALUES ('mehmet', 'akif', 'mehmetakif@hotmail.com','12345ma','2017-09-10 20:50' );

INSERT INTO profile
VALUES ('16', '18', '1996-06-10','male','single','05336728716');
	
GO
CREATE TRIGGER TRG_Delete_Friend
ON friend
FOR DELETE
AS BEGIN
	DELETE FROM friend 
	FROM friend,deleted
	WHERE friend.user_id=deleted.friend_user_id AND friend.friend_user_id=deleted.user_id

	UPDATE profile SET profile.num_of_friends = profile.num_of_friends - 1
		           FROM profile,deleted WHERE profile.user_id = deleted.user_id
	UPDATE profile SET profile.num_of_friends = profile.num_of_friends - 1 
				   FROM profile,deleted WHERE profile.user_id = deleted.friend_user_id
END;

GO
CREATE TRIGGER TRG_insert_Friend
ON friend
AFTER INSERT
AS BEGIN
	UPDATE profile SET profile.num_of_friends =  profile.num_of_friends + 1 
				   FROM profile,inserted 
				   WHERE profile.user_id = inserted.user_id
	UPDATE profile SET profile.num_of_friends =  profile.num_of_friends + 1 
				   FROM profile,inserted WHERE profile.user_id = inserted.friend_user_id

	
END;

 GO
CREATE TRIGGER trg_assertion_follow
ON follow
FOR INSERT
AS BEGIN
  DECLARE @us_id int
  DECLARE @fo_id int

  SELECT @us_id=user_id,@fo_id=following_id
  FROM inserted

  IF EXISTS ( SELECT *
				  FROM follow
				  WHERE @us_id=follow.following_id AND @fo_id=follow.user_id)
  BEGIN
	    print 'bu kiþiler zaten takipleþiyor'
		rollback transaction
  END
END;
 
GO
CREATE TRIGGER TRG_ASSERTÝON_FRÝEND
ON friend
FOR INSERT
AS BEGIN
  DECLARE @us_id int
  DECLARE @fr_us int

  SELECT @us_id=user_id,@fr_us=friend_user_id
  FROM inserted

  IF EXISTS ( SELECT *
				  FROM friend
				  WHERE @us_id=friend.friend_user_id AND @fr_us=friend.user_id)
  BEGIN
	    print 'bu kiþiler arkadas'
		rollback transaction
  END
END;


GO
CREATE TRIGGER Assertion_Check_Friendship
ON recommend
FOR INSERT
AS BEGIN
  DECLARE @us_id int
  DECLARE @Rec_id int
  DECLARE @Being_id int

  SELECT @us_id=user_id,@Rec_id=Recommender_id,@Being_id=Being_rec_id
  FROM inserted

  IF EXISTS ( SELECT *
			  FROM friend
			  WHERE @us_id=friend.user_id AND @Being_id=friend.friend_user_id)
  BEGIN	  
		print 'Önerinin sunuldugu kisiyle önerilen kisi arkadas olmamali..!'
		rollback transaction
  END
  ELSE IF NOT EXISTS ( SELECT *
				  FROM friend
				  WHERE @us_id=friend.user_id AND @Rec_id=friend.friend_user_id)
  BEGIN
	    print 'Önerinin sunuldugu kisiyle öneri yapan arkadas olmali..!'
		rollback transaction
  END
END;

GO
CREATE TRIGGER TRG_comment
ON comment
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(users.fname + ' ' + users.lname + ' senin paylasimina yorum yapti.') 
	FROM inserted,users
	WHERE inserted.user_id=users.user_id

	INSERT INTO notification(user_id,comment_id,thumb_id,msg)
	SELECT status.user_id,inserted.comment_id,NULL,@Message
	FROM inserted, status
	WHERE inserted.status_id=status.status_id

END;

GO
CREATE TRIGGER TRG_Inc_Rating
ON bookmark_info
AFTER INSERT
AS BEGIN
	IF(SELECT favorite FROM inserted)=1
	begin
	UPDATE bookmark SET bookmark.rating = BOOKMARK.Rating + 1 
				    FROM bookmark,inserted WHERE bookmark.bookmark_id IN (inserted.bookmark_id)
	end

END;

GO
CREATE TRIGGER TRG_Thumb
ON thumb_up_dawn
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(users.fname + ' ' + users.lname) 
	FROM inserted,users
	WHERE inserted.user_id = users.user_id

	IF(SELECT Flag FROM inserted)=1
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
		
	INSERT INTO notification(user_id,comment_id,thumb_id,msg)
	SELECT status.user_id,NULL,inserted.thumb_id,@Message
	FROM inserted,status
	WHERE status.status_id=inserted.status_id
	
END;

select users.user_id,num_of_friends
from users,profile
where profile.user_id=users.user_id
order by num_of_friends desc


select friend.user_id,count(*) friend_user_id
from friend 
group by user_id

 





