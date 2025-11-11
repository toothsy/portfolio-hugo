+++
date = '2025-11-08T18:00:00+05:30'
draft = true
title = 'Getting started with OIDC and dex with kind'
pin = true
tags = ["dex","oidc","OAuth2", kong", "postgres", "k8s", "kubernetes", "docker", "helm", "helmfile", "kind"]
+++

- this article covers how you can setup a local cluster in with kind (not rudely), the next one would cover GitHub Oauth process.

## OIDC?(Intro)

- Open IDentity Connect is a AUTHENTICATION protocol that is built on top of Oauth2.
- Oauth2 is primarily a AUTHORIZATION protocol.(The capitalization is more a reminder to myself than the reader)
- OIDC is the reason why you get that shiny "Sign in with Google" or Microsoft, or Facebook button in different apps you see.

## Why do I need dex?

- Imagine this you have built your cool application and it has a standard login page that accepts email and password. But its 2025 now and you feel you need to ease the process by having a google sign in button.
- So you set out on a journey to implement google Oauth2  by going to google console, registering your app, getting your client id and secret and start using it for your app.
- Luck is on your side and your application is growing popular, now you want to on onboard facebook users. But oh no!! your application is hard coded with google endpoints for authentication, so you pile up some technical debt and hardcode your facebook endpoint.
- As days pass you realise you maybe need Microsoft Oauth as well, and you finally realise maybe it was a bad idea to hard code facebook Oauth2, as your authentication endpoints keep increasing and it becomes a hassle to maintain dev,stage, and prod credentials of your application.

## What is Dex?

- [dex](https://dexidp.io/) is an open source project that aims to simplify authentication for applications.
- Imagine this, you only had to deal with OIDC once (Ideally never would be nice, but its never ideal is it) and someone else took care of every other OIDC providers.
- Dex would talk to other OIDC providers and your application remains agnostic about the different providers, your application only knows about dex and the tokens dex gives.
- Dex comes with a local installation too, which means that the source of truth for authentication is its own database, you can interact with this service via grpc calls.
- You can configure the storage options as described [here](https://dexidp.io/docs/configuration/storage/)
- Oauth2 is the only protocol it supports because your app only needs to do that, here's the exhaustive [list](https://dexidp.io/docs/connectors/).
- The upstream connector can be anything, LDAP,SAML,OAUTH2(these are other ways you can setup authentication). So your app only has to implement process for dex, dex will take care of the rest.

## But what is OIDC, technically?

- before i summarise briefly how an OIDC flow looks like, lets get on the same page about terminology for crystal clear clarity
  - your app will be called relying party, think of it like you are relying on GitHub.
  - GitHub will be called Identity provider.
  - your users would be called plain old users.
  - token here refers to a JSON Web Token or JWT token.(think of it like a non mutable source of truth that gets passed around)
  - client-id and client-secret are things you would get from the identity provider you have registered against.
  - redirect_url, this is the place identity provider will tell the user to go after they have successfully logged in with their creds.
  - consent screen, this refers to the time when users login for the first time and identity provider wants to let the user know what the relying party wants to access.
  - scope, this defines what relying party will access.for example name, email etc.
- Alright then lets get on already:

1. user makes clicks on "Sign in with GitHub", this triggers a call to GitHub with your client-id, redirect_url, scope.
2. If the redirect_url matches what

## Local connector

- connector is basically the place where dex will go to for getting the user credentials verified.
- local connector means that dex will maintain its own database.
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

### dex configuration

### demo

### explanation
