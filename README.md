# SAR_PROJECT
This project analyzes driver cancellations at San Francisco Auto Rental (SAR) using predictive analytics on historical booking data. Key steps included data preprocessing, feature selection, and model training, with Random Forest and Logistic Regression
                                                         

                                              











Executive Summary: 
In 2013, San Francisco Auto Rental (SAR) identified a recurring issue of driver cancellations, impacting customer experience and operational efficiency. By 2024, SAR still lacked a data-driven understanding of why these cancellations occurred and how to mitigate them.
A predictive analytics approach was applied to historical booking data to identify key patterns influencing cancellations. The data underwent extensive preprocessing, including:
•	Handling missing values using imputation and feature engineering.
•	Feature reduction by eliminating low-impact attributes.
•	Categorical encoding and handling high-cardinality variables to improve model interpretability.
•	Stratified data partitioning into training (60%), validation (20%), and test (20%) sets.
Key patterns and insights emerged:
•	Last-minute bookings, rare pickup/drop-off locations, and online reservations showed higher cancellation rates.
•	October and May had the highest cancellation rates, with spikes on the first and mid-month days.
•	Geospatial analysis indicated that certain city areas had a disproportionately higher cancellation frequency.
A Random Forest model was chosen for predictive analysis. Model refinement steps included:
•	Removing low-impact features to enhance efficiency.
•	Applying class weighting to address severe class imbalance (fewer cancellations).
•	Evaluating model performance based on accuracy, precision, recall (sensitivity), specificity, and F1-score.
Findings & Model Performance:
•	Baseline model: High accuracy but poor recall for canceled rides.
•	Feature reduction: Retained accuracy but did not significantly improve recall.
•	Class-weighted Random Forest: Minor improvements in detecting cancellations, but overall recall remained low.
•	Logistic Regression model: Performed the worst in recall, confirming that a linear approach was ineffective for this problem.
Key Takeaways:
•	SAR’s current cancellation issue is influenced by both temporal (time-based) and spatial (location-based) factors.
•	Despite model adjustments, recall for cancellations remained low, indicating the need for further enhancements, such as oversampling techniques (e.g., SMOTE), alternative models (XGBoost, Gradient Boosting), or ensemble approaches.
•	Actionable recommendations were provided to SAR, including dynamic pricing, enhanced ride allocation strategies, and policy adjustments to minimize cancellations and improve business operations.







Business and Analytics Goals
San Francisco Auto Rental (SAR) aims to address a critical issue in its operations: the high rate of ride cancellations by drivers. This challenge not only impacts customer satisfaction but also affects the overall efficiency and reliability of SAR’s services. To support SAR’s management in mitigating these cancellations, this project focuses on developing a predictive model that can anticipate cancellations based on historical data.
The primary objectives of this analysis are:
1.	Predictive Model Development – Build an analytics model to predict the likelihood of a ride being canceled by the driver.
2.	Customer Experience Enhancement – Identify key cancellation drivers and enable SAR to take proactive measures to improve service reliability.
3.	Operational Optimization – Optimize resource allocation by understanding cancellation patterns and their operational impact.
4.	Actionable Insights – Provide SAR management with data-driven recommendations to reduce cancellations and improve efficiency.
5.	Model Interpretability – Ensure that SAR’s management can understand and effectively utilize the predictive model for decision-making.
By achieving these objectives, SAR will be better positioned to enhance customer satisfaction, optimize operations, and reduce the frequency of ride cancellations.

Attributes Definition
The dataset (“SAR Rental.csv”)  consists of  10,000 records from 2013 and includes 19 attributes. These attributes provide crucial insights into user behavior, travel details, and booking methods. Below is a description of each attribute:
1.	Row ID: This is the unique identifier of this dataset. It is a number identifying each record. 
2.	User ID: This is the identifier of each client. There are many duplicates in this subset, meaning there are many clients who have called multiple rides. 
3.	Vehicle Model ID: This is an ID that represents the type of vehicle driven for each ride.  This also identifies the driver of the vehicle. 
4.	Travel Type ID: This is an ID that represents the type of travel (1= long distance, 2= point to point, 3= hourly rental). 
5.	Package ID: This is an ID that represents the type of travel package, with the following descriptions: 1=4hrs & 40kms, 2=8hrs & 80kms, 3=6hrs & 60kms, 4= 10hrs & 100kms, 5=5hrs & 50kms, 6=3hrs & 30kms, 7=12hrs & 120kms. 
6.	From Area: This is an identifier of the starting area. Available only for point-to-point travel. 
7.	To Area: This is an identifier of the ending area. Available only for point-to-point travel. 
8.	From City ID: Unique identifier of the starting city (i.e. suburb cities of San Francisco). 
9.	To City ID: Unique identifier of the ending city. 
10.	From Date: Date and time of the requested trip start. 
11.	To Date: Time stamp of trip end. 
12.	Online Booking: A binary (0,1) variable representing whether the booking was made online or not. 0 represents no, 1 represents yes. 
13.	Mobile Site Booking: A binary (0,1) variable representing whether the booking was made on their mobile site or not. 0 represents no, 1 represents yes. 
14.	Booking Created: Date and time of booking created.
15.	From Lat: The latitude of the start area. 
16.	From Long: The longitude of the start area. 
17.	To Lat: The latitude of the end area. 
18.	To Long: The longitude of the end area. 
19.	Car Cancellation: The target variable. A binary (0,1) variable representing whether or not the ride was cancelled. 0 means no, 1 means yes. 
•	Location-based factors (From Area To Area) help in allocating drivers efficiently and reducing cancellations in less frequent areas.
•	Booking lead time & time-based features allow better demand forecasting and dynamic pricing adjustments.
•	Booking method insights help in optimizing online & mobile booking policies to improve ride completion rates.

By leveraging these attributes, the predictive model effectively identifies rides at high risk of cancellation, allowing SAR to take proactive measures to reduce cancellations and improve service efficiency.
 
Important Class for the Goal: Class 1 (Canceled Rides)
The primary goal of the analysis is to predict and mitigate ride cancellations. This makes Class 1 (Canceled rides) the most important class in the classification task. The dataset, however, is highly imbalanced, with the vast majority of instances belonging to Class 0 (Not Canceled rides). Below is the class distribution across different datasets:
Class Distribution Across Data Splits
1. Training Set:
•	Not Canceled (Class 0): 92.57%
•	Canceled (Class 1 - Important Class): 7.43%
2. Testing Set:
•	Not Canceled (Class 0): 92.55%
•	Canceled (Class 1 - Important Class): 7.45%
3. Validation Set:
•	Not Canceled (Class 0): 92.60%
•	Canceled (Class 1 - Important Class): 7.40%
Key Observations:
1.	Severe Class Imbalance:
o	Across all datasets, less than 8% of rides are canceled, while over 92% are completed successfully.
o	This imbalance makes it difficult for the model to accurately learn patterns for cancellations.
2.	Importance of Class 1 (Canceled Rides):
o	A model that only maximizes accuracy may fail to correctly detect cancellations due to the dominance of Class 0.



 Data Preprocessing - Missing Values Analysis
The dataset contains a total of 10,000 records, and the percentage of missing values for each affected attribute is computed accordingly.
Column	Missing Values	Percentage (%)
To City ID	9,661	96.61%
Package ID	8,248	82.48%
From City ID	6,294	62.94%
To Date	4,178	41.78%
To Area ID	2,091	20.91%
To Lat	2,091	20.91%
To Long	2,091	20.91%
From Area ID	15	0.15%
From Lat	15	0.15%
From Long	15	0.15%
Row ID	0	0.00%
User ID	0	0.00%
Vehicle Model ID	0	0.00%
Travel Type ID	0	0.00%
From Date	0	0.00%
Online Booking	0	0.00%
Mobile Site Booking	0	0.00%
Booking Created	0	0.00%
Car Cancellation	0	0.00%

Summary of Data Cleaning, Investigation, and Imputation Steps
1. Dropped Columns
•	to_city_id: Removed as it was not relevant for analysis.
•	package_missing: Temporary column used for analysis; dropped after investigation.
•	to_date: Investigated its relationship with Car_Cancellation and found a lower cancellation rate for missing values. Removed due to its high missing rate and minimal impact on predictions.
2. Investigated & Imputed Missing Values
Package ID
•	Investigation: Checked the relationship between missing package_id and travel_type_id. It was determined that all missing values were from travel_type_id 1 and 2.
•	Imputation: Assigned "Not Applicable" to missing values for travel_type_id 1 & 2. Retained original values for travel_type_id 3.
From City ID
•	Investigation: Analyzed missing values by travel_type_id. Found that: 
o	15.6% of travel_type_id 1 cases were missing.
o	57.9% of travel_type_id 2 cases were missing.
o	94.8% of travel_type_id 3 cases were missing.
o	Checked correlation with Car_Cancellation, revealing that missing values had a lower cancellation rate.
•	Imputation: 
o	Replaced missing from_city_id for travel_type_id 1 with the most frequent value ("15").
o	Assigned "Unknown" for travel_type_id 2.
o	Assigned "Not Applicable" for travel_type_id 3.
To Area ID, To Lat, To Long
•	Investigation: Checked missing values by travel_type_id: 
o	Found that 100% of travel_type_id 1 & 3 cases had missing values.
o	Found no missing values for travel_type_id 2.
•	Imputation: 
o	Assigned "Not Applicable" for to_area_id in travel_type_id 1 & 3.
o	Imputed to_lat and to_long using median values.
From Lat, From Long
•	Investigation: Checked missing values by travel_type_id. Found: 
o	4.42% of travel_type_id 1 cases were missing.
o	100% of travel_type_id 2 & 3 cases had no missing values.
•	Imputation: 
o	Imputed missing values for travel_type_id 1 using the median latitude & longitude based on from_area_id.
o	Any remaining missing values were replaced with the overall median for Long Distance trips.
From Area ID
•	Investigation: Identified 15 missing values.
•	Imputation: Replaced missing values with "Unknown".
3. Final Missing Value Check
•	Verified that all missing values were successfully handled across all columns.
 
Summary of Zero-Invalid Column Investigation Strategy
1. Identifying Columns Where Zero is Invalid
•	Certain columns contain categorical or date-related values where a zero entry would be logically incorrect or indicate data corruption.
•	The selected columns include identifiers (row#, user_id, vehicle_model_id), categorical values (package_id, travel_type_id, to_area_id, from_city_id), and date/geolocation fields (from_date, booking_created, from_lat, from_long, to_lat, to_long).
2. Checking for Zero Values
•	The dataset was scanned for zero occurrences in these columns.
•	The analysis confirmed that no zero values were present in these fields, indicating data integrity for these attributes.
 
3. Dropping Unnecessary Identifiers
•	row# and user_id were removed as they are unique identifiers with no predictive value in the analysis.
Data Type Conversion & Processing Strategy:
 
1. Categorical Variables Conversion 
Converted to Factors:
•	vehicle_model_id
•	travel_type_id
•	from_area_id
•	to_area_id
•	from_city_id
2. Ordering package_id Factor Correctly 
Based on the given descriptions, the correct order from shortest to longest duration & distance is:
Package ID	Duration & Distance
6	3 hrs & 30 kms
1	4 hrs & 40 kms
5	5 hrs & 50 kms
3	6 hrs & 60 kms
2	8 hrs & 80 kms
4	10 hrs & 100 kms
7	12 hrs & 120 kms

Logical Ordering Based on Duration & Distance:
•	package_id represents travel packages sorted from shortest to longest (Duration & Distance).
•	Final Ordered Levels: 6 < 1 < 5 < 3 < 2 < 4 < 7
•	Stored as an ordered factor, ensuring correct sequencing for comparisons and modeling.
3. Binary Variables Conversion
Converted to Factors (0/1 Binary Categories):
•	online_booking
•	mobile_site_booking
•	Car_Cancellation
4. Date-Time Conversion for from_date & booking_created 
Cleaning Strings Before Parsing: 
o	Removed extra spaces to prevent parsing errors.
o	trimws(): Trims leading/trailing spaces.
2.	Ensuring Proper Date-Time Format: 
o	Original format: %m/%d/%Y %I:%M %p (Missing seconds)
o	Fixed Format: %m/%d/%Y %I:%M:%S %p
o	Timezone Standardized: tz="UTC" for consistency.
3.	Fixing Missing Seconds: 
o	Appended :00 where missing before conversion to maintain integrity.


Interpretation of VIF Results
The Variance Inflation Factor (VIF) values for the numeric predictors are:
Variable	VIF Value	Interpretation
from_long	1.0076	No multicollinearity
to_lat	1.3232	No multicollinearity   
to_long	1.3208	No multicollinearity 
1.	Since all VIF values are < 5, there is no multicollinearity between from_lat, from_long, to_lat, and to_long.
2.	No need to remove any variables, as each provides independent information.
3.	These predictors can be safely used together in a regression model without causing instability.
Conclusion: numeric variables are not highly correlated with each other and are good to keep in the model.


Handling Date-Time (POSIXct) Variables :
Feature Engineering (Extracting Time-Based Insights)
To make timestamps useful, create the following new columns:
New Column	Meaning
from_hour	The hour of the day when the ride is scheduled to start (0-23). Useful for identifying peak and off-peak hours.
from_day	Day of the month the ride is scheduled (1-31). Helps track monthly trends.
from_month	Month when the ride is scheduled (1-12). Useful for identifying seasonal patterns.
from_weekday	Day of the week (Monday-Sunday) when the ride is scheduled. Helps differentiate weekday vs. weekend patterns.
booking_hour	Hour of the day when the booking was made. Useful for analyzing cancellation trends based on booking time.
booking_day	Day of the month when the booking was made. Helps track trends in booking patterns.
booking_month	Month when the booking was made. Helps analyze seasonal variations in ride bookings.
booking_weekday	Day of the week when the booking was made. Useful to check if bookings on certain days are more likely to be canceled.
booking_lead_time	Time difference (in minutes) between booking creation and ride start time. Helps understand if last-minute bookings have a higher cancellation rate.
from_time_bin	Categorizes from_hour into four time slots: Night (0-6), Morning (6-12), Afternoon (12-18), Evening (18-24). Helps identify cancellation patterns based on the time of the ride.
booking_time_bin	Categorizes booking_hour into Night, Morning, Afternoon, and Evening. Useful for identifying trends in booking behaviors.
________________________________________
Removing Raw POSIXct Columns
The above features are extracted from_date and booking_created can be dropped since they are no longer required in raw format.
 

High-Cardinality Categorical Variables (from_area_id, to_area_id)
from_area_id (523 levels) and to_area_id (480 levels) exceed the 53-level limit for randomForest(),  need to reduce their cardinality.

Group Rare Categories into "Other"
Since most of these categories  have low frequency, combined less common categories into "Other".
Strategy for Stratified Data Splitting
1️  Defining Split Ratios
•	Training Set → 60% of the total data.
•	 
•	Testing Set → 20% of the total data.
 
•	Validation Set → 20% of the total data.
 
This ensures a balanced approach where most data are used for training while keeping enough for evaluation.

2️ Stratified Sampling
•	The dataset is split while preserving the class distribution of Car_Cancellation (target variable).
Step-by-Step Data Partitioning
1.	Training Set (60%) → Selected using stratified sampling.
2.	Remaining Data (40%) → Further split into: 
o	Testing Set (20%)
o	Validation Set (20%)
The split ensures equal representation of the target variable.



LOGISTIC REGRESSION:
Logistic Regression Model for Car Cancellation Prediction
Data Preprocessing
Train-Test-Validation Split
•	Training Set: 60% of the dataset
•	Testing Set: 20% of the dataset
•	Validation Set: 20% of the dataset
•	Stratified sampling was used to maintain class balance.
Handling High Cardinality
•	Categorical variables with more than 53 unique levels were identified.
•	Categories with fewer than 50 occurrences were grouped under "Other".
•	This was applied consistently to the training, test, and validation datasets to prevent errors during model evaluation.
3. Logistic Regression Model
Model Training
•	The dependent variable Car_Cancellation was converted to numeric format.
•	The logistic regression model was trained using the binomial family.
Logistic Regression Equation
The logistic regression equation provides the probability of an event occurring, expressed as:
Logit(P) = Intercept + Coefficient1 * Predictor1 + Coefficient2 * Predictor2 + ...
Each predictor variable contributes to the log-odds of the event occurring, where positive coefficients increase the likelihood and negative coefficients decrease it.
Intercept
•	Intercept (-258.1487): This represents the baseline log-odds when all predictor variables are zero.
 Vehicle Model Influence
•	Different vehicle models influence the outcome. Some have a negative impact (reducing the probability), while others have a positive effect.
Variable	Coefficient	Interpretation
vehicle_model_id24	-2.92	Decreases probability
vehicle_model_id28	-0.0811	Slight decrease
vehicle_model_id65	-0.461	Decreases probability
vehicle_model_id85	-2.5546	Significant decrease
vehicle_model_id87	-0.0808	Minimal decrease
vehicle_model_id89	0.6315	Increases probability
vehicle_model_idOther	-2.3142	Decreases probability significantly
________________________________________
Package Influence
•	Various packages affect the probability, some positively and some negatively.
Package ID	Coefficient	Effect
package_id.L	4.9782	Strong increase
package_id.Q	0.4934	Small increase
package_id.C	-3.4622	Decreases probability significantly
package_id^4	5.8389	Strong increase
package_id^5	-6.6235	Strong decrease
package_id^6	2.2516	Moderate increase
package_id^7	-1.6207	Moderate decrease
________________________________________
 Travel Type Influence
•	travel_type_id2 (1.4828): Increases probability.
________________________________________
Geographical Influence
•	From Area: Certain locations where the ride starts influence the probability.
•	To Area: Destinations also play a role in likelihood.
Location Variable	Coefficient	Effect
from_area_id1017	0.9919	Increases probability
from_area_id1096	-1.2829	Decreases probability
from_area_id768	-12.1868	Strongly decreases probability
from_city_id15	12.3577	Strong increase
from_city_idUnknown	12.6511	Strong increase
to_area_id1068	0.8187	Increases probability
to_area_id393	-1.9466	Decreases probability significantly
________________________________________
Booking Method Influence
•	online_booking1 (1.4676): Increases probability.
•	mobile_site_booking1 (1.1253): Increases probability.
________________________________________
Temporal Influence
•	Booking and travel times impact the likelihood of the event.
•	Booking Lead Time (0.0011): Small positive effect.
Time Variable	Coefficient	Interpretation
from_hour	-0.0437	Decreases probability
from_day	-1.6096	Significant decrease
from_month	-48.7417	Strong decrease
booking_hour	0.0289	Small increase
booking_day	1.6078	Moderate increase
booking_month	48.9601	Strong increase
________________________________________
 Day of the Week Influence
•	Different days of travel and booking affect probability.
Day Variable	Coefficient	Interpretation
from_weekdayMonday	0.0239	Minimal increase
from_weekdaySunday	0.2374	Small increase
from_weekdayWednesday	-0.2204	Slight decrease
booking_weekdayTuesday	-0.5221	Decreases probability
booking_weekdaySunday	0.4111	Moderate increase
________________________________________
Time Bin Influence
•	Time of day when booking and traveling affects the probability.
Time Bin	Coefficient	Interpretation
from_time_binMorning	-0.021	Slight decrease
from_time_binAfternoon	0.2944	Small increase
booking_time_binMorning	-0.5791	Decreases probability significantly
booking_time_binEvening	0.0821	Small increase
________________________________________
 Conclusion
•	Positive Coefficients: Factors like online booking, specific areas, and higher booking months increase the probability of the event.
•	Negative Coefficients: Some vehicle models, travel times, and certain locations decrease the probability.
•	Strongest Influencers: 
o	Increase Probability: High package IDs, online booking, specific city IDs.
o	Decrease Probability: Low-value vehicle models, certain locations, booking in the morning.
Understanding these coefficients allowed for better interpretation and strategic decision-making in logistic regression modeling.




The logistic regression equation derived from the model is:
 
4. Model Evaluation
Confusion Matrix and Statistics
Test Set Metrics
Metric	Value
Accuracy	92.8%
Sensitivity	10.07%
Specificity	99.46%
Precision (Pos Pred)	60.00%
Balanced Accuracy	54.76%
Detection Rate	0.75%
Prevalence	7.45%
Validation Set Metrics
Metric	Value
Accuracy	92.2%
Sensitivity	6.08%
Specificity	99.08%
Precision (Pos Pred)	34.61%
Balanced Accuracy	52.58%
Detection Rate	0.45%
Prevalence	7.40%

  

Interpretation
•	The model has a high specificity (~99%), indicating it correctly identifies non-cancellations.
•	However, low sensitivity (~6-10%) suggests that it fails to capture many actual cancellations.
•	Balanced Accuracy (~52-54%) suggests the model is slightly better than random guessing for predicting cancellations.

Analysis of the Naïve Random Forest Model Results
 Random Forest model is a baseline (naive) model trained on the dataset to predict Car_Cancellation.
________________________________________
1️ Model Setup
•	Number of Trees (ntree = 100) → The model consists of 100 decision trees.
•	Features per Split (mtry = 3) → At each split, 3 randomly chosen features were considered.
•	Feature Importance Calculation (importance = TRUE) → The model calculates which features contribute most to predictions.
________________________________________
2️ Model Performance Overview
 
•	Out-of-Bag (OOB) Error Rate: 6.85% 
o	OOB error rate estimates how well the model generalizes.
o	Lower values indicate better performance.
o	This means ~93.15% accuracy in OOB validation.
________________________________________
Confusion Matrix Interpretation
Actual \ Predicted	0 (Not Canceled)	1 (Canceled)	Class Error
0 (Not Canceled)	5541 correctly predicted	14 misclassified	0.25%
1 (Canceled)	397 misclassified	49 correctly predicted	89.01%
Key Observations:
•	Extremely High Accuracy for 0 (Not Canceled) 
o	Only 0.25% of Not Canceled rides were misclassified.
•	Poor Performance on 1 (Canceled) Class 
o	89.01% misclassification rate for Canceled rides.
o	Model struggles to detect cancellations.












The feature importance plot generated by the Random Forest model provides insights into which variables contribute most to predicting the target variable (Car_Cancellation).
 
 

Top Features Contributing to Predictions:
•	from_area_id: Identified as the most influential predictor, indicating that the ride's origin plays a significant role in cancellations. This suggests regional differences in ride fulfillment rates.
•	from_lat and to_lat: Geographic coordinates of the pickup and drop-off locations rank highly, reinforcing the impact of location-based factors in cancellation patterns.
•	booking_lead_time: The time interval between booking creation and the scheduled ride start is a critical factor, with shorter lead times associated with higher cancellation likelihood.
•	online_booking: The mode of booking demonstrates a strong association with cancellations, highlighting potential behavioral differences between online and offline reservations.
•	to_area_id: The destination location is a key variable, further supporting the relevance of geographic factors in ride cancellations.


Addressing Class Imbalance and Feature Selection 



The results analysis for  two main approaches to improve Random Forest performance:
1.	Removing Least Important Features
2.	Using Class Weights
1️ Removing Least Important Features
   
Impact on Model Performance:
•	OOB Error Rate: Increased slightly from 6.85% (naïve model) to 7.63%.
Validation Set:
•	Accuracy: 92.75% → Slightly higher than the naïve model.
•	Sensitivity (class 1 - Canceled): 13.42% → The ability to detect canceled rides remains very poor.
•	Specificity (class 0 - Not Canceled): 99.14% → The model performs well in detecting the majority class.
•	Kappa: 0.1928 → Reflects poor agreement on the minority class (Canceled).
•	Balanced Accuracy: 56.28% → Only a minor improvement in handling class imbalance.
Test Set:
•	Accuracy: 92.3% → Comparable to the validation set.
•	Sensitivity (class 1 - Canceled): 16.22% → Slight improvement in detecting canceled rides.
•	Specificity (class 0 - Not Canceled): 98.38% → Still highly biased toward the majority class.
•	Kappa: 0.2062 → Indicates a minor increase in agreement for canceled ride predictions.
•	Balanced Accuracy: 57.30% → Slightly improved class balance.
Insights:
•	Removing low-impact features did not significantly improve recall for canceled rides.
•	The model remains biased toward detecting Not Canceled rides, with very low recall for canceled cases.



2️  Adding Class Weights


  


Objective:
•	Address the class imbalance issue by assigning higher weights to the minority class (Canceled), increasing its influence during model training.
________________________________________
Impact on Model Performance:
Validation Set with Weighted Random Forest:
•	Accuracy: 92.25% → Slightly lower than the unweighted model.
•	Sensitivity (class 1 - Canceled): 12.08% → No significant improvement in detecting canceled rides.
•	Specificity (class 0 - Not Canceled): 98.70% → A slight decrease in detecting the majority class.
•	Kappa: 0.16 → Low agreement in predicting the minority class.
•	Balanced Accuracy: 55.39% → Minor improvement in handling class imbalance.
Test Set with Weighted Random Forest:
•	Accuracy: 91.9% → Slight decrease compared to the unweighted model.
•	Sensitivity (class 1 - Canceled): 16.89% → Small improvement in detecting canceled rides.
•	Specificity (class 0 - Not Canceled): 97.89% → Remains high.
Insights:
•	Adding class weights led to minor improvements in recall for the minority class but at the cost of slightly reduced overall accuracy.
•	The improvement in detecting canceled rides remains marginal, highlighting the model’s struggles with extreme class imbalance.
•	False negatives remain high, meaning the model is still missing many canceled rides, which limits its practical use for predicting cancellations.
________________________________________
Comparison of Approaches
Approach	Accuracy (Validation)	Sensitivity (Class 1)	Specificity (Class 0)	Kappa	Balanced Accuracy
Feature Removal Only	92.25%	13.42.%	99.14%	0.19	56.28%
Class Weights Added	92.25%	12.08%	98.70%	0.16	55.39%
Logistic Regression	92.2%	6.08%	99.08	0.0832 	  52.58%
					
Key Observations:
1.	Feature removal did not enhance recall for canceled rides, keeping sensitivity low.
2.	Adding class weights slightly decreased specificity but did not improve recall for the minority class.
3.	Logistic Regression performed the worst in detecting cancellations, showing it may not be suitable for this highly imbalanced dataset.
4.	All methods still struggle with class imbalance






insights from the top 10 features: 

 
 	booking_lead_time represents the time difference (in hours or days) between when the booking was created and when the ride was scheduled to start.
 	booking_lead_time = 0 means that the booking was made on the same day as the ride.
 	People who book just before the ride starts are more likely to cancel.
 
In october and may ride has more cancellations.
 
If rides are from areas that are rare or not frequent, they are more likely cancel.

 The first day of the month has the highest cancellation
 rides requested in October have highest cancellation  online booking has more cancellation than offline booking. 

Ride cancels are likely more if ride booked in mid days of month
 

To areas when are not common /rare they cancelled frequently


Observations and Conclusion
Based on our analysis, the key factors influencing ride cancellations were identified, and data-driven strategies were proposed to mitigate cancellations and improve operational efficiency.
Key Observations:
Location-Based Factors (from_area_id, to_area_id)
•	High cancellation rates were observed in rare or less frequent locations.
•	Drivers are less available in these areas, leading to ride cancellations.
Booking Lead Time (booking_lead_time)
•	A significant number of cancellations occur for last-minute bookings.
•	Customers booking in advance tend to cancel less frequently.
Time-Based Factors (booking_month, from_month, from_day)
•	The highest cancellation rates occur at the beginning of the month.
•	Certain months and specific days exhibit peak cancellation trends.
Booking Type (online_booking)
•	Online bookings have a higher cancellation rate compared to offline bookings.
•	Customers tend to cancel more frequently when they book without prior payment commitments.
Conclusion:
The analytical insights provide actionable recommendations to optimize SAR’s business operations. By implementing targeted policies such as driver incentives, dynamic pricing, cancellation fees, and loyalty rewards, SAR can:
	Reduce overall cancellation rates by improving driver availability and route optimization.
	Enhance customer retention through strategic pricing and personalized booking policies.
	 Increase operational efficiency by ensuring better ride fulfillment and revenue protection.
These insights align with SAR's business goals of improving customer reliability, reducing operational losses, and optimizing fleet efficiency, ultimately enhancing service quality and profitability. 

By implementing these strategies, cancellations can be minimized
Customer reliability can be improved, and driver efficiency can be optimized.

