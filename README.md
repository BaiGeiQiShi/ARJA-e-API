# ARJA-e


However, to successfully run the experiments, we have made two modifications:

①We implemented a test filter on the original ARJA-e to ensure that ARJA-e only checks the same tests as the `catena4j test`

②We fixed a [bug](https://github.com/yyxhdy/arja/blob/arja-e/src/us/msu/cse/repair/core/util/Helper.java) (line 389-390) that ignores the case where the package name does not contain `.`, which will cause `index1` and `index2` to become -1.

## 1. Environment
- Ubuntu 20.04
- docker
- JDK 1.8
- [Defects4J 2.0](https://github.com/rjust/defects4j)
- [CatenaD4J](https://github.com/universetraveller/CatenaD4J.git)

## 2. Experiment Setup
The original timeout used by ARJA-e was 1 hour, with a maximum number of generations of 50. For the sake of fairness, we multiply both parameters by 5.  
- Timeout: 5h
- Maximum number of generations: 250

## 3. Excluded Bugs
#### All 41 Closure bugs and All 2 Mockito bugs
> (1) As stated in ARJA-e's paper, ARJA-e ignored Closure because it uses the customized testing format instead of the standard JUnit tests.  
> (2) The implementation of ARJA-e is based on Defects4J (v1.0.1), so ARJA-e cannot work correctly on Mockito.


## 4. Installation
#### 4.1 Create the docker image
Use the `Dockerfile` in `./Docker` to create the docker image.
```shell
docker build -t arja-e-env .
```

This docker image includes **Defects4J**, **CatenaD4J**, and **JDK 1.8**.

#### 4.2 Create the container

```shell
docker run -it --name=arja-e arja-e-env /bin/bash
```

#### 4.3 Clone the ARJA-e repository

At the root of this container, we clone the ARJA-e repository.

```shell
cd /
git clone https://github.com/BaiGeiQiShi/ARJA-e-API.git
```

#### 4.4 Setup
Create the working directory.
```shell
cd ./ARJA-e-API
mkdir 105_bugs_with_src
```

## 5. Quickly Test
It takes about 2 hours to finish the repair.
```
# Generating the patches
cd 105_bugs_with_src
catena4j checkout -p Chart -v 18b2 -w ./Chart18b2
cd ..
./start.sh
```
After finishing the repair, the generated patches are in `./105_bugs_with_src/Chart18b2/arja-e/`.

## 6. Experiment Reproduction
You should first checkout the 105 bugs in Catena4j and then repair these 105 bugs
```shell
./checkout_105.sh  #checkout 105 bugs
./start.sh  #repair 105 bugs
```
If ARJA-e can generate plausible patch(es), the plausible patch(es) are located in `./105_bugs_with_src/$BUG_PROJECT/arja-e/`. Otherwise, the `./105_bugs_with_src/$BUG_PROJECT/arja-e/` folder does not exist.


If you have any questions, you can go to the [ARJA-e](https://github.com/yyxhdy/arja/tree/arja-e) repository or create issues for more information.
