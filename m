From: "Charlie Sharkey" <charlie.sharkey@bustech.com>
Subject: Suse sles10 SP1 -> SP2 update question
Date: Tue, 6 Jan 2009 15:56:59 -0500
Message-ID: <03FB5D708BE3C8448E8079186A56CDE60104231E@BTIBURMAIL.bustech.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1351431950=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

This is a multi-part message in MIME format.

--===============1351431950==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C97041.51A2BAAE"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C97041.51A2BAAE
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=20
I'm not sure if this is the correct place for this question or not.
If not, please let me know.
=20
After updating my Suse Sles10 SP1 system  (2.6.16.46-0.12-smp) with the
kernel rpm from SP2 (2.6.16.60-0.21-smp) devices that mounted (by label)
are mounting as non multipathed devices. For example, a device that
previously
mounted as:  /dev/dm-5  now mounts as:  /dev/sdj1 =20
=20
The devices mount ok, they're just not mounting as multipathed devices.=20
If I reboot, there is about a one in five chance that they will mount
ok.
=20
I have tried updating the rpms that I thought might be needed by the new
kernel, but
haven't been able to correct the problem. I've updated the following
rpms:
=20
    util-linux, util-linux-crypto, scsi, multipath-tools, device-mapper,
udev, lvm2
=20
Are there other dependencies that the device mapper needs for mounting ?
=20
Thank you,
=20
charlie

------_=_NextPart_001_01C97041.51A2BAAE
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.6000.16788" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>I'm =
not sure if this=20
is the correct place for this question or not.</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>If =
not, please let=20
me know.</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>After =
updating my=20
Suse Sles10 SP1 system&nbsp;&nbsp;(2.6.16.46-0.12-smp) with=20
the</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>kernel =
rpm from SP2=20
(2.6.16.60-0.21-smp) devices that mounted (by label)</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>are =
mounting&nbsp;as=20
non multipathed devices. For example, a device that=20
previously</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial =
size=3D2>mounted as:=20
&nbsp;/dev/dm-5&nbsp; now mounts as:&nbsp; /dev/sdj1&nbsp; =
</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>The=20
devices&nbsp;mount ok,</FONT></SPAN><SPAN =
class=3D018363720-06012009><FONT=20
face=3DArial size=3D2> they're just not mounting as multipathed devices. =

</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>If I =
reboot, there=20
is about a </FONT></SPAN><SPAN class=3D018363720-06012009><FONT =
face=3DArial=20
size=3D2>one </FONT></SPAN><SPAN class=3D018363720-06012009><FONT =
face=3DArial=20
size=3D2>in five chance that they will mount ok.</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>I have =
tried=20
updating the rpms that I thought might be needed by the new kernel,=20
but</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial =
size=3D2>haven't been able to=20
correct the problem. I've updated the following =
rpms:</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;=20
util-linux, util-linux-crypto, scsi, multipath-tools, device-mapper, =
udev,=20
lvm2</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>Are =
there other=20
dependencies that the device mapper needs for mounting =
?</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial size=3D2>Thank=20
you,</FONT></SPAN></DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D018363720-06012009><FONT face=3DArial=20
size=3D2>charlie</FONT></SPAN></DIV></BODY></HTML>

------_=_NextPart_001_01C97041.51A2BAAE--


--===============1351431950==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1351431950==--
