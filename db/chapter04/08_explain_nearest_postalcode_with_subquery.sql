-- ================================================
-- ファイル名: 08_explain_nearest_postalcode_with_subquery.sql
-- 役割:
--   リスト5.7のサブクエリ版について、
--   MySQL の実行計画を確認する。
--
-- このSQLの目的:
--   実際に DBMS が
--     外側クエリ
--     内側サブクエリ
--   をどう処理しているかを見ること。
--
-- 学習上の主題:
--   - EXPLAIN の見方
--   - サブクエリが独立に評価される構造
--   - CASE / LIKE により pcode 主キー索引を直接使いにくいこと
--
-- 今回の最重要ポイント:
--   このクエリは
--     pcode を CASE で採点してから MIN を取る
--   ため、
--   単純な主キー等値検索のようには動きにくい。
--
--   そのため実行計画では、
--   PostalCode を走査して score を計算する形が見えやすい。
-- ================================================

EXPLAIN
SELECT
       pcode,
       district_name
  FROM PostalCode
 WHERE
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
       =
       (
           SELECT
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
             FROM PostalCode
       );

-- ================================================
-- 実行計画で見たいポイント
-- ================================================
--
-- 1. 外側の PostalCode 走査
--   各行について CASE を評価するため、
--   行走査が発生しやすい。
--
-- 2. 内側サブクエリの PostalCode 走査
--   MIN(score) を求めるため、
--   こちらでも PostalCode を評価する。
--
-- 3. 主キー pcode があるのに、
--   CASE + LIKE の複合採点なので
--   単純な主キー検索になりにくい。
--
-- 4. テーブルサイズが大きくなると、
--   外側 + 内側で2回 score 計算が走る構造になる。
--
-- つまりこのサブクエリ版は、
--   ロジックは素直だが
--   「同じ採点を2回行う」
-- ところが性能上の論点になりやすい。
--
--
-- ================================================
-- 実行後の読み方の例
-- ================================================
--
-- もし
--   type = ALL
-- のような表示が見えたら、
--   全表走査に近い形で見ている
-- と解釈しやすい。
--
-- もし
--   select_type に PRIMARY / SUBQUERY
-- のような区別が出たら、
--   外側と内側が分かれて評価されている
-- ことが見やすい。
--
-- 重要なのは、
--   このSQLは「最小 rank を先に求めてから比較する」
--   二段構造
-- だという点である。
-- ================================================