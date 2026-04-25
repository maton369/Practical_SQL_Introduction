-- ================================================
-- ファイル名: 02_insert_receipts_sample_data.sql
-- 役割:
--   Receipts テーブルへ購入明細のサンプルデータを投入する。
--
-- このSQLの目的:
--   顧客ごとに複数の購入明細を持つデータを準備し、
--   後続のサブクエリで
--     顧客ごとの最初の購入明細
--   を抽出できるようにすること。
--
-- 学習上の主題:
--   - 顧客ごとに複数行あるデータ構造
--   - MIN(seq) の意味
--   - サブクエリがどういう中間結果を返すかの理解
--
-- 今回の最重要ポイント:
--   このデータでは、
--   各顧客について seq が複数存在する。
--
--   したがって
--     cust_id ごとに MIN(seq) を求める
--   と、
--   その顧客の最初の購入明細番号が取れる。
--
--   後続のサブクエリはまさにそこを計算する。
-- ================================================

INSERT INTO Receipts VALUES ('A',  1,   500 );
INSERT INTO Receipts VALUES ('A',  2,  1000 );
INSERT INTO Receipts VALUES ('A',  3,   700 );

INSERT INTO Receipts VALUES ('B',  5,   100 );
INSERT INTO Receipts VALUES ('B',  6,  5000 );
INSERT INTO Receipts VALUES ('B',  7,   300 );
INSERT INTO Receipts VALUES ('B',  9,   200 );
INSERT INTO Receipts VALUES ('B', 12,  1000 );

INSERT INTO Receipts VALUES ('C', 10,   600 );
INSERT INTO Receipts VALUES ('C', 20,   100 );
INSERT INTO Receipts VALUES ('C', 45,   200 );
INSERT INTO Receipts VALUES ('C', 70,    50 );

INSERT INTO Receipts VALUES ('D',  3,  2000 );

-- ================================================
-- データの見方
-- ================================================
--
-- 顧客 A:
--   (1, 500)
--   (2, 1000)
--   (3, 700)
--   -> 最小 seq は 1
--
-- 顧客 B:
--   (5, 100)
--   (6, 5000)
--   (7, 300)
--   (9, 200)
--   (12, 1000)
--   -> 最小 seq は 5
--
-- 顧客 C:
--   (10, 600)
--   (20, 100)
--   (45, 200)
--   (70, 50)
--   -> 最小 seq は 10
--
-- 顧客 D:
--   (3, 2000)
--   -> 最小 seq は 3
--
-- したがって後続の最終結果は概ね
--
--   A 1 500
--   B 5 100
--   C 10 600
--   D 3 2000
--
-- になるはずである。
--
-- ここで大事なのは、
--   「最小 seq は分かるが、その行の price は元表に戻らないと分からない」
-- という点である。
--
-- これが後続のサブクエリ + INNER JOIN の設計理由である。