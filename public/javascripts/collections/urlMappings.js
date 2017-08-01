/*global Backbone */
var app = app || {};

(function () {
  'use strict';

  // Todo Collection
  // ---------------

  // The collection of todos is backed by *localStorage* instead of a remote
  // server.
  var UrlMappings = Backbone.Collection.extend({
    // Reference to this collection's model.
    model: app.UrlMapping,

    addNewUrl: function(model){
      this.add(model);
      window.localStorage.setItem('urlMappings', JSON.stringify(this.models));
    },
    fetchLocallyStoredUrls: function(){
      var storedUrls = window.localStorage.getItem('urlMappings') || "[]";
      var parsedUrls = JSON.parse(storedUrls);
      this.add(parsedUrls);
    },
    clearLocallyStoredUrls: function(){
      window.localStorage.setItem('urlMappings', "");
    }
  });

  // Create our global collection of **Todos**.
  app.urlMappings = new UrlMappings();
})();
