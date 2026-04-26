-- ================================================
-- ファイル名: 05_create_weights2.sql
-- 役割:
--   複合主キーを持つ Weights2 テーブルを作成する。
--
-- このSQLの目的:
--   class と student_id の組で一意になる表に対して、
--   複数列の主キー順で連番を振る題材を用意すること。
--
-- 学習上の主題:
--   - 主キーが複数列の場合の順序の決め方
--   - 複合主キーによる一意な並び順
--   - ROW_NUMBER() と相関サブクエリの比較
--
-- 今回の最重要ポイント:
--   前回の Weights は
--     student_id
--   だけで一意だった。
--
--   今回の Weights2 は
--     (class, student_id)
--   の組で一意である。
--
--   したがって連番を振るときの順序も
--     ORDER BY class, student_id
--   のように複数列で考える必要がある。
--
--   つまりこの表は
--     「複合主キーの辞書順に従って連番を振る」
--   題材になっている。
-- ================================================

CREATE TABLE Weights2
(
    class INTEGER NOT NULL,
    -- class:
    --   クラス番号を表す列である。
    --
    --   今回の連番付与では、
    --   まず class の昇順で大きな並びを決める。
    --
    --   つまり
    --     class = 1 の行群
    --     class = 2 の行群
    --   の順に並ぶ。
    --
    --   この列だけでは学生は一意に決まらないが、
    --   複合主キーの先頭列として
    --   並び順の第1キーになる。

    student_id CHAR(4) NOT NULL,
    -- student_id:
    --   クラス内の学生IDを表す列である。
    --
    --   今回は
    --     class
    --     student_id
    --   の組で主キーになっている。
    --
    --   したがって並び順は
    --     まず class
    --     同じ class の中では student_id
    --   で決まる。
    --
    --   つまり student_id は
    --   複合順序の第2キーとして使われる。

    weight INTEGER NOT NULL,
    -- weight:
    --   学生の体重を表す列である。
    --
    --   今回の連番付与の計算そのものには使わない。
    --
    --   つまり今回の主題は
    --     体重順
    --   ではなく
    --     (class, student_id) 順
    --   に従って通し番号を付けることにある。

    PRIMARY KEY(class, student_id)
    -- PRIMARY KEY(class, student_id):
    --   class と student_id の組を複合主キーにしている。
    --
    --   これにより、
    --   同じ class 内で同じ student_id は重複しない。
    --
    --   また、
    --   (class, student_id) の辞書順で全行を一意に並べられる。
    --
    --   これが後続の
    --     ROW_NUMBER() OVER (ORDER BY class, student_id)
    --   や
    --     (W2.class, W2.student_id) <= (W1.class, W1.student_id)
    --   で安定して連番を振れる理由である。
);