From: device-mapper@eckner.net
Subject: [PATCH] dm-integrity: print device name in integrity
	error message.
Date: Wed, 12 Feb 2020 11:43:10 +0100
Message-ID: <20200212104310.1014996-1-device-mapper@eckner.net>
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
To: dm-devel@redhat.com
Cc: Erich Eckner <git@eckner.net>
List-Id: dm-devel.ids

From: Erich Eckner <git@eckner.net>

Similar to f710126cfc89c8df477002a26dee8407eb0b4acd, this message should
also better identify the device with the integrity failure.
---
 drivers/md/dm-integrity.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b225b3e445fa..92f16315ee1b 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1563,7 +1563,9 @@ static void integrity_metadata(struct work_struct *w)
 						checksums_ptr - checksums, !dio->write ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
 				if (r > 0) {
-					DMERR_LIMIT("Checksum failed at sector 0x%llx",
+					char b[BDEVNAME_SIZE];
+					DMERR_LIMIT("%s: Checksum failed at sector 0x%llx",
+						    bio_devname(bio, b),
 						    (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
 					r = -EILSEQ;
 					atomic64_inc(&ic->number_of_mismatches);
-- 
2.25.0
