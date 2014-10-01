note
	description: "Test class for method is_finished of class controller_2048."
	author: "bisoardi"
	date: "September 3, 2014"
	revision: "$0.01"

class
	IS_FINISHED_AT_CONTROLLER_2048

inherit

	EQA_TEST_SET

feature

	is_finished_on_starting_board
	-- Checks the finish condition on the starting board

		local
			board: BOARD_2048
			controller: CONTROLLER_2048
		do
			create board.make
			create controller.make_with_board (board)
			assert ("is_finished should be False", not controller.is_finished)
		end

	is_finished_on_full_board
	-- Checks the finish condition on full board, without a cell with 2048 on it

		local
			board: BOARD_2048
			controller: CONTROLLER_2048
			i,j,value : INTEGER
		do
			create board.make_empty
			value:=2
			from
				i := 1
			until
				i > board.rows
			loop
				from
					j := 1
				until
					j > board.columns
				loop
					board.set_cell (i, j, value)
					value:=value*2
					if (value=16384) then
						value:=2
					end
					j:=j+1
				end
				i:=i+1
			end
			create controller.make_with_board (board)
			assert ("is_finished should be True", controller.is_finished)
		end

		is_finished_on_board_with_16384
		-- Checks the finish condition on a board with a 2048 on it

			local
				board: BOARD_2048
				controller: CONTROLLER_2048
			do
				create board.make_empty
				board.set_cell (3, 2, 16384)
				create controller.make_with_board (board)
				assert ("is_finished should be True", controller.is_finished)
			end

end
