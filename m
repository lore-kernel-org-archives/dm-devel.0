From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix a crash with unusually large
Date: Thu, 19 Mar 2020 10:39:58 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003191035170.1262@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I've found a bug in dm-integrity - if the user specified tag size greater 
than HASH_MAX_DIGESTSIZE (and lower or equal than MAX_TAG_SIZE), it 
crashes if the kmalloc call in integrity_metadata fails.

I'm still not sure how to fix it: we can extend the size of the array 
checksums_onstack (but the extended array takes 424 bytes - which may be 
too large).

Or, we can restrict ic->tag_size to HASH_MAX_DIGESTSIZE, but it may break 
some existing volumes where the user is using larger tag_size.

What do you think would be better?

Mikulas





From: Mikulas Patocka <mpatocka@redhat.com>

If the user specifies tag size larger than HASH_MAX_DIGESTSIZE, there's a
crash in integrity_metadata.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-03-19 15:28:14.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-03-19 15:30:08.000000000 +0100
@@ -1519,7 +1519,7 @@ static void integrity_metadata(struct wo
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[HASH_MAX_DIGESTSIZE];
+		char checksums_onstack[max(HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		unsigned sectors_to_process = dio->range.n_sectors;
 		sector_t sector = dio->range.logical_sector;
 
