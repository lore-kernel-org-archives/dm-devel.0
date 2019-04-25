From: Ryan Norwood <ryan.p.norwood@gmail.com>
Subject: Re: max_sectors_kb limitations with VDO and dm-thin
Date: Thu, 25 Apr 2019 07:58:25 -0400
Message-ID: <CAFTvtQmJ--4nqJNfq2dOs=fHOs42Mv=31DGkbk+rx3GDAmaYpw@mail.gmail.com>
References: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
	<45987177-c92c-d906-50bc-f4c789c36857@redhat.com>
	<CAFTvtQ=JiZ7FWNiayM5bVY5A8ZCNbDtXV=rUxa_0u6Xm6rJAqg@mail.gmail.com>
	<CAMeeMh-v+xpn2YDizFQg4cKHZgC=aCdJwLfAMeGLGT1gB1ZURw@mail.gmail.com>
	<CAFTvtQnLDU_MKzse5t4xc_CVWENsZtwQQSTAFyj-45tPg5STZQ@mail.gmail.com>
	<CAFTvtQnALzibyS3jKisXRb+XGe8dopQfkj33=gtJAjd2+XymYQ@mail.gmail.com>
	<20190424212751.GC14367@redhat.com> <20190424222240.GA14922@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4594088186173510455=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190424222240.GA14922@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: vdo-devel@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4594088186173510455==
Content-Type: multipart/alternative; boundary="000000000000bfb17505875989cb"

--000000000000bfb17505875989cb
Content-Type: text/plain; charset="UTF-8"

Great, I will do that. Thank you for all your help!

On Wed, Apr 24, 2019 at 6:22 PM Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Apr 24 2019 at  5:27pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
> >
> > On Wed, Apr 24 2019 at 10:46am -0400,
> > Ryan Norwood <ryan.p.norwood@gmail.com> wrote:
> >
> > >    On Wed, Apr 24, 2019 at 9:08 AM Ryan Norwood <[1]
> ryan.p.norwood@gmail.com>
> > >    wrote:
> > >
> > >      Thank you for your help.
> > >      You are correct, it appears that the problem occurs when there is
> a RAID
> > >      5 or RAID 50 volume beneath VDO.
> > >      NAME      KNAME    RA   SIZE ALIGNMENT  MIN-IO  OPT-IO PHY-SEC
> LOG-SEC
> > >      RQ-SIZE SCHED    WSAME
> > >      sdh
> > >       sdh     128 977.5G         0     512       0     512     512
>  128
> > >      deadline    0B
> > >      +-sed6
> > >      dm-6    128 977.5G         0     512       0     512     512
>  128
> > >               0B
> > >        +-md127
> > >       md127 12288   5.7T         0 1048576 6291456     512     512
>  128
> > >               0B
> > >          +-vdo_data
> > >      dm-17   128   5.7T         0 1048576 6291456     512     512
>  128
> > >               0B
> > >            +-vdo
> > >       dm-18   128  57.3T         0    4096    4096    4096    4096
>  128
> > >               0B
>
> <snip>
>
> > >      /sys/block/dm-18/queue/max_hw_sectors_kb:4
> > >      /sys/block/dm-18/queue/max_sectors_kb:4
>
> These are getting set as a side-effect of MD raid imposing the need for
> merge_bvec (in the context of RHEL7.x only, not upstream) otherwise it
> goes conservative and forces the IO to be contrained to a single page,
> please see:
>
> drivers/md/dm-table.c:dm_set_device_limits() at the end:
>
>         /*
>          * Check if merge fn is supported.
>          * If not we'll force DM to use PAGE_SIZE or
>          * smaller I/O, just to be safe.
>          */
>         if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
>                 blk_limits_max_hw_sectors(limits,
>                                           (unsigned int) (PAGE_SIZE >> 9));
>
> With MD raid in the IO stack, dm_queue_merge_is_compulsory() will return
> true, so the VDO target not providing ti->type->merge causes this issue.
>
> Please file a BZ at bugzilla.redhat.com against VDO and I'll continue to
> work with the VDO developers to get this fixed for you for RHEL7.5, etc.
>
> Thanks,
> Mike
>

--000000000000bfb17505875989cb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Great, I will do that. Thank you for all your help!</div><=
br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Wed,=
 Apr 24, 2019 at 6:22 PM Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.=
com">snitzer@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">On Wed, Apr 24 2019 at=C2=A0 5:27pm -0400,<br>
Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com" target=3D"_blank">sn=
itzer@redhat.com</a>&gt; wrote:<br>
<br>
&gt; <br>
&gt; On Wed, Apr 24 2019 at 10:46am -0400,<br>
&gt; Ryan Norwood &lt;<a href=3D"mailto:ryan.p.norwood@gmail.com" target=3D=
"_blank">ryan.p.norwood@gmail.com</a>&gt; wrote:<br>
&gt; <br>
&gt; &gt;=C2=A0 =C2=A0 On Wed, Apr 24, 2019 at 9:08 AM Ryan Norwood &lt;[1]=
<a href=3D"mailto:ryan.p.norwood@gmail.com" target=3D"_blank">ryan.p.norwoo=
d@gmail.com</a>&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 wrote:<br>
&gt; &gt; <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 Thank you for your help.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 You are correct, it appears that the problem =
occurs when there is a RAID<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 5 or RAID 50 volume beneath VDO.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 NAME=C2=A0 =C2=A0 =C2=A0 KNAME=C2=A0 =C2=A0 R=
A=C2=A0 =C2=A0SIZE ALIGNMENT=C2=A0 MIN-IO=C2=A0 OPT-IO PHY-SEC LOG-SEC<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 RQ-SIZE SCHED=C2=A0 =C2=A0 WSAME<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 sdh<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0sdh=C2=A0 =C2=A0 =C2=A0128 977.5G=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0 =
=C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A012=
8<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 deadline=C2=A0 =C2=A0 0B<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 +-sed6<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 dm-6=C2=A0 =C2=A0 128 977.5G=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0=
 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 +-md127<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0md127 12288=C2=A0 =C2=A05.7T=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 1048576 6291456=C2=A0 =C2=A0 =C2=A0512=C2=A0 =C2=
=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 +-vdo_data<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 dm-17=C2=A0 =C2=A0128=C2=A0 =C2=A05.7T=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 1048576 6291456=C2=A0 =C2=A0 =C2=A0512=C2=A0 =
=C2=A0 =C2=A0512=C2=A0 =C2=A0 =C2=A0128<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 +-vdo<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dm-18=C2=A0 =C2=A0128=C2=A0 57.3T=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 4096=C2=A0 =C2=
=A0 4096=C2=A0 =C2=A0 4096=C2=A0 =C2=A0 =C2=A0128<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00B<br>
<br>
&lt;snip&gt;<br>
<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 /sys/block/dm-18/queue/max_hw_sectors_kb:4<br=
>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 /sys/block/dm-18/queue/max_sectors_kb:4<br>
<br>
These are getting set as a side-effect of MD raid imposing the need for<br>
merge_bvec (in the context of RHEL7.x only, not upstream) otherwise it<br>
goes conservative and forces the IO to be contrained to a single page,<br>
please see:<br>
<br>
drivers/md/dm-table.c:dm_set_device_limits() at the end:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Check if merge fn is supported.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If not we&#39;ll force DM to use PAGE_S=
IZE or<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* smaller I/O, just to be safe.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_queue_merge_is_compulsory(q) &amp;&amp; =
!ti-&gt;type-&gt;merge)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 blk_limits_max_hw_s=
ectors(limits,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (=
unsigned int) (PAGE_SIZE &gt;&gt; 9));<br>
<br>
With MD raid in the IO stack, dm_queue_merge_is_compulsory() will return<br=
>
true, so the VDO target not providing ti-&gt;type-&gt;merge causes this iss=
ue.<br>
<br>
Please file a BZ at <a href=3D"http://bugzilla.redhat.com" rel=3D"noreferre=
r" target=3D"_blank">bugzilla.redhat.com</a> against VDO and I&#39;ll conti=
nue to<br>
work with the VDO developers to get this fixed for you for RHEL7.5, etc.<br=
>
<br>
Thanks,<br>
Mike<br>
</blockquote></div>

--000000000000bfb17505875989cb--


--===============4594088186173510455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4594088186173510455==--
