sudo yum install git -y
git clone https://github.com/omaik/kitten-store.git
cd kitten-store
sudo ops/scripts/migrate.sh
sudo ops/scripts/up.sh
