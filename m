From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: fstrim discarding too many or wrong blocks on Linux
 5.1, leading to data loss
Date: Mon, 20 May 2019 15:53:30 +0200
Message-ID: <CAK-xaQYPs62v971zm1McXw_FGzDmh_vpz3KLEbxzkmrsSgTfXw@mail.gmail.com>
References: <297da4cbe20235080205719805b08810@bi-co.net>
	<CAJCQCtR-uo9fgs66pBMEoYX_xAye=O-L8kiMwyAdFjPS5T4+CA@mail.gmail.com>
	<8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
	<CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
	<AD966642-1043-468D-BABF-8FC9AF514D36@bi-co.net>
	<158a3491-e4d2-d905-7f58-11a15bddcd70@gmx.com>
	<C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3843945107317580719=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?UTF-8?B?TWljaGFlbCBMYcOf?= <bevan@bi-co.net>
Cc: dm-devel@redhat.com, Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
List-Id: dm-devel.ids

--===============3843945107317580719==
Content-Type: multipart/alternative; boundary="000000000000794ed60589520fbd"

--000000000000794ed60589520fbd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Had same issue on a similar (well,  quite exactly same setup), on a machine
in production.
But It Is more than 4 tera of data, so in the end I re-dd the image and
restarted, sticking to 5.0.y branch never had problem.
I was able to replicate it. SSD Samsung, more recent version.
Not with btrfs but ext4, by the way.
I saw the discard of big initial part of lvm partition. I can't find
superblocks Copy in the First half, but torwards the end of logical volume.

Sorry, i can't play with It again, but i have the whole (4 tera) dd image
with the bug.


Ciao,
Gelma

Il lun 20 mag 2019, 02:38 Michael La=C3=9F <bevan@bi-co.net> ha scritto:

> CC'ing dm-devel, as this seems to be a dm-related issue. Short summary fo=
r
> new readers:
>
> On Linux 5.1 (tested up to 5.1.3), fstrim may discard too many blocks,
> leading to data loss. I have the following storage stack:
>
> btrfs
> dm-crypt (LUKS)
> LVM logical volume
> LVM single physical volume
> MBR partition
> Samsung 830 SSD
>
> The mapping between logical volumes and physical segments is a bit mixed
> up. See below for the output for =E2=80=9Cpvdisplay -m=E2=80=9D. When I i=
ssue fstrim on the
> mounted btrfs volume, I get the following kernel messages:
>
> attempt to access beyond end of device
> sda1: rw=3D16387, want=3D252755893, limit=3D250067632
> BTRFS warning (device dm-5): failed to trim 1 device(s), last error -5
>
> At the same time, other logical volumes on the same physical volume are
> destroyed. Also the btrfs volume itself may be damaged (this seems to
> depend on the actual usage).
>
> I can easily reproduce this issue locally and I=E2=80=99m currently bisec=
ting. So
> far I could narrow down the range of commits to:
> Good: 92fff53b7191cae566be9ca6752069426c7f8241
> Bad: 225557446856448039a9e495da37b72c20071ef2
>
> In this range of commits, there are only dm-related changes.
>
> So far, I have not reproduced the issue with other file systems or a
> simplified stack. I first want to continue bisecting but this may take
> another day.
>
>
> > Am 18.05.2019 um 12:26 schrieb Qu Wenruo <quwenruo.btrfs@gmx.com>:
> > On 2019/5/18 =E4=B8=8B=E5=8D=885:18, Michael La=C3=9F wrote:
> >>
> >>> Am 18.05.2019 um 06:09 schrieb Chris Murphy <lists@colorremedies.com>=
:
> >>>
> >>> On Fri, May 17, 2019 at 11:37 AM Michael La=C3=9F <bevan@bi-co.net> w=
rote:
> >>>>
> >>>>
> >>>> I tried to reproduce this issue: I recreated the btrfs file system,
> set up a minimal system and issued fstrim again. It printed the following
> error message:
> >>>>
> >>>> fstrim: /: FITRIM ioctl failed: Input/output error
> >>>
> >>> Huh. Any kernel message at the same time? I would expect any fstrim
> >>> user space error message to also have a kernel message. Any i/o error
> >>> suggests some kind of storage stack failure - which could be hardware
> >>> or software, you can't know without seeing the kernel messages.
> >>
> >> I missed that. The kernel messages are:
> >>
> >> attempt to access beyond end of device
> >> sda1: rw=3D16387, want=3D252755893, limit=3D250067632
> >> BTRFS warning (device dm-5): failed to trim 1 device(s), last error -5
> >>
> >> Here are some more information on the partitions and LVM physical
> segments:
> >>
> >> fdisk -l /dev/sda:
> >>
> >> Device     Boot Start       End   Sectors   Size Id Type
> >> /dev/sda1  *     2048 250069679 250067632 119.2G 8e Linux LVM
> >>
> >> pvdisplay -m:
> >>
> >>  --- Physical volume ---
> >>  PV Name               /dev/sda1
> >>  VG Name               vg_system
> >>  PV Size               119.24 GiB / not usable <22.34 MiB
> >>  Allocatable           yes (but full)
> >>  PE Size               32.00 MiB
> >>  Total PE              3815
> >>  Free PE               0
> >>  Allocated PE          3815
> >>  PV UUID               mqCLFy-iDnt-NfdC-lfSv-Maor-V1Ih-RlG8lP
> >>
> >>  --- Physical Segments ---
> >>  Physical extent 0 to 1248:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   2231 to 3479
> >>  Physical extent 1249 to 1728:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   640 to 1119
> >>  Physical extent 1729 to 1760:
> >>    Logical volume    /dev/vg_system/grml-images
> >>    Logical extents   0 to 31
> >>  Physical extent 1761 to 2016:
> >>    Logical volume    /dev/vg_system/swap
> >>    Logical extents   0 to 255
> >>  Physical extent 2017 to 2047:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   3480 to 3510
> >>  Physical extent 2048 to 2687:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   0 to 639
> >>  Physical extent 2688 to 3007:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   1911 to 2230
> >>  Physical extent 3008 to 3320:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   1120 to 1432
> >>  Physical extent 3321 to 3336:
> >>    Logical volume    /dev/vg_system/boot
> >>    Logical extents   0 to 15
> >>  Physical extent 3337 to 3814:
> >>    Logical volume    /dev/vg_system/btrfs
> >>    Logical extents   1433 to 1910
> >>
> >>
> >> Would btrfs even be able to accidentally trim parts of other LVs or
> does this clearly hint towards a LVM/dm issue?
> >
> > I can't speak sure, but (at least for latest kernel) btrfs has a lot of
> > extra mount time self check, including chunk stripe check against
> > underlying device, thus the possibility shouldn't be that high for btrf=
s.
>
> Indeed, bisecting the issue led me to a range of commits that only
> contains dm-related and no btrfs-related changes. So I assume this is a b=
ug
> in dm.
>
> >> Is there an easy way to somehow trace the trim through the different
> layers so one can see where it goes wrong?
> >
> > Sure, you could use dm-log-writes.
> > It will record all read/write (including trim) for later replay.
> >
> > So in your case, you can build the storage stack like:
> >
> > Btrfs
> > <dm-log-writes>
> > LUKS/dmcrypt
> > LVM
> > MBR partition
> > Samsung SSD
> >
> > Then replay the log (using src/log-write/replay-log in fstests) with
> > verbose output, you can verify every trim operation against the dmcrypt
> > device size.
> >
> > If all trim are fine, then move the dm-log-writes a layer lower, until
> > you find which layer is causing the problem.
>
> That sounds like a plan! However, I first want to continue bisecting as I
> am afraid to lose my reproducer by changing parts of my storage stack.
>
> Cheers,
> Michael
>
> >
> > Thanks,
> > Qu
> >>
> >> Cheers,
> >> Michael
> >>
> >> PS: Current state of bisection: It looks like the error was introduced
> somewhere between b5dd0c658c31b469ccff1b637e5124851e7a4a1c and v5.1.
>
>

--000000000000794ed60589520fbd
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Had same issue on a similar (well,=C2=A0 quite exactly sa=
me setup), on a machine in production.<div dir=3D"auto">But It Is more than=
 4 tera of data, so in the end I re-dd the image and restarted, sticking to=
 5.0.y branch never had problem.</div><div dir=3D"auto">I was able to repli=
cate it. SSD Samsung, more recent version.</div><div dir=3D"auto">Not with =
btrfs but ext4, by the way.</div><div dir=3D"auto">I saw the discard of big=
 initial part of lvm partition. I can&#39;t find superblocks Copy in the Fi=
rst half, but torwards the end of logical volume.</div><div dir=3D"auto"><b=
r></div><div dir=3D"auto">Sorry, i can&#39;t play with It again, but i have=
 the whole (4 tera) dd image with the bug.</div><div dir=3D"auto"><br></div=
><div dir=3D"auto"><br></div><div dir=3D"auto">Ciao,</div><div dir=3D"auto"=
>Gelma</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"=
gmail_attr">Il lun 20 mag 2019, 02:38 Michael La=C3=9F &lt;<a href=3D"mailt=
o:bevan@bi-co.net">bevan@bi-co.net</a>&gt; ha scritto:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">CC&#39;ing dm-devel, as this seems to be a dm-related i=
ssue. Short summary for new readers:<br>
<br>
On Linux 5.1 (tested up to 5.1.3), fstrim may discard too many blocks, lead=
ing to data loss. I have the following storage stack:<br>
<br>
btrfs<br>
dm-crypt (LUKS)<br>
LVM logical volume<br>
LVM single physical volume<br>
MBR partition<br>
Samsung 830 SSD<br>
<br>
The mapping between logical volumes and physical segments is a bit mixed up=
. See below for the output for =E2=80=9Cpvdisplay -m=E2=80=9D. When I issue=
 fstrim on the mounted btrfs volume, I get the following kernel messages:<b=
r>
<br>
attempt to access beyond end of device<br>
sda1: rw=3D16387, want=3D252755893, limit=3D250067632<br>
BTRFS warning (device dm-5): failed to trim 1 device(s), last error -5<br>
<br>
At the same time, other logical volumes on the same physical volume are des=
troyed. Also the btrfs volume itself may be damaged (this seems to depend o=
n the actual usage).<br>
<br>
I can easily reproduce this issue locally and I=E2=80=99m currently bisecti=
ng. So far I could narrow down the range of commits to:<br>
Good: 92fff53b7191cae566be9ca6752069426c7f8241<br>
Bad: 225557446856448039a9e495da37b72c20071ef2<br>
<br>
In this range of commits, there are only dm-related changes.<br>
<br>
So far, I have not reproduced the issue with other file systems or a simpli=
fied stack. I first want to continue bisecting but this may take another da=
y.<br>
<br>
<br>
&gt; Am 18.05.2019 um 12:26 schrieb Qu Wenruo &lt;<a href=3D"mailto:quwenru=
o.btrfs@gmx.com" target=3D"_blank" rel=3D"noreferrer">quwenruo.btrfs@gmx.co=
m</a>&gt;:<br>
&gt; On 2019/5/18 =E4=B8=8B=E5=8D=885:18, Michael La=C3=9F wrote:<br>
&gt;&gt; <br>
&gt;&gt;&gt; Am 18.05.2019 um 06:09 schrieb Chris Murphy &lt;<a href=3D"mai=
lto:lists@colorremedies.com" target=3D"_blank" rel=3D"noreferrer">lists@col=
orremedies.com</a>&gt;:<br>
&gt;&gt;&gt; <br>
&gt;&gt;&gt; On Fri, May 17, 2019 at 11:37 AM Michael La=C3=9F &lt;<a href=
=3D"mailto:bevan@bi-co.net" target=3D"_blank" rel=3D"noreferrer">bevan@bi-c=
o.net</a>&gt; wrote:<br>
&gt;&gt;&gt;&gt; <br>
&gt;&gt;&gt;&gt; <br>
&gt;&gt;&gt;&gt; I tried to reproduce this issue: I recreated the btrfs fil=
e system, set up a minimal system and issued fstrim again. It printed the f=
ollowing error message:<br>
&gt;&gt;&gt;&gt; <br>
&gt;&gt;&gt;&gt; fstrim: /: FITRIM ioctl failed: Input/output error<br>
&gt;&gt;&gt; <br>
&gt;&gt;&gt; Huh. Any kernel message at the same time? I would expect any f=
strim<br>
&gt;&gt;&gt; user space error message to also have a kernel message. Any i/=
o error<br>
&gt;&gt;&gt; suggests some kind of storage stack failure - which could be h=
ardware<br>
&gt;&gt;&gt; or software, you can&#39;t know without seeing the kernel mess=
ages.<br>
&gt;&gt; <br>
&gt;&gt; I missed that. The kernel messages are:<br>
&gt;&gt; <br>
&gt;&gt; attempt to access beyond end of device<br>
&gt;&gt; sda1: rw=3D16387, want=3D252755893, limit=3D250067632<br>
&gt;&gt; BTRFS warning (device dm-5): failed to trim 1 device(s), last erro=
r -5<br>
&gt;&gt; <br>
&gt;&gt; Here are some more information on the partitions and LVM physical =
segments:<br>
&gt;&gt; <br>
&gt;&gt; fdisk -l /dev/sda:<br>
&gt;&gt; <br>
&gt;&gt; Device=C2=A0 =C2=A0 =C2=A0Boot Start=C2=A0 =C2=A0 =C2=A0 =C2=A0End=
=C2=A0 =C2=A0Sectors=C2=A0 =C2=A0Size Id Type<br>
&gt;&gt; /dev/sda1=C2=A0 *=C2=A0 =C2=A0 =C2=A02048 250069679 250067632 119.=
2G 8e Linux LVM<br>
&gt;&gt; <br>
&gt;&gt; pvdisplay -m:<br>
&gt;&gt; <br>
&gt;&gt;=C2=A0 --- Physical volume ---<br>
&gt;&gt;=C2=A0 PV Name=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/dev/sda1<br>
&gt;&gt;=C2=A0 VG Name=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0vg_system<br>
&gt;&gt;=C2=A0 PV Size=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0119.24 GiB / not usable &lt;22.34 MiB<br>
&gt;&gt;=C2=A0 Allocatable=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0yes (but=
 full)<br>
&gt;&gt;=C2=A0 PE Size=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A032.00 MiB<br>
&gt;&gt;=C2=A0 Total PE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 381=
5<br>
&gt;&gt;=C2=A0 Free PE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00<br>
&gt;&gt;=C2=A0 Allocated PE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3815<br>
&gt;&gt;=C2=A0 PV UUID=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0mqCLFy-iDnt-NfdC-lfSv-Maor-V1Ih-RlG8lP<br>
&gt;&gt; <br>
&gt;&gt;=C2=A0 --- Physical Segments ---<br>
&gt;&gt;=C2=A0 Physical extent 0 to 1248:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A02231 to 3479<br>
&gt;&gt;=C2=A0 Physical extent 1249 to 1728:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A0640 to 1119<br>
&gt;&gt;=C2=A0 Physical extent 1729 to 1760:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/grml-image=
s<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A00 to 31<br>
&gt;&gt;=C2=A0 Physical extent 1761 to 2016:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/swap<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A00 to 255<br>
&gt;&gt;=C2=A0 Physical extent 2017 to 2047:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A03480 to 3510<br>
&gt;&gt;=C2=A0 Physical extent 2048 to 2687:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A00 to 639<br>
&gt;&gt;=C2=A0 Physical extent 2688 to 3007:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A01911 to 2230<br>
&gt;&gt;=C2=A0 Physical extent 3008 to 3320:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A01120 to 1432<br>
&gt;&gt;=C2=A0 Physical extent 3321 to 3336:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/boot<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A00 to 15<br>
&gt;&gt;=C2=A0 Physical extent 3337 to 3814:<br>
&gt;&gt;=C2=A0 =C2=A0 Logical volume=C2=A0 =C2=A0 /dev/vg_system/btrfs<br>
&gt;&gt;=C2=A0 =C2=A0 Logical extents=C2=A0 =C2=A01433 to 1910<br>
&gt;&gt; <br>
&gt;&gt; <br>
&gt;&gt; Would btrfs even be able to accidentally trim parts of other LVs o=
r does this clearly hint towards a LVM/dm issue?<br>
&gt; <br>
&gt; I can&#39;t speak sure, but (at least for latest kernel) btrfs has a l=
ot of<br>
&gt; extra mount time self check, including chunk stripe check against<br>
&gt; underlying device, thus the possibility shouldn&#39;t be that high for=
 btrfs.<br>
<br>
Indeed, bisecting the issue led me to a range of commits that only contains=
 dm-related and no btrfs-related changes. So I assume this is a bug in dm.<=
br>
<br>
&gt;&gt; Is there an easy way to somehow trace the trim through the differe=
nt layers so one can see where it goes wrong?<br>
&gt; <br>
&gt; Sure, you could use dm-log-writes.<br>
&gt; It will record all read/write (including trim) for later replay.<br>
&gt; <br>
&gt; So in your case, you can build the storage stack like:<br>
&gt; <br>
&gt; Btrfs<br>
&gt; &lt;dm-log-writes&gt;<br>
&gt; LUKS/dmcrypt<br>
&gt; LVM<br>
&gt; MBR partition<br>
&gt; Samsung SSD<br>
&gt; <br>
&gt; Then replay the log (using src/log-write/replay-log in fstests) with<b=
r>
&gt; verbose output, you can verify every trim operation against the dmcryp=
t<br>
&gt; device size.<br>
&gt; <br>
&gt; If all trim are fine, then move the dm-log-writes a layer lower, until=
<br>
&gt; you find which layer is causing the problem.<br>
<br>
That sounds like a plan! However, I first want to continue bisecting as I a=
m afraid to lose my reproducer by changing parts of my storage stack.<br>
<br>
Cheers,<br>
Michael<br>
<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Qu<br>
&gt;&gt; <br>
&gt;&gt; Cheers,<br>
&gt;&gt; Michael<br>
&gt;&gt; <br>
&gt;&gt; PS: Current state of bisection: It looks like the error was introd=
uced somewhere between b5dd0c658c31b469ccff1b637e5124851e7a4a1c and v5.1.<b=
r>
<br>
</blockquote></div>

--000000000000794ed60589520fbd--


--===============3843945107317580719==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3843945107317580719==--
