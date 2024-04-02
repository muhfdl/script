#!/bin/bash

total_namespaces_with_consul=0

for i in $(oc get projects --no-headers | awk '{print $1}' | egrep -iv 'kube|openshift|default'); do
    consul_found=false

    for z in $(oc get deployment -n $i --no-headers | awk '{print $1}'); do
        if oc get deployment $z -n $i -o=jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{end}' | grep -q "grafana"; then
            consul_found=true
            ((total_namespaces_with_consul++))
            break
        fi
    done

    if [ "$consul_found" = true ]; then
        echo "Namespace with 'consul' container: $i"
	echo "With Deployment: $z"
	echo ""
    fi
done

echo ""
echo "--------------------------------------------"
echo "Total namespaces with 'consul' container: $total_namespaces_with_consul"
echo "--------------------------------------------"
