From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-integrity: Always set version on superblock
	update
Date: Wed, 22 May 2019 13:29:44 +0200
Message-ID: <20190522112944.26787-1-gmazyland@gmail.com>
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
Cc: mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

New integtiry bitmap mode uses the dirty flag.
This flag should not be set in older superblock versions.

The current code set it unconditionally, if the superblock
was already formatted without bitmap in older system.

This patch moves version check to one common place and does
check version on every superblock write.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-integrity.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 44e76cda087a..a2ab6a32b174 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -476,6 +476,9 @@ static int sync_rw_sb(struct dm_integrity_c *ic, int op, int op_flags)
 	io_loc.sector = ic->start;
 	io_loc.count = SB_SECTORS;
 
+	if (op == REQ_OP_WRITE)
+		sb_set_version(ic);
+
 	return dm_io(&io_req, 1, &io_loc, NULL);
 }
 
@@ -2317,7 +2320,6 @@ static void recalc_write_super(struct dm_integrity_c *ic)
 	if (dm_integrity_failed(ic))
 		return;
 
-	sb_set_version(ic);
 	r = sync_rw_sb(ic, REQ_OP_WRITE, 0);
 	if (unlikely(r))
 		dm_integrity_io_error(ic, "writing superblock", r);
-- 
2.20.1
