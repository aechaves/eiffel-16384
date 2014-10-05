note
	description: "Test class for routines make_existent_user at USER_2048"
	author: "adriangalfioni"
	date: "September 5, 2014"
	revision: "0.01"

class
	MAKE_EXISTANT_USER_AT_USER_2048

inherit
	EQA_TEST_SET

feature

	make_existent_user_with_correct_parameters
			-- Create an User using a valid nickname and password
		local
			user : USER_16384
			board : BOARD_2048
			serialized_board: STRING
			equal_board: BOOLEAN
			database: DB_16384 -- Database for serialization operations
		do
			create board.make
			create database.make
			serialized_board := database.serialize(board)

			create user.make_existent_user ("test_nickname", "test_password", serialized_board)
			if attached {BOARD_2048} database.deserialize(user.board) as deserialized_board then
				equal_board := (board = deserialized_board)
			end
			--assert ("board is equal", equal_board)
			assert ("nickname value must be test_nickname", user.nickname.is_equal ("test_nickname"))
			assert ("password value must be test_password", user.password.is_equal ("test_password"))
		end


	negative_test_with_empty_name
			--Create an User using empty nickname in contructor
		local
  			ok, try, second_time: BOOLEAN
  			user : USER_16384
  			test_board : STRING -- Technically a serialized board
		do
			create test_board.make_empty
    		if not second_time then
          		ok := True
          		create user.make_existent_user ("", "pass", test_board)
          			-- Must throw an exception
          		ok := False
    		end
    		assert ("Rutine must fail", ok)
		rescue
     		second_time := True
     		if ok then   -- If ok rutine failed
           		retry
     		end
		end


	negative_test_with_void_name
			--Create an User using void nickname in contructor
		local
  			ok, try, second_time: BOOLEAN
  			user : USER_16384
  			test_board : STRING -- Serialized board
  			test_nickname: STRING
		do
			create test_board.make_empty
    		if not second_time then
          		ok := True
          		create user.make_existent_user (test_nickname, "pass", test_board)
          			-- Must throw an exception
          		ok := False
    		end
    		assert ("Rutine must fail", ok)
		rescue
     		second_time := True
     		if ok then   -- If ok rutine failed
           		retry
     		end
		end


--	negative_test_with_name_that_start_with_number
--			--Create an User using a name thats strat with a number in contructor
--		local
--  			ok, try, second_time: BOOLEAN
--  			user : USER_16384
--  			test_board : BOARD_2048
--		do
--			create test_board.make
--    		if not second_time then
--          		ok := True
--          		create user.make_existent_user ("123name", "surname", "nickname", "pass", test_board)
--          			-- Must throw an exception
--          		ok := False
--    		end
--    		assert ("Rutine must fail", ok)
--		rescue
--     		second_time := True
--     		if ok then   -- If ok rutine failed
--           		retry
--     		end
--		end


	negative_test_with_empty_password
			--Create an User using an empty password
		local
  			ok, try, second_time: BOOLEAN
  			user : USER_16384
  			test_board : STRING -- Serialized board
		do
			create test_board.make_empty
    		if not second_time then
          		ok := True
          		create user.make_existent_user ("nickname", "", test_board)
          			-- Must throw an exception
          		ok := False
    		end
    		assert ("Rutine must fail", ok)
		rescue
     		second_time := True
     		if ok then   -- If ok rutine failed
           		retry
     		end
		end


	negative_test_with_void_password
			--Create an User using an empty password
		local
  			ok, try, second_time: BOOLEAN
  			user : USER_16384
  			test_board : STRING -- Serialized board
  			test_pass : STRING
		do
			create test_board.make_empty
    		if not second_time then
          		ok := True
          		create user.make_existent_user ("nickname", test_pass, test_board)
          			-- Must throw an exception
          		ok := False
    		end
    		assert ("Rutine must fail", ok)
		rescue
     		second_time := True
     		if ok then   -- If ok rutine failed
           		retry
     		end
		end


end
