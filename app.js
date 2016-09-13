'use strict';

var app = angular.module('app', ['ngTable']);
var githubRootUrl = "https://raw.githubusercontent.com/ashes999/rpg-maker-resources/gh-pages/resources/vxa";

angular.module('app').controller('ResourcesController', ['$scope', '$http', 'NgTableParams', 
function ($scope, $http, NgTableParams)
{
  this.githubRootUrl = githubRootUrl;  
  var self = this;

  // edition, eg. vxa, mv
  // resourceType, eg. graphics, json (see data/vxa/graphics.json, data/vxa/scripts.json)
  $scope.show = function(edition, resourceType)
  {
    console.log('show ' + edition + ' / ' + resourceType);
    $http({ method: 'GET', url: 'data/' + edition + '/' + resourceType + '.json'}).success(function(data, status, headers, config) {
      console.log('got data back: ' + data.resources);
      self.tableParams = new NgTableParams({}, { dataset: data.resources });
    });
  }

}]);

angular.module('app').directive('rpgResourcesTable', function() {
  return {
    restrict: 'E',
    templateUrl: 'rpg-maker-resources-table.html'
  };
});