-- ================================================
-- ファイル名: 10_explain_select_population_case_aggregate.sql
-- 役割:
--   CASE 集約版の SQL が MySQL でどのように実行されるかを確認する。
--
-- このSQLの目的:
--   先ほどの UNION 版と比較するために、
--   CASE 集約版の実行計画を EXPLAIN で確認すること。
--
-- 学習上の主題:
--   「SQL の見た目」だけでなく、
--   実行計画を見て処理構造を比較する習慣をつけること。
-- ================================================

EXPLAIN
SELECT
    prefecture,
    SUM(CASE WHEN sex = '1' THEN pop ELSE 0 END) AS pop_men,
    SUM(CASE WHEN sex = '2' THEN pop ELSE 0 END) AS pop_wom
FROM
    Population
GROUP BY
    prefecture;

-- EXPLAIN は、MySQL が SELECT などをどのように実行するかを示す。 [oai_citation:8‡MySQL Developer Zone](https://dev.mysql.com/doc/refman/8.0/ja/explain-output.html?utm_source=chatgpt.com)
--
-- 今回は、
--   CASE 集約版が
--   何本の query block で処理されるか
--   どの表をどう読むか
-- を確認するために使う。
--
-- UNION は複数の query block を組み合わせる集合演算なので、 [oai_citation:9‡MySQL Developer Zone](https://dev.mysql.com/doc/refman/8.0/ja/union.html?utm_source=chatgpt.com)
-- CASE 集約版との違いは EXPLAIN によって比較しやすい。
--
-- さらに、より実測に近い比較をしたい場合は
--   EXPLAIN ANALYZE
-- も有用である。MySQL 8.0.18 以降で利用できる。 [oai_citation:10‡MySQL Developer Zone](https://dev.mysql.com/doc/refman/8.0/en/mysql-nutshell.html?spm=a2c6h.13046898.publish-article.15.2c056ffaKTA1tv&utm_source=chatgpt.com)