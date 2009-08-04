From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Subject: Re: [PATCH] io-controller: implement per group request
 allocation limitation
Date: Mon, 03 Aug 2009 22:04:09 -0400
Message-ID: <4A779719.1070900@ds.jp.nec.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<4A569FC5.7090801@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A569FC5.7090801@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Vivek Goyal <vgoyal@redhat.com>, righi.andrea@gmail.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Gui Jianfeng wrote, on 07/09/2009 09:56 PM:
> Hi Vivek,
>
> This patch exports a cgroup based per group request limits interface.
> and removes the global one. Now we can use this interface to perform
> different request allocation limitation for different groups.
>
> Signed-off-by: Gui Jianfeng<guijianfeng@cn.fujitsu.com>
(snip)

Hi Jianfeng,

If this helps, again.

A patch posted from Gui Jianfeng on 2009/07/09 adds per-cgroup
nr_requests control by io.nr_group_requests.  The patch missed to update
iog->nr_congestion_{on|off} and this patch adds the missing-link.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
  block/elevator-fq.c |   11 +++++++++++
  1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 673e490..316bd8d 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1607,6 +1607,10 @@ static int io_cgroup_nr_requests_write(struct cgroup *cgroup,
  					u64 val)
  {
  	struct io_cgroup *iocg;
+	struct io_group *iog;
+	struct elv_fq_data *efqd;
+	struct request_queue *q;
+	struct hlist_node *n;
  
  	if (val < BLKDEV_MIN_RQ)
  		val = BLKDEV_MIN_RQ;
@@ -1618,6 +1622,13 @@ static int io_cgroup_nr_requests_write(struct cgroup *cgroup,
  
  	spin_lock_irq(&iocg->lock);
  	iocg->nr_group_requests = (unsigned long)val;
+	hlist_for_each_entry(iog, n, &iocg->group_data, group_node) {
+		rcu_read_lock();
+		efqd = rcu_dereference(iog->key);
+		q = efqd->queue;
+		rcu_read_unlock();
+		elv_io_group_congestion_threshold(q, iog);
+	}
  	spin_unlock_irq(&iocg->lock);
  
  	cgroup_unlock();
-- 
1.6.2.5


-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com
