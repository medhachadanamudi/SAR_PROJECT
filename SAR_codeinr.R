# Install the readr package
install.packages("readr")



# Load necessary libraries
library(readr)  # For reading CSV files
library(dplyr)  # For data manipulation

# Load the dataset
file_path <- "C:/Users/chada/OneDrive/Desktop/pragna assignments/SAR Rental.csv"

sar_data <- read_csv(file_path)

# Display the structure of the dataset to understand its attributes
str(sar_data)  # To check the data types and structure of the dataset



# Check for missing values in the dataset
missing_values <- colSums(is.na(sar_data))  # Count missing values in each column
print(missing_values)

# Drop the 'to_city_id' column
sar_data <- sar_data %>% select(-to_city_id)

# Verify column removal
print("Columns after dropping 'to_city_id':")
print(names(sar_data))





#Add a new column indicating whether 'package_id' is missing
sar_data <- sar_data %>%
  mutate(package_missing = is.na(package_id))

# Check the relationship between 'package_missing' and 'travel_type_id'
missing_patterns <- sar_data %>%
  group_by(travel_type_id, package_missing) %>%
  summarise(count = n()) %>%
  mutate(percentage = round((count / sum(count)) * 100, 2))

# View the patterns
print("Patterns of missing 'package_id' by 'travel_type_id':")
print(missing_patterns)

#after inspecting dropping new column package_missing
# Drop the 'package_missing' column from the dataset
sar_data <- sar_data %>% select(-package_missing)

# Verify if the column has been removed
print("Columns after dropping 'package_missing':")
print(names(sar_data))





# Replace missing 'package_id' with "Not Applicable" for travel_type_id 1 and 2
sar_data <- sar_data %>%
  mutate(package_id = case_when(
    travel_type_id %in% c(1, 2) ~ "Not Applicable",
    TRUE ~ as.character(package_id)  # Retain original values for travel_type_id = 3
  ))

# Check the updated column
print("Updated 'package_id' column:")
table(sar_data$package_id)


#investigating from_city_id Missing Values

# Check distribution of missing 'from_city_id' by 'travel_type_id'
missing_from_city <- sar_data %>%
  mutate(from_city_missing = is.na(from_city_id)) %>%
  group_by(travel_type_id, from_city_missing) %>%
  summarise(count = n()) %>%
  mutate(percentage = round((count / sum(count)) * 100, 2))

print("Distribution of missing 'from_city_id' by 'travel_type_id':")
print(missing_from_city)

# Check the relationship between 'from_city_id' and 'Car Cancellation'
from_city_correlation <- sar_data %>%
  group_by(from_city_id) %>%
  summarise(
    cancellation_rate = mean(Car_Cancellation, na.rm = TRUE),
    count = n()
  ) %>%
  arrange(desc(cancellation_rate))

# View correlation
print("Correlation between 'from_city_id' and 'Car Cancellation':")
print(from_city_correlation)


# Handle missing 'from_city_id' based on travel_type_id
sar_data <- sar_data %>%
  mutate(from_city_id = case_when(
    travel_type_id == 1 & is.na(from_city_id) ~ "15",  # Impute with most frequent value
    travel_type_id == 2 & is.na(from_city_id) ~ "Unknown",  # Impute "Unknown"
    travel_type_id == 3 & is.na(from_city_id) ~ "Not Applicable",  # Impute "Not Applicable"
    TRUE ~ as.character(from_city_id)  # Retain existing values
  ))

# Verify the imputation
table(sar_data$from_city_id, useNA = "ifany")


# Check the relationship between 'to_date' missingness and 'Car Cancellation'
missing_to_date <- sar_data %>%
  mutate(to_date_missing = is.na(to_date)) %>%
  group_by(to_date_missing) %>%
  summarise(
    count = n(),
    cancellation_rate = mean(Car_Cancellation, na.rm = TRUE)
  )

print("Distribution of missing 'to_date':")
print(missing_to_date)


# Drop the 'to_date' column
sar_data <- sar_data %>% select(-to_date)

# Verify column removal
print("Columns after dropping 'to_date':")
print(names(sar_data))

# Check missing patterns by travel_type_id
missing_to_columns <- sar_data %>%
  mutate(to_columns_missing = is.na(to_area_id) & is.na(to_lat) & is.na(to_long)) %>%
  group_by(travel_type_id, to_columns_missing) %>%
  summarise(count = n()) %>%
  mutate(percentage = round((count / sum(count)) * 100, 2))

print("Missing patterns in 'to_area_id', 'to_lat', 'to_long' by travel_type_id:")
print(missing_to_columns)


# Handle missing 'to_area_id', 'to_lat', and 'to_long' by travel_type_id
sar_data <- sar_data %>%
  mutate(
    to_area_id = case_when(
      travel_type_id == 1 ~ "Not Applicable",  # Long Distance
      travel_type_id == 3 ~ "Not Applicable",  # Hourly Rental
      TRUE ~ as.character(to_area_id)          # Retain existing values for Point-to-Point
    ),
    to_lat = case_when(
      travel_type_id %in% c(1, 3) ~ median(to_lat, na.rm = TRUE),  # Placeholder for missing latitudes
      TRUE ~ to_lat
    ),
    to_long = case_when(
      travel_type_id %in% c(1, 3) ~ median(to_long, na.rm = TRUE), # Placeholder for missing longitudes
      TRUE ~ to_long
    )
  )


# Check for remaining missing values
missing_values <- colSums(is.na(sar_data))
print("Remaining missing values after handling 'to_area_id', 'to_lat', and 'to_long':")
print(missing_values)


# Check distribution of missing 'from_lat' and 'from_long' by 'travel_type_id'
missing_from_lat_long <- sar_data %>%
  mutate(from_lat_long_missing = is.na(from_lat) & is.na(from_long)) %>%
  group_by(travel_type_id, from_lat_long_missing) %>%
  summarise(count = n()) %>%
  mutate(percentage = round((count / sum(count)) * 100, 2))

print("Missing patterns in 'from_lat' and 'from_long' by 'travel_type_id':")
print(missing_from_lat_long)

# Impute missing 'from_lat' and 'from_long' for Long Distance trips (Travel Type 1)
sar_data <- sar_data %>%
  group_by(from_area_id) %>%
  mutate(
    from_lat = if_else(
      travel_type_id == 1 & is.na(from_lat),
      median(from_lat[travel_type_id == 1], na.rm = TRUE),
      from_lat
    ),
    from_long = if_else(
      travel_type_id == 1 & is.na(from_long),
      median(from_long[travel_type_id == 1], na.rm = TRUE),
      from_long
    )
  ) %>%
  ungroup()
# Impute missing values in 'from_area_id' with "Unknown"
sar_data$from_area_id <- ifelse(is.na(sar_data$from_area_id), "Unknown", sar_data$from_area_id)



# Impute any remaining missing values using the overall median for Long Distance trips
sar_data <- sar_data %>%
  mutate(
    from_lat = if_else(is.na(from_lat), median(from_lat[travel_type_id == 1], na.rm = TRUE), from_lat),
    from_long = if_else(is.na(from_long), median(from_long[travel_type_id == 1], na.rm = TRUE), from_long)
  )



# Check remaining missing values
missing_values <- colSums(is.na(sar_data))
print("Remaining missing values after handling 'from_lat' and 'from_long':")
print(missing_values)







# Check for zero values in the dataset (if zeros are considered missing for some columns)
zero_values <- colSums(sar_data == 0, na.rm = TRUE)  # Count zero values in each column
print("Zero values in each column:")
print(zero_values)


# Identify columns where zero is invalid
columns_to_check <- c("row#", "user_id", "vehicle_model_id", "package_id",
                      "travel_type_id", "to_area_id", "from_city_id", 
                      "from_date", "booking_created", "from_lat", 
                      "from_long", "to_lat", "to_long")

# Check for zeros in the identified columns
zeros_check <- sar_data %>%
  summarise(across(all_of(columns_to_check), ~ sum(. == 0, na.rm = TRUE)))

# Print the result
print("Count of zeros in columns where zero is invalid:")
print(zeros_check)


# Drop the columns 'row#' and 'user_id'
sar_data <- sar_data[, !(colnames(sar_data) %in% c("row#", "user_id"))]

# Print the remaining column names
cat("Column Names:\n", paste(colnames(sar_data), collapse = ", "), "\n")


# View the remaining columns
# Load necessary library
library(readr)


# Print column names and unique values for each column
for (col_name in colnames(sar_data)) {
  cat("\nColumn:", col_name, "\n")
  cat("Unique Values:", paste(unique(sar_data[[col_name]]), collapse = ", "), "\n")
}





##################################################################
# Create a data frame with column names, data types, and first-row values
column_info <- data.frame(
  Column_Name = names(sar_data),
  Data_Type = sapply(sar_data, class),
  First_Value = sapply(sar_data, function(x) x[1])  # Extract first row values
)

# Print the result
print("Column Names, Data Types, and First Row Values:")
print(column_info)


#Convert categorical columns to factors
sar_data$vehicle_model_id <- as.factor(sar_data$vehicle_model_id)
sar_data$travel_type_id <- as.factor(sar_data$travel_type_id)
sar_data$from_area_id <- as.factor(sar_data$from_area_id)
sar_data$to_area_id <- as.factor(sar_data$to_area_id)
sar_data$from_city_id <- as.factor(sar_data$from_city_id)

# Convert package_id to an ordered factor without "Not Applicable"
sar_data$package_id <- factor(sar_data$package_id, 
                              levels = c("6", "5", "3", "1", "2", "4", "7"), 
                              ordered = TRUE)

# Convert "Not Applicable" separately as a character to avoid ordering issues
sar_data$package_id[sar_data$package_id == "Not Applicable"] <- NA  # Assign NA for now

# Convert NA values back to "Not Applicable" but keep them separate from ordering
sar_data$package_id <- addNA(sar_data$package_id)
levels(sar_data$package_id)[is.na(levels(sar_data$package_id))] <- "Not Applicable"

# Check if NA values are still present
print("Missing values in package_id after correction:")
print(sum(is.na(sar_data$package_id)))

# Verify new factor levels
print("Updated levels of package_id:")
print(levels(sar_data$package_id))



# Convert binary categorical columns to factors
sar_data$online_booking <- as.factor(sar_data$online_booking)
sar_data$mobile_site_booking <- as.factor(sar_data$mobile_site_booking)
sar_data$Car_Cancellation <- as.factor(sar_data$Car_Cancellation)



# Remove extra spaces and standardize format
sar_data$from_date <- trimws(gsub("\\s+", " ", sar_data$from_date))
sar_data$booking_created <- trimws(gsub("\\s+", " ", sar_data$booking_created))
# Add seconds manually where missing
sar_data$from_date <- ifelse(grepl("^[0-9]+/[0-9]+/[0-9]+ [0-9]+:[0-9]+$", sar_data$from_date),
                             paste0(sar_data$from_date, ":00"), 
                             sar_data$from_date)

sar_data$booking_created <- ifelse(grepl("^[0-9]+/[0-9]+/[0-9]+ [0-9]+:[0-9]+$", sar_data$booking_created),
                                   paste0(sar_data$booking_created, ":00"), 
                                   sar_data$booking_created)

sar_data$from_date <- as.POSIXct(sar_data$from_date, format="%m/%d/%Y %H:%M:%S", tz="UTC")
sar_data$booking_created <- as.POSIXct(sar_data$booking_created, format="%m/%d/%Y %H:%M:%S", tz="UTC")

# Verify conversion
print("Updated 'from_date' and 'booking_created' after formatting:")
print(head(sar_data[, c("from_date", "booking_created")], 10))

# Extract time-based features
sar_data$from_hour <- as.numeric(format(sar_data$from_date, "%H"))  # Extract hour (0-23)
sar_data$from_day <- as.numeric(format(sar_data$from_date, "%d"))   # Extract day of the month (1-31)
sar_data$from_month <- as.numeric(format(sar_data$from_date, "%m")) # Extract month (1-12)
sar_data$from_weekday <- as.factor(weekdays(sar_data$from_date))    # Extract day of the week

sar_data$booking_hour <- as.numeric(format(sar_data$booking_created, "%H"))
sar_data$booking_day <- as.numeric(format(sar_data$booking_created, "%d"))
sar_data$booking_month <- as.numeric(format(sar_data$booking_created, "%m"))
sar_data$booking_weekday <- as.factor(weekdays(sar_data$booking_created))


# Compute time difference between booking and actual trip start in minutes
sar_data$booking_lead_time <- as.numeric(difftime(sar_data$from_date, sar_data$booking_created, units="mins"))

# Summary of booking lead time
summary(sar_data$booking_lead_time)

sar_data$from_time_bin <- cut(
  sar_data$from_hour,
  breaks = c(-1, 6, 12, 18, 24),
  labels = c("Night", "Morning", "Afternoon", "Evening")
)
sar_data$booking_time_bin <- cut(
  sar_data$booking_hour,
  breaks = c(-1, 6, 12, 18, 24),
  labels = c("Night", "Morning", "Afternoon", "Evening")
)


sar_data<- subset(sar_data, select = -c(from_date, booking_created))

str(sar_data)






#######################################################

# Load required library
library(ggplot2)

# Count occurrences of each category
cancel_counts <- table(sar_data$Car_Cancellation)

# Convert to dataframe
cancel_df <- data.frame(
  Category = c("Not Cancelled (0)", "Cancelled (1)"),
  Count = as.numeric(cancel_counts)
)

# Calculate percentage
cancel_df$Percentage <- round((cancel_df$Count / sum(cancel_df$Count)) * 100, 2)

# Create pie chart with ggplot2
ggplot(cancel_df, aes(x = "", y = Count, fill = Category)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste0(Count, " (", Percentage, "%)")),
            position = position_stack(vjust = 0.5), size = 6) +
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +  # Custom colors
  labs(title = "Ride Cancellations: Cancelled vs Not Cancelled") +
  theme_void()  # Remove unnecessary background elements

###################################################
str(sar_data)
# Check for missing values in train_data
missing_counts <- colSums(is.na(sar_data))

# Print columns with missing values
print("Columns with Missing Values:")
print(missing_counts[missing_counts > 0])
str(sar_data)

library(caret)  # For stratified sampling
set.seed(123)   # Ensure reproducibility
# Define split ratios
train_ratio <- 0.6
test_ratio <- 0.2
val_ratio <- 0.2

# Create train index using stratified sampling
train_index <- createDataPartition(sar_data$Car_Cancellation, p = train_ratio, list = FALSE)

# Split train set
train_data <- sar_data[train_index, ]
remaining_data <- sar_data[-train_index, ]

# Split remaining data into test and validation (50%-50% of remaining)
test_index <- createDataPartition(remaining_data$Car_Cancellation, p = test_ratio / (test_ratio + val_ratio), list = FALSE)

test_data <- remaining_data[test_index, ]
val_data <- remaining_data[-test_index, ]

# Verify the number of rows in each set
cat("Training Set:", nrow(train_data), "\n")
cat("Testing Set:", nrow(test_data), "\n")
cat("Validation Set:", nrow(val_data), "\n")

# Verify class distribution in each set
cat("\nClass Distribution in Training Set:\n")
print(prop.table(table(train_data$Car_Cancellation)) * 100)

cat("\nClass Distribution in Testing Set:\n")
print(prop.table(table(test_data$Car_Cancellation)) * 100)

cat("\nClass Distribution in Validation Set:\n")
print(prop.table(table(val_data$Car_Cancellation)) * 100)

#####################################################
# Find categorical columns with more than 53 levels
high_cardinality_vars <- sapply(train_data, function(col) if (is.factor(col)) length(levels(col)) else NA)
high_cardinality_vars <- high_cardinality_vars[!is.na(high_cardinality_vars) & high_cardinality_vars > 53]

# Print columns exceeding 53 categories
print("Columns with High Cardinality:")
print(high_cardinality_vars)
# Function to replace rare categories with "Other"
combine_rare_levels <- function(column, threshold = 50) {
  freq_table <- table(column)  # Get frequency count of each level
  rare_levels <- names(freq_table[freq_table < threshold])  # Find rare categories
  column <- factor(ifelse(column %in% rare_levels, "Other", as.character(column)))  # Replace with "Other"
  return(column)
}
# Apply function to reduce categorical levels
train_data$from_area_id <- combine_rare_levels(train_data$from_area_id)
train_data$to_area_id <- combine_rare_levels(train_data$to_area_id)

# Check new number of unique levels
print("New levels after reducing cardinality:")
print(length(levels(train_data$from_area_id)))
print(length(levels(train_data$to_area_id)))
# Install the package if not already installed
if (!require(randomForest)) {
  install.packages("randomForest", dependencies = TRUE)
}

# Load the library
library(randomForest)


set.seed(123)
rf_model <- randomForest(Car_Cancellation ~ ., data = train_data, ntree = 100, mtry = 3, importance = TRUE)

# Print model summary
print(rf_model)


#########################
# Feature importance analysis
importance_scores <- importance(rf_model)
importance_df <- data.frame(Feature = rownames(importance_scores), Importance = importance_scores[, 1])

# Plot feature importance
library(ggplot2)
ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Feature Importance (Random Forest)", x = "Features", y = "Importance Score") +
  theme_minimal()
########
# Feature importance analysis
importance_scores <- importance(rf_model)  # Extract feature importance
importance_df <- data.frame(Feature = rownames(importance_scores), Importance = importance_scores[, 1])

# Select top 10 features
top_10_features <- importance_df %>% 
  arrange(desc(Importance)) %>% 
  head(10)

# Identify categorical vs numerical features
categorical_features <- c("from_area_id", "to_area_id", "from_city_id", "online_booking")  # Adjust based on dataset
numerical_features <- setdiff(top_10_features$Feature, categorical_features)

top_10_features$Type <- ifelse(top_10_features$Feature %in% categorical_features, "Categorical", "Numerical")

# Print Top 10 Features
cat("\nTop 10 Features Contributing to Cancellation:\n")
print(top_10_features)

# Plot top 10 feature importance
library(ggplot2)
ggplot(top_10_features, aes(x = reorder(Feature, Importance), y = Importance, fill = Type)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("Categorical" = "darkorange", "Numerical" = "steelblue")) +
  labs(title = "Top 10 Features Contributing to Cancellation",
       x = "Features", y = "Importance Score", fill = "Feature Type") +
  theme_minimal()

##########
library(ggplot2)
library(dplyr)

# Filter only cancelled cases (Car_Cancellation == 1)
cancellation_data <- train_data %>% filter(Car_Cancellation == 1)

###  Cancellations by `from_area_id`
ggplot(cancellation_data, aes(x = from_area_id)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by from_area_id", x = "from_area_id", y = "Count") +
  theme_minimal() +
  coord_flip()

###  Cancellations by `to_area_id`
ggplot(cancellation_data, aes(x = to_area_id)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by to_area_id", x = "to_area_id", y = "Count") +
  theme_minimal() +
  coord_flip()


###  Cancellations by `online_booking`
ggplot(cancellation_data, aes(x = online_booking)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by online_booking", x = "Online Booking", y = "Count") +
  theme_minimal()

print(unique(cancellation_data$from_month))

library(ggplot2)

# Plot cancellations by `booking_month`
ggplot(cancellation_data, aes(x = booking_month)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by Booking Month", x = "Booking Month", y = "Count") +
  theme_minimal() +
  scale_x_discrete(limits = c("January", "February", "March", "April", 
                              "May", "June", "July", "August", 
                              "September", "October", "November", "December"))



library(ggplot2)

# Plot cancellations by `from_month` with step size of 1
ggplot(cancellation_data, aes(x = from_month)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by From Month", x = "From Month", y = "Count") +
  scale_x_continuous(breaks = seq(min(cancellation_data$from_month, na.rm = TRUE), 
                                  max(cancellation_data$from_month, na.rm = TRUE), 
                                  by = 1)) +  # Step size of 1
  theme_minimal()
##
library(ggplot2)

# Replace NA or out-of-range values with "Unknown"
cancellation_data <- cancellation_data %>%
  mutate(from_month = ifelse(is.na(from_month) | from_month < 1 | from_month > 12, "Unknown", from_month))

# Map numerical months to month names
cancellation_data$from_month <- factor(cancellation_data$from_month, 
                                       levels = c(1:12, "Unknown"), 
                                       labels = c("January", "February", "March", "April", 
                                                  "May", "June", "July", "August", 
                                                  "September", "October", "November", "December", "Unknown"))

# Calculate the month with the highest cancellations
highest_month <- cancellation_data %>%
  group_by(from_month) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice(1)  # Select the month with the highest count

# Add a column to indicate if a bar should be highlighted
cancellation_data$Highlight <- ifelse(cancellation_data$from_month == highest_month$from_month, "Highest", "Others")

# Plot cancellations by `from_month`
ggplot(cancellation_data, aes(x = from_month, fill = Highlight)) +
  geom_bar(alpha = 0.8) +
  scale_fill_manual(values = c("Highest" = "red", "Others" = "darkorange")) +  # Color for highest bar
  labs(title = "Cancellations by From Month", x = "Month", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels




###  Cancellations by `from_day`
ggplot(cancellation_data, aes(x = from_day)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by from_day", x = "From Day", y = "Count") +
  theme_minimal()
library(ggplot2)

# Plot cancellations by `from_day` with step size of 5
ggplot(cancellation_data, aes(x = from_day)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by From Day", x = "From Day", y = "Count") +
  scale_x_continuous(breaks = seq(min(cancellation_data$from_day, na.rm = TRUE), 
                                  max(cancellation_data$from_day, na.rm = TRUE), 
                                  by = 1)) +  # Step size of 5
  theme_minimal()
library(ggplot2)
library(dplyr)

# Group `from_day` into Start, Mid, End of the month
cancellation_data <- cancellation_data %>%
  mutate(from_day_group = case_when(
    from_day >= 1 & from_day <= 10 ~ "Start of Month",
    from_day >= 11 & from_day <= 20 ~ "Mid-Month",
    from_day >= 21 & from_day <= 31 ~ "End of Month"
  ))

# Plot cancellations by grouped from_day
ggplot(cancellation_data, aes(x = from_day_group)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  labs(title = "Cancellations by Period of the Month", x = "Period of the Month", y = "Count") +
  theme_minimal()

###  Distribution of `from_lat` for Cancellations (Density Plot)
ggplot(cancellation_data, aes(x = from_lat)) +
  geom_density(fill = "darkorange", alpha = 0.7) +
  labs(title = "Density of from_lat for Cancellations", x = "From Latitude", y = "Density") +
  theme_minimal()
###  Distribution of `to_lat` for Cancellations (Density Plot)
ggplot(cancellation_data, aes(x = to_lat)) +
  geom_density(fill = "darkorange", alpha = 0.7) +
  labs(title = "Density of to_lat for Cancellations", x = "To Latitude", y = "Density") +
  theme_minimal()

### Booking Lead Time for Cancellations (Histogram)
ggplot(cancellation_data, aes(x = booking_lead_time)) +
  geom_histogram(fill = "darkorange", bins = 30, alpha = 0.7) +
  labs(title = "Booking Lead Time Distribution (Cancellations)", x = "Booking Lead Time", y = "Count") +
  theme_minimal()





###########
library(ggplot2)
library(dplyr)

# Define the top 10 features
top_10_features <- c("from_area_id", "from_lat", "booking_lead_time", "to_lat", "online_booking",
                     "to_area_id", "booking_month", "from_month", "from_day", "to_long")

# Identify categorical & numerical features
categorical_features <- c("from_area_id", "to_area_id", "online_booking", "booking_month", "from_month", "from_day")  
numerical_features <- setdiff(top_10_features, categorical_features)

# Filter only cancelled cases (Car_Cancellation == 1)
cancellation_data <- train_data %>% filter(Car_Cancellation == 1)

###  Categorical Feature Analysis ###
for (feature in categorical_features) {
  print(ggplot(cancellation_data, aes(x = .data[[feature]])) +
          geom_bar(fill = "darkorange", alpha = 0.8) +
          labs(title = paste("Cancellations by", feature),
               x = feature, y = "Count") +
          theme_minimal() +
          coord_flip())  # Flip for better readability
}

###  Numerical Feature Analysis ###
for (feature in numerical_features) {
  
  if (feature %in% c("from_lat", "to_lat", "to_long")) {
    # Density plot for latitude/longitude (geographical insights)
    print(ggplot(cancellation_data, aes(x = .data[[feature]])) +
            geom_density(fill = "darkorange", alpha = 0.7) +
            labs(title = paste("Density of", feature, "for Cancellations"),
                 x = feature, y = "Density") +
            theme_minimal())
    
  } else if (feature == "booking_lead_time") {
    # Histogram for booking lead time
    print(ggplot(cancellation_data, aes(x = .data[[feature]])) +
            geom_histogram(fill = "darkorange", bins = 30, alpha = 0.7) +
            labs(title = "Booking Lead Time Distribution (Cancellations)",
                 x = "Booking Lead Time", y = "Count") +
            theme_minimal())
    
  } else {
    # Boxplot for general numerical variables
    print(ggplot(cancellation_data, aes(y = .data[[feature]])) +
            geom_boxplot(fill = "darkorange", alpha = 0.7) +
            labs(title = paste("Distribution of", feature, "for Cancellations"),
                 x = "Cancelled Rides", y = feature) +
            theme_minimal())
  }
}



##############
#rerun
library(randomForest)

# Remove least important features
train_data_reduced <- train_data[, !colnames(train_data) %in% c(
  "package_id", "mobile_site_booking", "from_weekday", 
  "booking_weekday", "from_city_id", "from_time_bin", 
  "vehicle_model_id", "booking_time_bin", "travel_type_id", 
  "booking_hour", "from_long", "from_hour","booking_day","to_long","from_day"
)]

# Rerun Random Forest on reduced dataset
set.seed(123)
rf_model_reduced <- randomForest(Car_Cancellation ~ ., data = train_data_reduced, ntree = 100, mtry = 3, importance = TRUE)

# Print model summary
print(rf_model_reduced)
##################

#################
# Check lengths of predictions and actual labels
cat("Length of val_predictions_tuned:", length(val_predictions_tuned), "\n")
cat("Length of val_data_reduced$Car_Cancellation:", length(val_data_reduced$Car_Cancellation), "\n")

# Check factor levels of both
cat("Levels of val_predictions_tuned:\n")
print(levels(val_predictions_tuned))

cat("Levels of val_data_reduced$Car_Cancellation:\n")
print(levels(val_data_reduced$Car_Cancellation))










#######################check1##########
library(randomForest)
library(caret)

set.seed(123)  # Ensure reproducibility

###  Function to Replace Rare Categories ###
combine_rare_levels <- function(column, threshold = 50) {
  if (is.factor(column) || is.character(column)) {
    freq_table <- table(column)  # Get frequency count of each level
    rare_levels <- names(freq_table[freq_table < threshold])  # Find rare categories
    column <- factor(ifelse(column %in% rare_levels, "Other", as.character(column)))  # Replace with "Other"
  }
  return(column)
}

###  Split Data into Train (60%), Validate (20%), and Test (20%) ###

# Stratified sampling to maintain class balance
train_index <- createDataPartition(sar_data$Car_Cancellation, p = 0.6, list = FALSE)
train_data <- sar_data[train_index, ]
remaining_data <- sar_data[-train_index, ]

# Split remaining data into Validation (50%) and Test (50%)
val_index <- createDataPartition(remaining_data$Car_Cancellation, p = 0.5, list = FALSE)
val_data <- remaining_data[val_index, ]
test_data <- remaining_data[-val_index, ]

# Verify dataset sizes
cat("Training Set:", nrow(train_data), "\n")
cat("Validation Set:", nrow(val_data), "\n")
cat("Test Set:", nrow(test_data), "\n")

###  Apply Rare Category Handling to All Categorical Columns ###
categorical_columns <- c("from_area_id", "to_area_id", "from_city_id")  # Add more if needed

for (col in categorical_columns) {
  train_data[[col]] <- combine_rare_levels(train_data[[col]])
  val_data[[col]] <- combine_rare_levels(val_data[[col]])
  test_data[[col]] <- combine_rare_levels(test_data[[col]])
}

###  Remove Least Important Features ###
features_to_remove <- c("package_id", "mobile_site_booking", "from_weekday", 
                        "booking_weekday", "from_city_id", "from_time_bin", 
                        "vehicle_model_id", "booking_time_bin", "travel_type_id", 
                        "booking_hour", "from_long", "from_hour", "booking_day", 
                        "to_long", "from_day")

train_data_reduced <- train_data[, !colnames(train_data) %in% features_to_remove]
val_data_reduced <- val_data[, !colnames(val_data) %in% features_to_remove]
test_data_reduced <- test_data[, !colnames(test_data) %in% features_to_remove]

###  Train Random Forest Model ###
rf_model_reduced <- randomForest(Car_Cancellation ~ ., data = train_data_reduced, ntree = 100, mtry = 3, importance = TRUE)

# Print model summary
cat("\nRandom Forest Model Summary:\n")
print(rf_model_reduced)

### Ensure Factor Levels Match Training Set ###
for (col in colnames(train_data_reduced)) {
  if (is.factor(train_data_reduced[[col]])) {
    val_data_reduced[[col]] <- factor(val_data_reduced[[col]], levels = levels(train_data_reduced[[col]]))
    test_data_reduced[[col]] <- factor(test_data_reduced[[col]], levels = levels(train_data_reduced[[col]]))
  }
}

### ⃣ Re-run Predictions & Model Evaluation ###
# Predict on validation data
val_predictions <- predict(rf_model_reduced, newdata = val_data_reduced)

# Compute confusion matrix for validation set
val_conf_matrix <- confusionMatrix(val_predictions, val_data_reduced$Car_Cancellation, positive = "1")
cat("\nValidation Metrics:\n")
print(val_conf_matrix)

# Predict on test data
test_predictions <- predict(rf_model_reduced, newdata = test_data_reduced)

# Compute confusion matrix for test set
test_conf_matrix <- confusionMatrix(test_predictions, test_data_reduced$Car_Cancellation, positive = "1")
cat("\nTest Metrics:\n")
print(test_conf_matrix)

#####################
# Set class weights: Give higher weight to minority class (Cancelled)
class_weights <- c("0" = 0.5, "1" = 2)  # Adjust weights based on class imbalance

# Retrain Random Forest with Class Weights
set.seed(123)
rf_model_weighted <- randomForest(Car_Cancellation ~ ., data = train_data_reduced, 
                                  ntree = 200, mtry = 5, importance = TRUE, classwt = class_weights)

# Predict on Validation Set
val_predictions_weighted <- predict(rf_model_weighted, newdata = val_data_reduced)

# Compute confusion matrix for validation set
val_conf_matrix_weighted <- confusionMatrix(val_predictions_weighted, val_data_reduced$Car_Cancellation, positive = "1")
cat("\nValidation Metrics with Class Weighting:\n")
print(val_conf_matrix_weighted)

# Predict on Test Set
test_predictions_weighted <- predict(rf_model_weighted, newdata = test_data_reduced)

# Compute confusion matrix for test set
test_conf_matrix_weighted <- confusionMatrix(test_predictions_weighted, test_data_reduced$Car_Cancellation, positive = "1")
cat("\nTest Metrics with Class Weighting:\n")
print(test_conf_matrix_weighted)

############################################
# Load Required Libraries
library(caret)

# Set Seed for Reproducibility
set.seed(123)

# Define Split Ratios
train_ratio <- 0.6
test_ratio <- 0.2
val_ratio <- 0.2

# Stratified Train-Test-Validation Split
train_index <- createDataPartition(sar_data$Car_Cancellation, p = train_ratio, list = FALSE)
train_data <- sar_data[train_index, ]
remaining_data <- sar_data[-train_index, ]

test_index <- createDataPartition(remaining_data$Car_Cancellation, p = test_ratio / (test_ratio + val_ratio), list = FALSE)
test_data <- remaining_data[test_index, ]
val_data <- remaining_data[-test_index, ]

# Verify the number of rows in each set
cat("Training Set:", nrow(train_data), "\n")
cat("Testing Set:", nrow(test_data), "\n")
cat("Validation Set:", nrow(val_data), "\n")

# Function to replace rare categories with "Other"
combine_rare_levels <- function(column, threshold = 50) {
  freq_table <- table(column)
  rare_levels <- names(freq_table[freq_table < threshold])
  column <- factor(ifelse(column %in% rare_levels, "Other", as.character(column)))
  return(column)
}

# Apply Function to Reduce High Cardinality in Training Data
train_data$from_area_id <- combine_rare_levels(train_data$from_area_id)
train_data$to_area_id <- combine_rare_levels(train_data$to_area_id)
train_data$vehicle_model_id <- combine_rare_levels(train_data$vehicle_model_id)

# Ensure Test and Validation Data Have the Same Levels as Training Data
test_data$from_area_id <- factor(test_data$from_area_id, levels = levels(train_data$from_area_id))
val_data$from_area_id <- factor(val_data$from_area_id, levels = levels(train_data$from_area_id))

test_data$to_area_id <- factor(test_data$to_area_id, levels = levels(train_data$to_area_id))
val_data$to_area_id <- factor(val_data$to_area_id, levels = levels(train_data$to_area_id))

test_data$vehicle_model_id <- factor(test_data$vehicle_model_id, levels = levels(train_data$vehicle_model_id))
val_data$vehicle_model_id <- factor(val_data$vehicle_model_id, levels = levels(train_data$vehicle_model_id))

# Convert Unseen Levels to "Other"
test_data$vehicle_model_id[is.na(test_data$vehicle_model_id)] <- "Other"
val_data$vehicle_model_id[is.na(val_data$vehicle_model_id)] <- "Other"

test_data$from_area_id[is.na(test_data$from_area_id)] <- "Other"
val_data$from_area_id[is.na(val_data$from_area_id)] <- "Other"

test_data$to_area_id[is.na(test_data$to_area_id)] <- "Other"
val_data$to_area_id[is.na(val_data$to_area_id)] <- "Other"

# Convert Target Variable to Numeric
train_data$Car_Cancellation <- as.numeric(as.character(train_data$Car_Cancellation))
test_data$Car_Cancellation <- as.numeric(as.character(test_data$Car_Cancellation))
val_data$Car_Cancellation <- as.numeric(as.character(val_data$Car_Cancellation))

# Train Logistic Regression Model
log_model <- glm(Car_Cancellation ~ ., data = train_data, family = binomial())

# Model Summary
summary(log_model)

# Model Predictions
train_pred <- predict(log_model, train_data, type = "response")
test_pred <- predict(log_model, test_data, type = "response")
val_pred <- predict(log_model, val_data, type = "response")

# Convert Probabilities to Binary Labels (Threshold = 0.5)
train_pred_class <- ifelse(train_pred > 0.5, 1, 0)
test_pred_class <- ifelse(test_pred > 0.5, 1, 0)
val_pred_class <- ifelse(val_pred > 0.5, 1, 0)

# Model Evaluation Metrics
eval_metrics <- function(actual, predicted) {
  cm <- confusionMatrix(as.factor(predicted), as.factor(actual), positive = "1")
  return(cm)
}

cat("\nTrain Set Metrics:\n")
print(eval_metrics(train_data$Car_Cancellation, train_pred_class))

cat("\nTest Set Metrics:\n")
print(eval_metrics(test_data$Car_Cancellation, test_pred_class))

cat("\nValidation Set Metrics:\n")
print(eval_metrics(val_data$Car_Cancellation, val_pred_class))

# Logistic Regression Equation
cat("\nLogistic Regression Equation:\n")
cat("Logit(P) = ", paste(round(coef(log_model), 4), collapse = " + "), "\n")

# Logistic Regression Equation
cat("\nLogistic Regression Equation:\n")
cat("Logit(P) = ", paste(round(coef(log_model), 4), collapse = " + "), "\n")
# Extract coefficients from the model
coefficients <- coef(log_model)

# Remove NA values
coefficients <- coefficients[!is.na(coefficients)]

# Format the equation
logistic_equation <- paste(
  "Logit(P) =", 
  paste(names(coefficients), round(coefficients, 4), sep = " * ", collapse = " + ")
)

# Print the equation
cat(logistic_equation, "\n")





##############
