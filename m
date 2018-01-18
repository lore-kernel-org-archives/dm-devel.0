From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes
	idle
Date: Thu, 18 Jan 2018 16:45:15 -0500
Message-ID: <CAFfF4qv+7gZY1dTdFnFkM-qu9Z3yUEV=Qe7fdUZuACzoxDyfTQ@mail.gmail.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
	<b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
	<20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
	<20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
	<deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
	<20180118204856.GA31679@redhat.com>
	<1516309128.2676.38.camel@wdc.com> <20180118212327.GB31679@redhat.com>
	<1516311554.2676.50.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7681521669711163265=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1516311554.2676.50.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

--===============7681521669711163265==
Content-Type: multipart/alternative; boundary="001a1140642a267eba056313e166"

--001a1140642a267eba056313e166
Content-Type: text/plain; charset="UTF-8"

Hello Bart

Firstly let me start with : You have always been kind, patient and helpful
to me and myself the same to you so I am not keen to get in the middle of
this.

But its not true about Red Hat because I work very hard on this and I very
often find bugs you are not seeing so Red Hat is adding value here.
I emailed you a number of times asking if you can provide me the exact
steps, but not via your srp-test suite.

I have a setup that is not conducive to running your loop disconnects etc.
and if you are seeing a stall on multiple loops of 02-mq I should be able
to reproduce it with out having to run your test suite.

Please let me know how I can help

Laurence

On Thu, Jan 18, 2018 at 4:39 PM, Bart Van Assche <Bart.VanAssche@wdc.com>
wrote:

> On Thu, 2018-01-18 at 16:23 -0500, Mike Snitzer wrote:
> > On Thu, Jan 18 2018 at  3:58P -0500,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> >
> > > On Thu, 2018-01-18 at 15:48 -0500, Mike Snitzer wrote:
> > > > For Bart's test the underlying scsi-mq driver is what is regularly
> > > > hitting this case in __blk_mq_try_issue_directly():
> > > >
> > > >         if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q))
> > >
> > > These lockups were all triggered by incorrect handling of
> > > .queue_rq() returning BLK_STS_RESOURCE.
> >
> > Please be precise, dm_mq_queue_rq()'s return of BLK_STS_RESOURCE?
> > "Incorrect" because it no longer runs blk_mq_delay_run_hw_queue()?
>
> In what I wrote I was referring to both dm_mq_queue_rq() and
> scsi_queue_rq().
> With "incorrect" I meant that queue lockups are introduced that make user
> space processes unkillable. That's a severe bug.
>
> > Please try to do more work analyzing the test case that only you can
> > easily run (due to srp_test being a PITA).
>
> It is not correct that I'm the only one who is able to run that software.
> Anyone who is willing to merge the latest SRP initiator and target driver
> patches in his or her tree can run that software in
> any VM. I'm working hard
> on getting the patches upstream that make it possible to run the srp-test
> software on a setup that is not equipped with InfiniBand hardware.
>
> > We have time to get this right, please stop hyperventilating about
> > "regressions".
>
> Sorry Mike but that's something I consider as an unfair comment. If Ming
> and
> you work on patches together, it's your job to make sure that no
> regressions
> are introduced. Instead of blaming me because I report these regressions
> you
> should be grateful that I take the time and effort to report these
> regressions
> early. And since you are employed by a large organization that sells Linux
> support services, your employer should invest in developing test cases that
> reach a higher coverage of the dm, SCSI and block layer code. I don't think
> that it's normal that my tests discovered several issues that were not
> discovered by Red Hat's internal test suite. That's something Red Hat has
> to
> address.
>
> Bart.

--001a1140642a267eba056313e166
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello Bart<div><br></div><div>Firstly let me start with : =
You have always been kind, patient and helpful to me and myself the same to=
 you so I am not keen to get in the middle of this.</div><div><br></div><di=
v>But its not true about Red Hat because I work very hard on this and I ver=
y often find bugs you are not seeing so Red Hat is adding value here.</div>=
<div>I emailed you a number of times asking if you can provide me the exact=
 steps, but not via your srp-test suite.</div><div><br></div><div>I have a =
setup that is not conducive to running your loop disconnects etc. and if yo=
u are seeing a stall on multiple loops of 02-mq I should be able to reprodu=
ce it with out having to run your test suite.=C2=A0</div><div><br></div><di=
v>Please let me know how I can help=C2=A0</div><div><br></div><div>Laurence=
</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Th=
u, Jan 18, 2018 at 4:39 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=
=3D"mailto:Bart.VanAssche@wdc.com" target=3D"_blank">Bart.VanAssche@wdc.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">O=
n Thu, 2018-01-18 at 16:23 -0500, Mike Snitzer wrote:<br>
</span><span class=3D"">&gt; On Thu, Jan 18 2018 at=C2=A0 3:58P -0500,<br>
&gt; Bart Van Assche &lt;<a href=3D"mailto:Bart.VanAssche@wdc.com">Bart.Van=
Assche@wdc.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Thu, 2018-01-18 at 15:48 -0500, Mike Snitzer wrote:<br>
&gt; &gt; &gt; For Bart&#39;s test the underlying scsi-mq driver is what is=
 regularly<br>
&gt; &gt; &gt; hitting this case in __blk_mq_try_issue_directly():<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (blk_mq_hctx_stopped(hct=
x) || blk_queue_quiesced(q))<br>
&gt; &gt;<br>
</span><span class=3D"">&gt; &gt; These lockups were all triggered by incor=
rect handling of<br>
&gt; &gt; .queue_rq() returning BLK_STS_RESOURCE.<br>
&gt;<br>
&gt; Please be precise, dm_mq_queue_rq()&#39;s return of BLK_STS_RESOURCE?<=
br>
&gt; &quot;Incorrect&quot; because it no longer runs blk_mq_delay_run_hw_qu=
eue()?<br>
<br>
</span>In what I wrote I was referring to both dm_mq_queue_rq() and scsi_qu=
eue_rq().<br>
With &quot;incorrect&quot; I meant that queue lockups are introduced that m=
ake user<br>
space processes unkillable. That&#39;s a severe bug.<br>
<span class=3D""><br>
&gt; Please try to do more work analyzing the test case that only you can<b=
r>
&gt; easily run (due to srp_test being a PITA).<br>
<br>
</span>It is not correct that I&#39;m the only one who is able to run that =
software.<br>
Anyone who is willing to merge the latest SRP initiator and target driver<b=
r>
patches in his or her tree can run that software in<br>
any VM. I&#39;m working hard<br>
on getting the patches upstream that make it possible to run the srp-test<b=
r>
software on a setup that is not equipped with InfiniBand hardware.<br>
<span class=3D""><br>
&gt; We have time to get this right, please stop hyperventilating about<br>
&gt; &quot;regressions&quot;.<br>
<br>
</span>Sorry Mike but that&#39;s something I consider as an unfair comment.=
 If Ming and<br>
you work on patches together, it&#39;s your job to make sure that no regres=
sions<br>
are introduced. Instead of blaming me because I report these regressions yo=
u<br>
should be grateful that I take the time and effort to report these regressi=
ons<br>
early. And since you are employed by a large organization that sells Linux<=
br>
support services, your employer should invest in developing test cases that=
<br>
reach a higher coverage of the dm, SCSI and block layer code. I don&#39;t t=
hink<br>
that it&#39;s normal that my tests discovered several issues that were not<=
br>
discovered by Red Hat&#39;s internal test suite. That&#39;s something Red H=
at has to<br>
address.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Bart.</font></span></blockquote></div><br></div>

--001a1140642a267eba056313e166--


--===============7681521669711163265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7681521669711163265==--
