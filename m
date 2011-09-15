From: "--[ UxBoD ]--" <uxbod@splatnix.net>
Subject: Performance Question
Date: Thu, 15 Sep 2011 20:43:27 +0100 (BST)
Message-ID: <1eff05ad-e2cc-42a5-b757-dfa40f14e776@office.splatnix.net>
Reply-To: "--\[ UxBoD \]--" <uxbod@splatnix.net>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3978009683246225922=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============3978009683246225922==
Content-Type: multipart/alternative;
	boundary="=_a5debe90-bde7-4d8f-9f04-a4c698cd5f52"

--=_a5debe90-bde7-4d8f-9f04-a4c698cd5f52
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello all, 

we are about to configure a new storage system that utilizes the Nexenta OS=
 with sparsely allocated ZVOLs. We wish to present 4TB of storage to a Linu=
x system that has four NICs available to it. We are unsure whether to prese=
nt one large ZVOL or four smaller ones to maximize the use of the NICs avai=
lable to us. We have set rr_min_io to 100 which we have found offers a good=
 level of performance. Though this raises an interesting question; that the=
 multipath.conf man pages says that the rr_min_io parameter is the number o=
f IOs across the whole path group before a switch is made to the next path.=
 What constitutes a single IO operation ? A user opens a file for read acce=
ss, one IOP to open the file, IOsX to read the contents, and another to clo=
se ? Do each of those SCSI operations happen on the same path ie. on the sa=
me block device ? If a second user comes along and requests data from the s=
ame block device do they happen on the same path or the next one in the pat=
h group ? We imagine that they will all happen on the same path until rr_mi=
n_io is reached and it switches over to the next path. 

We are trying to squeeze out the maximum performance from our system and we=
 are unable to max out our 4 x 1Gbe interfaces. Any thoughts on how we can =
improve our performance ? 
-- 
Thanks, Phil 

--=_a5debe90-bde7-4d8f-9f04-a4c698cd5f52
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D'text/css'>p { margin: 0; }</style></head><body><=
div style=3D'font-family: Courier New; font-size: 10pt; color: #000000'>Hel=
lo all,<br><br>we are about to configure a new storage system that utilizes=
 the Nexenta OS with sparsely allocated ZVOLs.&nbsp; We wish to present 4TB=
 of storage to a Linux system that has four NICs available to it. We are un=
sure whether to present one large ZVOL or four smaller ones to maximize the=
 use of the NICs available to us.&nbsp; We have set rr_min_io to 100 which =
we have found offers a good level of performance.&nbsp; Though this raises =
an interesting question; that the multipath.conf man pages says that the rr=
_min_io parameter is the number of IOs across the whole path group before a=
 switch is made to the next path. What constitutes a single IO operation ? =
A user opens a file for read access, one IOP to open the file, IOsX to read=
 the contents, and another to close ? Do each of those SCSI operations happ=
en on the same path ie. on the same block device ? If a second user comes a=
long and requests data from the same block device do they happen on the sam=
e path or the next one in the path group ? We imagine that they will all ha=
ppen on the same path until rr_min_io is reached and it switches over to th=
e next path.<br><br>We are trying to squeeze out the maximum performance fr=
om our system and we are unable to max out our 4 x 1Gbe interfaces. Any tho=
ughts on how we can improve our performance ?<span><br><span name=3D"x"></s=
pan>-- <br>Thanks, Phil<span name=3D"x"></span><br></span><br></div></body>=
</html>
--=_a5debe90-bde7-4d8f-9f04-a4c698cd5f52--


--===============3978009683246225922==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3978009683246225922==--
