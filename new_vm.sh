eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
conda activate tpu 
git config --global user.email paw.kanarek@gmail.com
git config --global user.name "Pawel Kanarek"
# Fix for tpu xla
find / -name "libpython3.10.so.1.0" 2>/dev/null
export LD_LIBRARY_PATH=/home/raix/miniconda3/envs/tpu/lib:$LD_LIBRARY_PATH
