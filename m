From: "public0x05bf@bluewin.ch" <public0x05bf@bluewin.ch>
Subject: Swapping on device-mapper targets
Date: Tue, 21 Oct 2008 16:43:29 +0000 (GMT)
Message-ID: <6758992.428641224607409331.JavaMail.webmail@ps24zhh.bluewin.ch>
Reply-To: public0x05bf@bluewin.ch,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From Thomas Bruecker, Switzerland. 


Dear DM-Developers,

I have questions about swapping to device-mapper targets:

Question 1:

Provided that "sda1" and "sdb1" are two devices, to which I may swap without
any problems, e.g. with the entries in "/etc/fstab":

"
/dev/sda1   swap    swap    defaults     0 0
/dev/sdb1   swap    swap    defaults     0 0
".

May I swap also to the mirror target "test_raid" created by the statement

' dmsetup  create test_raid \
    --table "0 8388608   mirror   core 2 8388608 sync \
             2  /dev/sda1 0  /dev/sdb1 0 " '

without any problems (e.g. deadlocks)? (The command above completes
successfully and therefore there is enough space on "sda1" and "sdb1" to create
the target.)


Question 2:

Provided the table entry form for a mirror target is:

' ... --table " $START $LENGTH mirror \
                $LOG_TYPE $NumLOGARGS $LOGARG1 ... $LOGARGm \
                $NumDEVS  $DEVICE1 $OFFSET1 ... $DEVICEn $OFFSETn "
'
Does your answer to question 1 only hold for the parameters I specified in
question 1 or for all legal parameters $... (of the above table entry form)?

I have searched your site "http://www.redhat.com/archives/dm-devel/" by google
for answers to my above questions, but I have not found any answer to them
there. So I would be happy to get an answer from you.

Sincerely

Thomas Bruecker
