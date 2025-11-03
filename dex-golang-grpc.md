# plan to write the article on dex and grpc

- have dex running in a namespace in local k8s behind a kong ingress in kind setup.
  - create a helmfile.gotmpl file that has dex as a release?
  - have kong in the release.
  - setup local kind cluster
  - deploy the dex in the said cluster.
- write a server that does the callback communication with dex
- deploy it behind kong
-  

