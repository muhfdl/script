#!/bin/bash

total_namespaces_without_consul=0

exec > with.txt 2>&1

for i in $(oc get projects --no-headers | awk '{print $1}' | egrep -iv 'kube|openshift|default'); do
    consul_found=false

    for z in $(oc get deployment -n $i --no-headers | awk '{print $1}'); do
        if oc get deployment $z -n $i -o=jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{end}' | grep -q "grafana"; then
            consul_found=true
            break
        fi
    done

    if [ "$consul_found" = false ]; then
        ((total_namespaces_without_consul++))
        echo "Namespace without 'consul' container: "
	echo "$i"
    fi
done

echo ""
echo "-----------------------------------------------"
echo "Total namespaces without 'consul' container: $total_namespaces_without_consul"
echo "-----------------------------------------------"
