# buf-registry
Buf Registry for k8s.io &amp; protoc-gen-swagger

## K8s.io
Updates to the source repository [API](https://github.com/kubernetes/api) & [apimachinery](https://github.com/kubernetes/apimachinery) are automatically synced on a periodic basis, and each BSR commit is tagged with corresponding Git commits.

To depend on a specific Git commit, you can use it as your reference in your dependencies:

```yaml
deps:
  - buf.build/ealsocket/k8s:<GIT_COMMIT_TAG>
```

## Protoc-gen-swagger

Updates to the [source repository](https://github.com/grpc-ecosystem/grpc-gateway) are automatically synced on a periodic basis, and each BSR commit is tagged with corresponding Git commits.

To depend on a specific Git commit, you can use it as your reference in your dependencies:

```yaml
deps:
  - buf.build/ealsocket/protoc-gen-swagger:<GIT_COMMIT_TAG>
```
