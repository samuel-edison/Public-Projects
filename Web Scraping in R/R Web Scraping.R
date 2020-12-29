#load required libraries
library(stringr)
library(rvest)
library(tidyverse)
#save url that will be scraped
okstate_url = 'https://business.okstate.edu/msis/directory.html'

#load the webpage into memory so R can read its HTML, CSS, and anything that is loaded from that url:
okstate_html = read_html(okstate_url) #This contains all the code from the webpage. This is the same as viewing the source in your browser.


#find the name in the html using CSS
css_name = "div[id^='accordion-d36e101']>span>a,div[id^='accordion-d36e181']>span>a,div[id^='accordion-d36e320']>span>a,div[id^='accordion-d36e400']>span>a"
find_name_css = html_nodes(okstate_html, css_name) #CSS example
find_name_css
#find the name in the html using XPATH
xpath_name = "//div/div/span/a[@data-parent='#accordion-d36e101']|
//div/div/span/a[@data-parent='#accordion-d36e181']|
//div/div/span/a[@data-parent='#accordion-d36e320']|
//div/div/span/a[@data-parent='#accordion-d36e400']" #use | for or condition
find_name_xpath = html_nodes(okstate_html, xpath=xpath_name)
html_text(find_name_xpath)

#use html_text function to get actual name
name = html_text(find_name_css)
name 
#use regex to extract first name
first_name_regex = "([A-z]+)" #create a regex to pull just first name
first_name_extract = str_subset(name,first_name_regex)
first_name_extract
first_name_match = str_extract(first_name_extract,first_name_regex)
firstname = first_name_match
firstname
#use regex to extract last name
last_name_regex = "( [A-Za-z]+|Bagheri)" #create a regex to pull just last name
last_name_extract = str_subset(name,last_name_regex)
last_name_extract
last_name_match = str_extract(last_name_extract,last_name_regex)

last_name_match = str_trim(last_name_match, side = c("both", "left", "right"))
last_name_match
lastname = last_name_match
last_name_match

#find the title in the html using CSS
css_title = "div[id^='accordion-d36e101']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e181']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e320']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e400']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-9']>p:nth-child(1),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-6']>p:nth-child(1)"
find_title = html_nodes(okstate_html, css_title) #CSS example
#use html_text function to get actual title
title = html_text(find_title)
title = str_trim(title, side = c("both", "left", "right"))
title

#find the title in the html using XPATH
xpath_title = "//div/div[@id='accordion-d36e101']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|
//div/div[@id='accordion-d36e181']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|//div/div[@id='accordion-d36e320']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-9']/p[1]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-6']/p[1]"
find_title_xpath = html_nodes(okstate_html, xpath=xpath_title) #XPATH example
#use html_text function to get actual title
title_2 = html_text(find_title_xpath)
title_2 = str_trim(title_2, side = c("both", "left", "right"))
title_2

#create a regex to grab just title
###REGEX SAMPLES, KEEP FOR REFERENCE
#title_regex = "(Oklahoma.*+Professor|Professor|[A-Za-z ]+Professor|Visiting+[A-Za-z ]|Instructor|Vice Dean|[A-Za-z ]+Regents|Clinical|Associate|Assistant|Lecturer|Dean)"
#primary use#title_regex = "(Professor|Professor|[A-Za-z ]+Professor|Visiting+[A-Za-z ]|Instructor|Vice Dean|[A-Za-z ]+Regents|Clinical|Associate|Assistant|Lecturer|Dean|Professor)"
#title_regex = "(.*-?Oklahoma.*|Visiting|Regents|Clinical|Associate|.*?Assistant|Lecturer|Vice|Practice)? ?(Professor|Dean|Assistant)?"
#title_regex = "(\\-|Visiting|Regents|Clinical|Associate|.*?Assistant|Lecturer|Vice|Practice)? ?(Professor|Dean|Assistant)?"
title_drill = "^.*(?=(\\and))|(.*Professor)|(Instructor)|(Lecturer)" 
title_drill_set = str_subset(title,title_drill)
title_drill_match = str_extract(title_drill_set, title_drill)
title_drill_match
#
title_drill2 = "[A-Z].*"
title_precise = str_subset(title_drill_match,title_drill2)
title_match = str_extract(title_precise, title_drill2)
title_match = str_trim(title_match, side = c("both", "left", "right"))
title = title_match
title


#find address in the html using CSS
css_address = "div[id^='accordion-d36e101']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e181']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e320']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e400']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-9']>p:nth-child(3),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-6']>p:nth-child(3)"

#find the address in the html using XPATH
xpath_address = "//div/div[@id='accordion-d36e101']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|
//div/div[@id='accordion-d36e181']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|//div/div[@id='accordion-d36e320']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-9']/p[3]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-6']/p[3]"
find_address_xpath = html_nodes(okstate_html, xpath=xpath_address) #XPATH example
#use html_text function to get actual title
address_2 = html_text(find_address_xpath)
address_2 = str_trim(address_2, side = c("both", "left", "right"))
address_2

find_address = html_nodes(okstate_html, css_address) #CSS example
#use html_text function to get actual address
address = html_text(find_address)
address = str_trim(address, side = c("both", "left", "right"))
address
address_regex = "^.*(?=(\\Stillwater))|^.*(?=(\\Tulsa))"
address_extract = str_subset(address,address_regex)

address_match = str_extract(address_extract,address_regex)

address = address_match
address

########################
css_phone = "div[id^='accordion-d36e101']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e181']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e320']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e400']>div>div>div.col-xs-9>p:nth-child(3),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-9']>p:nth-child(3),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-6']>p:nth-child(3)"
find_phone = html_nodes(okstate_html, css_phone) #CSS example

#find the phone number in the html using XPATH
xpath_phone = "//div/div[@id='accordion-d36e101']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|
//div/div[@id='accordion-d36e181']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|//div/div[@id='accordion-d36e320']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-9']/p[3]|//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-9']/p[3]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-6']/p[3]"
find_phone_xpath = html_nodes(okstate_html, xpath=xpath_phone) #XPATH example
#use html_text function to get actual title
phone_2 = html_text(find_phone_xpath)
phone_2 = str_trim(phone_2, side = c("both", "left", "right"))
phone_2



#use html_text function to get actual phone number
phone = html_text(find_phone)
phone = str_trim(phone, side = c("both", "left", "right"))
phone
phone_regex = "[0-9.() -]{5,}( |$)"
phone_extract = str_extract(phone,phone_regex)

phone = phone_extract
phone

#find email in the html using CSS
css_email = "div[id^='accordion-d36e101']>div>div>div.col-xs-9>p:nth-child(2),
div[id^='accordion-d36e181']>div>div>div.col-xs-9>p:nth-child(2),
div[id^='accordion-d36e320']>div>div>div.col-xs-9>p:nth-child(2),
div[id^='accordion-d36e400']>div>div>div.col-xs-9>p:nth-child(2),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-9']>p:nth-child(2),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-6']>p:nth-child(2)"
find_email = html_nodes(okstate_html, css_email) #CSS example
#use html_text function to get actual address
email = html_text(find_email)
email = str_trim(email, side = c("both", "left", "right"))
email


#find email in the html using XPATH
xpath_email = "//div/div[@id='accordion-d36e101']/div/div[2]/div/div/div[@class='col-xs-9']/p[2]|
//div/div[@id='accordion-d36e181']/div/div[2]/div/div/div[@class='col-xs-9']/p[2]|
//div/div[@id='accordion-d36e320']/div/div[2]/div/div/div[@class='col-xs-9']/p[2]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-9']/p[2]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-9']/p[2]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-6']/p[2]"
find_email_xpath = html_nodes(okstate_html, xpath=xpath_email) #XPATH example
#use html_text function to get actual address
email2 = html_text(find_email_xpath)
email2 = str_trim(email2, side = c("both", "left", "right"))
email2


#find the additional positions in the html using CSS
css_position = "div[id^='accordion-d36e101']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e181']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e320']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e400']>div>div>div.col-xs-9>p:nth-child(1),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-9']>p:nth-child(1),
div[id^='accordion-d36e400']>div>div>div[class='col-xs-12 col-sm-6']>p:nth-child(1)"
find_position = html_nodes(okstate_html, css_position) #CSS example
#use html_text function to get actual title
position = html_text(find_position)
position = str_trim(position, side = c("both", "left", "right"))
position

#find the title in the html using XPATH
xpath_position = "//div/div[@id='accordion-d36e101']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|
//div/div[@id='accordion-d36e181']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|//div/div[@id='accordion-d36e320']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-9']/p[1]|//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-9']/p[1]|
//div/div[@id='accordion-d36e400']/div/div[2]/div/div/div[@class='col-xs-12 col-sm-6']/p[1]"
find_position_xpath = html_nodes(okstate_html, xpath=xpath_position) #XPATH example
#use html_text function to get actual title
position_2 = html_text(find_position_xpath)
position_2 = str_trim(title_2, side = c("both", "left", "right"))
position_2



#create a regex to grab just position
#position_regex = "(Head|MIS|Director|MSIA|William|Ardmore|Vice)(,?| S\\.?) ([A-z]+ [A-z]+)? ([A-z]+)? ([A-z]+)?"

position_extract = str_extract(position,position_regex)

position_match = str_extract(position_extract,position_regex)
position_match = str_replace(position_match, "Management|Management Science and Information|Science", "")
position_match = str_trim(position_match, side = c("both", "left", "right"))
position_match


position_drill = "(Vice.*)|(Head.*)|(William.*)|(MSIA.*)|(Assistant.Head.*)|(Director.*)"
position_drill_set = str_extract(position,position_drill)
position_drill_match = str_extract(position_drill_set, position_drill)
#
position_drill2 = "[A-Z].*"
position_precise = str_extract(position_drill_match,position_drill2)
position_match = str_extract(position_precise, position_drill2)
position_match = str_trim(position_match, side = c("both", "left", "right"))
position_match = str_replace(position_match, "Management|Management Science and Information|Science", "")
additional_position = position_match
additional_position


#combine all columns into one data frame
df = data.frame(firstname, lastname, title, address, phone, email, additional_position, stringsAsFactors = FALSE)
df
getwd()
#Export data frame as a txt file and load to github
write.table(df, file = "datafile.txt", sep="\t", row.names = TRUE, col.names = NA)
