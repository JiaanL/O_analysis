# Oracle Data Analysis

This repository is a data crawling and data analysis code

### Table of Contents
**[1. Setup](#1-setup)**<br>
**[2. Crawl Data](#2-crawl-data)**<br>
**[3. Data Analysis](#3-data-analysis)**<br>


## 1. Setup

install Golang, R and Python


Python packages: jupyter notebook, pandas, numpy, matplotlib, statsmodels, pandarallel, tqdm, binance

Go packages: go-ethereum, progressbar


## 2. Crawl Data

uncomment the target data crawling function in main.go; comment out the remaining. Then use terminal to run
```
go run main.go
```

## 3. Data Analysis


1. data_preprocessor.ipynb: clean the raw data crawled from geth
2. data_horizontal_analysis.ipynb: do the latency measurment of data
3. data_vertical_analysis.ipynb: do the on- off-chain aggregation comparision
4. mempool_data_processing.ipynb: clean the raw data from mempool
5. latency_source_analysis: use mempool data to perfrom casual analysis on mining time and also the MEV liquidation call ratio analysis
