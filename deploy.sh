echo "lets deploy"

make get
make all

mv dist/* $CIRCLE_ARTIFACTS/
