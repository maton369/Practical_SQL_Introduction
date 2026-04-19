-- ================================================
-- ファイル名: 26_explain_select_threeelements_case_in_where.sql
-- 役割:
--   CASE 版の検索が MySQL でどのように実行されるかを確認する。
--
-- このSQLの目的:
--   UNION 版・OR 版・IN 版と比較して、
--   CASE 版がどのようなアクセス方式になるかを見ること。
-- ================================================

EXPLAIN
SELECT
    `key`, name,
    date_1, flg_1,
    date_2, flg_2,
    date_3, flg_3
FROM
    ThreeElements
WHERE
    CASE
        WHEN date_1 = '2013-11-01' THEN flg_1
        WHEN date_2 = '2013-11-01' THEN flg_2
        WHEN date_3 = '2013-11-01' THEN flg_3
        ELSE NULL
    END = 'T';

-- この EXPLAIN で確認したいポイント:
--
-- 1. CASE 版が全表走査になるか
-- 2. どのインデックスが使われるか
-- 3. UNION 版のような枝ごとの専用索引利用が見えるか
--
-- 比較の観点としては、
--   UNION 版:
--     複数枝 + 各枝で専用インデックス
--
--   CASE 版:
--     1本の式評価
--
-- の違いを見ることが重要である。