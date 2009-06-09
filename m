From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 08/18] io-controller: idle for sometime on sync queue
 before expiring it
Date: Tue, 09 Jun 2009 15:56:38 +0800
Message-ID: <4A2E15B6.8030001@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-9-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758877AbZFIH60@vger.kernel.org>
In-Reply-To: <1241553525-28095-9-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +ssize_t elv_fairness_store(struct request_queue *q, const char *name,
> +			  size_t count)
> +{
> +	struct elv_fq_data *efqd;
> +	unsigned int data;
> +	unsigned long flags;
> +
> +	char *p = (char *)name;
> +
> +	data = simple_strtoul(p, &p, 10);
> +
> +	if (data < 0)
> +		data = 0;
> +	else if (data > INT_MAX)
> +		data = INT_MAX;

  Hi Vivek,

  data might overflow on 64 bit systems. In addition, since "fairness" is nothing 
  more than a switch, just let it be.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |   10 +++++-----
 block/elevator-fq.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 655162b..42d4279 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2605,7 +2605,7 @@ static inline int is_root_group_ioq(struct request_queue *q,
 ssize_t elv_fairness_show(struct request_queue *q, char *name)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2619,17 +2619,17 @@ ssize_t elv_fairness_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	char *p = (char *)name;
 
 	data = simple_strtoul(p, &p, 10);
 
-	if (data < 0)
+	if (!data)
 		data = 0;
-	else if (data > INT_MAX)
-		data = INT_MAX;
+	else
+		data = 1;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	efqd = &q->elevator->efqd;
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index b2bb11a..4fe843a 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -359,7 +359,7 @@ struct elv_fq_data {
 	 * throughput and focus more on providing fairness for sync
 	 * queues.
 	 */
-	int fairness;
+	unsigned long fairness;
 };
 
 extern int elv_slice_idle;
-- 
1.5.4.rc3
