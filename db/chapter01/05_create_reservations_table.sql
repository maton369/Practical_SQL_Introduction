-- ================================================
-- ファイル名: 05_create_reservations_table.sql
-- 目的:
--   予約情報を管理する Reservations テーブルを作成する。
--
-- テーブルの役割:
--   このテーブルは、どの予約(reserve_id)が、
--   どの店舗(shop_id)に対するもので、
--   予約者名(reserve_name)が誰かを保持する。
--
-- 各列の意味:
--   reserve_id   : 予約を一意に識別するID
--   shop_id      : 予約対象の店舗ID
--   reserve_name : 予約者名
--
-- 制約:
--   PRIMARY KEY (reserve_id)
--   → reserve_id は重複不可であり、各予約を一意に識別する。
--
-- 設計上のポイント:
--   - reserve_id は予約そのものの識別子であるため主キーにしている
--   - shop_id は Shops テーブルの shop_id と対応する列であり、
--     後で結合条件として利用される
-- ================================================

CREATE TABLE Reservations (
    reserve_id    INTEGER     NOT NULL,
    shop_id       CHAR(5),
    reserve_name  VARCHAR(64),
    CONSTRAINT pk_reservations PRIMARY KEY (reserve_id)
);