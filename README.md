# Azure DevOps Extension Bundler - shelljs POC

This is a POC repository to showcase an existing issue when bundling tasks for Azure DevOps using the `azure-pipelines-task-lib@4.12.1` library and a workaround which keeps your task size small (which is likely why you are already bundling your task code).

## The problem

The shelljs library uses dynamic require() which makes esbuild unable to tree-shake correctly. If you are bundling your task with

```bash
npx esbuild task.js --platform=node --bundle --outfile=out/task.js
node out/task.js
```

You would get an error

```text
/.../azure-devops-extension-bundler-shelljs-poc/out/task.js:10
  throw new Error("Module not found in bundle: " + path);
  ^

Error: Module not found in bundle: ./src/cat
```

You need to put `shelljs` as an external lib for esbuild:

```bash
npx esbuild task.js --platform=node --external:shelljs --bundle --outfile=out/task.js
```

But `shelljs` is required in the root of `azure-pipelines-task-lib/task`, so you'll likely get another error:

```text
Error: Cannot find module 'shelljs'
```

## The workaround

`shelljs` is required by `azure-pipelines-task-lib/task` but never used if you are not directly using a function which uses it (most arn't). In this case, you can create an empty file under `node_modules/shelljs/index.js` which will let the `require('shelljs')` successfully complete with an undefined value.

## POC

Run `run.sh` to run the workaround.

## Questions

If you have questions, or if you found a better solution for this problem, please open an issue to discuss about it.
