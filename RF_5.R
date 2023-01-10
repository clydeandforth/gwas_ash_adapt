library(randomForest)
require(caTools)
#library(reprtree)
library(ggraph)
library(igraph)
library(data.table)
library(caret)
library(e1071)
library(tidyverse)

setwd(".")

Markers2<-read.table("RF5_ready1000001.hap", header = TRUE)

Markers3 <- Markers2[,-1]
rownames(Markers3) <- Markers2[,1]

mat.t<-t(Markers3)
Pheno2 <-read.table("Match_bam_2_health.csv", sep = ",", header=TRUE)
Pheno3<-as.data.frame(Pheno2[,c("Health.difference.from.site.average", "Bud.burst.difference.from.site.average", "Color")])
names(Pheno3)[1]<-paste("Health") 
names(Pheno3)[2]<-paste("Bud_burst") 

training_table1<-as.data.frame(cbind(mat.t, Pheno3$Health))
names(training_table1)[1000001]<-paste("Health") 

apply_fun <- function() {
  

  sample = sample.split(training_table1$Health, SplitRatio = .5)

  train = subset(training_table1, sample == TRUE)
  test  = subset(training_table1, sample == FALSE)

  varNames <- names(training_table1)

  varNames <- varNames[!varNames %in% "Health_difference"]
  names(training_table1)<-make.names(names(training_table1))

  varNames1 <- paste(varNames, collapse = "+")
  rf.form <- as.formula(paste("Health_difference", varNames1, sep = " ~ "))

  #rf_classifier_JD <- randomForest(Health ~ ., data=train , ntree=500, mtry=6, importance=TRUE,keep.inbag=TRUE, do.trace=100,proximities=TRUE )
  rf_classifier_JD <- randomForest(x = train[, colnames(train) != "Health"],
                   y = train$Health, ntree=500, mtry=6, importance=TRUE,keep.inbag=TRUE, do.trace=100,proximities=TRUE)

  pred=predict(rf_classifier_JD, newdata = test)
  #confusionMatrix(pred, training_table1$Health_difference)
  table(pred, test$Health)
  mean(pred == test$Health)                    


  results<-cbind(pred,test$Health)

  colnames(results)<-c('pred','real')

  results<-as.data.frame(results)

  mod1<-lm(results$pred ~ results$real)
  summary(mod1)$adj.r.squared
  
}

#output_1000 <- lapply(c(1:1000), function(x) {set.seed(x);apply_fun()})
output_100 <- lapply(c(1:100), function(x) {set.seed(x);apply_fun()})

#Reduce("mean", output_1000)     
Reduce("mean", output_100)

# This works
#rf_classifier_JD <- randomForest(x = train[, colnames(train) != "Health"],
#                   y = train$Health, ntree=100, mtry=6, importance=TRUE,keep.inbag=TRUE, do.trace=100,proximities=TRUE)





lb1 <- paste("R^2 == 0.65")
p1<-ggplot(results, aes(x = pred, y = real)) +
  annotate(geom="text", x = -10, y = 25, colour = "black", size=5, label=lb1, parse=TRUE)+
  xlab("Predicted results")+
  ylab("Actual results") +
  geom_point() +
  stat_smooth(method = lm)


png("RF_Angsd_health_50.png", width = 12, height = 8, units = 'in', res = 300)
plot (p1)# Make plot
dev.off() 

