From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: regex.h and errno.h are
	standard headers
Date: Tue, 19 Jul 2016 22:54:35 +0200
Message-ID: <1468961675-8791-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/blacklist.h | 2 +-
 libmultipath/dict.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 24a5fa5..443025d 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -2,7 +2,7 @@
 #define _BLACKLIST_H
 
 #include <libudev.h>
-#include "regex.h"
+#include <regex.h>
 
 #define MATCH_NOTHING        0
 #define MATCH_WWID_BLIST     1
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 030ad98..1933b6d 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -19,7 +19,7 @@
 #include "blacklist.h"
 #include "defaults.h"
 #include "prio.h"
-#include "errno.h"
+#include <errno.h>
 #include <inttypes.h>
 #include "mpath_cmd.h"
 
-- 
2.7.4
