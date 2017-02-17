# Heroku Buildpack: TypeScript

Run this buildpack after [heroku/nodejs](https://github.com/heroku/heroku-buildpack-nodejs) to compile your TypeScript source files to JavaScript with the TypesScript compiler. In order to do that, it will install your development dependencies into `$BUILD_DIR`.

If the `tsc` command can be found in `node_modules/.bin`, it is assumed that the necessary dependencies for compilation have already been installed.
