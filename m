From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/tur.c libmultipath ...
Date: 21 Apr 2009 00:05:25 -0000
Message-ID: <20090421000525.23250.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-04-21 00:05:24

Modified files:
	libcheckers    : tur.c 
	libmultipath   : discovery.c discovery.h 
	multipathd     : main.c 
	path_priority/pp_alua: rtpg.c 

Log message:
	Fix for bz 472451.  This fixes two issues. First, it keeps multipathd from checking
	scsi paths in the "blocked" state, since multipathd will just hang until the device
	times out. Second, the tur checker retrys on a few more error codes that could happen
	during transient path failures.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/tur.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.1&r2=1.4.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.6&r2=1.32.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14.2.1&r2=1.14.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.18&r2=1.69.2.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.1&r2=1.3.2.2

--- multipath-tools/libcheckers/tur.c	2008/08/25 21:43:54	1.4.2.1
+++ multipath-tools/libcheckers/tur.c	2009/04/21 00:05:22	1.4.2.2
@@ -23,6 +23,11 @@
 #define MSG_TUR_UP	"tur checker reports path is up"
 #define MSG_TUR_DOWN	"tur checker reports path is down"
 
+/* from linux/include/scsi/scsi.h */
+#define DID_BUS_BUSY    0x02
+#define DID_ERROR       0x07
+#define DID_TRANSPORT_DISRUPTED 0x0e
+
 struct tur_checker_context {
 	void * dummy;
 };
@@ -62,6 +67,12 @@
 	if (io_hdr.info & SG_INFO_OK_MASK) {
 		int key = 0, asc, ascq;
 
+		if (io_hdr.host_status == DID_BUS_BUSY ||
+		    io_hdr.host_status == DID_ERROR ||
+		    io_hdr.host_status == DID_TRANSPORT_DISRUPTED) {
+			if (--retry_tur)
+				goto retry;
+		}
 		if (io_hdr.sb_len_wr > 3) {
 			if (io_hdr.sbp[0] == 0x72 || io_hdr.sbp[0] == 0x73) {
 				key = io_hdr.sbp[1] & 0x0f;
--- multipath-tools/libmultipath/discovery.c	2008/01/15 01:34:36	1.32.2.6
+++ multipath-tools/libmultipath/discovery.c	2009/04/21 00:05:22	1.32.2.7
@@ -235,6 +235,7 @@
 declare_sysfs_get_str(rev, "%s/block/%s/device/rev");
 declare_sysfs_get_str(dev, "%s/block/%s/dev");
 declare_sysfs_get_str(bustype, "%s/block/%s/device/bus");
+declare_sysfs_get_str(state, "%s/block/%s/device/state");
 
 int
 sysfs_get_size (char * sysfs_path, char * dev, unsigned long long * size)
--- multipath-tools/libmultipath/discovery.h	2007/06/18 17:37:18	1.14.2.1
+++ multipath-tools/libmultipath/discovery.h	2009/04/21 00:05:23	1.14.2.2
@@ -30,7 +30,7 @@
 int sysfs_get_rev (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_dev (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_bustype (char * sysfs_path, char * dev, char * buff, int len);
-
+int sysfs_get_state (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_size (char * sysfs_path, char * dev, unsigned long long *);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
--- multipath-tools/multipathd/main.c	2009/04/06 16:50:43	1.69.2.18
+++ multipath-tools/multipathd/main.c	2009/04/21 00:05:23	1.69.2.19
@@ -907,6 +907,22 @@
 	}
 }
 
+int
+check_sysfs_state (struct path *pp, int *newstate)
+{
+	char state[32];
+	if (pp->bus != SYSFS_BUS_SCSI)
+		return 0;
+	if (sysfs_get_state(sysfs_path, pp->dev, state, 32) != 0)
+                return 0;
+	condlog(3, "%s: state = %s", pp->dev, state);
+	if (strncmp(state, "blocked", 7) == 0){
+		*newstate = PATH_PENDING;
+		return 1;
+	}
+	return 0;
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -963,7 +979,8 @@
 			 */
 			checker_set_async(&pp->checker);
 
-			newstate = checker_check(&pp->checker);
+			if (check_sysfs_state(pp, &newstate) == 0)
+				newstate = checker_check(&pp->checker);
 			
 			if (newstate < 0) {
 				condlog(2, "%s: unusable path", pp->dev);
--- multipath-tools/path_priority/pp_alua/rtpg.c	2009/04/08 21:38:44	1.3.2.1
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2009/04/21 00:05:24	1.3.2.2
@@ -268,7 +268,7 @@
 	}
 	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
-		return rc;
+		goto out;
 	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
 	if (buflen < (scsi_buflen + 4)) {
 		free(buf);
