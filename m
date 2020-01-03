From: Patrick Dung <patdung100@gmail.com>
Subject: About dm-integrity layer and fsync
Date: Fri, 3 Jan 2020 23:51:24 +0800
Message-ID: <CAJTWkdu1-k5m0F-uzp-EMrncL1w4wLqEi8LgF0U1Js_Nf-YphQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1583472463075559882=="
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

--===============1583472463075559882==
Content-Type: multipart/alternative; boundary="0000000000009853c9059b3e4986"

--0000000000009853c9059b3e4986
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

A quick question on dm-integrity. Does dm-integrity layer honors fsync?

I was testing dm-integrity and performance. It had a strange result that
using dm-integrity with journal is faster than a normal file system or
dm-integrity with bitmap (no journal). fio is used for testing the storage
performance. The device is a SATA hard disk drive. Then I created a 100GB
partition for testing.

Below is the test cases:

1) XFS on a partition directly test case

2) dm-integrity: crc32c on a partition with default setting journal commit
interval is 10 seconds. Then create XFS on it. test case

3) dm-integrity: crc32c on a partition default setting journal commit
interval set to 5 seconds. Then create XFS on it.

4) dm-integrity:  crc32c on a partition default setting but using bitmap
instead of journal. Then create XFS on it.

FIO command:

fio --filename=3D./t1 --direct=3D1 --rw=3Drandrw --refill_buffers --norando=
mmap
--randrepeat=3D0 --ioengine=3Dsync --bs=3D4k --rwmixread=3D75 --iodepth=3D1=
6
--numjobs=3D8 --runtime=3D60 --group_reporting --fsync=3D1 --name=3D4ktest
--size=3D4G

Result:

   1. Read/Write IOPS: 117/41. Read/Write Speed 481KB/s 168KB/s
   2. Read/Write IOPS: 178/59. Read/Write Speed 732KB/s 244KB/s
   3. Read/Write IOPS: 169/57. Read/Write Speed 695KB/s 236KB/s
   4. Read/Write IOPS: 97/32. Read/Write Speed 400K/s 131KB/s

The original discussion in:
https://gitlab.com/cryptsetup/cryptsetup/issues/513 . Milan Broz said the
dm-devel mailing list is a suitable place to discuss the probem.

Thanks in advance.

Patrick

--0000000000009853c9059b3e4986
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div>Hello,</div><div><br></div><div>A qu=
ick question on dm-integrity. Does dm-integrity layer honors fsync?

</div><div><br></div><div>I was testing dm-integrity and performance. It ha=
d a strange result that using dm-integrity with journal is faster than a no=
rmal file system or dm-integrity with bitmap (no journal). fio is used for =
testing the storage performance. The device is a SATA hard disk drive. Then=
 I created a 100GB partition for testing.
<p dir=3D"auto">Below is the test cases:</p><p dir=3D"auto"> 1) XFS on a pa=
rtition directly
test case</p><p dir=3D"auto">2) dm-integrity: crc32c on a partition with de=
fault setting
journal commit interval is 10 seconds. Then create XFS on it.
test case</p><p dir=3D"auto">3) dm-integrity: crc32c on a partition default=
 setting
journal commit interval set to 5 seconds. Then create XFS on it.</p><p>4) d=
m-integrity:=C2=A0
crc32c on a partition default setting but using bitmap instead of journal. =
Then create XFS on it.</p><p>FIO command:</p><p>
fio --filename=3D./t1 --direct=3D1 --rw=3Drandrw --refill_buffers --norando=
mmap --randrepeat=3D0 --ioengine=3Dsync --bs=3D4k --rwmixread=3D75 --iodept=
h=3D16 --numjobs=3D8 --runtime=3D60 --group_reporting --fsync=3D1 --name=3D=
4ktest --size=3D4G

</p><p dir=3D"auto">Result:</p>
<ol dir=3D"auto"><li>Read/Write IOPS: 117/41. Read/Write Speed 481KB/s 168K=
B/s</li><li>Read/Write IOPS: 178/59. Read/Write Speed 732KB/s 244KB/s</li><=
li>Read/Write IOPS: 169/57. Read/Write Speed 695KB/s 236KB/s</li><li>
Read/Write IOPS: 97/32. Read/Write Speed 400K/s 131KB/s</li></ol></div><div=
>The original discussion in: <a href=3D"https://gitlab.com/cryptsetup/crypt=
setup/issues/513" target=3D"_blank">https://gitlab.com/cryptsetup/cryptsetu=
p/issues/513</a> . Milan Broz said the dm-devel mailing list is a suitable =
place to discuss the probem.</div><div><br></div><div>Thanks in advance.</d=
iv><div><br></div><div>Patrick<br></div></div></div>

--0000000000009853c9059b3e4986--

--===============1583472463075559882==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1583472463075559882==--
