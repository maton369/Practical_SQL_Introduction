-- ================================================
-- ファイル名: 16_create_address2_table.sql
-- 役割:
--   Address2 テーブルを作成する。
--
-- このSQLの目的:
--   Address テーブルとは別に、
--   もう1つ住所録テーブル Address2 を用意すること。
--
-- 今回の学習上の位置づけ:
--   後で
--     Address の name
--   と
--     Address2 の name
--   を比較するため、
--   比較対象となる第2の表として Address2 を作る。
--
-- この段階ではまだサブクエリは出てこないが、
-- 後続の IN (SELECT ...)
-- を理解するための準備として重要である。
-- ================================================

CREATE TABLE Address2
(
    -- name 列:
    --   氏名を入れる列である。
    --   VARCHAR(32) は可変長文字列型であり、
    --   最大32文字程度の文字列を格納できる。
    --
    --   NOT NULL により NULL は禁止される。
    --   したがって name は必須項目である。
    name       VARCHAR(32) NOT NULL,

    -- phone_nbr 列:
    --   電話番号を入れる列である。
    --   文字列として扱うため VARCHAR(32) を使っている。
    --
    --   NOT NULL が付いていないので、
    --   電話番号が未登録の行では NULL を入れられる。
    phone_nbr  VARCHAR(32),

    -- address 列:
    --   都道府県名などの住所情報を入れる列である。
    --   NOT NULL により必須項目になっている。
    address    VARCHAR(32) NOT NULL,

    -- sex 列:
    --   性別を表す列である。
    --   CHAR(4) は固定長文字列型である。
    --   今回は '男' や '女' のような値を格納する。
    sex        CHAR(4) NOT NULL,

    -- age 列:
    --   年齢を表す整数列である。
    --   INTEGER を使っている。
    age        INTEGER NOT NULL,

    -- PRIMARY KEY (name):
    --   name 列を主キーにする。
    --   同じ name を2回登録できない。
    --
    --   今回は教材として name を主キーにしているが、
    --   実務では専用IDを使う設計も多い。
    PRIMARY KEY (name)
);