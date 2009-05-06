From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] dm-table: fix printk formats
Date: Wed, 06 May 2009 14:54:46 -0700
Message-ID: <4A020726.3020009@oracle.com>
References: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/md/dm-table.c:408: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'
drivers/md/dm-table.c:414: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-table.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-next-20090506.orig/drivers/md/dm-table.c
+++ linux-next-20090506/drivers/md/dm-table.c
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
