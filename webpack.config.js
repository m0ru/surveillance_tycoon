/*module.exports = {
  entry: "./scripts/wv.js",
  output: {
        path: __dirname + "/bin/",
        filename: "packed.js"
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css"}
    ]
  },
  node: {
    global: true
  }
}*/

var webpack = require('webpack');

module.exports = {
  entry: './app/index',
  output: {
    path: __dirname,
    filename: 'bundle.js'
  },
  plugins: [
    new webpack.ProvidePlugin({
      riot: 'riot'
    })
  ],
  module: {
    preLoaders: [
      { test: /\.tag$/, exclude: /node_modules/, loader: 'riotjs-loader', query: { type: 'none' } }
    ]/*, atm unused
    loaders: [
      { test: /\.css$/, loader: "style!css"}
    ]*/
  },
  devServer: {
    contentBase: './'
  }
};
