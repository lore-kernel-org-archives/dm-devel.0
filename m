From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/7] Minimize #include directives
Date: Wed, 27 Jul 2016 14:12:26 -0700
Message-ID: <1bcb463e-0220-8bc8-d603-632ad0bf91bf@sandisk.com>
References: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Remove unneeded #include directives. Correct the comments next to
the #include directives in multipathd/pidfile.c.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/lock.c   | 2 --
 libmultipath/lock.h   | 2 +-
 libmultipath/uevent.c | 1 -
 multipathd/pidfile.c  | 8 +++-----
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/libmultipath/lock.c b/libmultipath/lock.c
index ec53a5e..8d7b2ad 100644
--- a/libmultipath/lock.c
+++ b/libmultipath/lock.c
@@ -1,6 +1,4 @@
-#include <pthread.h>
 #include "lock.h"
-#include <stdio.h>
 
 void cleanup_lock (void * data)
 {
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 97af0f4..c569f01 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -1,7 +1,7 @@
 #ifndef _LOCK_H
 #define _LOCK_H
 
-#include <signal.h>
+#include <pthread.h>
 
 /*
  * Wrapper for the mutex. Includes a ref-count to keep
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 5f3204b..6247898 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -37,7 +37,6 @@
 #include <linux/types.h>
 #include <linux/netlink.h>
 #include <pthread.h>
-#include <signal.h>
 #include <limits.h>
 #include <sys/mman.h>
 #include <libudev.h>
diff --git a/multipathd/pidfile.c b/multipathd/pidfile.c
index 9bac1dd..47d18e2 100644
--- a/multipathd/pidfile.c
+++ b/multipathd/pidfile.c
@@ -1,11 +1,9 @@
 #include <sys/types.h> /* for pid_t */
 #include <sys/stat.h>  /* for open */
-#include <signal.h>    /* for kill() */
-#include <errno.h>     /* for ESHRC */
-#include <stdio.h>     /* for f...() */
+#include <errno.h>     /* for EACCESS and EAGAIN */
+#include <stdio.h>     /* for snprintf() */
 #include <string.h>    /* for memset() */
-#include <stdlib.h>    /* for atoi() */
-#include <unistd.h>    /* for unlink() */
+#include <unistd.h>    /* for ftruncate() */
 #include <fcntl.h>     /* for fcntl() */
 
 #include "debug.h"
-- 
2.9.2
