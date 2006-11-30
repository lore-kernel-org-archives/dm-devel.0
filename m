From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.c libmulti ...
Date: 30 Nov 2006 23:25:14 -0000
Message-ID: <20061130232514.27363.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-11-30 23:25:13

Modified files:
	libmultipath   : config.c dmparser.c 
	multipath      : Makefile main.c multipath.8 
	path_priority/pp_alua: main.c 

Log message:
	Fixes for bzs 215971, 215973, 216033, 217972, and 215001
	
	215973, 216033, 215001 are SELinux issues. The SELinux policy is fixed in
	selinux-policy-2.4.3-10, this simply makes the multipath install create the
	/var/lib/multipath directory, so that it works with SELinux better.
	
	215971, and 217972 have fixes pulled from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dmparser.c.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&r1=1.16&r2=1.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&r1=1.43&r2=1.44
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.8.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/main.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- multipath-tools/libmultipath/config.c	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/config.c	2006/11/30 23:25:13	1.19
@@ -20,6 +20,25 @@
 #include "blacklist.h"
 #include "defaults.h"
 
+static struct hwentry *
+find_hwe_strmatch (vector hwtable, char * vendor, char * product)
+{
+	int i;
+	struct hwentry *hwe, *ret = NULL;
+
+	vector_foreach_slot (hwtable, hwe, i) {
+		if (hwe->vendor && vendor && strcmp(hwe->vendor, vendor))
+			continue;
+
+		if (hwe->product && product && strcmp(hwe->product, product))
+			continue;
+
+		ret = hwe;
+		break;
+	}
+	return ret;
+}
+
 struct hwentry *
 find_hwe (vector hwtable, char * vendor, char * product)
 {
@@ -222,7 +241,7 @@
 {
 	struct hwentry * hwe;
 
-	if (dup_hwe(hwtable, dhwe->vendor, dhwe->product))
+	if (find_hwe_strmatch(hwtable, dhwe->vendor, dhwe->product))
 		return 0;
 	
 	if (!(hwe = alloc_hwe()))
--- multipath-tools/libmultipath/dmparser.c	2006/06/06 18:32:43	1.12
+++ multipath-tools/libmultipath/dmparser.c	2006/11/30 23:25:13	1.13
@@ -84,11 +84,14 @@
 		freechar -= shift;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (mp->rr_weight == RR_WEIGHT_PRIO && pp->priority)
-				minio *= pp->priority;
+			int tmp_minio = minio;
+
+			if (mp->rr_weight == RR_WEIGHT_PRIO
+			    && pp->priority > 0)
+				tmp_minio = minio * pp->priority;
 
 			shift = snprintf(p, freechar, " %s %d",
-					 pp->dev_t, minio);
+					 pp->dev_t, tmp_minio);
 			if (shift >= freechar) {
 				fprintf(stderr, "mp->params too small\n");
 				return 1;
@@ -117,6 +120,7 @@
 	int num_pg_args = 0;
 	int num_paths = 0;
 	int num_paths_args = 0;
+	int def_minio = 0;
 	struct path * pp;
 	struct pathgroup * pgp;
 
@@ -305,12 +309,15 @@
 				if (k == 0 && !strncmp(mpp->selector,
 						       "round-robin", 11)) {
 					p += get_word(p, &word);
-					mpp->minio = atoi(word);
+					def_minio = atoi(word);
 
-					if (mpp->rr_weight)
-						mpp->minio /= mpp->rr_weight;
+					if (mpp->rr_weight == RR_WEIGHT_PRIO
+					    && pp->priority > 0)
+						def_minio /= pp->priority;
 
 					FREE(word);
+					if (def_minio != mpp->minio)
+						mpp->minio = def_minio;
 				}
 				else
 					p += get_word(p, NULL);
--- multipath-tools/multipath/Makefile	2006/10/12 16:16:09	1.16
+++ multipath-tools/multipath/Makefile	2006/11/30 23:25:13	1.17
@@ -44,6 +44,7 @@
 	@if [ ! -e $(DESTDIR)/etc/multipath.conf ]; then \
 		install -m 644 multipath.conf.redhat  $(DESTDIR)/etc/multipath.conf; \
 	fi
+	install -d $(DESTDIR)/var/lib/multipath
 
 uninstall:
 	rm $(DESTDIR)/etc/udev/rules.d/40-multipath.rules
--- multipath-tools/multipath/main.c	2006/09/15 18:08:03	1.43
+++ multipath-tools/multipath/main.c	2006/11/30 23:25:13	1.44
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.43 2006/09/15 18:08:03 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44 2006/11/30 23:25:13 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -72,7 +72,7 @@
 usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
-	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-l|-ll|-f|-F]\n",
+	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F]\n",
 		progname);
 	fprintf (stderr,
 		"\t\t\t[-p failover|multibus|group_by_serial|group_by_prio]\n" \
@@ -83,6 +83,7 @@
 		"\t   1\t\t\tprint created devmap names only\n" \
 		"\t   2\t\t\tdefault verbosity\n" \
 		"\t   3\t\t\tprint debug information\n" \
+		"\t-h\t\tprint this usage text\n" \
 		"\t-b file\t\tbindings file location\n" \
 		"\t-d\t\tdry run, do not create or update devmaps\n" \
 		"\t-l\t\tshow multipath topology (sysfs and DM info)\n" \
@@ -323,7 +324,7 @@
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dl::FfM:v:p:b:")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -366,6 +367,8 @@
 				usage(argv[0]);
 			}                
 			break;
+		case 'h':
+			usage(argv[0]);
 		case ':':
 			fprintf(stderr, "Missing option arguement\n");
 			usage(argv[0]);        
--- multipath-tools/multipath/multipath.8	2006/09/15 18:08:03	1.8
+++ multipath-tools/multipath/multipath.8	2006/11/30 23:25:13	1.9
@@ -6,7 +6,7 @@
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-d \|]
-.RB [\| \-l | \-ll | \-f | \-F \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-F \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -29,6 +29,9 @@
 print all info : detected paths, coalesced paths (ie multipaths) and device maps
 .RE
 .TP
+.B \-h
+print usage text
+.TP
 .B \-d
 dry run, do not create or update devmaps
 .TP
--- multipath-tools/path_priority/pp_alua/main.c	2005/10/12 21:57:26	1.2
+++ multipath-tools/path_priority/pp_alua/main.c	2006/11/30 23:25:13	1.3
@@ -12,8 +12,6 @@
  * 
  * This file is released under the GPL.
  */
-#include <linux/kdev_t.h>
-
 #include <sys/types.h>
 #include <sys/stat.h>
 
@@ -241,7 +239,7 @@
 			mknod(
 				devicepath,
 				S_IFBLK|S_IRUSR|S_IWUSR,
-				MKDEV(major, minor)
+				makedev(major, minor)
 			);
 			
 		}
