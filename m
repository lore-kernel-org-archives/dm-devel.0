From: Ryan Norwood <ryan.p.norwood@gmail.com>
Subject: Re: max_sectors_kb limitations with VDO and dm-thin
Date: Wed, 24 Apr 2019 10:46:00 -0400
Message-ID: <CAFTvtQnALzibyS3jKisXRb+XGe8dopQfkj33=gtJAjd2+XymYQ@mail.gmail.com>
References: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
	<45987177-c92c-d906-50bc-f4c789c36857@redhat.com>
	<CAFTvtQ=JiZ7FWNiayM5bVY5A8ZCNbDtXV=rUxa_0u6Xm6rJAqg@mail.gmail.com>
	<CAMeeMh-v+xpn2YDizFQg4cKHZgC=aCdJwLfAMeGLGT1gB1ZURw@mail.gmail.com>
	<CAFTvtQnLDU_MKzse5t4xc_CVWENsZtwQQSTAFyj-45tPg5STZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8941258127222943567=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFTvtQnLDU_MKzse5t4xc_CVWENsZtwQQSTAFyj-45tPg5STZQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, vdo-devel@redhat.com
List-Id: dm-devel.ids

--===============8941258127222943567==
Content-Type: multipart/alternative; boundary="000000000000454c46058747c3c2"

--000000000000454c46058747c3c2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2019 at 9:08 AM Ryan Norwood <ryan.p.norwood@gmail.com>
wrote:

> Thank you for your help.
>
> You are correct, it appears that the problem occurs when there is a RAID =
5
> or RAID 50 volume beneath VDO.
>
> NAME      KNAME    RA   SIZE ALIGNMENT  MIN-IO  OPT-IO PHY-SEC LOG-SEC
> RQ-SIZE SCHED    WSAME
> sdh                                                                   sdh
>    128 977.5G         0     512       0     512     512     128 deadline
> 0B
> =E2=94=94=E2=94=80sed6
> dm-6    128 977.5G         0     512       0     512     512     128
>      0B
>   =E2=94=94=E2=94=80md127
>  md127 12288   5.7T         0 1048576 6291456     512     512     128
>        0B
>     =E2=94=94=E2=94=80vdo_data
> dm-17   128   5.7T         0 1048576 6291456     512     512     128
>      0B
>       =E2=94=94=E2=94=80vdo
>  dm-18   128  57.3T         0    4096    4096    4096    4096     128
>        0B
>
> */sys/block/md126/queue/max_hw_sectors_kb:2147483647*
> /sys/block/md126/queue/max_integrity_segments:0
> */sys/block/md126/queue/max_sectors_kb:512*
> /sys/block/md126/queue/max_segments:64
> /sys/block/md126/queue/max_segment_size:4096
>
> */sys/block/dm-17/queue/max_hw_sectors_kb:512*
> /sys/block/dm-17/queue/max_integrity_segments:0
> */sys/block/dm-17/queue/max_sectors_kb:512*
> /sys/block/dm-17/queue/max_segments:64
> /sys/block/dm-17/queue/max_segment_size:4096
>
> */sys/block/dm-18/queue/max_hw_sectors_kb:4*
> /sys/block/dm-18/queue/max_integrity_segments:0
> */sys/block/dm-18/queue/max_sectors_kb:4*
> /sys/block/dm-18/queue/max_segments:64
> /sys/block/dm-18/queue/max_segment_size:4096
>
> NAME      KNAME    RA   SIZE ALIGNMENT  MIN-IO  OPT-IO PHY-SEC LOG-SEC
> RQ-SIZE SCHED    WSAME
> sdq       sdq     128 977.5G         0     512       0     512     512
>  128 deadline    0B
> =E2=94=94=E2=94=80sed15   dm-15   128 977.5G         0     512       0   =
  512     512
>  128             0B
>   =E2=94=94=E2=94=80vdo   dm-16   128  57.3T         0    4096    4096   =
 4096    4096
>  128             0B
>
> */sys/block/sdq/queue/max_hw_sectors_kb:256*
> /sys/block/sdq/queue/max_integrity_segments:0
> */sys/block/sdq/queue/max_sectors_kb:256*
> /sys/block/sdq/queue/max_segments:64
> /sys/block/sdq/queue/max_segment_size:65536
>
> */sys/block/dm-15/queue/max_hw_sectors_kb:256*
> /sys/block/dm-15/queue/max_integrity_segments:0
> */sys/block/dm-15/queue/max_sectors_kb:256*
> /sys/block/dm-15/queue/max_segments:64
> /sys/block/dm-15/queue/max_segment_size:4096
>
> */sys/block/dm-16/queue/max_hw_sectors_kb:256*
> /sys/block/dm-16/queue/max_integrity_segments:0
> */sys/block/dm-16/queue/max_sectors_kb:256*
> /sys/block/dm-16/queue/max_segments:64
> /sys/block/dm-16/queue/max_segment_size:4096
>
>
>
>
>
>
>
>
> On Tue, Apr 23, 2019 at 9:11 PM Sweet Tea Dorminy <sweettea@redhat.com>
> wrote:
>
>> One piece of this that I'm not following:
>>
>> > Now fast forward to VDO. Normally the IO size is determined by the
>> max_sectors_kb setting in /sys/block/DEVICE/queue. This value is inherit=
ed
>> for stacked DM devices and can be modified by the user up to the hardwar=
e
>> limit max_hw_sectors_kb, which also appears to be inherited for stacked =
DM
>> devices. VDO sets this value to 4k which in turn forces all layers stack=
ed
>> above it to also have a 4k maximum. If you take my previous example but
>> place VDO beneath the dm-thin volume, all IO sequential or otherwise wil=
l
>> be split down to 4k which will completely eliminate all the performance
>> optimizations that dm-thin provides.
>>
>> I am unable to find a place that VDO is setting max_sectors, and
>> indeed I cannot reproduce this -- I stack VDO atop various disks of
>> max_hw_sectors_kb of 256, 512, or 1280, and VDO reports max_sectors_kb
>> of [underlying max_hw_sectors_kb]. I'm suspicious that it's some other
>> setting that is going wonky... can you recheck whether max_sectors_kb
>> is changing between (device under VDO) and (VDO device)?
>>
>

--000000000000454c46058747c3c2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">On Wed, Apr 24, 2019 at 9:08 AM Ryan Norwood &lt;<a hr=
ef=3D"mailto:ryan.p.norwood@gmail.com">ryan.p.norwood@gmail.com</a>&gt; wro=
te:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"=
ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><d=
iv dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">Thank you for your help.<d=
iv><br></div><div>You are correct, it appears that the problem occurs when =
there is a RAID 5 or RAID 50 volume beneath VDO.</div><div><br></div><div>N=
AME=C2=A0 =C2=A0 =C2=A0 KNAME=C2=A0 =C2=A0 RA=C2=A0 =C2=A0SIZE ALIGNMENT=C2=
=A0 MIN-IO=C2=A0 OPT-IO PHY-SEC LOG-SEC RQ-SIZE SCHED=C2=A0 =C2=A0 WSAME<br=
></div><div><div><font face=3D"monospace, monospace">sdh=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sd=
h=C2=A0 =C2=A0 =C2=A0128 977.5G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128 deadline=C2=A0 =C2=A0 0B</font></di=
v><div><font face=3D"monospace, monospace">=E2=94=94=E2=94=80sed6=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dm-6=C2=
=A0 =C2=A0 128 977.5G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=
=A0512=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=
=A0512=C2=A0 =C2=A0 =C2=A0128=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00B</font></div><div><font face=3D"monospace, monospace">=C2=A0 =E2=94=94=
=E2=94=80md127=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0md127 12288=C2=A0 =C2=A05.7T=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 1=
048576 6291456=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =
=C2=A0128=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B</font></div><di=
v><font face=3D"monospace, monospace">=C2=A0 =C2=A0 =E2=94=94=E2=94=80vdo_d=
ata=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dm-17=C2=A0 =C2=A0128=
=C2=A0 =C2=A05.7T=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 1048576 6291456=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B</font></div><div><font face=3D"monosp=
ace, monospace">=C2=A0 =C2=A0 =C2=A0 =E2=94=94=E2=94=80vdo=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm-18=C2=A0 =C2=A0128=C2=A0 57=
.3T=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 4096=
=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 =C2=A0128=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B</font></div></div><div><font face=3D"m=
onospace, monospace"><br></font></div><div><div><div><b>/sys/block/md126/qu=
eue/max_hw_sectors_kb:2147483647</b></div><div>/sys/block/md126/queue/max_i=
ntegrity_segments:0</div><div><b>/sys/block/md126/queue/max_sectors_kb:512<=
/b></div><div>/sys/block/md126/queue/max_segments:64</div><div>/sys/block/m=
d126/queue/max_segment_size:4096</div></div><div><br></div><div><b>/sys/blo=
ck/dm-17/queue/max_hw_sectors_kb:512</b></div><div>/sys/block/dm-17/queue/m=
ax_integrity_segments:0</div><div><b>/sys/block/dm-17/queue/max_sectors_kb:=
512</b></div><div>/sys/block/dm-17/queue/max_segments:64</div><div>/sys/blo=
ck/dm-17/queue/max_segment_size:4096</div><div><br></div><div><b>/sys/block=
/dm-18/queue/max_hw_sectors_kb:4</b></div><div>/sys/block/dm-18/queue/max_i=
ntegrity_segments:0</div><div><b>/sys/block/dm-18/queue/max_sectors_kb:4</b=
></div><div>/sys/block/dm-18/queue/max_segments:64</div><div>/sys/block/dm-=
18/queue/max_segment_size:4096</div></div><div><br></div><div>NAME=C2=A0 =
=C2=A0 =C2=A0 KNAME=C2=A0 =C2=A0 RA=C2=A0 =C2=A0SIZE ALIGNMENT=C2=A0 MIN-IO=
=C2=A0 OPT-IO PHY-SEC LOG-SEC RQ-SIZE SCHED=C2=A0 =C2=A0 WSAME<br></div><di=
v><div><font face=3D"monospace, monospace">sdq=C2=A0 =C2=A0 =C2=A0 =C2=A0sd=
q=C2=A0 =C2=A0 =C2=A0128 977.5G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128 deadline=C2=A0 =C2=A0 0B</font></di=
v><div><font face=3D"monospace, monospace">=E2=94=94=E2=94=80sed15=C2=A0 =
=C2=A0dm-15=C2=A0 =C2=A0128 977.5G=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0=
 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00B</font></div><div><font face=3D"monospace, monospace">=C2=A0=
 =E2=94=94=E2=94=80vdo=C2=A0 =C2=A0dm-16=C2=A0 =C2=A0128=C2=A0 57.3T=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 4096=C2=A0 =C2=
=A0 4096=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 =C2=A0128=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00B</font></div></div><div><font face=3D"monospace, =
monospace"><br></font></div><div><div><div><font face=3D"arial, helvetica, =
sans-serif"><b>/sys/block/sdq/queue/max_hw_sectors_kb:256</b></font></div><=
div><font face=3D"arial, helvetica, sans-serif">/sys/block/sdq/queue/max_in=
tegrity_segments:0</font></div><div><font face=3D"arial, helvetica, sans-se=
rif"><b>/sys/block/sdq/queue/max_sectors_kb:256</b></font></div><div><font =
face=3D"arial, helvetica, sans-serif">/sys/block/sdq/queue/max_segments:64<=
/font></div><div><font face=3D"arial, helvetica, sans-serif">/sys/block/sdq=
/queue/max_segment_size:65536</font></div></div><div><div><font face=3D"ari=
al, helvetica, sans-serif"><br class=3D"gmail-m_7391193115041869426gmail-Ap=
ple-interchange-newline"><b>/sys/block/dm-15/queue/max_hw_sectors_kb:256</b=
></font></div><div><font face=3D"arial, helvetica, sans-serif">/sys/block/d=
m-15/queue/max_integrity_segments:0</font></div><div><font face=3D"arial, h=
elvetica, sans-serif"><b>/sys/block/dm-15/queue/max_sectors_kb:256</b></fon=
t></div><div><font face=3D"arial, helvetica, sans-serif">/sys/block/dm-15/q=
ueue/max_segments:64</font></div><div><font face=3D"arial, helvetica, sans-=
serif">/sys/block/dm-15/queue/max_segment_size:4096</font></div></div><div>=
<font face=3D"arial, helvetica, sans-serif"><br></font></div><div><font fac=
e=3D"arial, helvetica, sans-serif"><b>/sys/block/dm-16/queue/max_hw_sectors=
_kb:256</b></font></div><div><font face=3D"arial, helvetica, sans-serif">/s=
ys/block/dm-16/queue/max_integrity_segments:0</font></div><div><font face=
=3D"arial, helvetica, sans-serif"><b>/sys/block/dm-16/queue/max_sectors_kb:=
256</b></font></div><div><font face=3D"arial, helvetica, sans-serif">/sys/b=
lock/dm-16/queue/max_segments:64</font></div><div><font face=3D"arial, helv=
etica, sans-serif">/sys/block/dm-16/queue/max_segment_size:4096</font></div=
><div><br></div><div><font face=3D"arial, helvetica, sans-serif"><br></font=
></div><div><br></div><div style=3D"font-family:monospace,monospace"><br></=
div></div><div><br></div><div><br></div><div><br></div></div></div></div></=
div></div></div></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr"=
 class=3D"gmail_attr">On Tue, Apr 23, 2019 at 9:11 PM Sweet Tea Dorminy &lt=
;<a href=3D"mailto:sweettea@redhat.com" target=3D"_blank">sweettea@redhat.c=
om</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
">One piece of this that I&#39;m not following:<br>
<br>
&gt; Now fast forward to VDO. Normally the IO size is determined by the max=
_sectors_kb setting in /sys/block/DEVICE/queue. This value is inherited for=
 stacked DM devices and can be modified by the user up to the hardware limi=
t max_hw_sectors_kb, which also appears to be inherited for stacked DM devi=
ces. VDO sets this value to 4k which in turn forces all layers stacked abov=
e it to also have a 4k maximum. If you take my previous example but place V=
DO beneath the dm-thin volume, all IO sequential or otherwise will be split=
 down to 4k which will completely eliminate all the performance optimizatio=
ns that dm-thin provides.<br>
<br>
I am unable to find a place that VDO is setting max_sectors, and<br>
indeed I cannot reproduce this -- I stack VDO atop various disks of<br>
max_hw_sectors_kb of 256, 512, or 1280, and VDO reports max_sectors_kb<br>
of [underlying max_hw_sectors_kb]. I&#39;m suspicious that it&#39;s some ot=
her<br>
setting that is going wonky... can you recheck whether max_sectors_kb<br>
is changing between (device under VDO) and (VDO device)?<br>
</blockquote></div>
</blockquote></div>

--000000000000454c46058747c3c2--


--===============8941258127222943567==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8941258127222943567==--
