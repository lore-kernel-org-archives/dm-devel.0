From: laurent cop <laurent.cop@gmail.com>
Subject: Re: LUKS2 - RAID0 - NVME : alignment issue
Date: Sun, 28 Oct 2018 01:05:09 +0200
Message-ID: <CAHzw6ok4YHzQ2_oxShAiaa0T_vX4OA2oXGifNTmAOyLHYwGKRg@mail.gmail.com>
References: <CAHzw6onNd8JskiB75PzFd4Zo45dP4fx3emoHFz8eTNkTV2+7+A@mail.gmail.com>
	<alpine.LRH.2.02.1810181342200.19328@file01.intranet.prod.int.rdu2.redhat.com>
	<2cd7ddd8-6c3c-e420-fd1f-44912f24ca66@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3718265481843422858=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2cd7ddd8-6c3c-e420-fd1f-44912f24ca66@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

--===============3718265481843422858==
Content-Type: multipart/alternative; boundary="00000000000059935e05793de0a2"

--00000000000059935e05793de0a2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you all for your advises.

Meanwhile, I have read  Practical Cryptographic Data Integrity Protection
with Full Disk Encryption Extended Version (1 jul 2018). Very interesting
publication. :-)

1) Performances seems pretty correct for linear access write 4k blocks NO
JOURNAL. Nevertheless, you don't indicate how you realise this test (cp,
dd, fio tool...?).

2) I will reconsider doing again my stack. (No datas on it) Have you any
advises related to fs, RAID0, luksformat (type luk2) creation?  Indeed, I
don't clearly understand this point :
*"dm-integrity interleaves data and metadata and consequently data are not
aligned on raid stripe boundary."*
According to what I inderstand this will kill my RAID0 main goal for
getting fast performance.

3) I want integrity features and I want to try the no journal option for
performance gain. How to use it  ?
cryptsetup -v luksFormat --type luks2 /dev/md127 --cipher aes-gcm-random
--integrity aead  *--integrity-no-journal*
4) I am not sure to understand the relation between sector size of each
layer of the stack as we introduce a layer (dif) with metadata under
dm-crypt layer and above storage devices. Does 4096 bytes must be choosen
for all layers?
*--sector-size <bytes>*Set sector size for use with disk encryption. It
must be power of two and in range 512 - 4096 bytes. The default is 512
bytes sectors. This option is available only in the LUKS2 mode. Note that
if sector size is higher than underlying device hardware sector and there
is not integrity protection that uses data journal, using this option can
increase risk on incomplete sector writes during a power fail. If used
together with *--integrity* option and dm-integrity journal, the atomicity
of writes is guaranteed in all cases (but it cost write performance - data
has to be written twice). Increasing sector size from 512 bytes to 4096
bytes can provide better performance on most of the modern storage devices
and also with some hw encryption accelerators
Thank you very much for explainations. Any links, articles, documents
answering to my interrogation are welcomed.(I have already read
https://manpages.debian.org/unstable/cryptsetup-bin/cryptsetup.8.en.html
and your publication)

I will try to make the stack again with --debug option.

King regards





Le ven. 19 oct. 2018 =C3=A0 08:47, Milan Broz <gmazyland@gmail.com> a =C3=
=A9crit :

> On 18/10/2018 19:51, Mikulas Patocka wrote:
> > On Fri, 12 Oct 2018, laurent cop wrote:
> >
> >> Hello,
> >>
> >> I have trouble while in top of the stack :
> >> mkfs.ext4 /dev/mapper/raid0luks2
> >> /dev/mapper/raid0luks2 alignement is offset by 147456 bytes
> >> This may result in very poor performance (re-) partitioning is
> suggested.
> >> I have the same pb with mkfs.xfs
> >
> > Just ignore this warning. dm-integrity interleaves data and metadata an=
d
> > consequently data are not aligned on raid stripe boundary.
> >
> >> I am using following scheme:
> >>
> >> LUKS2           =3D> created with cryptsetup -v luksFormat --type luks=
2
> /dev/md127 --cipher aes-gcm-random --integrity aeae
> >> RAID 0           =3D> created with mdadm chunk=3D32
> >> 3 Disks NVME =3D> partition with gdisk (fist sector : 2048)
> >>
> >> I got this information with lsblk -t for each 3 disks, i got the same
> information.
> >> nvmeXn1
> >>        -> NvmeXn1p1                                 ALIGN =3D 0
> >>                   -> md127                               ALIGN =3D 0
> >>                            -> raid0luks2_dif           ALIGN =3D 14745=
6
> >>                                        -> raid0luks2     ALIGN =3D 147=
456
> >> 1) How can I solve my alignment issue?
> >>
> >> 2) Is it normal to have low performances while writing with dd. I was
> >> using LUKS previously and I got only one dev mapper. Now I got 2. Does
> >> it have a big impact on performances?
> >>
> >> Kind regards.
> >
> > dm-integrity already slows down writes about 3 times. At this situation=
,
> > trying to align accesses to raid stripe size doesn't make much sense.
>
> Actually, I think that the alignment reported there does not make any
> sense for dm-integrity (here is not a simple offset, data and metadata ar=
e
> interleaved,
> there is a journal... Dm-integrity here behaves more like a filesystem -
> what a single
> offset means?
>
> Anyway, Mikulas disagrees with me to simple remove it :-)
>
> > If you want to improve performance, you may try to put two dm-ingerity
> > images directly on the SSDs and create raid-0 on the top of them. It ma=
y
> > perform better, but you'll have to benchmark it with the workload you
> are
> > optimizing for.
>
> You can do this with LUKS2 authenticated encryption as well, but I am not
> sure
> it is good idea - it will eat CPU time for encryption for each raid 0
> member.
>
> Milan
>

--00000000000059935e05793de0a2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div>Thank you=
 all for your advises. <br><br>Meanwhile, I have read=C2=A0 Practical Crypt=
ographic Data Integrity Protection with Full Disk Encryption Extended Versi=
on (1 jul 2018). Very interesting publication. :-)<br><br></div><div>1) Per=
formances seems pretty correct for linear access write 4k blocks NO JOURNAL=
. Nevertheless, you don&#39;t indicate how you realise this test (cp, dd, f=
io tool...?). <br><br></div><div>2) I will reconsider doing again my stack.=
 (No datas on it) Have you any advises related to fs, RAID0, luksformat (ty=
pe luk2) creation?=C2=A0 Indeed, I don&#39;t clearly understand this point =
:<br><i>&quot;dm-integrity interleaves data and metadata and consequently d=
ata are not aligned on raid stripe boundary.&quot;</i><br></div><div>Accord=
ing to what I inderstand this will kill my RAID0 main goal for getting fast=
 performance.<br></div><div><br></div><div>3) I want integrity features and=
 I want to try the no journal option for performance gain. How to use it=C2=
=A0 ?<br></div><div><span class=3D"gmail-im">cryptsetup -v luksFormat --typ=
e luks2 /dev/md127 --cipher aes-gcm-random --integrity aead=C2=A0 </span><i=
>--integrity-no-journal</i><span class=3D"gmail-im"></span></div><div><dl c=
lass=3D"gmail-Bl-tag"><dt>4) I am not sure to understand the relation betwe=
en sector size of each layer of the stack as we introduce a layer (dif) wit=
h metadata under dm-crypt layer and above storage devices. Does 4096 bytes =
must be choosen for all layers? <br></dt><dt><b>--sector-size &lt;bytes&gt;=
</b></dt><dd>Set sector size for use with disk encryption. It must be power=
 of two and
      in range 512 - 4096 bytes. The default is 512 bytes sectors. This opt=
ion
      is available only in the LUKS2 mode.
   =20
    Note that if sector size is higher than underlying device hardware sect=
or
      and there is not integrity protection that uses data journal, using t=
his
      option can increase risk on incomplete sector writes during a power f=
ail.
   =20
    If used together with <i>--integrity</i> option and dm-integrity journa=
l,
      the atomicity of writes is guaranteed in all cases (but it cost write
      performance - data has to be written twice).
   =20
    Increasing sector size from 512 bytes to 4096 bytes can provide better
      performance on most of the modern storage devices and also with some =
hw
      encryption accelerators</dd><dt><br></dt><dt>Thank you very much for =
explainations. Any links, articles, documents answering to my interrogation=
 are welcomed.(I have already read <a href=3D"https://manpages.debian.org/u=
nstable/cryptsetup-bin/cryptsetup.8.en.html">https://manpages.debian.org/un=
stable/cryptsetup-bin/cryptsetup.8.en.html</a> and your publication)<br></d=
t></dl><p>I will try to make the stack again with --debug option.</p><p>Kin=
g regards<br></p></div><div><br></div><div><br></div><div><br></div><br></d=
iv></div></div></div></div></div></div></div><br><div class=3D"gmail_quote"=
><div dir=3D"ltr">Le=C2=A0ven. 19 oct. 2018 =C3=A0=C2=A008:47, Milan Broz &=
lt;<a href=3D"mailto:gmazyland@gmail.com" target=3D"_blank">gmazyland@gmail=
.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On=
 18/10/2018 19:51, Mikulas Patocka wrote:<br>
&gt; On Fri, 12 Oct 2018, laurent cop wrote:<br>
&gt; <br>
&gt;&gt; Hello,<br>
&gt;&gt;<br>
&gt;&gt; I have trouble while in top of the stack :<br>
&gt;&gt; mkfs.ext4 /dev/mapper/raid0luks2<br>
&gt;&gt; /dev/mapper/raid0luks2 alignement is offset by 147456 bytes<br>
&gt;&gt; This may result in very poor performance (re-) partitioning is sug=
gested.<br>
&gt;&gt; I have the same pb with mkfs.xfs<br>
&gt; <br>
&gt; Just ignore this warning. dm-integrity interleaves data and metadata a=
nd <br>
&gt; consequently data are not aligned on raid stripe boundary.<br>
&gt; <br>
&gt;&gt; I am using following scheme:<br>
&gt;&gt;<br>
&gt;&gt; LUKS2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=3D&gt; created with cryptsetup -v luksFormat --type luks2 /dev/md127 --cip=
her aes-gcm-random --integrity aeae<br>
&gt;&gt; RAID 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D&gt; created with mdadm chunk=3D32<br>
&gt;&gt; 3 Disks NVME =3D&gt; partition with gdisk (fist sector : 2048)<br>
&gt;&gt;<br>
&gt;&gt; I got this information with lsblk -t for each 3 disks, i got the s=
ame information.<br>
&gt;&gt; nvmeXn1<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -&gt; NvmeXn1p1=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ALIGN =3D 0<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -&gt; md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ALIGN =3D 0<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 -&gt; raid0luks2_dif=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ALIGN =3D 147456<br>
&gt;&gt; =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 -&gt; raid0luks2=C2=A0=C2=A0=C2=A0=C2=A0 ALIGN =3D 147456<br>
&gt;&gt; 1) How can I solve my alignment issue?<br>
&gt;&gt;<br>
&gt;&gt; 2) Is it normal to have low performances while writing with dd. I =
was <br>
&gt;&gt; using LUKS previously and I got only one dev mapper. Now I got 2. =
Does <br>
&gt;&gt; it have a big impact on performances?<br>
&gt;&gt;<br>
&gt;&gt; Kind regards.<br>
&gt; <br>
&gt; dm-integrity already slows down writes about 3 times. At this situatio=
n, <br>
&gt; trying to align accesses to raid stripe size doesn&#39;t make much sen=
se.<br>
<br>
Actually, I think that the alignment reported there does not make any<br>
sense for dm-integrity (here is not a simple offset, data and metadata are =
interleaved,<br>
there is a journal... Dm-integrity here behaves more like a filesystem - wh=
at a single<br>
offset means?<br>
<br>
Anyway, Mikulas disagrees with me to simple remove it :-)<br>
<br>
&gt; If you want to improve performance, you may try to put two dm-ingerity=
 <br>
&gt; images directly on the SSDs and create raid-0 on the top of them. It m=
ay <br>
&gt; perform better, but you&#39;ll have to benchmark it with the workload =
you are <br>
&gt; optimizing for.<br>
<br>
You can do this with LUKS2 authenticated encryption as well, but I am not s=
ure<br>
it is good idea - it will eat CPU time for encryption for each raid 0 membe=
r.<br>
<br>
Milan<br>
</blockquote></div>

--00000000000059935e05793de0a2--


--===============3718265481843422858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3718265481843422858==--
