From: Andreas.Bleischwitz@continental-corporation.com
Subject: Re: Priozier for remote port on fibre channel devices
Date: Fri, 11 Jan 2013 09:18:52 +0100
Message-ID: <OFE9A4507F.3E574BF0-ONC1257AF0.002D3A81-C1257AF0.002DAC1C@continental-corporation.com>
References: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
	<50EFBDB0.5010004@suse.de>	<OF3C233FBC.B29A53C0-ONC1257AF0.002A1FF8-C1257AF0.002AC473@continental-corporation.com>
	<50EFC81F.1070209@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8410900155165046827=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50EFC81F.1070209@suse.de>
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

This is a multipart message in MIME format.
--===============8410900155165046827==
Content-Type: multipart/alternative;
	boundary="=_alternative 002DAC17C1257AF0_="

This is a multipart message in MIME format.
--=_alternative 002DAC17C1257AF0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="ISO-8859-1"

Thanks for the hint, that will at least work for RHEL6+. For RHEL5 I will=
=20
use the scripted version.

The only downside on that is, that I will have a long line for the=20
weightedpath regex definition as this has to be for each VPLEX-port.
At least I will have reduced the need to write something on my own ;)

Best regards,

Andreas



From:   Hannes Reinecke <hare=40suse.de>
To:     dm-devel=40redhat.com,=20
Date:   11.01.2013 09:08
Subject:        Re: =5Bdm-devel=5D Priozier for remote port on fibre channe=
l=20
devices
Sent by:        dm-devel-bounces=40redhat.com



On 01/11/2013 08:47 AM,=20
Andreas.Bleischwitz=40continental-corporation.com wrote:
> Hello Hannes,
>
> sorry for top-posting, but crappy Notes is not really a good client
> for mailing-list - at least I don't know how to avoid such mess.
>
> The output is
>
> =5Broot=40fru3710e =7E=5D=23 sg_inq /dev/sdc
> standard INQUIRY:
>    PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x04  =5BSPC-2=5D
>    =5BAERC=3D0=5D  =5BTrmTsk=3D0=5D  NormACA=3D1  HiSUP=3D1  Resp_data_fo=
rmat=3D2
>    SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  BQue=3D0
>    EncServ=3D0  MultiP=3D1 (VS=3D1)  =5BMChngr=3D0=5D  =5BACKREQQ=3D0=5D =
 Addr16=3D0
>    =5BRelAdr=3D0=5D  WBus16=3D0  Sync=3D0  Linked=3D0  =5BTranDis=3D0=5D =
 CmdQue=3D1
>    =5BSPI: Clocking=3D0x0  QAS=3D0  IUS=3D0=5D
>      length=3D193 (0xc1) Peripheral device type: disk
>   Vendor identification: EMC
>   Product identification: Invista
>   Product revision level: 5100
>   Unit serial number: CKM00xxxxxxxxx
>
Hehe. No alua for you (TPGS=3D0).
But that's EMC for you; probably you should count yourself lucky
that it's not claiming compability to SCSI-2 ...

> and well, 'weightedpath' is also available in RHEL, but only queries
> for the device name and the SCSI-address. I wanted to query the
> remote-port of the storage-device - which is the frontend wwn of the
> storage device.
>
Why don't you use the 'by-path' symlinks for the device name in=20
weightedpath?
They'll include the target port WWN, so should give you what you want.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke                                    zSeries & Storage
hare=40suse.de                                                   +49 911=20=

74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--
dm-devel mailing list
dm-devel=40redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


--=_alternative 002DAC17C1257AF0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="ISO-8859-1"

<font size=3D2 face=3D=22sans-serif=22>Thanks for the hint, that will at le=
ast
work for RHEL6+. For RHEL5 I will use the scripted version.</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>The only downside on that is, th=
at I
will have a long line for the weightedpath regex definition as this has
to be for each VPLEX-port.</font>
<br><font size=3D2 face=3D=22sans-serif=22>At least I will have reduced the=
 need
to write something on my own ;)</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>Best regards,</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>Andreas</font>
<br>
<br>
<br>
<br><font size=3D1 color=3D=235f5f5f face=3D=22sans-serif=22>From: &nbsp; &=
nbsp; &nbsp;
&nbsp;</font><font size=3D1 face=3D=22sans-serif=22>Hannes Reinecke &lt;har=
e=40suse.de&gt;</font>
<br><font size=3D1 color=3D=235f5f5f face=3D=22sans-serif=22>To: &nbsp; &nb=
sp; &nbsp;
&nbsp;</font><font size=3D1 face=3D=22sans-serif=22>dm-devel=40redhat.com,
</font>
<br><font size=3D1 color=3D=235f5f5f face=3D=22sans-serif=22>Date: &nbsp; &=
nbsp; &nbsp;
&nbsp;</font><font size=3D1 face=3D=22sans-serif=22>11.01.2013 09:08</font>=

<br><font size=3D1 color=3D=235f5f5f face=3D=22sans-serif=22>Subject: &nbsp=
; &nbsp;
&nbsp; &nbsp;</font><font size=3D1 face=3D=22sans-serif=22>Re: =5Bdm-devel=
=5D
Priozier for remote port on fibre channel devices</font>
<br><font size=3D1 color=3D=235f5f5f face=3D=22sans-serif=22>Sent by: &nbsp=
; &nbsp;
&nbsp; &nbsp;</font><font size=3D1 face=3D=22sans-serif=22>dm-devel-bounces=
=40redhat.com</font>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=3D2>On 01/11/2013 08:47 AM, <br>
Andreas.Bleischwitz=40continental-corporation.com wrote:<br>
&gt; Hello Hannes,<br>
&gt;<br>
&gt; sorry for top-posting, but crappy Notes is not really a good client<br=
>
&gt; for mailing-list - at least I don't know how to avoid such mess.<br>
&gt;<br>
&gt; The output is<br>
&gt;<br>
&gt; =5Broot=40fru3710e =7E=5D=23 sg_inq /dev/sdc<br>
&gt; standard INQUIRY:<br>
&gt; &nbsp; &nbsp;PQual=3D0 &nbsp;Device_type=3D0 &nbsp;RMB=3D0 &nbsp;versi=
on=3D0x04
&nbsp;=5BSPC-2=5D<br>
&gt; &nbsp; &nbsp;=5BAERC=3D0=5D &nbsp;=5BTrmTsk=3D0=5D &nbsp;NormACA=3D1 &=
nbsp;HiSUP=3D1
&nbsp;Resp_data_format=3D2<br>
&gt; &nbsp; &nbsp;SCCS=3D0 &nbsp;ACC=3D0 &nbsp;TPGS=3D0 &nbsp;3PC=3D0 &nbsp=
;Protect=3D0
&nbsp;BQue=3D0<br>
&gt; &nbsp; &nbsp;EncServ=3D0 &nbsp;MultiP=3D1 (VS=3D1) &nbsp;=5BMChngr=3D0=
=5D &nbsp;=5BACKREQQ=3D0=5D
&nbsp;Addr16=3D0<br>
&gt; &nbsp; &nbsp;=5BRelAdr=3D0=5D &nbsp;WBus16=3D0 &nbsp;Sync=3D0 &nbsp;Li=
nked=3D0
&nbsp;=5BTranDis=3D0=5D &nbsp;CmdQue=3D1<br>
&gt; &nbsp; &nbsp;=5BSPI: Clocking=3D0x0 &nbsp;QAS=3D0 &nbsp;IUS=3D0=5D<br>=

&gt; &nbsp; &nbsp; &nbsp;length=3D193 (0xc1) Peripheral device type: disk<b=
r>
&gt; &nbsp; Vendor identification: EMC<br>
&gt; &nbsp; Product identification: Invista<br>
&gt; &nbsp; Product revision level: 5100<br>
&gt; &nbsp; Unit serial number: CKM00xxxxxxxxx<br>
&gt;<br>
Hehe. No alua for you (TPGS=3D0).<br>
But that's EMC for you; probably you should count yourself lucky<br>
that it's not claiming compability to SCSI-2 ...<br>
<br>
&gt; and well, 'weightedpath' is also available in RHEL, but only queries<b=
r>
&gt; for the device name and the SCSI-address. I wanted to query the<br>
&gt; remote-port of the storage-device - which is the frontend wwn of the<b=
r>
&gt; storage device.<br>
&gt;<br>
Why don't you use the 'by-path' symlinks for the device name in <br>
weightedpath?<br>
They'll include the target port WWN, so should give you what you want.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
-- <br>
Dr. Hannes Reinecke &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;zSeries &amp; Storage<br>
hare=40suse.de &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; +49 911 74053 688<br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)<br>
<br>
--<br>
dm-devel mailing list<br>
dm-devel=40redhat.com<br>
</font></tt><a href=3D=22https://www.redhat.com/mailman/listinfo/dm-devel=
=22><tt><font size=3D2>https://www.redhat.com/mailman/listinfo/dm-devel</fo=
nt></tt></a><tt><font size=3D2><br>
</font></tt>
<br>
--=_alternative 002DAC17C1257AF0_=--


--===============8410900155165046827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8410900155165046827==--
