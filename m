From: Busby <chaimvy@gmail.com>
Subject: Re: how to load dm-multisnapshot [with LVM patch]
Date: Wed, 26 May 2010 11:52:09 +0800
Message-ID: <AANLkTinNk5D7ojJyoBnHhMDfECB7eoYrnjQS4ptW3oVI@mail.gmail.com>
References: <AANLkTin9s-W4vvlRasZKfNqQo4r8t8hc-eE2zQTPL_jp@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1237183535875502594=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTin9s-W4vvlRasZKfNqQo4r8t8hc-eE2zQTPL_jp@mail.gmail.com>
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
Cc: daire.byrne@gmail.com, mpatocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

--===============1237183535875502594==
Content-Type: multipart/alternative; boundary=000e0cd58c6ec68f9b0487773247

--000e0cd58c6ec68f9b0487773247
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi,
     I have debug the lvm2.02.64 (with the shared-snapshot patches).
     In the last email I mentioned the 'Cannot update volume group vg00 wit=
h
unknown segments in it!'
     The debug mesg: " vg_has_unknown_segments  function: snapshot0 has
unknown seg."
      I don't know when the snapshot0 has been created?why its segtype
unkown?
     Hope for your help.
     Thank you.


Best regards,
Busby

=D4=DA 2010=C4=EA5=D4=C224=C8=D5 =CF=C2=CE=E75:04=A3=ACBusby <chaimvy@gmail=
.com>=D0=B4=B5=C0=A3=BA

> Hi All,
>
> I get the patches from:
> Linux kernel 2.6.34 patch:
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/
>
> LVM2-2.02.64 patch:
> http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.64/
>
>
>
> but when I used it, the segment type can not find, can anyone help me?
>
>
>
> [root@new-host-34 ~]# pvcreate /dev/sd[bcdef]
>
> [root@new-host-34 ~]# vgcreate vg00 /dev/sd[bcdef]
>
> [root@new-host-34 ~]# lvcreate -L 100G -n lv_test /dev/vg00
>
> [root@new-host-34 ~]# lvcreate -L 200G -c 256 --sharedstore  mikulas -s
> /dev/vg00/lv_test
>
>   *WARNING: Unrecognised segment type multisnapshot*
>
> *  Cannot update volume group vg00 with unknown segments in it!*
>
> [root@new-host-34 ~]# lvscan
>
> ACTIVE         '/dev/vg00/lv_test' [100.00 GiB] inherit
>
>   inactive          '/dev/vg00/lv_test-shared' [200.00 GiB] inherit
>
> [root@new-host-34 ~]# lvcreate -s -n lv_test_ss1 /dev/vg00/lv_test
>
>   *Unable to create new logical volume with no extents*
>
>
>
>
>
> The dm modules in the system:
>
>
>
> [root@new-host-34 LVM2.2.02.64]# lsmod |grep dm
> dm_snapshot            25583  0
> dm_store_daniel        11304  0
> dm_store_mikulas       43265  0
> dm_multisnapshot       20276  2 dm_store_daniel,dm_store_mikulas
> dm_mirror              11564  0
> dm_multipath           14594  0
> scsi_dh                 5480  1 dm_multipath
> dm_region_hash          8233  1 dm_mirror
> dm_log                  8158  2 dm_mirror,dm_region_hash
> dm_mod                 58855  9 dm_snapshot,*
> dm_store_daniel,dm_store_mikulas,dm_multisnapshot*
> ,dm_mirror,dm_multipath,dm_log
>
>
>
>
>
>         I just want to use the multisnap by LVM2 command. But I don't kno=
w
> is there any document about HOW-TO?
>
>         Thank you very much.
>
>
>
>
>
>
>
> Best regards,
>
> Busby
>

--000e0cd58c6ec68f9b0487773247
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp; I have debug the lvm2.02.64 (with the shared-=
snapshot patches).</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp; In the last email I mentioned the &#39;<font =
color=3D"#3333ff">Cannot update volume group vg00 with unknown segments in =
it!&#39;</font></div>
<div><font color=3D"#3333ff">&nbsp;&nbsp;&nbsp;&nbsp;<font color=3D"#000000=
"> The debug mesg</font>: &quot;</font><font color=3D"#ff9900">&nbsp;</font=
><font color=3D"#6633ff">vg_has_unknown_segments&nbsp; function: snapshot0 =
has unknown seg.&quot;</font></div>

<div><font color=3D"#ff9900">&nbsp;&nbsp;</font><font color=3D"#000000">&nb=
sp; &nbsp; I don&#39;t know when the snapshot0 has been created?why its seg=
type unkown?</font></div>
<div><font color=3D"#ff9900"><font color=3D"#000000">&nbsp;&nbsp;&nbsp;&nbs=
p; Hope for your help.</font></font></div>
<div><font color=3D"#ff9900"><font color=3D"#000000">&nbsp;&nbsp;&nbsp;&nbs=
p; Thank you.</font></font></div>
<p><font color=3D"#ff9900"><font color=3D"#000000"></font></font>&nbsp;</p>
<div><font color=3D"#000000">Best regards,</font></div>
<div><font color=3D"#ff9900"><font color=3D"#000000">Busby</font></font></d=
iv>
<div><br></div>
<div class=3D"gmail_quote">=D4=DA 2010=C4=EA5=D4=C224=C8=D5 =CF=C2=CE=E75:0=
4=A3=ACBusby <span dir=3D"ltr">&lt;<a href=3D"mailto:chaimvy@gmail.com">cha=
imvy@gmail.com</a>&gt;</span>=D0=B4=B5=C0=A3=BA<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>Hi All,</div>
<div>&nbsp;</div>
<div>I get the patches from:&nbsp;&nbsp;</div>
<div><span lang=3D"EN-US"><font size=3D"3" face=3D"Times New Roman">Linux k=
ernel 2.6.34 patch: </font></span><span lang=3D"EN-US"><a href=3D"http://pe=
ople.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/" target=3D"_blan=
k"><font size=3D"3" face=3D"Times New Roman">http://people.redhat.com/mpato=
cka/patches/kernel/new-snapshots/r19/</font></a></span></div>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">LVM2-2.02.64 patch: </font></span>=
<span lang=3D"EN-US"><a href=3D"http://people.redhat.com/msnitzer/patches/m=
ultisnap/lvm2/LVM2-2.02.64/" target=3D"_blank"><font size=3D"3" face=3D"Tim=
es New Roman">http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2=
-2.02.64/</font></a></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">b=
ut when I used it, the segment type can not find, can anyone help me?</span=
></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p><span lang=3D"EN-US">
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# pvcreate /de=
v/sd[bcdef]</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# vgcreate vg0=
0 /dev/sd[bcdef]</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# lvcreate -L =
100G -n lv_test /dev/vg00</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# lvcreate -L =
200G -c 256 --sharedstore <span>&nbsp;</span>mikulas -s /dev/vg00/lv_test</=
font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3"><font face=3D"Times New Roman"><span>&nbsp; </span><font co=
lor=3D"#3333ff"><strong>WARNING: Unrecognised segment type multisnapshot</s=
trong></font></font></font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3"><font face=3D"Times New Roman"><font color=3D"#3333ff"><str=
ong><span>&nbsp; </span>Cannot update volume group vg00 with unknown segmen=
ts in it!<span style=3D"COLOR: navy"></span></strong></font></font></font><=
/span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# lvscan</font=
></span></p>
<p style=3D"TEXT-INDENT: 10.5pt; MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><=
span lang=3D"EN-US"><font size=3D"3" face=3D"Times New Roman">ACTIVE<span>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&#39;/dev/vg00/lv_te=
st&#39; [100.00 GiB] inherit</font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3"><font face=3D"Times New Roman"><span>&nbsp;</span><span>&nb=
sp;</span>inactive<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; </span>&#39;/dev/vg00/lv_test-shared&#39; [200.00 GiB] inherit</font></=
font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# lvcreate -s =
-n lv_test_ss1 /dev/vg00/lv_test </font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span style=3D"FONT-FA=
MILY: &#39;Times New Roman&#39;,&#39;serif&#39;; FONT-SIZE: 10.5pt" lang=3D=
"EN-US"><span>&nbsp; </span><span style=3D"COLOR: navy"><strong>Unable to c=
reate new logical volume with no extents</strong></span></span></p>
</span>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">T=
he dm modules in the system:</span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">[=
root@new-host-34 LVM2.2.02.64]# lsmod |grep dm<br>dm_snapshot&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25583&nbsp; 0 <br>dm_s=
tore_daniel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11304&nbsp; 0 <br>dm_=
store_mikulas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 43265&nbsp; 0 <br>
dm_multisnapshot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20276&nbsp; 2 dm_store=
_daniel,dm_store_mikulas<br>dm_mirror&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11564&nbsp; 0 <br>dm_multipath&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14594&nbsp; 0 <br>=
scsi_dh&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; 5480&nbsp; 1 dm_multipath<br>dm_region_hash&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8233&nbsp; 1 dm_mirror<=
br>
dm_log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8158&nbsp; 2 dm_mirror,dm_region_hash<br>=
dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 58855&nbsp; 9 dm_snapshot,<font color=3D"#3366f=
f"><strong>dm_store_daniel,dm_store_mikulas,dm_multisnapshot</strong></font=
>,dm_mirror,dm_multipath,dm_log</span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">&=
nbsp;&nbsp;&nbsp;&nbsp; </span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; I just want to use the multisnap =
by LVM2 command. But I don&#39;t know is there any document about HOW-TO?</=
span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Thank you very much.</span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
/span>&nbsp;</p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">B=
est regards,</span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US">B=
usby</span></p></blockquote></div><br>

--000e0cd58c6ec68f9b0487773247--


--===============1237183535875502594==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1237183535875502594==--
