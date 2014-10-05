note
	description: "[
		Tests for the method load_game of class USER_2048
	]"
	author: "facumolina - aechaves"
	date: "$September 3, 2014$"
	revision: "$0.01$"
	testing: "type/manual"

class
	LOAD_GAME_AT_USER_2048

inherit
	EQA_TEST_SET

feature -- Test routines

	load_game_nonexistent_user_test
			-- test for nonexistent user should raise an exception
		local
			user : USER_16384
			ok, second_time : BOOLEAN
			database: DB_16384
		do
			if not second_time then
				ok := True
				create user.make_with_nickname ("nonexistent_user")
				create database.make
				database.connect_to_database
				database.select_user (user.nickname)
				ok := False
			end
			database.disconnect
			assert ("The routine has to fail", ok)
		rescue
			second_time := True
			if ok then
				retry
			end
		end

	load_game_existent_user
			--test for existent user
		local
			user : USER_16384
			board : BOARD_2048
			serialized_board: STRING
			database: DB_16384
		do
			create user.make_new_user ("user_nickname", "user_pwd")
			create board.make_empty
			create database.make
			board.set_cell (1,1,4)
			board.set_cell (1,2,8)
			serialized_board := database.serialize (board)
			user.set_board(serialized_board)
			-- Store the user
			database.connect_to_database
			database.insert_user (user)
			-- Load the user
			database.select_user (user.nickname)
			user := database.last_retrieved_user
			database.disconnect
			-- Correct atributtes
			assert("The nickname is correct", equal(user.nickname,"user_nickname"))
			assert("The password is correct", equal(user.password,"user_pwd"))
			-- Correct board
			if attached {BOARD_2048} database.deserialize (user.board) as deserialized_board then
				assert("Correct cell 1", deserialized_board.elements.item (1, 1).value=4)
				assert("Correct cell 2", deserialized_board.elements.item (1, 2).value=8)
			end
		end

end


