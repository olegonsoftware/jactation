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