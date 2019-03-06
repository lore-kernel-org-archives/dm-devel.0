From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: limit the rate of error messages
Date: Wed, 6 Mar 2019 08:29:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1903060827350.26676@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, ncroxon@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

When using dm-integrity underneath md-raid, some tests with raid
auto-correction trigger large amounts of integrity failures - and all
these failures print an error message. These messages can bring the
system to a halt if the system is using serial console.

This patch limits the rate of error messages - it improves the speed of
raid recovery and avoids the hang.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+

---
 drivers/md/dm-integrity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-02-10 21:50:15.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2019-03-06 13:42:17.000000000 +0100
@@ -1368,8 +1368,8 @@ again:
 						checksums_ptr - checksums, !dio->write ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
 				if (r > 0) {
-					DMERR("Checksum failed at sector 0x%llx",
-					      (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
+					DMERR_LIMIT("Checksum failed at sector 0x%llx",
+						    (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
 					r = -EILSEQ;
 					atomic64_inc(&ic->number_of_mismatches);
 				}
@@ -1561,8 +1561,8 @@ retry_kmap:
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
-						DMERR("Checksum failed when reading from journal, at sector 0x%llx",
-						      (unsigned long long)logical_sector);
+						DMERR_LIMIT("Checksum failed when reading from journal, at sector 0x%llx",
+							    (unsigned long long)logical_sector);
 					}
 				}
 #endif
