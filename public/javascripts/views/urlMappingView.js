/*global Backbone, jQuery, _, ENTER_KEY */
var app = app || {};

(function ($) {
  'use strict';

  // The Application
  // ---------------

  // Our overall **AppView** is the top-level piece of UI.
  app.UrlMappingView = Backbone.View.extend({


    template: _.template("<tr class='shortened-url <%-shortcode%>'><td class='col-md-8'><a class='col-md-6'rel='noopener noreferrer' target='_blank' href='<%- clickableUrl %>'><span class='base-url'>shooooort.com/ </span><span class='shortcode'><%- shortcode %></span></a><span class='col-md-6 click-to-copy'>Click to copy this link</span><input type='text' id='click-input-text' class=' hidden' value='<%- clickableUrl %>'/></td><td class='col-md-2 text-center visits' rowspan='2'><%= redirectCount %></td><td class='col-md-2 text-center last-visited' rowspan='2'> <%= lastSeenDate %> </td></tr><tr class='orignal-url <%-shortcode%>'><td class='col-md-8' colspan='2'><%- url %></td></tr>"),
    events: {
      'click .copy-link': 'copy-text'
    },
    initialize: function () {
      _.bindAll(this, "updateUi", "bindShowHideClickToCopy");
      this.model.bind('change', this.updateUi);
    },
    render: function () {
      var urlMappingHtml = this.template(this.model.displayableData());
      return urlMappingHtml;
    },

    updateUi: function(){
      $('.shortened-url.'+this.model.get('shortcode') + ' .visits').text(this.model.get('redirectCount'));
      $('.shortened-url.'+this.model.get('shortcode') + ' .last-visited').text(this.model.displayableDate(this.model.get('lastSeenDate')));
    },
    bindEvents: function(){
      //this.bindClickToCopy();
      //this.bindShowHideClickToCopy();
    },
    bindShowHideClickToCopy: function(){
      var _this = this;
      $('.shortened-url.'+_this.model.get('shortcode') + ' td').mouseenter(function(){
        $('.shortened-url.'+_this.model.get('shortcode') + ' td').addClass('show-copy-link');
      });

      $('.shortened-url.'+_this.model.get('shortcode') + ' td').mouseleave(function(){
        $('.shortened-url.'+_this.model.get('shortcode') + ' td').removeClass('show-copy-link');
      });
    },
    bindClickToCopy: function(){
    }
  });
})(jQuery);
