run_analysis.R

This program is designed to clean up the Samsung galaxy S data collected.

The program relies on X_test.txt, y_test.txt, subject_test.txt, X_train.txt, y_train.txt and features.txt files.

To be able to run the script, the Samsung galaxy files must be located in "./UCI HAR Dataset/test/X_test.txt" etc.

The program will first clean the test files by adding column names (from features.txt) to the data from X_test.txt file. Then it will add the activity labels by column binding with y_test.txt file.

Same will be done to the train files. Once the column names and activity labels are added, the test and train data will be row bound together into one big data table.

The resulting table will be written to "./myresult/resultTable.txt"