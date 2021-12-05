create or replace package AOC21_P01 as

    procedure part_one(pOut in out varchar2);
    procedure part_two(pOut in out varchar2);

end;
/
create or replace package body AOC21_P01 as

    /*
        ---- DDL

        CREATE TABLE  "AOC21_D01_INPUT" 
        (	"ID" NUMBER NOT NULL ENABLE, 
            "COL001" VARCHAR2(1000), 
            CONSTRAINT "AOC21_D01_INPUT_PK" PRIMARY KEY ("ID")
        USING INDEX  ENABLE
        )  DEFAULT COLLATION "USING_NLS_COMP"

        CREATE TABLE  "AOC21_D01_DEPTH" 
        (	"ID" NUMBER NOT NULL ENABLE, 
            "N_DEPTH" NUMBER, 
            CONSTRAINT "AOC21_D01_DEPTH_PK" PRIMARY KEY ("ID")
        USING INDEX  ENABLE
        )  DEFAULT COLLATION "USING_NLS_COMP"
    
     */

    procedure part_one(pOut in out varchar2)
    is
    begin

        DELETE FROM AOC21_D01_DEPTH;

        INSERT INTO AOC21_D01_DEPTH(ID,N_DEPTH)
            SELECT ID, TO_NUMBER(trim(COL001))
                FROM AOC21_D01_INPUT;

        select  sum(F_INC)
            into POut
            FROM (
                select t.ID, (case when n.N_DEPTH > t.n_depth then 1 else 0 end) F_INC
                FROM
                (
                    select * 
                        from AOC21_D01_DEPTH    
                ) t,
                (
                    select *
                        from AOC21_D01_DEPTH    
                ) n
                WHERE n.ID > 1 and n.ID = t.ID +1
                order by t.ID
            ); 
    end;

    procedure part_two(pOut in out varchar2)
    is
    begin
        DELETE FROM AOC21_D01_DEPTH;

        INSERT INTO AOC21_D01_DEPTH(ID,N_DEPTH)
            SELECT ID, TO_NUMBER(trim(COL001))
                FROM AOC21_D01_INPUT;


        UPDATE AOC21_D01_DEPTH t
        SET t.N_DEPTH =  (select  t.N_DEPTH + TO_NUMBER(trim(COL001))
                        from AOC21_D01_INPUT p
                            where p.id = t.id -1 )
        WHERE t.id > 2;


        UPDATE AOC21_D01_DEPTH t
        SET t.N_DEPTH =  (select  t.N_DEPTH + TO_NUMBER(trim(COL001))
                        from AOC21_D01_INPUT p
                            where p.id = t.id -2 )
        WHERE t.id > 2;

        select  sum(F_INC)
            into POut
            FROM (
                select t.ID, (case when n.N_DEPTH > t.n_depth then 1 else 0 end) F_INC
                FROM
                (
                    select * 
                        from AOC21_D01_DEPTH    
                ) t,
                (
                    select *
                        from AOC21_D01_DEPTH    
                ) n
                WHERE n.ID > 3 and n.ID = t.ID +1
                order by t.ID
            ); 
    end;    

end;
/
----------------------
declare
    vOut varchar2(100);
begin
    AOC21_P01.part_one(pOut => vOut);
    htp.prn('part one: illopa says '||vOut||'<BR />');
    AOC21_P01.part_two(pOut => vOut);
    htp.prn('part two: illopa says '||vOut||'<BR />');
end;