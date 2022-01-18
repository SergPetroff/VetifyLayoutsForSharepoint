const path = require('path');
module.exports = {
  assetsDir: 'SiteAssets/VueMaster',
  publicPath: '/sites/ui', //'../SiteAssets/VueMaster',
  //transpileDependencies: ['vuetify'],

  filenameHashing: false,
  chainWebpack: config => {
    config.optimization.splitChunks().clear();

    //Статическое имя пакета
    config.output.filename('main.js');
  },
};
