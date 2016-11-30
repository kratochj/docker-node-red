#!/bin/sh

echo "Running node-red"

if [ -n "$USERS_FULL_ACCESS" ] || [ -n "$USER_RO_ACCESS" ]; then 
	
	echo "adminAuth: {
    type: \"credentials\",
    users: [
    " > settings.js		
	
  	for user in $(echo $USERS_FULL_ACCESS | sed "s/,/ /g"); do
		echo "Creating admin users..."
		
		echo `$user`
		
		if [ -n "$ADD_COMMA" ]; then 
		  echo ", ">> settings.js	
		fi	
		
		echo "{
  		  username: \"`echo "$user" | awk -F'|' '{print $1}'`\",
		  
		  password: \"`echo "$user" | awk -F'|' '{print $2}'`\",
          permissions: \"*\"
		}" >> settings.js
		
		ADD_COMMA="true"	
	done
	
  	for user in $(echo $USERS_RO_ACCESS | sed "s/,/ /g"); do
		echo "Creating read/only users..."
		
		if [ -n "$ADD_COMMA" ]; then 
		  echo ", ">> settings.js	
		fi	
		
		
		echo "{
  		  username: \"`echo "$user" | awk -F'|' '{print $1}'`\",
		  
		  password: \"`echo "$user" | awk -F'|' '{print $2}'`\",
          permissions: \"read\"
		}" >> settings.js
		
		ADD_COMMA="true"	
	done



	sed -i '$ d' settings.sample.js
	echo "," >> settings.sample.js
    cat settings.js >> settings.sample.js
	echo "]}}" >> settings.sample.js
	
	
	
	cp -f settings.sample.js settings.js
	
	cat settings.js	
	
	cp -f settings.js /data/settings.js
fi	

npm start -- --userDir /data
