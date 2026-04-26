-- ================================================
-- ファイル名: 13_insert_companies_sample_data.sql
-- 役割:
--   Companies テーブルへ会社のサンプルデータを投入する。
--
-- このSQLの目的:
--   後続の JOIN 処理で、
--   集約結果へ district を付与できるようにすること。
--
-- 学習上の主題:
--   - マスタ表データの役割
--   - 集約結果へ属性を付加する流れ
-- ================================================

INSERT INTO Companies VALUES('001', 'A');
INSERT INTO Companies VALUES('002', 'B');
INSERT INTO Companies VALUES('003', 'C');
INSERT INTO Companies VALUES('004', 'D');