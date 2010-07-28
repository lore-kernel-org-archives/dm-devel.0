From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: [OT] How to associate pci id with wwpn for an hba
Date: Wed, 28 Jul 2010 15:51:08 +0200
Message-ID: <AANLkTi=_LMqT3xoCitF6qdfOW7yXWLoVcJArLUR0zU5s@mail.gmail.com>
References: <AANLkTik17u5GBF_SBB25-qptP9cqjQFqgG4D+k-zc9a9@mail.gmail.com>
	<AANLkTinfMy-G2Cd7GCBt3yUtV13TOMANp1Od-PBykbZd@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2081607714544664389=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTinfMy-G2Cd7GCBt3yUtV13TOMANp1Od-PBykbZd@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Barber <jonathan.barber@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2081607714544664389==
Content-Type: multipart/alternative; boundary=0016e6d975c7ed1649048c72e8be

--0016e6d975c7ed1649048c72e8be
Content-Type: text/plain; charset=UTF-8

On Wed, Jul 28, 2010 at 1:26 PM, Jonathan Barber wrote:

>
> # lspci | grep QLogic
> 0d:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to
> PCI Express HBA (rev 03)
> 0d:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to
> PCI Express HBA (rev 03)
>
> # ls -l /sys/class/fc_host/host?/device
> lrwxrwxrwx 1 root root 0 Jul 28 11:54 /sys/class/fc_host/host1/device
> ->
> ../../../devices/pci0000:00/0000:00:06.0/0000:0b:00.0/0000:0c:09.0/0000:0d:00.1/host1
> lrwxrwxrwx 1 root root 0 Jul 28 11:55 /sys/class/fc_host/host0/device
> ->
> ../../../devices/pci0000:00/0000:00:06.0/0000:0b:00.0/0000:0c:09.0/0000:0d:00.0/host0
>
> (note the 0d:00.0 and 0d:00.1 PCI ID in the symlink targets)
>
> And I believe:
> # ls -l /sys/block/*/device
>
> will show you the relationship between the block device and the FC
> port you were looking for in d).
>
> I would interpret your missing block devices as being each of your
> target HBA seeing only one of the storage controllers, and not both -
> but check the output of "ls -l /sys/block/{sdao,sdd}/device" to make
> sure.
>
>
Thanks for your answer Jonathan,
In my case I got
Jul 27 17:54:58 orastud1 kernel: qla2xxx 0000:06:00.0: SNS scan failed --
assuming zero-entry result...

and I'm sure both the controllers were visible as this is the passive node
of a 2 nodes cluster with same SAN visibility between nodes.
And the other node (the active one) had same fc-switch config and no problem
at all with the paths.

Now the problem is solved for this node (probably it was a matter of a
changed but not activated config... because a group of SAN disks was
swapped) and I get:

# ls -l /sys/class/fc_host/host?/device
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/class/fc_host/host1/device ->
../../../devices/pci0000:00/0000:00:07.0/0000:06:00.0/host1
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/class/fc_host/host2/device ->
../../../devices/pci0000:00/0000:00:07.0/0000:06:00.1/host2

]# ls -l /sys/block/*/device
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/block/sdaa/device ->
../../devices/pci0000:00/0000:00:07.0/0000:06:00.1/host2/rport-2:0-2/target2:0:2/2:0:2:12
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/block/sdab/device ->
../../devices/pci0000:00/0000:00:07.0/0000:06:00.1/host2/rport-2:0-2/target2:0:2/2:0:2:13
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/block/sdac/device ->
../../devices/pci0000:00/0000:00:07.0/0000:06:00.0/host1/rport-1:0-2/target1:0:2/1:0:2:13
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/block/sdad/device ->
../../devices/pci0000:00/0000:00:07.0/0000:06:00.1/host2/rport-2:0-2/target2:0:2/2:0:2:14
[snipped... long output]

I can see that all the host1 lines contain 06:00.0 (and 1:0:x:y devices at
the end), while all the host2 lines contain 06:00.1 (and 2:0:x:y for device
at the end)

In case of similar situation I would only have to see if
a) I have a mix of host1 and host2 disks lines
==> each hba is seeing only one path;

b) I have only hostx lines
==> I have only 1 hba involved in LUN visibility problems: the hosty missing
in output above (and related pci id)...
and then with
cat /sys/class/fc_host/hosty/port_name
I would get its wwpn to pass to SAN guys

Thanks!

--0016e6d975c7ed1649048c72e8be
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Wed, Jul 28, 2010 at 1:26 PM, Jonathan Barber=
 <span dir=3D"ltr"></span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); =
padding-left: 1ex;">
<div class=3D"im">
<br>
</div># lspci | grep QLogic<br>
0d:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to<br>
PCI Express HBA (rev 03)<br>
0d:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to<br>
PCI Express HBA (rev 03)<br>
<br>
# ls -l /sys/class/fc_host/host?/device<br>
lrwxrwxrwx 1 root root 0 Jul 28 11:54 /sys/class/fc_host/host1/device<br>
-&gt; ../../../devices/pci0000:00/0000:00:06.0/0000:0b:00.0/0000:0c:09.0/00=
00:0d:00.1/host1<br>
lrwxrwxrwx 1 root root 0 Jul 28 11:55 /sys/class/fc_host/host0/device<br>
-&gt; ../../../devices/pci0000:00/0000:00:06.0/0000:0b:00.0/0000:0c:09.0/00=
00:0d:00.0/host0<br>
<br>
(note the 0d:00.0 and 0d:00.1 PCI ID in the symlink targets)<br>
<br>
And I believe:<br>
# ls -l /sys/block/*/device<br>
<br>
will show you the relationship between the block device and the FC<br>
port you were looking for in d).<br>
<br>
I would interpret your missing block devices as being each of your<br>
target HBA seeing only one of the storage controllers, and not both -<br>
but check the output of &quot;ls -l /sys/block/{sdao,sdd}/device&quot; to m=
ake<br>
sure.<br>
<br>
<font color=3D"#888888">
</font></blockquote></div><br>Thanks for your answer Jonathan,<br>In my cas=
e I got <br>Jul 27 17:54:58 orastud1 kernel: qla2xxx 0000:06:00.0: SNS scan=
 failed -- assuming zero-entry result...<br><br>and I&#39;m sure both the c=
ontrollers were visible as this is the passive node of a 2 nodes cluster wi=
th same SAN visibility between nodes.<br>
And the other node (the active one) had same fc-switch config and no proble=
m at all with the paths.<br>=C2=A0 <br>Now the problem is solved for this n=
ode (probably it was a matter of a changed but not activated config... beca=
use a group of SAN disks was swapped) and I get:<br>
<br># ls -l /sys/class/fc_host/host?/device<br>lrwxrwxrwx 1 root root 0 Jul=
 27 18:16 /sys/class/fc_host/host1/device -&gt; ../../../devices/pci0000:00=
/0000:00:07.0/0000:06:00.0/host1<br>lrwxrwxrwx 1 root root 0 Jul 27 18:16 /=
sys/class/fc_host/host2/device -&gt; ../../../devices/pci0000:00/0000:00:07=
.0/0000:06:00.1/host2<br>
<br>]# ls -l /sys/block/*/device<br>lrwxrwxrwx 1 root root 0 Jul 27 18:16 /=
sys/block/sdaa/device -&gt; ../../devices/pci0000:00/0000:00:07.0/0000:06:0=
0.1/host2/rport-2:0-2/target2:0:2/2:0:2:12<br>lrwxrwxrwx 1 root root 0 Jul =
27 18:16 /sys/block/sdab/device -&gt; ../../devices/pci0000:00/0000:00:07.0=
/0000:06:00.1/host2/rport-2:0-2/target2:0:2/2:0:2:13<br>
lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/block/sdac/device -&gt; ../../de=
vices/pci0000:00/0000:00:07.0/0000:06:00.0/host1/rport-1:0-2/target1:0:2/1:=
0:2:13<br>lrwxrwxrwx 1 root root 0 Jul 27 18:16 /sys/block/sdad/device -&gt=
; ../../devices/pci0000:00/0000:00:07.0/0000:06:00.1/host2/rport-2:0-2/targ=
et2:0:2/2:0:2:14<br>
[snipped... long output]<br><br>I can see that all the host1 lines contain =
06:00.0 (and 1:0:x:y devices at the end), while all the host2 lines contain=
 06:00.1 (and 2:0:x:y for device at the end)<br><br>In case of similar situ=
ation I would only have to see if<br>
a) I have a mix of host1 and host2 disks lines<br>=3D=3D&gt; each hba is se=
eing only one path; <br><br>b) I have only hostx lines<br>=3D=3D&gt; I have=
 only 1 hba involved in LUN visibility problems: the hosty missing in outpu=
t above (and related pci id)...<br>
and then with <br>cat /sys/class/fc_host/hosty/port_name<br>I would get its=
 wwpn to pass to SAN guys <br><br>Thanks!<br>

--0016e6d975c7ed1649048c72e8be--


--===============2081607714544664389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2081607714544664389==--
