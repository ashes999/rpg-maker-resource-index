'use strict';

var app = angular.module('app', ['ngTable']);
var githubRootUrl = "https://raw.githubusercontent.com/ashes999/rpg-maker-resources/gh-pages/resources/vxa";

angular.module('app').controller('ScriptsController', ['$scope', '$http', 'NgTableParams', 
function ($scope, $http, NgTableParams)
{
  this.githubRootUrl = githubRootUrl;  
  var self = this;

  $http({ method: 'GET', url: 'data/vxa/scripts.json'}).success(function(data, status, headers, config) {
    self.tableParams = new NgTableParams({}, { dataset: data.scripts });
  });  
}]);

angular.module('app').controller('ResourcesController', ['$scope', '$http', 'NgTableParams',
function ($scope, $http, NgTableParams) {
    this.githubRootUrl = githubRootUrl;

  var self = this;

  $http({ method: 'GET', url: 'data/vxa/graphics.json'}).success(function(data, status, headers, config) {
    self.tableParams = new NgTableParams({}, { dataset: data.graphics });
  });    
}]);

