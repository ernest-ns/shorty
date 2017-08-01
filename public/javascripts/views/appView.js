/*global Backbone, jQuery, _, ENTER_KEY */
var app = app || {};

(function ($) {
  'use strict';

  // The Application
  // ---------------

  // Our overall **AppView** is the top-level piece of UI.
  app.AppView = Backbone.View.extend({

    el: '.main-container',

    // Delegated events for creating new items, and clearing completed ones.
    events: {
      'click .submit-button': 'createOnEnter',
      'click .clear-history': 'clearHistory'
    },

    // At initialization we bind to the relevant events on the `Todos`
    // collection, when items are added or changed. Kick things off by
    // loading any preexisting todos that might be saved in *localStorage*.
    initialize: function () {
      this.render();
    },


    render: function () {
      app.urlMappings.fetchLocallyStoredUrls();
      var _this = this;
      app.urlMappings.each(function(model){
        _this.appendNewUrlToUI(model);
      });
    },

    createOnEnter: function(e) {
      var url = this.$el.find('.url-field').val();
      var urlMapping = new app.UrlMapping;
      var _this = this;
      urlMapping.save(
        this.newAttributes(),
        {type: 'POST', url: '/shorten',
         error: function(model, response) {
           console.log(model);
         },
         success: function(model, response){
           console.log(model);
           _this.addNewUrl(model);
         }
        }
      );
      this.$el.find('.url-field').val('');
    },
    clearHistory: function(){
      app.urlMappings.reset(null);
      app.urlMappings.clearLocallyStoredUrls();
      this.$el.find('.shortened-url , .orignal-url').remove();

    },
    addNewUrl: function(model){
      app.urlMappings.addNewUrl(model);
      this.appendNewUrlToUI(model);
    },
    appendNewUrlToUI: function(model){
      var _this = this;
      var urlMappingView = new app.UrlMappingView({model: model });
      this.$el.find('.url-list.table').find('tbody').append(urlMappingView.render());
      urlMappingView.bindEvents();
      urlMappingView.model.fetch();
    },
    newAttributes: function () {
      return {
        url: this.$el.find('.url-field').val()
      };
    }
  });
})(jQuery);
