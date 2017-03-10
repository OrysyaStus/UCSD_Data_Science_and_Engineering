SET search_path TO cats;

/*******************
** MY kind of cats
********************/

CREATE VIEW init (uid, vid, verdict) AS
  select    u.user_id as uid, v.video_id as vid, 0 as verdict
  from	    cats.user u, cats.video v;
  
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
   select   x, y, sum (likeSame) as prod
   from     cats.commonLikes
   group by x, y;

CREATE VIEW cats.weightedMykindLikes (uid, vid, verdict) AS 
select  u.user_id as uid, l.video_id as vid, log(1+i.prod) as verdict
from	cats.user u, cats.inner_product i, cats.likes l
where   u.user_id = i.x and l.user_id = i.y;

SELECT *
FROM cats.weightedMykindLikes;

-- same query, replacing overallLikes with weightedMykindLikes

CREATE MATERIALIZED VIEW cats.weightedMykindLikes_mat AS
	select   vid, sum (verdict) as rank
	from     (
        select  u.user_id as uid, l.video_id as vid, log(1+i.prod) as verdict
		from	cats.user u, cats.inner_product i, cats.likes l
		where   u.user_id = i.x and l.user_id = i.y) o
	where    o.uid = 13 and 
	not exists (select 1 from cats.watch w where w.user_id = o.uid and w.video_id = o.vid) and
	not exists (select 1 from cats.likes l where l.user_id = o.uid and l.video_id = o.vid) 
	group by vid
	order by rank desc
	limit    10;

SELECT *
FROM cats.weightedMykindLikes_mat;