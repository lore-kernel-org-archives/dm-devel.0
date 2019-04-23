From: Ryan Norwood <ryan.p.norwood@gmail.com>
Subject: Re: max_sectors_kb limitations with VDO and dm-thin
Date: Tue, 23 Apr 2019 13:02:38 -0400
Message-ID: <CAFTvtQ=JiZ7FWNiayM5bVY5A8ZCNbDtXV=rUxa_0u6Xm6rJAqg@mail.gmail.com>
References: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
	<45987177-c92c-d906-50bc-f4c789c36857@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1764848670685058691=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45987177-c92c-d906-50bc-f4c789c36857@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1764848670685058691==
Content-Type: multipart/alternative; boundary="0000000000000e04670587358e4d"

--0000000000000e04670587358e4d
Content-Type: text/plain; charset="UTF-8"

I have added vdo-devel to the converation:
https://www.redhat.com/archives/vdo-devel/2019-April/msg00017.html

Here is some more info to describe the specific issue:

A dm-thin volume is configured with a chunk/block size that determines the
minimum allocation size that it can track, between 64KiB and 1GiB. If an
application performs a write to a dm-thin block device, and that IO
operation completely overlaps a thin block, dm-thin will skip zeroing after
allocation before performing the write. This is a pretty big performance
optimization as it effectively halves IO for large sequential writes. When
a block device has a snapshot the data is referenced by both the original
block and the snapshot. If a write is issued dm-thin will  normally
allocate a new chunk, copy the old data to that new chunk, then perform the
write. If the new write completely overlaps a chunk it will skip the copy.

So for example dm-thin block device is created in a thin pool with a 512k
block size. A new block is created and an application performs a 4k
sequential write at the beginning of the volume. dm-thin will do the
following,

1) allocate 512k block
2) write 0's to the block
3) perform the 4k write

This does 516k of writes for a 4k write (ouch). If the write was at least
512k, it will skip zeroing and just do the write.

Similarly assume there is a dm-thin block device with a snapshot and data
is shared between the two. Again the application performs a 4k write.

1) allocate new 512k block
2) copy 512k form the old block to the new
3) perform the 4k write

This does 512k in reads and 516k in writes (big ouch). If the write was at
least 512k it will skip all the overhead.

Now fast forward to VDO. Normally the IO size is determined by the
max_sectors_kb setting in /sys/block/DEVICE/queue. This value is inherited
for stacked DM devices and can be modified by the user up to the hardware
limit max_hw_sectors_kb, which also appears to be inherited for stacked DM
devices. VDO sets this value to 4k which in turn forces all layers stacked
above it to also have a 4k maximum. If you take my previous example but
place VDO beneath the dm-thin volume, all IO sequential or otherwise will
be split down to 4k which will completely eliminate all the performance
optimizations that dm-thin provides.

1) Is this known behavior?
2) Is there a possible workaround?


On Tue, Apr 23, 2019 at 6:11 AM Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 19. 04. 19 v 16:40 Ryan Norwood napsal(a):
> > We have been using dm-thin layered above VDO and have noticed that our
> > performance is not optimal for large sequential writes as max_sectors_kb
> > and max_hw_sectors_kb for all thin devices are set to 4k due to the VDO
> layer
> > beneath.
> >
> > This effectively eliminates the performance optimizations for sequential
> > writes to skip both zeroing and COW overhead when a write fully overlaps
> a
> > thin chunk as all bios are split into 4k which always be less than the
> 64k
> > thin chunk minimum.
> >
> > Is this known behavior? Is there any way around this issue?
>
> Hi
>
> If you require highest performance - I'd suggest to avoid using VDO.
> VDO replaces performance with better space utilization.
> It works on 4KiB block - so by design it's going to be slow.
>
> I'd also probably not mix 2 provisioning technologies together - there
> is nontrivial amount of problematic states when the whole device stack
> runs out of real physical space.
>
> Regards
>
> Zdenek
>

--0000000000000e04670587358e4d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">I have added vdo-devel to the converation=
:=C2=A0<a href=3D"https://www.redhat.com/archives/vdo-devel/2019-April/msg0=
0017.html" target=3D"_blank">https://www.redhat.com/archives/vdo-devel/2019=
-April/msg00017.html</a></div><div dir=3D"ltr"><br></div><div dir=3D"ltr">H=
ere is some more info to describe the specific issue:</div><div dir=3D"ltr"=
><div><br></div><div><div>A dm-thin volume is configured with a chunk/block=
 size that determines the minimum allocation size that it can track, betwee=
n 64KiB and 1GiB. If an application performs a write to a dm-thin block dev=
ice, and that IO operation completely overlaps a thin block, dm-thin will s=
kip zeroing after allocation before performing the write. This is a pretty =
big performance optimization as it effectively halves IO for large sequenti=
al writes. When a block device has a snapshot the data is referenced by bot=
h the original block and the snapshot. If a write is issued dm-thin will=C2=
=A0 normally allocate a new chunk, copy the old data to that new chunk, the=
n perform the write. If the new write completely overlaps a chunk it will s=
kip the copy.</div><div><br></div><div>So for example dm-thin block device =
is created in a thin pool with a 512k block size. A new block is created an=
d an application performs a 4k sequential write at the beginning of the vol=
ume. dm-thin will do the following,=C2=A0</div><div><br></div><div>1) alloc=
ate 512k block</div><div>2) write 0&#39;s to the block</div><div>3) perform=
 the 4k write</div><div><br></div><div>This does 516k of writes for a 4k wr=
ite (ouch). If the write was at least 512k, it will skip zeroing and just d=
o the write.</div><div><br></div><div>Similarly assume there is a dm-thin b=
lock device with a snapshot and data is shared between the two. Again the a=
pplication performs a 4k write.</div><div><br></div><div>1) allocate new 51=
2k block</div><div>2) copy 512k form the old block to the new</div><div>3) =
perform the 4k write</div><div><br></div><div>This does 512k in reads and 5=
16k in writes (big ouch). If the write was at least 512k it will skip all t=
he overhead.</div><div><br></div><div>Now fast forward to VDO. Normally the=
 IO size is determined by the max_sectors_kb setting in /sys/block/DEVICE/q=
ueue. This value is inherited for stacked DM devices and can be modified by=
 the user up to the hardware limit max_hw_sectors_kb, which also appears to=
 be inherited for stacked DM devices. VDO sets this value to 4k which in tu=
rn forces all layers stacked above it to also have a 4k maximum. If you tak=
e my previous example but place VDO beneath the dm-thin volume, all IO sequ=
ential or otherwise will be split down to 4k which will completely eliminat=
e all the performance optimizations that dm-thin provides.</div><div><br></=
div><div>1) Is this known behavior?=C2=A0</div><div>2) Is there a possible =
workaround?</div></div><div class=3D"gmail-yj6qo gmail-ajU" style=3D"outlin=
e:none;padding:10px 0px;width:22px;margin:2px 0px 0px"><br class=3D"gmail-A=
pple-interchange-newline"></div></div></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Apr 23, 2019 at 6:11 AM Zdene=
k Kabelac &lt;<a href=3D"mailto:zkabelac@redhat.com">zkabelac@redhat.com</a=
>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Dne=
 19. 04. 19 v 16:40 Ryan Norwood napsal(a):<br>
&gt; We have been using dm-thin layered above VDO and have noticed that our=
 <br>
&gt; performance is not optimal for large sequential writes as max_sectors_=
kb <br>
&gt; and=C2=A0max_hw_sectors_kb=C2=A0for all thin devices are set to 4k due=
 to the VDO layer <br>
&gt; beneath.<br>
&gt; <br>
&gt; This effectively eliminates the performance optimizations for sequenti=
al <br>
&gt; writes to skip both zeroing and COW overhead when a write fully overla=
ps a <br>
&gt; thin chunk as all bios are split into 4k which always be less than the=
 64k <br>
&gt; thin chunk minimum.<br>
&gt; <br>
&gt; Is this known behavior? Is there any way around this issue?<br>
<br>
Hi<br>
<br>
If you require highest performance - I&#39;d suggest to avoid using VDO.<br=
>
VDO replaces performance with better space utilization.<br>
It works on 4KiB block - so by design it&#39;s going to be slow.<br>
<br>
I&#39;d also probably not mix 2 provisioning technologies together - there<=
br>
is nontrivial amount of problematic states when the whole device stack<br>
runs out of real physical space.<br>
<br>
Regards<br>
<br>
Zdenek<br>
</blockquote></div>

--0000000000000e04670587358e4d--


--===============1764848670685058691==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1764848670685058691==--
