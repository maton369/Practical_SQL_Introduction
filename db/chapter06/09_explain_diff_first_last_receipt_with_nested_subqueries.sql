-- ================================================
-- ファイル名: 09_explain_diff_first_last_receipt_with_nested_subqueries.sql
-- 役割:
--   リスト7.5の多重サブクエリ版について、
--   MySQL の実行計画を確認する。
--
-- このSQLの目的:
--   DBMS が
--     TMP_MIN の生成
--     TMP_MAX の生成
--     それぞれの内側の集約
--     最後の JOIN
--   をどう処理するかを見ること。
--
-- 学習上の主題:
--   - 多層サブクエリの EXPLAIN の読み方
--   - 派生表(DERIVED)や一時表の見え方
--   - 集約サブクエリ + 元表復元 + 再JOIN の構造
--   - ウィンドウ関数版との実行計画上の違い
--
-- 今回の最重要ポイント:
--   このSQLは段階が多いため、
--   実行計画でも
--     先に集約
--     次に元表へ JOIN
--     さらに派生表どうしを JOIN
--   という複数段階が見えやすい。
--
--   つまり
--     「最初の代表行を作る系統」
--     「最後の代表行を作る系統」
--   が2本並走し、
--   最後に合流する構造を意識して読むことが重要である。
-- ================================================

EXPLAIN
SELECT
       TMP_MIN.cust_id,
       TMP_MIN.price - TMP_MAX.price AS diff
  FROM
       (
           SELECT
                  R1.cust_id,
                  R1.seq,
                  R1.price
             FROM Receipts R1
                  INNER JOIN
                  (
                      SELECT
                             cust_id,
                             MIN(seq) AS min_seq
                        FROM Receipts
                       GROUP BY cust_id
                  ) R2
                    ON R1.cust_id = R2.cust_id
                   AND R1.seq     = R2.min_seq
       ) TMP_MIN
       INNER JOIN
       (
           SELECT
                  R3.cust_id,
                  R3.seq,
                  R3.price
             FROM Receipts R3
                  INNER JOIN
                  (
                      SELECT
                             cust_id,
                             MAX(seq) AS min_seq
                        FROM Receipts
                       GROUP BY cust_id
                  ) R4
                    ON R3.cust_id = R4.cust_id
                   AND R3.seq     = R4.min_seq
       ) TMP_MAX
         ON TMP_MIN.cust_id = TMP_MAX.cust_id;

-- ================================================
-- 実行計画で見たいポイント
-- ================================================
--
-- 1. TMP_MIN 側の処理
--   a. cust_id ごとの MIN(seq) 集約
--   b. その結果を元表 R1 に JOIN
--
-- 2. TMP_MAX 側の処理
--   a. cust_id ごとの MAX(seq) 集約
--   b. その結果を元表 R3 に JOIN
--
-- 3. 最終段階
--   TMP_MIN と TMP_MAX を cust_id で結合する
--
-- 4. EXPLAIN 上では
--   DERIVED や一時的な中間表の生成が見える可能性がある。
--
-- つまりこのSQLは、
--   「集約 -> 元行復元」
-- を2回やってから
--   「代表行どうしを結合」
-- する構造であり、
--   その段階性が計画にも出やすい。
--
-- 重要なのは、
--   1本の単純な SELECT ではなく、
--   複数の中間表を順に組み立てるクエリ
-- だという点である。