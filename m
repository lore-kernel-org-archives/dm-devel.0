From: "Navin P.S" <navinp1912@gmail.com>
Subject: Snapshot origin table as P/PO snapshot with /dev/null
Date: Thu, 26 May 2016 05:07:43 +0530
Message-ID: <CAA=4085AdSO4uXrBwyrMyiSMAmRk=kyxucJ1TLLTcDkXsgvBpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1190096585362341026=="
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

--===============1190096585362341026==
Content-Type: multipart/alternative; boundary=001a11463b925552390533b32b6d

--001a11463b925552390533b32b6d
Content-Type: text/plain; charset=UTF-8

Hi,
  If i have a snapshot origin created using dmsetup create table with a
mapping  real device  with (major,minor) =(8,18) and lets name it
/dev/mapper/dmso . Now the set of reads are writes done from
/dev/mapper/dmso have some values (R,W).

Had i been creating a persistent snapshot using (P or PO) mode with origin
device as /dev/null and COW device is my real device (maj,min)=8,18 and it
is named as /dev/mapper/dmsp. Now if i do the exact same reads and writes
that i did to dmso (snapshot-origin) , will get i the same set of output
values (R,W).

In my experiment i did. So i'm asking is there a case where it differs ?

Also i looked at the code in drivers/md/dm-snap.c and i find that both the
drivers snapshot and snapshot-origin use the same __orgin_write . So my
partial/incomplete understanding is that it works from the read/write view
point from /dev/mapper/dmsp.

I'll not be using the snapshot-merge feature , so merging to /dev/null is
irrelevant here.

Regards,
-- Navin

--001a11463b925552390533b32b6d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div>=C2=A0 If i have a snapshot origin created using d=
msetup create table with a mapping =C2=A0real device =C2=A0with (major,mino=
r) =3D(8,18) and lets name it /dev/mapper/dmso . Now the set of reads are w=
rites done from /dev/mapper/dmso have some values (R,W).</div><div><br></di=
v><div>Had i been creating a persistent snapshot using (P or PO) mode with =
origin device as /dev/null and COW device is my real device (maj,min)=3D8,1=
8 and it is named as /dev/mapper/dmsp. Now if i do the exact same reads and=
 writes that i did to dmso (snapshot-origin) , will get i the same set of o=
utput values (R,W).</div><div><br></div><div>In my experiment i did. So i&#=
39;m asking is there a case where it differs ?=C2=A0</div><div><br></div><d=
iv>Also i looked at the code in drivers/md/dm-snap.c and i find that both t=
he drivers snapshot and snapshot-origin use the same __orgin_write . So my =
partial/incomplete understanding is that it works from the read/write view =
point from /dev/mapper/dmsp.</div><div><br></div><div>I&#39;ll not be using=
 the snapshot-merge feature , so merging to /dev/null is irrelevant here.</=
div><div><br></div><div>Regards,</div><div><div><div class=3D"gmail_signatu=
re">-- Navin </div>
</div></div></div>

--001a11463b925552390533b32b6d--


--===============1190096585362341026==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1190096585362341026==--
