From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
 elevaotor layer
Date: Mon, 08 Jun 2009 09:08:44 +0800
Message-ID: <4A2C649C.8070806@cn.fujitsu.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754617AbZFHBK1@vger.kernel.org>
In-Reply-To: <1243377729-2176-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +
> +/* Get next queue for service. */
> +struct io_queue *elv_get_next_ioq(struct request_queue *q, int extract)
> +{
> +	struct elv_fq_data *efqd = &q->elevator->efqd;
> +	struct io_entity *entity = NULL;
> +	struct io_queue *ioq = NULL;
> +	struct io_sched_data *sd;
> +
> +	/*
> +	 * one can check for which queue will be selected next while having
> +	 * one queue active. preempt logic uses it.
> +	 */
> +	BUG_ON(extract && efqd->active_queue != NULL);
> +
> +	if (!efqd->busy_queues)
> +		return NULL;
> +
> +	sd = &efqd->root_group->sched_data;
> +	if (extract)
> +		entity = bfq_lookup_next_entity(sd, 1);
> +	else
> +		entity = bfq_lookup_next_entity(sd, 0);

This if and else branch is not needed.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 3c5f9da..655162b 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3069,10 +3069,7 @@ struct io_queue *elv_get_next_ioq(struct request_queue *q, int extract)
 
 	sd = &efqd->root_group->sched_data;
 	for (; sd != NULL; sd = entity->my_sched_data) {
-		if (extract)
-			entity = bfq_lookup_next_entity(sd, 1);
-		else
-			entity = bfq_lookup_next_entity(sd, 0);
+		entity = bfq_lookup_next_entity(sd, extract);
 
 		/*
 		 * entity can be null despite the fact that there are busy
-- 
1.5.4.rc3
