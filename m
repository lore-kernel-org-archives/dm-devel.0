From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 12 May 2008 18:48:04 -0000
Message-ID: <20080512184804.30321.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-05-12 18:48:03

Modified files:
	multipathd     : main.c 

Log message:
	Fix multipathd startup so -d option works correctly.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.6&r2=1.69.2.7

--- multipath-tools/multipathd/main.c	2008/05/12 17:45:28	1.69.2.6
+++ multipath-tools/multipathd/main.c	2008/05/12 18:48:03	1.69.2.7
@@ -1422,15 +1422,31 @@
 	umask(0);
 }
 
+enum child_flag_bits {
+	__DAEMONIZE = 0,
+#ifdef CLONE_NEWNS
+	__NEW_NS,
+#endif
+};
+
+#define DAEMONIZE	(1 << __DAEMONIZE)
+#ifdef CLONE_NEWNS
+#define NEW_NS		(1 << __NEW_NS)
+#endif
+
 static int
 child (void * param)
 {
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t attr;
 	struct vectors * vecs;
-	unsigned long new_ns = (unsigned long)param;
+	unsigned int daemon = (unsigned long)param & DAEMONIZE;
+#ifdef CLONE_NEWNS
+	unsigned int new_ns = (unsigned long)param & NEW_NS;
+#endif
 
-	setup_daemon();
+	if (daemon)
+		setup_daemon();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
 	if (logsink)
@@ -1583,11 +1599,11 @@
 #ifdef CLONE_NEWNS
 	if (unshare(CLONE_NEWNS) < 0) {
 		fprintf(stderr, "Failed to unshare namespace : %s\n", strerror(errno));
-		return child((void *)0);
+		return child((void *)DAEMONIZE);
 	}
-	return child((void *)1);
+	return child((void *)(DAEMONIZE | NEW_NS));
 #else
-	return child((void *)0);
+	return child((void *)DAEMONIZE);
 #endif
 }
 
