CREATE OR REPLACE procedure sample_col(pct in number,startletter in varchar2,thisRunID out number,debugflg in varchar2 default 'FALSE') is
--declare
  rc sys_refcursor;
  sql_stmt varchar2(5000);
  tab_name varchar2(300);
  owner varchar2(300);
  rc2 sys_refcursor;


  v_cursor integer;
  v_dname  char(200);
  v_rows   integer;
  xsql varchar2(5000);
  xno integer;
  rec_tab  DBMS_SQL.DESC_TAB;
  col_cnt integer;
  col_num number;
  exist_cnt number;
  sql_stmt_cnt varchar2(5000);

  myrunid number;
  --myid number;
  mycreateDate date;

  --startletter varchar(1);
  --pct integer;



begin

   select pattern_search_kym_runid.nextval into myrunid from dual;

   select sysdate into mycreateDate from dual;


   exist_cnt  := 0;
 --pct := 1;
  --startletter := 'A';
  --sql_stmt := 'select owner,table_name from all_tables where table_name like '''||startletter||'%'''||' and owner not in (''SYS'',''SYSTEM'')';
  --sql_stmt_cnt := 'select count(*) from all_tables where table_name like '''||startletter||'%'''||' and owner not in (''SYS'',''SYSTEM'')';

  sql_stmt := 'select owner,table_name from all_tables where table_name = '''||startletter||'%'''||' and owner not in (''SYS'',''SYSTEM'')';
  sql_stmt_cnt := 'select count(*) from all_tables where table_name = '''||startletter||'%'''||' and owner not in (''SYS'',''SYSTEM'')';

    if debugflg='TRUE' then
      dbms_output.enable(1000000);
      dbms_output.put_line('sql_stmt='||sql_stmt);
      dbms_output.put_line('sql_stmt_cnt='||sql_stmt_cnt);
    end if;

  open rc for sql_stmt;
  loop

  fetch rc into owner,tab_name;

   execute immediate sql_stmt_cnt into exist_cnt;

   if exist_cnt = 0 then
    exit;
   end if;

  exit when rc%notfound;
    --<do your process.>



    --xsql := 'select * from '||owner||'.'||tab_name|| ' sample('||pct||') ';

    xsql:=  'SELECT  * FROM    ( '||
     ' SELECT  *
        FROM    '||owner||'.'||tab_name
        ||' ORDER BY
                dbms_random.value
        ) WHERE rownum <= '||pct;


    if debugflg='TRUE' then
      dbms_output.put_line('xsql='||xsql);
    end if;

--dbms_output.put_line(xsql);


    --where 1=:x';

    /*
xsql:='WITH     got_r_num    AS
(
     SELECT  e.*
     ,     ROW_NUMBER () OVER (ORDER BY  dbms_random.value)     AS r_num
     FROM     '||tab_name||' e
)
SELECT  *     -- or list all columns except r_num
FROM     got_r_num
WHERE     r_num     <= '||pct;
*/



  v_cursor := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cursor, xsql, DBMS_SQL.V7);
  --DBMS_SQL.BIND_VARIABLE(v_cursor, ':x', xno);
  v_rows := DBMS_SQL.EXECUTE(v_cursor);
  DBMS_SQL.DESCRIBE_COLUMNS(v_cursor, col_cnt, rec_tab);


    --col_num := rec_tab.first;
for   col_num in 1..col_cnt
LOOP
      --print_rec(rec_tab(col_num));
    if (rec_tab(col_num).col_type =1 or rec_tab(col_num).col_type=96 ) then
    --for (n)varchar2, & (n)char
    --http://docs.oracle.com/cd/B19306_01/server.102/b14200/sql_elements001.htm

      --DBMS_SQL.DEFINE_COLUMN_CHAR(v_cursor, col_num, v_dname,rec_tab(col_num).col_name_len );

      --need to use col_max_len. in column got blank space, the element got chopp off where the space at ???
      --https://docs.oracle.com/cd/A97630_01/appdev.920/a96612/d_sql.htm
      DBMS_SQL.DEFINE_COLUMN_CHAR(v_cursor, col_num, v_dname,rec_tab(col_num).col_max_len );
      --EXIT WHEN (col_num IS NULL);
    --col_num := rec_tab.next(col_num);

    end if;
    END LOOP;




  loop
    if DBMS_SQL.FETCH_ROWS(v_cursor) > 0 then--see if there is row?

        for idx in 1..col_cnt loop

             if debugflg='TRUE' then
              dbms_output.put_line('idx='||idx||' '||tab_name||' '||rec_tab(idx).col_name);
             end if;

            --we want to only look at the varchar,char datatype
            if (rec_tab(idx).col_type =1 or rec_tab(idx).col_type=96 ) then--for (n)varchar2, & (n)char
                DBMS_SQL.COLUMN_VALUE_CHAR(v_cursor, idx, v_dname);

        --if owa_pattern.match(TRIM(v_dname), pat) then
            --dbms_output.put_line('Match');
           -- if LENGTH(TRIM(v_dname))=3 then
            --dbms_output.put_line(LENGTH(TRIM(v_dname)));
            --DBMS_OUTPUT.PUT_LINE(rec_tab(idx).col_name||'='||v_dname);

                insert into pattern_search_kym(runid,id,create_date,owner,table_name,column_name,observation) values(myrunid,pattern_search_kym_id.nextval,mycreateDate,owner,tab_name,rec_tab(idx).col_name,v_dname);
            --end if;
        --end if;
            end if;
         end loop;

    else--no more row
        exit;
    end if;

  end loop;
    --DBMS_OUTPUT.PUT_LINE('name: '||v_dname);

  DBMS_SQL.CLOSE_CURSOR(v_cursor);


  end loop; --end v_cursor




  close rc;

  thisRunID := myRunID;

end;
/
