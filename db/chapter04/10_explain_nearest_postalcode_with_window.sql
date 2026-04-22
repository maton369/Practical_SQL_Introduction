-- ================================================
-- ファイル名: 10_explain_nearest_postalcode_with_window.sql
-- 役割:
--   リスト5.8のウィンドウ関数版について、
--   MySQL の実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     派生表 Foo
--     hit_code 計算
--     MIN OVER(...) 計算
--     外側 WHERE
--   をどう処理しているかを見ること。
--
-- 学習上の主題:
--   - EXPLAIN における派生表の見え方
--   - ウィンドウ関数でソートや一時領域が必要になる可能性
--   - サブクエリ版との構造比較
--
-- 今回の最重要ポイント:
--   このSQLはサブクエリ版のように
--   「同じ score を外と内で二重に計算する」形ではなく、
--   派生表の中で hit_code と min_code をまとめて作っている。
--
--   その代わり、
--   ウィンドウ関数の ORDER BY を評価するために
--   ソートやテンポラリ処理が出る可能性がある。
-- ================================================

EXPLAIN
SELECT
       pcode,
       district_name
  FROM
       (
           SELECT
                  pcode,
                  district_name,
                  CASE
                       WHEN pcode = '4130033' THEN 0
                       WHEN pcode LIKE '413003%' THEN 1
                       WHEN pcode LIKE '41300%'  THEN 2
                       WHEN pcode LIKE '4130%'   THEN 3
                       WHEN pcode LIKE '413%'    THEN 4
                       WHEN pcode LIKE '41%'     THEN 5
                       WHEN pcode LIKE '4%'      THEN 6
                       ELSE NULL
                  END AS hit_code,
                  MIN(
                      CASE
                           WHEN pcode = '4130033' THEN 0
                           WHEN pcode LIKE '413003%' THEN 1
                           WHEN pcode LIKE '41300%'  THEN 2
                           WHEN pcode LIKE '4130%'   THEN 3
                           WHEN pcode LIKE '413%'    THEN 4
                           WHEN pcode LIKE '41%'     THEN 5
                           WHEN pcode LIKE '4%'      THEN 6
                           ELSE NULL
                      END
                  )
                  OVER (
                      ORDER BY
                          CASE
                               WHEN pcode = '4130033' THEN 0
                               WHEN pcode LIKE '413003%' THEN 1
                               WHEN pcode LIKE '41300%'  THEN 2
                               WHEN pcode LIKE '4130%'   THEN 3
                               WHEN pcode LIKE '413%'    THEN 4
                               WHEN pcode LIKE '41%'     THEN 5
                               WHEN pcode LIKE '4%'      THEN 6
                               ELSE NULL
                          END
                  ) AS min_code
             FROM PostalCode
       ) Foo
 WHERE hit_code = min_code;

-- ================================================
-- 実行計画で見たいポイント
-- ================================================
--
-- 1. 派生表 Foo の生成
--   EXPLAIN では DERIVED や materialized 的な形で見えることがある。
--
-- 2. ウィンドウ関数の ORDER BY 評価
--   MIN OVER(ORDER BY ...) のために、
--   ソートや temporary が使われることがある。
--
-- 3. 外側 WHERE hit_code = min_code
--   派生表を作ったあとでフィルタする流れになりやすい。
--
-- 4. サブクエリ版との比較
--   サブクエリ版:
--     外側 + 内側の二段構造
--
--   ウィンドウ関数版:
--     派生表内で計算をまとめる構造
--
--   つまり性能上は
--     サブクエリ版は「二重計算」
--     ウィンドウ版は「ソート付きの一括計算」
--   という見え方をしやすい。
--
--
-- ================================================
-- 実行後の読み方の例
-- ================================================
--
-- もし
--   Extra に Using temporary
--   や filesort 的な情報
-- が見えたら、
--   ウィンドウ関数の並び順計算に伴う処理
-- と考えやすい。
--
-- もし
--   DERIVED
-- が見えたら、
--   派生表 Foo をいったん作ってから外側で絞っている
-- と理解しやすい。
--
-- 重要なのは、
--   このSQLは hit_code と min_code を同じ中間表で持たせる
--   という構造を取っている点である。
-- ================================================