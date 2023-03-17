group "jar" {
  targets = [
            "spring-builder",
            "petclinic-builder"
            ]
}

group "tools" {
  targets = [
            "tools-alpaquita",
            "tools-official",
            "tools-semeru",
            "tools-temurin",
            "tools-python"
            ]
}


group "alpaquita" {
  targets = [
            "petclinic-alpaquita",
            "petclinic-benchmark-alpaquita",
            ]
}

group "official" {
  targets = [
            "petclinic-official",
            "petclinic-benchmark-official",
            ]
}

group "semeru" {
  targets = [
            "petclinic-semeru",
            "petclinic-benchmark-semeru",
            ]
}

group "temurin" {
  targets = [
            "petclinic-temurin",
            "petclinic-benchmark-temurin",
            ]
}

target "spring-builder" {
  dockerfile = "Dockerfile.spring-builder"
  tags = ["spring-builder:v1"]
}

target "petclinic-builder" {
  dockerfile = "Dockerfile.petclinic-builder"
  tags = ["petclinic-builder:v1"]
  contexts = {
        spring-builder = "target:spring-builder"
  }
}

target "tools-alpaquita" {
  dockerfile = "Dockerfile.tools-alpine"
  tags = ["tools-alpaquita:v1"]
  contexts = {
        dist-base = "docker-image://bellsoft/liberica-runtime-container:jdk-17-stream-musl"
  }
}

target "tools-official" {
  dockerfile = "Dockerfile.tools-debian"
  tags = ["tools-official:v1"]
  contexts = {
        dist-base = "docker-image://openjdk:17-slim-buster"
  }
}

target "tools-semeru" {
  dockerfile = "Dockerfile.tools-centos"
  tags = ["tools-semeru:v1"]
  contexts = {
        dist-base = "docker-image://ibm-semeru-runtimes:open-17-jre-centos7"
  }
}

target "tools-temurin" {
  dockerfile = "Dockerfile.tools-debian"
  tags = ["tools-temurin:v1"]
  contexts = {
        dist-base = "docker-image://eclipse-temurin:17.0.6_10-jre-jammy"
  }
}


target "tools-python" {
  dockerfile = "Dockerfile.tools-python"
  tags = ["tools-python:v1"]
  contexts = {
        dist-base = "docker-image://bellsoft/liberica-runtime-container:jdk-17-stream-musl"
  }
}



target "petclinic-alpaquita" {
  dockerfile = "Dockerfile.petclinic-alpaquita"
  tags = ["petclinic-alpaquita:v1"]
}

target "petclinic-benchmark-alpaquita" {
  dockerfile = "Dockerfile.petclinic-benchmark"
  tags = ["petclinic-benchmark-alpaquita:v1"]
  contexts = {
        tools-base = "target:tools-alpaquita"
  }
}

target "petclinic-official" {
  dockerfile = "Dockerfile.petclinic-official"
  tags = ["petclinic-official:v1"]
}

target "petclinic-benchmark-official" {
  dockerfile = "Dockerfile.petclinic-benchmark"
  tags = ["petclinic-benchmark-official:v1"]
  contexts = {
        tools-base = "target:tools-official"
  }
}

target "petclinic-semeru" {
  dockerfile = "Dockerfile.petclinic-semeru"
  tags = ["petclinic-semeru:v1"]
}

target "petclinic-benchmark-semeru" {
  dockerfile = "Dockerfile.petclinic-benchmark"
  tags = ["petclinic-benchmark-semeru:v1"]
  contexts = {
        tools-base = "target:tools-semeru"
  }
}


target "petclinic-temurin" {
  dockerfile = "Dockerfile.petclinic-temurin"
  tags = ["petclinic-temurin:v1"]
}

target "petclinic-benchmark-temurin" {
  dockerfile = "Dockerfile.petclinic-benchmark"
  tags = ["petclinic-benchmark-temurin:v1"]
  contexts = {
        tools-base = "target:tools-temurin"
  }
}
