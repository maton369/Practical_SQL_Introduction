-- ================================================
-- ファイル名: 01_create_sales_tables.sql
-- 役割:
--   売上比較の元データを入れる Sales テーブルと、
--   比較結果(var列)を格納する Sales2 テーブルを作成する。
--
-- このSQLの目的:
--   後続のストアドプロシージャ PROC_INSERT_VAR で、
--   会社ごとの前年回比較結果を Sales2 に書き込めるようにすること。
--
-- 学習上の主題:
--   CREATE TABLE による表定義、
--   主キーの意味、
--   元表と出力表の役割分担を理解すること。
--
-- 今回の最重要ポイント:
--   Sales は「入力テーブル」、
--   Sales2 は「処理結果を書き込む出力テーブル」である。
--
--   つまり PROC_INSERT_VAR は
--     Sales を読む
--     直前売上と比較する
--     結果を Sales2 に書く
--   という流れになる。
-- ================================================


CREATE TABLE Sales
(
    company CHAR(1) NOT NULL,
    -- company:
    --   会社を表す列である。
    --
    --   例:
    --     'A'
    --     'B'
    --     'C'
    --
    --   この列と year を組み合わせて主キーになる。

    year INTEGER NOT NULL,
    -- year:
    --   売上が記録された年を表す。
    --
    --   例:
    --     2001
    --     2002
    --     2003
    --
    --   同じ company の中で年の順に並べることで、
    --   「直前の売上」と比較できるようになる。

    sale INTEGER NOT NULL,
    -- sale:
    --   その会社・その年の売上値である。
    --
    --   後続のプロシージャでは、
    --   直前レコードの sale と比較して
    --     増加 -> '+'
    --     減少 -> '-'
    --     同値 -> '='
    --   を判定する。

    CONSTRAINT pk_sales PRIMARY KEY (company, year)
    -- PRIMARY KEY(company, year):
    --   同じ会社の同じ年の売上が重複しないようにする。
    --
    --   これにより、
    --     A社 2002年
    --   のような1件の売上を一意に識別できる。
);


CREATE TABLE Sales2
(
    company CHAR(1) NOT NULL,
    -- company:
    --   Sales からコピーされる会社コードである。

    year INTEGER NOT NULL,
    -- year:
    --   Sales からコピーされる年である。

    sale INTEGER NOT NULL,
    -- sale:
    --   Sales からコピーされる売上値である。

    var CHAR(1),
    -- var:
    --   直前の年の売上と比べた変化記号を入れる列である。
    --
    --   値の意味:
    --     '+' : 前回より増えた
    --     '-' : 前回より減った
    --     '=' : 前回と同じ
    --     NULL: その会社の最初の行なので比較対象がない
    --
    --   ここが Sales2 の付加情報であり、
    --   Sales には無い列である。

    CONSTRAINT pk_sales2 PRIMARY KEY (company, year)
    -- PRIMARY KEY(company, year):
    --   出力表でも同じ会社・同じ年が重複しないようにする。
    --
    --   PROC_INSERT_VAR を再実行すると重複エラーになる可能性があるため、
    --   実運用では事前に DELETE/TRUNCATE を入れる設計も検討できる。
);