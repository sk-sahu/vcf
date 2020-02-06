bed_file <- "truseq.bed"
vcf_file <- "mutect_immediate.vcf"

# read bed data
bed_data <- read.table(bed_file, header = F)
names(bed_data) <- c("chr", "start", "end")

# read vcf data
tmp_vcf<-readLines(vcf_file)
vcf_data<-read.table(vcf_file, stringsAsFactors = FALSE)
tmp_vcf<-tmp_vcf[-(grep("#CHROM",tmp_vcf)+1):-(length(tmp_vcf))]
vcf_names<-unlist(strsplit(tmp_vcf[length(tmp_vcf)],"\t"))
names(vcf_data)<-vcf_names

vcf_data_passed <- vcf_data[vcf_data$FILTER == 'PASS',]

extracted_vcf_data <- data.frame()
for(n in 1:nrow(vcf_data_passed)){
  mutation <- vcf_data_passed[n,]
  for(m in 1:nrow(bed_data)){
    if(mutation$`#CHROM` == bed_data[m,]$chr){
      if(mutation$POS > bed_data[m,]$start & mutation$POS < bed_data[m,]$end){
        extracted_vcf_data <- rbind(extracted_vcf_data, mutation)
      }
    }
  }
}
names(extracted_vcf_data) <- names(vcf_data)

library(xlsx)
write.xlsx(extracted_vcf_data, "accepted.xls", row.names = F)
