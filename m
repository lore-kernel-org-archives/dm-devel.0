From: heinzm@sourceware.org
Subject: dmraid/lib/events libdmraid-events-isw.c
Date: 16 Mar 2010 15:33:51 -0000
Message-ID: <20100316153351.17171.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-03-16 15:33:51

Modified files:
	lib/events     : libdmraid-events-isw.c 

Log message:
	Fix compiler warnings

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/events/libdmraid-events-isw.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/lib/events/libdmraid-events-isw.c	2009/11/19 11:37:25	1.2
+++ dmraid/lib/events/libdmraid-events-isw.c	2010/03/16 15:33:50	1.3
@@ -27,20 +27,8 @@
  */
 
 /*
- * FIXME before releasing in RHEL5 (Heinz Mauelshagen):
- *
- * o symbols naming consistency
- *
- * Likely after 5.3:
- * o integrate code with dmraid package
- * o support metadata updates
- * o use libsysfs rather than duplicated code to access sysfs
- * o remove any limitations to SATA, because dmraid must be device agnostic;
- *   ie. the devices being registered with dmeventd have to be derived from
- *   libdmraid metadata discovery; this essentially means a rewrite!
- *
  * FIXED:
- * o stremaline event processing functions
+ * o streamline event processing functions
  * o register/event processing major:minor usage concept
  * o cover error paths
  * o locking race vs. registration in event processing
@@ -101,13 +89,11 @@
 static const char *default_dmraid_events_lib = "libdmraid-events.so";
 static const char *sys_dm_dm = "dm-";
 static const char *sys_block_path = "/sys/block/";
-static const char *sys_dm_path = "/sys/block/dm-";
 static const char *sys_scsi_path = "/sys/class/scsi_device/";
 static const char *sys_slaves_dir = "/slaves";
 static const char *sys_scsi_dev_blk = "/device/block";
 static const char sys_scsi_dev_blk_delims[] = { '/', ':' };
 static const char *sys_dev_dir = "/dev";
-static const char *syslog_ident = "libdmraid-events";
 
 /* Logging. */
 enum log_type { LOG_NAMES, LOG_PORTS, LOG_OPEN_FAILURE, LOG_NONE };
@@ -1070,7 +1056,7 @@
 						  char *params)
 {
 	int argc, i, num_devs, ret = D_INSYNC;
-	char **args, *dev_status_str, *p;
+	char **args = NULL, *dev_status_str, *p;
 	const char *rs_name = dm_task_get_name(dmt);
 	struct dso_raid_set *rs = _find_raid_set(rs_name, NULL, 1);
 	struct dso_raid_dev *dev;
@@ -1135,7 +1121,7 @@
 {
 	int argc, i, log_argc, num_devs, ret = D_INSYNC;
 	char **args = NULL, *dev_status_str,
-	     *log_status_str, *p, *sync_str;
+	     *log_status_str = NULL, *p, *sync_str;
 	const char *rs_name = dm_task_get_name(dmt);
 	struct dso_raid_set *rs = _find_raid_set(rs_name, NULL, 1);
 
@@ -1517,16 +1503,17 @@
  *
  * Return 1 for success and 0 for failure.
  */ 
-int register_device(const char *rs_name, const char *uuid,
+int register_device(const char *rs_name_in, const char *uuid,
 		    int major, int minor,
 		    void **unused __attribute((unused)))
 {
+	char *rs_name;
 	struct dso_raid_set *rs, *rs_new;
 
 	/* FIXME: need to run first to get syslog() to work. */
 	_check_sgpio();
 
-	rs_name = basename(rs_name);
+	rs_name = basename((char *) rs_name_in);
 
 	/* Check for double registration attempt. */
 	pthread_mutex_lock(&_register_mutex);
@@ -1581,13 +1568,14 @@
  *
  * Return 1 for success and 0 for failure.
  */ 
-int unregister_device(const char *rs_name, const char *uuid,
+int unregister_device(const char *rs_name_in, const char *uuid,
 		      int major, int minor,
 		      void **unused __attribute((unused)))
 {
+	char *rs_name;
 	struct dso_raid_set *prev, *rs;
 
-	rs_name = basename(rs_name);
+	rs_name = basename((char *) rs_name_in);
 
 	pthread_mutex_lock(&_register_mutex);
 
