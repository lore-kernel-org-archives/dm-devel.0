From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 11/24] io-controller: Introduce group idling
Date: Fri, 28 Aug 2009 09:12:57 +0800
Message-ID: <4A972F19.4090408@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-12-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250451046-9966-12-git-send-email-vgoyal@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> @@ -2201,13 +2362,44 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  		 * mean seek distance, give them a chance to run instead
>  		 * of idling.
>  		 */
> -		if (elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq))
> +		if (elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq)) {
> +			/*
> +			 * This is the last empty queue in the group and it
> +			 * has consumed its slice. If we expire it right away
> +			 * group might loose its share. Wait for an extra
> +			 * group_idle period for a request before queue
> +			 * expires.
> +			 */
> +			if (elv_iog_should_idle(ioq)) {
> +				elv_iog_arm_slice_timer(q, iog, 1);
> +				goto done;
> +			}
> +

Hi Vivek,

I think we shouldn't arm idle timer on iog again, if it's already on.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index a4161c2..04f646f 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3116,7 +3116,8 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 			 * group_idle period for a request before queue
 			 * expires.
 			 */
-			if (elv_iog_should_idle(ioq)) {
+			if (elv_iog_should_idle(ioq) &&
+			    !elv_iog_wait_busy(iog)) {
 				elv_iog_arm_slice_timer(q, iog, 1);
 				goto done;
 			}
-- 
1.5.4.rc3
