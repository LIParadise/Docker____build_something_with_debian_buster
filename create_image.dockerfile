socker run -it -d                                                                         \
    --name DAC17                                                                          \
    -p 2224:22                                                                            \
    --workdir ~liparadise                                                                 \
    --mount type=bind,source="$(pwd -P)/ABC_async_DAC17",target=/home/liparadise/DAC17    \
    async:debian_buster_with_ssh
