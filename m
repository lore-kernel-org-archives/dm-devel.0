From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [for-4.16 PATCH v6 0/3] blk-mq: improve DM's blk-mq
 IO merging via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 19:12:38 -0500
Message-ID: <CAFfF4qv0FiKqTta3fKWJE6xWT4LA9Gd5AiVtTVAQ4JgkQ4sohw@mail.gmail.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
	<45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
	<20180117165832.GA5573@redhat.com> <1516231868.2820.84.camel@wdc.com>
	<1516232589.3805.2.camel@redhat.com>
	<1516233206.2820.103.camel@wdc.com>
	<1516233471.3805.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8606136465819215349=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1516233471.3805.4.camel@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

--===============8606136465819215349==
Content-Type: multipart/alternative; boundary="001a1140642a58a48b056301d22b"

--001a1140642a58a48b056301d22b
Content-Type: text/plain; charset="UTF-8"

Grabbing Mikes latest combined tree and testing it now

Thanks
Laurence

On Wed, Jan 17, 2018 at 6:57 PM, Laurence Oberman <loberman@redhat.com>
wrote:

> On Wed, 2018-01-17 at 23:53 +0000, Bart Van Assche wrote:
> > On Wed, 2018-01-17 at 18:43 -0500, Laurence Oberman wrote:
> > > On Wed, 2018-01-17 at 23:31 +0000, Bart Van Assche wrote:
> > > > On Wed, 2018-01-17 at 11:58 -0500, Mike Snitzer wrote:
> > > > > On Wed, Jan 17 2018 at 11:50am -0500,
> > > > > Jens Axboe <axboe@kernel.dk> wrote:
> > > > >
> > > > > > On 1/17/18 9:25 AM, Mike Snitzer wrote:
> > > > > > > Hi Jens,
> > > > > > >
> > > > > > > Think this finally takes care of it! ;)
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Mike
> > > > > > >
> > > > > > > Mike Snitzer (2):
> > > > > > >   blk-mq: factor out a few helpers from
> > > > > > > __blk_mq_try_issue_directly
> > > > > > >   blk-mq-sched: remove unused 'can_block' arg from
> > > > > > > blk_mq_sched_insert_request
> > > > > > >
> > > > > > > Ming Lei (1):
> > > > > > >   blk-mq: improve DM's blk-mq IO merging via
> > > > > > > blk_insert_cloned_request feedback
> > > > > >
> > > > > > Applied - added actual commit message to patch 3.
> > > > >
> > > > > Great, thanks.
> > > >
> > > > Hello Mike,
> > > >
> > > > Laurence hit the following while retesting the SRP initiator
> > > > code:
> > > >
> > > > [ 2223.797129] list_add corruption. prev->next should be next
> > > > (00000000e0ddd5dd), but was 000000003defe5cd.
> > > > (prev=000000003defe5cd).
> > > > [ 2223.862168] WARNING: CPU: 14 PID: 577 at lib/list_debug.c:28
> > > > __list_add_valid+0x6a/0x70
> > > > [ 2224.481151] CPU: 14 PID: 577 Comm: kworker/14:1H Tainted:
> > > > G          I      4.15.0-rc8.bart3+ #1
> > > > [ 2224.531193] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > > > 08/16/2015
> > > > [ 2224.567150] Workqueue: kblockd blk_mq_run_work_fn
> > > > [ 2224.593182] RIP: 0010:__list_add_valid+0x6a/0x70
> > > > [ 2224.967002] Call Trace:
> > > > [ 2224.980941]  blk_mq_request_bypass_insert+0x57/0xa0
> > > > [ 2225.009044]  __blk_mq_try_issue_directly+0x56/0x1e0
> > > > [ 2225.037007]  blk_mq_request_direct_issue+0x5d/0xc0
> > > > [ 2225.090608]  map_request+0x142/0x260 [dm_mod]
> > > > [ 2225.114756]  dm_mq_queue_rq+0xa4/0x120 [dm_mod]
> > > > [ 2225.140812]  blk_mq_dispatch_rq_list+0x90/0x5b0
> > > > [ 2225.211769]  blk_mq_sched_dispatch_requests+0x107/0x1a0
> > > > [ 2225.240825]  __blk_mq_run_hw_queue+0x5f/0xf0
> > > > [ 2225.264852]  process_one_work+0x141/0x340
> > > > [ 2225.287872]  worker_thread+0x47/0x3e0
> > > > [ 2225.308354]  kthread+0xf5/0x130
> > > > [ 2225.396405]  ret_from_fork+0x32/0x40
> > > >
> > > > That call trace did not show up before this patch series was
> > > > added to
> > > > Jens'
> > > > tree. This is a regression. Could this have been introduced by
> > > > this
> > > > patch
> > > > series?
> > > >
> > > > Thanks,
> > > >
> > > > Bart.
> > >
> > > Hi Bart
> > > One thing to note.
> > >
> > > I tested Mike's combined tree on the weekend fully dm4.16-block4.16
> > > and
> > > did not see this.
> > > This was with Mike combined tree and SRPT running 4.13-rc2.
> > >
> > > I also tested your tree Monday with the revert of the
> > > scatter/gather
> > > patches with both SRP and SRPT running your tree and it was fine.
> > >
> > > So its a combination of what you provided me before and that has
> > > been
> > > added to your tree.
> > >
> > > Mike combined tree seemed to be fine, I can revisit that if needed.
> > > I
> > > still have that kernel in place.
> > >
> > > I was not running latest SRPT when I tested Mike's tree
> >
> > Hello Laurence,
> >
> > The tree I sent you this morning did not only include Mike's latest
> > dm code
> > but also Jens' latest for-next branch. So what you wrote above does
> > not
> > contradict what I wrote in my e-mail, namely that I suspect that a
> > regression
> > was introduced by the patches in the series "blk-mq: improve DM's
> > blk-mq IO
> > merging via blk_insert_cloned_request feedback". These changes namely
> > went in
> > through the block tree and not through the dm tree. Additionally,
> > these
> > changes were not present in the block-scsi-for-next branch I sent you
> > on
> > Monday.
> >
> > Bart.
>
> Hi Bart
> Thank you
>
> I probably don't have latest stuff Mike added Monday in his tree.
> I have not gone back to test that, been busy with yours all week.
>
> I will get with Mike and pull his latest and test it with SRPT on 4.13-
> rc2 like before.
>
> That should be the best way to isolate this.
>
> Regards
> Laurence
>

--001a1140642a58a48b056301d22b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Grabbing Mikes latest combined tree and testing it now<div=
><br></div><div>Thanks</div><div>Laurence</div></div><div class=3D"gmail_ex=
tra"><br><div class=3D"gmail_quote">On Wed, Jan 17, 2018 at 6:57 PM, Lauren=
ce Oberman <span dir=3D"ltr">&lt;<a href=3D"mailto:loberman@redhat.com" tar=
get=3D"_blank">loberman@redhat.com</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Wed, 2018-01-17 =
at 23:53 +0000, Bart Van Assche wrote:<br>
&gt; On Wed, 2018-01-17 at 18:43 -0500, Laurence Oberman wrote:<br>
&gt; &gt; On Wed, 2018-01-17 at 23:31 +0000, Bart Van Assche wrote:<br>
&gt; &gt; &gt; On Wed, 2018-01-17 at 11:58 -0500, Mike Snitzer wrote:<br>
&gt; &gt; &gt; &gt; On Wed, Jan 17 2018 at 11:50am -0500,<br>
&gt; &gt; &gt; &gt; Jens Axboe &lt;<a href=3D"mailto:axboe@kernel.dk">axboe=
@kernel.dk</a>&gt; wrote:<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; On 1/17/18 9:25 AM, Mike Snitzer wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; Hi Jens,<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Think this finally takes care of it! ;)<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; Mike<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Mike Snitzer (2):<br>
&gt; &gt; &gt; &gt; &gt; &gt; =C2=A0 blk-mq: factor out a few helpers from<=
br>
&gt; &gt; &gt; &gt; &gt; &gt; __blk_mq_try_issue_directly<br>
&gt; &gt; &gt; &gt; &gt; &gt; =C2=A0 blk-mq-sched: remove unused &#39;can_b=
lock&#39; arg from<br>
&gt; &gt; &gt; &gt; &gt; &gt; blk_mq_sched_insert_request<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Ming Lei (1):<br>
&gt; &gt; &gt; &gt; &gt; &gt; =C2=A0 blk-mq: improve DM&#39;s blk-mq IO mer=
ging via<br>
&gt; &gt; &gt; &gt; &gt; &gt; blk_insert_cloned_request feedback<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Applied - added actual commit message to patch 3.<=
br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Great, thanks.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Hello Mike,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Laurence hit the following while retesting the SRP initiator=
<br>
&gt; &gt; &gt; code:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; [ 2223.797129] list_add corruption. prev-&gt;next should be =
next<br>
&gt; &gt; &gt; (00000000e0ddd5dd), but was 000000003defe5cd.<br>
&gt; &gt; &gt; (prev=3D000000003defe5cd).<br>
&gt; &gt; &gt; [ 2223.862168] WARNING: CPU: 14 PID: 577 at lib/list_debug.c=
:28<br>
&gt; &gt; &gt; __list_add_valid+0x6a/0x70<br>
&gt; &gt; &gt; [ 2224.481151] CPU: 14 PID: 577 Comm: kworker/14:1H Tainted:=
<br>
&gt; &gt; &gt; G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0I=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04.15.0-rc8.<wbr>bart3+ #1<br>
&gt; &gt; &gt; [ 2224.531193] Hardware name: HP ProLiant DL380 G7, BIOS P67=
<br>
&gt; &gt; &gt; 08/16/2015<br>
&gt; &gt; &gt; [ 2224.567150] Workqueue: kblockd blk_mq_run_work_fn<br>
&gt; &gt; &gt; [ 2224.593182] RIP: 0010:__list_add_valid+0x6a/<wbr>0x70<br>
&gt; &gt; &gt; [ 2224.967002] Call Trace:<br>
&gt; &gt; &gt; [ 2224.980941]=C2=A0=C2=A0blk_mq_request_<wbr>bypass_insert+=
0x57/0xa0<br>
&gt; &gt; &gt; [ 2225.009044]=C2=A0=C2=A0__blk_mq_try_<wbr>issue_directly+0=
x56/0x1e0<br>
&gt; &gt; &gt; [ 2225.037007]=C2=A0=C2=A0blk_mq_request_<wbr>direct_issue+0=
x5d/0xc0<br>
&gt; &gt; &gt; [ 2225.090608]=C2=A0=C2=A0map_request+<wbr>0x142/0x260 [dm_m=
od]<br>
&gt; &gt; &gt; [ 2225.114756]=C2=A0=C2=A0dm_mq_queue_rq+<wbr>0xa4/0x120 [dm=
_mod]<br>
&gt; &gt; &gt; [ 2225.140812]=C2=A0=C2=A0blk_mq_dispatch_<wbr>rq_list+0x90/=
0x5b0<br>
&gt; &gt; &gt; [ 2225.211769]=C2=A0=C2=A0blk_mq_sched_<wbr>dispatch_request=
s+0x107/0x1a0<br>
&gt; &gt; &gt; [ 2225.240825]=C2=A0=C2=A0__blk_mq_run_hw_<wbr>queue+0x5f/0x=
f0<br>
&gt; &gt; &gt; [ 2225.264852]=C2=A0=C2=A0process_one_<wbr>work+0x141/0x340<=
br>
&gt; &gt; &gt; [ 2225.287872]=C2=A0=C2=A0worker_thread+<wbr>0x47/0x3e0<br>
&gt; &gt; &gt; [ 2225.308354]=C2=A0=C2=A0kthread+0xf5/<wbr>0x130<br>
&gt; &gt; &gt; [ 2225.396405]=C2=A0=C2=A0ret_from_fork+<wbr>0x32/0x40<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; That call trace did not show up before this patch series was=
<br>
&gt; &gt; &gt; added to<br>
&gt; &gt; &gt; Jens&#39;<br>
&gt; &gt; &gt; tree. This is a regression. Could this have been introduced =
by<br>
&gt; &gt; &gt; this<br>
&gt; &gt; &gt; patch<br>
&gt; &gt; &gt; series?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Bart.<br>
&gt; &gt;<br>
&gt; &gt; Hi Bart<br>
&gt; &gt; One thing to note.<br>
&gt; &gt;<br>
&gt; &gt; I tested Mike&#39;s combined tree on the weekend fully dm4.16-blo=
ck4.16<br>
&gt; &gt; and<br>
&gt; &gt; did not see this.<br>
&gt; &gt; This was with Mike combined tree and SRPT running 4.13-rc2.<br>
&gt; &gt;<br>
&gt; &gt; I also tested your tree Monday with the revert of the<br>
&gt; &gt; scatter/gather<br>
&gt; &gt; patches with both SRP and SRPT running your tree and it was fine.=
<br>
&gt; &gt;<br>
&gt; &gt; So its a combination of what you provided me before and that has<=
br>
&gt; &gt; been<br>
&gt; &gt; added to your tree.<br>
&gt; &gt;<br>
&gt; &gt; Mike combined tree seemed to be fine, I can revisit that if neede=
d.<br>
&gt; &gt; I<br>
&gt; &gt; still have that kernel in place.<br>
&gt; &gt;<br>
&gt; &gt; I was not running latest SRPT when I tested Mike&#39;s tree<br>
&gt;<br>
&gt; Hello Laurence,<br>
&gt;<br>
&gt; The tree I sent you this morning did not only include Mike&#39;s lates=
t<br>
&gt; dm code<br>
&gt; but also Jens&#39; latest for-next branch. So what you wrote above doe=
s<br>
&gt; not<br>
&gt; contradict what I wrote in my e-mail, namely that I suspect that a<br>
&gt; regression<br>
&gt; was introduced by the patches in the series &quot;blk-mq: improve DM&#=
39;s<br>
&gt; blk-mq IO<br>
&gt; merging via blk_insert_cloned_request feedback&quot;. These changes na=
mely<br>
&gt; went in<br>
&gt; through the block tree and not through the dm tree. Additionally,<br>
&gt; these<br>
&gt; changes were not present in the block-scsi-for-next branch I sent you<=
br>
&gt; on<br>
&gt; Monday.<br>
&gt;<br>
&gt; Bart.<br>
<br>
</div></div>Hi Bart<br>
Thank you<br>
<br>
I probably don&#39;t have latest stuff Mike added Monday in his tree.<br>
I have not gone back to test that, been busy with yours all week.<br>
<br>
I will get with Mike and pull his latest and test it with SRPT on 4.13-<br>
rc2 like before.<br>
<br>
That should be the best way to isolate this.<br>
<br>
Regards<br>
<span class=3D"HOEnZb"><font color=3D"#888888">Laurence<br>
</font></span></blockquote></div><br></div>

--001a1140642a58a48b056301d22b--


--===============8606136465819215349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8606136465819215349==--
