---
layout:default
---

{% highlight perl6 %}

#!/usr/bin/perl
# usage:
#        perl get_tweets.pl <screen_name> [number_tweets]
# ex.
#        perl get_tweets.pl realDonaldTrump
#        perl get_tweets.pl realDonaldTrump  10
#
#  This will produce a TXT file <screen_name>_tweets.txt containing
#        "id"      "datetime"    "screen_name" "text"
# Copyright (c) 2017 STATS 285 (stats285.stanford@gmail.com)
# visit http://stats285.github.io
#
###################################################################################
#  NOTES:
#  This CSV file can be read in R for analysis:
#       > data = read.table("realDonaldTrump_tweets.txt", header=TRUE,
#                            sep="\t", encoding="UTF-8", colClasses=c('character'))
#
#  To convert twitter datetime column to that of R:
#       > data$datetime <- strptime(data$datetime, "%a %b %d %H:%M:%S %z %Y")
###################################################################################
use strict;
use warnings;
use utf8;               # For wide characters: for STDOUT use 'perl -CS *.pl'
use Net::Twitter;
use Data::Dumper;



# Read command line arguments
my $screen_name=$ARGV[0] // exit 0;        # default to exit 0;
my $number_of_tweets= $ARGV[1] // 3200;    # default to 3200


# Define credentials from https://apps.twitter.com
my $twitter = Net::Twitter->new(
traits   => [qw/API::RESTv1_1/],
consumer_key        => '****************',
consumer_secret     => '****************',
access_token        => '****************',
access_token_secret => '****************'
);



# use method user_timeline and
# loop until you get all 3200 tweets allowed
my @all_tweets;
my $count       = $number_of_tweets < 200 ?  $number_of_tweets : 200;
my $tweets      = $twitter->user_timeline({'screen_name'=>$screen_name , 'count' => $count});  #arrayRef
while( ($#{$tweets} ge 0) and  (1+$#all_tweets)<$number_of_tweets ){
push @all_tweets, @$tweets;
printf "%-5s tweets downloaded...\n", 1+$#all_tweets;
my $oldest = @$tweets[$#{$tweets}]->{'id'}-1;
$tweets      = $twitter->user_timeline({'screen_name'=>$screen_name , 'count' => $count , 'max_id'=>$oldest});
}



# print to a tab-separated TXT file with UTF-8 encoding for non-ascii characters
my $filepath = "${screen_name}_tweets.txt";
open(my $fh, '>:encoding(UTF-8)' , "$filepath") or die "can't create file $filepath $!";
# write header
my $header = join "\t" , ("id","datetime","screen_name","text");
print $fh "$header\n";

foreach (@all_tweets){

my $created_at      = '"' . $_->{'created_at'} . '"';     #add quotes when written to CSV
my $id              = '"' . $_->{'id'} . '"';
my $user_screenname = '"' . $_->{'user'}{'screen_name'} . '"';
my $text            = '"' . $_->{'text'} . '"';
$text =~ s/[\n\r\t]/ /g;                  #replace new lines/tabs in text with space.

my $record = join "\t" , ($id,$created_at,$user_screenname,$text);

print $fh "$record\n";    # print to $fh
}

close $fh;


1;

{% endhighlight %}

[Download file](perl-tutorial-files/get_tweets.pl)



