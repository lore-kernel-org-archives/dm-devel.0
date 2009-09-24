From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] io-controller: Fix task hanging when there are more	than
 one groups
Date: Thu, 24 Sep 2009 09:10:17 +0800
Message-ID: <4ABAC6F9.9060406@cn.fujitsu.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA4B905.8010801@cn.fujitsu.com> <20090908191941.GF15974@redhat.com> <4AA75B71.5060109@cn.fujitsu.com> <20090909150537.GD8256@redhat.com> <4AA9A4BE.30005@cn.fujitsu.com> <20090915033739.GA4054@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754674AbZIXBMp@vger.kernel.org>
In-Reply-To: <20090915033739.GA4054@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

Hi Vivek,

Currently, we just set this flag when anticipating next request.
So make sure we remove this flag also in this case.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/as-iosched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 5868e72..7a64232 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -728,9 +728,10 @@ static void as_antic_stop(struct as_data *ad)
 	as_log(ad, "as_antic_stop antic_status=%d", ad->antic_status);
 
 	if (status == ANTIC_WAIT_REQ || status == ANTIC_WAIT_NEXT) {
-		if (status == ANTIC_WAIT_NEXT)
+		if (status == ANTIC_WAIT_NEXT) {
 			del_timer(&ad->antic_timer);
-		as_clear_active_asq_wait_request(ad);
+			as_clear_active_asq_wait_request(ad);
+		}
 		ad->antic_status = ANTIC_FINISHED;
 		/* see as_work_handler */
 		kblockd_schedule_work(ad->q, &ad->antic_work);
-- 
1.5.4.rc3
