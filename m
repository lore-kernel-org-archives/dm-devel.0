From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults kpar ...
Date: 7 Mar 2011 05:19:39 -0000
Message-ID: <20110307051939.24609.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-03-07 05:19:38

Modified files:
	.              : multipath.conf.defaults 
	kpartx         : kpartx.c 
	libmultipath   : hwtable.c parser.c 
	multipathd     : main.c 

Log message:
	Fix for bugs 502813, 578109, 676165, 663179.  Multiple small cleanup bugzillas. Not applicable or already present upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.28&r2=1.5.4.29
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.3&r2=1.9.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.34&r2=1.20.2.35
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.2&r2=1.18.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.32&r2=1.69.2.33

--- multipath-tools/multipath.conf.defaults	2010/11/12 20:17:09	1.5.4.28
+++ multipath-tools/multipath.conf.defaults	2011/03/07 05:19:36	1.5.4.29
@@ -81,7 +81,7 @@
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
-#               no_path_retry		12 
+#               no_path_retry		18
 #		rr_min_io		100
 #		path_checker		tur
 #	}
@@ -100,7 +100,35 @@
 #        }
 #       device {
 #               vendor                  "HP"
-#               product                 "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME"
+#               product                 "MSA2012sa|MSA2312sa|MSA2324sa"
+#               getuid_callout          "/sbin/scsi_id -g -u -n -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               features                "0"
+#               hardware_handler        "0"
+#               path_grouping_policy    group_by_prio
+#               failback                immediate
+#               rr_weight               uniform
+#               no_path_retry           18
+#               rr_min_io               100
+#               path_checker            tur
+#        }
+#       device {
+#               vendor                  "HP"
+#               product                 "MSA2312fc|MSA2324fc|MSA2312i|MSA2324i|MSA2000s VOLUME"
+#               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               features                "0"
+#               hardware_handler        "0"
+#               path_grouping_policy    group_by_prio
+#               failback                immediate
+#               rr_weight               uniform
+#               no_path_retry           18
+#               rr_min_io               100
+#               path_checker            tur
+#        }
+#       device {
+#               vendor                  "HP"
+#               product                 "P2000 G3 FC"
 #               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
 #               features                "0"
@@ -122,7 +150,21 @@
 #               path_grouping_policy    group_by_prio
 #               failback                immediate
 #               rr_weight               uniform
-#               no_path_retry           12
+#               no_path_retry           18
+#               rr_min_io               100
+#               path_checker            tur
+#        }
+#       device {
+#               vendor                  "HP"
+#               product                 "HSVX740"
+#               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               features                "0"
+#               hardware_handler        "0"
+#               path_grouping_policy    group_by_prio
+#               failback                immediate
+#               rr_weight               uniform
+#               no_path_retry           18
 #               rr_min_io               100
 #               path_checker            tur
 #        }
@@ -146,6 +188,7 @@
 #               path_grouping_policy    multibus
 #		failback		immediate
 #		rr_weight		uniform
+#		no_path_retry		18
 #		rr_min_io		1000
 #		path_checker		tur
 #	}
--- multipath-tools/kpartx/kpartx.c	2009/10/01 22:53:11	1.9.2.3
+++ multipath-tools/kpartx/kpartx.c	2011/03/07 05:19:37	1.9.2.4
@@ -195,6 +195,7 @@
 	char *uuid = NULL;
 	int loopro = 0;
 	int hotplug = 0;
+	int loopcreated = 0;
 	struct stat buf;
 
 	initpts();
@@ -298,6 +299,7 @@
 				fprintf(stderr, "can't set up loop\n");
 				exit (1);
 			}
+			loopcreated = 1;
 		}
 		device = loopdev;
 	}
@@ -369,6 +371,15 @@
 					slices[j].size, device,
 				        slices[j].start);
 			}
+			if (loopcreated && S_ISREG (buf.st_mode)) {
+				if (del_loop(device)) {
+					if (verbose)
+						printf("can't del loop : %s\n",
+						       device);
+					exit(1);
+				}
+				printf("loop deleted : %s\n", device);
+			}
 			break;
 
 		case DELETE:
--- multipath-tools/libmultipath/hwtable.c	2010/11/12 20:17:12	1.20.2.34
+++ multipath-tools/libmultipath/hwtable.c	2011/03/07 05:19:38	1.20.2.35
@@ -118,7 +118,7 @@
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 12,
+		.no_path_retry = 18,
 		.minio         = 100,
 		.checker_name  = TUR,
 	},
@@ -139,9 +139,41 @@
 		.checker_name  = TUR,
 	},
 	{
-                 /* HP MSA2000 product family with new firmware */
+                 /* HP MSA2000sa product family with new firmware */
+                .vendor        = "HP",
+                .product       = "MSA2012sa|MSA2312sa|MSA2324sa",
+                .getuid        = "/sbin/scsi_id -g -u -n -s /block/%n",
+                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
+                .features      = DEFAULT_FEATURES,
+                .hwhandler     = DEFAULT_HWHANDLER,
+                .selector      = DEFAULT_SELECTOR,
+                .pgpolicy      = GROUP_BY_PRIO,
+                .pgfailback    = -FAILBACK_IMMEDIATE,
+                .rr_weight     = RR_WEIGHT_NONE,
+                .no_path_retry = 18,
+                .minio         = 100,
+                .checker_name  = TUR,
+        },
+	{
+                 /* HP MSA2000fc and MSA2000i product family with new firmware */
+                .vendor        = "HP",
+                .product       = "MSA2312fc|MSA2324fc|MSA2312i|MSA2324i|MSA2000s VOLUME",
+                .getuid        = DEFAULT_GETUID,
+                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
+                .features      = DEFAULT_FEATURES,
+                .hwhandler     = DEFAULT_HWHANDLER,
+                .selector      = DEFAULT_SELECTOR,
+                .pgpolicy      = GROUP_BY_PRIO,
+                .pgfailback    = -FAILBACK_IMMEDIATE,
+                .rr_weight     = RR_WEIGHT_NONE,
+                .no_path_retry = 18,
+                .minio         = 100,
+                .checker_name  = TUR,
+        },
+	{
+                 /* HP P2000 product family */
                 .vendor        = "HP",
-                .product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
+                .product       = "P2000 G3 FC",
                 .getuid        = DEFAULT_GETUID,
                 .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                 .features      = DEFAULT_FEATURES,
@@ -155,7 +187,7 @@
                 .checker_name  = TUR,
         },
 	{
-                 /* HP SVSP */
+                 /* HP SVSP Active-Standby */
                 .vendor        = "HP",
                 .product       = "HSVX700",
                 .getuid        = DEFAULT_GETUID,
@@ -166,11 +198,27 @@
                 .pgpolicy      = GROUP_BY_PRIO,
                 .pgfailback    = -FAILBACK_IMMEDIATE,
                 .rr_weight     = RR_WEIGHT_NONE,
-                .no_path_retry = 12,
+                .no_path_retry = 18,
                 .minio         = 100,
                 .checker_name  = TUR,
 	},
 	{
+                 /* HP SVSP Active-Active*/
+                .vendor        = "HP",
+                .product       = "HSVX740",
+                .getuid        = DEFAULT_GETUID,
+                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
+                .features      = DEFAULT_FEATURES,
+                .hwhandler     = DEFAULT_HWHANDLER,
+                .selector      = DEFAULT_SELECTOR,
+                .pgpolicy      = GROUP_BY_PRIO,
+                .pgfailback    = -FAILBACK_IMMEDIATE,
+                .rr_weight     = RR_WEIGHT_NONE,
+                .no_path_retry = 18,
+                .minio         = 100,
+                .checker_name  = TUR,
+        },
+	{
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
@@ -313,7 +361,7 @@
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 12,
+		.no_path_retry = 18,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
 	},
--- multipath-tools/libmultipath/parser.c	2010/08/27 21:02:08	1.18.2.2
+++ multipath-tools/libmultipath/parser.c	2011/03/07 05:19:38	1.18.2.3
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.18.2.2 2010/08/27 21:02:08 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.18.2.3 2011/03/07 05:19:38 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -501,7 +501,7 @@
 			}
 		}
 		if (i >= VECTOR_SIZE(keywords))
-			condlog(1, "mulipath.conf line %d, invalid keyword: %s",
+			condlog(1, "multipath.conf line %d, invalid keyword: %s",
 				line_nr, str);
 		
 		free_strvec(strvec);
--- multipath-tools/multipathd/main.c	2011/02/18 18:27:00	1.69.2.32
+++ multipath-tools/multipathd/main.c	2011/03/07 05:19:38	1.69.2.33
@@ -1356,7 +1356,8 @@
 		    strncmp(mnt, "/dev", 4) == 0 || strncmp(mnt, "/sys", 4) == 0 ||
 		    strcmp(mnt, "/var") == 0 || strncmp(mnt, "/var/lib", 8) == 0 ||
 		    strncmp(mnt, "/var/run", 8) == 0 || strncmp(mnt, "/lib", 4) == 0 ||
-		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0)
+		    strncmp(mnt, "/lib64", 6) == 0 || strncmp(mnt, "/usr/lib64", 10) == 0 ||
+		    strncmp(mnt, "/ram", 4) == 0)
 			continue;
 		if (umount2(mnt, MNT_DETACH) < 0 && errno != ENOENT) {
 			condlog(0, "failed to umount '%s' (%s). skipping", mnt, strerror(errno));
