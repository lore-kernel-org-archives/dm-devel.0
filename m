From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/78] multipath: implement option '-u' for
	uevents
Date: Mon, 16 Mar 2015 13:36:09 +0100
Message-ID: <1426509425-15978-23-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When calling 'multipath' from an uevent udev will not have
all information for that device, as it's being written into
the database _after_ the event has been processed.
This patch implements an option '-u' which uses the information
from the program environment when checking the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  3 ++-
 libmultipath/configure.c   | 28 ++++++++++++++++++++++++++--
 libmultipath/log_pthread.c |  2 +-
 multipath/main.c           | 21 ++++++++++++++++++---
 multipath/multipath.8      |  6 +++++-
 multipath/multipath.rules  |  2 +-
 7 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 79c6bc1..1007f32 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -617,6 +617,7 @@ load_config (char * file, struct udev *udev)
 	conf->partition_delim = NULL;
 	conf->processed_main_config = 0;
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
+	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index a680e2b..d304a6c 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -19,7 +19,8 @@ enum devtypes {
 	DEV_NONE,
 	DEV_DEVT,
 	DEV_DEVNODE,
-	DEV_DEVMAP
+	DEV_DEVMAP,
+	DEV_UEVENT
 };
 
 enum mpath_cmds {
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c9f16c7..a30ca59 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -957,8 +957,8 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
-					condlog(0, "%s can't store path info",
-						buff);
+					condlog(0, "%s: can't store path info",
+						dev);
 				return ret;
 			}
 		}
@@ -995,6 +995,30 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 		refwwid = pp->wwid;
 		goto out;
 	}
+
+	if (dev_type == DEV_UEVENT) {
+		struct udev_device *udevice = udev_device_new_from_environment(conf->udev);
+
+		if (!udevice) {
+			condlog(2, "%s: can't get udev device", dev);
+			return 1;
+		}
+		ret = store_pathinfo(pathvec, conf->hwtable, udevice,
+				     DI_SYSFS | DI_WWID, &pp);
+		udev_device_unref(udevice);
+		if (!pp) {
+			if (ret == 1)
+				condlog(0, "%s: can't store path info",
+					dev);
+			return ret;
+		}
+		if (pp->udev && filter_property(conf, pp->udev) > 0)
+			return 2;
+
+		refwwid = pp->wwid;
+		goto out;
+	}
+
 	if (dev_type == DEV_DEVMAP) {
 
 		if (((dm_get_uuid(dev, tmpwwid)) == 0) && (strlen(tmpwwid))) {
diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 47d75a1..e6f4b5c 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -25,7 +25,7 @@ int logq_running;
 void log_safe (int prio, const char * fmt, va_list ap)
 {
 	if (log_thr == (pthread_t)0) {
-		syslog(prio, fmt, ap);
+		vsyslog(prio, fmt, ap);
 		return;
 	}
 
diff --git a/multipath/main.c b/multipath/main.c
index dadbb2a..08ba66c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -28,6 +28,7 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <libudev.h>
+#include <syslog.h>
 
 #include <checkers.h>
 #include <prio.h>
@@ -283,6 +284,7 @@ configure (void)
 		int failed = get_refwwid(conf->dev, conf->dev_type, pathvec,
 					 &refwwid);
 		if (!refwwid) {
+			condlog(3, "%s: failed to get wwid", conf->dev);
 			if (failed == 2 && conf->cmd == CMD_VALID_PATH)
 				printf("%s is not a valid multipath device path\n", conf->dev);
 			else
@@ -471,11 +473,11 @@ main (int argc, char *argv[])
 	int r = 1;
 
 	udev = udev_new();
-
+	logsink = 0;
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritqwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -542,6 +544,10 @@ main (int argc, char *argv[])
 		case 'h':
 			usage(argv[0]);
 			exit(0);
+		case 'u':
+			conf->cmd = CMD_VALID_PATH;
+			conf->dev_type = DEV_UEVENT;
+			break;
 		case 'w':
 			conf->cmd = CMD_REMOVE_WWID;
 			break;
@@ -581,9 +587,15 @@ main (int argc, char *argv[])
 			goto out;
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
-		conf->dev_type = get_dev_type(conf->dev);
+		if (conf->dev_type != DEV_UEVENT)
+			conf->dev_type = get_dev_type(conf->dev);
 	}
 	conf->daemon = 0;
+	if (conf->dev_type == DEV_UEVENT) {
+		openlog("multipath", 0, LOG_DAEMON);
+		setlogmask(LOG_UPTO(conf->verbosity + 3));
+		logsink = 1;
+	}
 
 	if (conf->max_fds) {
 		struct rlimit fd_limit;
@@ -659,6 +671,9 @@ out:
 	cleanup_prio();
 	cleanup_checkers();
 
+	if (conf->dev_type == DEV_UEVENT)
+		closelog();
+
 out_free_config:
 	/*
 	 * Freeing config must be done after dm_lib_exit(), because
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 13e2e89..966139e 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i | \-a | \-w | \-W \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i | \-a | \|-u | \-w | \-W \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -74,6 +74,10 @@ allow device tables with queue_if_no_path when multipathd is not running
 .B \-a
 add the wwid for the specified device to the wwids file
 .TP
+.B \-u
+check if the device specified in the program environment should be
+a path in a multipath device.
+.TP
 .B \-w
 remove the wwid for the specified device from the wwids file
 .TP
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 799fbb0..5bc5068 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -6,7 +6,7 @@ TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
 SUBSYSTEM=="block", ACTION=="add|change", KERNEL!="dm-*", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
-	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -v 0 -c $tempnode", \
+	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}="1" \
 	ENV{SYSTEMD_READY}="0"
 
-- 
1.8.4.5
