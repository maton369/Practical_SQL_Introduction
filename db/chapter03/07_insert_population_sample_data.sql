-- ================================================
-- ファイル名: 07_insert_population_sample_data.sql
-- 役割:
--   Population テーブルへ都道府県ごとの男女別人口サンプルを投入する。
--
-- このSQLの目的:
--   後続の UNION を使った縦持ち→横持ち変換と集約を試すための
--   サンプルデータを用意すること。
--
-- 学習上の主題:
--   1都道府県につき
--     男性行
--     女性行
--   の2行を持つ構造を理解すること。
--
-- 今回の重要点:
--   後続のSQLでは、この縦持ちデータを
--     prefecture, pop_men, pop_wom
--   の横持ち形式へ変換する。
-- ================================================

INSERT INTO Population VALUES('徳島', '1',  60);
INSERT INTO Population VALUES('徳島', '2',  40);

INSERT INTO Population VALUES('香川', '1',  90);
INSERT INTO Population VALUES('香川', '2', 100);

INSERT INTO Population VALUES('愛媛', '1', 100);
INSERT INTO Population VALUES('愛媛', '2',  50);

INSERT INTO Population VALUES('高知', '1', 100);
INSERT INTO Population VALUES('高知', '2', 100);

INSERT INTO Population VALUES('福岡', '1',  20);
INSERT INTO Population VALUES('福岡', '2', 200);


-- ================================================
-- データの見方
-- ================================================
--
-- 現在の Population は縦持ちデータである。
--
-- たとえば徳島については
--
--   徳島 | '1' |  60
--   徳島 | '2' |  40
--
-- の2行で表現されている。
--
-- つまり
--   男性人口と女性人口が別列ではなく、別行で管理されている。
--
-- 後続の SQL では、この縦持ちデータを
--   都道府県ごとに 1 行へまとめ、
--   男性人口列と女性人口列へ分ける
-- 処理を行う。