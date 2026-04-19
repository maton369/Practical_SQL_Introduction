-- ================================================
-- ファイル名: 12_insert_employees_sample_data.sql
-- 役割:
--   Employees テーブルへ社員と所属チームのサンプルデータを投入する。
--
-- このSQLの目的:
--   後続の UNION を使った条件分岐SQLで、
--   兼務数ごとの分類を試すためのデータを用意すること。
--
-- 学習上の主題:
--   同じ社員が複数行を持つことで、
--   兼務数を COUNT(*) で求められることを理解すること。
--
-- 今回の最重要ポイント:
--   各社員が持つ行数が、そのまま「何チーム兼務しているか」
--   を表す。
--
--   したがって、
--     COUNT(*) = 1 なら単独所属
--     COUNT(*) = 2 なら2つ兼務
--     COUNT(*) >= 3 なら3つ以上兼務
--   という判定が可能になる。
-- ================================================

INSERT INTO Employees VALUES('201', 1, 'Joe',  '商品企画');
INSERT INTO Employees VALUES('201', 2, 'Joe',  '開発');
INSERT INTO Employees VALUES('201', 3, 'Joe',  '営業');

INSERT INTO Employees VALUES('202', 2, 'Jim',  '開発');

INSERT INTO Employees VALUES('203', 3, 'Carl', '営業');

INSERT INTO Employees VALUES('204', 1, 'Bree', '商品企画');
INSERT INTO Employees VALUES('204', 2, 'Bree', '開発');
INSERT INTO Employees VALUES('204', 3, 'Bree', '営業');
INSERT INTO Employees VALUES('204', 4, 'Bree', '管理');

INSERT INTO Employees VALUES('205', 1, 'Kim',  '商品企画');
INSERT INTO Employees VALUES('205', 2, 'Kim',  '開発');


-- ================================================
-- データの見方
-- ================================================
--
-- この表では、1行が
--   「ある社員が、あるチームに所属している」
-- ことを表す。
--
-- 社員ごとに行数を数えると次のようになる。
--
-- 1. Joe
--    商品企画, 開発, 営業
--    → 3行
--    → 3つ兼務
--
-- 2. Jim
--    開発
--    → 1行
--    → 1つだけ所属
--
-- 3. Carl
--    営業
--    → 1行
--    → 1つだけ所属
--
-- 4. Bree
--    商品企画, 開発, 営業, 管理
--    → 4行
--    → 3つ以上兼務
--
-- 5. Kim
--    商品企画, 開発
--    → 2行
--    → 2つ兼務
--
-- したがって、このサンプルは
--   COUNT(*) = 1
--   COUNT(*) = 2
--   COUNT(*) >= 3
-- の3パターンをすべて含んでいる。
--
-- 後続の UNION SQL は、この行数を利用して
-- 社員ごとの兼務状態を分類する。