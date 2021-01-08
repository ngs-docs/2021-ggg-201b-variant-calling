rule download_data:
    conda: "env-wget.yml"
    shell: """
        wget https://osf.io/4rdza/download -O SRR2584857_1.fastq.gz
    """

rule download_genome:
    conda: "env-wget.yml"
    shell:
        "wget https://osf.io/8sm92/download -O ecoli-rel606.fa.gz"

rule map_reads:
    conda: "env-minimap.yml"
    shell: """
        minimap2 -ax sr ecoli-rel606.fa.gz SRR2584857_1.fastq.gz > SRR2584857_1.ecoli-rel606.sam
    """

rule sam_to_bam:
    conda: "env-minimap.yml"
    shell: """
        samtools view -b -F 4 SRR2584857_1.ecoli-rel606.sam > SRR2584857_1.ecoli-rel606.bam
     """

rule sort_bam:
    conda: "env-minimap.yml"
    shell: """
        samtools sort SRR2584857_1.ecoli-rel606.bam > SRR2584857_1.ecoli-rel606.bam.sorted
    """

rule call_variants:
    conda: "env-bcftools.yml"
    shell: """
        gunzip -c ecoli-rel606.fa.gz > ecoli-rel606.fa
        bcftools mpileup -Ou -f ecoli-rel606.fa SRR2584857_1.ecoli-rel606.bam.sorted > SRR2584857_1.ecoli-rel606.pileup
        bcftools call -mv -Ob SRR2584857_1.ecoli-rel606.pileup -o SRR2584857_1.ecoli-rel606.bcf
        bcftools view SRR2584857_1.ecoli-rel606.bcf > SRR2584857_1.ecoli-rel606.vcf
    """
