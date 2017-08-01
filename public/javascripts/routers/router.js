/*global Backbone */
var app = app || {};

(function () {
  'use strict';

  // Todo Router
  // ----------
  var UrlMappingRouter = Backbone.Router.extend({
    routes: {

    }
  });

  app.UrlMappingRouter = new UrlMappingRouter();
  Backbone.history.start();
})();
