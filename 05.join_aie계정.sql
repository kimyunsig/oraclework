/*
    <JOIN>
    두개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    조회 결과 하나의 결과물(RESULT SET)로 나옴
    
    관계형 데이터베이스는 최소한 데이터로 각각 테이블에 담고 있음
    (중복을 최소화하기 위해 최대한 나누어서 관리)
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 "관계"를 맺는 방법
    
    JOIN은 크기 "오라클전용구문"과 "ANSI 구문" (ANSI = 미국국립표준협회)
    
                                                 [ 용어 정리]
                                                 
                오라클 전용 구문                  |                                ANSI
------------------------------------------------------------------------------------      
                    등가조인                          |        내부조인(INNER JOIN) => JOIN USING/ON
                (EQUAL JOIN)                     |        자연조인(NATURL JOIN) => JOIN USING
------------------------------------------------------------------------------------      
                    포괄조인                           |        왼쪽 외부 조인(LEFT OUTER JOIN) 
                (LEFT OUTER)                     |       오른쪽 외부 조인(RIGHT OUTER JOIN) 
                (RIGHT OUTER)                   |        전체 외부 조인(FULL OUTER JOIN)
------------------------------------------------------------------------------------      
         자체 조인(SELF JOIN)                  |                           JOIN ON 
   비등가 조인(NON EQUL JOIN)            |        
------------------------------------------------------------------------------------      
카테시안 곱(CARTESIAN PRODUCT)     |                      교차 조인(CROSS JOIN)          

*/
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

------------------------------------------------------------------------------------    
/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
        연결시키고자 하는 컬럼 값이 "일치하는 행"들만 조인되어 조회(=일치하는 값이 없으면 조회에서 제외)
*/

-- >> 오라클 전용 구문
/*
    FROM에 조회하고자하는 테이블들을 나열(, 구분자로)
    WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시함
*/

-- 1) 연결할 두 컬럼명이 다른 경우(EMPLOYEE:DEPT_CODE, DEPARTMENT:DEPT_ID)
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 일치하는 값이 없는행은 조회에서 제외(NULL값 제외)

-- 2) 연결할 두 컬럼명이 같은 경우(EMPLOYEE:JOB_CODE, JOB:JOB_CODE)
-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회
/*
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;
*/

-- 해결방법1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법2) 테이블에 별칭을 부여하여 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- >> ANSI 구문
/*
    FROM에 기준이되는 테이블을 하나만 기술
    JOIN절에 같이 조회하고자하는 테이블을 기술 + 매칭시킬 컬럼에 대한 조건도 기술
      - JOIN 테이블명 USING(컬럼) , JOIN 테이블명 ON (컬럼1=컬럼2)
*/

-- 1) 연결할 두 컬럼명이 다른 경우(EMPLOYEE:DEPT_CODE, DEPARTMENT:DEPT_ID)
--      JOIN ON으로만 사용가능

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 두 컬럼명이 같은 경우(EMPLOYEE:JOB_CODE, JOB:JOB_CODE)
--      JOIN ON, JOIN USING 모두 사용 가능

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (JOB_CODE = JOB_CODE);      -- 오류

-- 해결방법1) 테이블명 또는 테이블에 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE);

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 해결방법2) JOIN USING 구문을 사용하는 방법(두 컬럼명이 일치할 때만 사용 가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

-- [참고사항]
-- 자연조인(NATURAL JOIN) : 각 테이블마다 동일한 컬럼이 한 개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- 3) 추가적인 조건도 제시 가능
-- 직급이 '대리'인 사원의 사번, 사원명, 직급명, 급여 조회
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
     AND JOB_NAME = '대리';

-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

--------------------------------------- <실습 문제>----------------------------------
-- 1. 부서가 인사관리부인 사원의 사번, 이름, 부서명, 보너스 조회
-- >> 오라클 구문 전용
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
     AND DEPT_TITLE = '인사관리부';
     
-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

-- 2. DEPARTMENT와 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-- >> 오라클 구문 전용
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- >> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- >> 오라클 구문 전용
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
     AND BONUS IS NOT NULL;
     
-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
-- >> 오라클 구문 전용
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
     AND DEPT_TITLE != '총무부' ;
     
-- >> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '총무부' ;

----------------------------------------------------------------------------------------------
/*
    2. 포괄조인 / 외부조인(OUTER JOIN)
        두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜 조회
        단, 반드시 LEFT/RIGHT를 지정해야됨(기준이 되는 테이블 지정)
*/
--  내부 조인시 부서배치가 안된 사원2명은 정보조회 안됨
--   사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼쪽에 기술된 테이블이 기준으로 JOIN
-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- 부서배치가 안된 사원도 조회됨

-->> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);  -- 기준이 아닌 테이블의 컬럼명 뒤에(+) 기호를 붙임

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블이 기준으로 JOIN
-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-->> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블에 기술된 모든 행을 조회(단, 오라클 전용 구문없음)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

----------------------------------------------------------------------------------------------
/*
    3. 비등가 조인(NON EQUAL JOIN)
        매칭시킬 컬럼에 대한 조건 작성시 '='(등호)를 사용하지 않는 JOIN문
        ANSI구문으로는 JOIN ON으로만 가능
*/
-- 사원명, 급여, 급여레벨 조회
--  >> 오라클 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
-- WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- >> ANSI 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

----------------------------------------------------------------------------------------------
/*
    4. 자체조인(SELF JOIN)
        같은 테이블을 다시 한번 조인하는 경우
*/

-- 사수가 있는 사원의 사번, 사원명, 직급코드 => EMPLOYEE
--                      사수의 사번, 사원명, 직급코드  => EMPLOYEE
--  >> 오라클 전용 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, 
              M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

--  >> ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, 
              M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);

-- 모든 사원의 사번, 사원명, 직급코드 => EMPLOYEE
--                   사수의 사번, 사원명, 직급코드  => EMPLOYEE
--  >> 오라클 전용 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, 
              M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);

--  >> ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, 
              M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);

----------------------------------------------------------------------------------------------
/*
    <다중 JOIN>
    2개 이상의 테이블을 JOIN
*/

-- 모든 사원의 사번, 사원명, 부서명, 직급명 조회
     /*
                                가져올 컬럼명                          JOIN될 컬럼명
    EMPLOYEE => EMP_ID, EMP_NAME        DEPT_CODE      JOB_CODE
    DEPARTMENT =>           DEPT_TITLE       DEPT_ID
    JOB  =>                           JOB_NAME                                  JOB_CODE
    */
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID
     AND E.JOB_CODE = J.JOB_CODE;

--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

-- 사원의 사번, 사원명, 부서명, 지역명 조회
     /*
                                가져올 컬럼명                          JOIN될 컬럼명
    EMPLOYEE => EMP_ID, EMP_NAME        DEPT_CODE      
    DEPARTMENT =>           DEPT_TITLE       DEPT_ID            LOCATION_ID
    LOCATION  =>                LOCAL_NAME                                LOCAL_CODE
    */
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
     AND LOCATION_ID = LOCAL_CODE;
     
--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

------------------------------------------  실습 문제  -------------------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회(EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL 조인)
    /*
    EMPLOYEE            DEPT_CODE
    DEPARTMENT       DEPT_ID            LOCATION_ID
    LOCATION                                        LOCAL_CODE          NATIONAL_CODE 
    NATIONAL                                                                        NATIONAL_CODE     
    */
    
-- >> 오라클 구문
SELECT EMP_ID, EMP_ID, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID
     AND LOCATION_ID = LOCAL_CODE
     AND L.NATIONAL_CODE = N.NATIONAL_CODE;
     
-- >> ANSI구문
SELECT EMP_ID, EMP_ID, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE);

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회 (모든 테이블 다 조인)
    /*
    EMPLOYEE            DEPT_CODE	        JOB_CODE					                                                            SALARY
    DEPARTMENT       DEPT_ID            	                            LOCATION_ID
    JOB					                                    JOB_CODE
    LOCATION                                                                        LOCAL_CODE          NATIONAL_CODE 
    NATIONAL                                                                                                        NATIONAL_CODE 
    SAL_GRADE										                                                                                                    MIN_SAL,MAX_SAL    
    */
-- >> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE DEPT_CODE = DEPT_ID
     AND E.JOB_CODE = J.JOB_CODE
     AND LOCATION_ID = LOCAL_CODE
     AND L.NATIONAL_CODE = N.NATIONAL_CODE
     AND SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- >> ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);