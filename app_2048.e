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


feature {NONE} -- Execution

	response (req: WSF_REQUEST): WSF_HTML_PAGE_RESPONSE
			-- Computed response message.
		do
			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create Result.make
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
				Result.set_body( html_body+style )
			else
				Result.set_body (html_body+style)
			end
			Result.add_javascript_url ("https://ajax.googleapis.com/ajax/libs/angularjs/1.2.26/angular.min.js")
			Result.add_javascript_content (main_script)
			--Result.add_style ("css/board.css","all")
		end

feature {NONE} -- Initialization

	initialize
		do
				--| Uncomment the following line, to be able to load options from the file ewf.ini
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")
			create controller.make
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


	show_board_and_form : STRING
	local
		i,j : INTEGER
		table, form : STRING
	do
		table:=""
		table.append ("<table id="+"board"+" width="+"300"+" height="+"300"+">")
		from
			i := 1
		until
			i>controller.board.rows
		loop
			table.append ("<tr>")
			from
				j:=1
			until
				j>controller.board.columns
			loop
				table.append ("<td>"+controller.board.elements.item (i, j).value.out+"</td>")
				j:=j+1
			end
			i:=i+1
			table.append ("</tr>")
		end
		table.append ("</table>")
		table.append ("<br>")
		table.append ("<form action="+"/"+" method="+"POST"+">")
		table.append ("<input type="+"text"+" name="+"user"+">")
		table.append ("<input type="+"submit"+" value="+"Mover"+">")
		table.append ("</form>")
		Result := table
	end

	main_script : STRING
	local
		s : STRING
		i,j : INTEGER
	do
		s := ""
		s.append ("var app = angular.module('main',[]). ")
		s.append("controller('BoardController',function($scope) {")
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
				s.append ("cell"+j.out+":'"+controller.board.elements.item (i, j).value.out+"'")
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
		s.append("})")
		Result := s
	end

	html_body : STRING
	local
		s : STRING
	do
		s:="</body><body ng-app="+"main"+" ng-controller="+"BoardController"+">"
		s.append ("<h1>16384</h1>")
		s.append ("<div class='wrapper'>")
		s.append ("<table width="+"600"+" height="+"600"+">")
		s.append ("<tr ng-repeat='row in board'>")
		s.append ("<td>{{row.cell1}}</td>")
		s.append ("<td>{{row.cell2}}</td>")
		s.append ("<td>{{row.cell3}}</td>")
		s.append ("<td>{{row.cell4}}</td>")
		s.append ("<td>{{row.cell5}}</td>")
		s.append ("<td>{{row.cell6}}</td>")
		s.append ("<td>{{row.cell7}}</td>")
		s.append ("<td>{{row.cell8}}</td>")
		s.append ("</tr>")
		s.append ("</table>")
		s.append ("<br>")
		s.append ("<form action="+"/"+" method="+"POST"+">")
		s.append ("<input type="+"text"+" name="+"user"+">")
		s.append ("<input type="+"submit"+" value="+"Mover"+">")
		s.append ("</form>")
		s.append ("</div>")
		Result := s
	end

	style : STRING
	local
		s : STRING
	do
		s:="<style>"
		s.append ("h1 {text-align: center;color:#666;text-shadow:0px 2px 0px #fff;}")
		s.append (".wrapper{width: 650px;margin: 0 auto;box-shadow: 5px 5px 5px #555;border-radius: 15px;padding: 10px;}")
		s.append ("body {background: #ccc;font-family: "+"Open Sans"+", arial;}")
		s.append ("table {max-width: 600px;height: 320px;border-collapse: collapse;border: 1px solid #38678f;margin: 50px auto;background: white;}")
		s.append ("td {border-right: 1px solid #cccccc;padding: 10px;text-align: center;transition: all 0.2s;}")
		s.append ("tr {border-bottom: 1px solid #cccccc;}")
		s.append ("tr:last-child {border-bottom: 0px;}")
		s.append ("td:last-child {border-right: 0px;}")
		s.append ("</style>")
		Result := s
	end
end
