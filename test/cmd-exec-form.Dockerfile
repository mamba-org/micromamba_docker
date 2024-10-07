ARG BASE_IMAGE=micromamba:test-debian12-slim

FROM --platform=$TARGETPLATFORM $BASE_IMAGE
RUN micromamba install -y -n base -c conda-forge \
       python=3.9.1  && \
    micromamba clean --all --yes

CMD ["/opt/conda/bin/python", "-c", "print('hello')"]
