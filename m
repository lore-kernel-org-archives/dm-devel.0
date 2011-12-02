From: Frederick Grose <fgrose@gmail.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Fri, 2 Dec 2011 12:42:54 -0500
Message-ID: <CAEcBt+Xom_9ePxb-RM2oYSXgTHJb0aSrhZna55YqL2dqeSEcRw@mail.gmail.com>
References: <4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
	<4ED59040.50406@filteredperception.org>
	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
	<20111130220259.GA7595@agk-dp.fab.redhat.com>
	<4ED6BD81.4090609@filteredperception.org>
	<20111201141236.GB7595@agk-dp.fab.redhat.com>
	<4ED7E11D.1090904@filteredperception.org>
	<20111201202029.GC7595@agk-dp.fab.redhat.com>
	<4ED849B5.7020206@filteredperception.org>
	<20111202084619.GD7595@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5817098364439117311=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111202084619.GD7595@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5817098364439117311==
Content-Type: multipart/alternative; boundary=f46d0442826a1ff75604b31f8268

--f46d0442826a1ff75604b31f8268
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Dec 2, 2011 at 3:46 AM, Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Dec 01, 2011 at 09:44:53PM -0600, Douglas McClendon wrote:
> > The commandline to do the 'edit' was requested for users like Fred, and
> > because I guess one day I might find myself wanting to do the same.
>
> This is unsupported, but if you want to try:
> You need to flip the 5th byte of the 'cow' device from 0 to 1 (when
> the snapshot is not active).  (But you might have lost the most recent
> changes if they weren't flushed out when it filled up.)
>
> Something like this:
>
> # lvs
>  LV    VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
>  lvol0 vg2  owi-a- 10.00m
>  lvol1 vg2  Swi-I- 10.00m lvol0  100.00
>
> # dmsetup table vg2-lvol1-cow
> 0 20480 linear 7:0 22528
>
> # lvchange -an vg2/lvol0
>
> # dmsetup create tmp-vg2-lvol1-cow --table "0 20480 linear 7:0 22528"
>
> # hexdump -C /dev/mapper/tmp-vg2-lvol1-cow | head -1
> 00000000  53 6e 41 70 00 00 00 00  01 00 00 00 08 00 00 00
>  |SnAp............|
>
> Flip byte 5, e.g. copy to file, edit that bit, copy back.
>  # dd if=/dev/mapper/tmp-vg2-lvol1-cow of=/tmp/cow-start bs=512 count=1
>  # vim -b /tmp/cow-start   (and/or xxd)
>  # dd if=/tmp/cow-start of=/dev/mapper/tmp-vg2-lvol1-cow
>
> # dmsetup remove tmp-vg2-lvol1-cow
>
> # lvchange -ay vg2/lvol0
>
> # lvs
>  LV    VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
>  lvol0 vg2  owi-a- 10.00m
>  lvol1 vg2  swi-a- 10.00m lvol0   10.08
>
> # hexdump -C /dev/mapper/vg2-lvol1-cow | head -1
> 00000000  53 6e 41 70 01 00 00 00  01 00 00 00 08 00 00 00
>  |SnAp............|
>
> Alasdair
>

Thank you Alasdair and Douglas for your attention to this matter,
the recovery succeeded on my simple test case.

Some reports follow:

I edited the 'exhausted', 100 MiB overlay file from my F16-Live test
case, which had been made Invalid by attempting to write beyond its
capacity.

After
# dmsetup create item --table "0 8388608 snapshot 7:1 7:2 P 8" --readonly

# dmsetup status
item: 0 8388608 snapshot 202336/204800 800

# mount /dev/dm-0 /mnt/b/
mount: block device /dev/mapper/item is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/mapper/item,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg |tail
[  772.461469] EXT4-fs (dm-0): INFO: recovery required on readonly
filesystem
[  772.461476] EXT4-fs (dm-0): write access unavailable, cannot proceed

# e2fsck -n /dev/dm-0

e2fsck 1.41.14 (22-Dec-2010)
Warning: skipping journal recovery because doing a read-only filesystem
check.
_Fedora-16-x86_6 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.  Fix? no

Inode 17442 was part of the orphaned inode list.  IGNORED.
Deleted inode 156288 has zero dtime.  Fix? no

Inode 162164 was part of the orphaned inode list.  IGNORED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(129696--129702) -(555921--557003)
-(557006--557016) -(557020--557050) -557058 -(557632--557663) -559125
-560586 -(565664--565759) -(566784--566911) -(566973--566991)
-(567016--567023) -(567032--567039) -(567044--567051) -(567068--567159)
-567164 -(567168--567183) -(567188--567189) -(567200--567279)
-(567284--567285) -(567288--567406) -(567408--567677) -(567680--567798)
-(567800--567807) -567839 -(567856--567912) -(567916--567919) -567960
-567967 -580765 -(580909--580911) -580920 -(580990--580991)
-(581024--581036) -(581040--581127) -592079 -606092 -(608256--608261)
-608264 -608290 -(608313--608314) -608317 -(608320--608322) -608361 -608376
-608400 -608421 -608767 -(608770--608773) -608775 -608777 -608779
-(608783--608784) -(608797--608807) -608809 -608813 -608816
-(608825--608831) -608895 -608914 -(608932--608943) -609054 -609077 -609147
-609167 -609195 -609203 -609223 -(609322--609323) -(609542--609543)
-(609558--609567) -(609584--609586) -(609666--609711) -609716
-(609718--609730) -(609736--609939) -609965 -(640485--640556)
Fix? no

Free blocks count wrong (381446, counted=375520).
Fix? no

Inode bitmap differences:  -17442 -156288 -162164
Fix? no

Free inodes count wrong (165564, counted=165454).
Fix? no


_Fedora-16-x86_6: ********** WARNING: Filesystem still has errors **********

_Fedora-16-x86_6: 96580/262144 files (0.3% non-contiguous), 667130/1048576
blocks


After removing and recreating the snapshot as read-write,

# e2fsck -f -y /dev/dm-0

e2fsck 1.41.14 (22-Dec-2010)
_Fedora-16-x86_6: recovering journal
Clearing orphaned inode 162164 (uid=0, gid=0, mode=0100644, size=10898776)
Clearing orphaned inode 17442 (uid=0, gid=0, mode=0100755, size=27520)
Clearing orphaned inode 156288 (uid=0, gid=0, mode=0100755, size=291672)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

_Fedora-16-x86_6: ***** FILE SYSTEM WAS MODIFIED *****
_Fedora-16-x86_6: 96688/262144 files (0.3% non-contiguous), 672875/1048576
blocks

# e2fsck -p /dev/dm-0

_Fedora-16-x86_6: clean, 96688/262144 files, 672875/1048576 blocks

# dmsetup status

item: 0 8388608 snapshot 202424/204800 800


Subsequent mounting (read-only for safety) succeeded in showing the
preexisting content.


I agree with Douglas that there is a significant class of non-technical
Live USB users who would benefit from a fail safe mechanism for their
content based in overlays of a read-only origin.

For example, students and teachers using the Sugar on a Stick Spin,

http://spins.fedoraproject.org/soas/

have been frustrated when their portfolio of work has been 'lost'
after a couple of months of classwork.

We are working to provide better file system support, viz.,

http://wiki.sugarlabs.org/go/LiveOS_image

and any Device-mapper support would be much appreciated!

       --Fred

--f46d0442826a1ff75604b31f8268
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><font face=3D"arial, helvetica, sans-serif">On F=
ri, Dec 2, 2011 at 3:46 AM, Alasdair G Kergon <span dir=3D"ltr">&lt;<a href=
=3D"mailto:agk@redhat.com">agk@redhat.com</a>&gt;</span> wrote:</font></div=
><div class=3D"gmail_quote">

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;"><div class=3D"im">On Thu, Dec 01, 2011 at 0=
9:44:53PM -0600, Douglas McClendon wrote:<br>
&gt; The commandline to do the &#39;edit&#39; was requested for users like =
Fred, and<br>
&gt; because I guess one day I might find myself wanting to do the same.<br=
>
<br>
</div>This is unsupported, but if you want to try:<br>
You need to flip the 5th byte of the &#39;cow&#39; device from 0 to 1 (when=
<br>
the snapshot is not active). =A0(But you might have lost the most recent<br=
>
changes if they weren&#39;t flushed out when it filled up.)<br>
<br>
Something like this:<br>
<br>
# lvs<br>
 =A0LV =A0 =A0VG =A0 Attr =A0 LSize =A0Origin Snap% =A0Move Log Copy% =A0Co=
nvert<br>
 =A0lvol0 vg2 =A0owi-a- 10.00m<br>
 =A0lvol1 vg2 =A0Swi-I- 10.00m lvol0 =A0100.00<br>
<br>
# dmsetup table vg2-lvol1-cow<br>
0 20480 linear 7:0 22528<br>
<br>
# lvchange -an vg2/lvol0<br>
<br>
# dmsetup create tmp-vg2-lvol1-cow --table &quot;0 20480 linear 7:0 22528&q=
uot;<br>
<br>
# hexdump -C /dev/mapper/tmp-vg2-lvol1-cow | head -1<br>
00000000 =A053 6e 41 70 00 00 00 00 =A001 00 00 00 08 00 00 00 =A0|SnAp....=
........|<br>
<br>
Flip byte 5, e.g. copy to file, edit that bit, copy back.<br>
 =A0# dd if=3D/dev/mapper/tmp-vg2-lvol1-cow of=3D/tmp/cow-start bs=3D512 co=
unt=3D1<br>
 =A0# vim -b /tmp/cow-start =A0 (and/or xxd)<br>
 =A0# dd if=3D/tmp/cow-start of=3D/dev/mapper/tmp-vg2-lvol1-cow<br>
<br>
# dmsetup remove tmp-vg2-lvol1-cow<br>
<br>
# lvchange -ay vg2/lvol0<br>
<br>
# lvs<br>
 =A0LV =A0 =A0VG =A0 Attr =A0 LSize =A0Origin Snap% =A0Move Log Copy% =A0Co=
nvert<br>
 =A0lvol0 vg2 =A0owi-a- 10.00m<br>
 =A0lvol1 vg2 =A0swi-a- 10.00m lvol0 =A0 10.08<br>
<br>
# hexdump -C /dev/mapper/vg2-lvol1-cow | head -1<br>
00000000 =A053 6e 41 70 01 00 00 00 =A001 00 00 00 08 00 00 00 =A0|SnAp....=
........|<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Alasdair<br></font></span></blockquote><div><font face=3D"&#39;courier new&=
#39;, monospace"><br></font></div><div><font face=3D"&#39;courier new&#39;,=
 monospace">Thank you Alasdair and Douglas for your attention to this matte=
r,</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">the recovery succeeded=
 on my simple test case.</font></div><div><font face=3D"&#39;courier new&#3=
9;, monospace"><br></font></div><div><font face=3D"&#39;courier new&#39;, m=
onospace">Some reports follow:</font></div>

<div><span style=3D"font-family: &#39;courier new&#39;, monospace; "><br></=
span></div><div><span style=3D"font-family: &#39;courier new&#39;, monospac=
e; ">I edited the &#39;exhausted&#39;, 100 MiB overlay file from my F16-Liv=
e test</span></div>

<div><span style=3D"font-family: &#39;courier new&#39;, monospace; ">case, =
which=A0</span><span style=3D"font-family: &#39;courier new&#39;, monospace=
; ">had been made Invalid by attempting to write beyond its</span></div><di=
v>

<span style=3D"font-family: &#39;courier new&#39;, monospace; ">capacity.</=
span></div><div><font face=3D"&#39;courier new&#39;, monospace"><br></font>=
</div><div><font face=3D"&#39;courier new&#39;, monospace">After</font></di=
v>

<div><span style=3D"font-family: &#39;courier new&#39;, monospace; "># dmse=
tup create item --table &quot;0 8388608 snapshot 7:1 7:2 P 8&quot; --readon=
ly</span></div><div><span style=3D"font-family: &#39;courier new&#39;, mono=
space; "><br>

</span></div><div><div style=3D"font-family: &#39;courier new&#39;, monospa=
ce; "># dmsetup status</div><div style=3D"font-family: &#39;courier new&#39=
;, monospace; ">item: 0 8388608 snapshot 202336/204800 800</div><div style=
=3D"font-family: &#39;courier new&#39;, monospace; ">

<br></div><div style=3D"font-family: &#39;courier new&#39;, monospace; "># =
mount /dev/dm-0 /mnt/b/</div><div style=3D"font-family: &#39;courier new&#3=
9;, monospace; ">mount: block device /dev/mapper/item is write-protected, m=
ounting read-only</div>

<div style=3D"font-family: &#39;courier new&#39;, monospace; ">mount: wrong=
 fs type, bad option, bad superblock on /dev/mapper/item,</div><div style=
=3D"font-family: &#39;courier new&#39;, monospace; ">=A0 =A0 =A0 =A0missing=
 codepage or helper program, or other error</div>

<div style=3D"font-family: &#39;courier new&#39;, monospace; ">=A0 =A0 =A0 =
=A0In some cases useful info is found in syslog - try</div><div style=3D"fo=
nt-family: &#39;courier new&#39;, monospace; ">=A0 =A0 =A0 =A0dmesg | tail =
=A0or so</div><div style=3D"font-family: &#39;courier new&#39;, monospace; =
">

<div><br></div><div># dmesg |tail</div><div>[ =A0772.461469] EXT4-fs (dm-0)=
: INFO: recovery required on readonly filesystem</div><div>[ =A0772.461476]=
 EXT4-fs (dm-0): write access unavailable, cannot proceed</div></div><div s=
tyle=3D"font-family: &#39;courier new&#39;, monospace; ">

<br></div><div><div><font face=3D"&#39;courier new&#39;, monospace"># e2fsc=
k -n /dev/dm-0=A0</font></div><div><font face=3D"&#39;courier new&#39;, mon=
ospace"><br></font></div><div><font face=3D"&#39;courier new&#39;, monospac=
e">e2fsck 1.41.14 (22-Dec-2010)</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Warning: skipping jour=
nal recovery because doing a read-only filesystem check.</font></div><div><=
font face=3D"&#39;courier new&#39;, monospace">_Fedora-16-x86_6 contains a =
file system with errors, check forced.</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Pass 1: Checking inode=
s, blocks, and sizes</font></div><div><font face=3D"&#39;courier new&#39;, =
monospace">Inodes that were part of a corrupted orphan linked list found. =
=A0Fix? no</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">Inode 17442 was part of the=
 orphaned inode list. =A0IGNORED.</font></div><div><font face=3D"&#39;couri=
er new&#39;, monospace">Deleted inode 156288 has zero dtime. =A0Fix? no</fo=
nt></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">Inode 162164 was part of th=
e orphaned inode list. =A0IGNORED.</font></div><div><font face=3D"&#39;cour=
ier new&#39;, monospace">Pass 2: Checking directory structure</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Pass 3: Checking direc=
tory connectivity</font></div><div><font face=3D"&#39;courier new&#39;, mon=
ospace">Pass 4: Checking reference counts</font></div><div><font face=3D"&#=
39;courier new&#39;, monospace">Pass 5: Checking group summary information<=
/font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Block bitmap differenc=
es: =A0-(129696--129702) -(555921--557003) -(557006--557016) -(557020--5570=
50) -557058 -(557632--557663) -559125 -560586 -(565664--565759) -(566784--5=
66911) -(566973--566991) -(567016--567023) -(567032--567039) -(567044--5670=
51) -(567068--567159) -567164 -(567168--567183) -(567188--567189) -(567200-=
-567279) -(567284--567285) -(567288--567406) -(567408--567677) -(567680--56=
7798) -(567800--567807) -567839 -(567856--567912) -(567916--567919) -567960=
 -567967 -580765 -(580909--580911) -580920 -(580990--580991) -(581024--5810=
36) -(581040--581127) -592079 -606092 -(608256--608261) -608264 -608290 -(6=
08313--608314) -608317 -(608320--608322) -608361 -608376 -608400 -608421 -6=
08767 -(608770--608773) -608775 -608777 -608779 -(608783--608784) -(608797-=
-608807) -608809 -608813 -608816 -(608825--608831) -608895 -608914 -(608932=
--608943) -609054 -609077 -609147 -609167 -609195 -609203 -609223 -(609322-=
-609323) -(609542--609543) -(609558--609567) -(609584--609586) -(609666--60=
9711) -609716 -(609718--609730) -(609736--609939) -609965 -(640485--640556)=
</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Fix? no</font></div><d=
iv><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><f=
ont face=3D"&#39;courier new&#39;, monospace">Free blocks count wrong (3814=
46, counted=3D375520).</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Fix? no</font></div><d=
iv><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><f=
ont face=3D"&#39;courier new&#39;, monospace">Inode bitmap differences: =A0=
-17442 -156288 -162164</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Fix? no</font></div><d=
iv><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><f=
ont face=3D"&#39;courier new&#39;, monospace">Free inodes count wrong (1655=
64, counted=3D165454).</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Fix? no</font></div><d=
iv><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><f=
ont face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><font f=
ace=3D"&#39;courier new&#39;, monospace">_Fedora-16-x86_6: ********** WARNI=
NG: Filesystem still has errors **********</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">_Fedora-16-x86_6: 96580/262=
144 files (0.3% non-contiguous), 667130/1048576 blocks</font></div></div><d=
iv>

<font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><font=
 face=3D"&#39;courier new&#39;, monospace"><br></font></div><div><font face=
=3D"&#39;courier new&#39;, monospace">After removing and recreating the sna=
pshot as read-write,</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace"><div># e2fsck -f -y /dev/dm=
-0=A0</div><div><br></div><div>e2fsck 1.41.14 (22-Dec-2010)</div><div>_Fedo=
ra-16-x86_6: recovering journal</div>

<div>Clearing orphaned inode 162164 (uid=3D0, gid=3D0, mode=3D0100644, size=
=3D10898776)</div><div>Clearing orphaned inode 17442 (uid=3D0, gid=3D0, mod=
e=3D0100755, size=3D27520)</div><div>Clearing orphaned inode 156288 (uid=3D=
0, gid=3D0, mode=3D0100755, size=3D291672)</div>

<div>Pass 1: Checking inodes, blocks, and sizes</div><div>Pass 2: Checking =
directory structure</div><div>Pass 3: Checking directory connectivity</div>=
<div>Pass 4: Checking reference counts</div><div>Pass 5: Checking group sum=
mary information</div>

<div><br></div><div>_Fedora-16-x86_6: ***** FILE SYSTEM WAS MODIFIED *****<=
/div><div>_Fedora-16-x86_6: 96688/262144 files (0.3% non-contiguous), 67287=
5/1048576 blocks</div><div><br></div><div># e2fsck -p /dev/dm-0=A0</div>
<div>
<br></div><div>_Fedora-16-x86_6: clean, 96688/262144 files, 672875/1048576 =
blocks</div><div><br></div><div># dmsetup status</div><div><br></div><div>i=
tem: 0 8388608 snapshot 202424/204800 800</div><div><br></div><div><br>

</div><div>Subsequent mounting (read-only for safety) succeeded in showing =
the</div><div>preexisting content.</div><div><br></div><div><br></div><div>=
I agree with Douglas that there is a significant class of non-technical</di=
v>

<div>Live USB users who would benefit from a fail safe mechanism for their<=
/div><div>content based in overlays of a read-only origin.</div><div><br></=
div><div>For example, students=A0and teachers using the Sugar on a Stick=A0=
Spin,</div>

<div><br></div><div><a href=3D"http://spins.fedoraproject.org/soas/">http:/=
/spins.fedoraproject.org/soas/</a></div><div><br></div><div>have been frust=
rated when their portfolio of work has been &#39;lost&#39;</div><div>after =
a couple of months of classwork.</div>

<div><br></div><div>We are working to provide better file system support, v=
iz.,</div><div><br></div><div><a href=3D"http://wiki.sugarlabs.org/go/LiveO=
S_image">http://wiki.sugarlabs.org/go/LiveOS_image</a></div><div><br></div>

<div>and any Device-mapper support would be much appreciated!</div><div><br=
></div><div>=A0 =A0 =A0 =A0--Fred</div></font></div><div><font face=3D"&#39=
;courier new&#39;, monospace"><br></font></div><div><font face=3D"&#39;cour=
ier new&#39;, monospace"><br>

</font></div><div style=3D"font-family: &#39;courier new&#39;, monospace; "=
><br></div><div style=3D"font-family: &#39;courier new&#39;, monospace; "><=
br></div><div style=3D"font-family: &#39;courier new&#39;, monospace; "><br=
>
</div>
<div style=3D"font-family: &#39;courier new&#39;, monospace; "><br></div></=
div><div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><=
div><br></div></div>

--f46d0442826a1ff75604b31f8268--


--===============5817098364439117311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5817098364439117311==--
