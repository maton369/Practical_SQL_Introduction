-- ================================================
-- ファイル名: 20_explain_select_threeelements_union_by_each_element.sql
-- 役割:
--   ThreeElements に対する UNION 検索が
--   MySQL でどのように実行されるかを確認する。
--
-- このSQLの目的:
--   各 SELECT が
--     IDX_1
--     IDX_2
--     IDX_3
-- を個別に使えているかを EXPLAIN で確認すること。
--
-- 学習上の主題:
--   「このケースでは UNION が有効」と言うだけでなく、
--   実行計画からその根拠を確認すること。
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
    date_1 = '2013-11-01'
    AND flg_1 = 'T'

UNION

SELECT
    `key`, name,
    date_1, flg_1,
    date_2, flg_2,
    date_3, flg_3
FROM
    ThreeElements
WHERE
    date_2 = '2013-11-01'
    AND flg_2 = 'T'

UNION

SELECT
    `key`, name,
    date_1, flg_1,
    date_2, flg_2,
    date_3, flg_3
FROM
    ThreeElements
WHERE
    date_3 = '2013-11-01'
    AND flg_3 = 'T';

-- この EXPLAIN で確認したいポイント:
--
-- 1. UNION の各枝が別 query block として見えるか
-- 2. 1本目が IDX_1 を使うか
-- 3. 2本目が IDX_2 を使うか
-- 4. 3本目が IDX_3 を使うか
--
-- もし各枝が対応インデックスを使っていれば、
-- このケースでは
--   UNION に分けることが
--   各列ペア専用インデックスの活用につながっている
-- と判断しやすい。
--
-- つまり今回の主張は、
--   「UNION は遅い」
-- ではなく、
--   「このように異なる複合インデックス条件を持つ横持ち表では、
--     UNION に分けることが有効になりやすい」
-- という点にある。