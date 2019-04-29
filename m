From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 03/10] dm-integrity: introduce rw_journal_sectors
Date: Mon, 29 Apr 2019 14:57:19 +0200
Message-ID: <20190429125739.682320200@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-journal_rw.patch
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

Introduce a function rw_journal_sectors that takess sector and length as
its arguments instead of a section and the number of sections.

This functions will be used in further patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-03-25 16:04:46.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2019-03-25 16:08:31.000000000 +0100
@@ -761,12 +761,12 @@ static void complete_journal_io(unsigned
 	complete_journal_op(comp);
 }
 
-static void rw_journal(struct dm_integrity_c *ic, int op, int op_flags, unsigned section,
-		       unsigned n_sections, struct journal_completion *comp)
+static void rw_journal_sectors(struct dm_integrity_c *ic, int op, int op_flags,
+			       unsigned sector, unsigned n_sectors, struct journal_completion *comp)
 {
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
-	unsigned sector, n_sectors, pl_index, pl_offset;
+	unsigned pl_index, pl_offset;
 	int r;
 
 	if (unlikely(dm_integrity_failed(ic))) {
@@ -775,9 +775,6 @@ static void rw_journal(struct dm_integri
 		return;
 	}
 
-	sector = section * ic->journal_section_sectors;
-	n_sectors = n_sections * ic->journal_section_sectors;
-
 	pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
 	pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
@@ -810,6 +807,17 @@ static void rw_journal(struct dm_integri
 	}
 }
 
+static void rw_journal(struct dm_integrity_c *ic, int op, int op_flags, unsigned section,
+		       unsigned n_sections, struct journal_completion *comp)
+{
+	unsigned sector, n_sectors;
+
+	sector = section * ic->journal_section_sectors;
+	n_sectors = n_sections * ic->journal_section_sectors;
+
+	rw_journal_sectors(ic, op, op_flags, sector, n_sectors, comp);
+}
+
 static void write_journal(struct dm_integrity_c *ic, unsigned commit_start, unsigned commit_sections)
 {
 	struct journal_completion io_comp;
