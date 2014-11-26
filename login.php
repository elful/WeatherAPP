<?php


header('Content-type: application/json');
if($_POST) {
	$username   = $_POST['username'];
	$password   = $_POST['password'];

	if($username && $password) {

			$db_name     = 'RL';
			$db_user     = 'root';
			$db_password = 'quatroljikbkec';
			$server_url  = '127.0.0.1';

			$mysqli = new mysqli('127.0.0.1', $db_user, $db_password, $db_name);

			
			if (mysqli_connect_errno()) {
				error_log("Connect failed: " . mysqli_connect_error());
				echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
			} else {
				if ($stmt = $mysqli->prepare("SELECT username FROM users WHERE username = ? and password = ?")) {

					
					$stmt->bind_param("ss", $username, md5($password));

					
					$stmt->execute();

					
					$stmt->bind_result($id);

					
					$stmt->fetch();

					
					$stmt->close();
				}

				
				$mysqli->close();

				if ($id) {
					error_log("User $username: password match.");
					echo '{"success":1}';
				} else {
					error_log("User $username: password doesn't match.");
					echo '{"success":0,"error_message":"Invalid Username/Password."}';
				}
			}
	} else {
		echo '{"success":0,"error_message":"Invalid Username/Password."}';
	}
}else {
	echo '{"success":0,"error_message":"Invalid Data."}';
}
?>
