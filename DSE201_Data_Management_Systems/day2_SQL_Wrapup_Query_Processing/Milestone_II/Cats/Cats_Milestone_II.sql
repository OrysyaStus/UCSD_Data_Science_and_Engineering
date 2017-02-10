-- Cats: Milestone II
-- Orysya Stus

-- Option "Overall Likes": The Top-10 cat videos are the ones that have collect the highest numbers of likes, overall
SELECT 
	v.video_id,
    v.video_name,
    COUNT(v.video_id) AS number_of_likes
FROM cats.video v, cats.likes l
WHERE v.video_id = l.video_id
GROUP BY v.video_id
ORDER BY COUNT(v.video_id) DESC
LIMIT 10;

-- Option "Friend Likes": The Top-10 cat videos are the ones that have collected the highest numbers of like from the friends of X
SELECT 
	v.video_id,
    v.video_name,
    COUNT(v.video_id) AS number_of_likes
FROM cats.video v, cats.likes l, cats.friend f
WHERE v.video_id = l.video_id AND l.user_id = f.user_id AND l.user_id = 1
GROUP BY v.video_id
ORDER BY COUNT(v.video_id) DESC
LIMIT 10;

-- Option "Friends-of-Friends Likes": The Top-10 cat videos are the ones that have collected the highest numbers of likes from friends and friends-of-friends
SELECT 
	v.video_id,
    v.video_name,
    COUNT(v.video_id) AS number_of_likes
FROM cats.video v, cats.likes l
WHERE v.video_id = l.video_id AND l.user_id NOT IN (1) AND l.user_id IN (
    (SELECT f.friend_id
	FROM cats.video v, cats.likes l, cats.friend f
	WHERE v.video_id = l.video_id AND l.user_id = f.user_id AND l.user_id = 1)
	UNION
	(SELECT f.friend_id
	FROM cats.friend AS f
	WHERE f.user_id in (
    	SELECT f2.friend_id
    	FROM cats.friend AS f2
    	WHERE F2.user_id = 1)))  
GROUP BY v.video_id
ORDER BY COUNT(v.video_id) DESC
LIMIT 10;

/*
-- (SELECT 
-- 	v.video_id,
--     v.video_name,
--     COUNT(v.video_id) AS number_of_likes
-- FROM video v, likes l, friend f
-- WHERE v.video_id = l.video_id AND l.user_id = l.user_id
-- GROUP BY v.video_id
-- ORDER BY COUNT(v.video_id) DESC
-- LIMIT 10)
-- UNION
-- friends of friends
-- (SELECT 
-- 	v.video_id,
--     v.video_name,
--     COUNT(v.video_id) AS number_of_likes
-- FROM video v, likes l, friend f
-- WHERE v.video_id = l.video_id AND f.user_id IN (
--     SELECT f.friend_id
-- 	FROM friend AS f
-- 	WHERE f.user_id in (
--     	SELECT f2.friend_id
--     	FROM friend AS f2
--     	WHERE F2.user_id = 1)) 
-- GROUP BY v.video_id
-- ORDER BY COUNT(v.video_id) DESC
-- LIMIT 10)

-- friend of friends
SELECT f.friend_id
FROM friend AS f
WHERE f.user_id in (
    SELECT f2.friend_id
    FROM friend AS f2
    WHERE F2.user_id = 1)
*/

-- Option "My kind of cats": The Top-10 cat videos are the ones that have collected the most likes from users who have liked at least 1 cat video that was liked by X
SELECT 
	v.video_id,
    v.video_name,
    COUNT(v.video_id) AS number_of_likes
FROM cats.video v, cats.likes l
WHERE v.video_id = l.video_id AND l.user_id IN (
    SELECT DISTINCT u.user_id
	FROM cats."user" AS u, cats.likes AS l, cats.video AS v
	WHERE u.user_id = l.user_id AND l.video_id = v.video_id AND u.user_id NOT IN (1) AND  l.video_id IN (
    	SELECT v.video_id
		FROM cats."user" AS u, cats.likes AS l, cats.video AS v
		WHERE u.user_id = l.user_id AND l.video_id = v.video_id AND u.user_id = 1))
GROUP BY v.video_id
ORDER BY COUNT(v.video_id) DESC
LIMIT 10;

/*Option "My kind of cats -- with preference (to cat aficionados that have the same tastes)": The Top-10 cat videos are the ones that have collected the hgihest sum of weighted likes from
every other user Y (i.e. given a cat video, each like on it, is multiplied by a weight).
The weight is the log cosine lc(X,Y) defined as follows: Conceptually, there is a vector v_u for each user U, including the logged-in user X. The vector has as many elements as the number
of cat video. Element i is 1 if U liked the ith cat video; it is 0 otherwise. For example, if 201Cats has five cat videos and user 21 liked only the 1st and the 4th, then 
v_21 = <1,0,0,1,1>, ie. v_21[1]=v_21[4]=1 and v_21[2]=v_21[3]=v_21[5]=0. Assuming there are N cat videos, the log cosine lc(X,Y) is (check out the sheet)*/
WITH kind_cats AS (
SELECT X.user_id, Y.user_id AS Other_user, log (1 + SUM(Y.BIN_LIKE * X.BIN_LIKE)) AS Weight
FROM
(	SELECT l1.video_id, l1.like_id/l1.like_id AS BIN_LIKE, l1.user_id
    FROM cats.likes l1
    WHERE l1.user_id = 1) X, 
   (   	SELECT l2.video_id, l2.like_id/l2.like_id AS BIN_LIKE, l2.user_id
    	FROM cats.likes l2
    	WHERE l2.user_id NOT IN (1)) Y
 WHERE X.video_id = Y.video_id
 GROUP BY X.user_id, Y.user_id
 ORDER BY X.user_id)
SELECT l3.video_id, SUM(kind_cats.weight) AS video_log_weight
FROM cats.likes l3, kind_cats
WHERE kind_cats.Other_user = l3.user_id
GROUP BY l3.video_id
ORDER BY video_log_weight DESC, l3.video_id DESC
LIMIT 10;

/*
WITH wusers AS
    (
    SELECT l2.user_id,
    log(COUNT(l2.like_id) + 1) like_weigh
    FROM cats.user u
    JOIN cats.likes l 
    ON  u.user_id = l.user_Id
    JOIN cats.likes l2
    ON  l2.video_id = l.video_id
    WHERE u.user_id = 1
    GROUP BY l2.user_id
    ),
wlikes AS
    (
    SELECT l.video_id,
    SUM(w.like_weigh) sum_weigh
    FROM cats.likes l
    JOIN wusers w
    ON l.user_id = w.user_id
    GROUP BY l.video_id
    ORDER BY sum_weigh DESC limit 10
    )
SELECT l.sum_weigh, v.video_name, v.video_id
FROM wlikes l
JOIN cats.video v
ON  l.video_id = v.video_id
ORDER BY sum_weigh DESC;
*/