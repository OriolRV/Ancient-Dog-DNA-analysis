#install.packages("zoom")
library("zoom")

##########
#PCA plot#
##########

###ADS###

#First, the files are loaded and modified accordingly to the needs.
print("Plot PCA ads")
eigenvectors1 <- read.table("newads.egve",col.names=c("Sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Pop"))
eigenvectors1$Sample <- sub(":.*","",eigenvectors1$Sample)
species <- read.table("pop_spc.txt",col.names=c("Sample","Origin","Species"))
species$Origin <- NULL
complete_table1 <- merge(eigenvectors1,species,by="Sample")
head(complete_table1)
nrow(complete_table1)
ncol(complete_table1)

#Then, the plot is performed.
plot(complete_table1$PC1,complete_table1$PC2,xlab="PC1",ylab="PC2",
     col=ifelse(complete_table1$Pop=="Africa","#ea5f5d",
                ifelse(complete_table1$Pop=="Asia","#ecf94c",
                       ifelse(complete_table1$Pop=="Europe","#6fed75",
                              ifelse(complete_table1$Pop=="North_America","#6dc6d7",
                                     ifelse(complete_table1$Pop=="Oceania","#cb0ae8",
                                            ifelse(complete_table1$Pop=="Unknown","#d7d7d7",
                                                   "black")))))),
     pch=ifelse(complete_table1$Species=="Breed",19,
                ifelse(complete_table1$Species=="Village",15,
                       ifelse(complete_table1$Species=="Indigenous",18,
                              8))))

#The ancient sample names are also added.
f <- function(x) {if (x[13]=="Unknown") {text(as.double(x[2]),as.double(x[3]),labels=x[1],pos=3,cex=0.5)}}
apply(complete_table1,1,f)

#The desired sections are zoomed.
zoomplot.zoom(xlim=c(0.0115,0.024),ylim=c(-0.04,0.006))

#To retrieve information about a specific section
complete_table1$c14 <- ifelse(complete_table1$PC1 > 0.0115 & complete_table1$PC1 <= 0.024 & complete_table1$PC2 >= -0.04 & complete_table1$PC2 <= 0.006, 'cloud', 'not' )
ncol(complete_table1)
head(complete_table1)
cloud <- complete_table1[complete_table1$c14 == "cloud", ]
cloud
nrow(cloud)
#write.table(upcloud, "upcloud.txt", append = FALSE, sep = " ", dec = ".", row.names = TRUE, col.names = TRUE)

#Finally, the legend is added.
legend("bottom",title="Continent                   Type",
       title.adj=0.1,bg="#edebe9",ncol=2,
       legend=c("Africa","Asia","Europe","North America","Oceania","Unknown","Breed","Indigenous","Village","Ancient Samples",NA,NA),
       pch=c(22,22,22,22,22,22,19,18,15,8,NA,NA),
       pt.bg=c("#ea5f5d","#ecf94c","#6fed75","#6dc6d7","#cb0ae8","#d7d7d7","transparent","transparent","transparent","transparent",NA,NA))
	   
###ADWS###

#First, the files are loaded and modified accordingly to the needs.
print("Plot PCA adws")
eigenvectors2 <- read.table("newadws.egve",col.names=c("Sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Pop"))
eigenvectors2$Sample <- sub(":.*","",eigenvectors2$Sample)
species <- read.table("pop_spc.txt",col.names=c("Sample","Origin","Species"))
species$Origin <- NULL
complete_table2 <- merge(eigenvectors2,species,by="Sample")
head(complete_table2)
nrow(complete_table2)
ncol(complete_table2)

#Then, the plot is performed.
plot(complete_table2$PC1,complete_table2$PC2,xlab="PC1",ylab="PC2",
     col=ifelse(complete_table2$Pop=="Africa","#ea5f5d",
                ifelse(complete_table2$Pop=="Asia","#ecf94c",
                       ifelse(complete_table2$Pop=="Europe","#6fed75",
                              ifelse(complete_table2$Pop=="North_America","#6dc6d7",
                                     ifelse(complete_table2$Pop=="Oceania","#cb0ae8",
                                            ifelse(complete_table2$Pop=="Unknown","#d7d7d7",
                                                   "black")))))),
     pch=ifelse(complete_table2$Species=="Breed",19,
                ifelse(complete_table2$Species=="Village",15,
                       ifelse(complete_table2$Species=="Indigenous",18,
                              ifelse(complete_table2$Species=="Wolf",17,
                              8)))))

#The desired sections are zoomed.
zoomplot.zoom(xlim=c(-0.035,-0),ylim=c(-0.03,0.02))

#Finally, the legend is added.
legend("topleft",title="Continent                   Type",
       title.adj=0.1,bg="#edebe9",ncol=2,
       legend=c("Africa","Asia","Europe","North America","Oceania","Unknown","Breed","Indigenous","Village","Wolf","Ancient Samples",NA),
       pch=c(22,22,22,22,22,22,19,18,15,17,8,NA),
       pt.bg=c("#ea5f5d","#ecf94c","#6fed75","#6dc6d7","#cb0ae8","#d7d7d7","transparent","transparent","transparent","transparent","transparent",NA))

#The ancient sample names are also added.
f <- function(x) {if (x[13]=="Unknown") {text(as.double(x[2]),as.double(x[3]),labels=x[1],pos=3)}}
apply(complete_table2,1,f)


