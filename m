From: =?GBK?B?tq266ces?= <dhongqian@163.com>
Subject: device-mapper: dm-multipath: Failing path
Date: Tue, 9 Oct 2007 18:16:10 +0800 (CST)
Message-ID: <10010466.349431191924970937.JavaMail.coremail@bj163app24.163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0618787611=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0618787611==
Content-Type: multipart/Alternative;
	boundary="----=_Part_38074_25790811.1191924970934"

------=_Part_38074_25790811.1191924970934
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit

Hi, All:     Some servers's message have the following problem: Jul 29 15:55:19 nd04 kernel: sd 0:0:3:0: SCSI error: return code = 0x20000
Jul 29 15:55:19 nd04 kernel: end_request: I/O error, dev sdc, sector 1673673255
Jul 29 15:55:19 nd04 kernel: end_request: I/O error, dev sdc, sector 1673673263
Jul 29 15:55:19 nd04 kernel: device-mapper: dm-multipath: Failing path 8:32.
Jul 29 15:55:19 nd04 multipathd: 8:32: mark as failed
Jul 29 15:55:19 nd04 multipathd: STOYOU___NetStor_DA9420F0CAC746E073C4300: Entering recovery mode: max_retries=100
Jul 29 15:55:19 nd04 multipathd: STOYOU___NetStor_DA9420F0CAC746E073C4300: remaining active paths: 0
Jul 29 15:55:20 nd04 multipathd: sdc: readsector0 checker reports path is up     The problem occurs quite often, especially when it has heavy business.        My OS is CentOS 4,     Thanks and regards                    hongqina           
------=_Part_38074_25790811.1191924970934
Content-Type: text/html; charset=gbk
Content-Transfer-Encoding: quoted-printable

<DIV>Hi, All:</DIV>
<DIV>&nbsp;&nbsp; </DIV>
<DIV>&nbsp;&nbsp; Some servers's message have the following problem:</DIV>
<DIV>&nbsp;</DIV>
<DIV>Jul 29 15:55:19 nd04 kernel: sd 0:0:3:0: SCSI error: return code =3D 0=
x20000<BR>Jul 29 15:55:19 nd04 kernel: end_request: I/O error, dev sdc, sec=
tor 1673673255<BR>Jul 29 15:55:19 nd04 kernel: end_request: I/O error, dev =
sdc, sector 1673673263<BR>Jul 29 15:55:19 nd04 kernel: device-mapper: dm-mu=
ltipath: Failing path 8:32.<BR>Jul 29 15:55:19 nd04 multipathd: 8:32: mark =
as failed<BR>Jul 29 15:55:19 nd04 multipathd: STOYOU___NetStor_DA9420F0CAC7=
46E073C4300: Entering recovery mode: max_retries=3D100<BR>Jul 29 15:55:19 n=
d04 multipathd: STOYOU___NetStor_DA9420F0CAC746E073C4300: remaining active =
paths: 0<BR>Jul 29 15:55:20 nd04 multipathd: sdc: readsector0 checker repor=
ts path is up </DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;&nbsp;&nbsp; The problem occurs quite often, especially when it =
has heavy business. </DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;&nbsp;&nbsp; </DIV>
<DIV>&nbsp;&nbsp;&nbsp; My OS is CentOS 4, </DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;&nbsp;&nbsp; Thanks and regards</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hongqina</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV><br><!-- footer --><br>
<hr>
<table width=3D"100%%" border=3D"0" cellspacing=3D"0" cellpadding=3D"0">
  <tr>
    <td width=3D"50" height=3D"50"><img src=3D"http://mimg.163.com/hd/163/1=
63footer/163footer_50.jpg" alt=3D"LOGO" width=3D"50" height=3D"50"></td>
    <td style=3D"padding:5px;"><a style=3D"font-size:12px;color:black; line=
-height:20px;text-decoration:none;" href=3D"http://popme.163.com/link/00351=
5_0929_938.html">=B0=D1=B0=AE=D0=C4=D7=A2=C8=EB=C5=A3=C4=CC=A3=AC=B9=B2=CD=
=AC=C4=FD=BE=DB=D5=E2=B7=DD=C1=A6=C1=BF</a><br /><a style=3D"font-size:12px=
;line-height:20px; color:black; text-decoration:none;" href=3D"http://popme=
163.com/link/003515_0929_938.html">=BF=EC=C0=B4=B2=CE=BC=D3=C3=C9=C5=A3=C3=
=E2=B7=D1=D4=F9=C4=CC=B0=AE=D0=C4=D0=D0=B6=AF </a></td>
  </tr>
</table>

------=_Part_38074_25790811.1191924970934--


--===============0618787611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0618787611==--
