note
	description: "This class represent a user of the game 16384"
	author: ""
	date: "$October 1, 2014$"
	revision: "$Revision$"

class
	DB_16384

inherit

	DATABASE_APPL [MYSQL]

create
	make,login

feature -- Creation
	make
		do

		end

feature -- Database management

	session_control: DB_CONTROL
			-- Session control

	storer : DB_STORE
			-- Storer for the user columns

	connect_to_database
			-- Login and connect to database
		do
			set_data_source("users_16348")
			login ("root", "")
			if is_logged_to_base then
				set_base
				create session_control.make
				session_control.connect
			end
		end

	disconnect
			-- Disconnect from database
		do
			if session_control.is_connected then
				session_control.disconnect
			end
		end

	user_repository: DB_REPOSITORY
			-- Repository for user table

	last_retrieved_user: USER_16384
			-- The last user we selected from the database

feature -- Database operations

	insert_user (new_user: USER_16384)
			-- Sets the new board and stores the user data in the database
		require
			user_exists: new_user /= Void
			user_has_nickname: new_user.nickname /= Void
			user_has_password: new_user.password /= Void
			user_has_board: new_user.board /= Void
			connected: session_control.is_connected
		do
			-- TODO: Check if user already exists and overwrite
			create user_repository.make ("users")
			create storer.make
			user_repository.load
			storer.set_repository (user_repository)
			if storer.is_ok then
				storer.put (new_user)
			end

		end

	select_user (user_nickname: STRING)
			-- Loads the user data from the database
		require
			nickname_is_not_void: user_nickname /= Void
			valid_nickname: is_valid_nickname (user_nickname)
			connected: session_control.is_connected
		local
			selection: DB_SELECTION
			action: DB_ACTION [USER_16384]
			l_user: USER_16384
		do
			create l_user.make_for_test --should use a standart make?
			create selection.make
			selection.set_query ("SELECT * FROM users WHERE nickname = "+user_nickname)
			selection.object_convert (l_user)
			create action.make (selection, l_user)
			selection.set_action (action)
			selection.execute_query
			selection.load_result
			if selection.is_ok and action.list.count = 1 then
				last_retrieved_user := (action.list.i_th (1))
			end
		end

feature  -- Serialization for database storing

	-- Subsequent methods are taken from eiffelroom.com

	serialize (a_object: ANY): STRING
        	-- Serialize `a_object'.
    require
        a_object_not_void: a_object /= Void
    local
        l_sed_rw: SED_MEMORY_READER_WRITER
        l_sed_ser: SED_RECOVERABLE_SERIALIZER
        l_cstring: C_STRING
        l_cnt: INTEGER
    do
        create l_sed_rw.make
        l_sed_rw.set_for_writing
        create l_sed_ser.make (l_sed_rw)
        l_sed_ser.set_root_object (a_object)
        l_sed_ser.encode
            -- the 'count' gives us the number of bytes
            -- we have to read and put into the string.
        l_cnt := l_sed_rw.count
        create l_cstring.make_by_pointer_and_count (l_sed_rw.buffer.item, l_cnt)
        Result := l_cstring.substring (1, l_cnt)
    ensure
        serialize_not_void: Result /= Void
    end

	deserialize (a_string: STRING): ANY
        	-- Deserialize `a_string'.
    require
        a_string_not_void: a_string /= Void
    local
        l_sed_rw: SED_MEMORY_READER_WRITER
        l_sed_ser: SED_RECOVERABLE_DESERIALIZER
        l_cstring: C_STRING
    do
        create l_cstring.make (a_string)
        create l_sed_rw.make_with_buffer (l_cstring.managed_data)
        l_sed_rw.set_for_reading
        create l_sed_ser.make (l_sed_rw)
        l_sed_ser.decode (True)
        Result := l_sed_ser.last_decoded_object
    end


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

end

