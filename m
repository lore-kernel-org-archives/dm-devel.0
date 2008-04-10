From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/3] dm: move dm_path to
	include/linux/device-mapper.h
Date: Thu, 10 Apr 2008 15:49:50 -0400 (EDT)
Message-ID: <20080410.154950.104028506.k-ueda@ct.jp.nec.com>
References: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch moves struct dm_path to include/linux/device-mapper.h
from drivers/md/dm-mpath.h.
No functional change.

Path selector is using struct dm_path as an interface structure
for multipath target.
By moving the interface to dm core, other targets can use
path selector.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.h         |   10 +---------
 drivers/md/dm-path-selector.h |    2 --
 include/linux/device-mapper.h |    8 ++++++++
 3 files changed, 9 insertions(+), 11 deletions(-)

Index: 2.6.25-rc8/drivers/md/dm-mpath.h
===================================================================
--- 2.6.25-rc8.orig/drivers/md/dm-mpath.h
+++ 2.6.25-rc8/drivers/md/dm-mpath.h
@@ -9,15 +9,7 @@
 #ifndef	DM_MPATH_H
 #define	DM_MPATH_H
 
-struct dm_dev;
-
-struct dm_path {
-	struct dm_dev *dev;	/* Read-only */
-	unsigned is_active;	/* Read-only */
-
-	void *pscontext;	/* For path-selector use */
-	void *hwhcontext;	/* For hw-handler use */
-};
+struct dm_path;
 
 /* Callback for hwh_pg_init_fn to use when complete */
 void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
Index: 2.6.25-rc8/drivers/md/dm-path-selector.h
===================================================================
--- 2.6.25-rc8.orig/drivers/md/dm-path-selector.h
+++ 2.6.25-rc8/drivers/md/dm-path-selector.h
@@ -14,8 +14,6 @@
 
 #include <linux/device-mapper.h>
 
-#include "dm-mpath.h"
-
 /*
  * We provide an abstraction for the code that chooses which path
  * to send some io down.
Index: 2.6.25-rc8/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc8.orig/include/linux/device-mapper.h
+++ 2.6.25-rc8/include/linux/device-mapper.h
@@ -146,6 +146,14 @@ struct dm_target {
 	char *error;
 };
 
+struct dm_path {
+	struct dm_dev *dev;	/* Read-only */
+	unsigned is_active;	/* Read-only */
+
+	void *pscontext;	/* For path-selector use */
+	void *hwhcontext;	/* For hw-handler use */
+};
+
 int dm_register_target(struct target_type *t);
 int dm_unregister_target(struct target_type *t);
 
