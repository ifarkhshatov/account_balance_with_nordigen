
#Copy HTTP request from POSTMAN
library(httr)

headers = c(
  'accept' = 'application/json',
  'Authorization' = 'Bearer <SECRET TOKEN>'
)

res <- VERB("GET", url = "https://ob.nordigen.com/api/v2/accounts/<ACCOUNT_ID>/transactions/", add_headers(headers), encode = 'multipart')

cat(content(res, 'text'))

#take only transactions from content
parsed_content <- content(res, "parsed")$transactions
#take only booked data and convert it into data.frame
booked_data <- type.convert(
  bind_rows(
    lapply(parsed_content$booked, as.data.frame)
    ), as.is = TRUE)

booked_data$bookingDate <- as.Date(booked_data$bookingDate)


# SUMMARY OF THE DATA
table(booked_data$additionalInformation)

# Pulling google sheet
library(googledrive)
library(googlesheets4)
# Get authentication from google auth
drive_auth()

# find ID of the sheet
gs4_find()
# Pull data from Nordigen API to Google Sheet
write_sheet(ss = "<SHEET ID>", booked_data, sheet = 3)
# If data already is present, append data
sheet_append("<SHEET ID>", booked_data, sheet = 2)
