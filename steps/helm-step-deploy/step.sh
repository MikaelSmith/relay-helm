#!/bin/sh

ni cluster config

NS=$(ni get -p {.namespace})
CLUSTER=$(ni get -p {.cluster.name})
KUBECONFIG=/workspace/"${CLUSTER}"/kubeconfig

CHART_NAME=$(ni get -p {.name})
CHART_PATH=$(ni get -p {.chart})

GIT=$(ni get -p {.git})
if [ -n "${GIT}" ]; then
    ni git clone
    CHART_PATH=/workspace/$(ni get -p {.git.name})/${CHART_PATH}
fi

ni file -p values -f values-overrides.yaml -o yaml

helm upgrade ${CHART_NAME} ${CHART_PATH} --install \
    --namespace ${NS} --kubeconfig ${KUBECONFIG} \
    -f values-overrides.yaml
