From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-ingerity: change memcmp to strncmp
Date: Wed, 13 Mar 2019 07:56:02 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1903130753420.22289@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If the string opt_string is small, the function memcmp can access bytes
that are beyond the terminating nul character. In theory, it could cause
segfault, if opt_string were located just below some unmapped memory.

This patch changes memcmp to strncmp, so that we don't read bytes beyond
the end of the string.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+

---
 drivers/md/dm-integrity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-03-12 15:33:17.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2019-03-12 15:34:49.000000000 +0100
@@ -3185,7 +3185,7 @@ static int dm_integrity_ctr(struct dm_ta
 			journal_watermark = val;
 		else if (sscanf(opt_string, "commit_time:%u%c", &val, &dummy) == 1)
 			sync_msec = val;
-		else if (!memcmp(opt_string, "meta_device:", strlen("meta_device:"))) {
+		else if (!strncmp(opt_string, "meta_device:", strlen("meta_device:"))) {
 			if (ic->meta_dev) {
 				dm_put_device(ti, ic->meta_dev);
 				ic->meta_dev = NULL;
@@ -3204,17 +3204,17 @@ static int dm_integrity_ctr(struct dm_ta
 				goto bad;
 			}
 			ic->sectors_per_block = val >> SECTOR_SHIFT;
-		} else if (!memcmp(opt_string, "internal_hash:", strlen("internal_hash:"))) {
+		} else if (!strncmp(opt_string, "internal_hash:", strlen("internal_hash:"))) {
 			r = get_alg_and_key(opt_string, &ic->internal_hash_alg, &ti->error,
 					    "Invalid internal_hash argument");
 			if (r)
 				goto bad;
-		} else if (!memcmp(opt_string, "journal_crypt:", strlen("journal_crypt:"))) {
+		} else if (!strncmp(opt_string, "journal_crypt:", strlen("journal_crypt:"))) {
 			r = get_alg_and_key(opt_string, &ic->journal_crypt_alg, &ti->error,
 					    "Invalid journal_crypt argument");
 			if (r)
 				goto bad;
-		} else if (!memcmp(opt_string, "journal_mac:", strlen("journal_mac:"))) {
+		} else if (!strncmp(opt_string, "journal_mac:", strlen("journal_mac:"))) {
 			r = get_alg_and_key(opt_string, &ic->journal_mac_alg,  &ti->error,
 					    "Invalid journal_mac argument");
 			if (r)
