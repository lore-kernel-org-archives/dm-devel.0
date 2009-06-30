From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
 elevaotor layer
Date: Tue, 30 Jun 2009 14:40:36 +0800
Message-ID: <4A49B364.5000508@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751110AbZF3GlP@vger.kernel.org>
In-Reply-To: <1245443858-8487-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +
> +/*
> + * Do the accounting. Determine how much service (in terms of time slices)
> + * current queue used and adjust the start, finish time of queue and vtime
> + * of the tree accordingly.
> + *
> + * Determining the service used in terms of time is tricky in certain
> + * situations. Especially when underlying device supports command queuing
> + * and requests from multiple queues can be there at same time, then it
> + * is not clear which queue consumed how much of disk time.
> + *
> + * To mitigate this problem, cfq starts the time slice of the queue only
> + * after first request from the queue has completed. This does not work
> + * very well if we expire the queue before we wait for first and more
> + * request to finish from the queue. For seeky queues, we will expire the
> + * queue after dispatching few requests without waiting and start dispatching
> + * from next queue.
> + *
> + * Not sure how to determine the time consumed by queue in such scenarios.
> + * Currently as a crude approximation, we are charging 25% of time slice
> + * for such cases. A better mechanism is needed for accurate accounting.
> + */

  Hi Vivek,

  The comment is out of date, would you update it accordingly?

> +void __elv_ioq_slice_expired(struct request_queue *q, struct io_queue *ioq)
> +{
> +	struct elv_fq_data *efqd = &q->elevator->efqd;
> +	struct io_entity *entity = &ioq->entity;
> +	long slice_unused = 0, slice_used = 0, slice_overshoot = 0;
> +
> +	assert_spin_locked(q->queue_lock);
> +	elv_log_ioq(efqd, ioq, "slice expired");
> +
> +	if (elv_ioq_wait_request(ioq))
> +		del_timer(&efqd->idle_slice_timer);
> +
> +	elv_clear_ioq_wait_request(ioq);
> +
> +	/*

-- 
Regards
Gui Jianfeng
