{{ define "dynamic-netpol" }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-deny-all
  namespace: {{ .namespace }}
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress: []
  egress: []
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-apisix-cluster-ingress
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_ingress }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  - to: 
    - podSelector:
        matchLabels:
          {{ .redis_cluster_ecdf }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-apisix-cluster-ingress-cp
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_ingress_cp }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  - to: 
    - podSelector:
        matchLabels:
          {{ .redis_cluster_ecdf }}
  - to:
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-apisix-cluster-egress
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_egress }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-apisix-cluster-egress-cp
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_egress_cp }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress_cp }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress_cp }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-apisix-dashboard-ingress
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .ingress_dashboard }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    {{- range $index, $value := .po_haproxy }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    {{- range $index, $value := .gkeapp }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    ports:
      - protocol: TCP
        port: 9000
      - protocol: TCP
        port: 9001
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-apisix-dashboard-egress
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .egress_dashboard }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    {{- range $index, $value := .po_haproxy }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    {{- range $index, $value := .gkeapp }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    ports:
      - protocol: TCP
        port: 9000
      - protocol: TCP
        port: 9001
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-etcd-cluster
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .etcd }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress_cp }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .ingress_dashboard }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .egress_dashboard }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .etcd }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-rabbit-cluster
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .rabbit_cluster }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster }}
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-rabbit-cluster-v2
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .rabbit_cluster_v2 }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster_v2 }}
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster_v2 }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-redis-cluster-cache
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .redis_cluster_cache }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - from: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_cache }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_cache }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-redis-cluster-ecdf
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .redis_cluster_ecdf }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_ecdf }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_ecdf }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-system
  namespace: {{ .namespace }}
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: TCP
      port: 443
    - protocol: TCP
      port: 80
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .nexus }}
    ports:
      - protocol: TCP
        port: 8081
      - protocol: TCP
        port: 8086
  - to: 
    - namespaceSelector: 
        matchLabels:
          kubernetes.io/metadata.name: "kube-system"
    ports:
      - protocol: TCP
        port: 53
      - protocol: UDP
        port: 53
  - to: 
    - namespaceSelector: 
        matchLabels:
          kubernetes.io/metadata.name: "istio-system"
      podSelector: 
        matchLabels:
          app: "istiod"
    ports:
      - protocol: TCP
        port: 15012
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-workload-domain
  namespace: {{ .namespace }}
spec:
  podSelector: 
    matchLabels: 
      role-domain: "true"
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - to: 
    {{- range $index, $value := .postgres_log }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .mongo }}
    ports:
      - protocol: TCP
        port: 27017
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .postgres_read }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .pgpool }}
    ports:
      - protocol: TCP
        port: 9999
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .postgres_write }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .h2db }}
    ports:
      - protocol: TCP
        port: 9042
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .artemis }}
    ports:
      - protocol: TCP
        port: 9081
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .vkyc }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .mysql }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .iwpdb }}
    ports:
      - protocol: TCP
        port: 3306
  - to:
    - ipBlock:
        cidr: {{ printf "%s/32" .app_haproxy }}
  - to:
    - ipBlock:
        cidr: {{ printf "%s/32" .kafka_node1 }}
    ports:
      - protocol: TCP
        port: 9092
  - to:
    - ipBlock:
        cidr: {{ printf "%s/32" .kafka_node2 }}
    ports:
      - protocol: TCP
        port: 9092
  - to:
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster_v2 }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_cache }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress_cp }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-workload-legacy
  namespace: {{ .namespace }}
spec:
  podSelector: 
    matchLabels: 
      role-legacy: "true"
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - to: 
    {{- range $index, $value := .postgres_log }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .mongo }}
    ports:
      - protocol: TCP
        port: 27017
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .postgres_read }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .pgpool }}
    ports:
      - protocol: TCP
        port: 9999
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .postgres_write }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .h2db }}
    ports:
      - protocol: TCP
        port: 9042
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .artemis }}
    ports:
      - protocol: TCP
        port: 9081
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .vkyc }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .mysql }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .iwpdb }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster_v2 }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_cache }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress_cp }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-allow-workload-orchestration
  namespace: {{ .namespace }}
spec:
  podSelector: 
    matchLabels: 
      role-orchestration: "true"
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - from: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress }}
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - to: 
    {{- range $index, $value := .postgres_log }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .mongo }}
    ports:
      - protocol: TCP
        port: 27017
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .postgres_read }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .pgpool }}
    ports:
      - protocol: TCP
        port: 9999
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .postgres_write }}
    ports:
      - protocol: TCP
        port: 5432
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .h2db }}
    ports:
      - protocol: TCP
        port: 9042
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .artemis }}
    ports:
      - protocol: TCP
        port: 9081
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .vkyc }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .mysql }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .iwpdb }}
    ports:
      - protocol: TCP
        port: 3306
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .rabbit_cluster_v2 }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .redis_cluster_cache }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_ingress_cp }}
  - to: 
    - podSelector: 
        matchLabels:
          {{ .apisix_egress_cp }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-common-apisix-ingress
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_ingress }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    {{- range $index, $value := .pi_haproxy }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    {{- range $index, $value := .po_haproxy }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    {{- range $index, $value := .pe_haproxy }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    {{- range $index, $value := .gkeapp }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    {{- range $index, $value := .gkeint }}
    - ipBlock: 
        cidr: {{ printf "%s/32" $value }}
    {{- end }}
    ports:
      - protocol: TCP
        port: 9080
      - protocol: TCP
        port: 9443
  egress:
  - to: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  - to: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-common-apisix-ingress-cp
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_ingress_cp }}
  policyTypes:
  - Ingress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          app: "authentication"
  - from: 
    - podSelector: 
        matchLabels:
          app: "authenticationfuture"
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-common-apisix-egress
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_egress }}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          role-domain: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-legacy: "true"
  - from: 
    - podSelector: 
        matchLabels:
          role-orchestration: "true"
  egress:
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .app_haproxy }}
    ports:
      - protocol: TCP
        port: 9444
      - protocol: TCP
        port: 6868
      - protocol: TCP
        port: 9443
      - protocol: TCP
        port: 1600
      - protocol: TCP
        port: 9445
      - protocol: TCP
        port: 9446
      - protocol: TCP
        port: 8443
      - protocol: TCP
        port: 8447
      - protocol: TCP
        port: 2307
      - protocol: TCP
        port: 6838
      - protocol: TCP
        port: 9092 
  - to: 
    - ipBlock: 
        cidr: {{ printf "%s/32" .vault }}
    ports:
      - protocol: TCP
        port: 8200
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: netpol-group-common-apisix-egress-cp
  namespace: {{ .namespace }}
spec:
  podSelector:
    matchLabels:
      {{ .apisix_egress_cp }}
  policyTypes:
  - Ingress
  ingress:
  - from: 
    - podSelector: 
        matchLabels:
          app: "oes"
{{- end }}