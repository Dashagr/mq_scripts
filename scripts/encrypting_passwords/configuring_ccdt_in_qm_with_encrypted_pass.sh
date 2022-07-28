# creating a new user in vm where qms are running

# username is remoteadmin
# give it a password

# encrypt the password, save it to a file using this command

# echo 'passw0rd' | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'encrypted.password' > userpassword.txt

# going inside both qms and setting a channel auth rules

SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('remoteadmin') AUTHADD(ALL)
SET AUTHREC OBJTYPE(QUEUE) PROFILE('**') PRINCIPAL('remoteadmin') AUTHADD(ALL)
SET AUTHREC OBJTYPE(CHANNEL) PROFILE('**') PRINCIPAL('remoteadmin') AUTHADD(ALL)
REFRESH SECURITY(*)

# then run a script

export MQSERVER='CHNL.AJ/TCP/18.130.221.119(1987)'
export MQCHLTAB='AMQCLCHL.TAB'
export MQCHLLIB='/tmp/aj'

typedpassword=$(< userpassword.txt)
password=` echo $typedpassword | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'encrypted.password' `

( echo $password; echo "DIS AUTHREC") | runmqsc -c -u remoteadmin QMAJ
