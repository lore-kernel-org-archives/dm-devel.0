From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: Re: Rescan for new LUNs
Date: Thu, 1 Jul 2010 13:43:57 -0400
Message-ID: <230ED15F81AFD3409345FFA4E565F0E50B8B58D4@NDHV3000.na.corp.mckesson.com>
References: <230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mckesson.com>
	<4C2C3BD1.2070207@held.org.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8064771438488315099=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4C2C3BD1.2070207@held.org.il>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============8064771438488315099==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CB1944.FBD7BF3A"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CB1944.FBD7BF3A
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

That sounds more like what I am looking for. But I can not find the
script on my system or what provides it via "yum provides". I am =
running
RHEL 5.5.
=20
We have customers that run an Application that needs to be up 24*7. =
They
some times need to add additional storage and when attached to a SAN
they would prefer not to have to take the Application down and reboot
the system just to make the new LUNs be seen by the system.
-----
Jack Allen
=20


  _____ =20

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Oren Held
Sent: Thursday, July 01, 2010 2:55 AM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Rescan for new LUNs


It's not an easy process.

The rescan-scsi-bus.sh script was added in recent RHEL5 updates, =
already
in old SLES. I guess it's becoming kind of a standard.

On 07/01/10 04:00, Allen, Jack wrote:=20

Hello:=20
        What is the best way to cause the system to rescan for new =
LUNs,
other than rebooting?=20

-----=20
Jack Allen=20



--

dm-devel mailing list

dm-devel@redhat.com <mailto:dm-devel@redhat.com>=20

https://www.redhat.com/mailman/listinfo/dm-devel
<https://www.redhat.com/mailman/listinfo/dm-devel>=20



------_=_NextPart_001_01CB1944.FBD7BF3A
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>

<META name=3DGENERATOR content=3D"MSHTML 8.00.6001.18928"></HEAD>
<BODY bgColor=3D#ffffff text=3D#000000>
<DIV dir=3Dltr align=3Dleft><FONT color=3D#800000 size=3D2 =
face=3DArial><SPAN=20
class=3D145183817-01072010>That sounds more like what I am looking for. =
But I can=20
not find the script on my system or what provides it via "yum =
provides". I am=20
running RHEL 5.5.</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT color=3D#800000 size=3D2 =
face=3DArial><SPAN=20
class=3D145183817-01072010></SPAN></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT color=3D#800000 size=3D2 =
face=3DArial><SPAN=20
class=3D145183817-01072010>We have customers that run an Application =
that needs to=20
be up 24*7. They some times need to add additional storage and when =
attached to=20
a SAN they would prefer not to have to take the Application down and =
reboot the=20
system just to make the new LUNs be seen by the =
system.</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT color=3D#800000 size=3D2 =
face=3DArial><SPAN=20
class=3D145183817-01072010>-----</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT color=3D#800000 size=3D2 =
face=3DArial><SPAN=20
class=3D145183817-01072010>Jack Allen</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT color=3D#800000 size=3D2 =
face=3DArial><SPAN=20
class=3D145183817-01072010></SPAN></FONT>&nbsp;</DIV><FONT =
color=3D#800000 size=3D2=20
face=3DArial></FONT><FONT color=3D#800000 size=3D2 =
face=3DArial></FONT><FONT=20
color=3D#800000 size=3D2 face=3DArial></FONT><FONT color=3D#800000 =
size=3D2=20
face=3DArial></FONT><BR>
<DIV dir=3Dltr lang=3Den-us class=3DOutlookMessageHeader align=3Dleft>
<HR tabIndex=3D-1>
<FONT size=3D2 face=3DTahoma><B>From:</B> dm-devel-bounces@redhat.com=20
[mailto:dm-devel-bounces@redhat.com] <B>On Behalf Of </B>Oren=20
Held<BR><B>Sent:</B> Thursday, July 01, 2010 2:55 AM<BR><B>To:</B>=20
dm-devel@redhat.com<BR><B>Subject:</B> Re: [dm-devel] Rescan for new=20
LUNs<BR></FONT><BR></DIV>
<DIV></DIV>It's not an easy process.<BR><BR>The rescan-scsi-bus.sh =
script was=20
added in recent RHEL5 updates, already in old SLES. I guess it's =
becoming kind=20
of a standard.<BR><BR>On 07/01/10 04:00, Allen, Jack wrote:=20
<BLOCKQUOTE=20
cite=3Dmid:230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mck=
esson.com=20
type=3D"cite">
  <META name=3DGenerator content=3D"MS Exchange Server version =
6.5.7655.4"><!-- Converted from text/rtf format -->
  <P><FONT size=3D2 face=3DArial>Hello:</FONT>=20
  <BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT size=3D2 =
face=3DArial>What is=20
  the best way to cause the system to rescan for new LUNs, other than=20
  rebooting?</FONT> </P>
  <P><FONT size=3D2 face=3DArial>-----</FONT> <BR><FONT size=3D2 =
face=3DArial>Jack=20
  Allen</FONT> </P><PRE wrap=3D""><FIELDSET =
class=3DmimeAttachmentHeader></FIELDSET>
--
dm-devel mailing list
<A class=3Dmoz-txt-link-abbreviated =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</A>
<A class=3Dmoz-txt-link-freetext =
href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.re=
dhat.com/mailman/listinfo/dm-devel</A></PRE></BLOCKQUOTE><BR></BODY></HT=
ML>

------_=_NextPart_001_01CB1944.FBD7BF3A--


--===============8064771438488315099==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8064771438488315099==--
