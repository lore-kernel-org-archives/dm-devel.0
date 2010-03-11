From: Busby <chaimvy@gmail.com>
Subject: Re: Shared snapshots test
Date: Thu, 11 Mar 2010 13:06:58 +0800
Message-ID: <b8091bb41003102106r531c90d0nbe146e0ab14f51a1@mail.gmail.com>
References: <20100310123713.GA9341@mick>
	<Pine.LNX.4.64.1003100806450.1635@hs20-bc2-1.build.redhat.com>
	<20100310133438.GA9704@mick>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7188002944597537391=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100310133438.GA9704@mick>
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

--===============7188002944597537391==
Content-Type: multipart/alternative; boundary=000e0cd359b6694cfa04817f6260

--000e0cd359b6694cfa04817f6260
Content-Type: text/plain; charset=ISO-8859-1

Hi,
     I used the patchs for LVM2.02.54, however, when i compiled it, an err
came:

../lib/liblvm-internal.a(lv_manip.o): In function `lv_extend':
lv_manip.c:(.text+0x629a): undefined reference to `last_seg'

  where is the 'last_seg' 's definition?
  my linux kernel version is 2.6.18.
  thank you!

best regards
Bubsy

2010/3/10 Mikhail Klepachevskyy <mikhailk1@open-e.com>

> Hello!
>
> Big thanks! It helped!
>
>
> On Wed, Mar 10, 2010 at 08:11:11AM -0500, Mikulas Patocka wrote:
>
> >
> > You need to suspend and resume the origin device after create message and
> > before attaching the snapshot.
> >
> > > I tried to test multisnapshots but unfortunately got some errors.
> > > Here is what I did:
> > >
>
> <skip>
>
> > >    # echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnapshot \
> > >      /dev/mapper/vg1-lv1 /dev/mapper/vg1-lv2 16 0 mikulas 0\
> > >      | dmsetup create ms
> > >
> > >    # dmsetup message /dev/mapper/ms 0 create
> >
> > dmsetup suspend ms
> > dmsetup resume ms
> >
> > >    # echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnap-snap \
> > >      /dev/mapper/vg1-lv1 0 | dmsetup create ms0
> > >
> > > At this point I got the next error:
> > > device-mapper: reload ioctl failed: No such file or directory
> > > Command failed
> > >
> > > And these lines appeared in dmesg:
> > > [ 6876.506623] device-mapper: table: 252:3: multisnap-snap: Snapshot
> with this id doesn't exist
> > > [ 6876.506629] device-mapper: ioctl: error adding target to table
> > >
> > > Could you check all the steps I performed right and what could cause
> > > those error messages?
> > >
> >
> > But rather, you could use userspace support for shared snapshots, it
> makes
> > the use much easier, you can use lvcreate, lvremove, lvresize commands:
> >
> > for lvm-2.02.54:
> >
> http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.54/
> > for lvm-2.02.60:
> >
> http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.60/
> > for lvm-2.02.62:
> > http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.62/
>
> --
> Best wishes,
> Mikhail Klepachevskyy
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--000e0cd359b6694cfa04817f6260
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>=A0=A0=A0=A0 I used the patchs for LVM2.02.54, however, when i compile=
d it, an err came:</div>
<div>=A0=A0=A0=A0 </div>
<div><font color=3D"#3333ff">../lib/liblvm-internal.a(lv_manip.o): In funct=
ion `lv_extend&#39;:<br>lv_manip.c:(.text+0x629a): undefined reference to `=
last_seg&#39;<br></font><br>=A0 where is the &#39;last_seg&#39; &#39;s defi=
nition?</div>

<div>=A0 my linux kernel version is 2.6.18.</div>
<div>=A0 thank you!</div>
<div>=A0</div>
<div>best regards</div>
<div>Bubsy</div>
<div>=A0</div>
<div class=3D"gmail_quote">2010/3/10 Mikhail Klepachevskyy <span dir=3D"ltr=
">&lt;<a href=3D"mailto:mikhailk1@open-e.com">mikhailk1@open-e.com</a>&gt;<=
/span><br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">Hello!<br><br>Big thanks! It hel=
ped!<br>
<div class=3D"im"><br><br>On Wed, Mar 10, 2010 at 08:11:11AM -0500, Mikulas=
 Patocka wrote:<br><br>&gt;<br>&gt; You need to suspend and resume the orig=
in device after create message and<br>&gt; before attaching the snapshot.<b=
r>
&gt;<br></div>
<div class=3D"im">&gt; &gt; I tried to test multisnapshots but unfortunatel=
y got some errors.<br>&gt; &gt; Here is what I did:<br>&gt; &gt;<br><br></d=
iv>&lt;skip&gt;<br>
<div class=3D"im"><br>&gt; &gt; =A0 =A0# echo 0 `blockdev --getsize /dev/ma=
pper/vg1-lv1` multisnapshot \<br>&gt; &gt; =A0 =A0 =A0/dev/mapper/vg1-lv1 /=
dev/mapper/vg1-lv2 16 0 mikulas 0\<br>&gt; &gt; =A0 =A0 =A0| dmsetup create=
 ms<br>&gt; &gt;<br>
&gt; &gt; =A0 =A0# dmsetup message /dev/mapper/ms 0 create<br>&gt;<br>&gt; =
dmsetup suspend ms<br>&gt; dmsetup resume ms<br>&gt;<br>&gt; &gt; =A0 =A0# =
echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnap-snap \<br>&gt; &g=
t; =A0 =A0 =A0/dev/mapper/vg1-lv1 0 | dmsetup create ms0<br>
&gt; &gt;<br>&gt; &gt; At this point I got the next error:<br>&gt; &gt; dev=
ice-mapper: reload ioctl failed: No such file or directory<br>&gt; &gt; Com=
mand failed<br>&gt; &gt;<br>&gt; &gt; And these lines appeared in dmesg:<br=
>
&gt; &gt; [ 6876.506623] device-mapper: table: 252:3: multisnap-snap: Snaps=
hot with this id doesn&#39;t exist<br>&gt; &gt; [ 6876.506629] device-mappe=
r: ioctl: error adding target to table<br>&gt; &gt;<br>&gt; &gt; Could you =
check all the steps I performed right and what could cause<br>
&gt; &gt; those error messages?<br>&gt; &gt;<br>&gt;<br></div>
<div class=3D"im">&gt; But rather, you could use userspace support for shar=
ed snapshots, it makes<br>&gt; the use much easier, you can use lvcreate, l=
vremove, lvresize commands:<br>&gt;<br>&gt; for lvm-2.02.54:<br>&gt; <a hre=
f=3D"http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-=
2.02.54/" target=3D"_blank">http://people.redhat.com/mpatocka/patches/users=
pace/new-snapshots/lvm-2.02.54/</a><br>
&gt; for lvm-2.02.60:<br>&gt; <a href=3D"http://people.redhat.com/mpatocka/=
patches/userspace/new-snapshots/lvm-2.02.60/" target=3D"_blank">http://peop=
le.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.60/</a><br>
&gt; for lvm-2.02.62:<br>&gt; <a href=3D"http://people.redhat.com/msnitzer/=
patches/multisnap/lvm2/LVM2-2.02.62/" target=3D"_blank">http://people.redha=
t.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.62/</a><br><br></div>--<br>
Best wishes,<br><font color=3D"#888888">Mikhail Klepachevskyy<br></font>
<div>
<div></div>
<div class=3D"h5"><br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-d=
evel@redhat.com">dm-devel@redhat.com</a><br><a href=3D"https://www.redhat.c=
om/mailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat.com/mail=
man/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br>

--000e0cd359b6694cfa04817f6260--


--===============7188002944597537391==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7188002944597537391==--
