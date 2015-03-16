From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 39/78] multipath: Use standard 'major' macro
Date: Mon, 16 Mar 2015 13:36:26 +0100
Message-ID: <1426509425-15978-40-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of carrying our own hand-crafted macros we should be using
the system-provided 'major' macro.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/dev_t.h | 3 ---
 multipath/main.c  | 3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)
 delete mode 100644 multipath/dev_t.h

diff --git a/multipath/dev_t.h b/multipath/dev_t.h
deleted file mode 100644
index aa80d5e..0000000
--- a/multipath/dev_t.h
+++ /dev/null
@@ -1,3 +0,0 @@
-#define MAJOR(dev)      ((dev & 0xfff00) >> 8)
-#define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
-#define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
diff --git a/multipath/main.c b/multipath/main.c
index ce8fb5b..1c1191a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -57,7 +57,6 @@
 #include <sys/resource.h>
 #include <wwids.h>
 #include <uxsock.h>
-#include "dev_t.h"
 
 int logsink;
 
@@ -454,7 +453,7 @@ get_dev_type(char *dev) {
 	int i;
 
 	if (stat(dev, &buf) == 0 && S_ISBLK(buf.st_mode)) {
-		if (dm_is_dm_major(MAJOR(buf.st_rdev)))
+		if (dm_is_dm_major(major(buf.st_rdev)))
 			return DEV_DEVMAP;
 		return DEV_DEVNODE;
 	}
-- 
1.8.4.5
