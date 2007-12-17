From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/checkers.c libchec ...
Date: 17 Dec 2007 22:27:43 -0000
Message-ID: <20071217222743.32514.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-12-17 22:27:38

Modified files:
	libcheckers    : checkers.c checkers.h directio.c 
	multipathd     : main.c 

Log message:
	Applied patch from bz 354661. backport async checker code from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/directio.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.1&r2=1.3.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.3&r2=1.69.2.4

--- multipath-tools/libcheckers/checkers.c	2007/06/18 17:37:18	1.1.2.2
+++ multipath-tools/libcheckers/checkers.c	2007/12/17 22:27:37	1.1.2.3
@@ -14,6 +14,7 @@
 static struct checker checkers[] = {
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = DIRECTIO,
 		.message    = "",
 		.context    = NULL,
@@ -23,6 +24,7 @@
 	},
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = TUR,
 		.message    = "",
 		.context    = NULL,
@@ -32,6 +34,7 @@
 	},
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = HP_SW,
 		.message    = "",
 		.context    = NULL,
@@ -41,6 +44,7 @@
 	},
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = EMC_CLARIION,
 		.message    = "",
 		.context    = NULL,
@@ -50,6 +54,7 @@
 	},
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = RDAC,
 		.message    = "",
 		.context    = NULL,
@@ -59,6 +64,7 @@
 	},
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = READSECTOR0,
 		.message    = "",
 		.context    = NULL,
@@ -68,6 +74,7 @@
 	},
 	{
 		.fd         = 0,
+		.sync       = 1,
 		.name       = CCISS_TUR,
 		.message    = "",
 		.context    = NULL,
@@ -75,7 +82,7 @@
 		.init       = cciss_tur_init,
 		.free       = cciss_tur_free
 	},
-	{0, "", "", NULL, NULL, NULL, NULL},
+	{0, 1, "", "", NULL, NULL, NULL, NULL},
 };
 
 void checker_set_fd (struct checker * c, int fd)
@@ -83,6 +90,16 @@
 	c->fd = fd;
 }
 
+void checker_set_sync (struct checker * c)
+{
+	c->sync = 1;
+}
+
+void checker_set_async (struct checker * c)
+{
+	c->sync = 0;
+}
+
 struct checker * checker_lookup (char * name)
 {
 	struct checker * c = &checkers[0];
@@ -143,6 +160,7 @@
 void checker_get (struct checker * dst, struct checker * src)
 {
 	dst->fd = src->fd;
+	dst->sync = src->sync;
 	strncpy(dst->name, src->name, CHECKER_NAME_LEN);
 	strncpy(dst->message, src->message, CHECKER_MSG_LEN);
 	dst->check = src->check;
--- multipath-tools/libcheckers/checkers.h	2007/06/18 17:37:18	1.5.2.2
+++ multipath-tools/libcheckers/checkers.h	2007/12/17 22:27:37	1.5.2.3
@@ -10,6 +10,7 @@
 #define PATH_UP		2
 #define PATH_SHAKY	3
 #define PATH_GHOST	4
+#define PATH_PENDING	5
 
 #define DIRECTIO     "directio"
 #define TUR          "tur"
@@ -45,6 +46,7 @@
 
 struct checker {
 	int fd;
+	int sync;
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
 	void * context;                      /* store for persistent data */
@@ -59,6 +61,8 @@
 void checker_put (struct checker *);
 void checker_reset (struct checker * c);
 void checker_set_fd (struct checker *, int);
+void checker_set_sync (struct checker *);
+void checker_set_async (struct checker *);
 struct checker * checker_lookup (char *);
 int checker_check (struct checker *);
 int checker_selected (struct checker *);
--- multipath-tools/libcheckers/directio.c	2007/06/12 21:07:46	1.3.2.1
+++ multipath-tools/libcheckers/directio.c	2007/12/17 22:27:37	1.3.2.2
@@ -19,9 +19,12 @@
 #include "checkers.h"
 #include "../libmultipath/debug.h"
 
+#define DIRECTIO_TIMEOUT	30
+
 #define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
 #define MSG_DIRECTIO_UP		"directio checker reports path is up"
 #define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
+#define MSG_DIRECTIO_PENDING	"directio checker waits for I/O"
 
 struct directio_context {
 	int		running;
@@ -115,9 +118,9 @@
 }
 
 static int
-check_state(int fd, struct directio_context *ct)
+check_state(int fd, struct directio_context *ct, int sync)
 {
-	struct timespec	timeout = { .tv_sec = 2 };
+	struct timespec	timeout = { .tv_sec = 1 };
 	struct io_event event;
 	struct stat	sb;
 	int		rc = PATH_UNCHECKED;
@@ -127,6 +130,11 @@
 		condlog(4, "directio: called for %x", (unsigned) sb.st_rdev);
 	}
 
+	if (sync) {
+		condlog(4, "directio: synchronous mode");
+		timeout.tv_sec = DIRECTIO_TIMEOUT;
+	}
+
 	if (!ct->running) {
 		struct iocb *ios[1] = { &ct->io };
 
@@ -138,10 +146,14 @@
 			return PATH_UNCHECKED;
 		}
 	}
-	ct->running = 1;
+	ct->running++;
 
 	r = syscall(__NR_io_getevents, ct->ioctx, 1L, 1L, &event, &timeout);
 	if (r < 1L) {
+		if (ct->running < DIRECTIO_TIMEOUT && !sync)
+			return PATH_PENDING;
+		ct->running = DIRECTIO_TIMEOUT;
+
 		condlog(3, "directio: timeout r=%li errno=%i", r, errno);
 		rc = PATH_DOWN;
 	} else {
@@ -162,7 +174,7 @@
 	if (!ct)
 		return PATH_UNCHECKED;
 
-	ret = check_state(c->fd, ct);
+	ret = check_state(c->fd, ct, c->sync);
 
 	switch (ret)
 	{
@@ -175,6 +187,8 @@
 	case PATH_UP:
 		MSG(c, MSG_DIRECTIO_UP);
 		break;
+	case PATH_PENDING:
+		MSG(c, MSG_DIRECTIO_PENDING);
 	default:
 		break;
 	}
--- multipath-tools/multipathd/main.c	2007/12/15 00:27:40	1.69.2.3
+++ multipath-tools/multipathd/main.c	2007/12/17 22:27:38	1.69.2.4
@@ -918,6 +918,13 @@
 				condlog(0, "%s: checker is not set", pp->dev);
 				continue;
 			}
+
+			/*
+			 * Set checker in async mode.
+			 * Honored only by checker implementing the said mode.
+			 */
+			checker_set_async(&pp->checker);
+
 			newstate = checker_check(&pp->checker);
 			
 			if (newstate < 0) {
@@ -926,6 +933,16 @@
 				continue;
 			}
 
+			/*
+			 * Async IO in flight. Keep the previous path state
+			 * and reschedule as soon as possible.
+			 */
+			if (newstate == PATH_PENDING) {
+				condlog(4, "%s: pending path", pp->dev);
+				pp->tick = 1;
+				continue;
+			}
+
 			if (newstate != pp->state) {
 				int oldstate = pp->state;
 				pp->state = newstate;
