From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: ALUA - rescan device capacity on zero sized block
	devices
Date: Tue, 14 Apr 2015 16:34:01 +0200
Message-ID: <CABr-Gnc+WX_uByZCCVCKyfH5a4=O=dpZJmxppEYGJTdnC3k-oA@mail.gmail.com>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	<552C008A.9070201@sandisk.com>
	<987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
	<552CC593.9030509@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0464535347180214935=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <552CC593.9030509@sandisk.com>
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
Cc: Thomas Wouters <thomas@kangaroot.net>
List-Id: dm-devel.ids

--===============0464535347180214935==
Content-Type: multipart/alternative; boundary=001a113cd8762cf1300513b01fcd

--001a113cd8762cf1300513b01fcd
Content-Type: text/plain; charset=UTF-8

Hi,

the 3par arrays peer persistence feature can perfectly be disabled (on a
per-initiator granularity, if I remember correctly). With this feature
disabled, the linux multipathing stack behaves correctly.

Thomas, I see the point of this array controller feature when you can not
or don't want to use the systems' multipathing layer, but you don't seem to
be in this case. Is there a reason why you are testing this combination ?

Best regards,
Christophe Varoqui

On Tue, Apr 14, 2015 at 9:45 AM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 04/14/15 09:20, Thomas Wouters wrote:
>
>> ----- On Apr 13, 2015, at 7:44 PM, Bart Van Assche
>> bart.vanassche@sandisk.com wrote:
>>
>>> On 04/13/15 17:32, Thomas Wouters wrote:
>>>
>>>> We're performing some tests with open-iscsi and multipath on two 3par
>>>> servers and their peer persistence feature.
>>>> 3par is a commercial storage solution that uses ALUA to allow failover.
>>>> We have two connections from each 3par server to a linux server.
>>>>
>>>> Every 3par server has two network controllers, so on our linux server we
>>>> initiate 4 iscsi connections.
>>>> Multipath detects that two of these connections are active paths (both
>>>> to the same 3par device, that is active at that point) and two are ghost
>>>> paths, to the passive 3par device.
>>>>
>>>> At this moment we have four block devices, the active paths show the
>>>> actual device size and the standby paths show the devices as zero sized:
>>>>
>>>> # multipath -ll
>>>> 360002ac000000000000000420001510c dm-3 3PARdata,VV
>>>> size=100G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
>>>> |-+- policy='round-robin 0' prio=130 status=active
>>>> | |- 48:0:0:123 sdc 8:32 active ready running
>>>> | `- 50:0:0:123 sdb 8:16 active ready running
>>>> `-+- policy='round-robin 0' prio=1 status=enabled
>>>>     |- 49:0:0:123 sdd 8:48 active ghost running
>>>>     `- 51:0:0:123 sde 8:64 active ghost running
>>>>
>>>> # cat /sys/block/sdb/size
>>>> 209715200
>>>> # cat /sys/block/sdc/size
>>>> 209715200
>>>> # cat /sys/block/sdd/size
>>>> 0
>>>> # cat /sys/block/sde/size
>>>> 0
>>>>
>>>> As soon as we perform a switchover on the 3par systems, multipath
>>>> detects the priority changes and switches paths but the new active paths
>>>> fail.
>>>> We believe this is because 3par doesn't allow us to read the capacity of
>>>> the disk on a standby path - and we have proof of this in the logs:
>>>>
>>>> Apr 13 15:05:12 deb-3par-test kernel: [   40.079736] sd 5:0:0:0: [sdc]
>>>> READ CAPACITY failed
>>>>
>>>> Unfortunately, once we perform the switchover on 3par, the capacity of
>>>> those old ghost paths, now active paths, is not re-read.  The multipath
>>>> device is therefore reduced to a size of 0 and the filesystem becomes
>>>> unavailable.
>>>>
>>>> If we only login on the two active paths without starting multipath,
>>>> perform a switchover, then login on the two new active paths and start
>>>> multipath, we have four block devices with a non-zero size and we can
>>>> perform switchovers at will without any issues.
>>>>
>>>> We've found some older discussions describing these issues on the scsi
>>>> target-devel and dm-devel mailinglists:
>>>> - http://permalink.gmane.org/gmane.linux.scsi.target.devel/6531
>>>> - https://www.redhat.com/archives/dm-devel/2014-July/msg00156.html
>>>>
>>>> As far as we can conclude after reading these messages, it is correct
>>>> behavior for disallowing READ CAPACITY on ghost paths.  However, once
>>>> the path becomes active, we do need a reread of the capacity in order
>>>> for the path to be functional...
>>>>
>>>> We've created a workaround for our issue but we're not sure we're going
>>>> in the right direction.
>>>>
>>>> diff --git a/multipathd/main.c b/multipathd/main.c
>>>> index f876258..ff32681 100644
>>>> --- a/multipathd/main.c
>>>> +++ b/multipathd/main.c
>>>> @@ -1235,6 +1235,11 @@ check_path (struct vectors * vecs, struct path *
>>>> pp)
>>>>
>>>> pp->chkrstate = newstate;
>>>> if (newstate != pp->state) {
>>>> +
>>>> + if (newstate == PATH_UP && pp->size != pp->mpp->size ) {
>>>> + sysfs_attr_set_value(pp->udev, "device/rescan", "1\n",2);
>>>> + }
>>>> +
>>>> int oldstate = pp->state;
>>>> pp->state = newstate;
>>>>
>>>
>>> The above patch will trigger a rescan after every failover and failback.
>>> I'm afraid that will slow down failover and failback, especially if the
>>> number of LUNs is large. I would appreciate it if the capacity would be
>>> reexamined only if it is not yet known.
>>>
>>
>> I realize this is not the best way to handle the situation.
>> This patch was never meant to be implemented as is but more of a
>>
> > clarification of how we look at the issue.
>
>>
>> If we resize a lun on the storage servers, the new size can't be read on
>>
> > standby paths. This means that if a failover occurs for any reason we
> > could end up with a corrupt block device?
>
>>
>> Is there a better way to rescan the capacity? Using sysfs_attr_set_value()
>>
> > like this doesn't look clean to me.
>
>>
>> Would it make sense to make this a configurable setting which is used for
>>
> > systems that don't allow READ CAPACITY on standby paths?
>
> Hello Thomas,
>
> There exists at least one storage array model that accepts the READ
> CAPACITY command on standby paths. The solution I would prefer is that all
> storage arrays would behave this way.
>
> Regarding LUN resizing: the SCSI specs require that a storage array
> reports CAPACITY DATA HAS CHANGED after a LUN has been resized. It should
> be possible to modify the SCSI core such that it rescans a device after
> having received this unit attention condition. The virtio_scsi already
> driver rescans a device after having received that unit attention
> condition. From drivers/scsi/virtio_scsi.c:
>
>         /* Handle "Parameters changed", "Mode parameters changed", and
>            "Capacity data has changed".  */
>         if (asc == 0x2a && (... || ascq == 0x09))
>                 scsi_rescan_device(&sdev->sdev_gendev);
>
> A quote from SBC-4:
>
> Any time the READ CAPACITY (10) parameter data (see 5.15.2) or the READ
> CAPACITY (16) parameter data (see 5.16.2) changes (e.g., when a FORMAT UNIT
> command or a MODE SELECT command causes a change to the logical block
> length or protection information, or when a vendor specific mechanism
> causes a change), then the device server shall establish a unit attention
> condition for the SCSI initiator port (see SAM-5) associated with each I_T
> nexus, except the I_T nexus on which the command causing the change was
> received with the additional sense code set to CAPACITY DATA HAS CHANGED.
>
> Bart.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113cd8762cf1300513b01fcd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>the 3par arrays peer persistence fe=
ature can perfectly be disabled (on a per-initiator granularity, if I remem=
ber correctly). With this feature disabled, the linux multipathing stack be=
haves correctly.</div><div><br></div><div>Thomas, I see the point of this a=
rray controller feature when you can not or don&#39;t want to use the syste=
ms&#39; multipathing layer, but you don&#39;t seem to be in this case. Is t=
here a reason why you are testing this combination ?</div><div><br></div><d=
iv>Best regards,</div><div>Christophe Varoqui</div></div><div class=3D"gmai=
l_extra"><br><div class=3D"gmail_quote">On Tue, Apr 14, 2015 at 9:45 AM, Ba=
rt Van Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandis=
k.com" target=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<b=
r><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:=
1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On=
 04/14/15 09:20, Thomas Wouters wrote:<br>
</div></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><div><div class=3D"h5">
----- On Apr 13, 2015, at 7:44 PM, Bart Van Assche <a href=3D"mailto:bart.v=
anassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk.com</a> wrot=
e:<br>
</div></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><div><div class=3D"h5">
On 04/13/15 17:32, Thomas Wouters wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
We&#39;re performing some tests with open-iscsi and multipath on two 3par<b=
r>
servers and their peer persistence feature.<br>
3par is a commercial storage solution that uses ALUA to allow failover.<br>
We have two connections from each 3par server to a linux server.<br>
<br>
Every 3par server has two network controllers, so on our linux server we<br=
>
initiate 4 iscsi connections.<br>
Multipath detects that two of these connections are active paths (both<br>
to the same 3par device, that is active at that point) and two are ghost<br=
>
paths, to the passive 3par device.<br>
<br>
At this moment we have four block devices, the active paths show the<br>
actual device size and the standby paths show the devices as zero sized:<br=
>
<br>
# multipath -ll<br>
360002ac0000000000000004200015<u></u>10c dm-3 3PARdata,VV<br>
size=3D100G features=3D&#39;1 queue_if_no_path&#39; hwhandler=3D&#39;1 alua=
&#39; wp=3Drw<br>
|-+- policy=3D&#39;round-robin 0&#39; prio=3D130 status=3Dactive<br>
| |- 48:0:0:123 sdc 8:32 active ready running<br>
| `- 50:0:0:123 sdb 8:16 active ready running<br>
`-+- policy=3D&#39;round-robin 0&#39; prio=3D1 status=3Denabled<br>
=C2=A0 =C2=A0 |- 49:0:0:123 sdd 8:48 active ghost running<br>
=C2=A0 =C2=A0 `- 51:0:0:123 sde 8:64 active ghost running<br>
<br>
# cat /sys/block/sdb/size<br>
209715200<br>
# cat /sys/block/sdc/size<br>
209715200<br>
# cat /sys/block/sdd/size<br>
0<br>
# cat /sys/block/sde/size<br>
0<br>
<br>
As soon as we perform a switchover on the 3par systems, multipath<br>
detects the priority changes and switches paths but the new active paths<br=
>
fail.<br>
We believe this is because 3par doesn&#39;t allow us to read the capacity o=
f<br>
the disk on a standby path - and we have proof of this in the logs:<br>
<br>
Apr 13 15:05:12 deb-3par-test kernel: [=C2=A0 =C2=A040.079736] sd 5:0:0:0: =
[sdc]<br>
READ CAPACITY failed<br>
<br>
Unfortunately, once we perform the switchover on 3par, the capacity of<br>
those old ghost paths, now active paths, is not re-read.=C2=A0 The multipat=
h<br>
device is therefore reduced to a size of 0 and the filesystem becomes<br>
unavailable.<br>
<br>
If we only login on the two active paths without starting multipath,<br>
perform a switchover, then login on the two new active paths and start<br>
multipath, we have four block devices with a non-zero size and we can<br>
perform switchovers at will without any issues.<br>
<br>
We&#39;ve found some older discussions describing these issues on the scsi<=
br>
target-devel and dm-devel mailinglists:<br>
- <a href=3D"http://permalink.gmane.org/gmane.linux.scsi.target.devel/6531"=
 target=3D"_blank">http://permalink.gmane.org/<u></u>gmane.linux.scsi.targe=
t.devel/<u></u>6531</a><br>
- <a href=3D"https://www.redhat.com/archives/dm-devel/2014-July/msg00156.ht=
ml" target=3D"_blank">https://www.redhat.com/<u></u>archives/dm-devel/2014-=
July/<u></u>msg00156.html</a><br>
<br>
As far as we can conclude after reading these messages, it is correct<br>
behavior for disallowing READ CAPACITY on ghost paths.=C2=A0 However, once<=
br>
the path becomes active, we do need a reread of the capacity in order<br>
for the path to be functional...<br>
<br>
We&#39;ve created a workaround for our issue but we&#39;re not sure we&#39;=
re going<br>
in the right direction.<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index f876258..ff32681 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1235,6 +1235,11 @@ check_path (struct vectors * vecs, struct path * pp)=
<br>
<br>
pp-&gt;chkrstate =3D newstate;<br>
if (newstate !=3D pp-&gt;state) {<br>
+<br>
+ if (newstate =3D=3D PATH_UP &amp;&amp; pp-&gt;size !=3D pp-&gt;mpp-&gt;si=
ze ) {<br>
+ sysfs_attr_set_value(pp-&gt;udev, &quot;device/rescan&quot;, &quot;1\n&qu=
ot;,2);<br>
+ }<br>
+<br>
int oldstate =3D pp-&gt;state;<br>
pp-&gt;state =3D newstate;<br>
</blockquote>
<br></div></div><span class=3D"">
The above patch will trigger a rescan after every failover and failback.<br=
>
I&#39;m afraid that will slow down failover and failback, especially if the=
<br>
number of LUNs is large. I would appreciate it if the capacity would be<br>
reexamined only if it is not yet known.<br>
</span></blockquote>
<br><span class=3D"">
I realize this is not the best way to handle the situation.<br>
This patch was never meant to be implemented as is but more of a<br>
</span></blockquote><span class=3D"">
&gt; clarification of how we look at the issue.<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
If we resize a lun on the storage servers, the new size can&#39;t be read o=
n<br>
</blockquote>
&gt; standby paths. This means that if a failover occurs for any reason we<=
br>
&gt; could end up with a corrupt block device?<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
Is there a better way to rescan the capacity? Using sysfs_attr_set_value()<=
br>
</blockquote>
&gt; like this doesn&#39;t look clean to me.<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
Would it make sense to make this a configurable setting which is used for<b=
r>
</blockquote>
&gt; systems that don&#39;t allow READ CAPACITY on standby paths?<br>
<br></span>
Hello Thomas,<br>
<br>
There exists at least one storage array model that accepts the READ CAPACIT=
Y command on standby paths. The solution I would prefer is that all storage=
 arrays would behave this way.<br>
<br>
Regarding LUN resizing: the SCSI specs require that a storage array reports=
 CAPACITY DATA HAS CHANGED after a LUN has been resized. It should be possi=
ble to modify the SCSI core such that it rescans a device after having rece=
ived this unit attention condition. The virtio_scsi already driver rescans =
a device after having received that unit attention condition. From drivers/=
scsi/virtio_scsi.c:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Handle &quot;Parameters changed&quot;, &quot=
;Mode parameters changed&quot;, and<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Capacity data has changed&qu=
ot;.=C2=A0 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (asc =3D=3D 0x2a &amp;&amp; (... || ascq =3D=
=3D 0x09))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_rescan_device(=
&amp;sdev-&gt;<u></u>sdev_gendev);<br>
<br>
A quote from SBC-4:<br>
<br>
Any time the READ CAPACITY (10) parameter data (see 5.15.2) or the READ CAP=
ACITY (16) parameter data (see 5.16.2) changes (e.g., when a FORMAT UNIT co=
mmand or a MODE SELECT command causes a change to the logical block length =
or protection information, or when a vendor specific mechanism causes a cha=
nge), then the device server shall establish a unit attention condition for=
 the SCSI initiator port (see SAM-5) associated with each I_T nexus, except=
 the I_T nexus on which the command causing the change was received with th=
e additional sense code set to CAPACITY DATA HAS CHANGED.<span class=3D"HOE=
nZb"><font color=3D"#888888"><br>
<br>
Bart.</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/<u></u>mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--001a113cd8762cf1300513b01fcd--


--===============0464535347180214935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0464535347180214935==--
