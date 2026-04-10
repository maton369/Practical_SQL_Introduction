-- ================================================
-- ファイル名: 06_insert_reservations_data.sql
-- 目的:
--   Reservations テーブルにサンプルデータを投入する。
--
-- データの見方:
--   - 1つの INSERT は1件の予約を表す
--   - 同じ shop_id が複数回登場する場合、
--     1つの店舗に対して複数の予約が入っていることを意味する
--
-- たとえば:
--   shop_id = '00005' には Eさん, Fさん の2件の予約がある
--   shop_id = '00006' には Gさん, Hさん の2件の予約がある
--
-- これは後の INNER JOIN で、
-- 「1つの店舗に対して予約件数分だけ結合結果が増える」
-- ことを確認するのに役立つ。
-- ================================================

INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (1,  '00001', 'Aさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (2,  '00002', 'Bさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (3,  '00003', 'Cさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (4,  '00004', 'Dさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (5,  '00005', 'Eさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (6,  '00005', 'Fさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (7,  '00006', 'Gさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (8,  '00006', 'Hさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (9,  '00007', 'Iさん');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (10, '00010', 'Jさん');