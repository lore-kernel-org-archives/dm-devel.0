From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: plug I/Os when writing the journal
Date: Wed, 19 Jul 2017 11:24:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707191123410.2305@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When copying data from the journal to the appropriate place, we submit
many I/Os. Some of these I/Os could go to adjacent areas. This patch uses
the plug mechanism, so that the adjacent I/Os could be merged.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -1822,6 +1822,9 @@ static void do_journal_write(struct dm_i
 {
 	unsigned i, j, n;
 	struct journal_completion comp;
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
 
 	comp.ic = ic;
 	comp.in_flight = (atomic_t)ATOMIC_INIT(1);
@@ -1946,6 +1949,8 @@ skip_io:
 
 	dm_bufio_write_dirty_buffers_async(ic->bufio);
 
+	blk_finish_plug(&plug);
+
 	complete_journal_op(&comp);
 	wait_for_completion_io(&comp.comp);
 
