From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 10/20] io-conroller: Prepare elevator layer
 for single queue schedulers
Date: Fri, 05 Jun 2009 17:17:07 +0800
Message-ID: <4A28E293.90402@cn.fujitsu.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-11-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1243377729-2176-11-git-send-email-vgoyal@redhat.com>
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
> +				e->ops->elevator_free_sched_queue_fn(e,
> +							sched_q);
> +				sched_q = NULL;
> +				goto queue_fail;
> +			}
> +		}
> +
> +		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);

It's better to use IOPRIO_NORM here.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index f1179aa..3c5f9da 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2403,7 +2403,8 @@ alloc_ioq:
 			}
 		}
 
-		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);
+		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE,
+			     IOPRIO_NORM, 1);
 		io_group_set_ioq(iog, ioq);
 		elv_mark_ioq_sync(ioq);
 		elv_get_iog(iog);
-- 
1.5.4.rc3
