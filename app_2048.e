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
			Result.set_title ("2048")
			--| Check if the request contains a parameter named "user"
			--| this could be a query, or a form parameter
			if attached req.string_item ("user") as l_user then

				if (l_user.is_equal ("a") and controller.board.can_move_left) then
					controller.left
					Result.set_body( show_board_and_form )
				end
				if (l_user.is_equal ("d") and controller.board.can_move_right) then
					controller.right
					Result.set_body( show_board_and_form )
				end
				if (l_user.is_equal ("w") and controller.board.can_move_up) then
					controller.up
					Result.set_body( show_board_and_form )
				end
				if (l_user.is_equal ("s") and controller.board.can_move_down) then
					controller.down
					Result.set_body( show_board_and_form )
				end

			else
				Result.set_body(  show_board_and_form )

			end

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

end
