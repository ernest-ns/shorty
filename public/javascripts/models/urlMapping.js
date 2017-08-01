/*global Backbone */
var app = app || {};

(function () {
  'use strict';
  app.UrlMapping = Backbone.Model.extend({

    idAttribute: 'shortcode',

    // Default attributes for the todo
    // and ensure that each todo created has `title` and `completed` keys.
    defaults: {
      url: '',
      shortcode: '',
      redirectCount: 0,
      lastSeenDate: '',
      startDate: ''
    },
    url : function() {
      var base = '/';
      if (this.isNew()) return base;
      return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.get('shortcode') + '/stats';
    },
    displayableData: function() {
      var attr = Backbone.Model.prototype.toJSON.call(this);
      attr.url = this.displayableUrl(attr.url);
      attr.lastSeenDate = this.displayableDate(attr.lastSeenDate);
      return attr;
    },
    displayableUrl: function(url){
      if(url.length > 50) {
        url = url.substring(0,49)+"...";
      }
      return url;
    },
    displayableDate: function(date){
      if(_.isEmpty(date)){
        return "";
      }
      return timeago().format(date);
    },
    fetchUpdates: function(){
      this.fetch({wait: true});
    },
    toggle: function () {
      // this.save({
      //   completed: !this.get('completed')
      // });
    }
  });
})();
