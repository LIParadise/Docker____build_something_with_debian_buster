#!/usr/bin/env sh
if socker ps | grep DAC17; then
    socker attach --detach-keys="ctrl-^" DAC17
else
    socker run -it --rm                                                                               \
        --name DAC17                                                                                  \
        --user "$(id -u)":"$(id -g)"                                                                  \
        --mount type=bind,source="$(pwd -P)/../ABC_async_DAC17",target="$(pwd -P)/../ABC_async_DAC17" \
        --detach-keys="ctrl-^"                                                                        \
        async:debian_buster
fi
