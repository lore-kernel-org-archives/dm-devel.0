From: Karan Vohra <karanvohra@outlook.com>
Subject: Questions around multipath failover and no_path_retry
Date: Sun, 11 Mar 2018 16:47:17 +0000
Message-ID: <SN1PR20MB047927660CFE0409EDE91C95C9DC0@SN1PR20MB0479.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1428333661117937983=="
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

--===============1428333661117937983==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR20MB047927660CFE0409EDE91C95C9DC0SN1PR20MB0479namp_"

--_000_SN1PR20MB047927660CFE0409EDE91C95C9DC0SN1PR20MB0479namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Folks,

Let us assume, there are 2 paths within the path group which dm-multipath i=
s sending the I/Os in round-robin fashion. Each of these paths are identifi=
ed as unique block device(s) such as /dev/sdb and /dev/sdc.

Let us say some I/Os are sent over to the path /dev/sdb and either the requ=
ests time out or there is a failure on that path, what happens to those I/O=
s? Are they sent over to the other path - /dev/sdc or does dm-multipath wai=
ts for /dev/sdb to come back online and only sends I/O to /dev/sdb? One of =
the reasons we are concerned about the above scenario is- let us say there =
is a write I/O W1 which is routed to /dev/sdb and then there is a failure. =
There was a write I/O W2 which wrote at the same block via /dev/sdc. Now if=
 multipath sends W1 through /dev/sdc, W2 gets overwritten by W1. The expect=
ation was that W2 happens after W1 and should overwrite W1 but the result i=
s opposite. Situations like these can cause data inconsistency and corrupti=
on.We were thinking of using no_path_retry configuration to be set to queue=
 to make sure that the I/Os supposed to be going to path1 never make it to =
path2. But the question is that would not that cause unexpected behavior in=
 application layer? Let us say there are I/O Requests R1, R2, R3 and so on.=
. R1 is going to Path1, R2 is going to Path2 and so on. If Path1 dies for s=
ome reason, with the setting of no_path_retry to queue, queueing will not s=
top until the path is fixed so does not that mean that R1, R3,R5 ... will n=
ot make it to block device until the path is fixed? Would it not cause fail=
ures if the issue persists for seconds? What about the size of queue? Is th=
ere any danger of queue getting overloaded?Any pointers or references would=
 be of great help.

Thanks!
Karan


Get Outlook for Android<https://aka.ms/ghei36>


--_000_SN1PR20MB047927660CFE0409EDE91C95C9DC0SN1PR20MB0479namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Hi Folks,<br>
<br>
</div>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Let us assume, there are 2 paths within the path group which dm-multipath i=
s sending the I/Os in round-robin fashion. Each of these paths are identifi=
ed as unique block device(s) such as /dev/sdb and /dev/sdc.&nbsp;<br>
<br>
</div>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Let us say some I/Os are sent over to the path /dev/sdb and either the requ=
ests time out or there is a failure on that path, what happens to those I/O=
s? Are they sent over to the other path - /dev/sdc or does dm-multipath wai=
ts for /dev/sdb to come back&nbsp;online
 and only sends I/O to /dev/sdb? One of the reasons we are concerned about =
the above scenario is- let us say there is a write I/O W1 which is routed t=
o /dev/sdb and then there is a failure. There was a write I/O W2 which wrot=
e at the same block via /dev/sdc.&nbsp;Now
 if multipath sends W1 through /dev/sdc, W2 gets overwritten by W1. The exp=
ectation was that W2 happens after W1 and should overwrite W1 but the resul=
t is opposite. Situations like these can cause data inconsistency and corru=
ption.We were thinking of using
 no_path_retry configuration to be set to queue to make sure that the I/Os =
supposed to be going to path1 never make it to path2. But the question is t=
hat would not that cause unexpected behavior in application layer? Let us s=
ay&nbsp;there are I/O Requests R1, R2,
 R3 and so on.. R1 is going to Path1, R2 is going to Path2 and so on. If Pa=
th1 dies for some reason, with the setting of no_path_retry to queue, queue=
ing will not stop until the path is fixed so does not that mean that R1, R3=
,R5 ... will not make it to block
 device until the path is fixed? Would it not cause failures if the issue p=
ersists for seconds? What about the size of queue? Is there any danger of q=
ueue getting overloaded?Any pointers or references would be of great help.<=
br>
<br>
</div>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Thanks!<br>
</div>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Karan<br>
<br>
<br>
</div>
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
<div dir=3D"auto" style=3D"direction: ltr; margin: 0; padding: 0; font-fami=
ly: sans-serif; font-size: 11pt; color: black; ">
Get <a href=3D"https://aka.ms/ghei36">Outlook for Android</a></div>
<br>
</div>
</body>
</html>

--_000_SN1PR20MB047927660CFE0409EDE91C95C9DC0SN1PR20MB0479namp_--


--===============1428333661117937983==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1428333661117937983==--
