# Java Advanced Container Tests (JACTation)

# Usage

1. Each script has two variants: without extension for Mac/Linux and `.bat` for Windows.
1. [Install](https://docs.docker.com/build/install-buildx/) `docker buildx` v0.8 or later.
2. Run `create_builder` just once.
3. To run the benchmark against Spring Petclinic, run `bake`.
4. To run the benchmark against your custom app, put it inside 'target/app.jar' and run `bake custom`.
    - You must change the first line in the `benchmark.sh`. Put here any public resource-heavy URL from your app.

# Results

1. Everything is in the `logs` directory.
2. We will test your app (or Petclinic) running on the following:
    - OpenJDK official Docker image (codename "official")
    - BellSoft Alpaquita Linux Docker image (codename "alpaquita")
3. The most important result is a barplot `median.png`. It's a plot of median memory usage per base image.
4. Also, you can check the histogram `frequency.png", which represents how long the app holds each RAM consumption value.
5. We use `alpaquita-log` and `official-log` as a source for all graphs.
6. We use IQR (Inter Quartile Range method) to filter out outliers from the source data.

# Contacts

For everything serious (like a question that your life depends on): [oleg@bell-sw.com](mailto:oleg@bell-sw.com)
For a casual chat, please direct message me on Twitter: [@olegonsoftware](https://twitter.com/olegonsoftware).