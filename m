From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 22/24] io-controller: Per io group bdi congestion interface
Date: Sat, 08 Aug 2009 16:14:51 +0800
Message-ID: <4A7D33FB.6090207@cn.fujitsu.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-23-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754039AbZHHIQv@vger.kernel.org>
In-Reply-To: <1248467274-32073-23-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +/* Set io group congestion on and off thresholds */
> +void elv_io_group_congestion_threshold(struct request_queue *q,
> +						struct io_group *iog)
> +{
> +	int nr;
> +
> +	nr = q->nr_group_requests - (q->nr_group_requests / 8) + 1;
> +	if (nr > q->nr_group_requests)
> +		nr = q->nr_group_requests;
> +	iog->nr_congestion_on = nr;
> +
> +	nr = q->nr_group_requests - (q->nr_group_requests / 8)
> +			- (q->nr_group_requests / 16) - 1;
> +	if (nr < 1)
> +		nr = 1;
> +	iog->nr_congestion_off = nr;

Vivek,

Since we determine whether io group is congenssed or not just by checking 
iog->nr_congestion_on, we can get rid of iog->nr_congestion_off here.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    6 ------
 block/elevator-fq.h |    3 +--
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 66b10eb..e73da31 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1267,12 +1267,6 @@ void elv_io_group_congestion_threshold(struct request_queue *q,
 	if (nr > q->nr_group_requests)
 		nr = q->nr_group_requests;
 	iog->nr_congestion_on = nr;
-
-	nr = q->nr_group_requests - (q->nr_group_requests / 8)
-			- (q->nr_group_requests / 16) - 1;
-	if (nr < 1)
-		nr = 1;
-	iog->nr_congestion_off = nr;
 }
 
 static inline int elv_is_iog_congested(struct request_queue *q,
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 0581e55..2815279 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -266,9 +266,8 @@ struct io_group {
 	/* Single ioq per group, used for noop, deadline, anticipatory */
 	struct io_queue *ioq;
 
-	/* io group congestion on and off threshold for request descriptors */
+	/* io group congestion on threshold for request descriptors */
 	unsigned int nr_congestion_on;
-	unsigned int nr_congestion_off;
 
 	/* request list associated with the group */
 	struct request_list rl;
-- 
1.5.4.rc3
