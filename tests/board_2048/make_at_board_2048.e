note
	description: "[
		Test class for routine make at BOARD_2048
	]"
	author: "Facundo Munoz"
	date: "30/08/2013"
	revision: "1.0"
	testing: "type/manual"

class
	MAKE_AT_BOARD_2048

inherit
	EQA_TEST_SET

feature -- Test routines

	make_at_board_2048
			-- New test routine
		local
			board: BOARD_2048
		do
			create board.make

			assert ("is not full",not board.is_full)
			assert ("is not winning",not board.is_winning_board)
			assert ("just two cells", board.nr_of_filled_cells = 2)
			assert ("8 columns", board.columns = 8)
			assert ("8 rows", board.rows = 8)
		end

end


