# root Dockerfile could be used to build contracts etc. but left empty
FROM alpine:3.19
CMD ["echo", "root container not intended for runtime"]
