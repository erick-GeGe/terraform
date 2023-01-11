apt-get update
apt-get install -yq build-essential python3-pip git rsync
echo 'cloning repo'
git clone https://github.com/erick-GeGe/test-autoscaling.git
cd test-autoscaling
pip install flask
echo 'starting'
python3 main.py