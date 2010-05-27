From: Busby <chaimvy@gmail.com>
Subject: Re: how to load dm-multisnapshot [with LVM patch]
Date: Thu, 27 May 2010 09:38:45 +0800
Message-ID: <AANLkTikJ3OUgQ2sQ1DDvdM8FAu0J1VS65hBBznz13TLP@mail.gmail.com>
References: <AANLkTin9s-W4vvlRasZKfNqQo4r8t8hc-eE2zQTPL_jp@mail.gmail.com>
	<AANLkTinNk5D7ojJyoBnHhMDfECB7eoYrnjQS4ptW3oVI@mail.gmail.com>
	<Pine.LNX.4.64.1005260742340.31622@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2133130783524637689=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1005260742340.31622@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: daire.byrne@gmail.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2133130783524637689==
Content-Type: multipart/alternative; boundary=000e0cd7625e906963048789730e

--000e0cd7625e906963048789730e
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi ,
                  I have done as Mikulas said, and it is OK now..
                  My autoconf version seems to be low and I install the
higher one, and it is OK.
                  Thank you.

Best regards,
Busby


2010/5/26 Mikulas Patocka <mpatocka@redhat.com>

> On Wed, 26 May 2010, Busby wrote:
>
> > Hi,
> >      I have debug the lvm2.02.64 (with the shared-snapshot patches).
> >      In the last email I mentioned the 'Cannot update volume group vg00
> with
> > unknown segments in it!'
> >      The debug mesg: " vg_has_unknown_segments  function: snapshot0 has
> > unknown seg."
> >       I don't know when the snapshot0 has been created?why its segtype
> > unkown?
> >      Hope for your help.
> >      Thank you.
> >
> > Best regards,
> > Busby
>
> Hi
>
> I think that you didn't run aclocal and autoconf before ./configure and
> make. So the multisnapshot module wasn't compiled in.
>
> Do make distclean, then aclocal, autoconf, ./configure, make
>
> Mikulas
>
> > =D4=DA 2010=C4=EA5=D4=C224=C8=D5 =CF=C2=CE=E75:04=A3=ACBusby <chaimvy@g=
mail.com>=D0=B4=B5=C0=A3=BA
> >
> > > Hi All,
> > >
> > > I get the patches from:
> > > Linux kernel 2.6.34 patch:
> > > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/
> > >
> > > LVM2-2.02.64 patch:
> > > http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.64=
/
> > >
> > >
> > >
> > > but when I used it, the segment type can not find, can anyone help me=
?
> > >
> > >
> > >
> > > [root@new-host-34 ~]# pvcreate /dev/sd[bcdef]
> > >
> > > [root@new-host-34 ~]# vgcreate vg00 /dev/sd[bcdef]
> > >
> > > [root@new-host-34 ~]# lvcreate -L 100G -n lv_test /dev/vg00
> > >
> > > [root@new-host-34 ~]# lvcreate -L 200G -c 256 --sharedstore  mikulas
> -s
> > > /dev/vg00/lv_test
> > >
> > >   *WARNING: Unrecognised segment type multisnapshot*
> > >
> > > *  Cannot update volume group vg00 with unknown segments in it!*
> > >
> > > [root@new-host-34 ~]# lvscan
> > >
> > > ACTIVE         '/dev/vg00/lv_test' [100.00 GiB] inherit
> > >
> > >   inactive          '/dev/vg00/lv_test-shared' [200.00 GiB] inherit
> > >
> > > [root@new-host-34 ~]# lvcreate -s -n lv_test_ss1 /dev/vg00/lv_test
> > >
> > >   *Unable to create new logical volume with no extents*
> > >
> > >
> > >
> > >
> > >
> > > The dm modules in the system:
> > >
> > >
> > >
> > > [root@new-host-34 LVM2.2.02.64]# lsmod |grep dm
> > > dm_snapshot            25583  0
> > > dm_store_daniel        11304  0
> > > dm_store_mikulas       43265  0
> > > dm_multisnapshot       20276  2 dm_store_daniel,dm_store_mikulas
> > > dm_mirror              11564  0
> > > dm_multipath           14594  0
> > > scsi_dh                 5480  1 dm_multipath
> > > dm_region_hash          8233  1 dm_mirror
> > > dm_log                  8158  2 dm_mirror,dm_region_hash
> > > dm_mod                 58855  9 dm_snapshot,*
> > > dm_store_daniel,dm_store_mikulas,dm_multisnapshot*
> > > ,dm_mirror,dm_multipath,dm_log
> > >
> > >
> > >
> > >
> > >
> > >         I just want to use the multisnap by LVM2 command. But I don't
> know
> > > is there any document about HOW-TO?
> > >
> > >         Thank you very much.
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > Best regards,
> > >
> > > Busby
> > >
> >
>

--000e0cd7625e906963048789730e
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div>Hi ,</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; I have done as&nbsp;Mikulas said, and it i=
s&nbsp;OK now..</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;My autoconf version seems to be&nbsp;=
low and I install the higher one, and it is OK.</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thank you.&nbsp;</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br></div>
<div>Best regards,</div>
<div>Busby</div>
<div><br>&nbsp;</div>
<div class=3D"gmail_quote">2010/5/26 Mikulas Patocka <span dir=3D"ltr">&lt;=
<a href=3D"mailto:mpatocka@redhat.com">mpatocka@redhat.com</a>&gt;</span><b=
r>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Wed, 26 May 2010, Busby wrote:<br><br>&gt; Hi,<br>&gt;=
 &nbsp; &nbsp; &nbsp;I have debug the lvm2.02.64 (with the shared-snapshot =
patches).<br>&gt; &nbsp; &nbsp; &nbsp;In the last email I mentioned the &#3=
9;Cannot update volume group vg00 with<br>
&gt; unknown segments in it!&#39;<br>&gt; &nbsp; &nbsp; &nbsp;The debug mes=
g: &quot; vg_has_unknown_segments &nbsp;function: snapshot0 has<br>&gt; unk=
nown seg.&quot;<br>&gt; &nbsp; &nbsp; &nbsp; I don&#39;t know when the snap=
shot0 has been created?why its segtype<br>
&gt; unkown?<br>&gt; &nbsp; &nbsp; &nbsp;Hope for your help.<br>&gt; &nbsp;=
 &nbsp; &nbsp;Thank you.<br>&gt;<br>&gt; Best regards,<br>&gt; Busby<br><br=
></div>Hi<br><br>I think that you didn&#39;t run aclocal and autoconf befor=
e ./configure and<br>make. So the multisnapshot module wasn&#39;t compiled =
in.<br>
<br>Do make distclean, then aclocal, autoconf, ./configure, make<br><font c=
olor=3D"#888888"><br>Mikulas<br></font>
<div>
<div></div>
<div class=3D"h5"><br>&gt; =D4=DA 2010=C4=EA5=D4=C224=C8=D5 =CF=C2=CE=E75:0=
4=A3=ACBusby &lt;<a href=3D"mailto:chaimvy@gmail.com">chaimvy@gmail.com</a>=
&gt;=D0=B4=B5=C0=A3=BA<br>&gt;<br>&gt; &gt; Hi All,<br>&gt; &gt;<br>&gt; &g=
t; I get the patches from:<br>&gt; &gt; Linux kernel 2.6.34 patch:<br>
&gt; &gt; <a href=3D"http://people.redhat.com/mpatocka/patches/kernel/new-s=
napshots/r19/" target=3D"_blank">http://people.redhat.com/mpatocka/patches/=
kernel/new-snapshots/r19/</a><br>&gt; &gt;<br>&gt; &gt; LVM2-2.02.64 patch:=
<br>
&gt; &gt; <a href=3D"http://people.redhat.com/msnitzer/patches/multisnap/lv=
m2/LVM2-2.02.64/" target=3D"_blank">http://people.redhat.com/msnitzer/patch=
es/multisnap/lvm2/LVM2-2.02.64/</a><br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<=
br>
&gt; &gt; but when I used it, the segment type can not find, can anyone hel=
p me?<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt; [root@new-host-34=
 ~]# pvcreate /dev/sd[bcdef]<br>&gt; &gt;<br>&gt; &gt; [root@new-host-34 ~]=
# vgcreate vg00 /dev/sd[bcdef]<br>
&gt; &gt;<br>&gt; &gt; [root@new-host-34 ~]# lvcreate -L 100G -n lv_test /d=
ev/vg00<br>&gt; &gt;<br>&gt; &gt; [root@new-host-34 ~]# lvcreate -L 200G -c=
 256 --sharedstore &nbsp;mikulas -s<br>&gt; &gt; /dev/vg00/lv_test<br>&gt; =
&gt;<br>
&gt; &gt; &nbsp; *WARNING: Unrecognised segment type multisnapshot*<br>&gt;=
 &gt;<br>&gt; &gt; * &nbsp;Cannot update volume group vg00 with unknown seg=
ments in it!*<br>&gt; &gt;<br>&gt; &gt; [root@new-host-34 ~]# lvscan<br>&gt=
; &gt;<br>
&gt; &gt; ACTIVE &nbsp; &nbsp; &nbsp; &nbsp; &#39;/dev/vg00/lv_test&#39; [1=
00.00 GiB] inherit<br>&gt; &gt;<br>&gt; &gt; &nbsp; inactive &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;&#39;/dev/vg00/lv_test-shared&#39; [200.00 GiB] inherit=
<br>&gt; &gt;<br>&gt; &gt; [root@new-host-34 ~]# lvcreate -s -n lv_test_ss1=
 /dev/vg00/lv_test<br>
&gt; &gt;<br>&gt; &gt; &nbsp; *Unable to create new logical volume with no =
extents*<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<b=
r>&gt; &gt; The dm modules in the system:<br>&gt; &gt;<br>&gt; &gt;<br>&gt;=
 &gt;<br>
&gt; &gt; [root@new-host-34 LVM2.2.02.64]# lsmod |grep dm<br>&gt; &gt; dm_s=
napshot &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;25583 &nbsp;0<br>&gt; &gt;=
 dm_store_daniel &nbsp; &nbsp; &nbsp; &nbsp;11304 &nbsp;0<br>&gt; &gt; dm_s=
tore_mikulas &nbsp; &nbsp; &nbsp; 43265 &nbsp;0<br>&gt; &gt; dm_multisnapsh=
ot &nbsp; &nbsp; &nbsp; 20276 &nbsp;2 dm_store_daniel,dm_store_mikulas<br>
&gt; &gt; dm_mirror &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;11564 &=
nbsp;0<br>&gt; &gt; dm_multipath &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 14594 &=
nbsp;0<br>&gt; &gt; scsi_dh &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; 5480 &nbsp;1 dm_multipath<br>&gt; &gt; dm_region_hash &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;8233 &nbsp;1 dm_mirror<br>&gt; &gt; dm_log &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;8158 &nbsp;2 dm_mirror,=
dm_region_hash<br>
&gt; &gt; dm_mod &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 58=
855 &nbsp;9 dm_snapshot,*<br>&gt; &gt; dm_store_daniel,dm_store_mikulas,dm_=
multisnapshot*<br>&gt; &gt; ,dm_mirror,dm_multipath,dm_log<br>&gt; &gt;<br>=
&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; I just want to use the multisnap by L=
VM2 command. But I don&#39;t know<br>&gt; &gt; is there any document about =
HOW-TO?<br>&gt; &gt;<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Thank you ver=
y much.<br>&gt; &gt;<br>&gt; &gt;<br>
&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt; =
Best regards,<br>&gt; &gt;<br>&gt; &gt; Busby<br>&gt; &gt;<br>&gt; </div></=
div></blockquote></div><br>

--000e0cd7625e906963048789730e--


--===============2133130783524637689==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2133130783524637689==--
