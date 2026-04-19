-- ================================================
-- ファイル名: 15_explain_select_employees_case_by_count.sql
-- 役割:
--   CASE 版の社員兼務分類SQLが
--   MySQLでどのように実行されるかを確認する。
--
-- このSQLの目的:
--   先ほどの UNION 版と比較するために、
--   CASE 版の実行計画を EXPLAIN で確認すること。
--
-- 学習上の主題:
--   SQL の見た目だけでなく、
--   実行計画を見て
--     集約回数
--     表参照の構造
--     query block の数
--   を比較する習慣を身につけること。
-- ================================================

EXPLAIN
SELECT
    emp_name,
    CASE
        WHEN COUNT(*) = 1 THEN MAX(team)
        WHEN COUNT(*) = 2 THEN '2つを兼務'
        WHEN COUNT(*) >= 3 THEN '3つ以上を兼務'
    END AS team
FROM
    Employees
GROUP BY
    emp_name;

-- この EXPLAIN によって確認したいポイント:
--
-- 1. CASE 版が何本の query block で処理されるか
-- 2. Employees 表をどう読むか
-- 3. GROUP BY がどのような形で行われるか
--
-- 先ほどの UNION 版は、
--   同種の集約を複数回行い、それを UNION で結合する構造だった。
--
-- 一方、この CASE 版は、
--   1回の GROUP BY 結果に対して
--   CASE で表示内容を分岐する構造である。
--
-- そのため、一般には
--   UNION 版より実行計画が単純になりやすい
-- と考えられる。
--
-- 実際に EXPLAIN を比較することで、
--   CASE 版が
--     単純な集約
--   として見えるのか、
--   UNION 版が
--     複数段階の処理
--   として見えるのかを確認できる。