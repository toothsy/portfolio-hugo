+++
date = '2025-11-08T18:00:00+05:30'
draft = false 
title = 'Getting started with OIDC and Dex with kind'
pin = true
tags = ["dex","oidc","OAuth2", "kong", "postgres", "k8s", "kubernetes", "docker", "helm", "helmfile", "kind"]
+++

- this article covers how you can setup a local cluster in with kind (not rudely), the next one would cover GitHub Oauth process.

## OIDC?(Intro)

- Open IDentity Connect is a AUTHENTICATION protocol that is built on top of Oauth2.
- Oauth2 is primarily a AUTHORIZATION protocol.(The capitalization is more a reminder to myself than the reader)
- OIDC is the reason why you get that shiny "Sign in with Google" or Microsoft, or Facebook button in different applications you see.

## Why do I need dex?

- Imagine this you have built your cool application and it has a standard login page that accepts email and password. But its 2025 now and you feel you need to ease the process by having a google sign in button.
- So you set out on a journey to implement google Oauth2  by going to google console, registering your app, getting your client id and secret and start using it for your app.
- Luck is on your side and your application is growing popular, now you want to on onboard facebook users. But oh no!! your application is hard coded with google endpoints for authentication, so you pile up some technical debt and hardcode your facebook endpoint.
- As days pass you realise you maybe need Microsoft Oauth as well, and you finally realise maybe it was a bad idea to hard code facebook Oauth2, as your authentication endpoints keep increasing and it becomes a hassle to maintain dev,stage, and prod credentials of your application.

## What is Dex?

- [dex](https://dexidp.io/) is an open source project that aims to simplify authentication for applications.
- Imagine this, you only had to deal with OIDC once (Ideally never would be nice, but its never ideal is it) and someone else took care of every other OIDC providers.
- Dex would talk to other OIDC providers and your application remains agnostic about the different providers, your application only knows about Dex and the tokens Dex gives.
- Dex comes with a local installation too, which means that the source of truth for authentication is its own database, you can interact with this service via grpc calls.
- You can configure the storage options as described [here](https://dexidp.io/docs/configuration/storage/)
- Oauth2 is the only protocol your application needs to support, the upstream connector can be anything, LDAP,SAML,OAUTH,here's the exhaustive [list](https://dexidp.io/docs/connectors/).
Connector is basically the place where Dex will go to for getting the user credentials verified.
So your app only has to implement OIDC process for Dex, Dex will take care of the rest.

## But what is OIDC, technically?

- before i summarise briefly how an OIDC flow looks like, lets get on the same page about terminology for clarity.
  - your app will be called relying party, think of it like you are relying on GitHub.
  - GitHub will be called Identity provider.
  - your users would be called plain old users.
  - token here refers to a JSON Web Token or JWT token.(think of it like a immutable source of truth that gets passed around)
  - client-id and client-secret are things you would get from the identity provider you have registered against.
  - redirect_url, this is the place identity provider will tell the user to go after they have successfully logged in with their creds.
  - consent screen, this refers to the time when users login for the first time and identity provider wants to let the user know what the relying party wants to access.
  - scope, this defines what relying party will access.for example name, email etc.
- Alright then lets get on already:

  1. user clicks on "Sign in with GitHub", this triggers a call to GitHub with your client-id, redirect_url, scope.
  2. If the redirect_url matches what

## Local connector

- local connector means that Dex will maintain its own database.
- you could get down and read all the deployment files to understand what the fuss is about for kubernetes or you can just run a script that will do these things for you it can be found here [ADD GITHUB LINK](asdasdasdasdasd)
- the process to setup connector mostly remains the same regardless of which Oauth2 provider you choose to go with.
- you would get client-id and client-secret, while choosing redirect url of your own liking and scopes that you might need.

### Getting the tools

- you would need these cli tools
  - [docker(where your kubernetes cluster would reside)](https://docs.docker.com/engine/install/)
  - [kind (Kubernetes IN Docker)](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
  - [kubectl (Primarily how would interact with your cluster)](https://kubernetes.io/docs/tasks/tools/)
  - [helm (think its like package manager for kubernetes)](https://helm.sh/docs/intro/install/)
  - [helmfile(to handle different environments)](https://github.com/helmfile/helmfile?tab=readme-ov-file#installation)
  - [helm-diff(for helmfile to know what changed)](https://github.com/databus23/helm-diff?tab=readme-ov-file#install)
  
### Architecture

- We will deploy our Dex instance behind a Kong gateway in a kind cluster, reason being that Dex is built for production, so you'd follow similar patterns when you use it in your actual project.
- once you understand how to deploy locally in kind, production is merely some endpoint changes away.

- ```
      ┌──────────────────────────────────────────────────────────────────────┐
      │ Docker                                                               │
      │                           ┌─────────────────────────────────────┐    │
      │                           │worker plane                         │    │
      │                           │ ┌────┐      ┌────┐   ┌─────────┐    │    │
      │    ┌──────────────┐       │ │KONG│      │DEX │   │POSTGRES │    │    │
      │    │ control-plane│       │ └────┘      └────┘   └─────────┘    │    │
      │    │  KinD        │       │                                     │    │
      │    └──────────────┘       └─────────────────────────────────────┘    │
      │                                                                      │
      └──────────────────────────────────────────────────────────────────────┘
      ```
- we will also use helmfile with [ADD_gotmpl_LINK]() format to deploy our application, for context this is like killing a mosquito with a nuke, because helmfile shines when you have a complex setup for your application, unlike our application, But we will still use this because its fun to learn complex things easily.

### Configurations

#### cluster config

- following helmfile describes the list of all the things kubernetes needs to install for our application.

``` yaml

environments:
  default:
    values:
      - values.yaml
---
repositories:
  - name: kong
    url: https://charts.konghq.com

releases:
  - name: kong
    namespace: kong
    createNamespace: true
    chart: kong/kong
    version: ~2.51.0  # or latest stable, check via `helm search repo kong/kong`
    set:
      - name: ingressControllerCRDs
        value: false
    values:
      - kong-values.yaml

  - name: postgres
    namespace: postgres
    labels:
      app: postgres
      tier: core
    version: 16.0.3
    chart: oci://registry-1.docker.io/bitnamicharts/postgresql
    set:
    - name: nameOverride
      value: postgres
    - name: auth.database
      value: ps_db
    - name: auth.username
      value: {{ .Values.postgres.user }}
    - name: auth.password
      value: {{ .Values.postgres.pass }}
    - name: image.repository
      value: bitnamilegacy/postgresql

  - name: dex
    namespace: auth
    createNamespace: true
    chart: ./charts/dex
    values:
      - dex-values.yaml

  - name: frontend
    namespace: frontend
    createNamespace: true
    chart: ./charts/frontend
    values:
      - frontend-values.yaml
  ```

#### dex config

```yaml

# Dex chart values - matching charts/dex/values.yaml structure

global:
  # Database configuration for Dex
  database:
    host: postgres.postgres.svc.cluster.local
    port: 5432
    username: dex
    ssl:
      mode: disable
    createDatabase: true

  # Database secret for password
  databaseSecret:
    name: postgres
    key: password

  # Ingress configuration
  ingress:
    ingressClassName: kong
    host: localhost
    # Controller URL is where Dex will be accessible from outside
    controllerUrl: "http://dex-dex-server-http.auth.svc.cluster.local:5556"
    annotations: {}

# Dex database name
database:
  database: ps_db

# HTTP port for Dex service
httpPort: 5556

# GRPC port for internal communication
internalGrpcPort: 8082

# Enable password database (local authentication)
enablePasswordDb: true

# OAuth2 configuration
oauth2:
  passwordConnector:
    enable: true
    value: local
  responseTypes: ["code"]

# Static passwords for local authentication
staticPasswords:
  - email: "admin-dex@example.com"
    hash: "JDJhJDEyJEwycXBiTjRjNThHTHd1YXo4Wnhoa2UvSzF1cHMvWnVyRnhvNU9iRnAxQWhILmllNGdUNXZD" # bcrypt hash of "password"
    username: "admin"
    userID: "1"

# Additional static clients for OAuth2
additionalStaticClients:
  - id: local-client
    public: true
    name: "Local Development Client"
    redirectURIs:
      - "http://localhost:8000/api/auth/callback"

  - id: backend-client
    public: false
    secret: "backend-secret-change-in-production"
    name: "Backend Auth Service"
    redirectURIs:
      - "http://localhost:8000/api/auth/callback"

# Resource limits
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "250m"
    memory: "256Mi"

# Liveness probe configuration
livenessProbe:
  enabled: true
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 3
  successThreshold: 1
  failureThreshold: 5

# Replica count
replicaCount: 1

# Environment variables for dex container
dex:
  env:
    - name: PASSWORD_ENV_VAR
      valueFrom:
        secretKeyRef:
          name: postgres
          key: password
```

![dex-local-login](../../assets/dexLogin.gif)

### explanation
