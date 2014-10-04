note
	description: "This class represent a user of the game 16384"
	author: ""
	date: "$October 1, 2014$"
	revision: "$Revision$"

class
	USER_16384

create
	default_create,make_new_user, make_existent_user, make_with_nickname, make_with_nick_and_pass, make_for_test

feature -- Initialisation

	make_existent_user (existent_nickname, existent_password: STRING; existent_board: STRING)
			-- Create a new user with existent user status
		require
			is_valid_password (existent_password)
			is_valid_nickname (existent_nickname)
		do
			nickname := existent_nickname
			password := existent_password
			board := existent_board
		end

	make_new_user (new_nickname, new_password: STRING)
			-- Create a new user with all atributes
		require
			is_valid_password (new_password)
			is_valid_nickname (new_nickname)
		do
			nickname := new_nickname
			password := new_password
			create board.make_empty
		end

	make_with_nickname (nick: STRING)
			-- Create a new user with nickname atribute
		require
			is_valid_nickname (nick)
		do
			nickname := nick
		end

	make_with_nick_and_pass (nick, pass: STRING)
			-- Create a new user with nickname and password atribute
		require
			is_valid_password (pass)
			is_valid_nickname (nick)
		do
			nickname := nick
			password := pass
		end

feature {IS_VALID_NAME_AT_USER_2048, APP_2048}

	make_for_test
			-- This method allows to create a User withtout any restriction on the imputs
			-- For testing purpouse
		do
		end

feature -- User data

	id: INTEGER
		-- Database id

	nickname: STRING

	password: STRING

	board: STRING
		-- Serialized board for database storing

feature -- Status report

	has_unfinished_game: BOOLEAN
			-- Returns true if the user has an unfinished game
--		require
--			valid_nickname: is_valid_name (nickname)
--		local
--			file: RAW_FILE
--		do
--			create file.make_with_name (path_saved_games + nickname)
--			if file.exists and then file.is_readable then
--				Result := True
--			end
--		end

feature -- Status setting


	save_game (new_game: BOARD_2048)
			--Saves the state of the current game board corresponding to this user
			--Requires that "new_game" is not void.
		obsolete
			"use database instead"
		do

		end
--		require
--			new_game /= void
--		do
--			game := new_game
--			store_by_name (path_saved_games + nickname)
--		ensure
--			game = new_game
--		end

	load_game
			-- Load a saved_game
		obsolete
			"use database instead"
		do

		end
--		require
--			existing_file (nickname)
--		do
--			if attached {USER_16384} retrieve_by_name (path_saved_games + nickname) as user_file then
--				name := user_file.name
--				surname := user_file.surname
--				password := user_file.password
--				game := user_file.game
--			end
--		ensure
--			(name /= Void) and (surname /= Void) and (password /= Void) and (game /= Void)
--		end


feature -- Control methods

	is_valid_password (pass_control: STRING): BOOLEAN
			-- Validate if pass isnt void or empty
		do
			if (pass_control /= Void) and (not pass_control.is_equal ("")) then
				Result := TRUE
			end
		end

	is_valid_nickname (nickname_control: STRING): BOOLEAN
		do
			if not nickname_control.is_empty then
				Result := TRUE
			end
		end

feature {HAS_UNFINISHED_GAME_AT_USER_2048, APP_2048}

	set_nickname (nick: STRING)
			--
		do
			nickname := nick
		end

	set_pass (pass: STRING)
			--
		do
			password := pass
		end

	set_board(new_board: STRING)
			--
		do
			board := new_board
		end

end
