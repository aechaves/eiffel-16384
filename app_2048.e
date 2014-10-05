note
	description: "eiffel-2048 application root class, for command line version of the application."
	date: "August 26, 2014"
	revision: "0.01"

class
	APP_2048

inherit

	WSF_DEFAULT_RESPONSE_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature -- Implementation

	controller: CONTROLLER_2048
			-- It takes care of the control of the 2048 game.
	user: USER_16384
			-- Used for loading and saving games.


feature {NONE} -- Execution

	response (req: WSF_REQUEST): WSF_HTML_PAGE_RESPONSE
			-- Computed response message.
		do
			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create Result.make
			Result.add_javascript_url ("http://code.jquery.com/jquery-latest.min.js")
			Result.add_javascript_url ("https://ajax.googleapis.com/ajax/libs/angularjs/1.2.26/angular.min.js")
			Result.set_title ("16384")
			--| Check if the request contains a parameter named "user"
			--| this could be a query, or a form parameter
			if attached req.string_item ("user") as l_user then

				if (l_user.is_equal ("a") and controller.board.can_move_left) then
					controller.left
				end
				if (l_user.is_equal ("d") and controller.board.can_move_right) then
					controller.right
				end
				if (l_user.is_equal ("w") and controller.board.can_move_up) then
					controller.up
				end
				if (l_user.is_equal ("s") and controller.board.can_move_down) then
					controller.down
				end
				Result.set_body( html_body+style+cell_color_style )
			else
				if (attached req.string_item ("load_user") as load_user) and (attached req.string_item ("load_pass") as load_pass) then
					user.load_game
					create controller.make_with_board (user.game)
				end

				if (attached req.string_item ("save_user") as save_user) and (attached req.string_item ("save_pass") as save_pass) then
					user.set_nickname (save_user)
					user.set_pass (save_pass)
					user.save_game(controller.board)
				end

				Result.set_body (html_body+style+cell_color_style)
			end
			--Result.add_javascript_content (main_script)
			Result.add_javascript_url ("https://raw.githubusercontent.com/aechaves/eiffel-16384/develop16384/js/main.js")
		end

feature {NONE} -- Initialization

	initialize
		do
				--| Uncomment the following line, to be able to load options from the file ewf.ini
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")
			create controller.make
			create user.make_new_user("guest","guest","guest","guest") -- Empty user
				--| You can also uncomment the following line if you use the Nino connector
				--| so that the server listens on port 9999
				--| quite often the port 80 is already busy
--			set_service_option ("port", 9999)

				--| Uncomment next line to have verbose option if available
--			set_service_option ("verbose", True)

				--| If you don't need any custom options, you are not obliged to redefine `initialize'
			Precursor
		end

feature {NONE} --Show board with html table

	main_script : STRING
	local
		s : STRING
		i,j : INTEGER
	do
		s := ""
		s.append ("var app = angular.module('main',[]). ")
		s.append("controller('BoardController',function($scope,$http) {")
		s.append(" $scope.board = [")
		from
			i := 1
		until
			i>controller.board.rows
		loop
			s.append (" { ")
			from
				j:=1
			until
				j>controller.board.columns
			loop
				--if (controller.board.elements.item (i, j).value=0) then
				--	s.append ("cell"+j.out+":''")
				--else
					s.append ("cell"+j.out+":'"+controller.board.elements.item (i, j).value.out+"'")
				--end
				if (j<controller.board.columns) then
					s.append (",")
				end
				j:=j+1
			end
			s.append (" }")
			if (i<controller.board.rows) then
				s.append (",")
			end
			i:=i+1
		end
		s.append(" ]; ")
		 --Cell color function
		s.append ("$scope.CellColor=function(cellNumber) { ")
		s.append ("if (cellNumber==0) { return {number0:true};} ")
		s.append ("if (cellNumber==2) { return {number2:true};} ")
		s.append ("if (cellNumber==4) { return {number4:true};} ")
		s.append ("if (cellNumber==8) { return {number8:true};} ")
		s.append ("if (cellNumber==16) { return {number16:true};} ")
		s.append ("if (cellNumber==32) { return {number32:true};} ")
		s.append ("if (cellNumber==64) { return {number64:true};} ")
		s.append ("if (cellNumber==128) { return {number128:true};} ")
		s.append ("if (cellNumber==256) { return {number256:true};} ")
		s.append ("if (cellNumber==512) { return {number512:true};} ")
		s.append ("if (cellNumber==1024) { return {number1024:true};} ")
		s.append ("if (cellNumber==2048) { return {number2048:true};} ")
		s.append ("if (cellNumber==4096) { return {number4096:true};} ")
		s.append ("if (cellNumber==8192) { return {number8192:true};} ")
		s.append ("if (cellNumber==16384) { return {number16384:true};} ")
		s.append ("}; ")
		-- Key control function
		--s.append ("$scope.listeningKeys=true;")
		--s.append ("$scope.Typing=function(){ $scope.listeningKeys=false;}")
		s.append ("$scope.key = {};")
		s.append ("$scope.keyOk = false;")
		s.append ("$scope.KeyControl=function(ev){ ")
		s.append ("if (ev.which==37 || ev.which==65) { $scope.keyOk=true; $scope.key={user:'a'}; } ")
		s.append ("if (ev.which==38 || ev.which==87) { $scope.keyOk=true; $scope.key={user:'w'}; } ")
		s.append ("if (ev.which==39 || ev.which==68) { $scope.keyOk=true; $scope.key={user:'d'}; } ")
		s.append ("if (ev.which==40 || ev.which==83) { $scope.keyOk=true; $scope.key={user:'s'}; }  ")
		--s.append ("if ($scope.keyOk) { $.ajax({type : 'POST',url:'http://localhost:9999/',data:$scope.key,contentType:'json',headers: {Accept : 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8','Content-Type': 'application/x-www-form-urlencoded'}}).done(function(data){document.open();document.write(data);document.close();})}")
		s.append ("if ($scope.keyOk) { $http({ method: 'POST',url:'http://localhost:9999/', data: $.param($scope.key),headers: {'Content-Type': 'application/x-www-form-urlencoded'} } ).success(function(data){document.open();document.write(data);document.close();}); } ")
		s.append ("}; ")
		-- Load form visibility
		s.append ("$scope.formLoadVisibility=false; ")
		s.append ("$scope.formSaveVisibility=false; ")
		s.append ("$scope.ShowFormLoad=function(){ $scope.formLoadVisibility=!$scope.formLoadVisibility; $scope.formSaveVisibility=false; }; ")
		s.append ("$scope.ShowFormSave=function(){ $scope.formSaveVisibility=!$scope.formSaveVisibility; $scope.formLoadVisibility=false; }; ")
		s.append ("$scope.Load=function(){ $scope.formLoadVisibility=false;} ; ")
		s.append ("$scope.Save=function(){ $scope.formSaveVisibility=false;} ; ")
		s.append("})")
		Result := s
	end

	html_body : STRING
	local
		s : STRING
	do
		s := "</body><body ng-app="+"main"+" ng-controller="+"BoardController"+" ng-keydown='KeyControl($event)' >"
		--s.append ("<link rel='stylesheet' type='text/css' href='https://raw.githubusercontent.com/aechaves/eiffel-16384/develop16384/css/board.css'>")
		s.append ("<h1>16384</h1>")
		s.append ("<div class='wrapper'>")
--		s.append ("<table width="+"600"+" height="+"600"+">")
--		s.append ("<tr ng-repeat='row in board'>")
--		s.append ("<td ng-class='CellColor({{row.cell1}})'>{{row.cell1}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell2}})'>{{row.cell2}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell3}})'>{{row.cell3}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell4}})'>{{row.cell4}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell5}})'>{{row.cell5}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell6}})'>{{row.cell6}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell7}})'>{{row.cell7}}</td>")
--		s.append ("<td ng-class='CellColor({{row.cell8}})'>{{row.cell8}}</td>")
--		s.append ("</tr>")
--		s.append ("</table>")
		s.append (controller.board.out)
		s.append ("</div>")
		s.append ("<br>")
		-- User load
		s.append ("<div class='wrapper'>")
		s.append ("<center>")
		s.append ("<button ng-click='ShowFormLoad()' >Load game</button>")
		s.append ("<button ng-click='ShowFormSave()' >Save game</button>")
		s.append ("<form ng-show='formLoadVisibility' action="+"/"+" method="+"POST"+">")
		s.append ("<input ng-click='Typing()' type="+"text"+" name="+"load_user"+" placeholder='nickname'>")
		s.append ("<input type="+"password"+" name="+"load_pass"+" placeholder='password'>")
		s.append ("<input ng-click='Load()' type="+"submit"+" value="+"Load game"+">")
		s.append ("</form>")
		-- User save
		s.append ("<form ng-show='formSaveVisibility' action="+"/"+" method="+"POST"+">")
		s.append ("<input type="+"text"+" name="+"save_user"+" placeholder='nickname'>")
		s.append ("<input type="+"password"+" name="+"save_pass"+" placeholder='password'>")
		s.append ("<input ng-click='Save()' type="+"submit"+" value="+"Save game"+">")
		s.append ("</form>")
		s.append ("</center>")
		s.append ("</div>")
		Result := s
	end

	style : STRING
	local
		s : STRING
	do
		s:="<style>"
		s.append ("h1 {text-align: center;color:black;text-shadow:0px 2px 0px #fff;}")
		s.append (".wrapper{width: 650px;margin: 0 auto;box-shadow: 5px 5px 5px #555;border-radius: 15px;padding: 10px;}")
		s.append ("body {background: #ccc;font-family: "+"Open Sans"+", arial;}")
		s.append ("table {max-width: 600px;height: 400px;border-collapse: collapse;border: 3px solid #7E7575;margin: 25px auto;table-layout: fixed;}")
		s.append ("td {border-right: 3px solid #7E7575;padding: 10px;text-align: center;transition: all 0.2s; color:#7E7575}")
		s.append ("tr {border-bottom: 3px solid #7E7575;}")
		s.append ("tr:last-child {border-bottom: 0px;}")
		s.append ("td:last-child {border-right: 0px; }")
		s.append ("</style>")
		Result := s
	end

	cell_color_style : STRING
	local
		s : STRING
	do
		s := "<style>"
		s.append (".number0 { background-color:#7E7575}")
		s.append (".number2 { background-color:#eee4da}")
		s.append (".number4 { background-color:#ede0c8}")
		s.append (".number8{ background-color:#f2b179}")
		s.append (".number16 { background-color:#f59563}")
		s.append (".number32 { background-color:#f67c5f}")
		s.append (".number64 { background-color:#f65e3b}")
		s.append (".number128 { background-color:#edcf72}")
		s.append (".number256{ background-color:#edcc61}")
		s.append (".number512 { background-color:#edc850}")
		s.append (".number1024{ background-color:#edc53f}")
		s.append (".number2048 { background-color:#edc22e}")
		s.append(".number4096 { background-color:#77a136}")
		s.append(".number8192 { background-color:#2db388}")
		s.append(".number16384 { background-color:#2d83b3}")
		s.append ("</style>")
		Result := s
	end
end
