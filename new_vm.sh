eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
conda activate tpu 
git config --global user.email paw.kanarek@gmail.com
git config --global user.name "Pawel Kanarek"