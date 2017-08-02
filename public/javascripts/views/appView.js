/*global Backbone, jQuery, _, ENTER_KEY */
var app = app || {};

(function ($) {
  'use strict';

  app.AppView = Backbone.View.extend({

    el: '.main-container',


    events: {
      'click .submit-button': 'createOnEnter',
      'click .clear-history': 'clearHistory'
    },

    initialize: function () {
      this.render();
    },

    render: function () {
      app.urlMappings.fetchLocallyStoredUrls();
      var _this = this;
      app.urlMappings.each(function(model){
        _this.appendNewUrlToUI(model);
      });
      if(app.urlMappings.length > 0){
        this.$el.find('.history').removeClass('hidden');
      }

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
      this.$el.find('.history').addClass('hidden');
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
      this.$el.find('.history').removeClass('hidden');
    },
    newAttributes: function () {
      return {
        url: this.$el.find('.url-field').val()
      };
    }
  });
})(jQuery);
