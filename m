From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 2/2] dm clone: Explicitly include header file for
	kvmalloc()
Date: Thu, 12 Sep 2019 15:11:37 +0300
Message-ID: <20190912121137.26567-3-ntsironis@arrikto.com>
References: <20190912121137.26567-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190912121137.26567-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: vkoukis@arrikto.com, ntsironis@arrikto.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-clone-metadata.c | 1 +
 drivers/md/dm-clone-target.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index 50abc2fb4c7a..6bc8c1d1c351 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2019 Arrikto, Inc. All Rights Reserved.
  */
 
+#include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/rwsem.h>
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index f80250c3103e..cd6f9e9fc98e 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2019 Arrikto, Inc. All Rights Reserved.
  */
 
+#include <linux/mm.h>
 #include <linux/bio.h>
 #include <linux/err.h>
 #include <linux/hash.h>
-- 
2.11.0
