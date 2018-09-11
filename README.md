# Heroku Buildpack: TypeScript [![Build Status](https://travis-ci.org/zidizei/heroku-buildpack-tsc.svg?branch=master)](https://travis-ci.org/zidizei/heroku-buildpack-tsc)

Run this buildpack after [heroku/nodejs](https://github.com/heroku/heroku-buildpack-nodejs) to compile your TypeScript source files to JavaScript with the TypesScript compiler. In order to do that, it will install your development dependencies into `BUILD_DIR`, since the offical Nodejs buildpack removes any installed development dependencies after it's successfully build.

Telling the Nodejs buildpack to [skip pruning](https://devcenter.heroku.com/articles/nodejs-support#skip-pruning) will also skip this buildpack's dependency installation.

## Usage

Append this TypeScript buildpack to your application's buildpack list.

```
heroku buildpacks:set heroku/nodejs
heroku buildpacks:add zidizei/typescript
```

To re-use the development dependencies that have been installed in the previous Nodejs buildpack, set the following config variables to [skip pruning](https://devcenter.heroku.com/articles/nodejs-support#skip-pruning).

```
heroku config:set NPM_CONFIG_PRODUCTION=false YARN_PRODUCTION=false
```

By default, `heroku-buildpack-tsc` will use the `tsconfig.json` file found in your application's root directory. You can specify a custom configuration file (e.g. for deployment builds) by setting `TSC_CONFIG` in your *Config Vars* to point to an alternative `tsconfig.json` file. (See also TypeScript's [configuration inheritance](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html))

```
heroku config:set TSC_CONFIG='config/tsconfig.prod.json'
```

## Build Environment

You can also set a different `NODE_ENV` for the compilation process.

```
heroku config:set TSC_BUILD_ENV='development'
```

## Using the latest source code

The `zidizei/typescript` buildpack from the [Heroku Buildpack Registry](https://devcenter.heroku.com/articles/buildpack-registry) represents the latest stable version of the buildpack. If you'd like to use the source code from this Github repository, you can set your buildpack to the Github URL:

```
heroku buildpacks:add https://github.com/zidizei/heroku-buildpack-tsc#v2.0
```

## Testing

Tests can be run with `docker-compose up` via [Heroku's Buildpack Testrunner](https://hub.docker.com/r/heroku/buildpack-testrunner/) container. Refer to the [testrunner repository](https://github.com/heroku/heroku-buildpack-testrunner) for more information.

# Changelog

## v2.0
- Removed the merging of `tsconfig.json` files when specifying a custom config file. Instead, TypeScript's [configuration inheritance](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html).
- Use `TSC_CONFIG` instead of `TSC_CUSTOM_FILE` to specify a different TypeScript configuration file
