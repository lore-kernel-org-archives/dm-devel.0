From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Subject: Re: [PATCH] io-controller: implement per group request
 allocation limitation
Date: Mon, 03 Aug 2009 22:02:58 -0400
Message-ID: <4A7796D2.4030104@ds.jp.nec.com>
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
> ---
(snip)

Hi Jianfeng,

If this helps.

If calling elv_io_group_congestion_threshold() before
setting iog->iocg_id, iocg->nr_group_requests cannot be
referred.  As a result of it, iog->nr_congestion_on is
always misculculated as 0.
This patch moves the calling of
elv_io_group_congestion_threshold() after setting
iog->iocg_id.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
  block/elevator-fq.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 7c83d1e..3368a7f 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2195,7 +2195,6 @@ static struct io_group *io_alloc_root_group(struct request_queue *q,
  		iog->sched_data.service_tree[i] = IO_SERVICE_TREE_INIT;
  
  	blk_init_request_list(&iog->rl);
-	elv_io_group_congestion_threshold(q, iog);
  
  	iocg = &io_root_cgroup;
  	spin_lock_irq(&iocg->lock);
@@ -2204,6 +2203,8 @@ static struct io_group *io_alloc_root_group(struct request_queue *q,
  	iog->iocg_id = css_id(&iocg->css);
  	spin_unlock_irq(&iocg->lock);
  
+	elv_io_group_congestion_threshold(q, iog);
+
  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
  	io_group_path(iog, iog->path, sizeof(iog->path));
  #endif
-- 
1.6.2.5




-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com
