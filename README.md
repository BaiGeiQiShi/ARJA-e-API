# ARJA-e

## 1. Environment

- Ubuntu 20.04
- docker
- JDK 1.8
- [Defects4J 2.0](https://github.com/rjust/defects4j)
- [CatenaD4J](https://github.com/universetraveller/CatenaD4J.git)


## 2. Installation

#### 2.1 Create the docker image

```shell
docker build -t arja-e-env .
```

This docker image includes **Defects4J**, **CatenaD4J**, and **JDK 1.8**.

#### 2.2 Create the container

```shell
docker run -it --name=arja-e arja-e-env /bin/bash
```

#### 2.3 Clone the ARJA-e repository

At the root of this container, we clone the ARJA-e repository.

```shell
cd /
git clone https://github.com/BaiGeiQiShi/ARJA-e-API.git
```

#### 2.4 Setup
Create the working directory.
```shell
cd ./ARJA-e-API
mkdir 105_bugs_with_src
```

## 3. Test Installation
It takes about 2 hours to finish the repair.
```
# Generating the patches
cd 105_bugs_with_src
catena4j checkout -p Chart -v 18b2 -w ./Chart18b2
cd ..
./start.sh
```
After finishing the repair, the generated patches are in `./105_bugs_with_src/Chart18b2/arja-e/`.

## 4. Usage
You should first checkout the 105 bugs in Catena4j and then repair these 105 bugs
```shell
./checkout_105.sh  #checkout 105 bugs
./start.sh  #repair 105 bugs
```
If ARJA-e can generate plausible patch(es), the plausible patch(es) are located in `./105_bugs_with_src/$BUG_PROJECT/arja-e/`. Otherwise, the `./105_bugs_with_src/$BUG_PROJECT/arja-e/` folder does not exist.


If you have any questions, you can go to the [ARJA-e](https://github.com/yyxhdy/arja/tree/arja-e) repository or create issues for more information.
