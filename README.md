# SimFix

## 1. Environment

- Ubuntu 20.04
- docker
- JDK 1.8
- [Defects4J 2.0](https://github.com/rjust/defects4j)
- [CatenaD4J](https://github.com/universetraveller/CatenaD4J.git)


## 2. Installation

#### 2.1 Create the docker image

```shell
docker build -t simfix-env .
```

This docker image includes **Defects4J**, **CatenaD4J**, and **JDK 1.8**.

#### 2.2 Create the container

```shell
docker run -it --name=simfix simfix-env /bin/bash
```

#### 2.3 Clone the SimFix repository

At the root of this container, we clone the SimFix repository.

```shell
cd /
git clone https://github.com/BaiGeiQiShi/SimFixAPI.git
```

#### 2.4 Install dependencies and Setup
After testing, we found that using **pip** in the Docker file might cause image creation to fail, so configuration inside the container is required.
```shell
cd ./SimFixAPI
./setup.sh
```

## 3. Test Installation
It takes about 4-5 hours to finish the repair.
```
# Generating the patches
cd 105_bugs_with_src
catena4j checkout -p Chart -v 18b2 -w ./Chat18b2
cd ..
./start_simfix.sh
```
After finishing the repair, the results are in folders: `log` and `patch`.

* `log` : debug output, including buggy statements already tried, patches and reference code snippet for correct patch generation.

* `patch` : a single source file repaired by *SimFix* that can pass the test suite. In the source file, you can find the patch, which is formatted as (example of Chart_1):

  ```java
  // start of generated patch
  int index=this.plot.getIndexOf(this);
  CategoryDataset dataset=this.plot.getDataset(index);
  if(dataset==null){
  return result;
  }
  // end of generated patch
  /* start of original code
          int index = this.plot.getIndexOf(this);
          CategoryDataset dataset = this.plot.getDataset(index);
          if (dataset != null) {
              return result;
          }
   end of original code*/
  ```

## 4. Usage
You should first checkout the 105 bugs in Catena4j and then repair these 105 bugs
```shell
./checkout_105.sh  #checkout 105 bugs
./start_simfix.sh  #repair 105 bugs
```
After finishing the repair, you can also check the results in folders: `log` and `patch`.


If you have any questions, you can go to the [SimFix](https://github.com/xgdsmileboy/SimFix.git) repository or create issues for more information.
