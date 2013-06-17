From: "Praveen Dhanasekaran - PTI" <praveend@promise.com>
Subject: Re: kernel crash with multipath-tools v0.4.7
Date: Mon, 17 Jun 2013 01:56:54 -0700
Message-ID: <975E8BE292621F4CA5B67883EB72497A03C25987@nonamew.ptu.promise.com>
References: <975E8BE292621F4CA5B67883EB72497A03C2597E@nonamew.ptu.promise.com>
	<51B98212.3070903@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5933384803187340275=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============5933384803187340275==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CE6B38.CA6BC5C6"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CE6B38.CA6BC5C6
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Dr. Hannes,=20
=20
   Thanks for your reply. We are trying to help a customer on this issue =
who want to use our RAID storage to=20
store video files. The customer is using a special Video =
Capture/Encoding hardware and Video workflow=20
supported only for kernel 2.6.26. The vendor of this video solution is =
no longer there and has closed down.=20
The customer has spent more than $300K on this proprietary video =
solution that they cannot move to the=20
latest kernel and is stuck with it.=20
=20
   Since updating the kernel is not possible, somehow I want to provide =
a targeted workaround for this issue.=20
=20
Thanks,
Praveen
=20

________________________________

From: Hannes Reinecke [mailto:hare@suse.de]
Sent: Thu 6/13/2013 1:25 AM
To: device-mapper development
Cc: Praveen Dhanasekaran - PTI; Mohan Rowlands - PTU; Manoj Mathew - =
PTU; Nagendra Vadlakunta - PTU
Subject: Re: [dm-devel] kernel crash with multipath-tools v0.4.7



On 06/12/2013 01:03 PM, Praveen Dhanasekaran - PTI wrote:
> Hello All,
>=20
> I have a RAID storage box connected to a Linux server through fc
> cables. The server is using
> kernel 2.6.26, and multipath-tools v0.4.7 (with dm-mpath target
> version 1.0.5) is installed on it
> to handle the disk scsi devices from the storage box. The multipath
> device is mounted and
> used for a file system.
>=20
This kernel is ancient, and there were several fixes for the SCSI
layer to fixup these issues.
Update the kernel or talk to your linux distributor.

(I know of one who'd be happy to help you out :-)

Cheers,

Hannes
--
Dr. Hannes Reinecke                   zSeries & Storage
hare@suse.de                          +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)



------_=_NextPart_001_01CE6B38.CA6BC5C6
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML dir=3Dltr><HEAD><TITLE>Re: [dm-devel] kernel crash with =
multipath-tools v0.4.7</TITLE>=0A=
<META content=3D"text/html; charset=3Dunicode" http-equiv=3DContent-Type>=0A=
<META name=3DGENERATOR content=3D"MSHTML 9.00.8112.16490"></HEAD>=0A=
<BODY>=0A=
<DIV dir=3Dltr id=3DidOWAReplyText94643>=0A=
<DIV dir=3Dltr><FONT color=3D#000000 size=3D2 face=3DArial>Hello Dr. =
Hannes, </FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2 face=3DArial></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT color=3D#000000 size=3D2 face=3DArial>&nbsp;&nbsp; =
Thanks for your reply. We are trying to help a customer on this issue =
who want to use our RAID storage to <BR>store video files. The customer =
is using a special Video Capture/Encoding hardware and Video workflow =
<BR>supported only for kernel 2.6.26. The vendor of this video solution =
is no longer there and has closed down. <BR>The customer has spent more =
than $300K on this proprietary video solution that they cannot move to =
the <BR>latest kernel and is stuck with it. </FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2 face=3DArial></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT color=3D#000000 size=3D2 face=3DArial>&nbsp;&nbsp; =
Since updating the kernel is not possible, somehow I want to provide a =
targeted workaround for this issue. </FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2 face=3DArial></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT color=3D#000000 size=3D2 =
face=3DArial>Thanks,<BR>Praveen</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT color=3D#000000 size=3D2 =
face=3DArial></FONT>&nbsp;</DIV></DIV>=0A=
<DIV dir=3Dltr><BR>=0A=
<HR tabIndex=3D-1>=0A=
<FONT size=3D2 face=3DTahoma><B>From:</B> Hannes Reinecke =
[mailto:hare@suse.de]<BR><B>Sent:</B> Thu 6/13/2013 1:25 =
AM<BR><B>To:</B> device-mapper development<BR><B>Cc:</B> Praveen =
Dhanasekaran - PTI; Mohan Rowlands - PTU; Manoj Mathew - PTU; Nagendra =
Vadlakunta - PTU<BR><B>Subject:</B> Re: [dm-devel] kernel crash with =
multipath-tools v0.4.7<BR></FONT><BR></DIV>=0A=
<DIV>=0A=
<P><FONT size=3D2>On 06/12/2013 01:03 PM, Praveen Dhanasekaran - PTI =
wrote:<BR>&gt; Hello All,<BR>&gt;&nbsp;<BR>&gt; I have a RAID storage =
box connected to a Linux server through fc<BR>&gt; cables. The server is =
using<BR>&gt; kernel 2.6.26, and multipath-tools v0.4.7 (with dm-mpath =
target<BR>&gt; version 1.0.5) is installed on it<BR>&gt; to handle the =
disk scsi devices from the storage box. The multipath<BR>&gt; device is =
mounted and<BR>&gt; used for a file system.<BR>&gt;&nbsp;<BR>This kernel =
is ancient, and there were several fixes for the SCSI<BR>layer to fixup =
these issues.<BR>Update the kernel or talk to your linux =
distributor.<BR><BR>(I know of one who'd be happy to help you out =
:-)<BR><BR>Cheers,<BR><BR>Hannes<BR>--<BR>Dr. Hannes =
Reinecke&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zSeries &amp; =
Storage<BR>hare@suse.de&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +49 911 74053 688<BR>SUSE LINUX Products =
GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<BR>GF: J. Hawn, J. Guild, F. =
Imend=F6rffer, HRB 16746 (AG =
N=FCrnberg)<BR></FONT></P></DIV></BODY></HTML>
------_=_NextPart_001_01CE6B38.CA6BC5C6--


--===============5933384803187340275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5933384803187340275==--
