-- ================================================
-- ファイル名: 19_explain_group_then_join.sql
-- 役割:
--   リスト7.10「集約を先に行う」SQL の実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     Shops のフィルタ
--     Shops の GROUP BY
--     集約表 CSUM の生成
--     最後の JOIN
--   をどう処理するかを見ること。
--
-- 学習上の主題:
--   - 集約先行型クエリの EXPLAIN の見方
--   - 派生表(DERIVED)が集約済み表として見えること
--   - JOIN 入力サイズの違い
--
-- 今回の最重要ポイント:
--   このSQLでは、
--   JOIN の前に
--   Shops が co_cd ごとに縮約される。
--
--   したがって実行計画では
--     派生表 CSUM の生成
--   が先に見え、
--   その後に Companies と JOIN する形が現れやすい。
--
--   つまり
--     結合先行型
--   と比べて
--     JOIN に入る前の段階でデータ量が減っている
--   という構造を意識して読むのが重要である。
-- ================================================

EXPLAIN
SELECT
       C.co_cd,
       C.district,
       sum_emp
  FROM Companies C
       INNER JOIN
       (
           SELECT
                  co_cd,
                  SUM(emp_nbr) AS sum_emp
             FROM Shops
            WHERE main_flg = 'Y'
            GROUP BY co_cd
       ) CSUM
         ON C.co_cd = CSUM.co_cd;