From: laurent cop <laurent.cop-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Need some advices on LUKS2 cryptsetup (performance issue
 with integrity)
Date: Mon, 29 Jun 2020 15:09:23 +0200
Message-ID: <CAHzw6onkk9TcHE6m_MwO7WRTSE5ehh1bg3YG9HeT_7p6oOZM8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0688954293507297082=="
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <https://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <https://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: dm-crypt-4q3lyFh4P1g@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

--===============0688954293507297082==
Content-Type: multipart/alternative; boundary="0000000000009ec80705a938c677"

--0000000000009ec80705a938c677
Content-Type: text/plain; charset="UTF-8"

 Hello,

I would need some advice on LUKS2 cryptsetup (confidentiality + integrity).

My context was :
*encryption (cryptsetu*p aes_xts_plain64) on xfs formatted Raid5 (4+1 for
parity) soft raid (mdadm) on SSD nvme disks

I would like to include crypsetup integrity feature with
--cipher aes-gcm-random --integrity aead
on the same stack ( on xfs formatted Raid5 (4+1 for parity) soft raid
(mdadm) on SSD nvme disks)

Few tests with fio (I am testing *sequential write performances*)
--ioengine=libaio --bs=4K --size=30G --end_fsync=1 --numjobs=4

Provide me* a ratio of 3 between the two use cases.*

A study *"Practical Cryptographic Data Integrity Protection with Full Disk
Encryption Extended Version" from 1 Jul 2018*
seems to show this kind of ratio and illustrates the difference between
(JOURNAL and NO JOURNAL). In the case of NO JOURNAL, integrity seems to
have very low effects on performances.

1)How can I improve my performances with --cipher aes-gcm-random
--integrity aead ?  (this ratio of 3 with aes_xts_plain64 is huge)
2) What are the impacts of NO JOURNAL, I understand the goal of
journalisation in fs in case of a crash. Is it the same goal?

Thank you.

--0000000000009ec80705a938c677
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>
Hello,</div><div><br></div><div>I would need some advice on LUKS2 cryptsetu=
p (confidentiality + integrity). <br></div><div><br></div><div>My context w=
as :</div><div><b>encryption (cryptsetu</b>p aes_xts_plain64) on xfs format=
ted Raid5 (4+1 for parity) soft raid (mdadm) on SSD nvme disks<br></div><br=
></div><div>I would like to include crypsetup integrity feature with</div><=
div>--cipher aes-gcm-random --integrity aead</div><div>on the same stack (
on xfs formatted Raid5 (4+1 for parity) soft raid (mdadm) on SSD nvme disks=
)</div><div><br></div><div>Few tests with fio (I am testing <b>sequential w=
rite performances</b>)<br></div><div>--ioengine=3Dlibaio --bs=3D4K --size=
=3D30G --end_fsync=3D1 --numjobs=3D4</div><div><br></div><div>Provide me<b>=
 a ratio of 3 between the two use cases.</b></div><div><br></div><div>A stu=
dy <b>&quot;Practical Cryptographic Data Integrity Protection with Full Dis=
k Encryption Extended Version&quot; from 1 Jul 2018</b> <br></div><div>seem=
s to show this kind of ratio and illustrates the difference between=C2=A0 (=
JOURNAL and NO JOURNAL). In the case of NO JOURNAL, integrity=C2=A0seems to=
 have very low effects on performances.</div><div><br></div><div>1)How can =
I improve my performances with=20
--cipher aes-gcm-random --integrity aead ?=C2=A0 (this ratio of 3 with aes_=
xts_plain64 is huge)</div><div>2) What are the impacts of NO JOURNAL, I und=
erstand the goal of journalisation in fs in case of a crash. Is it the same=
 goal?</div><div><br></div><div>Thank you.<br></div><div><br></div><div><di=
v><br>
<br></div></div></div>

--0000000000009ec80705a938c677--

--===============0688954293507297082==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
https://www.saout.de/mailman/listinfo/dm-crypt

--===============0688954293507297082==--
