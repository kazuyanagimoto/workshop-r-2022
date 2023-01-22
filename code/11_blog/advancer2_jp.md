---
title: "Rで論文を書く実践的なテクニック集 (グラフ編)"
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





## 読み取りやすさ (Readability)

良いグラフからは本文を読まなくともメッセージが読み取れるものです.
一番大事なのは, 質の良いデータと適切な手法の選択ですが, テクニックで改善できる部分もあります.
ケースバイケースですが, 一番シンプルなルールは以下の原則です.

::: {.callout-note}

## データインク比の原則 [@tufte_visual_2001]

図においては以下のデータインク比を最大化しなければならない:

$$
\text{データインク比} := \frac{\text{データインク}}{\text{図中で使われるインク総量}}
$$

:::

::: {.callout-tip}
## 系

削除しても情報量を損ねない要素は取り除かなければならない.

:::

例えば, 以下の棒グラフを改善してみましょう.



::: {.cell layout-align="center"}

```{.r .cell-code}
accident_bike <- read_parquet(here("data/cleaned/accident_bike.parquet")) |>
  filter(!is.na(type_person), !is.na(gender), is_hospitalized)

p <- accident_bike |>
  ggplot(aes(x = type_person, fill = gender)) +
  geom_bar(position = "dodge")

p
```

::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-2-1.png){fig-align='center' width=480}
:::
:::

::: {.cell layout-align="center"}

```{.r .cell-code}
p +
  labs(x = NULL, y = NULL, fill = NULL,
       title = "Number of People Hospitalized") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank())
```

::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-3-1.png){fig-align='center' width=480}
:::
:::


直した点は

- **x軸ラベル**: Driver, Passenger, Pedestrianがどういうくくりかは自明
- **y軸ラベル**: タイトルから人数であることが自明
- **凡例ラベル**: gender というラベルは Men/Women に何の情報も足していない
- 不要な背景色やグリッドの削除

データインク的にはこれで十分ですが, もう少し手を加えることで読みやすくなります.


::: {.cell layout-align="center"}

```{.r .cell-code}
accident_bike |>
  ggplot(aes(x = fct_rev(type_person),
         fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL,
       title = "Number of People Hospitalized") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.15),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 13),
        legend.text = element_text(size = 10),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))
```

::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-4-1.png){fig-align='center' width=480}
:::
:::


- 横向き棒グラフの方が見やすい場合が多いです.^[縦向き棒グラフでラベル名が長い場合, ラベル名が斜めになったりして美しくないです.] `coord_flip()` します
- Factor の順位が変わってしまうので, `fct_rev()` と `guides()` で調整します
- フォントサイズはデフォルトのものは少し小さいように感じます

## カラーパレット

色の選択は重要なテーマで様々な理論がありますが, ここでは深入りせずにできあいのカラーパレットを紹介します.

### R Color Brewer’s Palettes

現代的なカラーパレット集として有名な[Color Brewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3)のパッケージとして, `RColorBrewer`が提供されています.

![](https://r-graph-gallery.com/38-rcolorbrewers-palettes_files/figure-html/thecode-1.png){height=300 fig-align="center"}

`ggplot2`では, `scale_fill_brewer(palette = "Accent")` の様に使うことができます.


::: {.cell layout-align="center"}
::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-5-1.png){fig-align='center' width=480}
:::
:::


### カラーセーフティーパレット: Okabe-Ito Palette

色選択の一つの方針として, 色覚異常の方でも見分けやすい色を使う, という考え方があります.
カラーセーフティなパレットとして提案された中でも有名なカラーパレットが岡部・伊藤カラーパレットです.
個人的にもこなれた色だと思うので, かなり使いやすいと思っています.
`ggplot2` の場合は `see::scale_fill_okabeito()` を用いるだけで使うことができます.


::: {.cell layout-align="center"}
::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-6-1.png){fig-align='center' width=480}
:::
:::


## フォント

紹介するまでもないですが, [Goolge Fonts](https://fonts.google.com/) は数々のフリーフォントを提供しています.
論文中のグラフとして適切なフォントとしては, サンセリフ体を選べばよいと思いますが,
中でもおすすめは **Condensed** なフォントです (Roboto Condensed, Fira Sans Condensed, IBM Plex Sans Condensed,...) 字間が詰まっていて, パリッとした雰囲気が出ています.

ただフォントを共著者にインストールしてもらうのは少し手間です.
また, 私はDocker上で基本的に作業するので, Dockerマシンにフォントを毎回入れるのも面倒です.
これらの面倒は, `showtext::font_add_google()` と `showtext::showtext_auto()` 
が自動的に解決してくれます.


::: {.cell layout-align="center"}

```{.r .cell-code}
library(showtext)
font_base  <- "Roboto Condensed"
font_light <- "Roboto Condensed Light 300"
font_add_google(font_base, font_light)
showtext_auto()

accident_bike |>
  ggplot(aes(x = fct_rev(type_person), fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL,
       title = "Number of People Hospitalized") +
  see::scale_fill_okabeito() +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.1),
        plot.title = element_text(
            size = 30, face = "bold", family = font_base),
        axis.text.x = element_text(size = 20, family = font_light),
        axis.text.y = element_text(size = 25, family = font_light),
        legend.text = element_text(size = 20, family = font_light),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))
```

::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-7-1.png){fig-align='center' width=480}
:::
:::


## その他のTips

### グローバルオプション

論文内のグラフごとにこれらの設定を書くのは面倒ですし, 保守性が低いです.
グローバルに設定しまえば一度で済みます (e.g. @scherer_ggplot_2021)

```{.r}
theme_set(theme_minimal(base_size = 12, base_family = "Roboto Condensed"))
theme_update(
  axis.ticks = element_line(color = "grey92"),
  axis.ticks.length = unit(.5, "lines"),
  panel.grid.minor = element_blank(),
  legend.title = element_text(size = 12),
  legend.text = element_text(color = "grey30"),
  plot.title = element_text(size = 18, face = "bold"),
  plot.subtitle = element_text(size = 12, color = "grey30"),
  plot.caption = element_text(size = 9, margin = margin(t = 15))
)
```

ちなみにカラーパレットをデフォルトで設定するにはデフォルトの `scale_*_discrete()` を変更すればいいです.

```{.r}
scale_color_discrete <- function(...) {
  see::scale_color_okabeito()
}

scale_fill_discrete <- function(...) {
  see::scale_fill_okabeito()
}
```

その他の方法としては @heiss_who_2021 の方法などが参考になります.

### サードパーティーテーマ

フォントとカラーテーマがまとめてデザインされた様々なテーマがすでにパッケージ化されています.
代表的なものには[hrbrthemes](https://cinc.rud.is/web/packages/hrbrthemes/)
や[ggpubr](https://rpkgs.datanovia.com/ggpubr/) があります.

### Patchwork

複数の図を組み合わせる場合に最も簡単な方法が[patchwork](https://patchwork.data-imaginist.com/)
を使うことです. `+`や`/`という直感的な表現で複数の図を組み合わせることができます.


::: {.cell}

:::

::: {.cell layout-align="center"}

```{.r .cell-code}
library(patchwork)

(p_default + p_custom) / (p_hrbrthemes + p_ggpubr)
```

::: {.cell-output-display}
![](advancer2_jp_files/figure-html/unnamed-chunk-9-1.png){fig-align='center' width=768}
:::
:::



## グラフ編まとめ

**データインク比を最大化する**

- 必要のない要素は情報量を減らさない範囲ですべて取り除く

**色 & フォント**

- **カラーパレット**: `RColorBrewer`, `see::scale_*_okabeito()`, `ggsci`
- **フォント**: Googleフォント with `showtext`. 特に_condensed_なフォントがおすすめ
- **できあいのテーマ**: `hrbrthemes`, `ggpubr`

**より深く学ぶために**

英語版 (Online Books, 無料)

- "Data Visualization: A Practical Introduction" **@healy_data_2018**
- "Fundamentals of Data Visualization" **@wilke_fundamentals_2019**

邦訳版 (書籍)

- "実践Data Scienceシリーズ データ分析のためのデータ可視化入門"
- "データビジュアライゼーションの基礎"

