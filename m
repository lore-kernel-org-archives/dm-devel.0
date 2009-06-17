From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 15/19] io-controller: map async requests to
 appropriate cgroup
Date: Wed, 17 Jun 2009 17:17:40 +0800
Message-ID: <4A38B4B4.7060101@cn.fujitsu.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-16-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244513342-11758-16-git-send-email-vgoyal@redhat.com>
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
> +
> +struct io_group *rq_iog(struct request_queue *q, struct request *rq)
>  {
>  	return q->elevator->efqd.root_group;
>  }

There is no need for this function now.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 912ac6a..bfa79c9 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2522,11 +2522,6 @@ struct io_group *io_get_io_group(struct request_queue *q, struct bio *bio,
 {
 	return q->elevator->efqd.root_group;
 }
-
-struct io_group *rq_iog(struct request_queue *q, struct request *rq)
-{
-	return q->elevator->efqd.root_group;
-}
 EXPORT_SYMBOL(io_get_io_group);
 #endif /* CONFIG_GROUP_IOSCHED*/
 
-- 
1.5.4.rc3
