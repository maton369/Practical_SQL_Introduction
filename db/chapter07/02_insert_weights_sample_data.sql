-- ================================================
-- ファイル名: 02_insert_weights_sample_data.sql
-- 役割:
--   Weights テーブルへサンプルデータを投入する。
--
-- このSQLの目的:
--   主キーが1列の表に対して、
--   student_id 順に連番を振る例を確認できるようにすること。
--
-- 学習上の主題:
--   - ORDER BY student_id の並び
--   - ROW_NUMBER と COUNT(*) の結果比較
--   - 体重値が重複していても student_id が一意なら順番を決められること
--
-- 今回の最重要ポイント:
--   weight には重複がある。
--
--   たとえば
--     55
--     72
--   は複数人で同じ値を持つ。
--
--   しかし今回は
--     weight で並べる
--   のではなく
--     student_id で並べる
--   ので、
--   体重の重複は問題にならない。
--
--   重要なのは
--     student_id が一意
--   である点である。
-- ================================================

INSERT INTO Weights VALUES('A100', 50);
INSERT INTO Weights VALUES('A101', 55);
INSERT INTO Weights VALUES('A124', 55);
INSERT INTO Weights VALUES('B343', 60);
INSERT INTO Weights VALUES('B346', 72);
INSERT INTO Weights VALUES('C563', 72);
INSERT INTO Weights VALUES('C345', 72);

-- ================================================
-- student_id 順に並べたときのイメージ
-- ================================================
--
-- ORDER BY student_id とすると、
-- 概ね次の順になる。
--
--   A100
--   A101
--   A124
--   B343
--   B346
--   C345
--   C563
--
-- この順番に対して連番を振ると、
--
--   A100 -> 1
--   A101 -> 2
--   A124 -> 3
--   B343 -> 4
--   B346 -> 5
--   C345 -> 6
--   C563 -> 7
--
-- となる。
--
-- これが後続の
--   ROW_NUMBER()
--   相関サブクエリ COUNT(*)
-- の両方で得たい結果である。