#MQ Setup
#========

#Check if the user has authority to administrate MQ

#variables
vQmgrName=QMDASHA
QNAME=OUTPUT
QMGR1_IP="localhost"
QMGR1_PORT=1414

#Create a Queue Manager
#crtmqm QMDasha

#Start the Queue Manager
#strmqm $vQmgrName

#runmqsc $vQmgrName < setqmdasha.mqsc > output.log

echo "DEFINE QLOCAL(Q.$QNAME) DESCR('"${QMGR1_IP}"("${QMGR1_PORT}")')" | runmqsc $vQmgrName







#MQ Setup
#========

#Check if the user has authority to administrate MQ

#variables
#vQmgrName=QMDASHA

#Create a Queue Manager
#crtmqm QMDasha

#Start the Queue Manager
#strmqm $vQmgrName

#runmqsc $vQmgrName < setqmdasha.mqsc > output.log

#echo "DELETE QLOCAL("$BLA")" | runmqsc $vQmgrName