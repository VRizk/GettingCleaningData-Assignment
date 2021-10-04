---
title: "CodeBook"
author: "VRizk"
date: "04/10/2021"
output: html_document
---

# This CodeBook describes the variables and intermediary steps in the script provided

## Train and test
First of all, "Train" and "Test" data sets have been created binding the "X"", "Y"" and "subject" data sets from the train and test

## Unique_set
Then, "Unique_set" has been created merging the "Train" and "Test" sets

## Train_Test
A unique column data frame telling whether the measurement is coming from the train of the test set

## Activity
A unique column data frame telling which activity the measurement corresponds to whatever its provenance (train or test)

## Train_int, Test_int, Subject, Clean_set
A number of datasets created to simplify the initial "Unique_set" data set.
The idea is to have a dataset with one column "Train_Test" saying whether the measurement is coming from the train or the test, one column with the "subject", one with the "activity" performed and then, all the measurements but only once and always refer to Train_Test column to know where it was coming from

## ind
Indices of the Unique_set data set that are either IDs or measurements containing either "mean" or"std"

## Mean_Std / Mean_Std_Act
The extracted data set with only mean and std measurements. without / with the activity names

## Unique_Id_Fin
A one column data frame corresponding to a unique ID equal to the activity and the subject who has performed it

## Activity_Subject
Grouping by Unique_Id_Fin

## Activity_Subject_Mean
Summary of Activity_Subject taking the mean of each measurement per activity x subject

