# Keying the drug company data
# S. Kirmer
# Feb 2017
# Data4Democracy

library(dplyr)
library(data.table)
library(reshape2)
library(sem)
library(doBy)
library(ggplot2)
library(AER)
library(ivpack)
library(readxl)
library(RecordLinkage)
library(stringr)
library(gdata)
library(stringdist)
library(stats)

companies_drugs <- read.csv("U://Medicaid_Drug/drugdata_clean.csv", stringsAsFactors = FALSE)
lobbying <- read.csv("U://Medicaid_Drug/lobbying_data.csv", stringsAsFactors = FALSE)
#Source for lobbying data: https://data.world/data4democracy/drug-spending/file/Pharma_Lobby.csv

c_names <- unique(companies_drugs$LABELER.NAME)
l_names <- toupper(unique(lobbying$client))

c_names2 <- cbind(c_names, seq(1:length(c_names))) #Just adding a record indexing identifier
l_names2 <- cbind(l_names, seq(1:length(l_names)))

# ========== Prep for some probabilistic matching ============ ####

#You want to start with two unique lists, to the best of your ability.
#In this case we want to cut away things like "INC" or "CO" because that stuff is going to get in the way of clean matches.

c_cut_name <- gsub(" INC| LTD| CORPORATION| CORP| USA| US| COMPANY| & CO| CO| PLC| LLC|\\.|\\,| PHARMACEUTICAL| PHARMACEUTICALS| PHARMA","", c_names2[,"c_names"])
c_names3 <- as.data.frame(cbind(c_names2, c_cut_name))

l_cut_name <- gsub(" INC| LTD| CORPORATION| CORP| USA| US| COMPANY| & CO| CO| PLC| LLC|\\.|\\,| PHARMACEUTICAL| PHARMACEUTICALS| PHARMA","", l_names2[,"l_names"])
l_names3 <- as.data.frame(cbind(l_names2, l_cut_name))

# The data needs to not be factor
l_names3$V2 <- as.character(l_names3$V2)
c_names3$V2 <- as.character(c_names3$V2)
l_names3$l_cut_name <- as.character(l_names3$l_cut_name)
c_names3$c_cut_name <- as.character(c_names3$c_cut_name)


# ========== Do the Match! ============ ####

#Assess match quality - matching on name, omitting the record indexing identifier ####
match_check <- compare.linkage(l_names3[, c("l_cut_name", "V2")],
                               c_names3[, c("c_cut_name", "V2")],
                               blockfld = FALSE, exclude = c(2), strcmp = TRUE, strcmpfun = jarowinkler)

#Take the output from the linkage creator and clean up a tad
match_check_pairs <- as.data.frame(match_check$pairs)
l_names3$rownames <- rownames(l_names3)
c_names3$rownames <- rownames(c_names3)

check_pairs <- merge(match_check_pairs,l_names3, by.x="id1", by.y="rownames")
check_pairs <- merge(check_pairs,c_names3, by.x="id2", by.y="rownames")

#And now we have our cleaned up probability list. The field ends up being called "l_cut_name.x", oh well.
head(check_pairs)


# ========== Evaluate Results ============ ####

#Our next step, then, is to see what the probability threshold is. Most of the attempted matches will be bunk, so we filter.
above_90 <- dplyr::filter(check_pairs, l_cut_name.x > .9)
above_90[order(-above_90$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

#Save the ones that look decent to a dataframe that we'll keep adding to.
#100% matches are easy picks
goodmatches <- dplyr::filter(check_pairs, l_cut_name.x == 1)
goodmatches

#Keep looking for anything decent - 95%?
above_95 <- dplyr::filter(check_pairs, l_cut_name.x > .95 & l_cut_name.x < 1)
above_95[order(-above_95$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

#At the early stages, most matches will be all right, so you just bind with an omit index. Later you'll start binding with selection.
goodmatches <- rbind(goodmatches, above_95[-c(2),])
goodmatches

#checking 90-95%
a90_95 <- dplyr::filter(check_pairs, l_cut_name.x > .90 & l_cut_name.x <= .95)
a90_95[order(-a90_95$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

goodmatches <- rbind(goodmatches, a90_95[-c(9,44,32,20,1,5,27,18,3,26,23,24,2,34,37,38,30,43,19,40,7,6,25,39),])
goodmatches

#checking 88-90% - try to keep the breaks small so you can review.
#We're well into selection binding territory now, but still finding some good ones.
a88_90 <- dplyr::filter(check_pairs, l_cut_name.x > .88 & l_cut_name.x <= .90)
a88_90[order(-a88_90$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

goodmatches <- rbind(goodmatches, a88_90[c(2, 35,31,27,1,5,21,13,14),])
goodmatches

#checking 86-88%
a86_88 <- dplyr::filter(check_pairs, l_cut_name.x > .86 & l_cut_name.x <= .88)
a86_88[order(-a86_88$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

goodmatches <- rbind(goodmatches, a86_88[c(18,36,25,37,9,5,6),])
goodmatches

#checking 84-86%
a84_86 <- dplyr::filter(check_pairs, l_cut_name.x > .84 & l_cut_name.x <= .86)
a84_86[order(-a84_86$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

goodmatches <- rbind(goodmatches, a84_86[c(45,36,63,11,37,78, 10),])
goodmatches

#checking 83-84%
a83_84 <- dplyr::filter(check_pairs, l_cut_name.x > .83 & l_cut_name.x <= .84)
a83_84[order(-a83_84$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

goodmatches <- rbind(goodmatches, a83_84[c(9,3,6,52),])
goodmatches

#checking 82-83%
a82_83 <- dplyr::filter(check_pairs, l_cut_name.x > .82 & l_cut_name.x <= .83)
a82_83[order(-a82_83$l_cut_name.x),c("l_cut_name.x", "l_cut_name.y", "c_cut_name", "l_names", "c_names")]

goodmatches <- rbind(goodmatches, a82_83[c(38,8),])
goodmatches


# ========== Create Key Values ============ ####

#Looks like this is a good stopping point. So now we have our list of good matches. (Almost 200!)
#To set a key list, we should take this list and make a unique list of the codr values, because they are cleaned and known to be unique. 
#Each of those gets a key value, which will be used dict style to apply to the lob values.
companies_list <- list(unique(as.character(goodmatches$c_names)), as.numeric(as.character(paste0(seq(1:length(unique(as.character(goodmatches$c_names)))), "1001"))))

#Since R doesn't have dicts, you can just use it this way, making reference calls, if you want to:
companies_list[[1]][1]
companies_list[[2]][1]

#Just for convenience I'm also making a df version that I'll use to do merges:
companies_table <- as.data.frame(cbind(unlist(companies_list[[1]]), unlist(companies_list[[2]])))


# ======= Apply the key ============ #

#easy!
keyed_companies <- merge(goodmatches[,c("c_names", "l_names")],companies_table, by.x="c_names", by.y="V1")
colnames(keyed_companies)[3] <- "company_key"
keyed_companies$company_key <- as.numeric(as.character(keyed_companies$company_key))

#To get back to the beginning, then, let's return to our original datasets and key those.
#Remember, a lot of the records won't get a key in this because they didn't match.
companies_drugs_keyed <- merge(companies_drugs, keyed_companies[,c("c_names", "company_key")], by.x="LABELER.NAME", by.y="c_names", all=T)
lobbying$client <- toupper(lobbying$client)
lobbying_keyed <- merge(lobbying, keyed_companies[,c("l_names", "company_key")], by.x="client", by.y="l_names", all=T)


# ============== Keys for nonmatched ===================== #

#Now it's time to add keys for those in each file that didn't get records. 

lobby_list <- unique(lobbying_keyed$client[is.na(lobbying_keyed$company_key)])
key_list <- paste0(seq(117,5000), "1002") #using 1002 as the suffix to identify lobbying nonmatches.
lobby_list_table <- as.data.frame(cbind(lobby_list, key_list[1:length(lobby_list)]))
lobbying_keyed <- merge(lobbying_keyed, lobby_list_table, by.x=c("client"), by.y=c("lobby_list"), all=T)
lobbying_keyed$company_key <- ifelse(is.na(lobbying_keyed$company_key), as.numeric(as.character(lobbying_keyed$V2)), lobbying_keyed$company_key)

cd_list <- unique(companies_drugs_keyed$LABELER.NAME[is.na(companies_drugs_keyed$company_key)])
key_list <- paste0(seq(1240,5000), "1003") #using 1003 as the suffix to identify company-drug nonmatches.
cd_list_table <- as.data.frame(cbind(cd_list, key_list[1:length(cd_list)]))
companies_drugs_keyed <- merge(companies_drugs_keyed, cd_list_table, by.x=c("LABELER.NAME"), by.y=c("cd_list"), all=T)
companies_drugs_keyed$company_key <- ifelse(is.na(companies_drugs_keyed$company_key), as.numeric(as.character(companies_drugs_keyed$V2)), companies_drugs_keyed$company_key)


# ========== Conclusion ============ ####

#Clean up the messy bits
lobbying_keyed <- lobbying_keyed[,-8]
companies_drugs_keyed <- companies_drugs_keyed[,-15]


#Save the keyed files!
write.csv(lobbying_keyed, "U://Medicaid_Drug/lobbying_keyed.csv")
write.csv(companies_drugs_keyed, "U://Medicaid_Drug/companies_drugs_keyed.csv")