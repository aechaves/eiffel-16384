var app = angular.module('main',[]).
	controller('BoardController',function($scope,$http) {

	// Cell color function
	$scope.CellColor=function(cellNumber) { 
	if (cellNumber==0) { return {number0:true};} 
	if (cellNumber==2) { return {number2:true};} 
	if (cellNumber==4) { return {number4:true};} 
	if (cellNumber==8) { return {number8:true};} 
	if (cellNumber==16) { return {number16:true};}
	if (cellNumber==32) { return {number32:true};} 
	if (cellNumber==64) { return {number64:true};}
	if (cellNumber==128) { return {number128:true};} 
	if (cellNumber==256) { return {number256:true};} 
	if (cellNumber==512) { return {number512:true};} 
	if (cellNumber==1024) { return {number1024:true};} 
	if (cellNumber==2048) { return {number2048:true};} 
	if (cellNumber==4096) { return {number4096:true};} 
	if (cellNumber==8192) { return {number8192:true};} 
	if (cellNumber==16384) { return {number16384:true};} 
	}; 
		
	//Key control function
	$scope.key = {};
	$scope.keyOk = false;
	$scope.KeyControl=function(ev){ 
		if (ev.which==37 || ev.which==65) { $scope.keyOk=true; $scope.key={user:'a'}; } 
		if (ev.which==38 || ev.which==87) { $scope.keyOk=true; $scope.key={user:'w'}; } 
		if (ev.which==39 || ev.which==68) { $scope.keyOk=true; $scope.key={user:'d'}; } 
		if (ev.which==40 || ev.which==83) { $scope.keyOk=true; $scope.key={user:'s'}; } 
		if ($scope.keyOk) { 
			$http({ 
				method: 'POST',
				url:'http://localhost:9999/', 
				data: $.param($scope.key),
				headers: {'Content-Type': 'application/x-www-form-urlencoded'} 
			}).success(
				function(data){
					document.open();
					document.write(data);
					document.close();
				}
			); 
		} 
	}; 
		
	// Load form visibility
	$scope.formLoadVisibility=false; 
	$scope.formSaveVisibility=false; 
	
	$scope.ShowFormLoad=function(){ 
		$scope.formLoadVisibility=!$scope.formLoadVisibility; 
		$scope.formSaveVisibility=false; 
	};

	$scope.ShowFormSave=function(){ 
		$scope.formSaveVisibility=!$scope.formSaveVisibility; 
		$scope.formLoadVisibility=false; 
	}; 

	$scope.Load=function(){ $scope.formLoadVisibility=false;} ; 
	$scope.Save=function(){ $scope.formSaveVisibility=false;} ; 
})