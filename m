From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 21/25] io-controller: Per cgroup request
	descriptor support
Date: Wed, 08 Jul 2009 11:27:25 +0800
Message-ID: <4A54121D.5090008@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-22-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246564917-19603-22-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>  }
> +#ifdef CONFIG_GROUP_IOSCHED
> +static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->nr_group_requests, (page));
> +}
> +
> +static ssize_t
> +queue_group_requests_store(struct request_queue *q, const char *page,
> +					size_t count)
> +{
> +	unsigned long nr;
> +	int ret = queue_var_store(&nr, page, count);
> +	if (nr < BLKDEV_MIN_RQ)
> +		nr = BLKDEV_MIN_RQ;
> +
> +	spin_lock_irq(q->queue_lock);
> +	q->nr_group_requests = nr;
> +	spin_unlock_irq(q->queue_lock);
> +	return ret;
> +}
> +#endif

Hi Vivek,

Do we need to update the congestion thresholds for allocated io groups?

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-sysfs.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 577ed42..92b9f25 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -83,17 +83,32 @@ static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
 	return queue_var_show(q->nr_group_requests, (page));
 }
 
+extern void elv_io_group_congestion_threshold(struct request_queue *q,
+					      struct io_group *iog);
+
 static ssize_t
 queue_group_requests_store(struct request_queue *q, const char *page,
 					size_t count)
 {
+	struct hlist_node *n;
+	struct io_group *iog;
+	struct elv_fq_data *efqd;
 	unsigned long nr;
 	int ret = queue_var_store(&nr, page, count);
+
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
 	spin_lock_irq(q->queue_lock);
+
 	q->nr_group_requests = nr;
+
+	efqd = &q->elevator->efqd;
+
+	hlist_for_each_entry(iog, n, &efqd->group_list, elv_data_node) {
+		elv_io_group_congestion_threshold(q, iog);
+	}
+
 	spin_unlock_irq(q->queue_lock);
 	return ret;
 }
-- 
1.5.4.rc3 
