From: Sanjana Shari <sanjana.linux@gmail.com>
Subject: Re: creating two device mapper files for an underline
	blockdevice
Date: Tue, 1 Nov 2011 22:22:54 +0530
Message-ID: <CABMcfaOiMfbz_amLkoSJ-zhRKCGCEhc1Em29NV5-02LiOPJYcQ@mail.gmail.com>
References: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
	<4EAFAE7A.7060000@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6026546786950249857=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EAFAE7A.7060000@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: sanjana.linux@gmail.com
List-Id: dm-devel.ids

--===============6026546786950249857==
Content-Type: multipart/alternative; boundary=bcaec545480cce243e04b0af2fb9

--bcaec545480cce243e04b0af2fb9
Content-Type: text/plain; charset=ISO-8859-1

Hi Milan,

Thanks for the documentation links... it was useful.. one of the link I had
gone through it earlier.

Couple of questions more which I would post here...

Mapping the second half of the first device + the another device to create
a new map. here I ma not mapping the whole of first disk. Or I ma not
mapping the whole table, but still device creation is sucessfull.
[root@bladelinux01 ~]# losetup -a
/dev/loop0: [fd03]:2359319 (/root/dm/dm_test)
/dev/loop1: [fd03]:2359321 (/root/dm/dm_test1)
[root@bladelinux01 ~]# blockdev --getsize /dev/loop0
204800  < ------ 100 M
[root@bladelinux01 ~]# blockdev --getsize /dev/loop1
204800  < ------ 100 M

Using first half of the block device /dev/loop0. Here I have mapped the
table from 0 to 102400 sectors.

[root@bladelinux01 ~]# fdisk -lus /dev/loop0

Disk /dev/loop0: 104 MB, 104857600 bytes
255 heads, 63 sectors/track, 12 cylinders, total 204800 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Command is successful.... as expected.

[root@bladelinux01 ~]# dmsetup create firsthalf --table "0 102400 linear
/dev/loop0 0"
[root@bladelinux01 ~]# dmsetup table firsthalf
0 102400 linear 7:0 0
[root@bladelinux01 ~]# dmsetup info firsthalf
Name:              firsthalf
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      253, 6
Number of targets: 1

Now here I am creating a new device named "anotherhalf_plus_otherdisk" by
mapping the remaining first half of the first disk and then the whole of a
second block device /dev/loop1.

Creating table to use with dmsetup.
[root@bladelinux01 ~]# echo 0 102400 linear /dev/loop0 102400 > table
[root@bladelinux01 ~]# cat table
0 102400 linear /dev/loop0 102400
[root@bladelinux01 ~]# echo 102400 204800 linear /dev/loop1 0 >>table
[root@bladelinux01 ~]# cat table
0 102400 linear /dev/loop0 102400
102400 204800 linear /dev/loop1 0
[root@bladelinux01 ~]# dmsetup create anotherhalf_plus_otherdisk table
[root@bladelinux01 ~]# dmsetup table anotherhalf_plus_otherdisk
0 102400 linear 7:0 102400
102400 204800 linear 7:1 0
[root@bladelinux01 ~]# dmsetup info anotherhalf_plus_otherdisk
Name:              anotherhalf_plus_otherdisk
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      253, 7
Number of targets: 2

device created with size as expected. Agian here I haven't used the start
sector as "0" for the second block device,
I have used "102400"th sector to start from, which I believe should be
continuation of the previous logical sector. < --- Please this part.
[root@bladelinux01 ~]# blockdev --getsize
/dev/mapper/anotherhalf_plus_otherdisk
307200

[root@bladelinux01 ~]# fdisk -lus /dev/mapper/anotherhalf_plus_otherdisk

Disk /dev/mapper/anotherhalf_plus_otherdisk: 157 MB, 157286400 bytes
255 heads, 63 sectors/track, 19 cylinders, total 307200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Here I have some doubts which needs to be cleared to get a thorough
understanding.
My questions:

The table format to be used is as follows from man page of dmsetup.
Each line of the table specifies a single target and is of the form:
logical_start_sector    num_sectors    target_type target_args

Here:
"logical_start_sector" start sector should be "0" for the start of any
block device, rather I would say for the start of any new map would e more
appropriate. What do you say...?
"num_sectors" as name suggestes would be the number of sectors, which would
contribute to the size of the end mapped device.

For target type "linear" we use arguments as the following:
destination_device   start_sector   < -------- here which is the start
sector..?
Is it the logical start scetor of the blockdevice or the physical sector of
the blockdevice...? Or how do we define it...? This part is not yet clear
to me.



On Tue, Nov 1, 2011 at 2:01 PM, Milan Broz <mbroz@redhat.com> wrote:

> On 11/01/2011 07:08 AM, Sanjana Shari wrote:
>
> > But if I use the other part of the disk to map. The command is not
> successful
> >
> > [root@bladelinux01 root]#  dmsetup create half1 --table "102401 102399
> linear /dev/loop0 102400"
> > device-mapper: reload ioctl failed: Invalid argument
> > Command failed
>
> You have to always map the whole table (starting at sector 0).
> If you see syslog, you can see why
>  device-mapper: table: 254:2: linear: Gap in table
>  device-mapper: ioctl: error adding target to table
>
> Anyway, for the info how it works, example how to switch active table:
>
> 1. create linear device mapped to /dev/sdb
>
>  # dmsetup create x --table "0 10000 linear /dev/sdb 0"
>  # dmsetup table x
>  0 10000 linear 8:16 0
>
> 2. Remap the first half of device to another target, here "error"
>
>  - load new (yet inactive) table
>  # echo -e "0 5000 error\n5000 10000 linear /dev/sdb 5000" | dmsetup load x
>
>  - so now you have one active table and one inactive (prepared for switch)
>  # dmsetup table x
>  0 10000 linear 8:16 0
>
>  # dmsetup table x --inactive
>  0 5000 error
>  5000 10000 linear 8:16 5000
>
> 3. switch to new (inactive) table (note that "dmsetup suspend" here is
> implicit)
>  # dmsetup resume x
>
>  # dmsetup table x
>  0 5000 error
>  5000 10000 linear 8:16 5000
>
>
> If you want more info about this low level DM operation, read
> http://people.redhat.com/agk/talks/FOSDEM_2005/
> http://mbroz.fedorapeople.org/talks/DeviceMapperBasics/
> (old, but still useful, I hope :-)
>
> Milan
>

--bcaec545480cce243e04b0af2fb9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Milan,<br><br>Thanks for the documentation links... it was useful.. one =
of the link I had gone through it earlier.<br><br>Couple of questions more =
which I would post here...<br><br>Mapping the second half of the first devi=
ce + the another device to create a new map. here I ma not mapping the whol=
e of first disk. Or I ma not mapping the whole table, but still device crea=
tion is sucessfull.<br>
[root@bladelinux01 ~]# losetup -a<br>/dev/loop0: [fd03]:2359319 (/root/dm/d=
m_test)<br>/dev/loop1: [fd03]:2359321 (/root/dm/dm_test1)<br>[root@bladelin=
ux01 ~]# blockdev --getsize /dev/loop0<br>204800=A0 &lt; ------ 100 M<br>
[root@bladelinux01 ~]# blockdev --getsize /dev/loop1<br>204800=A0 &lt; ----=
-- 100 M<br><br>Using first half of the block device /dev/loop0. Here I hav=
e mapped the table from 0 to 102400 sectors.<br><br>[root@bladelinux01 ~]# =
fdisk -lus /dev/loop0<br>
<br>Disk /dev/loop0: 104 MB, 104857600 bytes<br>255 heads, 63 sectors/track=
, 12 cylinders, total 204800 sectors<br>Units =3D sectors of 1 * 512 =3D 51=
2 bytes<br>Sector size (logical/physical): 512 bytes / 512 bytes<br>I/O siz=
e (minimum/optimal): 512 bytes / 512 bytes<br>
Disk identifier: 0x00000000<br><br>Command is successful.... as expected.<b=
r><br>[root@bladelinux01 ~]# dmsetup create firsthalf --table &quot;0 10240=
0 linear /dev/loop0 0&quot;<br>[root@bladelinux01 ~]# dmsetup table firstha=
lf<br>
0 102400 linear 7:0 0<br>[root@bladelinux01 ~]# dmsetup info firsthalf<br>N=
ame:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 firsthalf<br>State:=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE<br>Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256<br>=
Tables present:=A0=A0=A0 LIVE<br>Open count:=A0=A0=A0=A0=A0=A0=A0 0<br>Even=
t number:=A0=A0=A0=A0=A0 0<br>
Major, minor:=A0=A0=A0=A0=A0 253, 6<br>Number of targets: 1<br><br>Now here=
 I am creating a new device named &quot;anotherhalf_plus_otherdisk&quot; by=
 mapping the remaining first half of the first disk and then the whole of a=
 second block device /dev/loop1.<br>
<br>Creating table to use with dmsetup.<br>[root@bladelinux01 ~]# echo 0 10=
2400 linear /dev/loop0 102400 &gt; table<br>[root@bladelinux01 ~]# cat tabl=
e<br>0 102400 linear /dev/loop0 102400<br>[root@bladelinux01 ~]# echo 10240=
0 204800 linear /dev/loop1 0 &gt;&gt;table<br>
[root@bladelinux01 ~]# cat table<br>0 102400 linear /dev/loop0 102400<br>10=
2400 204800 linear /dev/loop1 0<br>[root@bladelinux01 ~]# dmsetup create an=
otherhalf_plus_otherdisk table<br>[root@bladelinux01 ~]# dmsetup table anot=
herhalf_plus_otherdisk<br>
0 102400 linear 7:0 102400<br>102400 204800 linear 7:1 0<br>[root@bladelinu=
x01 ~]# dmsetup info anotherhalf_plus_otherdisk<br>Name:=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 anotherhalf_plus_otherdisk<br>State:=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ACTIVE<br>Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256<br>
Tables present:=A0=A0=A0 LIVE<br>Open count:=A0=A0=A0=A0=A0=A0=A0 0<br>Even=
t number:=A0=A0=A0=A0=A0 0<br>Major, minor:=A0=A0=A0=A0=A0 253, 7<br>Number=
 of targets: 2<br><br>device created with size as expected. Agian here I ha=
ven&#39;t used the start sector as &quot;0&quot; for the second block devic=
e, <br>
I have used &quot;102400&quot;th sector to start from, which I believe shou=
ld be continuation of the previous logical sector. &lt; --- Please this par=
t.<br>[root@bladelinux01 ~]# blockdev --getsize /dev/mapper/anotherhalf_plu=
s_otherdisk<br>
307200<br><br>[root@bladelinux01 ~]# fdisk -lus /dev/mapper/anotherhalf_plu=
s_otherdisk<br><br>Disk /dev/mapper/anotherhalf_plus_otherdisk: 157 MB, 157=
286400 bytes<br>255 heads, 63 sectors/track, 19 cylinders, total 307200 sec=
tors<br>
Units =3D sectors of 1 * 512 =3D 512 bytes<br>Sector size (logical/physical=
): 512 bytes / 512 bytes<br>I/O size (minimum/optimal): 512 bytes / 512 byt=
es<br>Disk identifier: 0x00000000<br><br>Here I have some doubts which need=
s to be cleared to get a thorough understanding.<br>
My questions:<br><br>The table format to be used is as follows from man pag=
e of dmsetup.<br>Each line of the table specifies a single target and is of=
 the form:<br>logical_start_sector=A0=A0=A0 num_sectors=A0=A0=A0 target_typ=
e target_args<br>
<br>Here:<br>&quot;logical_start_sector&quot; start sector should be &quot;=
0&quot; for the start of any block device, rather I would say for the start=
 of any new map would e more appropriate. What do you say...?<br>&quot;num_=
sectors&quot; as name suggestes would be the number of sectors, which would=
 contribute to the size of the end mapped device.<br>
<br>For target type &quot;linear&quot; we use arguments as the following:<b=
r>destination_device=A0=A0 start_sector=A0=A0 &lt; -------- here which is t=
he start sector..? <br>Is it the logical start scetor of the blockdevice or=
 the physical sector of the blockdevice...? Or how do we define it...? This=
 part is not yet clear to me.<br>
<br><br><br><div class=3D"gmail_quote">On Tue, Nov 1, 2011 at 2:01 PM, Mila=
n Broz <span dir=3D"ltr">&lt;<a href=3D"mailto:mbroz@redhat.com">mbroz@redh=
at.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">On 11/01/2011 07:08 AM, Sanjana Shari wrote:<br>
<br>
&gt; But if I use the other part of the disk to map. The command is not suc=
cessful<br>
&gt;<br>
&gt; [root@bladelinux01 root]# =A0dmsetup create half1 --table &quot;102401=
 102399 linear /dev/loop0 102400&quot;<br>
&gt; device-mapper: reload ioctl failed: Invalid argument<br>
&gt; Command failed<br>
<br>
</div>You have to always map the whole table (starting at sector 0).<br>
If you see syslog, you can see why<br>
 =A0device-mapper: table: 254:2: linear: Gap in table<br>
 =A0device-mapper: ioctl: error adding target to table<br>
<br>
Anyway, for the info how it works, example how to switch active table:<br>
<br>
1. create linear device mapped to /dev/sdb<br>
<br>
 =A0# dmsetup create x --table &quot;0 10000 linear /dev/sdb 0&quot;<br>
 =A0# dmsetup table x<br>
 =A00 10000 linear 8:16 0<br>
<br>
2. Remap the first half of device to another target, here &quot;error&quot;=
<br>
<br>
=A0- load new (yet inactive) table<br>
=A0# echo -e &quot;0 5000 error\n5000 10000 linear /dev/sdb 5000&quot; | dm=
setup load x<br>
<br>
=A0- so now you have one active table and one inactive (prepared for switch=
)<br>
=A0# dmsetup table x<br>
=A00 10000 linear 8:16 0<br>
<br>
=A0# dmsetup table x --inactive<br>
=A00 5000 error<br>
=A05000 10000 linear 8:16 5000<br>
<br>
3. switch to new (inactive) table (note that &quot;dmsetup suspend&quot; he=
re is implicit)<br>
 =A0# dmsetup resume x<br>
<br>
 =A0# dmsetup table x<br>
 =A00 5000 error<br>
 =A05000 10000 linear 8:16 5000<br>
<br>
<br>
If you want more info about this low level DM operation, read<br>
<a href=3D"http://people.redhat.com/agk/talks/FOSDEM_2005/" target=3D"_blan=
k">http://people.redhat.com/agk/talks/FOSDEM_2005/</a><br>
<a href=3D"http://mbroz.fedorapeople.org/talks/DeviceMapperBasics/" target=
=3D"_blank">http://mbroz.fedorapeople.org/talks/DeviceMapperBasics/</a><br>
(old, but still useful, I hope :-)<br>
<font color=3D"#888888"><br>
Milan<br>
</font></blockquote></div><br>

--bcaec545480cce243e04b0af2fb9--


--===============6026546786950249857==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6026546786950249857==--
