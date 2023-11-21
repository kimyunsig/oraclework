/*
    <DCL : DATA CONTROL LANGUAGE>
    데이터 제어어
    계정에게 시스템권한 또는 객체에 접근권한 부여(GRANT)하거나 회수(REVOKE)하는 구문
    
    > 시스템 권한 : DB에 접근하는 권한, 객체들을 생성할 수 있는 권한
    > 객체접근 권한 : 특정 객체들을 조작할 수 있는 권한
*/
----------------------------------------------------------------------------------------
/*
    1. 시스템 권한의 종류
       - GRANT CREATE SESSION : 접속할 수 있는 권한
       - GRANT CREATE TABLE : 테이블을 생성할 수 있는 권한
       - GRANT CREATE VIEW : 뷰를 생성할 수 있는 권한
       - GRANT CREATE SEQUENCE : 시퀀스 생성할 수 있는 권한
       ....
*/
-- 1.1 SAMPLE / sample 계성 생성
ALTER SESSION set "_oracle_script" = true;
create user sample identified by sample;
-- 접속권한이 없어 접속못함

-- 1.2 접속을 위해 CREATE SESSION 권한부여
GRANT CREATE SESSION TO SAMPLE;

/*
-- SAMPLE계정에서 테이블생성 불가 : 권한부여를 안해서
CREATE TABLE TEST (
    ID VARCHAR2(30),
    NAME VARCHAR2(20)
);
*/
-- 1.3 테이블을 생성할 수 있는 CREATE TABLE 권한 부여(테이블생성 못함)
GRANT CREATE TABLE TO SAMPLE;

-- 1.4 TABLESPACE 할당(데이터 삽입 안됨)
ALTER USER SAMPLE QUOTA 2M ON USERS;


----------------------------------------------------------------------------------------
/*
    2. 객체 접근 권한
        특정 객체에 접근하여 조작할 수 있는 권한
        
        권한 종류
        SELECT      TABLE, VIEW, SEQUENCE
        INSERT      TABLE, VIEW
        UPDATE      TABLE, VIEW
        DELETE      TABLE, VIEW
        .....
        
        [표현식]
        GRANT 권한종류 ON 특정객체 TO 계정명;
        - GRANT 권한 종류 ON 권한을 가지고 있는 USER.특정객체 TO 권한을줄USER;
*/
-- 2.1 SMAPLE계정에게 AIE계정 EMPLOYEE테이블을 SELECT할 수 있는 권한부여
GRANT SELECT ON AIE.EMPLOYEE TO SAMPLE;

-- 2.2 SMAPLE계정에게 AIE계정의 DEPARTMENT테이블에 INSERT할 수 있는 권한부여
GRANT INSERT ON AIE.DEPARTMENT TO SAMPLE;
GRANT SELECT ON AIE.DEPARTMENT TO SAMPLE;