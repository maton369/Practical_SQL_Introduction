-- ================================================
-- ファイル名: 17_explain_join_then_group.sql
-- 役割:
--   リスト7.9「結合を先に行う」SQL の実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     JOIN
--     WHERE
--     GROUP BY
--   をどう順に処理しているかを見ること。
--
-- 学習上の主題:
--   - JOIN先行型クエリの EXPLAIN の見方
--   - 集約が結合後に行われる構造
--   - GROUP BY がどの段階で効くか
--
-- 今回の最重要ポイント:
--   このSQLでは、
--   GROUP BY の前に
--   「Companies と Shops の結合結果」
--   ができる。
--
--   つまり実行計画でも、
--   まず両表アクセスと JOIN が見え、
--   その後に集約処理の痕跡
--   （Using temporary / filesort など）が
--   出る可能性がある。
--
--   これが
--   「集約を先に行う」版との比較ポイントになる。
-- ================================================

EXPLAIN
SELECT
       C.co_cd,
       C.district,
       SUM(emp_nbr) AS sum_emp
  FROM Companies C
       INNER JOIN Shops S
         ON C.co_cd = S.co_cd
 WHERE main_flg = 'Y'
 GROUP BY C.co_cd;