From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 04/19] io-controller: Modify cfq to make use of flat elevator
 fair queuing
Date: Wed, 17 Jun 2009 10:22:44 +0800
Message-ID: <4A385374.7060708@cn.fujitsu.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-5-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759806AbZFQCY5@vger.kernel.org>
In-Reply-To: <1244513342-11758-5-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> This patch changes cfq to use fair queuing code from elevator layer.
> 

elevator_private2 isn't used to store cfqq now.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 23b24b9..7a9bbe6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1874,7 +1874,7 @@ static void cfq_put_request(struct request *rq)
 		put_io_context(RQ_CIC(rq)->ioc);
 
 		rq->elevator_private = NULL;
-		rq->elevator_private2 = NULL;
+		rq->ioq = NULL;
 
 		cfq_put_queue(cfqq);
 	}
-- 
1.5.4.rc3
