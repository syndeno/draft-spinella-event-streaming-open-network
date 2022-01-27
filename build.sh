make clean
git reset --hard
git pull
git tag -a draft-spinella-event-streaming-open-network-01
make fix-lint
make
make publish
