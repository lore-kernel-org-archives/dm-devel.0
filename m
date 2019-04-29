From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 02/10] dm-integrity: dont report unused options
Date: Mon, 29 Apr 2019 14:57:18 +0200
Message-ID: <20190429125738.430881080@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-hide-unused-parameters.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

If we are not journaling, don't report journaling options in the table
status.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-09 14:01:43.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-09 14:01:43.000000000 +0200
@@ -2468,10 +2468,12 @@ static void dm_integrity_status(struct d
 		__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
 		watermark_percentage += ic->journal_entries / 2;
 		do_div(watermark_percentage, ic->journal_entries);
-		arg_count = 5;
+		arg_count = 3;
 		arg_count += !!ic->meta_dev;
 		arg_count += ic->sectors_per_block != 1;
 		arg_count += !!(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING));
+		arg_count += ic->mode == 'J';
+		arg_count += ic->mode == 'J';
 		arg_count += !!ic->internal_hash_alg.alg_string;
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
@@ -2486,8 +2488,10 @@ static void dm_integrity_status(struct d
 		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
-		DMEMIT(" journal_watermark:%u", (unsigned)watermark_percentage);
-		DMEMIT(" commit_time:%u", ic->autocommit_msec);
+		if (ic->mode == 'J') {
+			DMEMIT(" journal_watermark:%u", (unsigned)watermark_percentage);
+			DMEMIT(" commit_time:%u", ic->autocommit_msec);
+		}
 
 #define EMIT_ALG(a, n)							\
 		do {							\
