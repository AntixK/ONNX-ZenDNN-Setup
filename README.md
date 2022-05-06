ONNX-ZenDNN-Setup


## Getting Started
- Download the following ZenDNN files (note the versions)
    - [PT_v1.9.0_ZenDNN_v3.2_Python_v3.9.zip](https://developer.amd.com/zendnn/#download)
    - [aocc-compiler-3.2.0.tar](https://developer.amd.com/amd-aocc/#downloads)
    - [aocl-blis-linux-aocc-3.1.0.tar.gz](https://developer.amd.com/amd-aocl/blas-library/)
- Build docker container
```
docker-compose build zendnn
docker-compose up zendnn
docker-compose run zendnn
```
- Once inside the container, set up the environment variables.
```
source lib/zendnn_env_setup.sh
```
This will automatically create a conda environment called `zendnn` with pytorch installed. You may have to restart the container after this step.
- To create additional conda environments,
```
conda create --name <env_name> --file requirements.txt -y
```

## Tuning ZenDNN Variables
- Set batch size to be a multiple of the number of cores.

## FAQs
- What is jemalloc?
- What is AOCC?
- What is AOCL?
- What is numactl?

