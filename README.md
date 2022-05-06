ONNX-ZenDNN-Setup


## Getting Started
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
This will automatically create a conda environment called `zendnn` with pytorch installed.
- To create additional conda environments,
```
conda create --name <env_name> file requirements.txt
```

## Tuning ZenDNN Variables
- Set batch size to be a multiple of the number of cores.

## FAQs
- What is jemalloc?
- What is AOCC?
- What is AOCL?
- What is numactl?

