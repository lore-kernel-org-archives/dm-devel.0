From: akpm@linux-foundation.org
Subject: [patch 1/1] dm-table: fix printk formats
Date: Tue, 12 May 2009 13:37:44 -0700
Message-ID: <200905122057.n4CKv0mZ003266@imap1.linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: randy.dunlap@oracle.com, dm-devel@redhat.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/md/dm-table.c:408: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'
drivers/md/dm-table.c:414: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-table.c~dm-table-fix-printk-formats drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~dm-table-fix-printk-formats
+++ a/drivers/md/dm-table.c
@@ -405,14 +405,16 @@ static int device_area_is_valid(struct d
 		return 1;
 
 	if (start & (hardsect_size_sectors - 1)) {
-		DMWARN("%s: start=%lu not aligned to h/w sector of %s",
-		       dm_device_name(ti->table->md), start, bdevname(bdev, b));
+		DMWARN("%s: start=%llu not aligned to h/w sector of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)start, bdevname(bdev, b));
 		return 0;
 	}
 
 	if (len & (hardsect_size_sectors - 1)) {
-		DMWARN("%s: len=%lu not aligned to h/w sector size %hu of %s",
-		       dm_device_name(ti->table->md), len,
+		DMWARN("%s: len=%llu not aligned to h/w sector size %hu of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)len,
 		       ti->limits.hardsect_size, bdevname(bdev, b));
 		return 0;
 	}
_
