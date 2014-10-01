From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: break out of both loops when freeing
	data
Date: Wed, 1 Oct 2014 13:29:48 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410011329050.25573@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>, dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

When we free the required number of entries (nr_to_scan becomes zero), we
must break out of both loops. The code exited only the inner loop and
continued in the outer loop.

Also, move dm_bufio_cond_resched to the inner loop, so that scanning the
list doesn't result in scheduling latency.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-3.17-rc7/drivers/md/dm-bufio.c
===================================================================
--- linux-3.17-rc7.orig/drivers/md/dm-bufio.c	2014-10-01 19:20:36.000000000 +0200
+++ linux-3.17-rc7/drivers/md/dm-bufio.c	2014-10-01 19:22:50.000000000 +0200
@@ -1473,10 +1473,12 @@ static long __scan(struct dm_bufio_clien
 		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
 			freed += __cleanup_old_buffer(b, gfp_mask, 0);
 			if (!--nr_to_scan)
-				break;
+				goto brk;
+			dm_bufio_cond_resched();
 		}
-		dm_bufio_cond_resched();
 	}
+
+brk:
 	return freed;
 }
 
