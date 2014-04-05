From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/9] dm-crypt: use unbound workqueue for request
	processing
Date: Sat, 5 Apr 2014 14:06:04 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1404051405420.8509@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1404051404260.8509@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1404051405010.8509@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1404051405210.8509@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1404051405210.8509@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use unbound workqueue so that work is automatically ballanced between
available CPUs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.14-rc8/drivers/md/dm-crypt.c
===================================================================
--- linux-3.14-rc8.orig/drivers/md/dm-crypt.c	2014-03-25 22:57:00.000000000 +0100
+++ linux-3.14-rc8/drivers/md/dm-crypt.c	2014-03-28 17:09:14.000000000 +0100
@@ -1800,7 +1800,7 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	cc->crypt_queue = alloc_workqueue("kcryptd",
-					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
+					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
