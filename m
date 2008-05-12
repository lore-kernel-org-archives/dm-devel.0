From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c clone_platform.h
Date: 12 May 2008 17:45:29 -0000
Message-ID: <20080512174529.22145.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-05-12 17:45:28

Modified files:
	multipathd     : main.c 
Removed files:
	multipathd     : clone_platform.h 

Log message:
	Better fix for 355961. Instead of using clone(), use fork() and unshare()

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.5&r2=1.69.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/clone_platform.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.1&r2=NONE

--- multipath-tools/multipathd/main.c	2008/01/15 01:34:36	1.69.2.5
+++ multipath-tools/multipathd/main.c	2008/05/12 17:45:28	1.69.2.6
@@ -60,7 +60,6 @@
 #include "cli_handlers.h"
 #include "lock.h"
 #include "waiter.h"
-#include "clone_platform.h"
 #include "copy.h"
 
 #define FILE_NAME_SIZE 256
@@ -1537,8 +1536,6 @@
 	vecs->lock = NULL;
 	FREE(vecs);
 	vecs = NULL;
-	free_config(conf);
-	conf = NULL;
 
 	condlog(2, "--------shut down-------");
 	
@@ -1548,6 +1545,14 @@
 	dm_lib_release();
 	dm_lib_exit();
 
+	/*
+	 * Freeing config must be done after condlog() and dm_lib_exit(),
+	 * because logging functions like dlog() and dm_write_log()
+	 * reference the config.
+	 */
+	free_config(conf);
+	conf = NULL;
+
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
@@ -1559,9 +1564,6 @@
 daemonize(void)
 {
 	int pid;
-#ifdef CLONE_NEWNS
-	void *child_stack;
-#endif
 
 	if( (pid = fork()) < 0){
 		fprintf(stderr, "Failed first fork : %s\n", strerror(errno));
@@ -1572,35 +1574,19 @@
 
 	setsid();
 
-#ifdef CLONE_NEWNS
-
-	child_stack = (void *)malloc(CHILD_STACK_SIZE);
-	if (!child_stack) {
-		fprintf(stderr, "Failed to allocate child stack : %s\n",
-			strerror(errno));
-		_exit(1);
-	}
-#  if defined(__hppa__) || defined(__powerpc64__)
-	pid = clone(child, child_stack, CLONE_NEWNS, (void *)1);
-#  elif defined(__ia64__)
-	pid = clone2(child, child_stack, CHILD_STACK_SIZE, CLONE_NEWNS,
-	             (void *)1, NULL, NULL, NULL);
-#  else
-	pid = clone(child, child_stack + CHILD_STACK_SIZE, CLONE_NEWNS,
-	            (void *)1);
-#  endif
-	if (pid < 0) {
-		fprintf(stderr, "Clone failed : %s\n", strerror(errno));
-		_exit(1);
-	}
-	_exit(0);
-#else
 	if ( (pid = fork()) < 0){
 		fprintf(stderr, "Failed second fork : %s\n", strerror(errno));
 		_exit(1);
 	}
 	if (pid != 0)
 		_exit(0);
+#ifdef CLONE_NEWNS
+	if (unshare(CLONE_NEWNS) < 0) {
+		fprintf(stderr, "Failed to unshare namespace : %s\n", strerror(errno));
+		return child((void *)0);
+	}
+	return child((void *)1);
+#else
 	return child((void *)0);
 #endif
 }
