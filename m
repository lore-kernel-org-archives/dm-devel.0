From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: FW: Use-after-free while dm-verity
Date: Thu, 16 Aug 2018 03:57:53 +0300
Message-ID: <CAOtvUMd8qUm2A7DtQVSR_jZBM8Zihs6eBWshMbiTKJC0xU88vg@mail.gmail.com>
References: <CGME20180814083408epcms2p1980005414da7197755f798aa9ed47a4f@epcms2p6>
	<20180814083408epcms2p1980005414da7197755f798aa9ed47a4f@epcms2p1>
	<20180816003535epcms2p6bba40fd6423d0bb605b4dec3866f84c9@epcms2p6>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7827678895075788115=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180816003535epcms2p6bba40fd6423d0bb605b4dec3866f84c9@epcms2p6>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hyeon.chung@samsung.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, =?UTF-8?B?6rmA7Zi47ISx?= <hosung0.kim@samsung.com>
List-Id: dm-devel.ids

--===============7827678895075788115==
Content-Type: multipart/related; boundary="000000000000e900e3057382ee96"

--000000000000e900e3057382ee96
Content-Type: multipart/alternative; boundary="000000000000e900e1057382ee95"

--000000000000e900e1057382ee95
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hyeon,

On Thu, Aug 16, 2018 at 3:35 AM, =EC=A0=95=ED=98=9C=EC=97=B0 <hyeon.chung@s=
amsung.com> wrote:

> Hi,
>
>
>
> We found some async commit and are wondering if this could be make this
> issue or not.
>
> I want to test after reverting this but I'm not sure it is ok to revert
> only this commit and when I revert it there's a conflict.
>
>
> Could you please help me?
>

I am on vacation, so please excuse any delay in handling this. Luckily I
have my laptop with me and will try to do me best to help.

The description below relates to "use-after-free". I just want to make sure
I understand: does this relate to the memcpy after unmap, right?

Normally, I would say that since we use kmap_atomic to map the data,
preemption should be disabled and scheduling should not happen, I believe.

I will only be able to take a look at the code in the evening, but in the
mean time, can you verify the area the memcpy is applied to is mapped with
kmap_atomic?

thanks!
Gilad


>
> commit d1ac3ff008fb9a48f91fc15920b4c8db24c0f03e
> Author: Gilad Ben-Yossef <gilad@benyossef.com>
> Date:   Sun Feb 19 14:46:07 2017 +0200
>
>     dm verity: switch to using asynchronous hash crypto API
>
>     Use of the synchronous digest API limits dm-verity to using pure
>     CPU based algorithm providers and rules out the use of off CPU
>     algorithm providers which are normally asynchronous by nature,
>     potentially freeing CPU cycles.
>
>     This can reduce performance per Watt in situations such as during
>     boot time when a lot of concurrent file accesses are made to the
>     protected volume.
>
>     Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>     CC: Eric Biggers <ebiggers3@gmail.com>
>     CC: Ondrej Mosn=EC=B0=BC=ED=9B=BEek <omosnacek+linux-crypto@gmail.com=
>
>     Tested-by: Milan Broz <gmazyland@gmail.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>
>
>
>
>
> =EA=B0=90=EC=82=AC=ED=95=A9=EB=8B=88=EB=8B=A4.
>
> =EC=A0=95=ED=98=9C=EC=97=B0 =EB=93=9C=EB=A6=BC
>
>
>
>
>
> --------- *Original Message* ---------
>
> *Sender* : =EC=A0=95=ED=98=9C=EC=97=B0 <hyeon.chung@samsung.com> Principa=
l
> Engineer/Platform=EA=B0=9C=EB=B0=9C=ED=8C=80(S.LSI)/=EC=82=BC=EC=84=B1=EC=
=A0=84=EC=9E=90
>
> *Date* : 2018-08-14 17:34 (GMT+9)
>
> *Title* : Use-after-free while dm-verity
>
>
>
> Hi,
>
> I'm a samsung engineer who is responsible for dm-verity.
>
>
>
> We just enabled dm-verity for android verfied boot 2.0 (using linux
> 4.14.56).
>
> After enabling, we met kernel panic issue caused by dm-verity frequently
> and it always showed same call stack like below.
>
>
>
> Could you please let me know If you know any similar issue or have any
> opinion?
>
> If this mail list is not right, please forward proper person or let me
> know.
>
>
>
> Thanks in advance.
>
>
>
> < 4>[ 4686.384679]  [5:  kworker/u16:1:   58] Workqueue: kverityd
> verity_work
> < 4>[ 4686.384691]  [5:  kworker/u16:1:   58] task: ffffffc8742a0080
> task.stack: ffffff800b1d8000
> < 4>[ 4686.384705]  [5:  kworker/u16:1:   58] PC is at __memcpy+0x70/0x18=
0
> < 4>[ 4686.384718]  [5:  kworker/u16:1:   58] LR is at
> crypto_sha1_update+0x94/0xe4
>
> ...
>
> <4>[ 4686.387488]  [5:  kworker/u16:1:   58] [<ffffff8008b07370>]
> __memcpy+0x70/0x180
> < 4>[ 4686.387503]  [5:  kworker/u16:1:   58] [<ffffff80083a0f6c>]
> crypto_shash_update+0x2c/0x34
> < 4>[ 4686.387514]  [5:  kworker/u16:1:   58] [<ffffff80083a12c0>]
> shash_ahash_update+0x3c/0x80
> < 4>[ 4686.387525]  [5:  kworker/u16:1:   58] [<ffffff80083a1638>]
> shash_async_update+0x10/0x18
> < 4>[ 4686.387538]  [5:  kworker/u16:1:   58] [<ffffff8008824974>]
> verity_hash_update+0x50/0xdc
> < 4>[ 4686.387549]  [5:  kworker/u16:1:   58] [<ffffff80088247c0>]
> verity_hash+0x58/0xa0
> < 4>[ 4686.387560]  [5:  kworker/u16:1:   58] [<ffffff8008824c98>]
> verity_verify_level+0xc4/0x190
> < 4>[ 4686.387571]  [5:  kworker/u16:1:   58] [<ffffff8008824bc4>]
> verity_hash_for_block+0xf0/0x100
> < 4>[ 4686.387581]  [5:  kworker/u16:1:   58] [<ffffff80088244c8>]
> fec_read_bufs+0x144/0x30c
> < 4>[ 4686.387592]  [5:  kworker/u16:1:   58] [<ffffff8008823730>]
> fec_decode_rsb+0x170/0x4bc
> < 4>[ 4686.387603]  [5:  kworker/u16:1:   58] [<ffffff8008823524>]
> verity_fec_decode+0xe8/0x184
> < 4>[ 4686.387613]  [5:  kworker/u16:1:   58] [<ffffff8008824d38>]
> verity_verify_level+0x164/0x190
> < 4>[ 4686.387623]  [5:  kworker/u16:1:   58] [<ffffff8008824bc4>]
> verity_hash_for_block+0xf0/0x100
> < 4>[ 4686.387634]  [5:  kworker/u16:1:   58] [<ffffff80088264cc>]
> verity_work+0xf8/0x308
> < 4>[ 4686.387646]  [5:  kworker/u16:1:   58] [<ffffff80080cb5ec>]
> process_one_work+0x2d4/0x608
> < 4>[ 4686.387656]  [5:  kworker/u16:1:   58] [<ffffff80080cbbf4>]
> worker_thread+0x220/0x340
> < 4>[ 4686.387667]  [5:  kworker/u16:1:   58] [<ffffff80080d0498>]
> kthread+0x11c/0x12c
> < 4>[ 4686.387678]  [5:  kworker/u16:1:   58] [<ffffff800808557c>]
> ret_from_fork+0x10/0x18
> < 0>[ 4686.387690]  [5:  kworker/u16:1:   58] Code: 54000080 540000ab
> a8c12027 a88120c7 (a8c12027)
> < 4>[ 4686.387839]  [5:  kworker/u16:1:   58] ---[ end trace
> 54664349b0f9422c ]---
>
>
>
>
>
> In memcopy function,
>
> load x1 register successfully then context switched by scheduler.
>
> After returning to same memcopy function, failed another x1 load becuase
> this is unmapped.(walk->data)
>
> <1>[  889.732488]  [2:  kworker/u16:3:15332] Unable to handle kernel
> paging request at virtual address ffffffc00b6ad000
>
>
>
> I suspect that this is not protected propely becuase callstack and proble=
m
> (walk->data: use-after-free) is alwasys same.
>
> 1. shrink_node is executed on onther core at that time. Is it
> possible this make this problem?
>
> 2. I found that walk->data is unmapped by ahahs.c but I don't know whethe=
r
> this cause this unmapped situation or not.
>
> if (walk->flags & CRYPTO_ALG_ASYNC)
>     kunmap(walk->pg);
> else
>     kunmap_atomic(walk->data);
>
>
>
>
>
> Best Regards,
>
> HyeYeon Chung
>
>
>
>
>
>
>



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

--000000000000e900e1057382ee95
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Hyeon,<br><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Thu, Aug 16, 2018 at 3:35 AM, =EC=A0=95=ED=98=9C=EC=97=B0 <=
span dir=3D"ltr">&lt;<a href=3D"mailto:hyeon.chung@samsung.com" target=3D"_=
blank">hyeon.chung@samsung.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">









<div style=3D"OVERFLOW:auto">
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">Hi,</span></p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95"></span>=C2=A0</p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">We found some async commit and are wondering if this could be make =
this issue or not.</span></p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">I want to test after reverting this but I&#39;m not sure <span styl=
e=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=94=95">it is=
 ok to revert only this commit and=C2=A0<span style=3D"FONT-SIZE:9pt;FONT-F=
AMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=94=95">when I revert it there&#39;s a=
 conflict.</span></span></span></p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">
</span></p><p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =
=EA=B3=A0=EB=94=95"></span>=C2=A0</p><span style=3D"FONT-SIZE:9pt;FONT-FAMI=
LY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=94=95">Could you please=C2=A0help me?</s=
pan></div></blockquote><div><br></div><div>I am on vacation, so please excu=
se any delay in handling this. Luckily I have my laptop with me and will tr=
y to do me best to help.</div><div>=C2=A0</div><div>The description below r=
elates to &quot;use-after-free&quot;. I just want to make sure I understand=
: does this relate to the memcpy after unmap, right?</div><div><br></div><d=
iv>Normally, I would say that since we use kmap_atomic to map the data, pre=
emption should be disabled and scheduling should not happen, I believe.</di=
v><div><br></div><div>I will only be able to take a look at the code in the=
 evening, but in the mean time, can you verify the area the memcpy is appli=
ed to is mapped with kmap_atomic?</div><div><br></div><div>thanks!</div><di=
v>Gilad</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div style=3D"OV=
ERFLOW:auto"><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =
=EA=B3=A0=EB=94=95">=20
<p>
</p><p>=C2=A0</p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">commit d1ac3ff008fb9a48f91fc15920b4c8<wbr>db24c0f03e<br>Author: Gil=
ad Ben-Yossef &lt;<a href=3D"mailto:gilad@benyossef.com" target=3D"_blank">=
gilad@benyossef.com</a>&gt;<br>Date:=C2=A0=C2=A0 Sun Feb 19 14:46:07 2017 +=
0200</span></p><p></p></span><p></p>
<p></p>
<p></p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">=C2=A0=C2=A0=C2=A0 dm verity: switch to using asynchronous hash cry=
pto API<br>=C2=A0=C2=A0=C2=A0 <br>=C2=A0=C2=A0=C2=A0 Use of the synchronous=
 digest API limits dm-verity to using pure<br>=C2=A0=C2=A0=C2=A0 CPU based =
algorithm providers and rules out the use of off CPU<br>=C2=A0=C2=A0=C2=A0 =
algorithm providers which are normally asynchronous by nature,<br>=C2=A0=C2=
=A0=C2=A0 potentially freeing CPU cycles.<br>=C2=A0=C2=A0=C2=A0 <br>=C2=A0=
=C2=A0=C2=A0 This can reduce performance per Watt in situations such as dur=
ing<br>=C2=A0=C2=A0=C2=A0 boot time when a lot of concurrent file accesses =
are made to the<br>=C2=A0=C2=A0=C2=A0 protected volume.<br>=C2=A0=C2=A0=C2=
=A0 <br>=C2=A0=C2=A0=C2=A0 Signed-off-by: Gilad Ben-Yossef &lt;<a href=3D"m=
ailto:gilad@benyossef.com" target=3D"_blank">gilad@benyossef.com</a>&gt;<br=
>=C2=A0=C2=A0=C2=A0 CC: Eric Biggers &lt;<a href=3D"mailto:ebiggers3@gmail.=
com" target=3D"_blank">ebiggers3@gmail.com</a>&gt;<br>=C2=A0=C2=A0=C2=A0 CC=
: Ondrej Mosn=EC=B0=BC=ED=9B=BEek &lt;<a href=3D"mailto:omosnacek+linux-cry=
pto@gmail.com" target=3D"_blank">omosnacek+linux-crypto@gmail.<wbr>com</a>&=
gt;<br>=C2=A0=C2=A0=C2=A0 Tested-by: Milan Broz &lt;<a href=3D"mailto:gmazy=
land@gmail.com" target=3D"_blank">gmazyland@gmail.com</a>&gt;<br>=C2=A0=C2=
=A0=C2=A0 Signed-off-by: Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.=
com" target=3D"_blank">snitzer@redhat.com</a>&gt;</span></p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95"></span>=C2=A0</p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95"></span>=C2=A0</p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">=EA=B0=90=EC=82=AC=ED=95=A9=EB=8B=88=EB=8B=A4.</span></p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95">=EC=A0=95=ED=98=9C=EC=97=B0 =EB=93=9C=EB=A6=BC</span></p>
<p>=C2=A0</p>
<p>=C2=A0</p>
<p>--------- <b>Original Message</b> ---------</p>
<p><b>Sender</b> : =EC=A0=95=ED=98=9C=EC=97=B0=C2=A0&lt;<a href=3D"mailto:h=
yeon.chung@samsung.com" target=3D"_blank">hyeon.chung@samsung.com</a>&gt;=
=C2=A0<wbr>Principal Engineer/Platform=EA=B0=9C=EB=B0=9C=ED=8C=80(S.LSI)/<w=
br>=EC=82=BC=EC=84=B1=EC=A0=84=EC=9E=90</p>
<p><b>Date</b> : 2018-08-14 17:34 (GMT+9)</p>
<p><b>Title</b> : Use-after-free while dm-verity</p>
<p>=C2=A0</p>
<p>Hi, </p>
<p>I&#39;m a samsung engineer who is responsible for dm-verity.</p>
<p>=C2=A0</p>
<p>We=C2=A0just=C2=A0enabled dm-verity for android verfied boot 2.0=C2=A0(u=
sing linux 4.14.56).</p>
<p>After enabling, we met kernel panic issue caused by dm-verity frequently=
 and it always showed same call stack like below.</p>
<p>=C2=A0</p>
<p>Could you=C2=A0please let me know If you know any similar issue or have =
any opinion?</p>
<p>If this mail list is not right, please forward proper person or let me k=
now.</p>
<p>=C2=A0</p>
<p>Thanks in advance.</p>
<p>=C2=A0</p>
<p><span style=3D"FONT-SIZE:9pt;FONT-FAMILY:=EB=A7=91=EC=9D=80 =EA=B3=A0=EB=
=94=95"><font face=3D"Courier New">&lt; 4&gt;[ 4686.384679]=C2=A0 [5:=C2=A0=
 kworker/u16:1:=C2=A0=C2=A0 58] </font><span style=3D"FONT-FAMILY:&quot;Cou=
rier New&quot;;COLOR:rgb(0,0,255)">Workqueue: kverityd verity_work</span><s=
pan style=3D"FONT-FAMILY:&quot;Courier New&quot;"><br>&lt; 4&gt;[ 4686.3846=
91]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] task: ffffffc8742a0080 t=
ask.stack: ffffff800b1d8000<br>&lt; 4&gt;[ 4686.384705]=C2=A0 [5:=C2=A0 kwo=
rker/u16:1:=C2=A0=C2=A0 58] PC is at __memcpy+0x70/0x180<br>&lt; 4&gt;[ 468=
6.384718]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] LR is at crypto_sh=
a1_update+0x94/0xe4</span></span></p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">...</span></p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">&lt;4&gt;[ 4686.3874=
88]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff8008b07370&gt=
;] __memcpy+0x70/0x180<br>&lt; 4&gt;[ 4686.387503]=C2=A0 [5:=C2=A0 kworker/=
u16:1:=C2=A0=C2=A0 58] [&lt;ffffff80083a0f6c&gt;] crypto_shash_update+0x2c/=
0x34<br>&lt; 4&gt;[ 4686.387514]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0=
 58] [&lt;ffffff80083a12c0&gt;] shash_ahash_update+0x3c/0x80<br>&lt; 4&gt;[=
 4686.387525]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff800=
83a1638&gt;] shash_async_update+0x10/0x18<br>&lt; 4&gt;[ 4686.387538]=C2=A0=
 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff8008824974&gt;] verity=
_hash_update+0x50/0xdc<br>&lt; 4&gt;[ 4686.387549]=C2=A0 [5:=C2=A0 kworker/=
u16:1:=C2=A0=C2=A0 58] [&lt;ffffff80088247c0&gt;] verity_hash+0x58/0xa0<br>=
&lt; 4&gt;[ 4686.387560]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&l=
t;ffffff8008824c98&gt;] verity_verify_level+0xc4/0x190<br>&lt; 4&gt;[ 4686.=
387571]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff8008824bc=
4&gt;] verity_hash_for_block+0xf0/<wbr>0x100<br>&lt; 4&gt;[ 4686.387581]=C2=
=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff80088244c8&gt;] fec=
_read_bufs+0x144/0x30c<br>&lt; 4&gt;[ 4686.387592]=C2=A0 [5:=C2=A0 kworker/=
u16:1:=C2=A0=C2=A0 58] [&lt;ffffff8008823730&gt;] fec_decode_rsb+0x170/0x4b=
c<br>&lt; 4&gt;[ 4686.387603]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58=
] [&lt;ffffff8008823524&gt;] verity_fec_decode+0xe8/0x184<br>&lt; 4&gt;[ 46=
86.387613]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff800882=
4d38&gt;] verity_verify_level+0x164/<wbr>0x190<br>&lt; 4&gt;[ 4686.387623]=
=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff8008824bc4&gt;] =
verity_hash_for_block+0xf0/<wbr>0x100<br>&lt; 4&gt;[ 4686.387634]=C2=A0 [5:=
=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff80088264cc&gt;] verity_wor=
k+0xf8/0x308<br>&lt; 4&gt;[ 4686.387646]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=
=A0=C2=A0 58] [&lt;ffffff80080cb5ec&gt;] process_one_work+0x2d4/0x608<br>&l=
t; 4&gt;[ 4686.387656]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;=
ffffff80080cbbf4&gt;] worker_thread+0x220/0x340<br>&lt; 4&gt;[ 4686.387667]=
=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] [&lt;ffffff80080d0498&gt;] =
kthread+0x11c/0x12c<br>&lt; 4&gt;[ 4686.387678]=C2=A0 [5:=C2=A0 kworker/u16=
:1:=C2=A0=C2=A0 58] [&lt;ffffff800808557c&gt;] ret_from_fork+0x10/0x18<br>&=
lt; 0&gt;[ 4686.387690]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] Code=
: 54000080 540000ab a8c12027 a88120c7 (a8c12027)<br>&lt; 4&gt;[ 4686.387839=
]=C2=A0 [5:=C2=A0 kworker/u16:1:=C2=A0=C2=A0 58] ---[ end trace 54664349b0f=
9422c ]---</span></p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;"></span>=C2=A0</p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;"></span>=C2=A0</p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">In memcopy function,=
</span></p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">load x1 register suc=
cessfully then=C2=A0context switched by scheduler.</span></p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">After returning to s=
ame memcopy function, failed another x1 load becuase this is unmapped.(walk=
-&gt;data)</span></p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;"><span style=3D"COLOR=
:rgb(255,0,0)">&lt;1&gt;[=C2=A0 889.732488]=C2=A0 [2:=C2=A0 kworker/u16:3:1=
5332] Unable to handle kernel paging request at virtual address ffffffc00b6=
ad000</span></span></p>
<p>=C2=A0</p>
<p><span style=3D"COLOR:#0000ff">I suspect that this is not protected prope=
ly becuase callstack and problem (walk-&gt;data: use-after-free)=C2=A0is al=
wasys same.</span></p>
<p><span style=3D"COLOR:#0000ff">1.=C2=A0shrink_node is executed on onther =
core at that time. Is it possible=C2=A0this=C2=A0make this problem?</span><=
/p>
<p><span style=3D"COLOR:#0000ff">2. I found that walk-&gt;data is unmapped =
by ahahs.c but I don&#39;t know whether this cause this unmapped situation =
or not.</span></p>
<p>if (walk-&gt;flags &amp; CRYPTO_ALG_ASYNC)<br>=C2=A0=C2=A0=C2=A0=C2=A0ku=
nmap(walk-&gt;pg);<br>else<br>=C2=A0=C2=A0=C2=A0=C2=A0kunmap_atomic(walk-&g=
t;data); </p>
<p>=C2=A0</p>
<p>=C2=A0</p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">Best Regards,</span>=
</p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;">HyeYeon Chung</span>=
</p>
<p><span style=3D"FONT-FAMILY:&quot;Courier New&quot;"></span>=C2=A0</p>

<table id=3D"m_-1303007912768233539bannersignimg"><tbody><tr><td><p>=C2=A0<=
/p>
</td></tr></tbody></table><table id=3D"m_-1303007912768233539confidentialsi=
gnimg"><tbody><tr><td><p><img style=3D"border:0px solid currentColor;width:=
520px;height:144px;display:inline-block" src=3D"cid:cafe_image_0@s-core.co.=
kr">=C2=A0</p>
</td></tr></tbody></table></div><img src=3D"http://ext.samsung.net/mail/ext=
/v1/external/status/update?userid=3Dhyeon.chung&amp;do=3DbWFpbElEPTIwMTgwOD=
E2MDAzNTM1ZXBjbXMycDZiYmE0MGZkNjQyM2QwYmI2MDViNGRlYzM4NjZmODRjOSZyZWNpcGllb=
nRBZGRyZXNzPWdpbGFkQGJlbnlvc3NlZi5jb20_" border=3D"0" width=3D"0" height=3D=
"0" style=3D"display:none"></blockquote></div><br><br clear=3D"all"><div><b=
r></div>-- <br><div class=3D"gmail_signature" data-smartmail=3D"gmail_signa=
ture"><div dir=3D"ltr"><div>Gilad Ben-Yossef<br>Chief Coffee Drinker<br><br=
>values of =CE=B2 will give rise to dom!<br></div></div></div>
</div></div>

--000000000000e900e1057382ee95--

--000000000000e900e3057382ee96
Content-Type: image/gif
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-ID: <cafe_image_0@s-core.co.kr>
X-Attachment-Id: 88ec640348ea08f6_0.1

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
fqAGBgQAOw==
--000000000000e900e3057382ee96--


--===============7827678895075788115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7827678895075788115==--
