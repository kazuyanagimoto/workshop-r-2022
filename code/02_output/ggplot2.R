library(here)
library(tidyverse)
library(showtext)
library(patchwork)

font_add_google("Roboto Condensed", "Roboto Condensed Light 300")
showtext_auto()

accident_bike <- arrow::read_parquet(here("data/cleaned/accident_bike.parquet")) |>
  filter(!is.na(type_person), !is.na(gender), is_hospitalized)

# Plot with My Custom Theme

accident_bike |>
  ggplot(aes(x = fct_rev(type_person), fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL) +
  see::scale_fill_okabeito() +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.2),
        plot.title = element_text(size = 15, family = font_base, face = "bold"),
        axis.text.x = element_text(size = 10, family = "Roboto Condensed Light 300"),
        axis.text.y = element_text(size = 12, family = "Roboto Condensed"),
        legend.text = element_text(size = 10, family = "Roboto Condensed Light 300"),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))

ggsave(here("output/img/num_hospitalized.pdf"), width = 6, height = 4)


# Patchwork

p_default <- accident_bike |>
  ggplot(aes(x = fct_rev(type_person),
         fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL, title = "Default") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.2),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))

p_custom <- accident_bike |>
  ggplot(aes(x = fct_rev(type_person), fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL, title = "Custom Theme") +
  see::scale_fill_okabeito() +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.2),
        plot.title = element_text(size = 15, family = font_base, face = "bold"),
        axis.text.x = element_text(size = 10, family = "Roboto Condensed Light 300"),
        axis.text.y = element_text(size = 12, family = "Roboto Condensed"),
        legend.text = element_text(size = 10, family = "Roboto Condensed Light 300"),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))

p_hrbrthemes <- accident_bike |>
  ggplot(aes(x = fct_rev(type_person),
         fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL, title = "hrbrthemes") +
  hrbrthemes::scale_fill_ipsum() +
  hrbrthemes::theme_ipsum_rc() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.2),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))

p_ggpubr <- accident_bike |>
  ggplot(aes(x = fct_rev(type_person),
         fill = fct_rev(gender))) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(x = NULL, y = NULL, fill = NULL, title = "ggpubr & ggsci") +
  ggpubr::theme_pubr() +
  scale_fill_manual(values = ggpubr::get_palette("jco", 2)) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = c(0.9, 0.3),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        plot.title.position = "plot") +
  guides(fill = guide_legend(reverse = TRUE))



# Export
(p_default + p_custom) / (p_hrbrthemes + p_ggpubr)

ggsave(here("output/img/comp_plots.pdf"))
