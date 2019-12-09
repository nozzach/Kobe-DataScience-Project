import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier

# read in the data
data = pd.read_csv('data.csv')

# drop non useful data that will not help with predictions
data.drop('team_id', inplace=True, axis=1)
data.drop('lat', inplace=True, axis=1)
data.drop('lon', inplace=True, axis=1)
data.drop('game_id', inplace=True, axis=1)
data.drop('game_event_id', inplace=True, axis=1)
data.drop('team_name', inplace=True, axis=1)


# transform minutes and seconds remaining to one variable that holds the time left
data["time_remaining"] = data['minutes_remaining'] + data['seconds_remaining'] * 60

# now can drop minutes and seconds remaining
data.drop('minutes_remaining', inplace=True, axis=1)
data.drop('seconds_remaining', inplace=True, axis=1)


# encodes categorical data to numerical
encoder = LabelEncoder()

# change certain attributes to categorical data
data["action_type"] = data["action_type"].astype('category')
data["combined_shot_type"] = data["combined_shot_type"].astype('category')
data["season"] = data["season"].astype('category')
data["shot_type"] = data["shot_type"].astype('category')

# encode to transform non-numerical labels to numerical data
data["action_type"] = encoder.fit_transform(data["action_type"])
data["combined_shot_type"] = encoder.fit_transform(data["combined_shot_type"])
data["season"] = encoder.fit_transform(data["season"])
data["shot_type"] = encoder.fit_transform(data["shot_type"])

# get training and test data
train = data[data["shot_made_flag"].notnull()]
test = data[data["shot_made_flag"].isnull()]

# create random forest classifier
forest_classifier = RandomForestClassifier(n_estimators=500, max_depth=5000)

# train and test using top three features
train = train[['shot_distance', 'action_type', 'combined_shot_type', 'shot_made_flag']]
test = test[['shot_distance', 'action_type', 'combined_shot_type', 'shot_id']]

test_drop = test.drop('shot_id', 1)

drop_flag = train.drop('shot_made_flag', 1)
shot_made = train.shot_made_flag

forest_classifier.fit(drop_flag, shot_made)
result = forest_classifier.predict_proba(test_drop)

# most important features from sklearn documentation library
most_important = forest_classifier.feature_importances_
std = np.std([tree.feature_importances_ for tree in forest_classifier.estimators_])
indices = np.argsort(most_important)[::-1]

# Print the feature ranking
print("Top features:")
for f in range(3):
    print("feature %d" % (indices[f]))

# submission file to check accuracy on Kaggle
submission_file = pd.DataFrame({'shot_id': test.shot_id, 'shot_made_flag': result[:, 1]})
submission_file.sort_values('shot_id',  inplace=True)
submission_file[['shot_id', 'shot_made_flag']].to_csv('my_submission.csv', index=False)
