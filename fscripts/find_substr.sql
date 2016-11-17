--search a pattern in dba_source

with jj as (
    SELECT *  
    FROM dba_source 
    WHERE UPPER(REPLACE(upper(text),' ')) LIKE '%APEX_MAIL%'  --LIKE '%EMP_EMAIL%'  
)
select * from jj ORDER BY OWNER,NAME,LINE;
