#!/usr/bin/env sh
if socker ps | grep ASYNC17; then
    socker attach --detach-keys="ctrl-^" ASYNC17
else
    socker run -it --rm                                                                                   \
        --name ASYNC17                                                                                    \
        --user "$(id -u)":"$(id -g)"                                                                      \
        --mount type=bind,source="$(pwd -P)/../ABC_async_ASYNC17",target="$(pwd -P)/../ABC_async_ASYNC17" \
        --detach-keys="ctrl-^"                                                                            \
        async:debian_buster
fi
