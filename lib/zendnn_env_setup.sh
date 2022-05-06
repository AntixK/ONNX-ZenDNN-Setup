export ZENDNN_LOG_OPTS=ALL:0
export OMP_NUM_THREADS=48
export OMP_WAIT_POLICY=ACTIVE
export OMP_PROC_BIND=FALSE
export OMP_DYNAMIC=FALSE
export ZENDNN_GIT_ROOT=/home/deps/pyzendnn/PT_v1.9.0_ZenDNN_v3.2_Python_v3.9_2021-12-03T10/ZenDNN
export ZENDNN_PARENT_FOLDER=/home/deps/pyzendnn/PT_v1.9.0_ZenDNN_v3.2_Python_v3.9_2021-12-03T10
export ZENDNN_AOCC_COMP_PATH=/home/deps/aocc-compiler-3.2.0
export ZENDNN_BLIS_PATH=/home/deps/amd-blis
export ZENDNN_PRIMITIVE_CACHE_CAPACITY=1024
export GOMP_CPU_AFFINITY=0-47
export ZENDNN_BLOCKED_FORMAT=1 # NCHWc8 format


export PATH=$ZENDNN_AOCC_COMP_PATH/bin:$PATH
export LD_LIBRARY_PATH=$ZENDNN_AOCC_COMP_PATH/lib:$ZENDNN_AOCC_COMP_PATH/lib32:$LD_LIBRARY_PATH

# Export PATH and LD_LIBRARY_PATH for ZenDNN
export PATH=$PATH:$ZENDNN_GIT_ROOT/_out/tests
export LD_LIBRARY_PATH=$ZENDNN_BLIS_PATH/lib/:$ZENDNN_BLIS_PATH/lib/lp64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$ZENDNN_GIT_ROOT/_out/lib/:$ZENDNN_GIT_ROOT/external/googletest/lib:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=$ZENDNN_BLIS_PATH/lib/lp64/:$LD_LIBRARY_PATH
echo "LD_LIBRARY_PATH: "$LD_LIBRARY_PATH

export LD_PRELOAD=$ZENDNN_AOCC_COMP_PATH/lib/libomp.so:$LD_PRELOAD

echo "Creating conda env"
conda init bash

conda create -n zendnn python=3.9 -y
conda activate zendnn

pip install -r requirements.txt
pip install /home/deps/pyzendnn/PT_v1.9.0_ZenDNN_v3.2_Python_v3.9_2021-12-03T10/torch-1.9.0a0+gitd69c22d-cp39-cp39-linux_x86_64.whl
pip install --no-dependencies torchvision==0.10.0
echo "To check the installed version of PT:"
python -c 'import torch as pt; print(pt.__version__)'
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Issue with Installing Pytorch"
    return
fi
