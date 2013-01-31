# peak1.bed: sample 1 peak list
# peak2.bed: sample 2 peak list
# read1.bed: sample 1 read used for mapping to peaks
# read2.bed: sample 2 read used for mapping to peaks
# peak1_dump.bed: sample 1 peaks not used
# peak2_dump.bed: sample 2 peaks not used
# read1_dump.bed: sample 1 read NOT used for mapping to peaks
# read2_dump.bed: sample 2 read NOT used for mapping to peaks
if [ $# -eq 7 ]
then
	fname=$1
	mkdir $fname #TODO: write catch for this
	echo $@ > ./$fname/${1}.log
	echo "StepI: clean input"
	#global variables must be accessed differently in awk
	zcat $2 | sed 's/\s$//g' | awk -v fname="$fname" 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $1 !~/random/ && $3>$2 && $2>0 && $3>0)
			print $1,$2,$3>"./"fname"/tmp_peak1.bed";
		else 
			print $0 > "./"fname"/tmp_peak1_exclude.bed"}'
	zcat $3 | sed 's/\s$//g' | awk -v fname="$fname" 'BEGIN {OFS="\t"}
		{if ($$1~/chr/ && 1 !="chrM"  && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2,$3>"./"fname"/tmp_peak2.bed";
		else 
			print $0 > "./"fname"/tmp_peak2_exclude.bed"}' 
	#shift NOT extend, ideally would also check for end of chr
	zcat $4 | sed 's/\s$//g' | awk -v fname="$fname" -v shift1=$6 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $6=="+" && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2+shift1,$3+shift1>"./"fname"/tmp_read1.bed";
		else if ($1~/chr/  && $1 !="chrM" && $6=="-" && $1 !~/random/ && $3>$2  && $2>shift1 && $3>shift1)
			print $1,$2-shift1,$3-shift1>"./"fname"/tmp_read1.bed";
		else 
			print $0 > "./"fname"/tmp_read1_exclude.bed"}'
	zcat $5 | sed 's/\s$//g' | awk -v fname="$fname" -v shift2=$7 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $6=="+" && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2+shift2,$3+shift2>"./"fname"/tmp_read2.bed";
		else if ($1~/chr/  && $1 !="chrM" && $6=="-" && $1 !~/random/ && $3>$2  && $2>shift2 && $3>shift2)
			print $1,$2-shift2,$3-shift2>"./"fname"/tmp_read2.bed";
		else 
			print $0 > "./"fname"/tmp_read2_exclude.bed"}'
	echo "wc -l tmp_read1.bed `wc -l ./$fname/tmp_read1.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read2.bed `wc -l ./$fname/tmp_read2.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read1_exclude.bed `wc -l ./$fname/tmp_read1_exclude.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read2_exclude.bed `wc -l ./$fname/tmp_read2_exclude.bed`" >> ./$fname/${1}.log
elif [ $# -eq 11 ]
then 
	#mostly copied from above
	#add functionality to combine replicates
	#"proper" way would be to downscale replicates so that both contribute equally (not done)
	fname=$1 
	mkdir $fname 
	echo $@ > ./$fname/${1}.log
	echo "StepI: clean input"
	zcat $2 | sed 's/\s$//g' | awk -v fname="$fname" 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $1 !~/random/ && $3>$2 && $2>0 && $3>0)
			print $1,$2,$3>"./"fname"/tmp_peak1.bed";
		else 
			print $0 > "./"fname"/tmp_peak1_exclude.bed"}'
	zcat $3 | sed 's/\s$//g' | awk -v fname="$fname" 'BEGIN {OFS="\t"}
		{if ($$1~/chr/ && 1 !="chrM"  && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2,$3>"./"fname"/tmp_peak2.bed";
		else 
			print $0 > "./"fname"/tmp_peak2_exclude.bed"}' 
	#shift NOT extend, ideally would also check for end of chr
	zcat $4 | sed 's/\s$//g' | awk -v fname="$fname" -v shift1a=$8 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $6=="+" && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2+shift1a,$3+shift1a>"./"fname"/tmp_read1a.bed";
		else if ($1~/chr/  && $1 !="chrM" && $6=="-" && $1 !~/random/ && $3>$2  && $2>shift1a && $3>shift1a)
			print $1,$2-shift1a,$3-shift1a>"./"fname"/tmp_read1a.bed";
		else 
			print $0 > "./"fname"/tmp_read1a_exclude.bed"}'
	zcat $5 | sed 's/\s$//g' | awk -v fname="$fname" -v shift1b=$9 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $6=="+" && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2+shift1b,$3+shift1b>"./"fname"/tmp_read1b.bed";
		else if ($1~/chr/  && $1 !="chrM" && $6=="-" && $1 !~/random/ && $3>$2  && $2>shift1b && $3>shift1b)
			print $1,$2-shift1b,$3-shift1b>"./"fname"/tmp_read1b.bed";
		else 
			print $0 > "./"fname"/tmp_read1b_exclude.bed"}'	
	zcat $6 | sed 's/\s$//g' | awk -v fname="$fname" -v shift2a=$10 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $6=="+" && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2+shift2a,$3+shift2a>"./"fname"/tmp_read2a.bed";
		else if ($1~/chr/  && $1 !="chrM" && $6=="-" && $1 !~/random/ && $3>$2  && $2>shift2a && $3>shift2a)
			print $1,$2-shift2a,$3-shift2a>"./"fname"/tmp_read2a.bed";
		else 
			print $0 > "./"fname"/tmp_read2a_exclude.bed"}'
	zcat $7 | sed 's/\s$//g' | awk -v fname="$fname" -v shift2b=$11 'BEGIN {OFS="\t"}
		{if ($1~/chr/ && $1 !="chrM" && $6=="+" && $1 !~/random/ && $3>$2  && $2>0 && $3>0)
			print $1,$2+shift2b,$3+shift2b>"./"fname"/tmp_read2b.bed";
		else if ($1~/chr/  && $1 !="chrM" && $6=="-" && $1 !~/random/ && $3>$2  && $2>shift2b && $3>shift2b)
			print $1,$2-shift2b,$3-shift2b>"./"fname"/tmp_read2b.bed";
		else 
			print $0 > "./"fname"/tmp_read2b_exclude.bed"}'
	cat ./$fname/tmp_read1a.bed ./$fname/tmp_read1b.bed > ./$fname/tmp_read1.bed
	cat ./$fname/tmp_read2a.bed ./$fname/tmp_read2b.bed > ./$fname/tmp_read2.bed
	echo "wc -l tmp_read1a.bed `wc -l ./$fname/tmp_read1a.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read1b.bed `wc -l ./$fname/tmp_read1b.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read2a.bed `wc -l ./$fname/tmp_read2a.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read2b.bed `wc -l ./$fname/tmp_read2b.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read1a_exclude.bed `wc -l ./$fname/tmp_read1a_exclude.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read1b_exclude.bed `wc -l ./$fname/tmp_read1b_exclude.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read2a_exclude.bed `wc -l ./$fname/tmp_read2a_exclude.bed`" >> ./$fname/${1}.log
	echo "wc -l tmp_read2b_exclude.bed `wc -l ./$fname/tmp_read2b_exclude.bed`" >> ./$fname/${1}.log
else
  #basename command will remove the directory part of the file as well as the suffix
  echo "$# arguments found"
  echo "Usage: `basename $0` foldername peak1.bed peak2.bed read1.bed read2.bed shift1 shift2"
  echo "or `basename $0` foldername peak1.bed peak2.bed read1a.bed read1b.bed read2a.bed read2b.bed shift1a shift1b shift2a shift2b"
  exit
fi


#####################################################################################################
echo "StepII: classify common or unique peaks"
#the sort is in non-ASCII order ie 1, 10, 11, etc
intersectBed -a ./$fname/tmp_peak1.bed -b ./$fname/tmp_peak2.bed -u | sort -k1,1 -k2,2n -k3,3n > ./$fname/tmp_common_peak1.bed &
intersectBed -a ./$fname/tmp_peak2.bed -b ./$fname/tmp_peak1.bed -u | sort -k1,1 -k2,2n -k3,3n > ./$fname/tmp_common_peak2.bed &
intersectBed -a ./$fname/tmp_peak1.bed -b ./$fname/tmp_peak2.bed -v | sort -k1,1 -k2,2n -k3,3n > ./$fname/tmp_unique_peak1.bed &
intersectBed -a ./$fname/tmp_peak2.bed -b ./$fname/tmp_peak1.bed -v | sort -k1,1 -k2,2n -k3,3n > ./$fname/tmp_unique_peak2.bed &
wait

cat ./$fname/tmp_common_peak1.bed ./$fname/tmp_common_peak2.bed | mergeBed > ./$fname/tmp_common_peak.bed
echo "wc -l tmp_common_peak.bed `wc -l ./$fname/tmp_common_peak.bed`" >> ./$fname/${1}.log
#cat common_peak1.bed common_peak2.bed > temp_common_peak.bed
#mergeBed -i temp_common_peak.bed > common_peak.bed

#####################################################################################################
echo "StepIII: count peak read"
if [ -f ./$fname/tmp_MAnorm.bed ];
then
rm ./$fname/tmp_MAnorm.bed
fi
coverageBed -a ./$fname/tmp_read1.bed -b ./$fname/tmp_unique_peak1.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"unique_peak1" >> "./"fname"/tmp_MAnorm.bed"; print $4 > "./"fname"/tmp_unique_peak1_count_read1"}'
coverageBed -a ./$fname/tmp_read2.bed -b ./$fname/tmp_unique_peak1.bed | awk -v fname="$fname" '{print $4 > "./"fname"/tmp_unique_peak1_count_read2"}'
coverageBed -a ./$fname/tmp_read1.bed -b ./$fname/tmp_common_peak1.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"common_peak1" >> "./"fname"/tmp_MAnorm.bed";print $4 > "./"fname"/tmp_common_peak1_count_read1"}'
coverageBed -a ./$fname/tmp_read2.bed -b ./$fname/tmp_common_peak1.bed | awk -v fname="$fname" '{print $4 > "./"fname"/tmp_common_peak1_count_read2"}'
coverageBed -a ./$fname/tmp_read1.bed -b ./$fname/tmp_common_peak2.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"common_peak2"  >> "./"fname"/tmp_MAnorm.bed";print $4 > "./"fname"/tmp_common_peak2_count_read1"}'
coverageBed -a ./$fname/tmp_read2.bed -b ./$fname/tmp_common_peak2.bed | awk -v fname="$fname" '{print $4 > "./"fname"/tmp_common_peak2_count_read2"}'
coverageBed -a ./$fname/tmp_read1.bed -b ./$fname/tmp_unique_peak2.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"unique_peak2">> "./"fname"/tmp_MAnorm.bed";print $4 > "./"fname"/tmp_unique_peak2_count_read1"}'
coverageBed -a ./$fname/tmp_read2.bed -b ./$fname/tmp_unique_peak2.bed | awk -v fname="$fname" '{print $4 > "./"fname"/tmp_unique_peak2_count_read2"}'

cat ./$fname/tmp_common_peak1_count_read1 ./$fname/tmp_common_peak2_count_read1 > ./$fname/tmp_common_peak_count_read1
cat ./$fname/tmp_common_peak1_count_read2 ./$fname/tmp_common_peak2_count_read2 > ./$fname/tmp_common_peak_count_read2
cat ./$fname/tmp_unique_peak1_count_read1 ./$fname/tmp_common_peak1_count_read1 ./$fname/tmp_common_peak2_count_read1 ./$fname/tmp_unique_peak2_count_read1 > ./$fname/tmp_peak_count_read1
cat ./$fname/tmp_unique_peak1_count_read2 ./$fname/tmp_common_peak1_count_read2 ./$fname/tmp_common_peak2_count_read2 ./$fname/tmp_unique_peak2_count_read2 > ./$fname/tmp_peak_count_read2

if [ -f ./"fname"/tmp_MAnorm_merge.bed ];
then
rm ./"fname"/tmp_MAnorm_merge.bed
fi

cat ./$fname/tmp_unique_peak1.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"tmp_unique_peak1" >> "./"fname"/tmp_MAnorm_merge.bed"}'
coverageBed -a ./$fname/tmp_read1.bed -b ./$fname/tmp_common_peak.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"merged_common_peak" >> "./"fname"/tmp_MAnorm_merge.bed"; print $4 > "./"fname"/tmp_merge_common_read1"}'
coverageBed -a ./$fname/tmp_read2.bed -b ./$fname/tmp_common_peak.bed | awk -v fname="$fname" '{print $4 > "./"fname"/tmp_merge_common_read2"}'
cat ./$fname/tmp_unique_peak2.bed | awk -v fname="$fname" 'BEGIN {OFS="\t"} {print $1,$2,$3,"tmp_unique_peak2" >> "./"fname"/tmp_MAnorm_merge.bed"}'

cat ./$fname/tmp_unique_peak1_count_read1 ./$fname/tmp_merge_common_read1 ./$fname/tmp_unique_peak2_count_read1 > ./$fname/tmp_merge_common_peak_count_read1
cat ./$fname/tmp_unique_peak1_count_read2 ./$fname/tmp_merge_common_read2 ./$fname/tmp_unique_peak2_count_read2 > ./$fname/tmp_merge_common_peak_count_read2

#####################################################################################################
echo "SetpIV: normalize using common peaks"
#R --vanilla MAnorm.r >Rcommand.out 
#R CMD BATCH ../MAnorm.r Rcommand.out
cd ./$fname/
#R --no-restore --save < ../MAnorm2.r ${1}_Rcommand.out 
#doesnt load .R that might slow things down but still loads usr+global env 
#doesnt redirect nicely
R CMD BATCH ../MAnorm2.r ${1}_Rcommand.out 
cd ..

#This is not a proper wig, I think it is a bed (check)
#for format definition see: http://genome.ucsc.edu/goldenPath/help/wiggle.html
#This is just a bed + score
#awk -v fname="$fname" 'BEGIN{OFS="\t"}{if($4~/1/) print $1,$2,$3,$7>"./"fname"/${1}_sample1_peaks.wig"}' MAnorm_result.xls
#awk -v fname="$fname" 'BEGIN{OFS="\t"}{if($4~/2/) print $1,$2,$3,$7>"./"fname"/${1}_sample2_peaks.wig"}' MAnorm_result.xls

#####################################################################################################
#cleanup
rm tmp_*

# rm temp_common_peak.bed
# rm *count*
# rm *read1*
# rm *read2*
# rm *peak1*
# rm *peak2*
# rm MAnorm.bed
# rm MAnorm_merge.bed
# rm common_peak.bed