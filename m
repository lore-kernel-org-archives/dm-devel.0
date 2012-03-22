From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 22 Mar 2012 18:02:35 -0000
Message-ID: <20120322180235.1349.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2012-03-22 18:02:34

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bz803849.  applying patch from John Ruemker. multipathd was not
	correctly unmounting all unnecessary devices from its private namespace.
	Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.39&r2=1.69.2.40

--- multipath-tools/multipathd/main.c	2011/10/27 21:36:20	1.69.2.39
+++ multipath-tools/multipathd/main.c	2012/03/22 18:02:34	1.69.2.40
@@ -1377,17 +1377,27 @@
 {
 	char buf[LINE_MAX];
 	FILE *file;
+	vector extra_devs;
+	char *slot;
+	int s;
 
 	file = fopen("/proc/mounts", "r");
 	if (!file) {
 		condlog(0, "couldn't open /proc/mounts : %s", strerror(errno));
 		return -1;
 	}
+
+	extra_devs = vector_alloc();
+	if (!extra_devs) {
+		condlog(0, "couldn't allocate vector for extra devs\n");
+		return -1;
+	}
+
 	find_keep_dirs();
 	while (fgets(buf, LINE_MAX, file)) {
 		int i;
 		char *keep;
-		char *end, *mnt = strchr(buf, ' ');
+		char *end, *extra, *mnt = strchr(buf, ' ');
 		if (!mnt)
 			continue;
 		mnt++;
@@ -1418,13 +1428,26 @@
 		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0 ||
 		    strncmp(mnt, "/ram", 4) == 0)
 			continue;
-		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT)
-			condlog(0, "failed to umount '%s' (%s). skipping", mnt,
-				strerror(errno));
+		if (!vector_alloc_slot(extra_devs)) {
+			condlog(2, "couldn't allocate vector slot for extra dev (%s). "
+				"skipping,", mnt);
+			continue;
+ 		}
+		extra = strdup(mnt);
+		vector_set_slot(extra_devs, extra);
 next:
 		;
 	}
 	fclose(file);
+
+	vector_foreach_slot(extra_devs, slot, s) {
+	        if (umount2(slot, MNT_DETACH) < 0 && errno != ENOENT) {
+                        condlog(0, "failed to umount '%s' (%s). skipping",
+				slot, strerror(errno));
+                }
+		free(slot);
+	}
+	vector_free(extra_devs);
 	return 0;
 }	
 	
