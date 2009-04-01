From: Rodrigo Nascimento <nascimento.rp@gmail.com>
Subject: Re: DM-MP, Xen 5.0.0 and NetApp
Date: Wed, 1 Apr 2009 11:45:53 -0300
Message-ID: <af7b4eb20904010745g37191673sa7f3e4aba1fe70f2@mail.gmail.com>
References: <af7b4eb20904010731v5596112dy783c8c9ad05f558d@mail.gmail.com>
	<49D37BD0.5090004@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0547457704=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49D37BD0.5090004@suse.de>
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

--===============0547457704==
Content-Type: multipart/alternative; boundary=000e0cd4cd765cae9b04667f5f41

--000e0cd4cd765cae9b04667f5f41
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

multipath -ll output:

[root@CMPXEN02 ~]# multipath -ll
360a98000572d42774e6f4f2f682f6330dm-0 NETAPP,LUN
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D32][active]
 \_ 0:0:0:0 sda        8:0   [active][ready]
 \_ 0:0:1:0 sdb        8:16  [active][ready]
 \_ 1:0:0:0 sdd        8:48  [active][ready]
 \_ 1:0:1:0 sde        8:64  [active][ready]
 \_ 2:0:0:0 sdh        8:112 [active][ready]
 \_ 3:0:0:0 sdi        8:128 [active][ready]
 \_ 3:0:1:0 sdj        8:144 [active][ready]
 \_ 2:0:1:0 sdk        8:160 [active][ready]
\_ round-robin 0 [prio=3D7][enabled]
 \_ 0:0:2:0 sdc        8:32  [active][ready]
 \_ 1:0:2:0 sdf        8:80  [active][ready]
 \_ 1:0:3:0 sdg        8:96  [active][ready]
 \_ 3:0:2:0 sdl        8:176 [active][ready]
 \_ 3:0:3:0 sdn        8:208 [active][ready]
 \_ 0:0:3:0 sdo        8:224 [active][ready]
 \_ 2:0:3:0 sdp        8:240 [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:2:0 sdm        8:192 [failed][faulty]


On Wed, Apr 1, 2009 at 11:36 AM, Hannes Reinecke <hare@suse.de> wrote:

> Rodrigo Nascimento wrote:
>
>> Hi All,
>>  I'm having problems to put the Multipathing tools to work correctly wit=
h
>> NetApp Cluster Solution.
>>  I have a xenpool with 3 machines the multipathing are enabled on them,
>> the HBA are Qlogic, two FAS3140 controllers in Cluster. I created a lun =
to
>> be a storage repository (SR), the lun is visible and was recognized on t=
he 3
>> machines, but when we say to the XenServer to build a SR with this Lun, =
all
>> I/O operations arrive to the FAS3140 by the non-optimized path.
>>  *XenServer multipath.conf*
>>  defaults {
>>        user_friendly_names no
>> }
>> devices {
>>        device {
>>                vendor                  "NETAPP"
>>                product                 "LUN"
>>                path_grouping_policy    group_by_prio
>>                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n=
"
>>                prio_callout            "/sbin/mpath_prio_netapp /dev/%n"
>>                features                "1 queue_if_no_path"
>>                path_checker            directio
>>                failback                immediate
>>        }
>> }
>>  We made two tests, one with prio_callout as /sbin/mpath_prio_alua and
>> other with prio_callout as /sbin/mpath_prio_netapp, both returns the sam=
e
>> results.
>>
>>
>
> What's the output of 'multipath -ll'?
> Looks like all paths are configured into one group here.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Rodrigo Nascimento

--000e0cd4cd765cae9b04667f5f41
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><font face=3D"courier new,monospace">multipath -ll output:</font></div=
>
<div><font face=3D"courier new,monospace"></font>=A0</div>
<div><font face=3D"courier new,monospace">[root@CMPXEN02 ~]# multipath -ll<=
br>360a98000572d42774e6f4f2f682f6330dm-0 NETAPP,LUN<br>[size=3D20G][feature=
s=3D1 queue_if_no_path][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D32][acti=
ve]<br>
=A0\_ 0:0:0:0 sda=A0=A0=A0=A0=A0=A0=A0 8:0=A0=A0 [active][ready]<br>=A0\_ 0=
:0:1:0 sdb=A0=A0=A0=A0=A0=A0=A0 8:16=A0 [active][ready]<br>=A0\_ 1:0:0:0 sd=
d=A0=A0=A0=A0=A0=A0=A0 8:48=A0 [active][ready]<br>=A0\_ 1:0:1:0 sde=A0=A0=
=A0=A0=A0=A0=A0 8:64=A0 [active][ready]<br>=A0\_ 2:0:0:0 sdh=A0=A0=A0=A0=A0=
=A0=A0 8:112 [active][ready]<br>
=A0\_ 3:0:0:0 sdi=A0=A0=A0=A0=A0=A0=A0 8:128 [active][ready]<br>=A0\_ 3:0:1=
:0 sdj=A0=A0=A0=A0=A0=A0=A0 8:144 [active][ready]<br>=A0\_ 2:0:1:0 sdk=A0=
=A0=A0=A0=A0=A0=A0 8:160 [active][ready]<br>\_ round-robin 0 [prio=3D7][ena=
bled]<br>=A0\_ 0:0:2:0 sdc=A0=A0=A0=A0=A0=A0=A0 8:32=A0 [active][ready]<br>
=A0\_ 1:0:2:0 sdf=A0=A0=A0=A0=A0=A0=A0 8:80=A0 [active][ready]<br>=A0\_ 1:0=
:3:0 sdg=A0=A0=A0=A0=A0=A0=A0 8:96=A0 [active][ready]<br>=A0\_ 3:0:2:0 sdl=
=A0=A0=A0=A0=A0=A0=A0 8:176 [active][ready]<br>=A0\_ 3:0:3:0 sdn=A0=A0=A0=
=A0=A0=A0=A0 8:208 [active][ready]<br>=A0\_ 0:0:3:0 sdo=A0=A0=A0=A0=A0=A0=
=A0 8:224 [active][ready]<br>
=A0\_ 2:0:3:0 sdp=A0=A0=A0=A0=A0=A0=A0 8:240 [active][ready]<br>\_ round-ro=
bin 0 [prio=3D0][enabled]<br>=A0\_ 2:0:2:0 sdm=A0=A0=A0=A0=A0=A0=A0 8:192 [=
failed][faulty]</font><br><br><br></div>
<div class=3D"gmail_quote">On Wed, Apr 1, 2009 at 11:36 AM, Hannes Reinecke=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt;=
</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">Rodrigo Nascimento wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hi All,<br>=A0I&#39;m having pro=
blems to put the Multipathing tools to work correctly with NetApp Cluster S=
olution.<br>
=A0I have a xenpool with 3 machines the multipathing are enabled on them, t=
he HBA are Qlogic, two FAS3140 controllers in Cluster. I created a lun to b=
e a storage repository (SR), the lun is visible and was recognized on the 3=
 machines, but when we say to the XenServer to build a SR with this Lun, al=
l I/O operations arrive to the FAS3140 by the non-optimized path.<br>
=A0*XenServer multipath.conf*<br>=A0defaults {<br>=A0 =A0 =A0 =A0user_frien=
dly_names no<br>}<br>devices {<br>=A0 =A0 =A0 =A0device {<br>=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0vendor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot;NETAPP&q=
uot;<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0product =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &quot;LUN&quot;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path_grouping_policy =A0 =A0group_by_prio<br=
>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0getuid_callout =A0 =A0 =A0 =A0 =A0&quot;/sb=
in/scsi_id -g -u -s /block/%n&quot;<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0prio_=
callout =A0 =A0 =A0 =A0 =A0 =A0&quot;/sbin/mpath_prio_netapp /dev/%n&quot;<=
br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0features =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quo=
t;1 queue_if_no_path&quot;<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path_checker =
=A0 =A0 =A0 =A0 =A0 =A0directio<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failback =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0immediate<br>=A0 =A0 =A0 =A0}<br>}<br>=A0We =
made two tests, one with prio_callout as /sbin/mpath_prio_alua and other wi=
th prio_callout as /sbin/mpath_prio_netapp, both returns the same results.<=
br>
=A0<br></blockquote><br></div>What&#39;s the output of &#39;multipath -ll&#=
39;?<br>Looks like all paths are configured into one group here.<br><br>Che=
ers,<br><br>Hannes<br>-- <br>Dr. Hannes Reinecke =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a> =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+49 911 74053 688<br>SUSE LINUX =
Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<br>GF: Markus Rex, HRB 16746=
 (AG N=FCrnberg)<br><font color=3D"#888888"><br>
--<br>dm-devel mailing list<br><a href=3D"mailto:dm-devel@redhat.com" targe=
t=3D"_blank">dm-devel@redhat.com</a><br><a href=3D"https://www.redhat.com/m=
ailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Rodrigo Nascimen=
to<br>

--000e0cd4cd765cae9b04667f5f41--


--===============0547457704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0547457704==--
