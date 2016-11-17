declare
v_length number(10);
v_out varchar2(20);
--in_string varchar2(26) := 'ABCDEFGHIJKLMNOPQRSTUXWXYZ';
in_string varchar2(26) := 'BCDEFGHIJKLMNOPQRSTUXWXYZ';
  PCT NUMBER := 10;
  STARTLETTER VARCHAR2(32767) := 'A';
  THISRUNID NUMBER;
  DEBUGFLG VARCHAR2(32767) := 'FALSE';
Begin
v_length := length(IN_string);
  --PCT := 10;
  --STARTLETTER := 'WDS_KWRD_PRE_LOAD';
  THISRUNID := NULL;
  --DEBUGFLG := 'TRUE';
  dbms_output.enable(1000000);
    GKN_COMMON.SAMPLE_COL ( PCT, STARTLETTER, THISRUNID, DEBUGFLG );
    dbms_output.put_line('thisRunId='||thisRunID); 
for i in 1..v_length
Loop
    v_out  := substr(IN_string,i,1) ;
    GKN_COMMON.SAMPLE_COL ( PCT, v_out, THISRUNID, DEBUGFLG );

DBMS_OUTPUT.PUT_LINE('v_ou='||v_out||'|thisRunId='||thisRunID);

End loop;
DBMS_OUTPUT.PUT_LINE('Text printed=' || IN_string||' length='||length(in_string));
End;