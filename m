From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm snapshot: fix data corruption
Date: Mon, 3 Mar 2014 17:19:22 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1403031717130.15269@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Marian Csontos <mcsontos@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The patch 55494bf2947dccdf2d98b62374fea7365dfead84 broke snapshots. When
loading the list of exceptions, the old code read exception areas one by
one into ps->area and inserted the exceptions into the hash table. The
patch 55494bf2 changed it so that dm-bufio with prefetch is used to load
exceptions. It loads the exceptions correctly, but leaves ps->area
uninitialized. When a new exception is allocated, it is stored in this
uninitialized ps->area location and full ps->area is written to the disk.
This causes metadata corruption.

This patch fixes the bug by copying the last area that was read via
dm-bufio into ps->area.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-3.14-rc5/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-3.14-rc5.orig/drivers/md/dm-snap-persistent.c	2014-03-03 22:42:32.000000000 +0100
+++ linux-3.14-rc5/drivers/md/dm-snap-persistent.c	2014-03-03 22:45:45.000000000 +0100
@@ -546,6 +546,9 @@ static int read_exceptions(struct pstore
 		r = insert_exceptions(ps, area, callback, callback_context,
 				      &full);
 
+		if (!full)
+			memcpy(ps->area, area, ps->store->chunk_size << SECTOR_SHIFT);
+
 		dm_bufio_release(bp);
 
 		dm_bufio_forget(client, chunk);
