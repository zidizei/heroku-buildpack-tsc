# Heroku Buildpack: TypeScript

Run this buildpack after [heroku/nodejs](https://github.com/heroku/heroku-buildpack-nodejs) to compile your TypeScript source files to JavaScript with the TypesScript compiler. In order to do that, it will install your development dependencies into `BUILD_DIR`.

If the `tsc` command can be found in `node_modules/.bin`, it is assumed that the necessary dependencies for compilation have already been installed.

## Usage

Append this TypeScript buildpack to your application's buildpack list.

```
heroku buildpacks:set https://github.com/heroku/heroku-buildpack-nodejs
heroku buildpacks:add https://github.com/zidizei/heroku-buildpack-tsc
```

By default, `heroku-buildpack-tsc` will use the `tsconfig.json` file found in your application's root directory. You can specify a custom configuration file (e.g. for deployment builds) by setting `TSC_CUSTOM_FILE` in your *Config Vars* to point to an alternative `tsconfig.json`.

```
heroku config:set TSC_CUSTOM_FILE='config/tsconfig.prod.json'
```

## Build Environment

You can also set a different `NODE_ENV` for the compilation process.

```
heroku config:set TSC_BUILD_ENV='development'
```

This is mostly **required** for **`yarn`** builds. Development dependencies with **`npm`** are installed with the `--only=dev` flag.
