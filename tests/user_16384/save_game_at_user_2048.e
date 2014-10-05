note
	description: "[
		Tests for the save_game feature at the USER_2048 class
	]"
	author: "jheredia"
	date: "September 3, 2014"
	revision: "0.01"
	testing: "type/manual"

class
	SAVE_GAME_AT_USER_2048

inherit
	EQA_TEST_SET

feature -- Test routines

	save_game_with_void_board
			-- Attempt to save_game with a void board
			-- Should raise an exception.
		local
			user: USER_16384
			board: STRING -- Serialized board
			database: DB_16384
			second_time, ok: BOOLEAN
		do
			create user.make_with_nick_and_pass ("johndoe","johnpass")
			create database.make
			if not second_time then
				ok := True
				database.connect_to_database
				database.insert_user (user)
				ok := False
			end
			database.disconnect
			assert ("You can't save a void board.", ok)
			rescue
			second_time := True
			if ok then
				retry
			end
		end

	save_game_with_non_void_board
		-- Saves a file with a generated board
		-- Should return true
		local
			user, x: USER_16384
			database: DB_16384
			bool : BOOLEAN
			obj : ANY
			board: BOARD_2048
			serialized_board: STRING -- Serialized board
		do
			create user.make_with_nickname ("johndoe")
			create board.make
			create database.make
			board.set_cell (1, 2, 4)

			serialized_board := database.serialize(board)
			user.set_board (serialized_board)
			-- Store
			database.connect_to_database
			database.insert_user (user)
			-- Retrieve
			database.select_user (user.nickname)
			database.disconnect
			assert ("This test should pass", database.last_retrieved_user /= void)
		end
end


