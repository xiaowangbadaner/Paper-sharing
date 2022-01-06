samtools faidx D2.fa
bwa index D2.fa
picard CreateSequenceDictionary R=D2.fa O=D2.dict
bwa mem -Y -R '@RG\tID:aligned_reads\tLB:aligned_reads\tPL:ILLUMINA\tPM:HISEQ\tSM:aligned_reads' D2.fa D2_R1.fq D2_R2.fq > aligned_reads.sam
gatk MarkDuplicatesSpark -I aligned_reads.sam -M dedup_metrics.txt -O sorted_dedup_reads.bam
picard CollectAlignmentSummaryMetrics R=D2.fa I=sorted_dedup_reads.bam O=alignment_metrics.txt
picard CollectInsertSizeMetrics I=sorted_dedup_reads.bam O=insert_metrics.txt HISTOGRAM_FILE=insert_size_histogram.pdf
samtools depth -a sorted_dedup_reads.bam > depth_out.txt
gatk HaplotypeCaller -R D2.fa -I sorted_dedup_reads.bam -O raw_variants.vcf
gatk SelectVariants -R D2.fa -V raw_variants.vcf -select-type SNP -O raw_snps.vcf
gatk SelectVariants -R D2.fa -V raw_variants.vcf -select-type INDEL -O raw_indels.vcf
gatk VariantFiltration \
        -R D2.fa \
        -V raw_snps.vcf \
        -O filtered_snps.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 60.0" \
        -filter-name "MQ_filter" -filter "MQ < 40.0" \
        -filter-name "SOR_filter" -filter "SOR > 4.0" \
        -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
        -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0"
gatk VariantFiltration \
        -R D2.fa \
        -V raw_indels.vcf \
        -O filtered_indels.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 200.0" \
        -filter-name "SOR_filter" -filter "SOR > 10.0"
gatk SelectVariants \
        --exclude-filtered \
        -V filtered_snps.vcf \
        -O bqsr_snps.vcf
gatk SelectVariants \
        --exclude-filtered \
        -V filtered_indels.vcf \
        -O bqsr_indels.vcf
gatk BaseRecalibrator -R D2.fa -I sorted_dedup_reads.bam --known-sites bqsr_snps.vcf --known-sites bqsr_indels.vcf -O recal_data.table
gatk ApplyBQSR \
        -R D2.fa \
        -I sorted_dedup_reads.bam \
        -bqsr recal_data.table \
        -O recal_reads.bam
gatk BaseRecalibrator -R D2.fa -I recal_reads.bam --known-sites bqsr_snps.vcf --known-sites bqsr_indels.vcf -O post_recal_data.table
gatk AnalyzeCovariates -before recal_data.table -after post_recal_data.table -plots recalibration_plots.pdf
gatk HaplotypeCaller \
        -R D2.fa \
        -I recal_reads.bam \
        -O raw_variants_recal.vcf
gatk SelectVariants \
        -R D2.fa \
        -V raw_variants_recal.vcf \
        -select-type SNP \
        -O raw_snps_recal.vcf
gatk SelectVariants \
        -R D2.fa \
        -V raw_variants.vcf \
        -select-type INDEL \
        -O raw_indels_recal.vcf
gatk VariantFiltration \
-R D2.fa \
        -V raw_snps_recal.vcf \
        -O filtered_snps_final.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 60.0" \
        -filter-name "MQ_filter" -filter "MQ < 40.0" \
        -filter-name "SOR_filter" -filter "SOR > 4.0" \
        -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
        -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0"
gatk VariantFiltration \
-R D2.fa \
        -V raw_indels_recal.vcf \
        -O filtered_indels_final.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 200.0" \
        -filter-name "SOR_filter" -filter "SOR > 10.0"


