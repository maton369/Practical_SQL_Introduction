-- ================================================
-- ファイル名: 28_insert_nonaggtbl_sample_data.sql
-- 役割:
--   NonAggTbl にサンプルデータを投入する。
--
-- このSQLの目的:
--   CASE + MAX による横持ち変換を試すための、
--   A/B/C の3種類のデータ行を各 id に対して用意すること。
--
-- 学習上の主題:
--   同じ id に対して data_type ごとに別行を持つ構造を理解すること。
--
-- 今回の最重要ポイント:
--   各 id は
--     A行
--     B行
--     C行
-- を1つずつ持つ。
--
--   そのため、最終的には
--     A行から必要列を抜く
--     B行から必要列を抜く
--     C行から必要列を抜く
--   という形で 1 行へまとめられる。
-- ================================================

DELETE FROM NonAggTbl;
-- 既存データをいったん削除してからサンプルを入れ直す。
-- 教材として再実行しやすくするための前処理である。

INSERT INTO NonAggTbl VALUES('Jim',  'A', 100,  10,   34,  346,  54, NULL);
INSERT INTO NonAggTbl VALUES('Jim',  'B',  45,   2,  167,   77,  90, 157);
INSERT INTO NonAggTbl VALUES('Jim',  'C', NULL,  3,  687, 1355, 324, 457);

INSERT INTO NonAggTbl VALUES('Ken',  'A',  78,   5,  724,  457, NULL,   1);
INSERT INTO NonAggTbl VALUES('Ken',  'B', 123,  12,  178,  346,  85, 235);
INSERT INTO NonAggTbl VALUES('Ken',  'C',  45, NULL,  23,   46, 687,  33);

INSERT INTO NonAggTbl VALUES('Beth', 'A',  75,   0,  190,   25, 356, NULL);
INSERT INTO NonAggTbl VALUES('Beth', 'B', 435,   0,  183, NULL,   4, 325);
INSERT INTO NonAggTbl VALUES('Beth', 'C',  96, 128, NULL,    0,   0,  12);


-- ================================================
-- データの見方
-- ================================================
--
-- たとえば Jim については次の3行を持つ。
--
--   Jim, A, ...
--   Jim, B, ...
--   Jim, C, ...
--
-- この3行のうち、
--   A行からは data_1, data_2 を採用する
--   B行からは data_3, data_4, data_5 を採用する
--   C行からは data_6 を採用する
-- というのが、後続SQLのルールである。
--
-- つまり最終的に Jim の1行を作るときは、
--   A 行の必要列
--   B 行の必要列
--   C 行の必要列
-- を合体させることになる。
--
-- Ken, Beth も同様である。