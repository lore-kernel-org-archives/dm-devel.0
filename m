From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 03/24] io-controller: Common flat fair queuing code in
 elevaotor layer
Date: Wed, 19 Aug 2009 11:36:22 +0800
Message-ID: <4A8B7336.7010800@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751624AbZHSDhP@vger.kernel.org>
In-Reply-To: <1250451046-9966-4-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
...

> +
> +static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
> +{
> +	elv_log_ioq(q->elevator->efqd, ioq, "preempt");
> +	elv_slice_expired(q);
> +
> +	/*
> +	 * Put the new queue at the front of the of the current list,
> +	 * so we know that it will be selected next.
> +	 */
> +
> +	requeue_ioq(ioq);
> +	ioq->slice_start = ioq->slice_end = 0;

I think this assignment is redundant because these two members will be reset
when this ioq is scheduled.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d04e925..b3c387d 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2650,7 +2650,6 @@ static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
 		 */
 
 		requeue_ioq(ioq);
-		ioq->slice_start = ioq->slice_end = 0;
 		elv_mark_ioq_slice_new(ioq);
 	}
 }
-- 
1.5.4.rc3
