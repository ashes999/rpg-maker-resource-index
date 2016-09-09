function showScripts() {
  document.getElementById('scriptsTable').style.display =  'block';
  document.getElementById('resourcesTable').style.display =  'none';
}

function showResources() {
  document.getElementById('scriptsTable').style.display =  'none';
  document.getElementById('resourcesTable').style.display =  'block';
}

showScripts();

var app = angular.module('app', ['ngTable']);
