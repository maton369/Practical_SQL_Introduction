-- ================================================
-- ファイル名: 37_insert_persons_sample_data.sql
-- 役割:
--   Persons テーブルへサンプル人物データを投入する。
--
-- このSQLの目的:
--   頭文字ごとの人数集計を試せるようにすること。
--
-- 学習上の主題:
--   名前の先頭文字によって
--     A グループ
--     B グループ
--     C グループ
--     D グループ
-- のように人物を分類できることを理解すること。
--
-- 今回の最重要ポイント:
--   後続のSQLでは、人物そのものを数えるのではなく、
--   「頭文字ごと」に人数を数える。
--
--   したがって、このデータは
--   先頭文字が複数人で重なるように作られている。
-- ================================================

INSERT INTO Persons VALUES('Anderson', 30, 188,  90);
INSERT INTO Persons VALUES('Adela',    21, 167,  55);

INSERT INTO Persons VALUES('Bates',    87, 158,  48);
INSERT INTO Persons VALUES('Becky',    54, 187,  70);
INSERT INTO Persons VALUES('Bill',     39, 177, 120);

INSERT INTO Persons VALUES('Chris',    90, 175,  48);

INSERT INTO Persons VALUES('Darwin',   12, 160,  55);
INSERT INTO Persons VALUES('Dawson',   25, 182,  90);
INSERT INTO Persons VALUES('Donald',   30, 176,  53);


-- ================================================
-- データの見方
-- ================================================
--
-- 先頭文字ごとに並べると次のようになる。
--
-- A:
--   Anderson
--   Adela
--   → 2人
--
-- B:
--   Bates
--   Becky
--   Bill
--   → 3人
--
-- C:
--   Chris
--   → 1人
--
-- D:
--   Darwin
--   Dawson
--   Donald
--   → 3人
--
-- したがって後続SQLの結果は概ね
--   A -> 2
--   B -> 3
--   C -> 1
--   D -> 3
-- のようになる。