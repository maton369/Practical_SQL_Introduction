-- ================================================
-- ファイル名: 24_explain_select_threeelements_in_by_row_constructor.sql
-- 役割:
--   IN 版の検索が MySQL でどのように実行されるかを確認する。
--
-- このSQLの目的:
--   UNION 版・OR 版と比較して、
--   IN 版がどのようなアクセス方式になるかを見ること。
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
    ('2013-11-01', 'T')
    IN (
        (date_1, flg_1),
        (date_2, flg_2),
        (date_3, flg_3)
    );

-- この EXPLAIN で確認したいポイント:
--
-- 1. 全表走査かどうか
-- 2. どのインデックスが使われるか
-- 3. UNION 版のように枝ごとの専用インデックス利用が見えるか
--
-- この比較により、
--   読みやすさ重視の IN 版
--   索引活用を明示しやすい UNION 版
-- の違いが分かりやすくなる。