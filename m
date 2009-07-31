From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 05/24] io-controller: Modify cfq to make use
	of flat elevator fair queuing
Date: Fri, 31 Jul 2009 09:18:13 -0400
Message-ID: <20090731131813.GB3668@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
	<1248467274-32073-6-git-send-email-vgoyal@redhat.com>
	<4A713E10.2030204@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A713E10.2030204@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Thu, Jul 30, 2009 at 02:30:40PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  /*
> >   * Check if new_cfqq should preempt the currently active queue. Return 0 for
> > - * no or if we aren't sure, a 1 will cause a preempt.
> > + * no or if we aren't sure, a 1 will cause a preemption attempt.
> > + * Some of the preemption logic has been moved to common layer. Only cfq
> > + * specific parts are left here.
> >   */
> >  static int
> > -cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> > -		   struct request *rq)
> > +cfq_should_preempt(struct request_queue *q, void *new_cfqq, struct request *rq)
> >  {
> > -	struct cfq_queue *cfqq;
> > +	struct cfq_data *cfqd = q->elevator->elevator_data;
> > +	struct cfq_queue *cfqq = elv_active_sched_queue(q->elevator);
> >  
> > -	cfqq = cfqd->active_queue;
> >  	if (!cfqq)
> >  		return 0;
> >  
> > -	if (cfq_slice_used(cfqq))
> > +	if (elv_ioq_slice_used(cfqq->ioq))
> >  		return 1;
> >  
> >  	if (cfq_class_idle(new_cfqq))
> > @@ -2018,13 +1661,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> >  	if (rq_is_meta(rq) && !cfqq->meta_pending)
> >  		return 1;
> >  
> > -	/*
> > -	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> > -	 */
> > -	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> > -		return 1;
> > -
> > -	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
> > +	if (!cfqd->active_cic || !elv_ioq_wait_request(cfqq->ioq))
> >  		return 0;
> >  
> >  	/*
> 
> Hi Vivek,
> 
> cfq_should_preempt() will do the check "if (cfq_rq_close(cfqd, rq)) to see whether
> it should preempt the current cfqq. From fairness point of view,  should we also 
> check "fairness" value, if it's set fairness == 1, don't allow to preempt the current
> cfqq?

Hi Gui,

In V7, fairness=1 means that we try to dispatch request only from one
queue at a time and wait for requests to finish from that queue before
next queue is scheduled in. This helps in better disk time accounting for the
queue.

But currently this is not true for preemption path. So if we decide to
preempt the current queue (either by elevator layer or by cfq), we expire
the queue immediately and bring in the new one. So this is just not
cfq_rq_close() but the whole preemption path.

Currently I will leave it as it is but if we run into significant issues, 
then we can fix it. It will require extra logic of keeping track that
current queue has been preempted. Also keep track who preempted etc and
as soon as last request from queue completes, expire it.

Thanks
Vivek
