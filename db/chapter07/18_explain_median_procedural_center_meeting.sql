-- ================================================
-- ファイル名: 18_explain_median_procedural_center_meeting.sql
-- 役割:
--   リスト8.13の手続き型メジアンSQLの実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     2本の ROW_NUMBER() 計算
--     派生表 TMP の生成
--     hi / lo 条件による絞り込み
--     外側の AVG(weight)
--   をどう処理するかを見ること。
--
-- 学習上の主題:
--   - ウィンドウ関数を2本使う場合の EXPLAIN の見方
--   - 昇順・降順の順位計算に伴うソート
--   - 派生表を先に作ってからフィルタする構造
--
-- 今回の最重要ポイント:
--   このSQLは
--     hi 用の昇順ソート
--     lo 用の降順ソート
--   という2方向の順位計算を持つ。
--
--   そのため実行計画では
--     DERIVED
--     Using filesort
--     Using temporary
--   などが現れる可能性がある。
--
--   重要なのは、
--   このSQLが
--     先に各行へ左右順位を付ける
--     その後で中央条件により絞る
--   という二段構造である点である。
-- ================================================

EXPLAIN
SELECT AVG(weight) AS median
  FROM
       (
           SELECT weight,
                  ROW_NUMBER() OVER (ORDER BY weight ASC, student_id ASC) AS hi,
                  ROW_NUMBER() OVER (ORDER BY weight DESC, student_id DESC) AS lo
             FROM Weights
       ) TMP
 WHERE hi IN (lo, lo + 1, lo - 1);

-- ================================================
-- 実行計画で見たいポイント
-- ================================================
--
-- 1. 派生表 TMP の生成
--    -> まず hi, lo 付きの中間表を作る構造なので
--       DERIVED が見えやすい
--
-- 2. 2本の ROW_NUMBER() の計算
--    -> 昇順と降順の両方が必要なので
--       ソート系の Extra が出る可能性がある
--
-- 3. 外側の WHERE hi IN (lo, lo+1, lo-1)
--    -> 派生表に対して中央候補だけを残すフィルタ
--
-- 4. 最後の AVG(weight)
--    -> 中央候補に残った1行または2行の平均を取る
-- ================================================