From: Leonardo Santos <heiligerstein@gmail.com>
Subject: Re: dmcache RAID1 bug?
Date: Mon, 17 Nov 2014 16:14:57 -0200
Message-ID: <CAEZ+n-jJoCS0WqeeiETYf1jAwPJzy+fyEgr_-Qek+7NzS+uERQ@mail.gmail.com>
References: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
	<20141117144659.GA29929@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8914123524969303237=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141117144659.GA29929@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8914123524969303237==
Content-Type: multipart/alternative; boundary=089e0160ba3ac7314c050811f492

--089e0160ba3ac7314c050811f492
Content-Type: text/plain; charset=UTF-8

On Mon, Nov 17, 2014 at 12:46 PM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Nov 17 2014 at  9:24am -0500,
> Leonardo Santos <heiligerstein@gmail.com> wrote:
>
> > I'm working in tests for my msc thesis envolving dm_cache module. I'm
> > having problems with the following scenario:
> >
> > Slowstorage: RAID1 (mdadm) with 4 HDDs;
> > - /dev/md/raid1_4ssds
>
> You mean /dev/md/raid1_4hdds ?
>

A symlink to raid1 created using 4 ssds.

mdadm --create --verbose /dev/md/raid0_4ssds --raid-devices=4 --force
--level=1 /dev/sdd /dev/sdc /dev/sdb /dev/sda


>
> > -- /dev/sda
> > -- /dev/sdb
> > -- /dev/sdc
> > -- /dev/sdd
> >
> > Faststorage: RAID1 (mdadm) with 4 SSDs
> > - /dev/md/raid1_4hdds
>
> And /dev/md/raid1_4ssds here?
>

mdadm --create --verbose /dev/md/raid0_4hdds --raid-devices=4 --force
--level=1  /dev/sdh /dev/sdg /dev/sdf /dev/sde


>
> > -- /dev/sde
> > -- /dev/sdf
> > -- /dev/sdg
> > -- /dev/sdh
> >
> >
> > Cachestorage: dm_cache envolving both devices
> > - /dev/mapper/dmcache
> > -- /dev/md/raid1_4ssds
> > -- /dev/md/raid1_4hdds
> >
>

Commands:
vgcreate cache /dev/md/raid0_4ssds -y
lvcreate cache -n metadata -l 5%FREE
lvcreate cache -n block -l 100%FREE
dd if=/dev/zero of=/dev/cache/metadata bs=1M count=100
# 16773120 = blockdev --getsize /dev/md/raid0_4hdds
dmsetup create dmcache --table '0 16773120 cache /dev/cache/metadata
/dev/cache/block /dev/md/raid0_4hdds 512 1 writeback default 0'


> > Other informations (strange facts):
> > In RAID0 it's working very well.
> > In a virtual machine (vbox) it's working as well (in this case disks have
> > 2GB only for big tests automatization, in production are 160GB SSDs and
> 2TB
> > HDDs);
> >
> > Have you seen about this error? Syslog is bellow.
>
> Never seen this before... have you taken care to zero the dm-cache
> metadata's superblock (first 512B of the cache metadata device) each
> time you've reconfigured the cache device?
>
> Have you tried using the latest lvm2 to create the dm-cache device?
>

I've used LVM2 from distribution (debian) and a latest kernel version.

LVM2 latest today is 2.02.112 (I'll try with latest LVM2 version and post
results).

# lvm version
  LVM version:     2.02.95(2) (2012-03-06)
  Library version: 1.02.74 (2012-03-06)
  Driver version:  4.27.0

# uname -a
Linux steinhager 3.17.2 #2 SMP Fri Nov 7 12:49:16 BRST 2014 x86_64 GNU/Linux

--089e0160ba3ac7314c050811f492
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Nov 17, 2014 at 12:46 PM, Mike Snitzer <span dir=3D"ltr">&lt;<a href=3D=
"mailto:snitzer@redhat.com" target=3D"_blank">snitzer@redhat.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex"><span class=3D"">On Mon, Nov 17 2014 at=C2=
=A0 9:24am -0500,<br>
Leonardo Santos &lt;<a href=3D"mailto:heiligerstein@gmail.com">heiligerstei=
n@gmail.com</a>&gt; wrote:<br>
<br>
&gt; I&#39;m working in tests for my msc thesis envolving dm_cache module. =
I&#39;m<br>
&gt; having problems with the following scenario:<br>
&gt;<br>
&gt; Slowstorage: RAID1 (mdadm) with 4 HDDs;<br>
&gt; - /dev/md/raid1_4ssds<br>
<br>
</span>You mean /dev/md/raid1_4hdds ?<br></blockquote><div><br></div><div>A=
 symlink to raid1 created using 4 ssds.</div><div><br></div><div>mdadm --cr=
eate --verbose /dev/md/raid0_4ssds --raid-devices=3D4 --force --level=3D1 /=
dev/sdd /dev/sdc /dev/sdb /dev/sda<br></div><div>=C2=A0</div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px=
;border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1e=
x">
<span class=3D""><br>
&gt; -- /dev/sda<br>
&gt; -- /dev/sdb<br>
&gt; -- /dev/sdc<br>
&gt; -- /dev/sdd<br>
&gt;<br>
&gt; Faststorage: RAID1 (mdadm) with 4 SSDs<br>
&gt; - /dev/md/raid1_4hdds<br>
<br>
</span>And /dev/md/raid1_4ssds here?<br></blockquote><div><br></div><div>md=
adm --create --verbose /dev/md/raid0_4hdds --raid-devices=3D4 --force --lev=
el=3D1 =C2=A0/dev/sdh /dev/sdg /dev/sdf /dev/sde<br></div><div>=C2=A0</div>=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
<span class=3D""><br>
&gt; -- /dev/sde<br>
&gt; -- /dev/sdf<br>
&gt; -- /dev/sdg<br>
&gt; -- /dev/sdh<br>
&gt;<br>
&gt;<br>
&gt; Cachestorage: dm_cache envolving both devices<br>
&gt; - /dev/mapper/dmcache<br>
&gt; -- /dev/md/raid1_4ssds<br>
&gt; -- /dev/md/raid1_4hdds<br>
&gt;<br></span></blockquote><div><br></div><div>Commands:</div><div>vgcreat=
e cache /dev/md/raid0_4ssds -y<br></div><div><div>lvcreate cache -n metadat=
a -l 5%FREE<br></div><div>lvcreate cache -n block -l 100%FREE<br></div><div=
>dd if=3D/dev/zero of=3D/dev/cache/metadata bs=3D1M count=3D100<br></div><d=
iv>#=C2=A016773120=C2=A0=3D blockdev --getsize /dev/md/raid0_4hdds<br></div=
><div>dmsetup create dmcache --table &#39;0 16773120 cache /dev/cache/metad=
ata /dev/cache/block /dev/md/raid0_4hdds 512 1 writeback default 0&#39;</di=
v></div><div>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,2=
04);border-left-style:solid;padding-left:1ex"><span class=3D"">
&gt; Other informations (strange facts):<br>
&gt; In RAID0 it&#39;s working very well.<br>
&gt; In a virtual machine (vbox) it&#39;s working as well (in this case dis=
ks have<br>
&gt; 2GB only for big tests automatization, in production are 160GB SSDs an=
d 2TB<br>
&gt; HDDs);<br>
&gt;<br>
&gt; Have you seen about this error? Syslog is bellow.<br>
<br>
</span>Never seen this before... have you taken care to zero the dm-cache<b=
r>
metadata&#39;s superblock (first 512B of the cache metadata device) each<br=
>
time you&#39;ve reconfigured the cache device?<br>
<br>
Have you tried using the latest lvm2 to create the dm-cache device?<br>
</blockquote></div><br></div><div class=3D"gmail_extra">I&#39;ve used LVM2 =
from distribution (debian) and a latest kernel version.</div><div class=3D"=
gmail_extra"><br></div><div class=3D"gmail_extra">LVM2 latest today is 2.02=
.112 (I&#39;ll try with latest LVM2 version and post results).</div><div cl=
ass=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><div class=3D"gmai=
l_extra"># lvm version</div><div class=3D"gmail_extra">=C2=A0 LVM version: =
=C2=A0 =C2=A0 2.02.95(2) (2012-03-06)</div><div class=3D"gmail_extra">=C2=
=A0 Library version: 1.02.74 (2012-03-06)</div><div class=3D"gmail_extra">=
=C2=A0 Driver version: =C2=A04.27.0</div><div><br></div><div><div># uname -=
a</div><div>Linux steinhager 3.17.2 #2 SMP Fri Nov 7 12:49:16 BRST 2014 x86=
_64 GNU/Linux</div></div></div></div>

--089e0160ba3ac7314c050811f492--


--===============8914123524969303237==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8914123524969303237==--
