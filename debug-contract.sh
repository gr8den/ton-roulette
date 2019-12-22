nodemon -w contract.fc -w debug-contract.fif -x /bin/bash -c "func-build contract || exit 1 ; fift-run debug-contract.fif"
