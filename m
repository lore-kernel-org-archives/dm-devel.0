From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace remaining leading
	spaces with tabs
Date: Tue, 26 Jul 2016 01:10:03 +0200
Message-ID: <1469488203-24448-1-git-send-email-xose.vazquez@gmail.com>
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

spotted by checkpatch.pl

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/dasd.c            |  4 ++--
 kpartx/lopart.c          | 32 +++++++++++++++-----------------
 libmultipath/devmapper.c |  2 +-
 mpathpersist/main.c      |  2 +-
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 0cd2002..faf5e2e 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -233,7 +233,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			    || EBCtoASC[f1.DS1FMTID] == '5'
 			    || EBCtoASC[f1.DS1FMTID] == '7'
 			    || EBCtoASC[f1.DS1FMTID] == '9') {
-			        blk++;
+				blk++;
 				continue;
 			}
 
@@ -243,7 +243,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 				break;
 
 			/* OK, we got valid partition data */
-		        offset = cchh2blk(&f1.DS1EXT1.llimit, &geo);
+			offset = cchh2blk(&f1.DS1EXT1.llimit, &geo);
 			size  = cchh2blk(&f1.DS1EXT1.ulimit, &geo) -
 				offset + geo.sectors;
 			sp[counter].start = sectors512(offset, blocksize);
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index e8e3f08..5d20450 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -211,23 +211,21 @@ find_unused_loop_device (void)
 		fprintf(stderr, "mount: could not find any device /dev/loop#");
 
 	else if (!someloop) {
-	    if (loop_known == 1)
-		fprintf(stderr,
-		    "mount: Could not find any loop device.\n"
-		    "       Maybe /dev/loop# has a wrong major number?");
-	    else if (loop_known == -1)
-		fprintf(stderr,
-		    "mount: Could not find any loop device, and, according to %s,\n"
-		    "       this kernel does not know about the loop device.\n"
-		    "       (If so, then recompile or `modprobe loop'.)",
-		      PROC_DEVICES);
-
-	    else
-		fprintf(stderr,
-		    "mount: Could not find any loop device. Maybe this kernel does not know\n"
-		    "       about the loop device (then recompile or `modprobe loop'), or\n"
-		    "       maybe /dev/loop# has the wrong major number?");
-
+		if (loop_known == 1)
+			fprintf(stderr,
+				"mount: Could not find any loop device.\n"
+				"       Maybe /dev/loop# has a wrong major number?");
+		else if (loop_known == -1)
+			fprintf(stderr,
+				"mount: Could not find any loop device, and, according to %s,\n"
+				"       this kernel does not know about the loop device.\n"
+				"       (If so, then recompile or `modprobe loop'.)",
+				PROC_DEVICES);
+		else
+			fprintf(stderr,
+				"mount: Could not find any loop device. Maybe this kernel does not know\n"
+				"       about the loop device (then recompile or `modprobe loop'), or\n"
+				"       maybe /dev/loop# has the wrong major number?");
 	} else
 		fprintf(stderr, "mount: could not find any free loop device");
 	return 0;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2c76d8b..9b2c706 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -664,7 +664,7 @@ dm_dev_t (const char * mapname, char * dev_t, int len)
 		goto out;
 
 	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
-		    goto out;
+		goto out;
 
 	r = 0;
 out:
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index bf9c721..6e922a2 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -744,7 +744,7 @@ mpath_print_transport_id(struct prin_fulldescr *fdesc)
 			break;
 		case MPATH_PROTOCOL_ID_SAS:
 			printf("   SAS ");
-			 if (0 != fdesc->trnptid.format_code)
+			if (0 != fdesc->trnptid.format_code)
 				printf(" [Unexpected format code: %d]\n",
 						fdesc->trnptid.format_code);
 			dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
-- 
2.7.4
