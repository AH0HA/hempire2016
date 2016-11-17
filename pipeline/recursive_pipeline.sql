CREATE OR REPLACE EDITIONABLE TYPE t_tf_tab IS TABLE OF VARCHAR2(500);
 
--https://community.oracle.com/thread/3978696
--test if store pwd works

CREATE OR REPLACE FUNCTION print_anagrams2(pre IN VARCHAR2, str IN VARCHAR2)
    RETURN t_tf_tab
    PIPELINED
AS
    prefix    VARCHAR2(30);
    stringg   VARCHAR2(30);
    strlen    NUMBER;
BEGIN
    strlen := LENGTH(str);
    IF NVL(strlen, 0) = 0
    THEN
        PIPE ROW (pre);
    ELSE
        FOR i IN 1 .. strlen
        LOOP
            prefix := pre || SUBSTR(str, i, 1);
            stringg := SUBSTR(str, 1, i - 1) || SUBSTR(str, i + 1, strlen);
            FOR x IN (SELECT COLUMN_VALUE val
                        FROM TABLE(print_anagrams2(prefix, stringg)))
            LOOP
                PIPE ROW (x.val);
            END LOOP;
        END LOOP;
    END IF;
END;

select * from table(print_anagrams2('','cat'));