From: "neelima dahiya" <neelima.dahiya@gmail.com>
Subject: Re: device-mapper: device /dev/hdc too small for target
Date: Wed, 1 Mar 2006 12:38:17 +0530
Message-ID: <40b3fe60602282308u6394cd30i5c6aab3e4923ac55@mail.gmail.com>
References: <43E8DAD6.3030208@kreno.be> <20060207184106.GB22775@tik.ee.ethz.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0221104219=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060207184106.GB22775@tik.ee.ethz.ch>
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

--===============0221104219==
Content-Type: multipart/alternative;
	boundary="----=_Part_16378_29734418.1141196897037"

------=_Part_16378_29734418.1141196897037
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

I am a new linux user
this device mapper mutilpathing has been disturbing me for quite sometime
now.
can anyone please tell me what are the hardware requirements for using
kpartx and mutipathing on linux

Thanks,
neelima


On 2/8/06, Arno Wagner <wagner@tik.ee.ethz.ch> wrote:
>
> Is it possible that you are using the wrong target type,
> e.g. RAID0/1/5? That would explain the complaint about hdc being
> too small. Maybe you do not have linear in as target type
> in the new system?
>
> If you do a 'cat /proc/mdstat', it needs to list the
> 'linear' target, like this:
>
> root ~>cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid5] [raid10]
> ...             ^^^^^^^^
>
> Arno
>
>
> On Tue, Feb 07, 2006 at 06:37:26PM +0100, Thomas Berton wrote:
> > Hello,
> > I'm encountering some problems with device-mapper when migrating my lvm
> > system to a new debian system.
> > I must say I had to play around with pvcreate and vgcfgrestore to get
> > /dev/hdb recognized again on the new system but after fixing that issue
> > I'm stuck with following problem:
> > Booting the new system with the lvm disks it seems that the
> > device-mapper is having troubles putting together the lvm device:
> >
> > output from dmesg:
> > device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
> > device-mapper: device /dev/hdc too small for target
> > device-mapper: : dm-linear: Device lookup failed
> >
> > device-mapper: error adding target to table
> >
> > Starting the lvm service gives the following:
> > storage:~# /etc/init.d/lvm start
> > Setting up LVM Volume Groups...
> > Reading all physical volumes.  This may take a while...
> > Found volume group "storage" using metadata type lvm2
> > /dev/storage: opendir failed: No such file or directory
> > device-mapper ioctl cmd 9 failed: Invalid argument
> > Couldn't load device 'storage-storage1'.
> > 1 logical volume(s) in volume group "storage" now active
> > storage:~#
> >
> > Nevertheless other lvm commands seem to display correct information
> > about the lvm.
> > Below is the output from pvscan, lvscan, lvmdiskscan, pvdisplay and
> > vgdisplay.
> > The lvm is appearing in the /dev/mapper folder, but no link is made in
> > the /dev folder btw.
> > Mounting the lvm fails, gives the error of bad superblock (ext3
> > filesystem).
> > The lvm has been created using the full disks and not working on
> > partitions.
> > I'm hoping someone on this list can help me out or give me some pointer=
s
> > on how to continue and getting the disks right and making my lvm
> > mountable again.
> > Thx in advance,
> > Thomas.
> >
> > storage:~# pvscan
> > PV /dev/hda   VG storage   lvm2 [279.46 GB / 0    free]
> > PV /dev/hdc   VG storage   lvm2 [189.92 GB / 0    free]
> > PV /dev/hdb   VG storage   lvm2 [279.46 GB / 0    free]
> > Total: 3 [748.84 GB] / in use: 3 [748.84 GB] / in no VG: 0 [0   ]
> > storage:~#
> >
> > storage:~# lvscan
> > ACTIVE            '/dev/storage/storage1' [748.84 GB] inherit
> > storage:~#
> >
> > storage:~# lvmdiskscan
> > /dev/hda  [      279.46 GB] LVM physical volume
> > /dev/hdc  [      189.92 GB] LVM physical volume
> > /dev/sda1 [       18.63 GB]
> > /dev/sda2 [      957.00 MB]
> > /dev/sda3 [        4.66 GB]
> > /dev/sda5 [      956.97 MB]
> > /dev/sda6 [        2.80 GB]
> > /dev/hdb  [      279.46 GB] LVM physical volume
> > 0 disks
> > 5 partitions
> > 3 LVM physical volume whole disks
> > 0 LVM physical volumes
> > storage:~#
> >
> > storage:~# pvdisplay
> > --- Physical volume ---
> > PV Name               /dev/hda
> > VG Name               storage
> > PV Size               279.46 GB / not usable 0
> > Allocatable           yes (but full)
> > PE Size (KByte)       4096
> > Total PE              71541
> > Free PE               0
> > Allocated PE          71541
> > PV UUID               ZDOYsq-1rGU-bngq-QVZu-DqvG-I7AO-r7Rnl5
> >
> > --- Physical volume ---
> > PV Name               /dev/hdc
> > VG Name               storage
> > PV Size               189.92 GB / not usable 0
> > Allocatable           yes (but full)
> > PE Size (KByte)       4096
> > Total PE              48620
> > Free PE               0
> > Allocated PE          48620
> > PV UUID               VT7Lkj-n4V1-G8mV-a6GF-kspp-Zs61-3YzXD3
> >
> > --- Physical volume ---
> > PV Name               /dev/hdb
> > VG Name               storage
> > PV Size               279.46 GB / not usable 0
> > Allocatable           yes (but full)
> > PE Size (KByte)       4096
> > Total PE              71541
> > Free PE               0
> > Allocated PE          71541
> > PV UUID               jJqtAX-XxMz-nIEC-2ast-7y40-XPFG-rN0Rzz
> > storage:~#
> >
> > storage:~# vgdisplay
> > --- Volume group ---
> > VG Name               storage
> > System ID
> > Format                lvm2
> > Metadata Areas        3
> > Metadata Sequence No  12
> > VG Access             read/write
> > VG Status             resizable
> > MAX LV                0
> > Cur LV                1
> > Open LV               0
> > Max PV                0
> > Cur PV                3
> > Act PV                3
> > VG Size               748.84 GB
> > PE Size               4.00 MB
> > Total PE              191702
> > Alloc PE / Size       191702 / 748.84 GB
> > Free  PE / Size       0 / 0
> > VG UUID               59Yxut-UcZa-MBUS-KH8Y-5wZP-Eh1x-1E33Wl
> >
> > storage:~#
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
> --
> Arno Wagner, Dipl. Inform., CISSP --- CSG, ETH Zurich,
> wagner@tik.ee.ethz.ch
> GnuPG:  ID: 1E25338F  FP: 0C30 5782 9D93 F785 E79C  0296 797F 6B50 1E25
> 338F
> ----
> Cuddly UI's are the manifestation of wishful thinking. -- Dylan Evans
> Windows is the "under-3" toy of the OS world. -- Matthew D. Fuller
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_16378_29734418.1141196897037
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div>Hi </div>
<div>&nbsp;</div>
<div>I am a new linux user </div>
<div>this device mapper mutilpathing has been disturbing me for quite somet=
ime now.</div>
<div>can anyone please tell me what are the hardware requirements for using=
 kpartx and mutipathing on linux</div>
<div>&nbsp;</div>
<div>Thanks,</div>
<div>neelima<br><br>&nbsp;</div>
<div><span class=3D"gmail_quote">On 2/8/06, <b class=3D"gmail_sendername">A=
rno Wagner</b> &lt;<a href=3D"mailto:wagner@tik.ee.ethz.ch">wagner@tik.ee.e=
thz.ch</a>&gt; wrote:</span>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Is it possible that you are usin=
g the wrong target type,<br>e.g. RAID0/1/5? That would explain the complain=
t about hdc being
<br>too small. Maybe you do not have linear in as target type<br>in the new=
 system?<br><br>If you do a 'cat /proc/mdstat', it needs to list the<br>'li=
near' target, like this:<br><br>root ~&gt;cat /proc/mdstat<br>Personalities=
 : [linear] [raid0] [raid1] [raid5] [raid10]
<br>...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; ^^^^^^^^<br><br>Arno<br><br><br>On Tue, Feb 07, 2006 at 06:37:26PM +01=
00, Thomas Berton wrote:<br>&gt; Hello,<br>&gt; I'm encountering some probl=
ems with device-mapper when migrating my lvm<br>&gt; system to a new debian=
 system.
<br>&gt; I must say I had to play around with pvcreate and vgcfgrestore to =
get<br>&gt; /dev/hdb recognized again on the new system but after fixing th=
at issue<br>&gt; I'm stuck with following problem:<br>&gt; Booting the new =
system with the lvm disks it seems that the
<br>&gt; device-mapper is having troubles putting together the lvm device:<=
br>&gt;<br>&gt; output from dmesg:<br>&gt; device-mapper: 4.1.0-ioctl (2003=
-12-10) initialised: <a href=3D"mailto:dm@uk.sistina.com">dm@uk.sistina.com
</a><br>&gt; device-mapper: device /dev/hdc too small for target<br>&gt; de=
vice-mapper: : dm-linear: Device lookup failed<br>&gt;<br>&gt; device-mappe=
r: error adding target to table<br>&gt;<br>&gt; Starting the lvm service gi=
ves the following:
<br>&gt; storage:~# /etc/init.d/lvm start<br>&gt; Setting up LVM Volume Gro=
ups...<br>&gt; Reading all physical volumes.&nbsp;&nbsp;This may take a whi=
le...<br>&gt; Found volume group &quot;storage&quot; using metadata type lv=
m2<br>
&gt; /dev/storage: opendir failed: No such file or directory<br>&gt; device=
-mapper ioctl cmd 9 failed: Invalid argument<br>&gt; Couldn't load device '=
storage-storage1'.<br>&gt; 1 logical volume(s) in volume group &quot;storag=
e&quot; now active
<br>&gt; storage:~#<br>&gt;<br>&gt; Nevertheless other lvm commands seem to=
 display correct information<br>&gt; about the lvm.<br>&gt; Below is the ou=
tput from pvscan, lvscan, lvmdiskscan, pvdisplay and<br>&gt; vgdisplay.
<br>&gt; The lvm is appearing in the /dev/mapper folder, but no link is mad=
e in<br>&gt; the /dev folder btw.<br>&gt; Mounting the lvm fails, gives the=
 error of bad superblock (ext3<br>&gt; filesystem).<br>&gt; The lvm has bee=
n created using the full disks and not working on
<br>&gt; partitions.<br>&gt; I'm hoping someone on this list can help me ou=
t or give me some pointers<br>&gt; on how to continue and getting the disks=
 right and making my lvm<br>&gt; mountable again.<br>&gt; Thx in advance,
<br>&gt; Thomas.<br>&gt;<br>&gt; storage:~# pvscan<br>&gt; PV /dev/hda&nbsp=
;&nbsp; VG storage&nbsp;&nbsp; lvm2 [279.46 GB / 0&nbsp;&nbsp;&nbsp;&nbsp;f=
ree]<br>&gt; PV /dev/hdc&nbsp;&nbsp; VG storage&nbsp;&nbsp; lvm2 [189.92 GB=
 / 0&nbsp;&nbsp;&nbsp;&nbsp;free]<br>&gt; PV /dev/hdb&nbsp;&nbsp; VG storag=
e&nbsp;&nbsp; lvm2 [279.46
 GB / 0&nbsp;&nbsp;&nbsp;&nbsp;free]<br>&gt; Total: 3 [748.84 GB] / in use:=
 3 [748.84 GB] / in no VG: 0 [0&nbsp;&nbsp; ]<br>&gt; storage:~#<br>&gt;<br=
>&gt; storage:~# lvscan<br>&gt; ACTIVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'/dev/storage/storage1' [748.84 GB] inhe=
rit<br>&gt; storage:~#
<br>&gt;<br>&gt; storage:~# lvmdiskscan<br>&gt; /dev/hda&nbsp;&nbsp;[&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;279.46 GB] LVM physical volume<br>&gt; /dev/h=
dc&nbsp;&nbsp;[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;189.92 GB] LVM physical =
volume<br>&gt; /dev/sda1 [&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18.63 GB]<br=
>&gt; /dev/sda2 [&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;957.00 MB]
<br>&gt; /dev/sda3 [&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.66 GB=
]<br>&gt; /dev/sda5 [&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;956.97 MB]<br>&gt;=
 /dev/sda6 [&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.80 GB]<br>&gt=
; /dev/hdb&nbsp;&nbsp;[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;279.46 GB] LVM p=
hysical volume<br>&gt; 0 disks<br>&gt; 5 partitions<br>&gt; 3 LVM physical =
volume whole disks
<br>&gt; 0 LVM physical volumes<br>&gt; storage:~#<br>&gt;<br>&gt; storage:=
~# pvdisplay<br>&gt; --- Physical volume ---<br>&gt; PV Name&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/=
hda<br>&gt; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; storage<br>&gt; PV Size&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
279.46 GB / not usable 0<br>&gt; Allocatable&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes (but full)<br>&gt; PE Size (KByte)&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>&gt; Total PE&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;71541<br>&gt; F=
ree PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; 0<br>&gt; Allocated PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;71541<br>&gt; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ZDOYsq-1rGU-bngq-QVZu=
-DqvG-I7AO-r7Rnl5
<br>&gt;<br>&gt; --- Physical volume ---<br>&gt; PV Name&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/hdc<=
br>&gt; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; storage<br>&gt; PV Size&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 189.92 GB / not u=
sable 0<br>&gt; Allocatable&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; yes (but full)<br>
&gt; PE Size (KByte)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>&gt; Total=
 PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;48620<br>&gt; Free PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&gt; Allocated PE&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;48620<br>&gt; PV UUID&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; VT7Lkj-n4V1-G8mV-a6GF-kspp-Zs61-3YzXD3<br>&gt;<br>&gt; --- Physical v=
olume ---
<br>&gt; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; /dev/hdb<br>&gt; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; storage<br>&gt;=
 PV Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 279.46 GB / not usable 0<br>&gt; Allocatable&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes (but full)<br>&gt; PE S=
ize (KByte)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>&gt; Total PE&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;71541
<br>&gt; Free PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&gt; Allocated PE&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;71541<br>&gt; PV UUID&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; jJqtAX-XxMz=
-nIEC-2ast-7y40-XPFG-rN0Rzz<br>&gt; storage:~#<br>&gt;<br>&gt; storage:~# v=
gdisplay<br>&gt; --- Volume group ---
<br>&gt; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; storage<br>&gt; System ID<br>&gt; Format&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;lvm2<br>&gt; Metadata Areas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;3<br>&gt; Metadata Sequence No&nbsp;&nbsp;12<br>&gt; VG Access&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rea=
d/write<br>&gt; VG Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; resizable
<br>&gt; MAX LV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br>&gt; Cur LV&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1<=
br>&gt; Open LV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&gt; Max PV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<br>&gt; Cur=
 PV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;3<br>&gt; Act PV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3<br>&gt; VG S=
ize&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;=20
748.84 GB<br>&gt; PE Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4.00 MB<br>&gt; Total PE&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;191702<=
br>&gt; Alloc PE / Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 191702 / 748.84=
 GB<br>&gt; Free&nbsp;&nbsp;PE / Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0=
 / 0<br>&gt; VG UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 59Yxut-UcZa-MBUS-KH8Y-5wZP-Eh1x-1E33Wl
<br>&gt;<br>&gt; storage:~#<br>&gt;<br>&gt; --<br>&gt; dm-devel mailing lis=
t<br>&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br=
>&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://=
www.redhat.com/mailman/listinfo/dm-devel
</a><br>&gt;<br><br>--<br>Arno Wagner, Dipl. Inform., CISSP --- CSG, ETH Zu=
rich, <a href=3D"mailto:wagner@tik.ee.ethz.ch">wagner@tik.ee.ethz.ch</a><br=
>GnuPG:&nbsp;&nbsp;ID: 1E25338F&nbsp;&nbsp;FP: 0C30 5782 9D93 F785 E79C&nbs=
p;&nbsp;0296 797F 6B50 1E25 338F
<br>----<br>Cuddly UI's are the manifestation of wishful thinking. -- Dylan=
 Evans<br>Windows is the &quot;under-3&quot; toy of the OS world. -- Matthe=
w D. Fuller<br><br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-deve=
l@redhat.com">
dm-devel@redhat.com</a><br><a href=3D"https://www.redhat.com/mailman/listin=
fo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></bloc=
kquote></div><br>

------=_Part_16378_29734418.1141196897037--


--===============0221104219==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0221104219==--
