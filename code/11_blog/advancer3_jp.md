---
title: "Rで論文を書く実践的なテクニック集 (テーブル編)"
date: 'January 22, 2023'
author: Kazuharu Yanagimoto
draft: true
categories: [R, Quarto, Japanese]
image: https://source.unsplash.com/5QgIuuBxKwM
twitter-card:
  image: https://source.unsplash.com/5QgIuuBxKwM
execute:
  warning: false
  message: false
  cache: false
fig-width: 5
fig-height: 3
format:
  html:
    keep-md: true
---




## `kableExtra`





$\LaTeX$ 用の表作成は基本的に`kableExtra`を使えばよいです.
例えば以下のようなデータフレームを持っているとします.


::: {.cell}

:::

::: {.cell}

```{.r .cell-code}
tab
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 6 × 9
# Groups:   weather [6]
  weather   n_Men_2019 n_Men_2…¹ n_Men…² n_Men…³ n_Wom…⁴ n_Wom…⁵ n_Wom…⁶ n_Wom…⁷
  <fct>          <int>     <int>   <int>   <int>   <int>   <int>   <int>   <int>
1 sunny          24399     14969   19208   19420   11971    6958    9417    9298
2 cloud           1159      1190    1325    1633     555     554     630     774
3 soft rain       2126      1198    1281    1408    1068     542     605     716
4 hard rain        386       202     386     352     222      96     210     179
5 snow               2         2     124       5      NA      NA      38       1
6 hail              11         5       6       4       3       3       1       2
# … with abbreviated variable names ¹​n_Men_2020, ²​n_Men_2021, ³​n_Men_2022,
#   ⁴​n_Women_2019, ⁵​n_Women_2020, ⁶​n_Women_2021, ⁷​n_Women_2022
```
:::
:::


`kableExtra` なら簡単に`.tex`ファイルにできます.


::: {.cell}

```{.r .cell-code}
library(kableExtra)
options(knitr.kable.NA = '')

ktb <- tab |>
  kbl(format = "latex", booktabs = TRUE,
      col.names = c(" ", 2019:2022, 2019:2022)) |>
  add_header_above(c(" ", "Men" = 4, "Women" = 4)) |>
  pack_rows(index = c("Good" = 2, "Bad" = 4))

ktb |>
  save_kable(here("output/tex/kableextra/tb_accident_bike.tex"))
```
:::



![](https://github.com/kazuyanagimoto/workshop-r-2022/blob/main/code/slides/advancedr/img/kableextra.png?raw=true){fig-align="center" height=300}

ポイントとしては

- `booktabs = TRUE` は `booktabs` パッケージを使うので見た目がよくなります
- 列名は`col.names`項で指定します
- 行と列は`pack_rows()` と `add_header_above()` でまとめることができます
- `kbl(format = "latex")` を指定すると `save_kable()` でtexファイルに出力できます
- タイトルは論文用の本文用のtexファイルであとづけしています.

より複雑な表については @zhu_create_2021 を読むことをおすすめします.
ここまで複雑な $\LaTeX$ の表はPythonやJuliaだと簡単には作成できないのではないかと思います.

## `modelsummary`

回帰分析の表は`modelsummary` を使います. 以下のような回帰結果をリストでもっているとします.


::: {.cell}

:::

::: {.cell}

```{.r .cell-code}
library(fixest) # for faster regression with fixed effect

models <- list(
    "(1)" = feglm(is_hospitalized ~ type_person + positive_alcohol + positive_drug | age_c + gender,
                family = binomial(logit), data = data),
    "(2)" = feglm(is_hospitalized ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle,
                family = binomial(logit), data = data),
    "(3)" = feglm(is_hospitalized ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle + weather,
                family = binomial(logit), data = data),
    "(4)" = feglm(is_died ~ type_person + positive_alcohol + positive_drug | age_c + gender,
                family = binomial(logit), data = data),
    "(5)" = feglm(is_died ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle,
                family = binomial(logit), data = data),
    "(6)" = feglm(is_died ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle + weather,
                family = binomial(logit), data = data)
)
```
:::


計算を早くするために`fixest::feglm()` を使っていますが通常の`lm()` や `glm()` で問題ありません.

`modelsummary()`のデフォルトの設定で以下のようなテーブルを作ることができます.

```{.r}
library(modelsummary)
modelsummary(models)
```


::: {style="font-size: 0.3em"}


::: {.cell}
::: {.cell-output-display}

`````{=html}
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> (1) </th>
   <th style="text-align:center;"> (2) </th>
   <th style="text-align:center;"> (3) </th>
   <th style="text-align:center;"> (4) </th>
   <th style="text-align:center;"> (5) </th>
   <th style="text-align:center;"> (6) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> type_personPassenger </td>
   <td style="text-align:center;"> 0.049 </td>
   <td style="text-align:center;"> 0.530 </td>
   <td style="text-align:center;"> 0.507 </td>
   <td style="text-align:center;"> −1.781 </td>
   <td style="text-align:center;"> −1.575 </td>
   <td style="text-align:center;"> −1.565 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.104) </td>
   <td style="text-align:center;"> (0.071) </td>
   <td style="text-align:center;"> (0.070) </td>
   <td style="text-align:center;"> (0.759) </td>
   <td style="text-align:center;"> (0.783) </td>
   <td style="text-align:center;"> (0.784) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> type_personPedestrian </td>
   <td style="text-align:center;"> 2.124 </td>
   <td style="text-align:center;"> 2.402 </td>
   <td style="text-align:center;"> 2.323 </td>
   <td style="text-align:center;"> 2.280 </td>
   <td style="text-align:center;"> 2.418 </td>
   <td style="text-align:center;"> 2.422 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.115) </td>
   <td style="text-align:center;"> (0.066) </td>
   <td style="text-align:center;"> (0.064) </td>
   <td style="text-align:center;"> (0.301) </td>
   <td style="text-align:center;"> (0.287) </td>
   <td style="text-align:center;"> (0.285) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> positive_alcoholTRUE </td>
   <td style="text-align:center;"> −0.077 </td>
   <td style="text-align:center;"> 0.310 </td>
   <td style="text-align:center;"> 0.353 </td>
   <td style="text-align:center;"> −13.710 </td>
   <td style="text-align:center;"> −13.455 </td>
   <td style="text-align:center;"> −13.492 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.088) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.095) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.093) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.053) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.064) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.063) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 149918 </td>
   <td style="text-align:center;"> 149831 </td>
   <td style="text-align:center;"> 134006 </td>
   <td style="text-align:center;"> 90852 </td>
   <td style="text-align:center;"> 89300 </td>
   <td style="text-align:center;"> 86330 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.055 </td>
   <td style="text-align:center;"> 0.171 </td>
   <td style="text-align:center;"> 0.165 </td>
   <td style="text-align:center;"> 0.107 </td>
   <td style="text-align:center;"> 0.145 </td>
   <td style="text-align:center;"> 0.148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.054 </td>
   <td style="text-align:center;"> 0.170 </td>
   <td style="text-align:center;"> 0.163 </td>
   <td style="text-align:center;"> 0.086 </td>
   <td style="text-align:center;"> 0.113 </td>
   <td style="text-align:center;"> 0.112 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;"> 0.047 </td>
   <td style="text-align:center;"> 0.054 </td>
   <td style="text-align:center;"> 0.052 </td>
   <td style="text-align:center;"> 0.073 </td>
   <td style="text-align:center;"> 0.076 </td>
   <td style="text-align:center;"> 0.076 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within Adj. </td>
   <td style="text-align:center;"> 0.047 </td>
   <td style="text-align:center;"> 0.054 </td>
   <td style="text-align:center;"> 0.052 </td>
   <td style="text-align:center;"> 0.070 </td>
   <td style="text-align:center;"> 0.072 </td>
   <td style="text-align:center;"> 0.073 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;"> 62871.0 </td>
   <td style="text-align:center;"> 55210.6 </td>
   <td style="text-align:center;"> 53565.4 </td>
   <td style="text-align:center;"> 1601.9 </td>
   <td style="text-align:center;"> 1552.2 </td>
   <td style="text-align:center;"> 1534.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;"> 63079.3 </td>
   <td style="text-align:center;"> 55696.5 </td>
   <td style="text-align:center;"> 54085.1 </td>
   <td style="text-align:center;"> 1780.8 </td>
   <td style="text-align:center;"> 1824.8 </td>
   <td style="text-align:center;"> 1834.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 0.23 </td>
   <td style="text-align:center;"> 0.22 </td>
   <td style="text-align:center;"> 0.23 </td>
   <td style="text-align:center;"> 0.04 </td>
   <td style="text-align:center;"> 0.04 </td>
   <td style="text-align:center;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> by: age_c </td>
   <td style="text-align:center;"> by: age_c </td>
   <td style="text-align:center;"> by: age_c </td>
   <td style="text-align:center;"> by: age_c </td>
   <td style="text-align:center;"> by: age_c </td>
   <td style="text-align:center;"> by: age_c </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: age_c </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: gender </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: type_vehicle </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: weather </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
  </tr>
</tbody>
</table>

`````

:::
:::


:::

論文に使える形にするために以下のように調整します.



::: {.cell}

```{.r .cell-code}
cm  <-  c(
    "type_personPassenger" = "Passenger",
    "type_personPedestrian" = "Pedestrian",
    "positive_alcoholTRUE" = "Positive Alcohol"
)

gm <- tibble(
    raw = c("nobs", "FE: age_c", "FE: gender",
            "FE: type_vehicle", "FE: weather"),
    clean = c("Observations", "FE: Age Group", "FE: Gender",
              "FE: Type of Vehicle", "FE: Weather"),
    fmt = c(0, 0, 0, 0, 0)
)

modelsummary(models,
  output = "latex_tabular",
  stars = c("+" = .1, "*" = .05, "**" = .01),
  coef_map = cm,
  gof_map = gm) |>
  add_header_above(
    c(" ", "Hospitalization" = 3, "Died within 24 hours" = 3)) |>
  row_spec(7, hline_after = T) |>
  save_kable(here("output/tex/modelsummary/reg_accident_bike.tex"))
```
:::


![](https://github.com/kazuyanagimoto/workshop-r-2022/blob/main/code/slides/advancedr/img/modelsummary.png?raw=true){fig-align="center" height="300"}

調整した項目は以下です

- `coef_map = cm` で係数のラベルを変更
- `gof_map = gm` で統計量を選択&ラベル付け
- 出力が `kableExtra` 形式なので `add_header_above()` や `row_spec()` で見た目を調整
- タイトルとノートは本文用texファイルで記述
- `output = "latex_tabular"` を使うことで `table` タグなしのtexファイルが出力できる

## テーブル編まとめ

**`kableExtra` & `modelsummary`**

- `kableExtra` でtibble (データフレーム) から簡単にtexのテーブルを作成できる
- `modelsummary` で回帰結果から `kableExtra` のテーブルを出力できる
- 出力されたtexファイルとそれをコンパイルする本文のtexファイルはレポジトリ内の`output/tex/`と`code/thesis/`から確認できます

**より詳しく**

- 公式ドキュメント[modelsummary](https://vincentarelbundock.github.io/modelsummary/articles/modelsummary.html) と @zhu_create_2021
- [gt](https://gt.rstudio.com/articles/intro-creating-gt-tables.html)は `kableExtra` に替わりうる強力なテーブル作成パッケージです (が数式に対応していないので, 論文用には使っていません. スライドではよく使います.)
