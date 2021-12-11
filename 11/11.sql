create or replace package AOC21_P11 as

    /*
        -- DDL
        CREATE TABLE  "AOC21_D11_FLASH" 
        (	"IDROW" NUMBER, 
            "IDCOL" NUMBER, 
            "ELEVEL" NUMBER, 
            "HAVE" NUMBER, 
            "FLASH" NUMBER, 
            CONSTRAINT "AOC21_D11_FLASH_PK" PRIMARY KEY ("IDROW", "IDCOL")
        USING INDEX  ENABLE
        )

     */ 

    procedure part_one(pIn in varchar2, pOut in out varchar2);
    procedure part_two(pIn in varchar2, pOut in out varchar2);

end;
/
create or replace package body AOC21_P11 as

    procedure part_one(pIn in varchar2, pOut in out varchar2)
    is
        vCount number;
        vOld number;
    begin
    
        EXECUTE IMMEDIATE 'TRUNCATE TABLE AOC21_D11_FLASH';

        INSERT INTO AOC21_D11_FLASH(IDROW,IDCOL,ELEVEL,HAVE,FLASH)
        SELECT t.IDROW, MOD( (ROWNUM -1), 10) +1 IDCOL, to_number(t2.COLUMN_VALUE) ELEVEL, 0 HAVE, 0 FLASH
            FROM
            (
            SELECT ROWNUM IDROW, COLUMN_VALUE LINE
            FROM 
            TABLE(APEX_STRING.split(pIn ,chr(10)))
            ) t,
            TABLE(APEX_STRING.split(t.LINE,'')) t2;

        FOR I IN 1..100
        LOOP
            -- increase all level and reset have indicator
            UPDATE AOC21_D11_FLASH
                SET ELEVEL = ELEVEL +1,
                    HAVE = 0;
            vCount := 0;
            vOld := -1;
            WHILE vCount > vOld
                LOOP
                    UPDATE AOC21_D11_FLASH
                        SET FLASH = FLASH +1,
                            HAVE = 1,
                            ELEVEL = 0
                        WHERE ELEVEL > 9 and HAVE = 0;

                    FOR F IN (SELECT * FROM AOC21_D11_FLASH WHERE HAVE = 1 )
                        LOOP

                            UPDATE AOC21_D11_FLASH
                                SET ELEVEL = ELEVEL +1
                                WHERE HAVE = 0
                                    AND IDROW BETWEEN (F.IDROW -1) AND  (F.IDROW +1)
                                    AND IDCOL BETWEEN (F.IDCOL -1) AND  (F.IDCOL +1);
                        END LOOP;

                    UPDATE AOC21_D11_FLASH
                      SET HAVE = 2
                      WHERE HAVE = 1;

                      vOLd := vCount;

                      SELECT COUNT(*)
                        INTO vCount
                        FROM AOC21_D11_FLASH
                        WHERE HAVE > 0;

                    -- htp.prn('I='||I||';vCount='||vCount||'<BR />');

            END LOOP;

        SELECT SUM(FLASH)
            INTO pOut
            FROM AOC21_D11_FLASH;      

        -- htp.prn('I='||I||';flash='||pOut||'<BR />');      

        END LOOP;

        SELECT SUM(FLASH)
            INTO pOut
            FROM AOC21_D11_FLASH;

    end;

    procedure part_two(pIn in varchar2, pOut in out varchar2)
    is
        vCount number;
        vOld number;

        I number;
    begin
    
        EXECUTE IMMEDIATE 'TRUNCATE TABLE AOC21_D11_FLASH';

        INSERT INTO AOC21_D11_FLASH(IDROW,IDCOL,ELEVEL,HAVE,FLASH)
        SELECT t.IDROW, MOD( (ROWNUM -1), 10) +1 IDCOL, to_number(t2.COLUMN_VALUE) ELEVEL, 0 HAVE, 0 FLASH
            FROM
            (
            SELECT ROWNUM IDROW, COLUMN_VALUE LINE
            FROM 
            TABLE(APEX_STRING.split(pIn,chr(10)))
            ) t,
            TABLE(APEX_STRING.split(t.LINE,'')) t2;

        I := 1;
        WHILE 1 = 1
        LOOP
            -- increase all level and reset have indicator
            UPDATE AOC21_D11_FLASH
                SET ELEVEL = ELEVEL +1,
                    HAVE = 0;
            vCount := 0;
            vOld := -1;
            WHILE vCount > vOld
                LOOP
                    UPDATE AOC21_D11_FLASH
                        SET FLASH = FLASH +1,
                            HAVE = 1,
                            ELEVEL = 0
                        WHERE ELEVEL > 9 and HAVE = 0;

                    FOR F IN (SELECT * FROM AOC21_D11_FLASH WHERE HAVE = 1 )
                        LOOP

                            UPDATE AOC21_D11_FLASH
                                SET ELEVEL = ELEVEL +1
                                WHERE HAVE = 0
                                    AND IDROW BETWEEN (F.IDROW -1) AND  (F.IDROW +1)
                                    AND IDCOL BETWEEN (F.IDCOL -1) AND  (F.IDCOL +1);
                        END LOOP;

                    UPDATE AOC21_D11_FLASH
                      SET HAVE = 2
                      WHERE HAVE = 1;

                      vOLd := vCount;

                      SELECT COUNT(*)
                        INTO vCount
                        FROM AOC21_D11_FLASH
                        WHERE HAVE > 0;
                    if vCount = 100 then
                        pOut := I;
                        RETURN;
                    end if;            

                -- htp.prn('vCount'||vCount||'<BR />');
            END LOOP;

            I := I +1;

        END LOOP;

    end;    

end;
/
declare
    vOut varchar2(100);
begin
    AOC21_P11.part_one(pIn => '6744638455
3135745418
4754123271
4224257161
8167186546
2268577674
7177768175
2662255275
4655343376
7852526168', pOut => vOut);
    htp.prn('part one: illopa says '||vOut||'<BR />');

    AOC21_P11.part_two(pIn => '6744638455
3135745418
4754123271
4224257161
8167186546
2268577674
7177768175
2662255275
4655343376
7852526168', pOut => vOut);
    htp.prn('part two: illopa says '||vOut||'<BR />');
    
end;