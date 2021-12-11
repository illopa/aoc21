create or replace package AOC21_P02 as

    TYPE t_num IS TABLE OF NUMBER;

    FUNCTION moving_one(input_values SYS_REFCURSOR) RETURN t_num PIPELINED;
    FUNCTION moving_two(input_values SYS_REFCURSOR) RETURN t_num PIPELINED;

    procedure part_one(pOut in out varchar2);
    procedure part_two(pOut in out varchar2);

end;
/
create or replace package body AOC21_P02 as

    procedure move_one(pDir in varchar2, pNum in number, pHor in out number, pDep in out number)
        is
        begin
            select  (case when pDir = 'forward' then pHor + pNum else pHor end) nH,
                    (case when pDir = 'up' then greatest(0,pDep - pNum)
                        when pDir = 'down' then pDep + pNum
                        else pDep end) nD
                into pHor, pDep
                from dual;
        end;

    FUNCTION moving_one(input_values SYS_REFCURSOR)
        RETURN t_num PIPELINED
    IS
        vHor number := 0;
        vDep number := 0;

        vDir varchar2(100);
        vNum number;
    BEGIN
        LOOP
            FETCH input_values INTO vDir, vNum;
            EXIT WHEN input_values%NOTFOUND;

            move_one(pDir => vDir, pNum => vNum, pHor => vHor, pDep => vDep);

        END LOOP;
        PIPE ROW (vHor * vDep);
        RETURN; -- returns single result
    END moving_one;    

    procedure part_one(pOut in out varchar2)
        is
        begin

            select  column_value
                into pOut
                FROM TABLE( moving_one( CURSOR ( select trim(regexp_substr(t.col001,'[^ ]+',1,1)) dir, to_number(trim(regexp_substr(t.col001,'[^ ]+',1,2))) num from 
                            AOC21_D02_INPUT t ORDER BY t.id ) ) );
        end;

    procedure move_two(pDir in varchar2, pNum in number, pHor in out number, pDep in out number, pAim in out number)
        is
        begin
            select  (case when pDir = 'forward' then pHor + pNum else pHor end) nH,
                    (case when pDir = 'forward' then greatest(0,pDep + (pAim *pNum) )
                        else pDep end) nD,
                    (case when pDir = 'up' then pAim - pNum
                        when pDir = 'down' then pAim + pNum
                        else pAim end) nA                    
                into pHor, pDep, pAim
                from dual;
        end;  

    FUNCTION moving_two(input_values SYS_REFCURSOR)
        RETURN t_num PIPELINED
    IS
        vHor number := 0;
        vDep number := 0;
        vAim number := 0;

        vDir varchar2(100);
        vNum number;
    BEGIN
        LOOP
            FETCH input_values INTO vDir, vNum;
            EXIT WHEN input_values%NOTFOUND;

            move_two(pDir => vDir, pNum => vNum, pHor => vHor, pDep => vDep, pAim => vAim);

        END LOOP;
        PIPE ROW (vHor * vDep);
        RETURN; -- returns single result
    END moving_two;               

    procedure part_two(pOut in out varchar2)
    is
    begin
        select  column_value
            into pOut
            FROM TABLE( moving_two( CURSOR ( select trim(regexp_substr(t.col001,'[^ ]+',1,1)) dir, to_number(trim(regexp_substr(t.col001,'[^ ]+',1,2))) num from 
                        AOC21_D02_INPUT t ORDER BY t.id ) ) );
    end;

end;
/
declare
    vOut varchar2(100);
begin
    AOC21_P02.part_one(pOut => vOut);
    htp.prn('part one: illopa says '||vOut||'<BR />');
    AOC21_P02.part_two(pOut => vOut);
    htp.prn('part two: illopa says '||vOut||'<BR />');
end;