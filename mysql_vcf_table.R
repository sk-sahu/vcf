library(RMySQL)

con <- dbConnect(MySQL(), 
                 username = 'sangram', password = 'Bio@87654',
                 dbname = 'my_vcf', host = 'localhost')

dbSendQuery(con, "LOAD DATA INFILE 'output/vcf_data.csv'
             INTO TABLE my_vcf_table
             FIELDS TERMINATED by ','
             ENCLOSED BY '\"'
             LINES TERMINATED BY '\r\n'
             IGNORE 1 LINES;")

