From: Swastik Das <swastik.das@hotmail.com>
Subject: FW: Buffer I/O error on access lun.....
Date: Wed, 18 May 2011 10:35:48 +0530
Message-ID: <SNT103-W4709DE47195BA9FC3AE237F78F0@phx.gbl>
References: <SNT103-W30FCF7207FB3E8C606C309F7840@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8850364034421129202=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <SNT103-W30FCF7207FB3E8C606C309F7840@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel-request@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8850364034421129202==
Content-Type: multipart/alternative;
	boundary="_5fd287e3-52d5-458c-bbdc-f3eb9594b3b9_"

--_5fd287e3-52d5-458c-bbdc-f3eb9594b3b9_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable





Dear Team=2C
I mapped a Dell MD3200i iSCSI storage to one linux host(RHEL 5.5 64bit).Als=
o i did the following configuration.
1)Use the iscsid.conf from the Dell MDSM CD and modify it with the iSCSI IP=
s of the array=20
2) Install the Agent portion of the MDSM software from the MDSM cd.
3) Install the Linux RDAC (multipath) driver from the MDSM CD as well.
=20
But still during os booting i'm getting the following error.
=20
SCSI device sdc:409601 512-byte hdwr sectors (21MB)
sdc:write Protect is off
SCSI device sdc:drivr cache: write through w/ FUA
SCSI device sdc:409601 512-byte hdwr sectors (21MB)
sdc:write Protect is off
SCSI device sdc:drivr cache: write through w/ FUA
sd 5:0:0:31: Attached scsi disk sdc
sd 5:0:0:31: Attached scsi generic sg3 type 0
end_request: I/O error=2C dev sdc=2C sector 40
 Buffer I/O error on device sdc=2C logical block 5
 Buffer I/O error on device sdc=2C logical block 6
 Buffer I/O error on device sdc=2C logical block 7
Buffer I/O error on device sdc=2C logical block 8
Buffer I/O error on device sdc=2C logical block 9
 Buffer I/O error on device sdc=2C logical block 10
 Buffer I/O error on device sdc=2C logical block 11=20
Buffer I/O error on device sdc=2C logical block 12
Buffer I/O error on device sdc=2C logical block 13
 Buffer I/O error on device sdc=2C logical block 14=20
=20
Here "sdc" is the access lun(ghost lun) which is a write protected lun used=
 for managing inbound communication between host & storage.I want to remove=
 this error/Kernel should n't check this lun/blacklist this Lun or will mak=
e the access lun 31 not appear as a SD devices it will only show as a SG de=
vices so that this message will not appear during OS booting

=20

Pls suggest.
=20
Thanks in Advance...

Swastik Das
IM:+91-9007000384






 		 	   		  =

--_5fd287e3-52d5-458c-bbdc-f3eb9594b3b9_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Tahoma
}
--></style>
</head>
<body class=3D'hmmessage'>

<META name=3DGenerator content=3D"Microsoft SafeHTML">
<STYLE>
.ExternalClass .ecxhmmessage P
{padding:0px=3B}
.ExternalClass body.ecxhmmessage
{font-size:10pt=3Bfont-family:Tahoma=3B}

</STYLE>
Dear Team=2C<BR>I mapped a Dell MD3200i&nbsp=3BiSCSI storage to&nbsp=3Bone =
linux host(RHEL 5.5 64bit).Also i did the following configuration.<BR>
1)Use the iscsid.conf from the Dell MDSM CD and modify it with the&nbsp=3Bi=
SCSI&nbsp=3BIPs of the array&nbsp=3B<BR>
2) Install&nbsp=3Bthe Agent portion of the MDSM software from the MDSM cd.<=
BR>
3) Install the Linux RDAC (multipath) driver from the MDSM CD as well.<BR>
&nbsp=3B<BR>
But still during os booting i'm getting the following error.<BR>
&nbsp=3B<BR>
<FONT color=3D#c00000>SCSI device sdc:409601 512-byte hdwr sectors (21MB)</=
FONT><BR>
<FONT color=3D#c00000>sdc:write Protect is off</FONT><BR>
<FONT color=3D#c00000>SCSI device sdc:drivr cache: write through w/ FUA</FO=
NT><BR>
<FONT color=3D#c00000>SCSI device sdc:409601 512-byte hdwr sectors (21MB)</=
FONT><BR>
<FONT color=3D#c00000>sdc:write Protect is off</FONT><BR>
<FONT color=3D#c00000>SCSI device sdc:drivr cache: write through w/ FUA</FO=
NT><BR>
<FONT color=3D#c00000>sd 5:0:0:31: Attached scsi disk sdc</FONT><BR>
<FONT color=3D#c00000>sd 5:0:0:31: Attached scsi generic sg3 type 0</FONT><=
BR>
<FONT color=3D#c00000>end_request: I/O error=2C dev sdc=2C sector 40<BR>&nb=
sp=3BBuffer I/O error on device sdc=2C logical block&nbsp=3B5<BR>&nbsp=3BBu=
ffer I/O error on device sdc=2C logical block&nbsp=3B6<BR>&nbsp=3BBuffer I/=
O error on device sdc=2C logical block 7<BR>Buffer I/O error on device sdc=
=2C logical block 8<BR>Buffer I/O error on device sdc=2C logical block&nbsp=
=3B9<BR>&nbsp=3BBuffer I/O error on device sdc=2C logical block&nbsp=3B10<B=
R>&nbsp=3BBuffer I/O error on device sdc=2C logical block 11 </FONT><BR>
<FONT color=3D#c00000>Buffer I/O error on device sdc=2C logical block 12<BR=
>Buffer I/O error on device sdc=2C logical block&nbsp=3B13<BR>&nbsp=3BBuffe=
r I/O error on device sdc=2C logical block 14 </FONT><BR>
&nbsp=3B<BR>
Here&nbsp=3B"sdc" is the access lun(<SPAN style=3D"FONT-FAMILY: 'Calibri'=
=2C'sans-serif'=3B COLOR: black=3B FONT-SIZE: 11pt">ghost lun) which is a w=
rite protected lun used for managing inbound communication between&nbsp=3Bh=
ost &amp=3B storage.<FONT color=3D#e36c09>I want to remove this error/Kerne=
l should n't check this lun/blacklist this Lun or </FONT><FONT color=3D#000=
000>will make the access lun 31 not appear as a SD devices it will only sho=
w as a SG devices so that this message will not appear during OS booting</F=
ONT></SPAN><BR>
<STRONG></STRONG><BR>&nbsp=3B<BR>
<BR><SPAN style=3D"FONT-FAMILY: 'Calibri'=2C'sans-serif'=3B COLOR: black=3B=
 FONT-SIZE: 11pt">Pls suggest.</SPAN><BR><SPAN style=3D"FONT-FAMILY: 'Calib=
ri'=2C'sans-serif'=3B COLOR: black=3B FONT-SIZE: 11pt"></SPAN>&nbsp=3B<BR><=
SPAN style=3D"FONT-FAMILY: 'Calibri'=2C'sans-serif'=3B COLOR: black=3B FONT=
-SIZE: 11pt">Thanks in Advance...</SPAN><FONT color=3D#c00000 face=3D"Comic=
 Sans MS"><B><FONT color=3D#00b050 face=3D"Courier New"><FONT color=3D#0020=
60><BR></FONT></FONT></B></FONT><BR><FONT color=3D#c00000 face=3D"Comic San=
s MS"><B><FONT color=3D#00b050 face=3D"Courier New"><FONT color=3D#002060>S=
wastik Das<BR>IM:+91-9007000384<BR></FONT><BR><BR></FONT></B></FONT><BR><BR=
><BR><BR><BR> 		 	   		  </body>
</html>=

--_5fd287e3-52d5-458c-bbdc-f3eb9594b3b9_--


--===============8850364034421129202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8850364034421129202==--
