From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: count failures
Date: Fri, 21 Jul 2017 12:00:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707211158450.31337@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a patch to count errors in dm-integrity - as Jon suggested.

This patch changes dm-integrity so that it counts the number of checksum
failures and reports the counter in the status line.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -225,6 +225,8 @@ struct dm_integrity_c {
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
 	struct alg_spec journal_mac_alg;
+
+	atomic64_t number_of_mismatches;
 };
 
 struct dm_integrity_range {
@@ -309,6 +311,8 @@ static void dm_integrity_dtr(struct dm_t
 
 static void dm_integrity_io_error(struct dm_integrity_c *ic, const char *msg, int err)
 {
+	if (err == -EILSEQ)
+		atomic64_inc(&ic->number_of_mismatches);
 	if (!cmpxchg(&ic->failed, 0, err))
 		DMERR("Error on %s: %d", msg, err);
 }
@@ -1273,6 +1277,7 @@ again:
 					DMERR("Checksum failed at sector 0x%llx",
 					      (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
 					r = -EILSEQ;
+					atomic64_inc(&ic->number_of_mismatches);
 				}
 				if (likely(checksums != checksums_onstack))
 					kfree(checksums);
@@ -2222,7 +2227,7 @@ static void dm_integrity_status(struct d
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		result[0] = '\0';
+		DMEMIT("%llu", (unsigned long long)atomic64_read(&ic->number_of_mismatches));
 		break;
 
 	case STATUSTYPE_TABLE: {
@@ -2795,6 +2800,7 @@ static int dm_integrity_ctr(struct dm_ta
 	bio_list_init(&ic->flush_bio_list);
 	init_waitqueue_head(&ic->copy_to_journal_wait);
 	init_completion(&ic->crypto_backoff);
+	atomic64_set(&ic->number_of_mismatches, 0);
 
 	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &ic->dev);
 	if (r) {
