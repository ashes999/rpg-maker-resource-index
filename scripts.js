'use strict';

angular.module('app').controller('ScriptsController', ['$scope', '$http', 'NgTableParams', function ($scope, $http, NgTableParams)
{
  // TODO: make this common across both controllers
  this.githubRootUrl = "https://raw.githubusercontent.com/ashes999/rpg-maker-mv-resources/gh-pages/resources/vxa";
  var self = this;

  $http({ method: 'GET', url: 'data/scripts.json'}).success(function(data, status, headers, config) {
    self.tableParams = new NgTableParams({}, { dataset: data.scripts });
  });  
}]);

