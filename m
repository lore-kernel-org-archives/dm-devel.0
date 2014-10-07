From: heinzm@redhat.com
Subject: [PATCH] dm-raid: fix bug when round up region_size v2
Date: Tue,  7 Oct 2014 14:35:21 +0200
Message-ID: <1412685321-22796-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

If region_size is not supplied by userspace and the device is very
large, there is a bug in current code preventing region_size from being
correctly set.

This new version uses roundup_pow_of_two() for optimization
as proposed by Neil Brown.


Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..595afd5 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -7,6 +7,7 @@
 
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/log2.h>
 
 #include "md.h"
 #include "raid1.h"
@@ -325,13 +326,11 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 		 */
 		if (min_region_size > (1 << 13)) {
 			/* If not a power of 2, make it the next power of 2 */
-			if (min_region_size & (min_region_size - 1))
-				region_size = 1 << fls(region_size);
-			DMINFO("Choosing default region size of %lu sectors",
-			       region_size);
+			region_size = roundup_pow_of_two(min_region_size);
+			DMINFO("Choosing region size of %lu sectors", region_size);
 		} else {
-			DMINFO("Choosing default region size of 4MiB");
 			region_size = 1 << 13; /* sectors */
+			DMINFO("Choosing default region size of 4MiB");
 		}
 	} else {
 		/*
-- 
1.9.3
