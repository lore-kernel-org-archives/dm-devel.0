From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 05/24] io-controller: Modify cfq to make use of flat elevator
 fair queuing
Date: Thu, 30 Jul 2009 14:30:40 +0800
Message-ID: <4A713E10.2030204@cn.fujitsu.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-6-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752182AbZG3GcM@vger.kernel.org>
In-Reply-To: <1248467274-32073-6-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>  /*
>   * Check if new_cfqq should preempt the currently active queue. Return 0 for
> - * no or if we aren't sure, a 1 will cause a preempt.
> + * no or if we aren't sure, a 1 will cause a preemption attempt.
> + * Some of the preemption logic has been moved to common layer. Only cfq
> + * specific parts are left here.
>   */
>  static int
> -cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> -		   struct request *rq)
> +cfq_should_preempt(struct request_queue *q, void *new_cfqq, struct request *rq)
>  {
> -	struct cfq_queue *cfqq;
> +	struct cfq_data *cfqd = q->elevator->elevator_data;
> +	struct cfq_queue *cfqq = elv_active_sched_queue(q->elevator);
>  
> -	cfqq = cfqd->active_queue;
>  	if (!cfqq)
>  		return 0;
>  
> -	if (cfq_slice_used(cfqq))
> +	if (elv_ioq_slice_used(cfqq->ioq))
>  		return 1;
>  
>  	if (cfq_class_idle(new_cfqq))
> @@ -2018,13 +1661,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  	if (rq_is_meta(rq) && !cfqq->meta_pending)
>  		return 1;
>  
> -	/*
> -	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> -	 */
> -	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> -		return 1;
> -
> -	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
> +	if (!cfqd->active_cic || !elv_ioq_wait_request(cfqq->ioq))
>  		return 0;
>  
>  	/*

Hi Vivek,

cfq_should_preempt() will do the check "if (cfq_rq_close(cfqd, rq)) to see whether
it should preempt the current cfqq. From fairness point of view,  should we also 
check "fairness" value, if it's set fairness == 1, don't allow to preempt the current
cfqq?


-- 
Regards
Gui Jianfeng
