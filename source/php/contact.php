<?php

    $name = $_POST['name'];
    $email = $_POST['email'];
    $message = $_POST['text'];
    $subject = $_POST['subject'];
    
    $from = 'From: ' . $email . '' . "\r\n" .
    'Reply-To: ' . $email . '' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();


    $to = 'simon.cay.gaus@gmail.com';
    
    $body = '-' . $message . '-';
    
    $URL="../contact.html";
    echo '<META HTTP-EQUIV="refresh" content="3;URL=' . $URL . '">';
    echo "<script type='text/javascript'>setTimeout(function () { document.location.href='{$URL}; }, 3000);</script>";
    
    if ($email != '' && $subject != '' && $message != '') {

            if ($name == '') {
                
                $name = 'Anonym';
            }
                
            if (mail($to, $subject, $body, $from)) {
                
                echo '<h3>Your message has been sent! You will be redirected in 3 Seconds.</h3>';
            }
            else {
                
                echo '<h3>Something went wrong, please try again! You will be redirected in 3 Seconds.</h3>';
            }
    }
    else {
        
        echo '<h3>You need to fill in all fields (exept the name field). You will be redirected in 3 Seconds.</h3>';
    }
?>
