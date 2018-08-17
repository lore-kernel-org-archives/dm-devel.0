From: =?UTF-8?Q?J=C3=B6rg_Diederich?= <joerg.diederich@mailbox.org>
Subject: dm raid1,
 component device size check seem to fail at 32bit arch at >4byte
 values
Date: Fri, 17 Aug 2018 09:27:32 +0200 (CEST)
Message-ID: <1024651684.2843.1534490852300@office.mailbox.org>
Reply-To: =?UTF-8?Q?J=C3=B6rg_Diederich?= <joerg.diederich@mailbox.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0340604769312788643=="
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

--===============0340604769312788643==
Content-Type: multipart/alternative;
	boundary="----=_Part_2842_2008408988.1534490852295"

------=_Part_2842_2008408988.1534490852295
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hello,
some hours i have looked for any changes and issues existing to this alread=
y, but did not found any. which is hopefully correct.

PATCH V2 12/12 (2017-12-08 10:59:57 -050) introduced
_check_data_dev_sectors in raid.c

Calculation in there uses
to_sector(unsigned long n)

of a loff_t value returned by used i_size_read routine. Which is a long lon=
g type afaik. At a LP32 system, this results in a wrong value and intended =
check fails, which is expected to be wrong. At LP64, it should work of cour=
se. See example values at a used system (arm 32bit, 862GB raid1) below.

I might be wrong, if there is, may you please provide a hint to me how to p=
roceed here? Currently, there's no perfect patch available here, just start=
ed investigating the source due to this behavior.

Thanks a lot & regards,
J=C3=B6rg


the said example,at system

Linux gonzales 4.18.0-gentoo #3 SMP PREEMPT Wed Aug 15 15:33:45 CEST 2018 a=
rmv7l ARMv7 Processor rev 3 (v7l) SAMSUNG EXYNOS (Flattened Device Tree) GN=
U/Linux

the outputs i'd added
[ 49.004135] device-mapper: raid: _check_data_dev_sectors
[ 49.004149] device-mapper: raid: sizeof(sector_t) 8
[ 49.004161] device-mapper: raid: sizeof(unsigned long) 4
[ 49.004206] device-mapper: raid: md.dev_sectors 1809793024, that is 926614=
028288 bytes
[ 49.004242] device-mapper: raid: rdev->sectors 1809793024, that is 9266140=
28288 bytes
[ 49.004317] device-mapper: raid: i_size_read(rdev->bdev->bd_inode) returns=
 926614028288
[ 49.004327] device-mapper: raid: i_size_read(rdev->bdev->bd_inode) >> 9 is=
 1809793024
[ 49.004337] device-mapper: raid: to_sector(i_size_read(rdev->bdev->bd_inod=
e)) returns 6242304
[ 49.004346] device-mapper: raid: ds is 6242304
[ 49.004356] device-mapper: raid: Error

------=_Part_2842_2008408988.1534490852295
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html><head>
    <meta charset=3D"UTF-8">
</head><body><p class=3D"default-style">hello,<br>some hours i have looked =
for any changes and issues existing to this already, but did not found any.=
 which is hopefully correct.<br> <br>PATCH V2 12/12 (2017-12-08 10:59:57 -0=
50) introduced<br>_check_data_dev_sectors in raid.c</p><p class=3D"default-=
style">Calculation in there uses<br>to_sector(unsigned long n)</p><p class=
=3D"default-style">of a loff_t value returned by  used i_size_read routine.=
 Which is a long long type afaik. At a LP32 system, this results in a wrong=
 value and intended check fails, which is expected to be wrong. At LP64, it=
 should work of course. See example values at a used system (arm 32bit, 862=
GB raid1) below.</p><p class=3D"default-style">I might be wrong, if there i=
s, may you please provide a hint to me how to proceed here? Currently, ther=
e&#39;s no perfect patch available here, just started investigating the sou=
rce due to this behavior.</p><p class=3D"default-style">Thanks a lot &#38; =
regards,<br>J&#246;rg</p><p class=3D"default-style"><br>the said example,at=
 system<br></p><p class=3D"default-style">Linux gonzales 4.18.0-gentoo #3 S=
MP PREEMPT Wed Aug 15 15:33:45 CEST 2018 armv7l ARMv7 Processor rev 3 (v7l)=
 SAMSUNG EXYNOS (Flattened Device Tree) GNU/Linux</p><p class=3D"default-st=
yle">the outputs i&#39;d added<br>[ 49.004135] device-mapper: raid: _check_=
data_dev_sectors<br>[ 49.004149] device-mapper: raid: sizeof(sector_t) 8<br=
>[ 49.004161] device-mapper: raid: sizeof(unsigned long) 4<br>[ 49.004206] =
device-mapper: raid: md.dev_sectors 1809793024, that is 926614028288 bytes<=
br>[ 49.004242] device-mapper: raid: rdev-&#62;sectors 1809793024, that is =
926614028288 bytes<br>[ 49.004317] device-mapper: raid: i_size_read(rdev-&#=
62;bdev-&#62;bd_inode) returns 926614028288<br>[ 49.004327] device-mapper: =
raid: i_size_read(rdev-&#62;bdev-&#62;bd_inode) &#62;&#62; 9 is 1809793024<=
br>[ 49.004337] device-mapper: raid: to_sector(i_size_read(rdev-&#62;bdev-&=
#62;bd_inode)) returns 6242304<br>[ 49.004346] device-mapper: raid: ds is 6=
242304<br>[ 49.004356] device-mapper: raid: Error<br></p></body></html>
=20
------=_Part_2842_2008408988.1534490852295--


--===============0340604769312788643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0340604769312788643==--
