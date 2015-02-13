From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/7] dm-crypt: use unbound workqueue for request
	processing
Date: Fri, 13 Feb 2015 08:23:09 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502130822120.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use unbound workqueue so that work is automatically ballanced between
available CPUs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.18-rc1/drivers/md/dm-crypt.c
===================================================================
--- linux-3.18-rc1.orig/drivers/md/dm-crypt.c	2014-10-20 16:54:01.000000000 +0200
+++ linux-3.18-rc1/drivers/md/dm-crypt.c	2014-10-21 00:49:28.000000000 +0200
@@ -1808,7 +1808,7 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	cc->crypt_queue = alloc_workqueue("kcryptd",
-					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
+					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
