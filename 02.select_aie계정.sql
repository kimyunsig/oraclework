-- 테이블 컬럼의 정보 조회
/*
(') 홑따옴표 : 문자열일 때
(") 쌍따옴표 : 컬럼명일 때
*/
/*
    <select>
    데이터 조회할 때 사용하는 구문
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하려는컬럼명, 조회하려는컬럼명, ...
    FROM 테이블명
*/

-- 테이블의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;

-- EMPLOYEE테이블에서 사번, 이름, 전화번호만 조회
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE;

------------------- 실습문제----------------------
--1. JOB테이블에 직급명만 조회

--2. DEPARTMENT 테이블의 모든 컬럼 조회

--3. DEPARTMENT 테이블의 부서코드, 부서명만 조회

--4. EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회+

/*
    <컬럼값을 통한 산술연산>
    SELECT절 컬럼명 작성부분에 산술연산 기술 가능(이때 산술연산된 결과 조회)
*/
-- EMPLOYEE에서 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를포한한연봉((급여+(보너스*급여))*12)
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY+BONUS*SALARY)*12
FROM EMPLOYEE;
-- 산술연산 중 NULL이 존재하면 결과는 무조건 NULL이됨. 별도 처리(나중에)

-- EMPLOYEE에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
-- DATE형 끼리도 연산 가능 : 결과값은 일 단위
-- * 오늘날짜 : SYSDATE
 SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
 FROM EMPLOYEE;
 -- 함수수업시 DATE 날짜처리하면 초단위를 관리할 수 있음

--------------------------------------------------------------------------------------------------
/*
    <컬럼명에 별칭 지정하기>
    산술연산시 산술에 들어간 수식 그대로 컬럼명이 됨. 이때 별칭을 부여하면 깔끔하게 처리
    
    [표현법]
    컬럼명 별칭 / 컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
    
    별칭에 띄어쓰기나 특수문자 포함되면 반드시 (") 쌍따옴표를 넣어줘야 한다
*/

-- EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를포한한연봉((급여+(보너스*급여))*12)
SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS 보너스,  
             SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 소득"
FROM EMPLOYEE;

 SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
 FROM EMPLOYEE;

--------------------------------------------------------------------------------------------------
/*
    <리터럴>
    임의로 지정된 문자열(')
    
    SELECT절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회 가능
    조회된 RESULT SET의 모든 행에 반복적으로 출력
*/
-- EMPLOYEE에 사번, 사원명, 급여, 원 AS 단위 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS "단위"
FROM EMPLOYEE;

--------------------------------------------------------------------------------------------------
/*
    <연결 연산자 : || >
    여러 컬럼값들을 마치 하나의 컬럼값인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/
-- EMPLOYEE에 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '원'
FROM EMPLOYEE;

-- 홍길동의 월급은 900000원 입니다
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

-- 홍길동의 전화번호는 PHONE이고 이메일은 EMAIL 입니다