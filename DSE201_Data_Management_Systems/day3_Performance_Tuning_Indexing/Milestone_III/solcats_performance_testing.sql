SET search_path TO cats;


-- CREATE INDEX login_user_id_index ON cats.login(user_id);
CREATE INDEX friend_user_id_index ON cats.friend(user_id);

CREATE INDEX watch_user_id_index ON cats.watch(user_id);
-- CREATE INDEX watch_video_id_index ON cats.watch(video_id);

CREATE INDEX likes_user_id_index ON cats.likes(user_id);
CREATE INDEX likes_video_id_index ON cats.likes(video_id);

/*****************
 ** Overall likes
*****************/
-- We need to make sure that if fewer than 10 videos were liked overall, 
-- we still suggest 10 (if there are at least 10 videos in the db).
-- This means that all videos must be visible, including those not liked.
-- We achieve this by explicitly stating that they were liked 0 times in the
-- following view:

CREATE VIEW cats.init (uid, vid, verdict) AS
  select    u.user_id as uid, v.video_id as vid, 0 as verdict
  from	    cats.user u, cats.video v;


CREATE VIEW cats.overallLikes (uid, vid, verdict) AS
  select    u.user_id as uid, l.video_id as vid, 1 as verdict
  from      cats.user u, cats.likes l
  where	    l.user_id != u.user_id

  union all

  select    * from cats.init;


-- simplest: suggestion without checking whether this video was already watched by X, or liked by X

-- note we are creating a parameterized query:

PREPARE   Overall_simplest (int) AS

select    vid, sum (verdict) as rank
from      overallLikes
where     uid = $1
group by  vid 
order by  rank desc
limit     10;


--To invoke this parameterized query for user X, 
--call EXECUTE Overall_simplest (X);
--e.g. EXECUTE Overall_simplest (13);


--better: suggest only unwatched videos (whether liked by X or not)

PREPARE  Overall_better (int) AS

select   vid, sum (verdict) as rank
from     overallLikes o
where    o.uid = $1 and 
	 not exists (select 1 from watch w where w.user_id = o.uid and w.video_id = o.vid)
group by vid
order by rank desc
limit    10;

--EXECUTE Overall_better (13);



--best: suggest only unwatched and unliked videos
DISCARD ALL;
-- CREATE INDEX login_user_id_index ON cats.login(user_id);
-- CREATE INDEX friend_user_id_index ON cats.friend(user_id);
CREATE INDEX watch_user_id_index ON cats.watch(user_id); -- didn't improve, but was incorporated
CREATE INDEX watch_video_id_index ON cats.watch(video_id); -- didn't improve, was not incorportated
CREATE INDEX likes_user_id_index ON cats.likes(user_id); -- didn't improve, but was incorporated
CREATE INDEX likes_video_id_index ON cats.likes(video_id); -- didn't improve, was not incorportated
EXPLAIN ANALYZE
select   vid, sum (verdict) as rank
from     cats.overallLikes o
where    o.uid = 13 and 
	 not exists (select 1 from cats.watch w where w.user_id = o.uid and w.video_id = o.vid) and -- this is why it uses watch_user index
	 not exists (select 1 from cats.likes l where l.user_id = o.uid and l.video_id = o.vid)  -- this is why is uses likes_userid index
group by vid
order by rank desc
limit    10;

EXECUTE Overall_best (13);

DISCARD ALL
/*******************
 **Friend likes
*******************/

CREATE VIEW cats.friendLikes (uid, vid, verdict) AS
  select    u.user_id as uid, l.video_id as vid, 1 as verdict
  from      cats.user u, cats.friend f, cats.likes l
  where	    f.user_id = u.user_id and f.friend_id != u.user_id and -- don't think of X as his own friend
	    l.user_id = f.friend_id
            
  union all

  select    * from cats.init;



-- PREPARE  friend_likes (int) AS
DISCARD ALL;
-- CREATE INDEX login_user_id_index ON cats.login(user_id);
CREATE INDEX friend_user_id_index ON cats.friend(user_id); -- didn't improve, but was incorporated
CREATE INDEX watch_user_id_index ON cats.watch(user_id); -- didn't improve, but was incorporated
CREATE INDEX watch_video_id_index ON cats.watch(video_id); -- didn't improve, not incorporated
CREATE INDEX likes_user_id_index ON cats.likes(user_id); -- didn't improve, but incorporated
CREATE INDEX likes_video_id_index ON cats.likes(video_id); -- didn't improve, not incorporated
EXPLAIN ANALYZE
select   vid, sum (verdict) as rank
from     cats.friendLikes o
where    o.uid = 13 and 
	 not exists (select 1 from cats.watch w where w.user_id = o.uid and w.video_id = o.vid) and
	 not exists (select 1 from cats.likes l where l.user_id = o.uid and l.video_id = o.vid) 
group by vid
order by rank desc
limit    10;

EXECUTE friend_likes (13);

-- same query as Overall_best before, substitute overallLikes with friendLikes


/***************************
** Friends of friends likes
****************************/
-- find below only proper friends of friends pairs
-- (do not include direct friends,
-- these are accounted for in friendLikes and we do not want to count
-- their likes repeatedly)

CREATE VIEW cats.fof (user_id, fof_id) AS
  select distinct u.user_id, fof.friend_id as fof_id
  from   cats.user u, cats.friend f, cats.friend fof
  where	 f.user_id = u.user_id and f.friend_id != u.user_id and f.friend_id = fof.user_id and fof.friend_id != u.user_id and 
	 not exists (select 1 from cats.friend g where g.user_id = u.user_id and g.friend_id = fof.friend_id);

  
CREATE VIEW cats.fofLikes (uid, vid, verdict) AS

  select    u.user_id as uid, l.video_id as vid, 1 as verdict
  from      cats.user u, cats.fof f, cats.likes l
  where	    f.user_id = u.user_id and 
  	    l.user_id = f.fof_id

  union all

  select * from cats.friendLikes

  union all

  select * from cats.init;

-- same query as overall likes, replacing overallLikes with fofLikes

DISCARD ALL;
-- CREATE INDEX login_user_id_index ON cats.login(user_id);
CREATE INDEX friend_user_id_index ON cats.friend(user_id); -- didn't improve, is included
CREATE INDEX watch_user_id_index ON cats.watch(user_id); -- didn't improve, is included
CREATE INDEX watch_video_id_index ON cats.watch(video_id); -- didn't improve, not included
CREATE INDEX likes_user_id_index ON cats.likes(user_id); -- didn't improve, is included
CREATE INDEX likes_video_id_index ON cats.likes(video_id); -- didn't improve, not included
EXPLAIN ANALYZE
select   vid, sum (verdict) as rank
from     cats.fofLikes o
where    o.uid = 13 and 
	 not exists (select 1 from cats.watch w where w.user_id = o.uid and w.video_id = o.vid) and
	 not exists (select 1 from cats.likes l where l.user_id = o.uid and l.video_id = o.vid) 
group by vid
order by rank desc
limit    10;

EXECUTE fof_likes (13);

/*******************
** MY kind of cats
********************/

CREATE VIEW cats.mykindOfUser (user_id, other_id) AS
  select distinct ul.user_id, ol.user_id as other_id
  from   cats.likes ul, cats.likes ol
  where  ul.user_id != ol.user_id and
  	 ul.video_id = ol.video_id;

CREATE VIEW cats.mykindLikes (uid, vid, verdict) AS
  select    u.user_id as uid, l.video_id as vid, 1 as verdict
  from      cats.user u, cats.mykindOfUser m, cats.likes l
  where	    m.user_id = u.user_id and
  	    l.user_id = m.other_id

  union all

  select   * from cats.init;

--same query, replace overallLikes with mykindLikes

-- PREPARE  mykind_likes (int) AS
DISCARD ALL;
-- CREATE INDEX login_user_id_index ON cats.login(user_id);
-- CREATE INDEX friend_user_id_index ON cats.friend(user_id);
CREATE INDEX watch_user_id_index ON cats.watch(user_id); -- didn't improve, is incorporated
CREATE INDEX watch_video_id_index ON cats.watch(video_id); -- didn't improve, not incorporated
CREATE INDEX likes_user_id_index ON cats.likes(user_id); -- improved, is incorporated
CREATE INDEX likes_video_id_index ON cats.likes(video_id); -- improbed, is incorporated
EXPLAIN ANALYZE
select   vid, sum (verdict) as rank
from     cats.mykindLikes o
where    o.uid = 13 and 
	 not exists (select 1 from cats.watch w where w.user_id = o.uid and w.video_id = o.vid) and
	 not exists (select 1 from cats.likes l where l.user_id = o.uid and l.video_id = o.vid) 
group by vid
order by rank desc
limit    10;

EXECUTE mykind_likes (13);



/*********************
**weighted
**********************/

CREATE VIEW cats.commonLikes (x,y,likeSame) AS
   select  l1.user_id as x, l2.user_id as y, 1 as likeSame
   from	   cats.likes l1, cats.likes l2
   where   l1.video_id = l2.video_id and 
   	   l1.user_id != l2.user_id

   union all

   select  u1.user_id as x, u2.user_id as y, 0 as likeSame
   from	   cats.user u1, cats.user u2
   where   u1.user_id != u2.user_id;



CREATE VIEW cats.inner_product (x,y,prod) AS
-- x, y:  users
-- prod: the inner product of vectors v_x and v_y

   select   x, y, sum (likeSame) as prod
   from     cats.commonLikes
   group by x, y;


-- Conceptually, log is not really needed, it is a monotonic function so the ranking will be
-- unperturbed if we rank by argument of log. But note that in that case
-- we will need to multiply log args, since 
-- log a1 + log a2 + ... log an = log (a1 x a2 x ... x an).
-- 
-- An important practical reason to use log is to avoid overflow as we
-- multiply numerous arguments.


CREATE VIEW cats.weightedMykindLikes (uid, vid, verdict) AS 
select  u.user_id as uid, l.video_id as vid, log(1+i.prod) as verdict
from	cats.user u, cats.inner_product i, cats.likes l
where   u.user_id = i.x and 
	l.user_id = i.y;


--same query, replacing overallLikes with weightedMykindLikes

PREPARE  weightedmykind_likes (int) AS
select   vid, sum (verdict) as rank
from     cats.weightedMykindLikes o
where    o.uid = $1 and 
	 not exists (select 1 from cats.watch w where w.user_id = o.uid and w.video_id = o.vid) and
	 not exists (select 1 from cats.likes l where l.user_id = o.uid and l.video_id = o.vid) 
group by vid
order by rank desc
limit    10;

EXECUTE weightedmykind_likes (13);