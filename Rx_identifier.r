# Rx_identifier
# Based on the ratio of X chromosome-derived shotgun sequencing data to the autosomal coverage to establish the probability of an XX or XY karyotype for ancient samples.

#The name of the sample is received.
args=(commandArgs(TRUE))
PREFIX=as.character(args[1])

#The idxstats file is opened and the first 39 rows are read.
idxstats<-read.table(paste('/scratch/124-dogs/sex/',PREFIX,'.idxstats',sep=''),header=F,nrows=39,row.names=1)
#The chromosome lengths are stored in a vector.
c1 <- c(as.numeric(idxstats[,1]))
#The mapped read segments are stored in another vector.
c2 <- c(as.numeric(idxstats[,2]))
#The total for both vectors is calculated.
total_ref <- sum(c1)
total_map <- sum(c2)

#A linear regression is calculated using those vectors.
LM <- lm(c1~c2)
summary(LM)  

#Then, for each chromosome, the "ratio of the alignments to each chromosome 
#to the total number of alignments to autosomes and sex chromosomes" is calculated.  
Rt1 <- (idxstats[1,2]/total_map)/(idxstats[1,1]/total_ref)
Rt2 <- (idxstats[2,2]/total_map)/(idxstats[2,1]/total_ref)
Rt3 <- (idxstats[3,2]/total_map)/(idxstats[3,1]/total_ref)
Rt4 <- (idxstats[4,2]/total_map)/(idxstats[4,1]/total_ref)
Rt5 <- (idxstats[5,2]/total_map)/(idxstats[5,1]/total_ref)
Rt6 <- (idxstats[6,2]/total_map)/(idxstats[6,1]/total_ref)
Rt7 <- (idxstats[7,2]/total_map)/(idxstats[7,1]/total_ref)
Rt8 <- (idxstats[8,2]/total_map)/(idxstats[8,1]/total_ref)
Rt9 <- (idxstats[9,2]/total_map)/(idxstats[9,1]/total_ref)
Rt10 <- (idxstats[10,2]/total_map)/(idxstats[10,1]/total_ref)
Rt11 <- (idxstats[11,2]/total_map)/(idxstats[11,1]/total_ref)
Rt12 <- (idxstats[12,2]/total_map)/(idxstats[12,1]/total_ref)
Rt13 <- (idxstats[13,2]/total_map)/(idxstats[13,1]/total_ref)
Rt14 <- (idxstats[14,2]/total_map)/(idxstats[14,1]/total_ref)
Rt15 <- (idxstats[15,2]/total_map)/(idxstats[15,1]/total_ref)
Rt16 <- (idxstats[16,2]/total_map)/(idxstats[16,1]/total_ref)
Rt17 <- (idxstats[17,2]/total_map)/(idxstats[17,1]/total_ref)
Rt18 <- (idxstats[18,2]/total_map)/(idxstats[18,1]/total_ref)
Rt19 <- (idxstats[19,2]/total_map)/(idxstats[19,1]/total_ref)
Rt20 <- (idxstats[20,2]/total_map)/(idxstats[20,1]/total_ref)
Rt21 <- (idxstats[21,2]/total_map)/(idxstats[21,1]/total_ref)
Rt22 <- (idxstats[22,2]/total_map)/(idxstats[22,1]/total_ref)
Rt23 <- (idxstats[23,2]/total_map)/(idxstats[23,1]/total_ref)
Rt24 <- (idxstats[24,2]/total_map)/(idxstats[24,1]/total_ref)
Rt25 <- (idxstats[25,2]/total_map)/(idxstats[25,1]/total_ref)
Rt26 <- (idxstats[26,2]/total_map)/(idxstats[26,1]/total_ref)
Rt27 <- (idxstats[27,2]/total_map)/(idxstats[27,1]/total_ref)
Rt28 <- (idxstats[28,2]/total_map)/(idxstats[28,1]/total_ref)
Rt29 <- (idxstats[29,2]/total_map)/(idxstats[29,1]/total_ref)
Rt30 <- (idxstats[30,2]/total_map)/(idxstats[30,1]/total_ref)
Rt31 <- (idxstats[31,2]/total_map)/(idxstats[31,1]/total_ref)
Rt32 <- (idxstats[32,2]/total_map)/(idxstats[32,1]/total_ref)
Rt33 <- (idxstats[33,2]/total_map)/(idxstats[33,1]/total_ref)
Rt34 <- (idxstats[34,2]/total_map)/(idxstats[34,1]/total_ref)
Rt35 <- (idxstats[35,2]/total_map)/(idxstats[35,1]/total_ref)
Rt36 <- (idxstats[36,2]/total_map)/(idxstats[36,1]/total_ref)
Rt37 <- (idxstats[37,2]/total_map)/(idxstats[37,1]/total_ref)
Rt38 <- (idxstats[38,2]/total_map)/(idxstats[38,1]/total_ref)
Rt39 <- (idxstats[39,2]/total_map)/(idxstats[39,1]/total_ref)

#A new vector is created containing the ratio Xchr/everyChr.
tot <- c(Rt39/Rt1,Rt39/Rt2,Rt39/Rt3,Rt39/Rt4,Rt39/Rt5,Rt39/Rt6,Rt39/Rt7,Rt39/Rt8,Rt39/Rt9,Rt39/Rt10,Rt39/Rt11,Rt39/Rt12,Rt39/Rt13,Rt39/Rt14,Rt39/Rt15,Rt39/Rt16,Rt39/Rt17,Rt39/Rt18,Rt39/Rt19,Rt39/Rt20,Rt39/Rt21,Rt39/Rt22,Rt39/Rt23,Rt39/Rt24,Rt39/Rt25,Rt39/Rt26,Rt39/Rt27,Rt39/Rt28,Rt39/Rt29,Rt39/Rt30,Rt39/Rt31,Rt39/Rt32,Rt39/Rt33,Rt39/Rt34,Rt39/Rt35,Rt39/Rt36,Rt39/Rt37,Rt39/Rt38)
#Then, the relative coverage for chrX is calculated, with its interval of confidence.
Rx <- mean(tot)
cat("Rx :",Rx,"\n")
confinterval <- 1.96*(sd(tot)/sqrt(38))
CI1 <- Rx-confinterval
CI2 <- Rx+confinterval
cat("95% CI :",CI1, CI2,"\n")

#Depending on the ends of the interval of confidence, the sex is assigned.
if (CI1 > 0.8) {print ("Sex assignment:The sample should be assigned as Female")
} else if (CI2 < 0.6) {print ("Sex assignment:The sample should be assigned as Male")
} else if (CI1 > 0.6 & CI2 > 0.8) {print ("Sex assignment:The sample is consistent with XX but not XY")
} else if (CI1 < 0.6 & CI2 < 0.8) {print ("Sex assignment:The sample is consistent with XY but not XX")
} else print ("Sex assignment:The sample could not be assigned")

print ("***It is important to realize that the assignment is invalid, if there is no correlation between the number of reference reads and that of the mapped reads***")

