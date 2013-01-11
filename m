From: Andreas.Bleischwitz@continental-corporation.com
Subject: Re: Priozier for remote port on fibre channel devices
Date: Fri, 11 Jan 2013 08:47:08 +0100
Message-ID: <OF3C233FBC.B29A53C0-ONC1257AF0.002A1FF8-C1257AF0.002AC473@continental-corporation.com>
References: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
	<50EFBDB0.5010004@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2279719803729904016=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50EFBDB0.5010004@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: dm-devel@redhat.com, dm-devel-bounces@redhat.com
List-Id: dm-devel.ids

This is a multipart message in MIME format.
--===============2279719803729904016==
Content-Type: multipart/alternative;
	boundary="=_alternative 002AC471C1257AF0_="

This is a multipart message in MIME format.
--=_alternative 002AC471C1257AF0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="ISO-8859-1"

Hello Hannes,

sorry for top-posting, but crappy Notes is not really a good client for=20
mailing-list - at least I don't know how to avoid such mess.

The output is=20

=5Broot=40fru3710e =7E=5D=23 sg_inq /dev/sdc
standard INQUIRY:
  PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x04  =5BSPC-2=5D
  =5BAERC=3D0=5D  =5BTrmTsk=3D0=5D  NormACA=3D1  HiSUP=3D1  Resp_data_forma=
t=3D2
  SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  BQue=3D0
  EncServ=3D0  MultiP=3D1 (VS=3D1)  =5BMChngr=3D0=5D  =5BACKREQQ=3D0=5D  Ad=
dr16=3D0
  =5BRelAdr=3D0=5D  WBus16=3D0  Sync=3D0  Linked=3D0  =5BTranDis=3D0=5D  Cm=
dQue=3D1
  =5BSPI: Clocking=3D0x0  QAS=3D0  IUS=3D0=5D
    length=3D193 (0xc1)   Peripheral device type: disk
 Vendor identification: EMC=20
 Product identification: Invista=20
 Product revision level: 5100
 Unit serial number: CKM00xxxxxxxxx=20

and well, 'weightedpath' is also available in RHEL, but only queries for=20=

the device name and the SCSI-address. I wanted to query the remote-port of=
=20
the storage-device - which is the frontend wwn of the storage device.

Cheers,

Andreas





From:   Hannes Reinecke <hare=40suse.de>
To:     dm-devel=40redhat.com,=20
Date:   11.01.2013 08:28
Subject:        Re: =5Bdm-devel=5D Priozier for remote port on fibre channe=
l=20
devices
Sent by:        dm-devel-bounces=40redhat.com



On 01/11/2013 08:11 AM,=20
Andreas.Bleischwitz=40continental-corporation.com wrote:
> Hello List,
>
> I'm currently facing a problem with a storage virtualization device
> which is located in two different datacenters and shows up as
> another path to a configured SAN-LUN.
> The virtualization device is from EMC=B2 and is called V-PLEX.
>
> So I have something like this:
>
>          DC A
> Host ---VPLEX-DC A---LUN storage A
>    =7C     =7C
> ..=7C...........=7C...................
>    =7C     DC B  =7C
>    ------VPLEX-DC B---LUN storage B
>
> The VPLEX device itself is for storage based mirroring and
> synchronizes write access to storage A to storage B and the other
> way around.
>
> My problem is, that the virtual LUN I get from the VPLEX does not
> have any prioritization given by dm-multipath and looks like this:
>
> mpath3 (36000144000000010e06d8f12ec30dfef) dm-9 EMC,Invista
> =5Bsize=3D5.0G=5D=5Bfeatures=3D1 queue_if_no_path=5D=5Bhwhandler=3D0=5D=
=5Brw=5D
> =5C_ round-robin 0 =5Bprio=3D1=5D=5Bactive=5D
>   =5C_ 5:0:1:2 sdad 65:208 =5Bactive=5D=5Bready=5D
>   =5C_ 5:0:4:2 sdak 66:64  =5Bactive=5D=5Bready=5D
>   =5C_ 5:0:5:2 sdap 66:144 =5Bactive=5D=5Bready=5D
>   =5C_ 4:0:0:2 sdc  8:32   =5Bactive=5D=5Bready=5D
>   =5C_ 4:0:1:2 sdh  8:112  =5Bactive=5D=5Bready=5D
>   =5C_ 4:0:4:2 sdo  8:224  =5Bactive=5D=5Bready=5D
>   =5C_ 4:0:5:2 sdt  65:48  =5Bactive=5D=5Bready=5D
>   =5C_ 5:0:0:2 sdy  65:128 =5Bactive=5D=5Bready=5D
>
> That way, write access is made round-robin and access to the
> =22remote-devices=22 - device located in the other DC - creating
> duplicate traffic through the
> SAN switches as the access has to be routed to the remote VPLEX-B
> and it will write to the local VPLEX-A.
>
> I wanted to solve this problem by giving priorities to a path by its
> remote-port - which is different for each connection to a SAN
> device. Unfortunately
> there currently doesn't exist any priorizer and I have to write one
> on my own.
> To make the definition flexible, I would like to have a file with a
> list of port-wwns associated with a priority.
>
> For versions shipped with RHEL5 this could be a simple shell script
> which simply looks up the sysfs file structures of a given device.
> For RHEL6 this has to be
> a binary library. So writing a binary version will make more sense
> than maintaining two different solutions.
>

Well, at least on SLES we're shipping a prioritizer named=20
'weightedpath' which does exactly this.

However, chances are that the VPLEX is supporting ALUA, so you might=20
want to use the 'alua' prioritizer here.

What is the output of 'sg_inq /dev/sdc' ?

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


--=_alternative 002AC471C1257AF0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="ISO-8859-1"

<font size=3D2 face=3D=22sans-serif=22>Hello Hannes,</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>sorry for top-posting, but crapp=
y Notes
is not really a good client for mailing-list - at least I don't know how
to avoid such mess.</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>The output is </font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>=5Broot=40fru3710e =7E=5D=23 sg_=
inq /dev/sdc</font>
<br><font size=3D2 face=3D=22sans-serif=22>standard INQUIRY:</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; PQual=3D0 &nbsp;Device_ty=
pe=3D0 &nbsp;RMB=3D0
&nbsp;version=3D0x04 &nbsp;=5BSPC-2=5D</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; =5BAERC=3D0=5D &nbsp;=5BT=
rmTsk=3D0=5D &nbsp;NormACA=3D1
&nbsp;HiSUP=3D1 &nbsp;Resp_data_format=3D2</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; SCCS=3D0 &nbsp;ACC=3D0 &n=
bsp;TPGS=3D0
&nbsp;3PC=3D0 &nbsp;Protect=3D0 &nbsp;BQue=3D0</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; EncServ=3D0 &nbsp;MultiP=
=3D1 (VS=3D1)
&nbsp;=5BMChngr=3D0=5D &nbsp;=5BACKREQQ=3D0=5D &nbsp;Addr16=3D0</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; =5BRelAdr=3D0=5D &nbsp;WB=
us16=3D0 &nbsp;Sync=3D0
&nbsp;Linked=3D0 &nbsp;=5BTranDis=3D0=5D &nbsp;CmdQue=3D1</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; =5BSPI: Clocking=3D0x0 &n=
bsp;QAS=3D0
&nbsp;IUS=3D0=5D</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp; &nbsp; length=3D193 (0xc1=
) &nbsp;
Peripheral device type: disk</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp;Vendor identification: EMC=
 &nbsp;
&nbsp; </font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp;Product identification: In=
vista
&nbsp; &nbsp; &nbsp; &nbsp; </font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp;Product revision level: 51=
00</font>
<br><font size=3D2 face=3D=22sans-serif=22>&nbsp;Unit serial number: CKM00x=
xxxxxxxx
</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>and well, 'weightedpath' is also=
 available
in RHEL, but only queries for the device name and the SCSI-address. I wante=
d
to query the remote-port of the storage-device - which is the frontend
wwn of the storage device.</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>Cheers,</font>
<br>
<br><font size=3D2 face=3D=22sans-serif=22>Andreas</font>
<br>
<br>
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
&nbsp;</font><font size=3D1 face=3D=22sans-serif=22>11.01.2013 08:28</font>=

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
<br><tt><font size=3D2>On 01/11/2013 08:11 AM, <br>
Andreas.Bleischwitz=40continental-corporation.com wrote:<br>
&gt; Hello List,<br>
&gt;<br>
&gt; I'm currently facing a problem with a storage virtualization device<br=
>
&gt; which is located in two different datacenters and shows up as<br>
&gt; another path to a configured SAN-LUN.<br>
&gt; The virtualization device is from EMC=B2 and is called V-PLEX.<br>
&gt;<br>
&gt; So I have something like this:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;DC A<br>
&gt; Host ---VPLEX-DC A---LUN storage A<br>
&gt; &nbsp; &nbsp;=7C &nbsp; &nbsp; =7C<br>
&gt; ..=7C...........=7C...................<br>
&gt; &nbsp; &nbsp;=7C &nbsp; &nbsp; DC B &nbsp;=7C<br>
&gt; &nbsp; &nbsp;------VPLEX-DC B---LUN storage B<br>
&gt;<br>
&gt; The VPLEX device itself is for storage based mirroring and<br>
&gt; synchronizes write access to storage A to storage B and the other<br>
&gt; way around.<br>
&gt;<br>
&gt; My problem is, that the virtual LUN I get from the VPLEX does not<br>
&gt; have any prioritization given by dm-multipath and looks like this:<br>=

&gt;<br>
&gt; mpath3 (36000144000000010e06d8f12ec30dfef) dm-9 EMC,Invista<br>
&gt; =5Bsize=3D5.0G=5D=5Bfeatures=3D1 queue_if_no_path=5D=5Bhwhandler=3D0=
=5D=5Brw=5D<br>
&gt; =5C_ round-robin 0 =5Bprio=3D1=5D=5Bactive=5D<br>
&gt; &nbsp; =5C_ 5:0:1:2 sdad 65:208 =5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 5:0:4:2 sdak 66:64 &nbsp;=5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 5:0:5:2 sdap 66:144 =5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 4:0:0:2 sdc &nbsp;8:32 &nbsp; =5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 4:0:1:2 sdh &nbsp;8:112 &nbsp;=5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 4:0:4:2 sdo &nbsp;8:224 &nbsp;=5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 4:0:5:2 sdt &nbsp;65:48 &nbsp;=5Bactive=5D=5Bready=5D<br>
&gt; &nbsp; =5C_ 5:0:0:2 sdy &nbsp;65:128 =5Bactive=5D=5Bready=5D<br>
&gt;<br>
&gt; That way, write access is made round-robin and access to the<br>
&gt; &quot;remote-devices&quot; - device located in the other DC - creating=
<br>
&gt; duplicate traffic through the<br>
&gt; SAN switches as the access has to be routed to the remote VPLEX-B<br>
&gt; and it will write to the local VPLEX-A.<br>
&gt;<br>
&gt; I wanted to solve this problem by giving priorities to a path by its<b=
r>
&gt; remote-port - which is different for each connection to a SAN<br>
&gt; device. Unfortunately<br>
&gt; there currently doesn't exist any priorizer and I have to write one<br=
>
&gt; on my own.<br>
&gt; To make the definition flexible, I would like to have a file with
a<br>
&gt; list of port-wwns associated with a priority.<br>
&gt;<br>
&gt; For versions shipped with RHEL5 this could be a simple shell script<br=
>
&gt; which simply looks up the sysfs file structures of a given device.<br>=

&gt; For RHEL6 this has to be<br>
&gt; a binary library. So writing a binary version will make more sense<br>=

&gt; than maintaining two different solutions.<br>
&gt;<br>
<br>
Well, at least on SLES we're shipping a prioritizer named <br>
'weightedpath' which does exactly this.<br>
<br>
However, chances are that the VPLEX is supporting ALUA, so you might <br>
want to use the 'alua' prioritizer here.<br>
<br>
What is the output of 'sg_inq /dev/sdc' ?<br>
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
--=_alternative 002AC471C1257AF0_=--


--===============2279719803729904016==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2279719803729904016==--
