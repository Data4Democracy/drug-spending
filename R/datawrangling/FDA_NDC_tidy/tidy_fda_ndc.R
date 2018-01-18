#IMPORT LIBRARIES
library(reshape)

#READ-IN CSV AND SET HANDY VARIABLES
dat <- read.csv('FDA_NDC_Product.csv')
names(dat) <- tolower(names(dat))

#uncomment to speed up code runtime by like 100x
#dat <- dat[1:1000,]

untidy.names <- c('nonproprietaryname', 'substancename', 'active_numerator_strength', 'active_ingred_unit')
tidy.names <- names( subset( dat[1,], select = -c(nonproprietaryname, substancename, active_numerator_strength, active_ingred_unit) ) )

#Count num of drugs w/ multiple active ingreds
act.ingreds <- strsplit( unlist(sapply( dat$active_ingred_unit, as.character )), c(', |; |,|;| and ') )
num.act.ingreds <- unlist( lapply( act.ingreds, length ) )
#length(num.act.ingreds[ num.act.ingreds > 1])

#PRELIMS FOR TIDYING

#Initialize a data frame that we will add rows to.  If we make the first row of the DF an integer vector it seems to handle rbinding character rows  better
#>>Not sure why that is and couldn't find something simpler, the rest of the script is similarly hacky
tidy.dat <- as.data.frame( matrix( 1:(dim(dat)[2]) , ncol=dim(dat)[2] ) )
names(tidy.dat) <- c( tidy.names, untidy.names )

#These are going to hold which rows in the tidy.dat flagged an error as they were processed
np.mis <- c()
ai.mis <- c()

#Passing some data values to tolower() tossed weird, corner-case errors => wrapped tolower() in a generic error catcher which simply passes back original char vector
#>>if anything goes wrong
safe.lower <- function(x){
    result <- tryCatch({
        sapply( x, tolower)
    },
    error = function(e){
        return( as.character(x) )
    })
    return( result )
}


#Load up Civ V or something b/c you are going to be waiting for a little while...
print('starting split...')
for (i in 1:dim(dat)[1] ){
    #Pull the row to-be-split
    row <- dat[i,]

    #Subsection the elements that we need to Tidy from the ones we don't
    tidy.elems <- row[,tidy.names]
    untidy.elems <- row[,untidy.names] #NB: these are the elements we will be Tidying

    #This basically greps through the a character vector searching for matches to the char vec c(', |; |,|;| and ')
    #>>NB: the | symbol reads as "OR" for grep, so we are matching on ', ' OR ';  OR' ',' OR ';' OR ',' which were the only joining symbols I could find 
    split.elems <- strsplit( sapply( untidy.elems, as.character ), c(', |; |,|;| and ') )
    
    #>>split.elems is a list-of-lists, each list elem is itself a list of the split strings

    N <- length( split.elems[[1]] ) #>> N gives us the number of proprietarynames that we need to convert to new rows

    #Let's hold on to which rows mismatch in their number of proprietarynames vs. substancenames
    if( length(split.elems[[1]]) != length(split.elems[[2]]) ){
        print('nonproprietaryname mismatch!')
        np.mis <- append(np.mis, dim(tidy.dat)[1] )
    }

    #Also check to make sure that the number of active_ingreds and number of active_numers match up
    #>>Spoiler alert: they all do!
    if( length(split.elems[[3]]) != length(split.elems[[4]]) ){
        print('active_ingred mismatch!')
        ai.mis <- append( ai.mis, dim(tidy.dat)[1] )
    }    

    #Okay now we start assembling and appending the new rows from the split.elems
    for (j in 1:N){
        new.row <- unlist( c( unlist( sapply( tidy.elems, safe.lower ) ), split.elems[[1]][j], split.elems[[2]][j], split.elems[[3]][j], split.elems[[4]][j] ) )

        #If all of the untidy elements were NA then new.row will only have 14 elements, so needs to be rebuilt
        if (length(new.row) == 14){
            new.row <- c( new.row, NA, NA, NA, NA )
        }

        #Append the new.row to tidy.dat
        names(new.row) <- c( tidy.names, untidy.names )
        tidy.dat <- rbind( tidy.dat, sapply( new.row, safe.lower) )
    }
}
#Some nonproprietarynames still start with an "and " for some reason, so let's clean them up
to.fix <- sapply( dat$nonproprietaryname, function(x) { (substring(x,1,4)=='and ')*!is.na(x) } )
to.fix <- unlist( sapply( to.fix, function(x) { if( is.na(x) ){ return(FALSE) } } ) )
fixed <- sapply( dat[to.fix,]$nonproprietaryname, function(x) { substring(x,5) } )
dat[ to.fix,]$nonproprietaryname <- fixed

#Save tidy data just in case of a crash or something
write.csv(tidy.dat, 'fda_ndc_product.csv', row.names = FALSE)

#Scrape off that first integer line
tidy.dat <- tidy.dat[2:dim(tidy.dat)[1], ]

#Convert data column to ISO format
to.iso <- function(x) {
    date <- as.character(x)

    if ( is.na( date ) ){
        return(date)
    }

    else {
        iso.date <- paste( substring(date,1,4), substring(date,5,6), substring(date,7), sep = '-')
        return(iso.date)
    }
}

tidy.dat$startmarketingdate <- sapply( tidy.dat$startmarketingdate, to.iso )
tidy.dat$endmarketingdate <- sapply( tidy.dat$endmarketingdate, to.iso )

#See which rows threw errors in the splitting process
tidy.dat[ np.mis[sample(1:length(np.mis),10)], untidy.names]
length(ai.mis) #length is 0

#Check if any strings weren't split
np.missed <- grep( ' and ', tidy.dat[,untidy.names[1]] )
sn.missed <- grep( ' and ', tidy.dat[,untidy.names[2]] )

act_num.missed <- grep( ' and |, |; | , | ; ', tidy.dat[,untidy.names[3]] )
act_ingred.missed <- grep( ' and |, |; | , | ; ', tidy.dat[,untidy.names[4]] )
#No hanging ', ', ' and ' or '; ' joins in active_numerator_strength" or "active_ingred_unit" => hopefully everything has an unambiguous dosage
#Only unusual joins (ie. ', ' or '; ')  in "nonpropname" or "substancename" are things like "sennosides a and b", and have unamibugous dosage so I'm assuming
#it's meant to imply that both substances are present in some canonical ratio

np.sn.missed <- tidy.dat$nonproprietaryname == tidy.dat$substancename
name.mismatch <- tidy.dat[!np.sn.misses, untidy.names]

#Let's see what some random rows of the name mismatches look like...
name.mismatch[sample( 1:dim(name.mismatch)[1], 100 ), untidy.names[1:2]]
#again just a lot of sloppy entry mistmatch stuff, so we're probably good

#Save tidy data just in case of a crash or something
write.csv(tidy.dat, 'fda_ndc_product.csv', row.names = FALSE)

###################################################################
#TRASH
###################################################################
#split.column <- function( col.name, dat ) {
#	     hold <- dat
#	     dat.col <- hold[,col.name]
#
#	     split.col <- strsplit( tolower( as.character( dat.col ) ), c( ', |; | and |,|;'  ) )
#
#	     var.nums <- sapply( split.col, length )
#	     max.iter <- max( var.nums )
#
#             if ( max.iter == 1) {
#                 return(hold)
#                 }
#                             
#	     for( i in 1:max.iter ){
#	     	    new.name <- paste( col.name, as.character( i ), sep='' ) 
#	     	    hold[ ,new.name] <- sapply( split.col, '[', i)
#             }
#
#             return( hold[ , names(hold) != col.name ] )
#}
#
#
#split.dat <- small.dat
#for (s in untidy.names){
#    print(s)
#    split.dat <- split.column(s, split.dat)
#}
#
#to.copy <- split.dat[ !is.na(split.dat$nonproprietaryname2), ]
#
#to.copy$nonproprietaryname1 <- to.copy$nonproprietaryname2
#to.copy$substancename1 <- to.copy$substancename2
#to.copy$active_numerator_strength1 <- to.copy$active_numerator_strength2
#to.copy$active_ingred_unit1 <- to.copy$active_ingred_unit2
#
#split.dat <- rbind(split.dat, to.copy)
#split.dat <- split.dat[ , c(1:15,17,19,21)]
