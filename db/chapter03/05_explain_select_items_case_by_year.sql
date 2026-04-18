-- ================================================
-- ファイル名: 05_explain_select_items_case_by_year.sql
-- 役割:
--   CASE 版の SELECT が MySQL でどのように実行されるかを確認する。
--
-- このSQLの目的:
--   先ほどの UNION ALL 版と比較するために、
--   CASE 版の実行計画を EXPLAIN で確認すること。
--
-- 学習上の主題:
--   EXPLAIN を使って、
--   SQL の「見た目」ではなく
--   実行方法を確認する習慣を身につけること。
-- ================================================

EXPLAIN
SELECT
    item_name,
    year,
    CASE
        WHEN year <= 2001 THEN price_tax_ex
        WHEN year >= 2002 THEN price_tax_in
    END AS price
FROM
    Items;

-- EXPLAIN は、MySQL が SELECT / UPDATE / DELETE などを
-- どのように実行するかを見るための仕組みである。  [oai_citation:9‡MySQL Developer Zone](https://dev.mysql.com/doc/en/explain-output.html?utm_source=chatgpt.com)
--
-- 今回は、
--   CASE 版が 1 本の SELECT としてどう処理されるか
-- を確認するために使う。
--
-- UNION ALL 版と見比べることで、
--   query block の数
--   テーブル参照の見え方
-- などを比較しやすくなる。これは EXPLAIN の用途に沿った確認方法である。  [oai_citation:10‡MySQL Developer Zone](https://dev.mysql.com/doc/en/union.html?utm_source=chatgpt.com)