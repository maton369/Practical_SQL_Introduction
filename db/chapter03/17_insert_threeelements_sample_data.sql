-- ================================================
-- ファイル名: 17_insert_threeelements_sample_data.sql
-- 役割:
--   ThreeElements テーブルへサンプルデータを投入する。
--
-- このSQLの目的:
--   UNION による検索で、
--   どの列ペアが条件に一致するかを試せるデータを用意すること。
--
-- 学習上の主題:
--   複数列ペアのうち、どこに条件一致が入るかが行ごとに異なる
--   データ構造を理解すること。
--
-- 今回の最重要ポイント:
--   条件
--     date_X = '2013-11-01'
--     AND flg_X = 'T'
-- に一致する場所が、
--   各行で
--     1番目だったり
--     2番目だったり
--     3番目だったり
-- するようにデータが作られている。
-- ================================================

INSERT INTO ThreeElements VALUES ('1', 'a', '2013-11-01', 'T', NULL, NULL, NULL, NULL);
INSERT INTO ThreeElements VALUES ('2', 'b', NULL, NULL, '2013-11-01', 'T', NULL, NULL);
INSERT INTO ThreeElements VALUES ('3', 'c', NULL, NULL, '2013-11-01', 'F', NULL, NULL);
INSERT INTO ThreeElements VALUES ('4', 'd', NULL, NULL, '2013-12-30', 'T', NULL, NULL);
INSERT INTO ThreeElements VALUES ('5', 'e', NULL, NULL, NULL, NULL, '2013-11-01', 'T');
INSERT INTO ThreeElements VALUES ('6', 'f', NULL, NULL, NULL, NULL, '2013-12-01', 'F');


-- ================================================
-- データの見方
-- ================================================
--
-- 条件:
--   date_X = '2013-11-01'
--   AND flg_X = 'T'
--
-- に一致する行を考えると、
--
-- 1. key='1'
--    date_1='2013-11-01', flg_1='T'
--    → 第1ペアで一致
--
-- 2. key='2'
--    date_2='2013-11-01', flg_2='T'
--    → 第2ペアで一致
--
-- 3. key='3'
--    date_2='2013-11-01', flg_2='F'
--    → 日付は合うがフラグが不一致
--
-- 4. key='4'
--    date_2='2013-12-30', flg_2='T'
--    → フラグは合うが日付が不一致
--
-- 5. key='5'
--    date_3='2013-11-01', flg_3='T'
--    → 第3ペアで一致
--
-- 6. key='6'
--    date_3='2013-12-01', flg_3='F'
--    → 両方とも不一致
--
-- したがって最終的にヒットすべき行は
--   key='1'
--   key='2'
--   key='5'
-- の3行である。