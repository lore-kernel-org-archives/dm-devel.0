From: Busby <chaimvy@gmail.com>
Subject: how to load dm-multisnapshot [with LVM patch]
Date: Mon, 24 May 2010 17:04:41 +0800
Message-ID: <AANLkTin9s-W4vvlRasZKfNqQo4r8t8hc-eE2zQTPL_jp@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1583209348758829005=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============1583209348758829005==
Content-Type: multipart/alternative; boundary=000e0cdf16ccd1c84404875354fa

--000e0cdf16ccd1c84404875354fa
Content-Type: text/plain; charset=ISO-8859-1

Hi All,

I get the patches from:
Linux kernel 2.6.34 patch:
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/

LVM2-2.02.64 patch:
http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.64/



but when I used it, the segment type can not find, can anyone help me?



[root@new-host-34 ~]# pvcreate /dev/sd[bcdef]

[root@new-host-34 ~]# vgcreate vg00 /dev/sd[bcdef]

[root@new-host-34 ~]# lvcreate -L 100G -n lv_test /dev/vg00

[root@new-host-34 ~]# lvcreate -L 200G -c 256 --sharedstore  mikulas -s
/dev/vg00/lv_test

  *WARNING: Unrecognised segment type multisnapshot*

*  Cannot update volume group vg00 with unknown segments in it!*

[root@new-host-34 ~]# lvscan

ACTIVE         '/dev/vg00/lv_test' [100.00 GiB] inherit

  inactive          '/dev/vg00/lv_test-shared' [200.00 GiB] inherit

[root@new-host-34 ~]# lvcreate -s -n lv_test_ss1 /dev/vg00/lv_test

  *Unable to create new logical volume with no extents*





The dm modules in the system:



[root@new-host-34 LVM2.2.02.64]# lsmod |grep dm
dm_snapshot            25583  0
dm_store_daniel        11304  0
dm_store_mikulas       43265  0
dm_multisnapshot       20276  2 dm_store_daniel,dm_store_mikulas
dm_mirror              11564  0
dm_multipath           14594  0
scsi_dh                 5480  1 dm_multipath
dm_region_hash          8233  1 dm_mirror
dm_log                  8158  2 dm_mirror,dm_region_hash
dm_mod                 58855  9 dm_snapshot,*
dm_store_daniel,dm_store_mikulas,dm_multisnapshot*
,dm_mirror,dm_multipath,dm_log





        I just want to use the multisnap by LVM2 command. But I don't know
is there any document about HOW-TO?

        Thank you very much.







Best regards,

Busby

--000e0cdf16ccd1c84404875354fa
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div>Hi All,</div>
<div>&nbsp;</div>
<div>I get the patches from:&nbsp;&nbsp;</div>
<div><span lang=3D"EN-US"><font size=3D"3" face=3D"Times New Roman">Linux k=
ernel 2.6.34 patch: </font></span><span lang=3D"EN-US"><a href=3D"http://pe=
ople.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/"><font size=3D"3=
" face=3D"Times New Roman">http://people.redhat.com/mpatocka/patches/kernel=
/new-snapshots/r19/</font></a></span></div>

<p style=3D"MARGIN: 0cm 0cm 0pt; mso-outline-level: 1" class=3D"MsoNormal">=
<span lang=3D"EN-US"><font size=3D"3" face=3D"Times New Roman">LVM2-2.02.64=
 patch: </font></span><span lang=3D"EN-US"><a href=3D"http://people.redhat.=
com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.64/"><font size=3D"3" face=3D=
"Times New Roman">http://people.redhat.com/msnitzer/patches/multisnap/lvm2/=
LVM2-2.02.64/</font></a></span></p>

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
200G -c 256 --sharedstore <span style=3D"mso-spacerun: yes">&nbsp;</span>mi=
kulas -s /dev/vg00/lv_test</font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3"><font face=3D"Times New Roman"><span style=3D"mso-spacerun:=
 yes">&nbsp; </span><font color=3D"#3333ff"><strong>WARNING: Unrecognised s=
egment type multisnapshot</strong></font></font></font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3"><font face=3D"Times New Roman"><font color=3D"#3333ff"><str=
ong><span style=3D"mso-spacerun: yes">&nbsp; </span>Cannot update volume gr=
oup vg00 with unknown segments in it!<span style=3D"COLOR: navy"></span></s=
trong></font></font></font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# lvscan</font=
></span></p>
<p style=3D"TEXT-INDENT: 10.5pt; MARGIN: 0cm 0cm 0pt; mso-char-indent-count=
: 1.0" class=3D"MsoNormal"><span lang=3D"EN-US"><font size=3D"3" face=3D"Ti=
mes New Roman">ACTIVE<span style=3D"mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&#39;/dev/vg00/lv_test&#39; [100.00 GiB=
] inherit</font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3"><font face=3D"Times New Roman"><span style=3D"mso-spacerun:=
 yes">&nbsp;</span><span style=3D"mso-spacerun: yes">&nbsp;</span>inactive<=
span style=3D"mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; </span>&#39;/dev/vg00/lv_test-shared&#39; [200.00 GiB] inherit=
</font></font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span lang=3D"EN-US"><=
font size=3D"3" face=3D"Times New Roman">[root@new-host-34 ~]# lvcreate -s =
-n lv_test_ss1 /dev/vg00/lv_test </font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt" class=3D"MsoNormal"><span style=3D"FONT-FA=
MILY: &#39;Times New Roman&#39;,&#39;serif&#39;; FONT-SIZE: 10.5pt; mso-bid=
i-font-size: 12.0pt; mso-fareast-font-family: =CB=CE=CC=E5; mso-font-kernin=
g: 1.0pt; mso-ansi-language: EN-US; mso-fareast-language: ZH-CN; mso-bidi-l=
anguage: AR-SA" lang=3D"EN-US"><span style=3D"mso-spacerun: yes">&nbsp; </s=
pan><span style=3D"COLOR: navy"><strong>Unable to create new logical volume=
 with no extents</strong></span></span></p>
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
usby</span></p>

--000e0cdf16ccd1c84404875354fa--


--===============1583209348758829005==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1583209348758829005==--
