From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/12] kpartx: include sys/sysmacros.h
Date: Mon, 15 May 2017 17:37:22 +0200
Message-ID: <20170515153722.11508-13-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Finish the work started in ea436715. Fixes a compilation warning.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/lopart.c    | 2 +-
 kpartx/sysmacros.h | 9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)
 delete mode 100644 kpartx/sysmacros.h

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 0521d7dc..70054459 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -27,7 +27,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <dirent.h>
-#include "sysmacros.h"
+#include <sys/sysmacros.h>
 #include <linux/loop.h>
 
 #include "lopart.h"
diff --git a/kpartx/sysmacros.h b/kpartx/sysmacros.h
deleted file mode 100644
index 171b33d4..00000000
--- a/kpartx/sysmacros.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* versions to be used with > 16-bit dev_t - leave unused for now */
-
-#ifndef major
-#define major(dev)	((dev) >> 8)
-#endif
-
-#ifndef minor
-#define minor(dev)	((dev) & 0xff)
-#endif
-- 
2.12.2
