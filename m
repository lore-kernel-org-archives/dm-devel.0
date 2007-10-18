From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: multibus / failover and EMC CX600
Date: Thu, 18 Oct 2007 10:07:59 +0200
Message-ID: <06e001c8115d$ffd7e9b0$0a00a8c0@ALDI2>
References: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2><20071018061907.GA22562@pentland.suse.de><06cf01c81153$eca36c70$0a00a8c0@ALDI2>
	<20071018071244.GB22562@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_06DC_01C8116E.C311FD70"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------=_NextPart_000_06DC_01C8116E.C311FD70
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_06DD_01C8116E.C311FD70"


------=_NextPart_001_06DD_01C8116E.C311FD70
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hannes,

nothing that looks really bedrohlich in the syslog.

What I have done:

9:47 multipathd -v 6 started
9:50 2:0:0:0 and 1:0:1:0 blocked (both paths to SP-A of the SAN)
9:52 2:0:0:0 and 1:0:1:0 re-enabled

I have attached my syslog.

I am on a gentoo with multipath 0.4.7=20

(Gerald)
  ----- Original Message -----=20
  From: Hannes Reinecke=20
  To: device-mapper development=20
  Sent: Thursday, October 18, 2007 9:12 AM
  Subject: Re: [dm-devel] multibus / failover and EMC CX600


  On Thu, Oct 18, 2007 at 08:55:52AM +0200, Gerald Nowitzky wrote:
  > Hannes,
  >=20
  > so is this behavior by design? In this case, patching in the scsi =
subsystem won't
  > help to much, will it?
  >
  No, not really.
  =20
  > Manually updating the multipath information - well, yes, that will =
work I guess,
  > but in the end that should work without manual intervention. Thus, =
I'd need to have
  > a job checking the multipath table if there are stale devices, and, =
if there are,
  > rerun multipath to get them out. Not exactly smooth, is it?
  >
  Why, we do have interns for this kind of work :-)

  No, really: Normally this should be done by multipathd / udev. With =
the mainline
  multipathd it reads from the kernel netlink socket and will get a =
uevent if
  a device is removed. And it should update the tables accordingly.

  There have been problems with device-mapper itself (older versions =
required to
  flush all outstanding I/O before the table could be modified), but =
that should
  be resolved by now.

  So maybe have multipathd running in verbose mode (ie -v 6 or somesuch) =
and see
  what's going on. Especially why it isn't updating the device-mapper =
tables.

  BTW, which distribution are you running? multipath & udev seem to be a =
tricky
  area for most.

  Not ours, of course :-)

  Cheers,

  Hannes
  --=20
  Dr. Hannes Reinecke       zSeries & Storage
  hare@suse.de       +49 911 74053 688
  SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nrnberg
  GF: Markus Rex, HRB 16746 (AG Nrnberg)

  --
  dm-devel mailing list
  dm-devel@redhat.com
  https://www.redhat.com/mailman/listinfo/dm-devel
------=_NextPart_001_06DD_01C8116E.C311FD70
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=EF=BB=BF<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8">
<META content=3D"MSHTML 6.00.2900.2802" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hannes,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>nothing that looks really bedrohlich in =
the=20
syslog.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>What I have done:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>9:47 multipathd -v 6 =
started</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>9:50 2:0:0:0 and 1:0:1:0 blocked (both =
paths to=20
SP-A of the SAN)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>9:52 2:0:0:0 and 1:0:1:0 =
re-enabled</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I have attached my syslog.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am on a gentoo with multipath 0.4.7 =
</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>(Gerald)</FONT></DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Dhare@suse.de href=3D"mailto:hare@suse.de">Hannes =
Reinecke</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Ddm-devel@redhat.com=20
  href=3D"mailto:dm-devel@redhat.com">device-mapper development</A> =
</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Thursday, October 18, =
2007 9:12=20
  AM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [dm-devel] =
multibus /=20
  failover and EMC CX600</DIV>
  <DIV><BR></DIV>On Thu, Oct 18, 2007 at 08:55:52AM +0200, Gerald =
Nowitzky=20
  wrote:<BR>&gt; Hannes,<BR>&gt; <BR>&gt; so is this behavior by design? =
In this=20
  case, patching in the scsi subsystem won't<BR>&gt; help to much, will=20
  it?<BR>&gt;<BR>No, not really.<BR>&nbsp;<BR>&gt; Manually updating the =

  multipath information - well, yes, that will work I guess,<BR>&gt; but =
in the=20
  end that should work without manual intervention. Thus, I'd need to=20
  have<BR>&gt; a job checking the multipath table if there are stale =
devices,=20
  and, if there are,<BR>&gt; rerun multipath to get them out. Not =
exactly=20
  smooth, is it?<BR>&gt;<BR>Why, we do have interns for this kind of =
work=20
  :-)<BR><BR>No, really: Normally this should be done by multipathd / =
udev. With=20
  the mainline<BR>multipathd it reads from the kernel netlink socket and =
will=20
  get a uevent if<BR>a device is removed. And it should update the =
tables=20
  accordingly.<BR><BR>There have been problems with device-mapper itself =
(older=20
  versions required to<BR>flush all outstanding I/O before the table =
could be=20
  modified), but that should<BR>be resolved by now.<BR><BR>So maybe have =

  multipathd running in verbose mode (ie -v 6 or somesuch) and =
see<BR>what's=20
  going on. Especially why it isn't updating the device-mapper=20
  tables.<BR><BR>BTW, which distribution are you running? multipath =
&amp; udev=20
  seem to be a tricky<BR>area for most.<BR><BR>Not ours, of course=20
  :-)<BR><BR>Cheers,<BR><BR>Hannes<BR>-- <BR>Dr. Hannes Reinecke=20
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zSeries &amp; Storage<BR><A=20
  href=3D"mailto:hare@suse.de">hare@suse.de</A> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +49=20
  911 74053 688<BR>SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 =
Nrnberg<BR>GF:=20
  Markus Rex, HRB 16746 (AG Nrnberg)<BR><BR>--<BR>dm-devel mailing =
list<BR><A=20
  href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</A><BR><A=20
  =
href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.red=
hat.com/mailman/listinfo/dm-devel</A></BLOCKQUOTE></BODY></HTML>

------=_NextPart_001_06DD_01C8116E.C311FD70--

------=_NextPart_000_06DC_01C8116E.C311FD70
Content-Type: application/x-zip-compressed;
	name="syslog.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="syslog.zip"

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

------=_NextPart_000_06DC_01C8116E.C311FD70
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_06DC_01C8116E.C311FD70--
