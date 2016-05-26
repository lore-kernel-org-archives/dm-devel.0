From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Snapshot origin table as P/PO snapshot with /dev/null
Date: Thu, 26 May 2016 10:12:01 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1605261011410.14462@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed;
	BOUNDARY="185206533-1074554404-1464271025=:14462"
Return-path: <dm-devel-bounces@redhat.com>
Content-ID: <alpine.LRH.2.02.1605261011411.14462@file01.intranet.prod.int.rdu2.redhat.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-1074554404-1464271025=:14462
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-ID: <alpine.LRH.2.02.1605261011412.14462@file01.intranet.prod.int.rdu2.redhat.com>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id u4QEC3Cs014435



On Thu, 26 May 2016, Navin P.S wrote:

> Hi,=C2=A0Can you please help me with the below query that i posted to d=
m-devel ?
>=20
> On Thu, May 26, 2016 at 5:07 AM, Navin P.S <navinp1912@gmail.com> wrote=
:
>       Hi,=C2=A0 If i have a snapshot origin created using dmsetup creat=
e table with a mapping =C2=A0real device =C2=A0with (major,minor) =3D(8,1=
8) and lets name it /dev/mapper/dmso
>       . Now the set of reads are writes done from /dev/mapper/dmso have=
 some values (R,W).
>=20
> Had i been creating a persistent snapshot using (P or PO) mode with ori=
gin device as /dev/null and COW device is my real device (maj,min)=3D8,18=
 and it is named as
> /dev/mapper/dmsp. Now if i do the exact same reads and writes that i di=
d to dmso (snapshot-origin) , will get i the same set of output values (R=
,W).
>=20
> In my experiment i did. So i'm asking is there a case where it differs =
?=C2=A0
>=20
> Also i looked at the code in drivers/md/dm-snap.c and i find that both =
the drivers snapshot and snapshot-origin use the same __orgin_write . So =
my
> partial/incomplete understanding is that it works from the read/write v=
iew point from /dev/mapper/dmsp.
>=20
> I'll not be using the snapshot-merge feature , so merging to /dev/null =
is irrelevant here.
>=20
> Regards,
> -- Navin

Hi

The snapshot target doesn't accept /dev/null because it requires a block=20
device and /dev/null is chatected device.

You can use the "zero" device mapper target to create a block device that=
=20
returns zeroes on reads and that discards writes. You can use this zero=20
device as an origin to the dm-snapshot target.

With LVM, you can use this functionality with lvcreate --virtualsize=20
switch.

Mikulas
--185206533-1074554404-1464271025=:14462
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--185206533-1074554404-1464271025=:14462--
