library(ggplot2)
library(gridExtra)
library(scales)

# ggplot(data = df, mapping = aes(x, y, other_aesthetics))

scatter <- ggplot(
    mpg, 
    aes(
        x = displ,
        y =hwy,
        colour = drv
        )
) + 
   geom_point() +
   xlab("engine size in litres") +
   ylab("highway mileage")

# print(scatter)

line <- ggplot(
    economics,
    aes(
        x = date, 
        y = unemploy
        )
) +
   geom_line(
       color = "blue"
       ) +
   xlab("date") +
   ylab("unemployment rate") +
   scale_y_continuous(labels = scales::comma) # 15000 becomes 15,000
#print(line)

# create data for forest plot

df <- data.frame(
    study=c('S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7'),
    index = 1:7,
    effect=c(-.4, -.25, -.1, .1, .15, .2, .3),
    lower=c(-.43, -.29, -.17, -.02, .04, .17, .27),
    upper=c(-.37, -.21, -.03, .22, .24, .23, .33))

forest <- ggplot(
    data = df,
    aes(
        x = effect,
        y = index,
        xmin = lower,
        xmax = upper
        )
    ) +
    geom_point() +
    geom_errorbar(width = 0.1) + # plots whiskers
    scale_y_continuous(
        name = "",
        breaks = 1:nrow(df),
        labels = df$study
    ) +
    labs(
        title = 'Effect Size by Study',
        x = 'Effect Size',
        y = 'Study',
    ) +
    geom_vline(
        xintercept = 0,
        color = 'blue',
        linetype = 'dashed',
        alpha = 0.5,
    ) +
   theme_classic()

print(forest)
