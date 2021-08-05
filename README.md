# Spark on Docker
> AWS EC2 환경에서 노트북을 통해 S3 로부터 데이터를 읽고 쓸 수 있는 스파크 도커 이미지를 생성합니다

## 이미지 변경내역
* v1.0 : Spark 3.0.1 환경 적용 (deprecated)
* v1.1 : Spark 3.1.x 환경 적용 (data-engineer-all-spark-notebook:1.0)

## How to run images
```bash
$ docker-compose -f docker-compose.yml up -d
```

## How to build images
```bash
$ git clone git@github.com:psyoblade/all-spark-notebook.git
$ docker build -t psyoblade/all-spark-notebook .
```

## References
* [Jupyter/Base-Notebook](https://hub.docker.com/r/jupyter/base-notebook/dockerfile)
  * [jitsejan/Dockerfile](https://gist.github.com/jitsejan/f3991e5be9495e17aedc16b6512bd209)
* [Integrating PySpark Notebook w/ S3](https://www.jitsejan.com/integrating-pyspark-notebook-with-s3.html)

