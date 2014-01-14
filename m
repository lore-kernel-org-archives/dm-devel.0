From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/6] dm-snapshot: make ps->area explicit
Date: Mon, 13 Jan 2014 19:14:04 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401131913420.30362@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401131911570.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131912480.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131913090.30362@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401131913090.30362@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch changes the functions get_exception, read_exception and
insert_exceptions so that the pointer ps->area is given as an argument.

This patch doesn't change any functionality, but it refactors the code for
the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-snap-persistent.c	2014-01-09 23:37:59.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-snap-persistent.c	2014-01-09 23:40:22.000000000 +0100
@@ -401,17 +401,18 @@ static int write_header(struct pstore *p
 /*
  * Access functions for the disk exceptions, these do the endian conversions.
  */
-static struct disk_exception *get_exception(struct pstore *ps, uint32_t index)
+static struct disk_exception *get_exception(struct pstore *ps, void *ps_area,
+					    uint32_t index)
 {
 	BUG_ON(index >= ps->exceptions_per_area);
 
-	return ((struct disk_exception *) ps->area) + index;
+	return ((struct disk_exception *) ps_area) + index;
 }
 
-static void read_exception(struct pstore *ps,
+static void read_exception(struct pstore *ps, void *ps_area,
 			   uint32_t index, struct core_exception *result)
 {
-	struct disk_exception *de = get_exception(ps, index);
+	struct disk_exception *de = get_exception(ps, ps_area, index);
 
 	/* copy it */
 	result->old_chunk = le64_to_cpu(de->old_chunk);
@@ -421,7 +422,7 @@ static void read_exception(struct pstore
 static void write_exception(struct pstore *ps,
 			    uint32_t index, struct core_exception *e)
 {
-	struct disk_exception *de = get_exception(ps, index);
+	struct disk_exception *de = get_exception(ps, ps->area, index);
 
 	/* copy it */
 	de->old_chunk = cpu_to_le64(e->old_chunk);
@@ -430,7 +431,7 @@ static void write_exception(struct pstor
 
 static void clear_exception(struct pstore *ps, uint32_t index)
 {
-	struct disk_exception *de = get_exception(ps, index);
+	struct disk_exception *de = get_exception(ps, ps->area, index);
 
 	/* clear it */
 	de->old_chunk = 0;
@@ -442,7 +443,7 @@ static void clear_exception(struct pstor
  * 'full' is filled in to indicate if the area has been
  * filled.
  */
-static int insert_exceptions(struct pstore *ps,
+static int insert_exceptions(struct pstore *ps, void *ps_area,
 			     int (*callback)(void *callback_context,
 					     chunk_t old, chunk_t new),
 			     void *callback_context,
@@ -456,7 +457,7 @@ static int insert_exceptions(struct psto
 	*full = 1;
 
 	for (i = 0; i < ps->exceptions_per_area; i++) {
-		read_exception(ps, i, &e);
+		read_exception(ps, ps_area, i, &e);
 
 		/*
 		 * If the new_chunk is pointing at the start of
@@ -503,7 +504,8 @@ static int read_exceptions(struct pstore
 		if (r)
 			return r;
 
-		r = insert_exceptions(ps, callback, callback_context, &full);
+		r = insert_exceptions(ps, ps->area, callback, callback_context,
+				      &full);
 		if (r)
 			return r;
 	}
@@ -733,7 +735,7 @@ static int persistent_prepare_merge(stru
 		ps->current_committed = ps->exceptions_per_area;
 	}
 
-	read_exception(ps, ps->current_committed - 1, &ce);
+	read_exception(ps, ps->area, ps->current_committed - 1, &ce);
 	*last_old_chunk = ce.old_chunk;
 	*last_new_chunk = ce.new_chunk;
 
@@ -743,8 +745,8 @@ static int persistent_prepare_merge(stru
 	 */
 	for (nr_consecutive = 1; nr_consecutive < ps->current_committed;
 	     nr_consecutive++) {
-		read_exception(ps, ps->current_committed - 1 - nr_consecutive,
-			       &ce);
+		read_exception(ps, ps->area,
+			       ps->current_committed - 1 - nr_consecutive, &ce);
 		if (ce.old_chunk != *last_old_chunk - nr_consecutive ||
 		    ce.new_chunk != *last_new_chunk - nr_consecutive)
 			break;
