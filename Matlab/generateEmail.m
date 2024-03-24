% Define the company and position for this batch of emails
companyFile = 'yahoo.txt';
fileID = fopen(companyFile, 'r');

companyName = fgetl(fileID);
link = fgetl(fileID);

fclose(fileID);

% Grab email & password.
credentialsFile = 'credentials.txt';
fileID = fopen(credentialsFile, 'r');

email = fgetl(fileID);
password = fgetl(fileID);

fclose(fileID);

% Set up Gmail SMTP service.
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail',email);
setpref('Internet','SMTP_Username',email);
setpref('Internet','SMTP_Password',password);

% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% This section configures MATLAB to use Gmail's SMTP server to send emails. 
% It includes the server address, the sender's email address, and login credentials. 
% It also configures SMTP to use SSL for security, specifying the port number 465.

% Specify file names
namesFile = 'Names.txt';
templateFile = 'TemplateEmail.txt';
outputFile = 'Output.txt';

% Read the names and template content
namesContent = fileread(namesFile);
templateContent = fileread(templateFile);

% Split the content by new lines to get each name
namesLines = splitlines(namesContent);

% Open the output file for writing
fid = fopen(outputFile, 'w');

% Process each name line
for i = 1:length(namesLines)
    nameLine = strtrim(namesLines{i});
    % Split the name into parts and check if it seems valid
    nameParts = split(nameLine);
    if length(nameParts) >= 2
        % Construct the email using the first and last name
        firstName = nameParts{1};
        lastName = nameParts{2};
        email = strcat(lower(firstName), '.', lower(lastName), '@', companyName, '.com');
        header = ['Rutgers Student Interested in ', companyName, ' Opportunity'];
        attachmentFilePath = '/Abhitej_Bokka_Resume.pdf'; 

        % Replace placeholders in the template
        personalizedEmail = strrep(templateContent, '{firstName}', firstName);
        personalizedEmail = strrep(personalizedEmail, '{lastName}', lastName);
        personalizedEmail = strrep(personalizedEmail, '{companyName}', companyName);
        personalizedEmail = strrep(personalizedEmail, '{email}', email);
        personalizedEmail = replace(personalizedEmail, '{link}', link);

        % Send the email
        sendmail(email, header, personalizedEmail, attachmentFilePath);

        
        % Write the personalized email to the output file
        fprintf(fid, '%s\n', personalizedEmail);
    end
end

fclose(fid);
disp(['Personalized emails have been saved to ', outputFile]);

%{
\textbf{Simple Mail Transfer Protocol (SMTP) Overview}

\textit{SMTP} is a protocol utilized for sending emails across the Internet. It 
defines a set of guidelines that mail servers adhere to for sending and 
receiving email messages. Operating on a client-server model, SMTP allows 
a client to send a mail request to the mail server, which then forwards the 
mail to the recipient's mail server.

\textbf{How SMTP Works in Depth}

The SMTP communication involves several key steps and commands to 
transport an email from a sender to a recipient:

1. \textbf{Connection Establishment:} The SMTP client establishes a TCP connection 
   to the SMTP server on port 25 (standard) or 465/587 (for SSL/TLS encrypted 
   connections).

2. \textbf{SMTP Handshake:} The client and server exchange greetings using the HELO 
   (or EHLO for Extended SMTP) command, identifying the sender and opening 
   the communication channel.

3. \textbf{Mail Transfer:} The client sends the email's sender and recipient information 
   using the MAIL FROM and RCPT TO commands, respectively.

4. \textbf{Data Transfer:} The client indicates the beginning of the message data 
   transmission with the DATA command, followed by the email's headers, body, 
   and attachments encoded as text.

5. \textbf{Closing the Connection:} After the email is transferred, the client sends the 
   QUIT command to close the SMTP session.

SMTP servers may relay emails through multiple intermediate servers before 
the email reaches the recipient's server, depending on the email's routing path.
%}
