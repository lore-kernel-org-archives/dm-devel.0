From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: memory.h is referred to the
	local header
Date: Wed, 20 Jul 2016 15:15:49 +0200
Message-ID: <1469020549-10327-1-git-send-email-xose.vazquez@gmail.com>
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

It could be removed from these files because it's already included in
the hierarchy of the headers. As it's shown in the headers tree,
(multipathd/cli.c): https://drive.google.com/file/d/0B_B6YmEmO7cDeWVaMDViekRldW8

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/log_pthread.c               | 2 +-
 libmultipath/prioritizers/weightedpath.c | 2 +-
 multipath/main.c                         | 2 +-
 multipathd/cli.c                         | 2 +-
 multipathd/cli_handlers.c                | 2 +-
 multipathd/main.c                        | 2 +-
 multipathd/uxlsnr.c                      | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index e6f4b5c..380ab89 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -8,7 +8,7 @@
 #include <pthread.h>
 #include <sys/mman.h>
 
-#include <memory.h>
+#include "memory.h"
 
 #include "log_pthread.h"
 #include "log.h"
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 406cef5..4bf2a1e 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -29,7 +29,7 @@
 #include "weightedpath.h"
 #include "config.h"
 #include "structs.h"
-#include <memory.h>
+#include "memory.h"
 #include "debug.h"
 #include <regex.h>
 #include "structs_vec.h"
diff --git a/multipath/main.c b/multipath/main.c
index 7dba54e..6ccece7 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -33,7 +33,7 @@
 #include "checkers.h"
 #include "prio.h"
 #include "vector.h"
-#include <memory.h>
+#include "memory.h"
 #include <libdevmapper.h>
 #include "devmapper.h"
 #include "util.h"
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 4a7b24d..8b4824c 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -4,7 +4,7 @@
 #include <sys/time.h>
 #include <errno.h>
 #include <pthread.h>
-#include <memory.h>
+#include "memory.h"
 #include "vector.h"
 #include "structs.h"
 #include "structs_vec.h"
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 1b046c4..f613233 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2005 Christophe Varoqui
  */
 #include "checkers.h"
-#include <memory.h>
+#include "memory.h"
 #include "vector.h"
 #include "structs.h"
 #include "structs_vec.h"
diff --git a/multipathd/main.c b/multipathd/main.c
index fb37f0d..1799cbe 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -40,7 +40,7 @@ int uxsock_timeout;
  */
 #include "parser.h"
 #include "vector.h"
-#include <memory.h>
+#include "memory.h"
 #include "config.h"
 #include "util.h"
 #include "hwtable.h"
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 4fce585..8ab55ea 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -23,7 +23,7 @@
 #include <sys/time.h>
 #include <signal.h>
 #include "checkers.h"
-#include <memory.h>
+#include "memory.h"
 #include "debug.h"
 #include "vector.h"
 #include "structs.h"
-- 
2.7.4
