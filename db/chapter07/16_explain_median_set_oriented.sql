-- ================================================
-- ファイル名: 16_explain_median_set_oriented.sql
-- 役割:
--   リスト8.12の集合指向型メジアンSQLの実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     候補値側 W1
--     母集合側 W2
--     GROUP BY
--     HAVING
--     外側の AVG
--   をどう処理するかを見ること。
--
-- 今回の最重要ポイント:
--   このSQLは
--     候補値ごとに母集合全体を見て判定する
--   構造なので、
--   実行計画では
--     Weights の2回参照
--     GROUP BY
--     HAVING
--     派生表 TMP
--   が見える可能性が高い。
-- ================================================

EXPLAIN
SELECT AVG(TMP.weight) AS median_weight
  FROM
  (
      SELECT W1.weight
        FROM Weights AS W1
       CROSS JOIN Weights AS W2
       GROUP BY W1.weight
      HAVING
             SUM(CASE WHEN W2.weight >= W1.weight THEN 1 ELSE 0 END)
             >= COUNT(*) / 2
         AND SUM(CASE WHEN W2.weight <= W1.weight THEN 1 ELSE 0 END)
             >= COUNT(*) / 2
  ) AS TMP;

-- ================================================
-- 実行計画で見たいポイント
-- ================================================
--
-- 1. Weights が2回出るか
--    -> W1 は候補値側
--    -> W2 は母集合側
--
-- 2. 派生表 TMP が見えるか
--    -> まず中央値候補を作ってから
--       外側で AVG を取る二段構造になっているため
--
-- 3. GROUP BY / HAVING に伴う
--      Using temporary
--      Using filesort
--    などが出るか
--
-- 4. CROSS JOIN により、
--    候補値ごとに全体分布を見る構造が
--    実行計画にどう現れるか
--
-- ================================================