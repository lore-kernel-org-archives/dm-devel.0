From: Jan Blunck <jblunck@suse.de>
Subject: [patch 05/11] dm-snap: remove SECTOR_SHIFT define
Date: Fri, 10 Aug 2007 22:02:09 +0200
Message-ID: <45371.1087270223$1186776757@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-snap-remove-SECTOR_SHIFT.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Sector size on Linux is always 512 bytes. Don't even try to give the
impression this is changeable.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-exception-store.c |    8 ++++----
 drivers/md/dm-snap.h            |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -139,7 +139,7 @@ static int alloc_area(struct pstore *ps)
 	int r = -ENOMEM;
 	size_t len;
 
-	len = ps->snap->chunk_size << SECTOR_SHIFT;
+	len = ps->snap->chunk_size << 9;
 
 	/*
 	 * Allocate the chunk_size block of memory that will hold
@@ -230,7 +230,7 @@ static int area_io(struct pstore *ps, ui
 
 static int zero_area(struct pstore *ps, uint32_t area)
 {
-	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->snap->chunk_size << 9);
 	return area_io(ps, area, WRITE);
 }
 
@@ -315,7 +315,7 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->snap->chunk_size << 9);
 
 	dh = (struct disk_header *) ps->area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
@@ -462,7 +462,7 @@ static int persistent_read_metadata(stru
 	/*
 	 * Now we know correct chunk_size, complete the initialisation.
 	 */
-	ps->exceptions_per_area = (ps->snap->chunk_size << SECTOR_SHIFT) /
+	ps->exceptions_per_area = (ps->snap->chunk_size << 9) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
 			sizeof(*ps->callbacks));
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -139,7 +139,7 @@ int dm_create_transient(struct exception
  */
 static inline sector_t get_dev_size(struct block_device *bdev)
 {
-	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	return bdev->bd_inode->i_size >> 9;
 }
 
 static inline chunk_t sector_to_chunk(struct dm_snapshot *s, sector_t sector)

-- 
