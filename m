From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: About dm-integrity layer and fsync
Date: Fri, 3 Jan 2020 12:14:07 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001031206190.11685@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAJTWkdu1-k5m0F-uzp-EMrncL1w4wLqEi8LgF0U1Js_Nf-YphQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="185206533-1783000016-1578071647=:11685"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJTWkdu1-k5m0F-uzp-EMrncL1w4wLqEi8LgF0U1Js_Nf-YphQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick Dung <patdung100@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-1783000016-1578071647=:11685
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On Fri, 3 Jan 2020, Patrick Dung wrote:

> Hello,
>=20
> A quick question on dm-integrity. Does dm-integrity layer honors fsync?

Yes it does.

However, it writes data into the journal and when the journal is flushed,=
=20
it reports the fsync function as finished.

On a mechanical disk, writes to contiguous space (i.e. the journal) are=20
faster than random writes all over the disk, that's why you see better=20
performance with dm-integrity than without it.

Mikulas

> I was testing dm-integrity and performance. It had a strange result that =
using dm-integrity with journal is faster than a normal file system or dm-i=
ntegrity with
> bitmap (no journal). fio is used for testing the storage performance. The=
 device is a SATA hard disk drive. Then I created a 100GB partition for tes=
ting.
>=20
> Below is the test cases:
>=20
> 1) XFS on a partition directly test case
>=20
> 2) dm-integrity: crc32c on a partition with default setting journal commi=
t interval is 10 seconds. Then create XFS on it. test case
>=20
> 3) dm-integrity: crc32c on a partition default setting journal commit int=
erval set to 5 seconds. Then create XFS on it.
>=20
> 4) dm-integrity:=C2=A0 crc32c on a partition default setting but using bi=
tmap instead of journal. Then create XFS on it.
>=20
> FIO command:
>=20
> fio --filename=3D./t1 --direct=3D1 --rw=3Drandrw --refill_buffers --noran=
dommap --randrepeat=3D0 --ioengine=3Dsync --bs=3D4k --rwmixread=3D75 --iode=
pth=3D16 --numjobs=3D8 --runtime=3D60
> --group_reporting --fsync=3D1 --name=3D4ktest --size=3D4G
>=20
> Result:
>=20
>  1. Read/Write IOPS: 117/41. Read/Write Speed 481KB/s 168KB/s
>  2. Read/Write IOPS: 178/59. Read/Write Speed 732KB/s 244KB/s
>  3. Read/Write IOPS: 169/57. Read/Write Speed 695KB/s 236KB/s
>  4. Read/Write IOPS: 97/32. Read/Write Speed 400K/s 131KB/s
> The original discussion in: https://gitlab.com/cryptsetup/cryptsetup/issu=
es/513 . Milan Broz said the dm-devel mailing list is a suitable place to d=
iscuss the probem.
>=20
> Thanks in advance.
>=20
> Patrick
>=20
> 
--185206533-1783000016-1578071647=:11685
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185206533-1783000016-1578071647=:11685--
