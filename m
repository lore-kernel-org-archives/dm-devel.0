From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/2] Allow the compiler to verify consistency of
	declarations and definitions
Date: Mon, 19 Mar 2018 09:23:50 -0700
Message-ID: <20180319162351.28950-2-bart.vanassche@wdc.com>
References: <20180319162351.28950-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319162351.28950-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Make sure that in every source file the header file is included that
declares the functions defined in that source file. This allows the
compiler to detect inconsistencies between source and header files.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 libmultipath/callout.c    | 1 +
 libmultipath/debug.c      | 1 +
 libmultipath/defaults.c   | 1 +
 libmultipath/dict.c       | 1 +
 libmultipath/dmparser.c   | 1 +
 libmultipath/hwtable.c    | 1 +
 libmultipath/propsel.c    | 1 +
 mpathpersist/main.c       | 1 +
 multipathd/cli_handlers.c | 1 +
 multipathd/uxclnt.c       | 1 +
 10 files changed, 10 insertions(+)

diff --git a/libmultipath/callout.c b/libmultipath/callout.c
index dc18e0200de8..d5ca27b1dd76 100644
--- a/libmultipath/callout.c
+++ b/libmultipath/callout.c
@@ -18,6 +18,7 @@
 #include "vector.h"
 #include "structs.h"
 #include "util.h"
+#include "callout.h"
 #include "debug.h"
 
 int execute_program(char *path, char *value, int len)
diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index f95a3e5f97f5..cbf1e5701952 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -12,6 +12,7 @@
 #include "vector.h"
 #include "config.h"
 #include "defaults.h"
+#include "debug.h"
 
 void dlog (int sink, int prio, const char * fmt, ...)
 {
diff --git a/libmultipath/defaults.c b/libmultipath/defaults.c
index e66532529dae..7130e56f99c4 100644
--- a/libmultipath/defaults.c
+++ b/libmultipath/defaults.c
@@ -3,6 +3,7 @@
  */
 #include <string.h>
 
+#include "defaults.h"
 #include "memory.h"
 
 char *
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ea273dd91962..ac9216c4c5f3 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -23,6 +23,7 @@
 #include <errno.h>
 #include <inttypes.h>
 #include "mpath_cmd.h"
+#include "dict.h"
 
 static int
 set_int(vector strvec, void *ptr)
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 783c934f1154..620f507dbecd 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -13,6 +13,7 @@
 #include "structs.h"
 #include "util.h"
 #include "debug.h"
+#include "dmparser.h"
 
 #define WORD_SIZE 64
 
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fe71d1427d55..fd439ae38e87 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -7,6 +7,7 @@
 #include "config.h"
 #include "pgpolicies.h"
 #include "prio.h"
+#include "hwtable.h"
 
 /*
  * Tuning suggestions on these parameters should go to
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 58a6a42fe333..06f2fd538835 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -22,6 +22,7 @@
 #include "sysfs.h"
 #include "prioritizers/alua_rtpg.h"
 #include "prkey.h"
+#include "propsel.h"
 #include <inttypes.h>
 #include <libudev.h>
 
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 79b89e5b035a..c51fa1d31db9 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -11,6 +11,7 @@
 #include <libudev.h>
 #include "mpath_persist.h"
 #include "main.h"
+#include "debug.h"
 #include <pthread.h>
 #include <ctype.h>
 #include <string.h>
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 60ec48b9904a..0de76b698013 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -28,6 +28,7 @@
 #include "cli.h"
 #include "uevent.h"
 #include "foreign.h"
+#include "cli_handlers.h"
 
 int
 show_paths (char ** r, int * len, struct vectors * vecs, char * style,
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index c5c32eacb380..08db0e884318 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -25,6 +25,7 @@
 
 #include "vector.h"
 #include "cli.h"
+#include "uxclnt.h"
 
 static void print_reply(char *s)
 {
-- 
2.16.2
