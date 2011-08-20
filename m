From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm space map: only include bitops.h in
	dm-space-map-common.c
Date: Fri, 19 Aug 2011 21:10:34 -0400
Message-ID: <1313802634-15884-2-git-send-email-snitzer@redhat.com>
References: <20110819161745.GA27778@ubuntu>
	<1313802634-15884-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1313802634-15884-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/persistent-data/dm-space-map-common.c   |    1 +
 drivers/md/persistent-data/dm-space-map-disk.c     |    1 -
 drivers/md/persistent-data/dm-space-map-metadata.c |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 90cc199..513ef86 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -1,6 +1,7 @@
 #include "dm-space-map-common.h"
 #include "dm-transaction-manager.h"
 
+#include <linux/bitops.h>
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "space map common"
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index ba917cd..dee112f 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -11,7 +11,6 @@
 
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/device-mapper.h>
 
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 49adf0d..1911c41 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -10,7 +10,6 @@
 
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/bitops.h>
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "space map metadata"
-- 
1.7.4.4
