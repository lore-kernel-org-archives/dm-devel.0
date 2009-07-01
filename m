From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
 elevaotor layer
Date: Wed, 01 Jul 2009 17:24:46 +0800
Message-ID: <4A4B2B5E.3080309@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755050AbZGAJZ1@vger.kernel.org>
In-Reply-To: <1245443858-8487-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> + * If ioscheduler has functionality of keeping track of close cooperator, check
> + * with it if it has got a closely co-operating queue.
> + */
> +static inline struct io_queue *elv_close_cooperator(struct request_queue *q,
> +					struct io_queue *ioq, int probe)
> +{
> +	struct elevator_queue *e = q->elevator;
> +	struct io_queue *new_ioq = NULL;
> +
> +	/*
> +	 * Currently this feature is supported only for flat hierarchy or
> +	 * root group queues so that default cfq behavior is not changed.
> +	 */
> +	if (!is_root_group_ioq(q, ioq))
> +		return NULL;
> +
> +	if (q->elevator->ops->elevator_close_cooperator_fn)
> +		new_ioq = e->ops->elevator_close_cooperator_fn(q,
> +						ioq->sched_queue, probe);
> +
> +	/* Only select co-operating queue if it belongs to root group */
> +	if (new_ioq && !is_root_group_ioq(q, new_ioq))
> +		return NULL;
> +
> +	return new_ioq;
> +}

  Hi Vivek,

  Currently, whether we can let this feature be supported if current queue 
  and found queue are in the same group? I guess this change won't break 
  the default cfq behavior. Am i missing something?

-- 
Regards
Gui Jianfeng
