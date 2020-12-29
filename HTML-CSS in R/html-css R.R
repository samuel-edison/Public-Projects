#Store columns as vectors

Manufacturer = c("BMW", "Daimler", "Fiat Chrysler*", "Ford", "GM", "Honda", "Hyundai", "Jaguar Land Rover", "Kia", "Lotus", "Mazda", "Mitsubishi", "Nissan", "Subaru", "Tesla", "Toyota", "Volvo", "VW*")
STD = c("", "", "32.9", "34.0", "33.9", "33.8", "", "", "", "", "", "", "34.7", "", "32.1", "34.4", "", "33.6")
CAFE = c("", "", "31.1", "36.6", "34.4", "39.2", "", "", "", "", "", "", "41.9", "", "276.7", "39.1", "", "37.7")
CAFE_STD = c("", "", "-1.8", "2.6", "0.5", "5.4", "", "", "", "", "", "", "7.2", "", "244.6", "4.7", "", "4.1")


#review vectors
str(Manufacturer)
str(STD)
str(CAFE)
str(CAFE_STD)
#convert STD, CAFE, CAFE_STD to numeric vectors
STD = as.numeric(STD)
CAFE = as.numeric(CAFE)
CAFE_STD = as.numeric(CAFE_STD)
#confirm numeric change
STD
CAFE
CAFE_STD

#Create a data frame using the four vectors. Be sure to use the argument stringsAsFactors = FALSE
df = data.frame(Manufacturer, STD, CAFE, CAFE_STD, stringsAsFactors = FALSE)
df

#check and set working directory
getwd()

#Export the Data Frame as a txt file
write.table(df, file = "datafile.txt", sep = "\t",row.names = TRUE, col.names = NA)

