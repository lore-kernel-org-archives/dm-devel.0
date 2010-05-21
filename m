From: Busby <chaimvy@gmail.com>
Subject: Re: Shared snapshot tests
Date: Fri, 21 May 2010 16:27:02 +0800
Message-ID: <AANLkTikpvYqQjdgfipFZ7iRLQZuwcMBjcQ1IWWif9SOx@mail.gmail.com>
References: <y2h131780341004151106k584e905fv5b659d4f9fd2366a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2292321942318026550=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <y2h131780341004151106k584e905fv5b659d4f9fd2366a@mail.gmail.com>
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

--===============2292321942318026550==
Content-Type: multipart/alternative; boundary=000e0cd6133ca59acf0487167424

--000e0cd6133ca59acf0487167424
Content-Type: text/plain; charset=ISO-8859-1

Hi,
      I patched the r19 version of multisnap and LVM2.02.64.
      But when I type the command like "  lvcreate -s -n test_lv_ss1
/dev/test_vg/test_lv", it failed, it seems the system did the command as no
sharedstore, outputing the err mesg like: no extents.
      I create the origin lv and sharedstore as  Daire Byrne did. 'lvs'
command can see the test_lv and the 'test_lv--shared'. How to create
snapshot?
     Thank you very much.



Best regards,
Busby



2010/4/16 Daire Byrne <daire.byrne@gmail.com>

> Hi,
>
> I had some spare RAID hardware lying around and thought I'd give the
> new shared snapshots code a whirl. Maybe the results are of interest
> so I'm posting them here. I used the "r18" version of the code with
> 2.6.33 and patched lvm2-2.02.54.
>
> Steps to create test environment:
>
>  # pvcreate /dev/sdb
>  # vgcreate test_vg /dev/sdb
>  # lvcreate -L 1TB test_vg -n test_lv
>  # mkfs.xfs /dev/test_vg/test_lv
>  # mount /dev/test_vg/test_lv /mnt/images/
>
>  # lvcreate -L 2TB -c 256 --sharedstore mikulas -s /dev/test_vg/test_lv
>  # lvcreate -s -n test_lv_ss1 /dev/test_vg/test_lv
>  # dd if=/dev/zero of=/mnt/images/dd-file bs=1M count=102400
>  # dd of=/dev/null if=/mnt/images/dd-file bs=1M count=102400
>
> Raw speeds of the "test_lv" xfs formatted volume without any shared
> snapshot space allocated was 308 MB/s writes and 214 MB/s reads. I
> have done no further tuning.
>
> No. snaps |  type  | chunk | writes  |  reads
> ----------------------------------------------
>        0   mikulas     4k    225MB/s   127MB/s
>        1   mikulas     4k     18MB/s   128MB/s
>        2   mikulas     4k     11MB/s   128MB/s
>        3   mikulas     4k     11MB/s   127MB/s
>        4   mikulas     4k     10MB/s   127MB/s
>       10   mikulas     4k      9MB/s   127MB/s
>
>        0   mikulas     256k  242MB/s   129MB/s
>        1   mikulas     256k   38MB/s   130MB/s
>        2   mikulas     256k   37MB/s   131MB/s
>        3   mikulas     256k   36MB/s   132MB/s
>        4   mikulas     256k   33MB/s   129MB/s
>       10   mikulas     256k   31MB/s   128MB/s
>
>        1   normal      256k   45MB/s   127MB/s
>        2   normal      256k   18MB/s   128MB/s
>        3   normal      256k   11MB/s   127MB/s
>        4   normal      256k    8MB/s   124MB/s
>       10   normal      256k    3MB/s   126MB/s
>
> I wanted to test the "daniel" store but I got "multisnapshot:
> Unsupported chunk size" with everything except a chunksize of "16k".
> Even then the store was created but reported that it was 100% full.
> Nevertheless I created a few snapshots but performance didn't seem
> much different. I have not included the results as I could only use a
> chunksize of 16k. Also when removing the snapshots I got some kmalloc
> nastiness (needed to reboot). I think the daniel store is a bit
> broken.
>
> Observations/questions:
>
>  (1) why does performance drop when you create the shared snapshot
> space but not create any actual snapshots and there is no COW being
> done? The kmultisnapd eats CPU...
>  (2) similarly why does the read performance change at all
> (214->127MB/s). There is no COW overhead. This is the case for both
> the old snapshots and the new shared ones.
>  (3) when writing why does it write data to the origin quickly in
> short bursts (buffer?) but then effectively stall while the COW
> read/write occurs? Why can you not write to the filesystem
> asynchronously while the COW is happening? This is the same for the
> normal/old snapshots too so I guess it is just an inherent limitation
> to ensure consistency?
>  (4) why is there a small (but appreciable) drop in writes as the
> number of snapshots increase? It should only have to do a single COW
> in all cases no?
>  (5) It takes a really long time (hours) to create a few TB worth of
> shared snapshot space when using 4k chunks. Seems much better with
> 256k. The old snapshots create almost instantly.
>
> All in all it looks very interesting and is currently the best way of
> implementing shared snapshots for filesystems which don't have native
> support for it (e.g. btrfs). I found the zumastor stuff to be rather
> slow, buggy and difficult to operate in comparison.
>
> The performance seem to be on par with with the normal/old snapshots
> and much much better once you increase the number of snapshots. If
> only the snapshot performance could be better overall (old and multi)
> - perhaps there are some further tweaks and tunings I could do?
>
> Regards,
>
> Daire
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--000e0cd6133ca59acf0487167424
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>=A0=A0=A0=A0=A0 I patched the r19 version of multisnap and LVM2.02.64.=
</div>
<div>=A0=A0=A0=A0=A0 But when I type the command like &quot;=A0 lvcreate -s=
 -n test_lv_ss1 /dev/test_vg/test_lv&quot;, it failed, it seems the system =
did the command as no sharedstore, outputing the err mesg like: no extents.=
</div>
<div>=A0=A0=A0=A0 =A0I create the origin lv and sharedstore as=A0 Daire Byr=
ne did. &#39;lvs&#39; command can see the test_lv and the &#39;test_lv--sha=
red&#39;. How to create snapshot?</div>
<div>=A0=A0=A0=A0 Thank you very much.</div>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>
<div>Best regards,</div>
<div>Busby</div>
<div>=A0=A0=A0 </div>
<div>=A0=A0=A0 <br><br></div>
<div class=3D"gmail_quote">2010/4/16 Daire Byrne <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:daire.byrne@gmail.com">daire.byrne@gmail.com</a>&gt;</span><b=
r>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">Hi,<br><br>I had some spare RAID=
 hardware lying around and thought I&#39;d give the<br>new shared snapshots=
 code a whirl. Maybe the results are of interest<br>
so I&#39;m posting them here. I used the &quot;r18&quot; version of the cod=
e with<br>2.6.33 and patched lvm2-2.02.54.<br><br>Steps to create test envi=
ronment:<br><br>=A0# pvcreate /dev/sdb<br>=A0# vgcreate test_vg /dev/sdb<br=
>
=A0# lvcreate -L 1TB test_vg -n test_lv<br>=A0# mkfs.xfs /dev/test_vg/test_=
lv<br>=A0# mount /dev/test_vg/test_lv /mnt/images/<br><br>=A0# lvcreate -L =
2TB -c 256 --sharedstore mikulas -s /dev/test_vg/test_lv<br>=A0# lvcreate -=
s -n test_lv_ss1 /dev/test_vg/test_lv<br>
=A0# dd if=3D/dev/zero of=3D/mnt/images/dd-file bs=3D1M count=3D102400<br>=
=A0# dd of=3D/dev/null if=3D/mnt/images/dd-file bs=3D1M count=3D102400<br><=
br>Raw speeds of the &quot;test_lv&quot; xfs formatted volume without any s=
hared<br>snapshot space allocated was 308 MB/s writes and 214 MB/s reads. I=
<br>
have done no further tuning.<br><br>No. snaps | =A0type =A0| chunk | writes=
 =A0| =A0reads<br>----------------------------------------------<br>=A0 =A0=
 =A0 =A00 =A0 mikulas =A0 =A0 4k =A0 =A0225MB/s =A0 127MB/s<br>=A0 =A0 =A0 =
=A01 =A0 mikulas =A0 =A0 4k =A0 =A0 18MB/s =A0 128MB/s<br>
=A0 =A0 =A0 =A02 =A0 mikulas =A0 =A0 4k =A0 =A0 11MB/s =A0 128MB/s<br>=A0 =
=A0 =A0 =A03 =A0 mikulas =A0 =A0 4k =A0 =A0 11MB/s =A0 127MB/s<br>=A0 =A0 =
=A0 =A04 =A0 mikulas =A0 =A0 4k =A0 =A0 10MB/s =A0 127MB/s<br>=A0 =A0 =A0 1=
0 =A0 mikulas =A0 =A0 4k =A0 =A0 =A09MB/s =A0 127MB/s<br><br>=A0 =A0 =A0 =
=A00 =A0 mikulas =A0 =A0 256k =A0242MB/s =A0 129MB/s<br>
=A0 =A0 =A0 =A01 =A0 mikulas =A0 =A0 256k =A0 38MB/s =A0 130MB/s<br>=A0 =A0=
 =A0 =A02 =A0 mikulas =A0 =A0 256k =A0 37MB/s =A0 131MB/s<br>=A0 =A0 =A0 =
=A03 =A0 mikulas =A0 =A0 256k =A0 36MB/s =A0 132MB/s<br>=A0 =A0 =A0 =A04 =
=A0 mikulas =A0 =A0 256k =A0 33MB/s =A0 129MB/s<br>=A0 =A0 =A0 10 =A0 mikul=
as =A0 =A0 256k =A0 31MB/s =A0 128MB/s<br>
<br>=A0 =A0 =A0 =A01 =A0 normal =A0 =A0 =A0256k =A0 45MB/s =A0 127MB/s<br>=
=A0 =A0 =A0 =A02 =A0 normal =A0 =A0 =A0256k =A0 18MB/s =A0 128MB/s<br>=A0 =
=A0 =A0 =A03 =A0 normal =A0 =A0 =A0256k =A0 11MB/s =A0 127MB/s<br>=A0 =A0 =
=A0 =A04 =A0 normal =A0 =A0 =A0256k =A0 =A08MB/s =A0 124MB/s<br>=A0 =A0 =A0=
 10 =A0 normal =A0 =A0 =A0256k =A0 =A03MB/s =A0 126MB/s<br>
<br>I wanted to test the &quot;daniel&quot; store but I got &quot;multisnap=
shot:<br>Unsupported chunk size&quot; with everything except a chunksize of=
 &quot;16k&quot;.<br>Even then the store was created but reported that it w=
as 100% full.<br>
Nevertheless I created a few snapshots but performance didn&#39;t seem<br>m=
uch different. I have not included the results as I could only use a<br>chu=
nksize of 16k. Also when removing the snapshots I got some kmalloc<br>nasti=
ness (needed to reboot). I think the daniel store is a bit<br>
broken.<br><br>Observations/questions:<br><br>=A0(1) why does performance d=
rop when you create the shared snapshot<br>space but not create any actual =
snapshots and there is no COW being<br>done? The kmultisnapd eats CPU...<br=
>
=A0(2) similarly why does the read performance change at all<br>(214-&gt;12=
7MB/s). There is no COW overhead. This is the case for both<br>the old snap=
shots and the new shared ones.<br>=A0(3) when writing why does it write dat=
a to the origin quickly in<br>
short bursts (buffer?) but then effectively stall while the COW<br>read/wri=
te occurs? Why can you not write to the filesystem<br>asynchronously while =
the COW is happening? This is the same for the<br>normal/old snapshots too =
so I guess it is just an inherent limitation<br>
to ensure consistency?<br>=A0(4) why is there a small (but appreciable) dro=
p in writes as the<br>number of snapshots increase? It should only have to =
do a single COW<br>in all cases no?<br>=A0(5) It takes a really long time (=
hours) to create a few TB worth of<br>
shared snapshot space when using 4k chunks. Seems much better with<br>256k.=
 The old snapshots create almost instantly.<br><br>All in all it looks very=
 interesting and is currently the best way of<br>implementing shared snapsh=
ots for filesystems which don&#39;t have native<br>
support for it (e.g. btrfs). I found the zumastor stuff to be rather<br>slo=
w, buggy and difficult to operate in comparison.<br><br>The performance see=
m to be on par with with the normal/old snapshots<br>and much much better o=
nce you increase the number of snapshots. If<br>
only the snapshot performance could be better overall (old and multi)<br>- =
perhaps there are some further tweaks and tunings I could do?<br><br>Regard=
s,<br><br>Daire<br><font color=3D"#888888"><br>--<br>dm-devel mailing list<=
br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href=
=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_blank">htt=
ps://www.redhat.com/mailman/listinfo/dm-devel</a><br></font></blockquote></=
div>
<br>

--000e0cd6133ca59acf0487167424--


--===============2292321942318026550==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2292321942318026550==--
