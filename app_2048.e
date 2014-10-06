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
	database: DB_16384
			-- Database with user data.


feature {NONE} -- Execution

	response (req: WSF_REQUEST): WSF_HTML_PAGE_RESPONSE
			-- Computed response message.
		do
			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create Result.make
			Result.add_javascript_url ("http://code.jquery.com/jquery-latest.min.js")
			Result.add_javascript_url ("https://ajax.googleapis.com/ajax/libs/angularjs/1.2.26/angular.min.js")
			Result.add_javascript_url ("https://raw.githubusercontent.com/aechaves/eiffel-16384/develop16384/js/main.js")
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
					-- Here we load a serialized board from the database,
					-- and deserialize it so we can create a new controller with it.
					database.select_user (load_user)
					user := database.last_retrieved_user
					if attached {BOARD_2048} database.deserialize(user.board) as user_board then
						create controller.make_with_board (user_board)
					end

				end

				if (attached req.string_item ("save_user") as save_user) and (attached req.string_item ("save_pass") as save_pass) then
					-- Here we set the user data to the object,
					-- and store it in the database.
					user.set_nickname (save_user)
					user.set_pass (save_pass)
					user.set_board (database.serialize(controller.board))
					database.insert_user (user)

				end

				user.set_board ("board")
				database.insert_user (user)

				Result.set_body (html_body+style+cell_color_style)
			end
		end

feature {NONE} -- Initialization

	initialize
		do
				--| Uncomment the following line, to be able to load options from the file ewf.ini
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")
			create controller.make

			create database.make
			database.connect_to_database

			create user.make_new_user("guest","guest") -- Empty user

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

	html_body : STRING
	local
		s : STRING
	do
		s := "</body><body ng-app="+"main"+" ng-controller="+"BoardController"+" ng-keydown='KeyControl($event)' >"
		--s.append ("<link rel='stylesheet' type='text/css' href='https://raw.githubusercontent.com/aechaves/eiffel-16384/develop16384/css/board.css'>")
		s.append ("<h1>16384</h1>")
		s.append ("<div class='wrapper'>")
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
