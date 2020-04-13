#!/usr/bin/perl
#By Luke Shannon

use CGI;
use CGI::Carp  qw(fatalsToBrowser);
use Net::SMTP;

$query = CGI::new();

#get the values from the form
$name = $query->param("name");
$date = $query->param("date");
$comments = $query->param("comments");

#only run if the values are provided
if ( (defined($name)) && (defined($date)) && (defined($comments)) ) {

	#figure out who this is sent to and from
	$sendTo = "beaconhillpool\@gmail.com";
	$sentBy = "contact-submission\@bhill.pl";
	$subject = "Contact";

	#formulate the message
	$message = "This came in from the contact form: \n\n\n";
	$message = $message . "Name: " . $name . "\n\n";
	$message = $message . "Date: " . $date . "\n\n";
	$message = $message . "Comments: " . $comments . "\n\n";

	$ServerName = "localhost";

	# Create a new SMTP object
	$smtp = Net::SMTP->new( $ServerName );

	# If you can't connect, don't proceed with the rest of the script
	die "Couldn't connect to server" unless $smtp;

	# Identify sender and recipient to the server
	$smtp->mail ( $sentBy );
	$smtp->to   ( $sendTo );

	# Start the mail
	$smtp->data();

	# Send the header
	$smtp->datasend("To: $sendTo\n");
	$smtp->datasend("From: $sentBy\n");
	$smtp->datasend("Subject: $subject\n");
	$smtp->datasend("\n");

	# Send the message
	$smtp->datasend("$message \n\n");

	# Send the termination string
	$smtp->dataend();

	# Close the connection
	$smtp->quit();

	#redirect to the thank you page
	print $query->redirect( "http://bhill.pl/success.html" );
} else {
	 print "HTTP/1.1 400 Bad Request\r\n";
}
