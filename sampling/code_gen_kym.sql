--drop view code_gen_kym
--create materialized view code_gen_kym as
create or replace view code_gen_kym_debug as
with xxx as (
select
 --owa_pattern.amatch(trim(observation),1,'\s*[a-zA-Z][a-zA-Z0-9][a-zA-Z]\s*') mynum
 --,length(trim(observation)) mylen
 owa_pattern.amatch(TRIM(x.observation),1,'^[a-zA-Z][a-zA-Z0-9][a-zA-Z]$') mynum-- = 4
 ,length(trim(x.observation)) mylen--=3)
,x.*
from  
pattern_search_kym x 
where runID>= 75
--where rownum < 100
--sample(1)
--where
and 
x.column_name not in ('GRP','REF','USER_PROFILE','DATA_LINE','PGM','ROLE')
)
,mx as (
select * from xxx where mynum = 4 and mylen = 3
)
--select * from mx
--select * from mx where mynum <> 4 and mylen <> 3
,j2 as (
select runid,id,count(*) over (partition by runid,table_name,column_name) ttl_cnt,table_name,column_name,observation from pattern_search_kym --group by table_name,column_name
)
,p2 as(
select runid,id,count(distinct(observation))  over (partition by runid,table_name,column_name) filter_cnt ,table_name,column_name,observation from mx --group by table_name,column_name
) 
,hh2 as (

select distinct(ss_employees.emp_alias) from ss_employees  where emp_status ='A'
--union
--select distinct(ss_employees_hist.emp_alias) from ss_employees_hist  where emp_status = 'A'
)/*
select p2.filter_cnt,j2.*
from  p2 right join j2 on (j2.table_name = p2.table_name and j2.column_name = p2.column_name)
order by filter_cnt desc
*/
--select p2.filter_cnt
--from p2 right join hh2 on (h2.emp_alias = 
,cip as (
select mx.*,hh2.emp_alias,p2.filter_cnt,j2.ttl_cnt
from mx left join hh2
on upper(trim(hh2.emp_alias)) = upper(trim(mx.observation))
join p2 on p2.table_name = mx.table_name and mx.column_name = p2.column_name and p2.runid = mx.runid
join j2 on j2.table_name = mx.table_name and mx.column_name = j2.column_name and p2.runid = mx.runid
)
select * from cip  where filter_cnt >3 and ttl_cnt=10 and emp_alias is not null
      --owa_pattern.amatch(x.observation,1,'\s*[a-zA-Z][a-zA-Z0-9][a-zA-Z]\s*')=4
      
with mp as (
select count(*) cnt,table_name,column_name,'select '||table_name||'.'||column_name||' from '||table_name||' where rownum < 10' str from code_gen_kym_debug group by table_name,column_name
)
select * from mp order by cnt

select WDS_KWRD_TABLE_20140624.USER_PROFILE from WDS_KWRD_TABLE_20140624 where rownum < 10
      
      