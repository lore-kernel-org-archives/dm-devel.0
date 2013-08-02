From: Amy Rupp <amymoseleyrupp@gmail.com>
Subject: Re: state we don't understand
Date: Thu, 1 Aug 2013 23:45:01 -0500
Message-ID: <CAC4stOsU8F2vWhOqKUfqBcHN5ZVs=1eg9RadPkoSYTTJ-mQgmg@mail.gmail.com>
References: <B8BEC492-4943-4032-9126-313D30D3AF6A@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1191499357739516128=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B8BEC492-4943-4032-9126-313D30D3AF6A@purestorage.com>
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

--===============1191499357739516128==
Content-Type: multipart/alternative; boundary=f46d04374a0919710f04e2ef9f5e

--f46d04374a0919710f04e2ef9f5e
Content-Type: text/plain; charset=ISO-8859-1

A thought:

In checking the model, only SCSI_PRODUCT_SIZE chars will be returned from
sysfs_get_model.  If the entire model strings are:

FlashArray:FC048517648240BB00010003
FlashArray:FC048517648240BB00010005

that's 36 characters, of which the first 35 look identical to me.

Even if "FlashArray:" is ignored, and the hex digits represent the product,
that's still 25 hex digits of which the first 24 look identical.


On Thu, Aug 1, 2013 at 4:16 PM, Brian Bunker <brian@purestorage.com> wrote:

> Hello all,
>
> Every once in a while we run into a situation like this and we have caught
> a machine in this state to hopefully gain some insight into what is wrong
> where causing this. We have a 'multipath -l' output like this:
>
> [root@r17init5 ~]# multipath -l
> ...
> mpathguk (3624a9370fc048517648240bb00010005) dm-4 PURE,FlashArray
> size=500G features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=0 status=active
>   |- 2:0:0:7  sdar 66:176 active undef running
>   |- 0:0:0:7  sdba 67:64  active undef running
>   |- 3:0:0:5  sde  8:64   active undef running
>   `- 1:0:0:5  sdt  65:48  active undef running
> ...
> mpathgui (3624a9370fc048517648240bb00010004) dm-5 PURE,FlashArray
> size=500G features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=0 status=active
>   |- 2:0:0:6  sdaq 66:160 active undef running
>   |- 0:0:0:6  sday 67:32  active undef running
>   |- 3:0:0:4  sdd  8:48   active undef running
>   `- 1:0:0:4  sds  65:32  active undef running
> ....
>
> You can see that the dm device is combining different LUN numbers under
> the same dm device which is obviously leading to data corruption. Some dm
> devices in the list do not have this problem. You can see that these should
> not be getting combined since their page 0x83 inquiry data is not the same:
>
> [root@r17init5 ~]# sg_inq -p 0x83 /dev/sdar
> VPD INQUIRY: Device Identification page
>   Designation descriptor number 1, descriptor length: 20
>     designator_type: NAA,  code_set: Binary
>     associated with the addressed logical unit
>       NAA 6, IEEE Company_id: 0x24a937
>       Vendor Specific Identifier: 0xfc048517
>       Vendor Specific Identifier Extension: 0x648240bb00010005
>       [0x624a9370fc048517648240bb00010005]
>   Designation descriptor number 2, descriptor length: 47
>     designator_type: T10 vendor identification,  code_set: ASCII
>     associated with the addressed logical unit
>       vendor id: PURE
>       vendor specific: FlashArray:FC048517648240BB00010005
>   Designation descriptor number 3, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Relative target port,  code_set: Binary
>     associated with the target port
>       Relative target port: 0x17
>   Designation descriptor number 4, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Target port group,  code_set: Binary
>     associated with the target port
>       Target port group: 0x0
>   Designation descriptor number 5, descriptor length: 8
>     designator_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>       Logical unit group: 0x0
>   Designation descriptor number 6, descriptor length: 36
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: SCSI name string,  code_set: UTF-8
>     associated with the target port
>       SCSI name string:
>       naa.524a937000013316,t,0x0001
>   Designation descriptor number 7, descriptor length: 16
>     designator_type: vendor specific [0x0],  code_set: ASCII
>     associated with the addressed logical unit
>       vendor specific: validation4
>
> [root@r17init5 ~]# sg_inq -p 0x83 /dev/sdba
> VPD INQUIRY: Device Identification page
>   Designation descriptor number 1, descriptor length: 20
>     designator_type: NAA,  code_set: Binary
>     associated with the addressed logical unit
>       NAA 6, IEEE Company_id: 0x24a937
>       Vendor Specific Identifier: 0xfc048517
>       Vendor Specific Identifier Extension: 0x648240bb00010005
>       [0x624a9370fc048517648240bb00010005]
>   Designation descriptor number 2, descriptor length: 47
>     designator_type: T10 vendor identification,  code_set: ASCII
>     associated with the addressed logical unit
>       vendor id: PURE
>       vendor specific: FlashArray:FC048517648240BB00010005
>   Designation descriptor number 3, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Relative target port,  code_set: Binary
>     associated with the target port
>       Relative target port: 0x13
>   Designation descriptor number 4, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Target port group,  code_set: Binary
>     associated with the target port
>       Target port group: 0x0
>   Designation descriptor number 5, descriptor length: 8
>     designator_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>       Logical unit group: 0x0
>   Designation descriptor number 6, descriptor length: 36
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: SCSI name string,  code_set: UTF-8
>     associated with the target port
>       SCSI name string:
>       naa.524a937000013312,t,0x0001
>   Designation descriptor number 7, descriptor length: 16
>     designator_type: vendor specific [0x0],  code_set: ASCII
>     associated with the addressed logical unit
>       vendor specific: validation4
>
> [root@r17init5 ~]# sg_inq -p 0x83 /dev/sde
> VPD INQUIRY: Device Identification page
>   Designation descriptor number 1, descriptor length: 20
>     designator_type: NAA,  code_set: Binary
>     associated with the addressed logical unit
>       NAA 6, IEEE Company_id: 0x24a937
>       Vendor Specific Identifier: 0xfc048517
>       Vendor Specific Identifier Extension: 0x648240bb00010003
>       [0x624a9370fc048517648240bb00010003]
>   Designation descriptor number 2, descriptor length: 47
>     designator_type: T10 vendor identification,  code_set: ASCII
>     associated with the addressed logical unit
>       vendor id: PURE
>       vendor specific: FlashArray:FC048517648240BB00010003
>   Designation descriptor number 3, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Relative target port,  code_set: Binary
>     associated with the target port
>       Relative target port: 0x7
>   Designation descriptor number 4, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Target port group,  code_set: Binary
>     associated with the target port
>       Target port group: 0x0
>   Designation descriptor number 5, descriptor length: 8
>     designator_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>       Logical unit group: 0x0
>   Designation descriptor number 6, descriptor length: 36
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: SCSI name string,  code_set: UTF-8
>     associated with the target port
>       SCSI name string:
>       naa.524a937000013306,t,0x0001
>   Designation descriptor number 7, descriptor length: 16
>     designator_type: vendor specific [0x0],  code_set: ASCII
>     associated with the addressed logical unit
>       vendor specific: validation2
>
> [root@r17init5 ~]# sg_inq -p 0x83 /dev/sdt
> VPD INQUIRY: Device Identification page
>   Designation descriptor number 1, descriptor length: 20
>     designator_type: NAA,  code_set: Binary
>     associated with the addressed logical unit
>       NAA 6, IEEE Company_id: 0x24a937
>       Vendor Specific Identifier: 0xfc048517
>       Vendor Specific Identifier Extension: 0x648240bb00010003
>       [0x624a9370fc048517648240bb00010003]
>   Designation descriptor number 2, descriptor length: 47
>     designator_type: T10 vendor identification,  code_set: ASCII
>     associated with the addressed logical unit
>       vendor id: PURE
>       vendor specific: FlashArray:FC048517648240BB00010003
>   Designation descriptor number 3, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Relative target port,  code_set: Binary
>     associated with the target port
>       Relative target port: 0x3
>   Designation descriptor number 4, descriptor length: 8
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: Target port group,  code_set: Binary
>     associated with the target port
>       Target port group: 0x0
>   Designation descriptor number 5, descriptor length: 8
>     designator_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>       Logical unit group: 0x0
>   Designation descriptor number 6, descriptor length: 36
>     transport: Fibre Channel Protocol for SCSI (FCP-2)
>     designator_type: SCSI name string,  code_set: UTF-8
>     associated with the target port
>       SCSI name string:
>       naa.524a937000013302,t,0x0001
>   Designation descriptor number 7, descriptor length: 16
>     designator_type: vendor specific [0x0],  code_set: ASCII
>     associated with the addressed logical unit
>       vendor specific: validation2
>
> So the first two have 0x624a9370fc048517648240bb00010005 and the second
> two have the 0x624a9370fc048517648240bb00010003. Is there some caching here
> that causes this? What could get us here?
>
> I have the server in the state currently so if there is any further output
> that would help figure out what happened here then let me know.
>
> Thanks,
> Brian
>
> Brian Bunker
> brian@purestorage.com
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--f46d04374a0919710f04e2ef9f5e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">A thought:<div><br></div><div>In checking the model, only =
SCSI_PRODUCT_SIZE chars will be returned from sysfs_get_model. =A0If the en=
tire model strings are:</div><div><br></div><div><span style=3D"font-family=
:arial,sans-serif;font-size:13px">FlashArray:</span><span style=3D"font-fam=
ily:arial,sans-serif;font-size:13px">FC048517648240BB00010003</span><br>
</div><div><span style=3D"font-family:arial,sans-serif;font-size:13px">Flas=
hArray:</span><span style=3D"font-family:arial,sans-serif;font-size:13px">F=
C048517648240BB00010005</span><span style=3D"font-family:arial,sans-serif;f=
ont-size:13px"><br>
</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:13p=
x"><br></span></div><div><span style=3D"font-family:arial,sans-serif;font-s=
ize:13px">that&#39;s 36 characters, of which the first 35 look identical to=
 me.</span></div>
<div><span style=3D"font-family:arial,sans-serif;font-size:13px"><br></span=
></div><div><span style=3D"font-family:arial,sans-serif;font-size:13px">Eve=
n if &quot;FlashArray:&quot; is ignored, and the hex digits represent the p=
roduct,=A0</span></div>
<div><span style=3D"font-family:arial,sans-serif;font-size:13px">that&#39;s=
 still 25 hex digits of which the first 24 look identical.</span></div></di=
v><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu, Aug=
 1, 2013 at 4:16 PM, Brian Bunker <span dir=3D"ltr">&lt;<a href=3D"mailto:b=
rian@purestorage.com" target=3D"_blank">brian@purestorage.com</a>&gt;</span=
> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hello all,<br>
<br>
Every once in a while we run into a situation like this and we have caught =
a machine in this state to hopefully gain some insight into what is wrong w=
here causing this. We have a &#39;multipath -l&#39; output like this:<br>

<br>
[root@r17init5 ~]# multipath -l<br>
...<br>
mpathguk (3624a9370fc048517648240bb00010005) dm-4 PURE,FlashArray<br>
size=3D500G features=3D&#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw<br>
`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Dactive<br>
=A0 |- 2:0:0:7 =A0sdar 66:176 active undef running<br>
=A0 |- 0:0:0:7 =A0sdba 67:64 =A0active undef running<br>
=A0 |- 3:0:0:5 =A0sde =A08:64 =A0 active undef running<br>
=A0 `- 1:0:0:5 =A0sdt =A065:48 =A0active undef running<br>
...<br>
mpathgui (3624a9370fc048517648240bb00010004) dm-5 PURE,FlashArray<br>
size=3D500G features=3D&#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw<br>
`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Dactive<br>
=A0 |- 2:0:0:6 =A0sdaq 66:160 active undef running<br>
=A0 |- 0:0:0:6 =A0sday 67:32 =A0active undef running<br>
=A0 |- 3:0:0:4 =A0sdd =A08:48 =A0 active undef running<br>
=A0 `- 1:0:0:4 =A0sds =A065:32 =A0active undef running<br>
....<br>
<br>
You can see that the dm device is combining different LUN numbers under the=
 same dm device which is obviously leading to data corruption. Some dm devi=
ces in the list do not have this problem. You can see that these should not=
 be getting combined since their page 0x83 inquiry data is not the same:<br=
>

<br>
[root@r17init5 ~]# sg_inq -p 0x83 /dev/sdar<br>
VPD INQUIRY: Device Identification page<br>
=A0 Designation descriptor number 1, descriptor length: 20<br>
=A0 =A0 designator_type: NAA, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 NAA 6, IEEE Company_id: 0x24a937<br>
=A0 =A0 =A0 Vendor Specific Identifier: 0xfc048517<br>
=A0 =A0 =A0 Vendor Specific Identifier Extension: 0x648240bb00010005<br>
=A0 =A0 =A0 [0x624a9370fc048517648240bb00010005]<br>
=A0 Designation descriptor number 2, descriptor length: 47<br>
=A0 =A0 designator_type: T10 vendor identification, =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor id: PURE<br>
=A0 =A0 =A0 vendor specific: FlashArray:FC048517648240BB00010005<br>
=A0 Designation descriptor number 3, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Relative target port, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Relative target port: 0x17<br>
=A0 Designation descriptor number 4, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Target port group, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Target port group: 0x0<br>
=A0 Designation descriptor number 5, descriptor length: 8<br>
=A0 =A0 designator_type: Logical unit group, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 Logical unit group: 0x0<br>
=A0 Designation descriptor number 6, descriptor length: 36<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: SCSI name string, =A0code_set: UTF-8<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 SCSI name string:<br>
=A0 =A0 =A0 naa.524a937000013316,t,0x0001<br>
=A0 Designation descriptor number 7, descriptor length: 16<br>
=A0 =A0 designator_type: vendor specific [0x0], =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor specific: validation4<br>
<br>
[root@r17init5 ~]# sg_inq -p 0x83 /dev/sdba<br>
VPD INQUIRY: Device Identification page<br>
=A0 Designation descriptor number 1, descriptor length: 20<br>
=A0 =A0 designator_type: NAA, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 NAA 6, IEEE Company_id: 0x24a937<br>
=A0 =A0 =A0 Vendor Specific Identifier: 0xfc048517<br>
=A0 =A0 =A0 Vendor Specific Identifier Extension: 0x648240bb00010005<br>
=A0 =A0 =A0 [0x624a9370fc048517648240bb00010005]<br>
=A0 Designation descriptor number 2, descriptor length: 47<br>
=A0 =A0 designator_type: T10 vendor identification, =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor id: PURE<br>
=A0 =A0 =A0 vendor specific: FlashArray:FC048517648240BB00010005<br>
=A0 Designation descriptor number 3, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Relative target port, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Relative target port: 0x13<br>
=A0 Designation descriptor number 4, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Target port group, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Target port group: 0x0<br>
=A0 Designation descriptor number 5, descriptor length: 8<br>
=A0 =A0 designator_type: Logical unit group, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 Logical unit group: 0x0<br>
=A0 Designation descriptor number 6, descriptor length: 36<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: SCSI name string, =A0code_set: UTF-8<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 SCSI name string:<br>
=A0 =A0 =A0 naa.524a937000013312,t,0x0001<br>
=A0 Designation descriptor number 7, descriptor length: 16<br>
=A0 =A0 designator_type: vendor specific [0x0], =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor specific: validation4<br>
<br>
[root@r17init5 ~]# sg_inq -p 0x83 /dev/sde<br>
VPD INQUIRY: Device Identification page<br>
=A0 Designation descriptor number 1, descriptor length: 20<br>
=A0 =A0 designator_type: NAA, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 NAA 6, IEEE Company_id: 0x24a937<br>
=A0 =A0 =A0 Vendor Specific Identifier: 0xfc048517<br>
=A0 =A0 =A0 Vendor Specific Identifier Extension: 0x648240bb00010003<br>
=A0 =A0 =A0 [0x624a9370fc048517648240bb00010003]<br>
=A0 Designation descriptor number 2, descriptor length: 47<br>
=A0 =A0 designator_type: T10 vendor identification, =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor id: PURE<br>
=A0 =A0 =A0 vendor specific: FlashArray:FC048517648240BB00010003<br>
=A0 Designation descriptor number 3, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Relative target port, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Relative target port: 0x7<br>
=A0 Designation descriptor number 4, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Target port group, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Target port group: 0x0<br>
=A0 Designation descriptor number 5, descriptor length: 8<br>
=A0 =A0 designator_type: Logical unit group, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 Logical unit group: 0x0<br>
=A0 Designation descriptor number 6, descriptor length: 36<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: SCSI name string, =A0code_set: UTF-8<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 SCSI name string:<br>
=A0 =A0 =A0 naa.524a937000013306,t,0x0001<br>
=A0 Designation descriptor number 7, descriptor length: 16<br>
=A0 =A0 designator_type: vendor specific [0x0], =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor specific: validation2<br>
<br>
[root@r17init5 ~]# sg_inq -p 0x83 /dev/sdt<br>
VPD INQUIRY: Device Identification page<br>
=A0 Designation descriptor number 1, descriptor length: 20<br>
=A0 =A0 designator_type: NAA, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 NAA 6, IEEE Company_id: 0x24a937<br>
=A0 =A0 =A0 Vendor Specific Identifier: 0xfc048517<br>
=A0 =A0 =A0 Vendor Specific Identifier Extension: 0x648240bb00010003<br>
=A0 =A0 =A0 [0x624a9370fc048517648240bb00010003]<br>
=A0 Designation descriptor number 2, descriptor length: 47<br>
=A0 =A0 designator_type: T10 vendor identification, =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor id: PURE<br>
=A0 =A0 =A0 vendor specific: FlashArray:FC048517648240BB00010003<br>
=A0 Designation descriptor number 3, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Relative target port, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Relative target port: 0x3<br>
=A0 Designation descriptor number 4, descriptor length: 8<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: Target port group, =A0code_set: Binary<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 Target port group: 0x0<br>
=A0 Designation descriptor number 5, descriptor length: 8<br>
=A0 =A0 designator_type: Logical unit group, =A0code_set: Binary<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 Logical unit group: 0x0<br>
=A0 Designation descriptor number 6, descriptor length: 36<br>
=A0 =A0 transport: Fibre Channel Protocol for SCSI (FCP-2)<br>
=A0 =A0 designator_type: SCSI name string, =A0code_set: UTF-8<br>
=A0 =A0 associated with the target port<br>
=A0 =A0 =A0 SCSI name string:<br>
=A0 =A0 =A0 naa.524a937000013302,t,0x0001<br>
=A0 Designation descriptor number 7, descriptor length: 16<br>
=A0 =A0 designator_type: vendor specific [0x0], =A0code_set: ASCII<br>
=A0 =A0 associated with the addressed logical unit<br>
=A0 =A0 =A0 vendor specific: validation2<br>
<br>
So the first two have 0x624a9370fc048517648240bb00010005 and the second two=
 have the 0x624a9370fc048517648240bb00010003. Is there some caching here th=
at causes this? What could get us here?<br>
<br>
I have the server in the state currently so if there is any further output =
that would help figure out what happened here then let me know.<br>
<br>
Thanks,<br>
Brian<br>
<br>
Brian Bunker<br>
<a href=3D"mailto:brian@purestorage.com">brian@purestorage.com</a><br>
<br>
<br>
<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--f46d04374a0919710f04e2ef9f5e--


--===============1191499357739516128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1191499357739516128==--
