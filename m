From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: multibus / failover and EMC CX600
Date: Thu, 18 Oct 2007 08:55:52 +0200
Message-ID: <06cf01c81153$eca36c70$0a00a8c0@ALDI2>
References: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
	<471631E5.9050603@linpro.no><068301c810e8$1f4e6e70$0a00a8c0@ALDI2>
	<20071018061907.GA22562@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0471931887=="
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

--===============0471931887==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_06CC_01C81164.AFDDA740"

This is a multi-part message in MIME format.

------=_NextPart_000_06CC_01C81164.AFDDA740
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hannes,

so is this behavior by design? In this case, patching in the scsi =
subsystem won't help to much, will it?

Manually updating the multipath information - well, yes, that will work =
I guess, but in the end that should work without manual intervention. =
Thus, I'd need to have a job checking the multipath table if there are =
stale devices, and, if there are, rerun multipath to get them out. Not =
exactly smooth, is it?

Thanks
(Gerald)
  ----- Original Message -----=20
  From: Hannes Reinecke=20
  To: device-mapper development=20
  Sent: Thursday, October 18, 2007 8:19 AM
  Subject: Re: [dm-devel] multibus / failover and EMC CX600


  On Wed, Oct 17, 2007 at 08:04:12PM +0200, Gerald Nowitzky wrote:
  > I'm afraid the patch did not work for me. I'ts still the same.
  >=20
  > I am using kernel 2.6.22.2 at the moment. Should I upgrade to 2.6.23 =
?
  >=20
  > Anybody any Ideas?
  > The system is not in production at the moment. We could do some =
testing.
  >=20
  Well, yes. By the looks of if the problem is with multipathing still =
holding
  references to the stale devices.
  IE after dev_loss_tmo kicks in, the devices are removed from sysfs.
  But multipathing does _not_ update it's device-mapper tables (that's =
why
  you see all the '#' in the output), so there's still a refence on the
  removed device and the in-kernel resources can't be freed.

  So when the device is re-registered, you're getting this Oops.

  Try to update the multipath information by running 'multipath' after =
the
  devices have been removed. Once the '#' in the output are gone, you =
can
  savely re-add the devices.

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
------=_NextPart_000_06CC_01C81164.AFDDA740
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
<DIV><FONT face=3DArial size=3D2>so is this behavior&nbsp;by design? In =
this case,=20
patching in the scsi subsystem won't help to much, will it?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Manually updating the multipath =
information - well,=20
yes, that will work I guess, but in the end that should work without =
manual=20
intervention. Thus, I'd need to have a job checking the multipath table =
if there=20
are stale devices, and, if there are, rerun multipath to get them out. =
Not=20
exactly smooth, is it?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thanks</FONT></DIV>
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
2007 8:19=20
  AM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [dm-devel] =
multibus /=20
  failover and EMC CX600</DIV>
  <DIV><FONT face=3DArial size=3D2></FONT><FONT face=3DArial=20
  size=3D2></FONT><BR></DIV>On Wed, Oct 17, 2007 at 08:04:12PM +0200, =
Gerald=20
  Nowitzky wrote:<BR>&gt; I'm afraid the patch did not work for me. I'ts =
still=20
  the same.<BR>&gt; <BR>&gt; I am using kernel 2.6.22.2 at the moment. =
Should I=20
  upgrade to 2.6.23 ?<BR>&gt; <BR>&gt; Anybody any Ideas?<BR>&gt; The =
system is=20
  not in production at the moment. We could do some testing.<BR>&gt; =
<BR>Well,=20
  yes. By the looks of if the problem is with multipathing still=20
  holding<BR>references to the stale devices.<BR>IE after dev_loss_tmo =
kicks in,=20
  the devices are removed from sysfs.<BR>But multipathing does _not_ =
update it's=20
  device-mapper tables (that's why<BR>you see all the '#' in the =
output), so=20
  there's still a refence on the<BR>removed device and the in-kernel =
resources=20
  can't be freed.<BR><BR>So when the device is re-registered, you're =
getting=20
  this Oops.<BR><BR>Try to update the multipath information by running=20
  'multipath' after the<BR>devices have been removed. Once the '#' in =
the output=20
  are gone, you can<BR>savely re-add the=20
  devices.<BR><BR>Cheers,<BR><BR>Hannes<BR>-- <BR>Dr. Hannes Reinecke=20
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

------=_NextPart_000_06CC_01C81164.AFDDA740--


--===============0471931887==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0471931887==--
