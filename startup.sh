gcloud config list
gcloud config set project ${PROJECT}
gcloud config set account gke-admin@intrepid-league-397203.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file=./service-account.json
gcloud config list
gcloud container clusters get-credentials hipster-dev --region europe-west2 --project intrepid-league-397203
