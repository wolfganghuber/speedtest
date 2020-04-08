---
title: "Speedtest"
author: "Wolfgang Huber"
output: 
  html_document: 
    keep_md: true
---



# Install the speedtest command line interface

The tool is called [`speedtest-cli`](https://github.com/sivel/speedtest-cli). The below shell command is for Mac OS X and homebrew. Replace by your favourite package manager.


```sh
brew install speedtest-cli
```

# Set up crontab to run it in regular intervals

This works on Unix-derived systems like Linux and Mac OS X. Edit the crontab using


```sh
env EDITOR=nano crontab -e
```

and add a line similar to:


```sh
 */5 * * * * /Users/whuber/svnco/speedtest/run-speedtest-cli.sh
```

This will run the shell script `run-speedtest-cli.sh`, which is provided in a separate file, every five 5 minutes. Of course you'll have to adapt the file path to your local setup. Check the documentation of `crontab` if you want to run it at different times or intervals. Make sure the file is executable, with e.g.


```sh
chmod 755 /Users/whuber/svnco/speedtest/run-speedtest-cli.sh
```


# Visualize the data


```r
library("readr")
library("tidyr")
library("dplyr")
library("magrittr")
library("ggplot2")
```

Get the CSV header and read the CSV file

```r
hosts = c("spinoza", "boltzmann")
logfile = "/Users/whuber/Dropbox/speedtest/%s-speedtest.csv"
  
header = system2("speedtest-cli", args = c("--csv-header"), stdout = TRUE)  %>%
  strsplit(split = ",") %>% `[[`(1)

st = lapply(hosts, function(h) {
  read_csv(sprintf(logfile, h), col_names = FALSE) %>%
  `colnames<-`(header)  %>% 
  mutate(hostname = h)
}) %>% bind_rows 

for (j in c("Timestamp", "Download", "Upload", "Ping"))
  stopifnot(all(is.finite(st[[j]])))

variables = c("Download (Mb/s)", "Upload (Mb/s)", "log10 Ping (ms)")
st %<>% mutate(
  `Download (Mb/s)` = Download / 2^20,
  `Upload (Mb/s)` = Upload / 2^20,
  `log10 Ping (ms)` = log10(Ping)) %>% 
   pivot_longer(cols = all_of(variables))
st$name %<>% factor(levels = variables)
```


```r
ggplot(st, aes(x = Timestamp, y = value)) + 
  scale_x_datetime(timezone = "CET") + 
  xlab("Time") +
  geom_point(aes(col = hostname), size = 0.5) + 
  facet_grid(rows = vars(name), scales = "free_y") +
  theme(legend.position="bottom") + scale_colour_brewer(palette = "Set1")
```

![](speedtest_files/figure-html/speedtestplot-1.png)<!-- -->

```r
dev.copy(pdf, file = "speedtest.pdf")
```
