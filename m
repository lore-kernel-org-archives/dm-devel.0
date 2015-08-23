From: "Ni, Xun" <xun.ni@intel.com>
Subject: A small question about Device Mapper
Date: Sun, 23 Aug 2015 07:29:53 +0000
Message-ID: <91E2D863603AD4478F101CE81E76E45D01D2D23C@SHSMSX103.ccr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6266781387958158037=="
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

--===============6266781387958158037==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_91E2D863603AD4478F101CE81E76E45D01D2D23CSHSMSX103ccrcor_"

--_000_91E2D863603AD4478F101CE81E76E45D01D2D23CSHSMSX103ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, all:

I use device mapper to config a thin-provision for a block device, with dms=
etup, with the following command:

Dmsetup create pool -table "0 `blockdev -getsize /dev/sdd1` thin-pool /dev/=
sdd2 /dev/sdd1 128 0"
Dmsetup message /dev/mapper/pool 0 "create_thin 0"
Dmsetup create snap1 -tabe "0 `blockdev -getsize /dev/sdd3` thin /dev/mappe=
r/pool 0 /dev/sdd3"

Everything works well, but when I reboot the system, the block device is go=
ne, I need to create the pool again...

Anyone has idea on how to make this config persistent?  I need to boot the =
kernel , the dm pool device shows after the MD device found.

Thanks,
Xun


--_000_91E2D863603AD4478F101CE81E76E45D01D2D23CSHSMSX103ccrcor_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">
<div>Hi, all:</div>
<div>&nbsp;</div>
<div style=3D"text-indent:9.6pt;">I use device mapper to config a thin-prov=
ision for a block device, with dmsetup, with the following command:</div>
<div style=3D"text-indent:9.6pt;">&nbsp;</div>
<div style=3D"text-indent:9.6pt;">Dmsetup create pool &#8211;table &#8220;0=
 `blockdev &#8211;getsize /dev/sdd1` thin-pool /dev/sdd2 /dev/sdd1 128 0&#8=
221;</div>
<div style=3D"text-indent:9.6pt;">Dmsetup message /dev/mapper/pool 0 &#8220=
;create_thin 0&#8221;</div>
<div style=3D"text-indent:9.6pt;">Dmsetup create snap1 &#8211;tabe &#8220;0=
 `blockdev &#8211;getsize /dev/sdd3` thin /dev/mapper/pool 0 /dev/sdd3&#822=
1;</div>
<div style=3D"text-indent:9.6pt;">&nbsp;</div>
<div style=3D"text-indent:9.6pt;">Everything works well, but when I reboot =
the system, the block device is gone, I need to create the pool again&#8230=
;</div>
<div style=3D"text-indent:9.6pt;">&nbsp;</div>
<div style=3D"text-indent:9.6pt;">Anyone has idea on how to make this confi=
g persistent?&nbsp; I need to boot the kernel , the dm pool device shows af=
ter the MD device found.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>Thanks,</div>
<div>Xun </div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
</span></font>
</body>
</html>

--_000_91E2D863603AD4478F101CE81E76E45D01D2D23CSHSMSX103ccrcor_--


--===============6266781387958158037==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6266781387958158037==--
