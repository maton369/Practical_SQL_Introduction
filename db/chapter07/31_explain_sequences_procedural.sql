-- ================================================
-- ファイル名: 31_explain_sequences_procedural.sql
-- 役割:
--   リスト8.20「シーケンスを求める（手続き型）」について、
--   MySQL の実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     前後差分の計算
--     low/high の生成
--     high の後方補完
--     low IS NOT NULL の絞り込み
--   をどう処理するかを見ること。
--
-- 学習上の主題:
--   - 多段サブクエリ型ウィンドウSQLの EXPLAIN の見方
--   - 派生表 TMP1/TMP2/TMP3 相当の生成順序
--   - 前後行参照 + 後方探索という手続き構造
--   - 集合指向型シーケンス抽出との比較
--
-- 今回の最重要ポイント:
--   このSQLは多段構造であり、
--   実行計画でも
--     DERIVED
--     Using temporary
--     Using filesort
--   などが複数段に現れる可能性がある。
--
--   特に
--     TMP1: 前後差分 + seq
--     TMP2: low/high の立ち上げ
--     TMP3: high の補完
--   という段階が、
--   実行計画にどう反映されるかを見るのが重要である。
-- ================================================

EXPLAIN
SELECT low, high
  FROM
       (
           SELECT low,
                  CASE
                      WHEN high IS NULL
                      THEN MIN(high) OVER (
                               ORDER BY seq
                               ROWS BETWEEN CURRENT ROW
                                        AND UNBOUNDED FOLLOWING
                           )
                      ELSE high
                  END AS high
             FROM
                  (
                      SELECT CASE
                                 WHEN COALESCE(prev_diff, 0) <> 1
                                 THEN num ELSE NULL
                             END AS low,
                             CASE
                                 WHEN COALESCE(next_diff, 0) <> 1
                                 THEN num ELSE NULL
                             END AS high,
                             seq
                        FROM
                             (
                                 SELECT num,
                                        MAX(num) OVER (
                                            ORDER BY num
                                            ROWS BETWEEN 1 FOLLOWING
                                                     AND 1 FOLLOWING
                                        ) - num AS next_diff,
                                        num - MAX(num) OVER (
                                                  ORDER BY num
                                                  ROWS BETWEEN 1 PRECEDING
                                                           AND 1 PRECEDING
                                              ) AS prev_diff,
                                        ROW_NUMBER() OVER (ORDER BY num) AS seq
                                   FROM Numbers
                             ) TMP1
                  ) TMP2
       ) TMP3
 WHERE low IS NOT NULL;

-- ================================================
-- 実行計画で見たいポイント
-- ================================================
--
-- 1. TMP1 相当の生成
--    -> Numbers から
--       next_diff / prev_diff / seq
--       を作る段階
--
-- 2. TMP2 相当の生成
--    -> CASE により low / high を立てる段階
--
-- 3. TMP3 相当の生成
--    -> MIN(high) OVER (...) で後方補完する段階
--
-- 4. 最外 WHERE low IS NOT NULL
--    -> 区間開始行だけを残すフィルタ
--
-- 5. Using temporary / Using filesort
--    -> ORDER BY num や ORDER BY seq を伴う
--       ウィンドウ関数処理のコスト構造
--
-- 6. リスト8.19との比較
--    -> 8.19 は gp によるグループ化で一気に区間化
--    -> 8.20 は境界検出と対応付けを段階的に進める
--
--    つまり
--      不変量グループ化型
--    と
--      境界対応付け型
--    の違いが実行計画にどう表れるかを見る
-- ================================================