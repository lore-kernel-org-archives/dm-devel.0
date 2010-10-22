From: Rahsaan Page <rahsaan.page-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Q: md-RAID1 creation with I/O error (attempt to access beyond end
 of device)
Date: Fri, 22 Oct 2010 08:46:54 -0400
Message-ID: <AANLkTineg_wHmd_es91=aGpr-bRLBp=xNikiO7i8MWBV@mail.gmail.com>
References: <4CC03D24020000A100010898@gwsmtp1.uni-regensburg.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=0015174bedce8b8d89049334091e
Return-path: <open-iscsi+bncCOfRkNbTFBDCj4bmBBoEUS6jtQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4CC03D24020000A100010898-fGY2nAV5vPx/OEjykgKEBs2foqfSTWces0AfqQuZ5sE@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

--0015174bedce8b8d89049334091e
Content-Type: text/plain; charset=ISO-8859-1

Hi Ulrich,

I dont think thats going to work, arent you suppose to create the raid with
xdisk, than create LVM on top of the raid?

On Thu, Oct 21, 2010 at 7:16 AM, Ulrich Windl <
Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org> wrote:

> Hi,
>
> not an iSCSI question, but maybe here's the right audience: I had
> sucessfully created a RAID1 using mdadm, multipath, iSCSI and some SAN
> storage on SLES10 SP3+Updates on x86_64. When I tried to do the same thing
> on a comparable machine, the RAID could not be created, because something
> tried to access the disk at a bad position. I reapeated the attempt with
> another set of disks of the same size, and it also failed.
>
> Details:
> # mdadm --verbose --create /dev/md5 --raid-devices=2 --level=raid1
> --bitmap=internal --assume-clean /dev/mapper/EVA1_L232_host05
> /dev/mapper/EVA2_L232_host05
> mdadm: /dev/mapper/EVA1_L232_host05 appears to be part of a raid array:
>    level=raid1 devices=2 ctime=Thu Oct 21 12:26:18 2010
> mdadm: /dev/mapper/EVA2_L232_host05 appears to be part of a raid array:
>    level=raid1 devices=2 ctime=Thu Oct 21 12:26:18 2010
> mdadm: size set to 31457216K
> Continue creating array? y
> mdadm: RUN_ARRAY failed: Input/output error
> mdadm: stopped /dev/md5
> hostname:~ # tail -24 /var/log/messages
>     Oct 21 12:28:05 hostname kernel: md: md5 stopped.
> Oct 21 12:28:07 hostname kernel: md: md5 stopped.
> Oct 21 12:29:46 hostname kernel: md: bind<dm-21>
> Oct 21 12:29:46 hostname kernel: md: bind<dm-14>
> Oct 21 12:29:46 hostname kernel: raid1: raid set md5 active with 2 out of 2
> mirrors
> Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date (0 < 1) --
> forcing full recovery
> Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date, doing
> full recovery
> Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
> Oct 21 12:29:46 hostname kernel: dm-14: rw=8, want=62914568, limit=62914560
> Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
> Oct 21 12:29:46 hostname kernel: dm-21: rw=8, want=62914568, limit=62914560
> Oct 21 12:29:46 hostname kernel: md5: bitmap initialized from disk: read
> 15/16 pages, set 489472 bits, status: -5
> Oct 21 12:29:46 hostname kernel: md5: failed to create bitmap (-5)
> Oct 21 12:29:46 hostname kernel: md: pers->run() failed ...
> Oct 21 12:29:46 hostname kernel: md: md5 stopped.
> Oct 21 12:29:46 hostname kernel: md: unbind<dm-14>
> Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-14)
> Oct 21 12:29:46 hostname kernel: md: unbind<dm-21>
> Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-21)
>
> hostname:~ # mdadm --query -X /dev/mapper/EVA2_L232_host05
> mdadm: WARNING: bitmap file is not large enough for array size 62914432!
>
>        Filename : /dev/mapper/EVA2_L232_host05
>           Magic : 6d746962
>         Version : 4
>            UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
>          Events : 0
>  Events Cleared : 0
>           State : Out of date
>       Chunksize : 64 KB
>          Daemon : 5s flush period
>      Write Mode : Normal
>       Sync Size : 31457216 (30.00 GiB 32.21 GB)
>          Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
> hostname:~ # mdadm --query -X /dev/mapper/EVA1_L232_host05
> mdadm: WARNING: bitmap file is not large enough for array size 62914432!
>
>        Filename : /dev/mapper/EVA1_L232_host05
>           Magic : 6d746962
>         Version : 4
>            UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
>          Events : 0
>  Events Cleared : 0
>           State : Out of date
>       Chunksize : 64 KB
>          Daemon : 5s flush period
>      Write Mode : Normal
>       Sync Size : 31457216 (30.00 GiB 32.21 GB)
>          Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
>
> "blockdev --getsize" reports "62914560" for each LUN being used.
>
> Regards,
> Ulrich
>
>
> --
> You received this message because you are subscribed to the Google Groups
> "open-iscsi" group.
> To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To unsubscribe from this group, send email to
> open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org<open-iscsi%2Bunsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
> .
> For more options, visit this group at
> http://groups.google.com/group/open-iscsi?hl=en.
>
>


-- 
Rahsaan D. Page

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.


--0015174bedce8b8d89049334091e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ulrich,<br><br>I dont think thats going to work, arent you suppose to cr=
eate the raid with xdisk, than create LVM on top of the raid?<br><br><div c=
lass=3D"gmail_quote">On Thu, Oct 21, 2010 at 7:16 AM, Ulrich Windl <span di=
r=3D"ltr">&lt;<a href=3D"mailto:Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org">Ulrich.W=
indl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; borde=
r-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">Hi,<br>
<br>
not an iSCSI question, but maybe here&#39;s the right audience: I had suces=
sfully created a RAID1 using mdadm, multipath, iSCSI and some SAN storage o=
n SLES10 SP3+Updates on x86_64. When I tried to do the same thing on a comp=
arable machine, the RAID could not be created, because something tried to a=
ccess the disk at a bad position. I reapeated the attempt with another set =
of disks of the same size, and it also failed.<br>

<br>
Details:<br>
# mdadm --verbose --create /dev/md5 --raid-devices=3D2 --level=3Draid1 --bi=
tmap=3Dinternal --assume-clean /dev/mapper/EVA1_L232_host05 /dev/mapper/EVA=
2_L232_host05<br>
mdadm: /dev/mapper/EVA1_L232_host05 appears to be part of a raid array:<br>
 =A0 =A0level=3Draid1 devices=3D2 ctime=3DThu Oct 21 12:26:18 2010<br>
mdadm: /dev/mapper/EVA2_L232_host05 appears to be part of a raid array:<br>
 =A0 =A0level=3Draid1 devices=3D2 ctime=3DThu Oct 21 12:26:18 2010<br>
mdadm: size set to 31457216K<br>
Continue creating array? y<br>
mdadm: RUN_ARRAY failed: Input/output error<br>
mdadm: stopped /dev/md5<br>
hostname:~ # tail -24 /var/log/messages =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Oct 21 12:28:05 hostname kerne=
l: md: md5 stopped.<br>
Oct 21 12:28:07 hostname kernel: md: md5 stopped.<br>
Oct 21 12:29:46 hostname kernel: md: bind&lt;dm-21&gt;<br>
Oct 21 12:29:46 hostname kernel: md: bind&lt;dm-14&gt;<br>
Oct 21 12:29:46 hostname kernel: raid1: raid set md5 active with 2 out of 2=
 mirrors<br>
Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date (0 &lt; 1)=
 -- forcing full recovery<br>
Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date, doing ful=
l recovery<br>
Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device<br>
Oct 21 12:29:46 hostname kernel: dm-14: rw=3D8, want=3D62914568, limit=3D62=
914560<br>
Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device<br>
Oct 21 12:29:46 hostname kernel: dm-21: rw=3D8, want=3D62914568, limit=3D62=
914560<br>
Oct 21 12:29:46 hostname kernel: md5: bitmap initialized from disk: read 15=
/16 pages, set 489472 bits, status: -5<br>
Oct 21 12:29:46 hostname kernel: md5: failed to create bitmap (-5)<br>
Oct 21 12:29:46 hostname kernel: md: pers-&gt;run() failed ...<br>
Oct 21 12:29:46 hostname kernel: md: md5 stopped.<br>
Oct 21 12:29:46 hostname kernel: md: unbind&lt;dm-14&gt;<br>
Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-14)<br>
Oct 21 12:29:46 hostname kernel: md: unbind&lt;dm-21&gt;<br>
Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-21)<br>
<br>
hostname:~ # mdadm --query -X /dev/mapper/EVA2_L232_host05<br>
mdadm: WARNING: bitmap file is not large enough for array size 62914432!<br=
>
<br>
 =A0 =A0 =A0 =A0Filename : /dev/mapper/EVA2_L232_host05<br>
 =A0 =A0 =A0 =A0 =A0 Magic : 6d746962<br>
 =A0 =A0 =A0 =A0 Version : 4<br>
 =A0 =A0 =A0 =A0 =A0 =A0UUID : c522ab5a:24f292a0:0b3d7356:64ade12a<br>
 =A0 =A0 =A0 =A0 =A0Events : 0<br>
 =A0Events Cleared : 0<br>
 =A0 =A0 =A0 =A0 =A0 State : Out of date<br>
 =A0 =A0 =A0 Chunksize : 64 KB<br>
 =A0 =A0 =A0 =A0 =A0Daemon : 5s flush period<br>
 =A0 =A0 =A0Write Mode : Normal<br>
 =A0 =A0 =A0 Sync Size : 31457216 (30.00 GiB 32.21 GB)<br>
 =A0 =A0 =A0 =A0 =A0Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)<br=
>
hostname:~ # mdadm --query -X /dev/mapper/EVA1_L232_host05<br>
mdadm: WARNING: bitmap file is not large enough for array size 62914432!<br=
>
<br>
 =A0 =A0 =A0 =A0Filename : /dev/mapper/EVA1_L232_host05<br>
 =A0 =A0 =A0 =A0 =A0 Magic : 6d746962<br>
 =A0 =A0 =A0 =A0 Version : 4<br>
 =A0 =A0 =A0 =A0 =A0 =A0UUID : c522ab5a:24f292a0:0b3d7356:64ade12a<br>
 =A0 =A0 =A0 =A0 =A0Events : 0<br>
 =A0Events Cleared : 0<br>
 =A0 =A0 =A0 =A0 =A0 State : Out of date<br>
 =A0 =A0 =A0 Chunksize : 64 KB<br>
 =A0 =A0 =A0 =A0 =A0Daemon : 5s flush period<br>
 =A0 =A0 =A0Write Mode : Normal<br>
 =A0 =A0 =A0 Sync Size : 31457216 (30.00 GiB 32.21 GB)<br>
 =A0 =A0 =A0 =A0 =A0Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)<br=
>
<br>
&quot;blockdev --getsize&quot; reports &quot;62914560&quot; for each LUN be=
ing used.<br>
<br>
Regards,<br>
Ulrich<br>
<font color=3D"#888888"><br>
<br>
--<br>
You received this message because you are subscribed to the Google Groups &=
quot;open-iscsi&quot; group.<br>
To post to this group, send email to <a href=3D"mailto:open-iscsi@googlegro=
ups.com">open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br>
To unsubscribe from this group, send email to <a href=3D"mailto:open-iscsi%=
2Bunsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>=
.<br>
For more options, visit this group at <a href=3D"http://groups.google.com/g=
roup/open-iscsi?hl=3Den" target=3D"_blank">http://groups.google.com/group/o=
pen-iscsi?hl=3Den</a>.<br>
<br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Rahsaan D. Page<=
br>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.<br />
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org<br />
To unsubscribe from this group, send email to open-iscsi+unsubscribe@google=
groups.com.<br />

For more options, visit this group at http://groups.google.com/group/open-i=
scsi?hl=3Den.<br />



--0015174bedce8b8d89049334091e--
