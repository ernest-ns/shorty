/*global Backbone, jQuery, _, ENTER_KEY */
var app = app || {};

(function ($) {
  'use strict';

  // The Application
  // ---------------

  // Our overall **AppView** is the top-level piece of UI.
  app.UrlMappingView = Backbone.View.extend({


    template: _.template("<tr class='shortened-url <%-shortcode%>'><td class='col-md-8'><span class='base-url'>shooooort.com/ </span><span class='shortcode'><%- shortcode %></span></td><td class='col-md-2 text-center visits' rowspan='2'><%= redirectCount %></td><td class='col-md-2 text-center last-visited' rowspan='2'> <%= lastSeenDate %> </td></tr><tr class='orignal-url <%-shortcode%>'><td class='col-md-8' colspan='2'><%- url %></td></tr>"),
    events: {
      'click .copy-link': 'copy-text'
    },
    initialize: function () {
      _.bindAll(this, "updateUi");
      this.model.bind('change', this.updateUi);
    },
    render: function () {
      var urlMappingHtml = this.template(this.model.displayableData());
      return urlMappingHtml;
    },

    updateUi: function(){
      $('.shortened-url.'+this.model.get('shortcode') + ' .visits').text(this.model.get('redirectCount'));
      $('.shortened-url.'+this.model.get('shortcode') + ' .last-visited').text(this.model.displayableDate(this.model.get('lastSeenDate')));
    }
  });
})(jQuery);
