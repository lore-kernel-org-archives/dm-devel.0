From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: all kstrto* consumers should include kernel.h
Date: Fri,  3 Aug 2012 13:06:34 -0400
Message-ID: <1344013594-13898-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Commit 1a66a08ae8 ("dm: replace simple_strtoul") should've included
<linux/kernel.h>.  Likewise for commit 991d9fa0 ("dm: add thin
provisioning target").

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.c |    1 +
 drivers/md/dm-stripe.c          |    1 +
 drivers/md/dm-thin.c            |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index ebaa4f8..4ddcd8a 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a087bf2..0a70334 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -7,6 +7,7 @@
 #include <linux/device-mapper.h>
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index af1fc3b..c961efd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -7,6 +7,7 @@
 #include "dm-thin-metadata.h"
 #include "dm.h"
 
+#include <linux/kernel.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
-- 
1.7.4.4
