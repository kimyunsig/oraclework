/*
    - 서브쿼리(SUBQUERY)
      하나의 SQL문 안에 포함된 또다른 SELECT문
      메인 SQL문의 보조 역할을 하는 쿼리문
*/

-- 박정보 사원과 같은 부서에 속한 사원들 조회
-- 1. 박정보 사원 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '박정보';

-- 2. 부서코드가 'D9'인 사원의 정보 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- > 위의 두 쿼리문을 하나로 하면
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                      WHERE EMP_NAME = '박정보');
                                      
-- 전 직원의 평균급여보다 급여를 더 많이 받는 사원의 사번, 사원명, 급여, 직급코드 조회
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                                    FROM EMPLOYEE);

--------------------------------------------------------------------------------------------------------
/*
    - 서브쿼리의 구분
      서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 분류
      
      * 단일행 서브쿼리 : 서버쿼리의 조회 결과값이 오로지 1개일 때(1행 1열)
      * 다중행 서브쿼리 : 서버쿼리의 조회 결과값이 여러행 일 때(여러행 1열)
      * 다중열 서브쿼리 : 서버쿼리의 조회 결과값이 여러열 일 때(1행 여러열)
      * 다중행 다중열 서브쿼리 : 서버쿼리의 조회 결과값이 여러행 여러열 일 때(여러행 여러열)
      
      >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
        서버쿼리의 조회 결과값이 오로지 1개일 때(1행 1열)
        
        일반 비교연산자 사용 가능
        =, !=, > , < ...
*/
-- 1) 전 직원의 평균급여보다 급여를 적게 받는 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                                FROM EMPLOYEE)
ORDER BY SALARY;

-- 2) 최저 급여를 받는 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                                FROM EMPLOYEE);
                                
-- 3) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박정보');

-- JOIN + SUBQUERY
-- 4) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 부서이름, 급여 조회
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박정보')
     AND DEPT_CODE = DEPT_ID;
     
--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박정보');

-- 5) 왕정보 사원과 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회 단, 왕정보는 제외
-- >>  오라클 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
     AND DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                      WHERE EMP_NAME = '왕정보')
    AND EMP_NAME != '왕정보';
    
-- >>  ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                      WHERE EMP_NAME = '왕정보')
    AND EMP_NAME != '왕정보';
    
-- GROUP + SUBQUERY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--     6.1.  부서별 급여합 중 가장 큰 값 조회
/*
SELECT DEPT_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 급여합 DESC;
*/

SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--     6.2 부서별 급여합이 17,700,000 인 부서 조회
SELECT DEPT_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

--  >> 위 2개를 합치면
SELECT DEPT_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                                            FROM EMPLOYEE
                                          GROUP BY DEPT_CODE);
                                          
--------------------------------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
        서버쿼리의 조회 결과값이 여러행 일 때(여러행 1열)
        - IN 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면
        
        -   > ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 클 경우
               ( 여러개의 결과값 중 가장 작은값 보다 클 경우)
        -   < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은 경우
               ( 여러개의 결과값 중 가장 큰값 보다 작을 경우)
               
        비교대상 > ANY(값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/
-- 1) 조정연 또는 전지연과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여
--   1.1 조정연 또는 전지연이 어떤 직급 인지 조회
SELECT JOB_CODE
FROM EMPLOYEE
-- WHERE EMP_NAME = '조정연' OR EMP_NAME = '전지연';
WHERE EMP_NAME IN ('조정연','전지연');

--    1.2 직급코드가 J3, J7인 사원의 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                                       FROM EMPLOYEE
                                     WHERE EMP_NAME IN ('조정연','전지연'));

--  대표 => 부사장 => 부장  =>  차장 => 과장 => 대리 => 사원
--  2) 대리 직급임에도 불구하고 과장직급의 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급명, 급여조회
--     2.1 과장 직급인 사원들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';    -- 2,200  ,  2,500,   3,760

--     2.2 직급이 대리이면서 급여가 위의 목록값 중에 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
     AND SALARY > ANY(SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME = '과장');

-- 단일행 서브쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
     AND SALARY > (SELECT MIN(SALARY)
                                FROM EMPLOYEE
                                JOIN JOB USING(JOB_CODE)
                                WHERE JOB_NAME = '과장');

-- 3) 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장'
     AND SALARY < ANY (SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME = '과장');   -- 220  ,  250,   376

--4)  과장직급임에도 불구하고 차장직급인 사원들의 
--     모든 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급명, 급여조회
-- ANY : 차장의 가장 적게받는 급여보다 많이 받는 과장
--          비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'     -- 220  ,  250,   376
     AND SALARY > ANY(SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME='차장');    -- 280, 155, 249, 248

-- ALL : 서브쿼리의 값들중 가장 큰값보다 더 큰값을 얻어올 때
--          비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
-- 차장의 가장 많이 받는 급여보다 더 많이 과장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'     -- 220  ,  250,   376
     AND SALARY > ALL(SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME='차장');     -- 280, 155, 249, 248

--------------------------------------------------------------------------------------------------------
/*
    3.  다중열 서브쿼리
        결과값이 한행이면서 여러 컬럼일 때
*/
-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사번, 사원명, 부서코드, 직급코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = '장정보의 부서코드'
     AND JOB_CODE = '장정보의 직급코드';

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE EMP_NAME = '장정보')
     AND JOB_CODE = (SELECT JOB_CODE
                                        FROM EMPLOYEE
                                        WHERE EMP_NAME = '장정보');
                                        
-- 다중열 서브쿼리로
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                                            FROM EMPLOYEE
                                                            WHERE EMP_NAME = '장정보');

-- 지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                                                FROM EMPLOYEE
                                                              WHERE EMP_NAME = '지정보');

--------------------------------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
       서브쿼리 결과 여러행, 여러열일 경우
*/
-- 1) 각 직급별 최소급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회
--    1.1 각 직급별로 최소급여를 받는 사원의 직급코드, 최소급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;
/*
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J5' AND SALARY = 2200000
       OR JOB_CODE = 'J6' AND SALARY = 2000000;
       
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J5', 2200000)  
                .. 7번 수행
*/

-- 서브쿼리로 하면
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                                        FROM EMPLOYEE
                                                      GROUP BY JOB_CODE);
                                                      
 -- 2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회                                                     
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                                           FROM EMPLOYEE
                                                         GROUP BY DEPT_CODE);

--------------------------------------------------------------------------------------------------------
/*
    5. 인라인 뷰(INLINE VIEW)
        FROM절에 서브쿼리를 작성
        
        서브쿼리를 수행한 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스포함연봉, 부서코드 조회
--      조건 1. 보너스 포함 연봉이 NULL이 나오지 않도록
--      조건 2. 보너스 포함 연봉이 3000만원 이상인 사원들만 조회

SELECT EMP_ID, EMP_NAME, SALARY * NVL((1+BONUS), 1)  *12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY * NVL((1+BONUS), 1)  *12 >= 30000000;

SELECT *
FROM (SELECT EMP_ID, EMP_NAME, SALARY * NVL((1+BONUS), 1)  *12 연봉, DEPT_CODE
              FROM EMPLOYEE)
WHERE 연봉 >= 30000000;


SELECT EMP_ID, EMP_NAME, 연봉
FROM (SELECT EMP_ID, EMP_NAME, SALARY * NVL((1+BONUS), 1)  *12 연봉, DEPT_CODE
              FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

-- 인라인 뷰에 없는 컬럼은 가져올 수 없다
SELECT EMP_ID, EMP_NAME, 연봉, JOB_CODE
FROM (SELECT EMP_ID, EMP_NAME, SALARY * NVL((1+BONUS), 1)  *12 연봉, DEPT_CODE
              FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

--  인라인 뷰를 주로 사용하는 곳 => TOP-N분석(상위 몇위만 가져오기)

-- 전 직원 중 급여 가장 높은 상위 5명만 조회
--  * ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 부여해줌

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY;

-- 순서때문에 내가 원하는 결과 나오지 않음
--  먼저 정렬(ORDER BY) 한 테이블을 만들고
--  그 테이블에서 ROWNUM을 부여

SELECT *
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
                FROM EMPLOYEE
             ORDER BY SALARY DESC);   

SELECT ROWNUM, EMP_NAME, SALARY, DEPT_CODE
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
                FROM EMPLOYEE
             ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

-- 인라인 뷰의 모든컬럼과 다른 컬럼(오라클에서 제공해 주는 컬럼)을 가져올때 테이블에 별칭 부여        
SELECT ROWNUM, T.*
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
                FROM EMPLOYEE
             ORDER BY SALARY DESC) T
WHERE ROWNUM <= 5;             

-- 가장 최근에 입사한 사원 5명의 ROWNUM, 사번, 사원명, 입사일 조회
SELECT ROWNUM, T.*
FROM (SELECT EMP_ID, EMP_NAME, HIRE_DATE
            FROM EMPLOYEE
            ORDER BY HIRE_DATE DESC) T
WHERE ROWNUM <= 5;

-- 각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회
SELECT *
FROM (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY 2 DESC)
WHERE ROWNUM <= 3;

--------------------------------------------------------------------------------------------------------
/*
    6. WITH
        서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
        
        -장점
           1. 같은 서브쿼리가 여러 번 사용될 경우 중복 작성을 피할 수 있다
           2. 실행속도도 빨라 짐
*/
WITH TOPN_SAL1 AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                                        FROM EMPLOYEE
                                     GROUP BY DEPT_CODE
                                     ORDER BY 평균급여 DESC)
                                     
SELECT *
FROM TOPN_SAL1
WHERE ROWNUM <= 5;

--------------------------------------------------------------------------------------------------------
/*
    7. 순위 매기는 함수(WINDOW FUNCTION)
        RANK() OVER(정렬기준)  |  DENSE_RANK() OVER(정렬기준)
       - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                                                  EX) 공동 1순위가 3명이면 그 다음 순위는 4위
       - DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
                                                                EX) 공동 1순위가 3명이면 그 다음 순위는 2위
      >> 두 함수는 무조건 SELECT절에서만 사용 가능          
*/
-- 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

-- 급여가 상위 5위까지 사원의 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- WHERE 순위 <= 5    실행순서 때문에 오류
-- WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;    
                        --  RANK() 함수는 SELECT절에서만 사용 그래서 오류

-- >> 인라인 뷰를 쓸 수밖에 없다
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
                FROM EMPLOYEE)
WHERE 순위 <= 5;

-- WITH로 사용
WITH TOPN_SAL5 AS (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
                                        FROM EMPLOYEE)

SELECT 순위, EMP_NAME, SALARY
FROM TOPN_SAL5
WHERE 순위 <= 5;