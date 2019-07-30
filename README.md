# Using Lighthouse in Jenkins pipeline with docker

Lighthouse analyzes web apps and web pages, collecting modern performance metrics and insights on developer best practices. This container allows you to use lighthouse in conjunction with the `--headless` option

## How to Use

## Step 1: Build the docker image using Dockerfile

```
docker build -t lighthouse:headless .
```

## Step 2: Run Container

```
docker run -itv ~/your-local-dir:/home/chrome/reports --rm lighthouse:headless bash
```

## Step 3: Run Lighthouse with `--chrome-flags`

Once you're in the container, using the `--chrome-flags` option available in lighthouse, we can automatically start Chrome in headless mode within the container light so:

```
lighthouse --chrome-flags="--headless --no-sandbox --disable-gpu" http://www.google.com
```

## Setup with Jenkins Pipeline

For Jenkins Pipeline, setup Jenkins server and add new pipeline job. Use pipeline with scm, add GIT repository [URL](https://github.com/nareshanjuru/lighthouse)
