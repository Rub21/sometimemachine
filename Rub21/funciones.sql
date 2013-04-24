select osm_user,(CAST(((TIMESTAMP WITH TIME ZONE 'epoch' +  INTERVAL '1 second' * timestamp)|| ' ') AS date)|| '') as timestamp ,
num_changes from  osm_changeset   where osm_user='bot-mode' ORDER BY num_changes DESC;
/**************************************************/
/*order By moth*/
select substring((CAST(((TIMESTAMP WITH TIME ZONE 'epoch' +  INTERVAL '1 second' * timestamp)|| ' ') AS date)|| ''),1,7) as date , 
count(num_changes) as num_edition, sum(num_changes) as num_changes from  osm_changeset  where osm_user='SDT_420'
GROUP BY substring((CAST(((TIMESTAMP WITH TIME ZONE 'epoch' +  INTERVAL '1 second' * timestamp)|| ' ') AS date)|| ''),1,7) 
ORDER BY substring((CAST(((TIMESTAMP WITH TIME ZONE 'epoch' +  INTERVAL '1 second' * timestamp)|| ' ') AS date)|| ''),1,7) DESC;

/*Order By Day order */
select (CAST(((TIMESTAMP WITH TIME ZONE 'epoch' +  INTERVAL '1 second' * timestamp)|| ' ') AS date)|| '') as date , 
count(num_changes) as num_edition, sum(num_changes) as num_changes from  osm_changeset  where osm_user='ian29'
GROUP BY (CAST(((TIMESTAMP WITH TIME ZONE 'epoch' +  INTERVAL '1 second' * timestamp)|| ' ') AS date)|| '')
ORDER BY num_changes DESC;
/*
OSMF Redaction Account
Bot-mode
SDT_420 
TexasNHD
25or6to4*/


SELECT osm_user , count(*) AS nun_edits FROM osm_changeset GROUP BY osm_user ORDER BY nun_edits DESC limit 60;

select * from osm_changeset limit 10

SELECT osm_user , sum(num_changes) AS nun_changes FROM osm_changeset GROUP BY osm_user ORDER BY nun_changes DESC limit 100;


SELECT osm_user , sum(num_changes) AS nun_changes FROM osm_changeset
 GROUP BY osm_user ORDER BY nun_changes DESC limit 100;


SELECT osm_user , count(num_changes) AS nun_changes 
FROM osm_changeset  where osm_user='jremillard-massgis' GROUP BY osm_user ORDER BY  nun_changes DESC ;
SELECT osm_user , count(num_changes) AS nun_changes FROM osm_changeset where osm_user='pnorman_mechanical' GROUP BY osm_user ORDER BY nun_changes DESC 


SELECT osm_user , count(num_changes),sum(num_changes)
pnorman_mechanical
slo_osm_imports
jremillard-massgis



select * from osm_changeset where user_id=37392
SELECT osm_user , count(*) AS nun_edits FROM osm_changeset GROUP BY osm_user ORDER BY nun_edits DESC limit 55;

/*************************************************************************************************/
CREATE OR REPLACE FUNCTION get_date(tm INTEGER)
RETURNS  text
AS $$
DECLARE
	_time TEXT;	
	BEGIN
		_time=(SELECT TIMESTAMP WITH TIME ZONE 'epoch'+  INTERVAL '1 second'* tm);	
	RETURN _time;
	END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_date_by_hour(tm INTEGER)
RETURNS  text
AS $$
DECLARE
	_time TEXT;	
	BEGIN
		_time=(SELECT substring(((TIMESTAMP WITH TIME ZONE 'epoch'+  INTERVAL '1 second'* tm)|| ''),1,13));	
	RETURN _time;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_date_by_day(tm INTEGER)
RETURNS  text
AS $$
DECLARE
	_time TEXT;	
	BEGIN
		_time=(SELECT substring(((TIMESTAMP WITH TIME ZONE 'epoch'+  INTERVAL '1 second'* tm)|| ''),1,10));	
	RETURN _time;
	END;
$$ LANGUAGE plpgsql;


select get_date_by_hour(timestamp) from osm_changeset limit 100

select get_date_by_day(timestamp)as date,
count(num_changes) as num_edition, sum(num_changes) as num_changes 
from  osm_changeset  where user_id=510836
GROUP BY get_date_by_day(timestamp)
ORDER BY get_date_by_day(timestamp) ;


--promedio de subidas por dia..
select avg(*) from osm_changeset where osm_user='Rub21'

select * from osm_changeset  where osm_user='25or6to4'

SELECT * from osm_changeset  limit 1;
SELECT osm_user FROM osm_changeset where user_id=510836 GROUP BY osm_user;