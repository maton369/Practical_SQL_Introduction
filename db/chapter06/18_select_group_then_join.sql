-- ================================================
-- ファイル名: 18_select_group_then_join.sql
-- 役割:
--   先に Shops を集約し、
--   その後で Companies と結合する。
--
-- このSQLの目的:
--   「集約を先に行う」場合のアルゴリズムを明示すること。
--
-- 学習上の主題:
--   - 集約と JOIN の順序
--   - 詳細表を先に縮約してからマスタ表へ結び付ける発想
--   - 入力行数と中間結果サイズの違い
--
-- 今回の最重要ポイント:
--   このSQLでは、
--     1. まず Shops だけを見て
--     2. main_flg='Y' の行を残す
--     3. co_cd ごとに SUM(emp_nbr) して
--        小さな集約表 CSUM を作る
--     4. 最後に Companies と JOIN する
--   という順序になっている。
--
--   つまり
--     FILTER -> GROUP BY -> JOIN
--   の流れである。
--
--   そのため JOIN の入力は
--     詳細行集合
--   ではなく
--     すでに会社ごとに縮約された集約表
--   になる。
--
--   これが解1との最大の違いである。
-- ================================================

SELECT
       C.co_cd,
       -- 会社コードを返す。
       --
       -- 最終的に Companies 側から返しているが、
       -- JOIN 相手 CSUM も co_cd ごとに1行なので
       -- 1会社1行の結果になる。

       C.district,
       -- 会社の地区属性を返す。
       --
       -- 集約は Shops 側で完了しているので、
       -- この JOIN は
       --   集約済み会社コードにマスタ属性を付ける
       -- 役割になる。

       sum_emp
       -- CSUM で計算済みの合計従業員数を返す。
       --
       -- ここでは SUM を再計算していない。
       --
       -- つまりこの列は
       --   先に作った集約結果
       -- をそのまま使っている。

  FROM Companies C
       INNER JOIN
       (
           SELECT
                  co_cd,
                  SUM(emp_nbr) AS sum_emp
                  -- main_flg='Y' の事業所について、
                  -- 会社ごとの従業員数合計を求める。
                  --
                  -- このサブクエリは
                  --   「会社単位の集約表」
                  -- を作る役割である。
             FROM Shops
            WHERE main_flg = 'Y'
            -- 先に Shops 単体へ条件をかける。
            --
            -- つまり
            --   不要な事業所行を早い段階で落とす
            -- ことになる。

            GROUP BY co_cd
            -- co_cd ごとにグループ化して SUM(emp_nbr) を求める。
            --
            -- ここで
            --   詳細行 -> 会社単位の集約行
            -- に縮約される。
       ) CSUM
         ON C.co_cd = CSUM.co_cd;
         -- 最後に Companies と集約済み表 CSUM を結び付ける。
         --
         -- したがってこの JOIN は
         --   詳細行どうしの JOIN
         -- ではなく
         --   会社マスタに集約値を付与する JOIN
         -- になっている。


-- ================================================
-- このSQLの処理の流れ
-- ================================================
--
-- 1. Shops から main_flg='Y' の行だけを残す
-- 2. co_cd ごとに SUM(emp_nbr) を求める
-- 3. 集約表 CSUM を作る
-- 4. Companies と CSUM を co_cd で結合する
--
-- 概念的には次のような処理に近い。
--
--   filtered_shops = shops where main_flg == 'Y'
--
--   csum = {}
--   for each shop in filtered_shops:
--       csum[shop.co_cd] += shop.emp_nbr
--
--   for each company in Companies:
--       if company.co_cd in csum:
--           output company.co_cd, company.district, csum[company.co_cd]
--
-- つまりこれは、
--   「詳細表を先に縮約し、最後にマスタと結ぶ」
--   集約先行型アルゴリズムである。


-- ================================================
-- 図解: 集約を先に行う
-- ================================================
--
--   Shops
--      |
--      | main_flg='Y'
--      v
--   対象行だけ残す
--      |
--      | GROUP BY co_cd
--      v
--   集約表 CSUM
--      |
--      | Companies と JOIN
--      v
--   district を付与した最終結果
--
-- つまり
--   先に詳細表を小さくまとめてから、
--   最後にマスタ情報を付けている。