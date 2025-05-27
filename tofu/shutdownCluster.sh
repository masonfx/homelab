#!/bin/bash
# This script is used to shut down a Talos cluster.
# It will drain the control plane and worker nodes, and then shut them down.
# Usage: ./shutdownCluster.sh

kubectl cordon ctrl-01 ctrl-02 ctrl-03 work-01 work-03
kubectl drain ctrl-01 ctrl-02 ctrl-03 work-01 work-03 --ignore-daemonsets --delete-emptydir-data
talosctl shutdown work-01 work-03
talosctl shutdown ctrl-01 ctrl-02 ctrl-03
