
import pandas as pd
import numpy as np
from sklearn.utils import shuffle


path = r"C:\Users\lyra001\OneDrive - Wageningen University & Research\articles_project\matlab\EartH2Observe\ANN\csv_to_RF_final\z"

##### CHOOSING MODEL AND INDEX #####

# 'JULES'	'ORCHIDEE'	'HTESSEL'	'SURFEX'	'PCR'
MODELS = ['JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR']

Indices = ['Evap', 'Q', 'Qs', 'Qsb']


# MODEL = 'JULES'
for MODEL in MODELS:

    print(MODEL)

    for output_VAR in Indices:

        for j in range(1, 4):

            print(output_VAR)

            x = path + MODEL + "_" + output_VAR + ".csv"
            data = pd.read_csv(x)


            ##### SHUFFLING DATA AND DROPPING ROWS FOR TRAINING AND TESTING #####
            data2 = shuffle(data, random_state=j)
            data2 = data2.reset_index(drop=True)
            data3 = data2
            x = np.arange(int(7*len(data)/10), len(data))
            x2 = np.arange(0, int(7*len(data)/10))
            data2 = data2.drop(x, axis=0)
            data3 = data3.drop(x2, axis=0)

            # print(data2)

            data_all = data.drop(columns=output_VAR)
            target_all = data[output_VAR]
            data_train = data2.drop(columns=output_VAR)
            target_train = data2[output_VAR]
            data_test = data3.drop(columns=output_VAR)
            target_test = data3[output_VAR]


            ##### HYPERPARAMETERS RANDOM FOREST #####
            from sklearn.ensemble import RandomForestRegressor

            FI = []
            for i in range(1, 4):

                search_cv = RandomForestRegressor(n_estimators=200,
                                                  max_features=0.33,
                                                  n_jobs=2, random_state=i)
                cv_results = search_cv.fit(X=data_train, y=target_train)
                print(cv_results)

                ## All Data
                target_predict = search_cv.predict(data_all)
                error = search_cv.score(X=data_all, y=target_all) # R2
                print(f"On average, our random forest regressor makes an overall R2 of {error:.4f} k$")
                data["predict" + str(i)] = target_predict

                ## Train Data
                target_predict = search_cv.predict(data_train)
                error = search_cv.score(X=data_train, y=target_train) # R2
                print(f"On average, our random forest regressor makes a training R2 of {error:.4f} k$")
                data2["predict" + str(i)] = target_predict

                ## Test Data
                target_predict = search_cv.predict(data_test)
                error = search_cv.score(X=data_test, y=target_test) # R2
                print(f"On average, our random forest regressor makes a testing R2 of {error:.4f} k$")
                data3["predict" + str(i)] = target_predict

                ##### FEATURE IMPORTANCE
                MDI = search_cv.feature_importances_
                FI.append(MDI)


            x2 = pd.DataFrame(FI)
            x2.to_csv('./OUTPUT_FILES_final/FI_' + MODEL + '_' + output_VAR + '_' + str(j) + '.csv', sep=',')

            huffs = data[[output_VAR, "predict1", "predict2", "predict3"]]
            huffs.to_csv('./OUTPUT_FILES_final/z_result_all_' + MODEL + '_' + output_VAR + '_' + str(j) + '.csv', sep=',')
            huffs = data2[[output_VAR, "predict1", "predict2", "predict3"]]
            huffs.to_csv('./OUTPUT_FILES_final/z_result_train_' + MODEL + '_' + output_VAR + '_' + str(j) + '.csv', sep=',')
            huffs = data3[[output_VAR, "predict1", "predict2", "predict3"]]
            huffs.to_csv('./OUTPUT_FILES_final/z_result_test_' + MODEL + '_' + output_VAR + '_' + str(j) + '.csv', sep=',')
