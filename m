From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/discovery.c multi ...
Date: 27 Jan 2010 17:21:50 -0000
Message-ID: <20100127172150.27153.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-01-27 17:21:49

Modified files:
	libmultipath   : discovery.c 
	multipathd     : main.c 

Log message:
	More work for bz #553042. If the checker_timeout isn't set, check the sysfs scsi
	timeout before each check.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.11&r2=1.32.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.25&r2=1.69.2.26

--- multipath-tools/libmultipath/discovery.c	2010/01/27 16:46:48	1.32.2.11
+++ multipath-tools/libmultipath/discovery.c	2010/01/27 17:21:48	1.32.2.12
@@ -242,7 +242,7 @@
 {
 	struct sysfs_attribute * attr;
 	char attr_path[SYSFS_PATH_SIZE];
-	int r;
+	int t, r;
 
 	if (safe_sprintf(attr_path, "%s/block/%s/device/timeout", sysfs_path,
 			 dev))
@@ -256,12 +256,13 @@
 	if (0 > sysfs_read_attribute(attr))
 		goto out;
 
-	r = sscanf(attr->value, "%u\n", timeout);
+	r = sscanf(attr->value, "%u\n", &t);
 	sysfs_close_attribute(attr);
 
 	if (r != 1)
 		return 1;
 
+	*timeout = t;
 	return 0;
 out:
 	sysfs_close_attribute(attr);
--- multipath-tools/multipathd/main.c	2009/11/02 19:11:46	1.69.2.25
+++ multipath-tools/multipathd/main.c	2010/01/27 17:21:48	1.69.2.26
@@ -979,8 +979,12 @@
 			 */
 			checker_set_async(&pp->checker);
 
-			if (check_sysfs_state(pp, &newstate) == 0)
+			if (check_sysfs_state(pp, &newstate) == 0) {
+				if (!conf->checker_timeout)
+					sysfs_get_timeout(sysfs_path, pp->dev,
+							&(pp->checker.timeout));
 				newstate = checker_check(&pp->checker);
+			}
 			
 			if (newstate < 0) {
 				condlog(2, "%s: unusable path", pp->dev);
