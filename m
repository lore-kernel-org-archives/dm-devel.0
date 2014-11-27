From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 16:56:13 +0100
Message-ID: <CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
	<54773621.5090301@redhat.com>
	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
	<54774220.7080709@redhat.com>
	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
	<5477469A.1080103@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1166457124425835510=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5477469A.1080103@redhat.com>
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

--===============1166457124425835510==
Content-Type: multipart/alternative; boundary=089e01176a4b04d1350508d92fa0

--089e01176a4b04d1350508d92fa0
Content-Type: text/plain; charset=UTF-8

On Thu, Nov 27, 2014 at 4:43 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

>
>> Thanks!
>> here it is:
>> https://drive.google.com/file/d/0BwoPbcrMv8mvellaS1FtVXpqU2c/
>> view?usp=sharing
>>
>>
>>
> Well yes - it shows the device is being held open - lvm2 retries to
> several times if the device does not get close - but it doesn't so it
> refuses o deactivate.
>
> So if you are sure there is no user - then maybe you have some kpartx
> partition this device ?
>

No, the PV is the whole disk and the VG is composed only of this LV that
uses all the PEs

[root@orapr2 ~]# pvs /dev/mapper/360a9800037543544465d424130533177
  PV                                            VG          Fmt  Attr PSize
   PFree
  /dev/mapper/360a9800037543544465d424130533177 VG_AAA_TEMP lvm2 a--
 1020.00m    0

[root@orapr2 ~]# fdisk -l /dev/mapper/360a9800037543544465d424130533177

Disk /dev/mapper/360a9800037543544465d424130533177: 1073 MB, 1073741824
bytes
255 heads, 63 sectors/track, 130 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 65536 bytes
Disk identifier: 0x00000000

[root@orapr2 ~]# vgdisplay -v VG_AAA_TEMP
    Using volume group(s) on command line
    Finding volume group "VG_AAA_TEMP"
  --- Volume group ---
  VG Name               VG_AAA_TEMP
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  56
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               1020.00 MiB
  PE Size               4.00 MiB
  Total PE              255
  Alloc PE / Size       255 / 1020.00 MiB
  Free  PE / Size       0 / 0
  VG UUID               3sItFO-bvAo-FINS-R6Mj-Fcl7-4kF2-gmzY4M

  --- Logical volume ---
  LV Path                /dev/VG_AAA_TEMP/LV_AAA_TEMP
  LV Name                LV_AAA_TEMP
  VG Name                VG_AAA_TEMP
  LV UUID                azFNtf-L1CY-3rdz-OQLA-7oF4-3rMX-uWfXpH
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                1020.00 MiB
  Current LE             255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:49

  --- Physical volumes ---
  PV Name               /dev/mapper/360a9800037543544465d424130533177
  PV UUID               LnsWgD-XfYe-axfJ-nBgC-Gew5-jBH3-oXpiIO
  PV Status             allocatable
  Total PE / Free PE    255 / 0




>
> I'd probably need to see your whole 'dmsetup table'
> (at least do a grep for VG_AAA_TEMP/LV_AAA_TEMP minor)



[root@orapr2 ~]# dmsetup table | egrep
"AAA_TEMP|360a9800037543544465d424130533177|253:4"
VG_AAA_TEMP-LV_AAA_TEMP: 0 2088960 linear 253:4 384
360a9800037543544465d424130533177: 0 2097152 multipath 4 queue_if_no_path
pg_init_retries 50 retain_attached_hw_handler 1 alua 2 1 round-robin 0 4 1
66:160 1 69:192 1 133:224 1 8:288 1 round-robin 0 4 1 8:96 1 68:48 1 129:32
1 130:128 1

It seems no sempahores to be cleaned...
[root@orapr2 ~]# dmsetup udevcomplete_all 1
This operation will destroy all semaphores older than 1 minutes with keys
that have a prefix 3405 (0xd4d).
Do you really want to continue? [y/n]: y
0 semaphores with keys prefixed by 3405 (0xd4d) destroyed. 0 skipped.

and still
[root@orapr2 ~]# lvchange -an VG_AAA_TEMP/LV_AAA_TEMP
  Logical volume VG_AAA_TEMP/LV_AAA_TEMP in use.

;-(

--089e01176a4b04d1350508d92fa0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 27, 2014 at 4:43 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(2=
04,204,204);border-left-style:solid;padding-left:1ex"><span class=3D""><br>
Thanks!<br>
here it is:<br>
<a href=3D"https://drive.google.com/file/d/0BwoPbcrMv8mvellaS1FtVXpqU2c/vie=
w?usp=3Dsharing" target=3D"_blank">https://drive.google.com/file/<u></u>d/<=
u></u>0BwoPbcrMv8mvellaS1FtVXpqU2c/<u></u>view?usp=3Dsharing</a><br>
<br>
<br>
</span></blockquote>
<br>
Well yes - it shows the device is being held open - lvm2 retries to several=
 times if the device does not get close - but it doesn&#39;t so it refuses =
o deactivate.<br>
<br>
So if you are sure there is no user - then maybe you have some kpartx parti=
tion this device ?<br></blockquote><div><br></div><div>No, the PV is the wh=
ole disk and the VG is composed only of this LV that uses all the PEs</div>=
<div><br></div><div><div>[root@orapr2 ~]# pvs /dev/mapper/360a9800037543544=
465d424130533177</div><div>=C2=A0 PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0VG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0Fmt =C2=A0Attr PSize =C2=A0 =C2=A0PFree</div><div>=C2=A0 /dev/mapper/360=
a9800037543544465d424130533177 VG_AAA_TEMP lvm2 a-- =C2=A01020.00m =C2=A0 =
=C2=A00=C2=A0</div></div><div><br></div><div><div>[root@orapr2 ~]# fdisk -l=
 /dev/mapper/360a9800037543544465d424130533177</div><div><br></div><div>Dis=
k /dev/mapper/360a9800037543544465d424130533177: 1073 MB, 1073741824 bytes<=
/div><div>255 heads, 63 sectors/track, 130 cylinders</div><div>Units =3D cy=
linders of 16065 * 512 =3D 8225280 bytes</div><div>Sector size (logical/phy=
sical): 512 bytes / 4096 bytes</div><div>I/O size (minimum/optimal): 4096 b=
ytes / 65536 bytes</div><div>Disk identifier: 0x00000000</div></div><div><b=
r></div><div><div>[root@orapr2 ~]# vgdisplay -v VG_AAA_TEMP</div><div>=C2=
=A0 =C2=A0 Using volume group(s) on command line</div><div>=C2=A0 =C2=A0 Fi=
nding volume group &quot;VG_AAA_TEMP&quot;</div><div>=C2=A0 --- Volume grou=
p ---</div><div>=C2=A0 VG Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 VG_AAA_TEMP</div><div>=C2=A0 System ID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0=C2=A0</div><div>=C2=A0 Format =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0lvm2</div><div>=C2=A0 Metadata Areas =C2=A0 =C2=A0 =
=C2=A0 =C2=A01</div><div>=C2=A0 Metadata Sequence No =C2=A056</div><div>=C2=
=A0 VG Access =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 read/write</div><di=
v>=C2=A0 VG Status =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 resizable</div=
><div>=C2=A0 MAX LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0</div><div>=C2=A0 Cur LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01</div><div>=C2=A0 Open LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 1</div><div>=C2=A0 Max PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</div><div>=C2=A0 Cur PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A01</div><div>=C2=A0 Act PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A01</div><div>=C2=A0 VG Size =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 1020.00 MiB</div><div>=C2=A0 PE Size =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 4.00 MiB</div><div>=C2=A0 Total PE =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0255</div><div>=C2=A0 Alloc =
PE / Size =C2=A0 =C2=A0 =C2=A0 255 / 1020.00 MiB</div><div>=C2=A0 Free =C2=
=A0PE / Size =C2=A0 =C2=A0 =C2=A0 0 / 0 =C2=A0=C2=A0</div><div>=C2=A0 VG UU=
ID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3sItFO-bvAo-FINS-R6Mj-F=
cl7-4kF2-gmzY4M</div><div>=C2=A0 =C2=A0</div><div>=C2=A0 --- Logical volume=
 ---</div><div>=C2=A0 LV Path =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/dev/VG_AAA_TEMP/LV_AAA_TEMP</div><div>=C2=A0 LV Name =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LV_AAA_TEMP</div><div>=C2=A0 V=
G Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0VG_AAA_TEMP</=
div><div>=C2=A0 LV UUID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0azFNtf-L1CY-3rdz-OQLA-7oF4-3rMX-uWfXpH</div><div>=C2=A0 LV Write Acce=
ss =C2=A0 =C2=A0 =C2=A0 =C2=A0read/write</div><div>=C2=A0 LV Creation host,=
 time ,=C2=A0</div><div>=C2=A0 LV Status =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0available</div><div>=C2=A0 # open =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1</div><div>=C2=A0 LV Size =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01020.00 MiB</div><div>=C2=A0 Current =
LE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 255</div><div>=C2=A0 Segments =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1</div><div>=C2=A0 Allocat=
ion =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inherit</div><div>=C2=A0 Read=
 ahead sectors =C2=A0 =C2=A0 auto</div><div>=C2=A0 - currently set to =C2=
=A0 =C2=A0 256</div><div>=C2=A0 Block device =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 253:49</div><div>=C2=A0 =C2=A0</div><div>=C2=A0 --- Physical volumes=
 ---</div><div>=C2=A0 PV Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /dev/mapper/360a9800037543544465d424130533177 =C2=A0 =C2=A0=C2=A0</div>=
<div>=C2=A0 PV UUID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LnsWgD=
-XfYe-axfJ-nBgC-Gew5-jBH3-oXpiIO</div><div>=C2=A0 PV Status =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 allocatable</div><div>=C2=A0 Total PE / Free PE=
 =C2=A0 =C2=A0255 / 0</div></div><div><br></div><div><br></div><div>=C2=A0<=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:so=
lid;padding-left:1ex">
<br>
I&#39;d probably need to see your whole &#39;dmsetup table&#39;<br>
(at least do a grep for VG_AAA_TEMP/LV_AAA_TEMP minor)</blockquote><div><br=
></div><div><br></div><div>[root@orapr2 ~]# dmsetup table | egrep &quot;AAA=
_TEMP|360a9800037543544465d424130533177|253:4&quot;<br></div><div><div>VG_A=
AA_TEMP-LV_AAA_TEMP: 0 2088960 linear 253:4 384</div><div>360a9800037543544=
465d424130533177: 0 2097152 multipath 4 queue_if_no_path pg_init_retries 50=
 retain_attached_hw_handler 1 alua 2 1 round-robin 0 4 1 66:160 1 69:192 1 =
133:224 1 8:288 1 round-robin 0 4 1 8:96 1 68:48 1 129:32 1 130:128 1=C2=A0=
</div></div><div><br></div><div>It seems no sempahores to be cleaned...</di=
v><div><div>[root@orapr2 ~]# dmsetup udevcomplete_all 1</div><div>This oper=
ation will destroy all semaphores older than 1 minutes with keys that have =
a prefix 3405 (0xd4d).</div><div>Do you really want to continue? [y/n]: y</=
div><div>0 semaphores with keys prefixed by 3405 (0xd4d) destroyed. 0 skipp=
ed.</div></div><div><br></div></div>and still</div><div class=3D"gmail_extr=
a"><div class=3D"gmail_extra">[root@orapr2 ~]# lvchange -an VG_AAA_TEMP/LV_=
AAA_TEMP</div><div class=3D"gmail_extra">=C2=A0 Logical volume VG_AAA_TEMP/=
LV_AAA_TEMP in use.</div><div><br></div><div>;-(</div></div></div>

--089e01176a4b04d1350508d92fa0--


--===============1166457124425835510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1166457124425835510==--
