From: Karan Vohra <karanvohra@outlook.com>
Subject: Questions around multipath - failover and no_path_retry
Date: Sat, 10 Mar 2018 00:19:27 +0000
Message-ID: <SN1PR20MB04799DB408CB3C7DBFF26A12C9DE0@SN1PR20MB0479.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6789603626306769082=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6789603626306769082==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR20MB04799DB408CB3C7DBFF26A12C9DE0SN1PR20MB0479namp_"

--_000_SN1PR20MB04799DB408CB3C7DBFF26A12C9DE0SN1PR20MB0479namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Folks,

Let us assume, there are 2 paths within the path group which dm-multipath i=
s sending the I/Os in round-robin fashion. Each of these paths are identifi=
ed as unique block device(s) such as /dev/sdb and /dev/sdc.


  1.  Let us say some I/Os are sent over to the path /dev/sdb and either th=
e requests time out or there is a failure on that path, what happens to tho=
se I/Os? Are they sent over to the other path - /dev/sdc or does dm-multipa=
th waits for /dev/sdb to come back online and only sends I/O to /dev/sdb? O=
ne of the reasons we are concerned about the above scenario is- let us say =
there is a write I/O W1 which is routed to /dev/sdb and then there is a fai=
lure. There was a write I/O W2 which wrote at the same block via /dev/sdc. =
Now if multipath sends W1 through /dev/sdc, W2 gets overwritten by W1. The =
expectation was that W2 happens after W1 and should overwrite W1 but the re=
sult is opposite. Situations like these can cause data inconsistency and co=
rruption.
  2.  We were thinking of using no_path_retry configuration to be set to qu=
eue to make sure that the I/Os supposed to be going to path1 never make it =
to path2. But the question is that would not that cause unexpected behavior=
 in application layer? Let us say there are I/O Requests R1, R2, R3 and so =
on.. R1 is going to Path1, R2 is going to Path2 and so on. If Path1 dies fo=
r some reason, with the setting of no_path_retry to queue, queueing will no=
t stop until the path is fixed so does not that mean that R1, R3, R5 ... wi=
ll not make it to block device until the path is fixed? Would it not cause =
failures if the issue persists for seconds? What about the size of queue? I=
s there any danger of queue getting overloaded?

Any pointers or references would be of great help.

Thanks!
Karan


--_000_SN1PR20MB04799DB408CB3C7DBFF26A12C9DE0SN1PR20MB0479namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri,Helvetica,sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: transparent;">
Hi Folks,<br>
<br>
Let us assume, there are 2 paths within the path group which dm-multipath i=
s sending the I/Os in round-robin fashion. Each of these paths are identifi=
ed as unique block device(s) such as /dev/sdb and /dev/sdc.
<br>
<br>
<ol>
<li>Let us say some I/Os are sent over to the path /dev/sdb and either the =
requests time out or there is a failure on that path, what happens to those=
 I/Os? Are they sent over to the other path - /dev/sdc or does dm-multipath=
 waits for /dev/sdb to come back
 online and only sends I/O to /dev/sdb? One of the reasons we are concerned=
 about the above scenario is- let us say there is a write I/O W1 which is r=
outed to /dev/sdb and then there is a failure. There was a write I/O W2 whi=
ch wrote at the same block via /dev/sdc.
 Now if multipath sends W1 through /dev/sdc, W2 gets overwritten by W1. The=
 expectation was that W2 happens after W1 and should overwrite W1 but the r=
esult is opposite. Situations like these can cause data inconsistency and c=
orruption.</li><li>We were thinking of using no_path_retry configuration to=
 be set to queue to make sure that the I/Os supposed to be going to path1 n=
ever make it to path2. But the question is that would not that cause unexpe=
cted behavior in application layer? Let us say
 there are I/O Requests R1, R2, R3 and so on.. R1 is going to Path1, R2 is =
going to Path2 and so on. If Path1 dies for some reason, with the setting o=
f no_path_retry to queue, queueing will not stop until the path is fixed so=
 does not that mean that R1, R3,
 R5 ... will not make it to block device until the path is fixed? Would it =
not cause failures if the issue persists for seconds? What about the size o=
f queue? Is there any danger of queue getting overloaded?</li></ol>
Any pointers or references would be of great help.<br>
<br>
Thanks!<br>
Karan<br>
<br>
</div>
</body>
</html>

--_000_SN1PR20MB04799DB408CB3C7DBFF26A12C9DE0SN1PR20MB0479namp_--


--===============6789603626306769082==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6789603626306769082==--
