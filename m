From: "Ben El Hadj, Sami" <Sami.Benelhadj@fujitsu-siemens.com>
Subject: Multipathing.
Date: Wed, 11 Jun 2008 15:06:37 +0200
Message-ID: <F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFE@ABGEX70E.FSC.NET>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0153124249=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: fr-FR
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0153124249==
Content-Language: fr-FR
Content-Type: multipart/alternative;
	boundary="_000_F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFEABGEX70EFSCNE_"

--_000_F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFEABGEX70EFSCNE_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dear all,

We want to implement Multipathing under linux redhat x86-64 AS U5 and two F=
C Emulex HBA LPe1150 and LPe11002

we installed the following drivers : 8.0.16.40<linux_26_0.jsp>

We applied the following steps to configurer MPIO:
*       configure /etc/modprobe.conf
*       make a new ramdisk
*       edit and change the etc/multipath.conf
*       multipathd start
*       multipath -v2
*       enable MPIO at boot
*       multipath -v0
*       multipathd restart
*       multipath -v2

under /dev/mapper we can find two devices VolGroup00-LogVol00  and  VolGrou=
p00-LogVol01 but multipath -ll oes not show any output
can you please advise ?
best regards


--_000_F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFEABGEX70EFSCNE_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Arial, sans-serif" size=3D"2">
<div>Dear all,</div>
<div>&nbsp;</div>
<div>We want to implement Multipathing under linux redhat x86-64 AS U5 and =
two FC Emulex HBA LPe1150 and LPe11002</div>
<div style=3D"margin-top: 5pt; margin-bottom: 5pt; ">we installed the follo=
wing drivers : <a href=3D"linux_26_0.jsp"><font face=3D"Times New Roman, se=
rif" size=3D"3" color=3D"#0000FF"><u><b>8.0.16.40</b></u></font></a><font f=
ace=3D"Times New Roman, serif" size=3D"3"> </font></div>
<div><font face=3D"Times New Roman, serif" size=3D"3">&nbsp;</font></div>
<div>We applied the following steps to configurer MPIO:</div>
<ul style=3D"margin-top: 0pt; margin-bottom: 0pt; margin-left: 19pt; ">
<li>configure /etc/modprobe.conf</li><li>make a new ramdisk</li><li>edit an=
d change the etc/multipath.conf</li><li>multipathd start</li><li>multipath =
-v2</li><li>enable MPIO at boot</li><li>multipath -v0</li><li>multipathd re=
start</li><li>multipath -v2</li></ul>
<div>&nbsp;</div>
<div>under /dev/mapper we can find two devices VolGroup00-LogVol00&nbsp; an=
d&nbsp; VolGroup00-LogVol01 but multipath -ll oes not show any output</div>
<div>can you please advise ? </div>
<div>best regards</div>
<div>&nbsp;</div>
</font>
</body>
</html>

--_000_F827A1300CC73247B0255EEEA5FFFB3BCA0A8AFCFEABGEX70EFSCNE_--


--===============0153124249==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0153124249==--
