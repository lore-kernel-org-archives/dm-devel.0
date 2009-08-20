From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH] IO-Controller: clear ioq wait flag if a request goes into
 that ioq
Date: Thu, 20 Aug 2009 09:46:10 +0800
Message-ID: <4A8CAAE2.1030804@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-12-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751869AbZHTBrC@vger.kernel.org>
In-Reply-To: <1250451046-9966-12-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>  		/*
>  		 * Remember that we saw a request from this process, but
> @@ -1940,7 +2013,7 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
>  		 * has other work pending, don't risk delaying until the
>  		 * idle timer unplug to continue working.
>  		 */
> -		if (elv_ioq_wait_request(ioq)) {
> +		if (group_wait || elv_ioq_wait_request(ioq)) {

Hi Vivek,

I guess we need to clear ioq_wait_request flags if there are requests to 
go in this ioq. Otherwise, once waitting request on ioq, it will go into
this path every time when a request is enqueued.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index b3c387d..201543e 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2708,6 +2708,9 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
 				__blk_run_queue(q);
 			else
 				elv_mark_ioq_must_dispatch(ioq);
+
+			if (elv_ioq_wait_request(ioq))
+				elv_clear_ioq_wait_request(ioq);
 		}
 	} else if (elv_should_preempt(q, ioq, rq)) {
 		/*
-- 
1.5.4.rc3
