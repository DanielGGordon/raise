#!/bin/bash

# Use pure bash (using curl) to get the percent
# $1 = String that represents store. Example: "ebay"
# For stores with more than one word: "best-buy"
# $2 = How often to check
# $3 = (optional) bandwidth max when pulling from raise. Default is 50kb/s
#   Enter this like "50000B" or "100000B". Don't know if "kb" works
# $4 = Future variable: at what % to send email alert
# Other future work: Allow passing of multiple stores. Take as parameter, or as file

# ########################## Example Usage ##################################### 
#                                                                              #
# sh raise.sh ebay 10                                                          #
# sh raise.sh ebay 10 250000B #increased bandwidth to 250kb from 50kb          #
# sh raise.sh kohl-s 10 #Note the                                              #
# sh raise.sh j-c-penny 10                                                     #
# sh raise.sh t-j-maxx 10                                                      # 
# sh raise.sh best-buy 10                                                      #
#                                                                              #
# The last one wil appened output to a file called 'ebayhistory.txt', while    #
#     also printing to the console at the same time                            #
#                                                                              #
# ##############################################################################

### Assign variables ###
store=$1
### Done assigning variables ###
if [ -z "$3" ]
    then
       rate="25000B"
    else
       rate=$3
fi
### Done assigning variables ###

grep1="[0-9]\?[0-9]\.[0-9]%..td"
grep2="[0-9]?[0-9]\.[0-9]"
while true
do
    store=$1
    ebay_gc=$(curl -s --limit-rate $3 https://www.raise.com/buy-$store-gift-cards | grep $grep1 | head -n 1 | grep -oP $grep2)
    # The 2nd grep is Perl style, so the '?' does not need to be escaped
    # Also, double quotes are necessary for grep when adding the '?' for optional character
    # However, double quotes are not needed for the Perl Regex
    # ebay_gc=$(curl -s --limit-rate $rate https://www.raise.com/buy-$store-gift-cards?page=1 | grep [0-9]\.[0-9]%..td | head -n 1 | grep -oP [0-9]\.[0-9])
    # -s flag for 'silent' output. --limit-rate to lower the rate of transfer, as to put less load on raise.com
    # ebay_gc is a number only, like "3.2" or "5.0". Technically bash will consider it a string
    
    now=$(echo $(date +"%m-%d @ %T")) # Get timestamp
    # echo "$ebay_gc% $now" | tee -a $1.txt
    echo "$ebay_gc% $now (7 hours ahead)" >> $1.txt
    sleep $interval
done

