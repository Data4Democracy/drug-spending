# Cleaning January 2016 CMS drug name, manufacturer, and dosage data
# S. Kirmer
# Data4Democracy - Drug Spending Project
# January 2017

list1 <- read.csv("U://Medicaid_Drug/2016-January-ASP-NDC-HCPCS-Crosswalk/Section 508 version of Jan 2016 AWP NDC-HCPCS Crosswalk 120815.csv", skip = 7, stringsAsFactors=FALSE)
list2 <- read.csv("U://Medicaid_Drug/2016-January-ASP-NDC-HCPCS-Crosswalk/section 508 version of January 2016 ASP NDC-HCPCS Crosswalk 010716.csv", skip = 6, stringsAsFactors=FALSE)
list3 <- read.csv("U://Medicaid_Drug/2016-January-ASP-NDC-HCPCS-Crosswalk/section 508 version of January 2016 NOC NDC-HCPCS Crosswalk 120915.csv", skip = 6, stringsAsFactors=FALSE)
list4 <- read.csv("U://Medicaid_Drug/2016-January-ASP-NDC-HCPCS-Crosswalk/section 508 version of January 2016 OPPS NDC-HCPCS Crosswalk 120915.csv", skip = 6, stringsAsFactors=FALSE)

list5 <- read.csv("U://Medicaid_Drug/2016-January-ASP-NDC-HCPCS-Crosswalk/section 508 version of NDC-HCPCS Crosswalk Introduction Text 120915.csv")

colnames(list1) <- toupper(names(list1))
colnames(list2) <- toupper(names(list2))
colnames(list3) <- toupper(names(list3))
colnames(list4) <- toupper(names(list4))

colnames(list2)[1] <- "HCPCS CODE"
colnames(list4)[1] <- "HCPCS CODE"
colnames(list1)[2] <- "SHORT DESCRIPTION"
colnames(list3)[5] <- "HCPCS DOSAGE"
colnames(list2)[4] <- "NDC"
colnames(list3)[3] <- "NDC"
colnames(list4)[4] <- "NDC"

mergedlist <- merge(list1, list2, by=c("HCPCS CODE", "SHORT DESCRIPTION", "LABELER NAME","DRUG NAME", "NDC","HCPCS DOSAGE", "PKG SIZE","PKG QTY",
                                      "BILLUNITS","BILLUNITSPKG"), all=T)

mergedlist <- merge(mergedlist, list3, by.x=c("SHORT DESCRIPTION", "LABELER NAME","DRUG NAME","NDC", "HCPCS DOSAGE", "PKG SIZE","PKG QTY",
                                       "BILLUNITS","BILLUNITSPKG"), 
                    by.y=c("DRUG GENERIC NAME", "LABELER NAME","DRUG NAME", "NDC","HCPCS DOSAGE", "PKG SIZE","PKG QTY",
                                                                           "BILLUNITS","BILLUNITSPKG"), all=T)
mergedlist <- merge(mergedlist, list4, by.x=c("HCPCS CODE","SHORT DESCRIPTION", "LABELER NAME","DRUG NAME","NDC", "HCPCS DOSAGE", "PKG SIZE","PKG QTY",
                                              "BILLUNITS","BILLUNITSPKG"), 
                    by.y=c("HCPCS CODE","SHORT DESCRIPTOR", "LABELER NAME","DRUG NAME", "NDC","HCPCS DOSAGE", "PKG SIZE","PKG QTY",
                           "BILLUNITS","BILLUNITSPKG"), all=T)


mergedlist$`HCPCS DOSAGE` <- gsub('MG', ' MG', mergedlist$`HCPCS DOSAGE`)
mergedlist$`HCPCS DOSAGE` <- gsub('mg', ' MG', mergedlist$`HCPCS DOSAGE`)

mergedlist <- tidyr::separate(mergedlist, `HCPCS DOSAGE` ,c("DOSAGENUM", "DOSAGEUNITS"), " ", extra="merge", remove=FALSE)
mergedlist$DOSAGENUM <- as.numeric(mergedlist$DOSAGENUM)

mergedlist <- mergedlist[,c(1,5,3, 4, 2, 6:12)]
mergedlist$ASOFDATE <- "01/01/2016"

write.csv(mergedlist, "U://Medicaid_Drug/2016drugdata.csv")
