group "jar" {
  targets = [
            "spring-builder",
            "petclinic-builder"
            ]
}

group "tools" {
  targets = [
            "tools-python"
            ]
}

target "spring-builder" {
  dockerfile = "tools/Dockerfile.spring-builder"
  tags = ["spring-builder:v1"]
}

target "petclinic-builder" {
  dockerfile = "tools/Dockerfile.petclinic-builder"
  tags = ["petclinic-builder:v1"]
  contexts = {
        spring-builder = "target:spring-builder"
  }
}

target "tools-python" {
  dockerfile = "tools/Dockerfile.tools-python"
  tags = ["tools-python:v1"]
  contexts = {
        dist-base = "docker-image://bellsoft/liberica-runtime-container:jdk-11-stream-glibc"
  }
}