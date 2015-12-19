From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: corruption causing crash in __queue_work
Date: Sat, 19 Dec 2015 15:34:45 +0200
Message-ID: <CAJFSNy5Lqv_xy7Lf1GEDPczHpZU8+a2CYCM-3ZR=VkDPJptmcg@mail.gmail.com>
References: <566AF262.8050009@kyup.com>
	<20151211170805.GT30240@mtj.duckdns.org>
	<566E80AE.7020502@kyup.com> <20151214153147.GA14957@redhat.com>
	<CAJFSNy6qc-m_=FNuzrFJnvKJR2zSE12m8sQ3CCBRaBtyf=6AFg@mail.gmail.com>
	<20151214203138.GA2871@redhat.com> <56729272.2010803@kyup.com>
	<20151217153327.GI4026@mtj.duckdns.org> <5672D810.2010404@kyup.com>
	<20151217155032.GJ4026@mtj.duckdns.org>
	<20151217171537.GA24921@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7163174969632635222=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151217171537.GA24921@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Nikolay Borisov <kernel@kyup.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============7163174969632635222==
Content-Type: multipart/alternative; boundary=089e01176f27b36c3c05274051d5

--089e01176f27b36c3c05274051d5
Content-Type: text/plain; charset=UTF-8

On Thursday, December 17, 2015, Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Dec 17 2015 at 10:50am -0500,
> Tejun Heo <tj@kernel.org <javascript:;>> wrote:
>
> > Hello, Nikolay.
> >
> > On Thu, Dec 17, 2015 at 05:43:12PM +0200, Nikolay Borisov wrote:
> > > Right, but my initial understanding was that when canceling the delayed
> > > work and then issuing flush_workqueue would act the same way as if
> > > cancel_delayed_work_sync is called wrt to this particular delayed
> item, no?
> >
> > Not necessarily.  cancel_delayed_work() cancels whatever is currently
> > pending.  flush_workqueue() flushes whatever is pending and in flight
> > at the time of invocation.  Imagine the following scenario.
> >
> > 1. Work item is running but hasn't requeued itself yet.
> >
> > 2. cancel_delayed_work_sync() doesn't do anything as it's not pending.
>
> Did you mean cancel_delayed_work()?
>
> > 3. flush_workqueue() starts and waits for the running instance.
> >
> > 4. The running instance requeues itself but this isn't included in the
> >    scope of the above flush_workqueue().
> >
> > 5. flush_workqueue() returns when the work item is finished (but it's
> >    still queued).
>
> Hmm, the comment above cancel_delayed_work() is pretty misleading then:
>
>  * Note:
>  * The work callback function may still be running on return, unless
>  * it returns %true and the work doesn't re-arm itself.  Explicitly flush
> or
>  * use cancel_delayed_work_sync() to wait on it.
>
> Given dm-thin.c:pool_postsuspend() does:
>
>         cancel_delayed_work(&pool->waker);
>         cancel_delayed_work(&pool->no_space_timeout);
>         flush_workqueue(pool->wq);
>
> I wouldn't have thought cancel_delayed_work_sync() was needed.
>

Ping as Tejun might have missed this email. I'm also interested in knowing
the logic behind the comment.

--089e01176f27b36c3c05274051d5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Thursday, December 17, 2015, Mike Snitzer &lt;<a href=3D"mailto:=
snitzer@redhat.com">snitzer@redhat.com</a>&gt; wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Thu, Dec 17 2015 at 10:50am -0500,<br>
Tejun Heo &lt;<a href=3D"javascript:;" onclick=3D"_e(event, &#39;cvml&#39;,=
 &#39;tj@kernel.org&#39;)">tj@kernel.org</a>&gt; wrote:<br>
<br>
&gt; Hello, Nikolay.<br>
&gt;<br>
&gt; On Thu, Dec 17, 2015 at 05:43:12PM +0200, Nikolay Borisov wrote:<br>
&gt; &gt; Right, but my initial understanding was that when canceling the d=
elayed<br>
&gt; &gt; work and then issuing flush_workqueue would act the same way as i=
f<br>
&gt; &gt; cancel_delayed_work_sync is called wrt to this particular delayed=
 item, no?<br>
&gt;<br>
&gt; Not necessarily.=C2=A0 cancel_delayed_work() cancels whatever is curre=
ntly<br>
&gt; pending.=C2=A0 flush_workqueue() flushes whatever is pending and in fl=
ight<br>
&gt; at the time of invocation.=C2=A0 Imagine the following scenario.<br>
&gt;<br>
&gt; 1. Work item is running but hasn&#39;t requeued itself yet.<br>
&gt;<br>
&gt; 2. cancel_delayed_work_sync() doesn&#39;t do anything as it&#39;s not =
pending.<br>
<br>
Did you mean cancel_delayed_work()?<br>
<br>
&gt; 3. flush_workqueue() starts and waits for the running instance.<br>
&gt;<br>
&gt; 4. The running instance requeues itself but this isn&#39;t included in=
 the<br>
&gt;=C2=A0 =C2=A0 scope of the above flush_workqueue().<br>
&gt;<br>
&gt; 5. flush_workqueue() returns when the work item is finished (but it&#3=
9;s<br>
&gt;=C2=A0 =C2=A0 still queued).<br>
<br>
Hmm, the comment above cancel_delayed_work() is pretty misleading then:<br>
<br>
=C2=A0* Note:<br>
=C2=A0* The work callback function may still be running on return, unless<b=
r>
=C2=A0* it returns %true and the work doesn&#39;t re-arm itself.=C2=A0 Expl=
icitly flush or<br>
=C2=A0* use cancel_delayed_work_sync() to wait on it.<br>
<br>
Given dm-thin.c:pool_postsuspend() does:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cancel_delayed_work(&amp;pool-&gt;waker);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cancel_delayed_work(&amp;pool-&gt;no_space_time=
out);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 flush_workqueue(pool-&gt;wq);<br>
<br>
I wouldn&#39;t have thought cancel_delayed_work_sync() was needed.<br>
</blockquote><div><br></div><div>Ping as Tejun might have missed this email=
. I&#39;m also interested in knowing the logic behind the comment.</div>

--089e01176f27b36c3c05274051d5--


--===============7163174969632635222==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7163174969632635222==--
