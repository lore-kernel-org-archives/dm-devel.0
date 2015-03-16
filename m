From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 78/78] multipathd: trigger all devices on startup
Date: Mon, 16 Mar 2015 13:37:05 +0100
Message-ID: <1426509425-15978-79-git-send-email-hare@suse.de>
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

During startup multipathd might race with udev and device discovery.
During that time any information from libudev might not be fully
available, leading to spurious multipathd failures during startup.
So instead of scanning all devices on our own we should just
re-trigger the existing devices; with that we'll read _all_
devices via uevents during startup and avoid the race condition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/discovery.h |  1 +
 multipathd/main.c        | 36 +++++++++++++++++++++++++++++----
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4582a20..8762819 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -134,6 +134,58 @@ path_discover (vector pathvec, struct config * conf,
 }
 
 int
+path_trigger (struct config * conf, int flag)
+{
+	struct udev_enumerate *udev_iter;
+	struct udev_list_entry *entry;
+	int num_paths = 0;
+
+	udev_iter = udev_enumerate_new(conf->udev);
+	if (!udev_iter)
+		return -ENOMEM;
+
+	udev_enumerate_add_match_subsystem(udev_iter, "block");
+	udev_enumerate_scan_devices(udev_iter);
+
+	udev_list_entry_foreach(entry,
+				udev_enumerate_get_list_entry(udev_iter)) {
+		const char *devpath;
+		char *devname;
+		char filename[PATH_MAX];
+		int fd;
+
+		devpath = udev_list_entry_get_name(entry);
+		condlog(3, "Trigger device %s", devpath);
+		devname = strrchr(devpath, '/');
+		if (!devname) {
+			condlog(3, "%s: invalid devpath", devpath);
+			continue;
+		}
+		devname++;
+		if (filter_devnode(conf->blist_devnode,
+				   conf->elist_devnode, devname) > 0) {
+			condlog(3, "%s: blacklisted", devname);
+			continue;
+		}
+		strncpy(filename, devpath, strlen(devpath) + 1);
+		strncat(filename, "/uevent", 8);
+		fd = open(filename, O_WRONLY | O_CLOEXEC);
+		if (fd < 0)
+			continue;
+		if (write(fd, "add", 3) < 0) {
+			condlog(3, "%s: Failed to trigger 'add' uevent: %m",
+				devpath);
+		} else {
+			num_paths++;
+		}
+		close(fd);
+	}
+	udev_enumerate_unref(udev_iter);
+	condlog(4, "Triggered %d paths", num_paths);
+	return num_paths;
+}
+
+int
 path_discovery (vector pathvec, struct config * conf, int flag)
 {
 	struct udev_enumerate *udev_iter;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index da7652c..9ae3d23 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -31,6 +31,7 @@
 struct config;
 
 int path_discovery (vector pathvec, struct config * conf, int flag);
+int path_trigger (struct config * conf, int flag);
 
 int do_tur (char *);
 int path_offline (struct path *);
diff --git a/multipathd/main.c b/multipathd/main.c
index d9f2435..480b10d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1581,6 +1581,24 @@ configure (struct vectors * vecs, int start_waiters)
 }
 
 int
+trigger_devices (struct vectors * vecs)
+{
+
+	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc()))
+		return 1;
+
+	if (!vecs->mpvec && !(vecs->mpvec = vector_alloc()))
+		return 1;
+
+	/*
+	 * Trigger all non-blacklisted block devices
+	 */
+	path_trigger(conf, DI_ALL);
+
+	return 0;
+}
+
+int
 reconfigure (struct vectors * vecs)
 {
 	struct config * old = conf;
@@ -1902,15 +1920,21 @@ child (void * param)
 		condlog(0, "failed to create cli listener: %d", rc);
 		goto failed;
 	}
-	/*
-	 * fetch and configure both paths and multipaths
-	 */
 #ifdef USE_SYSTEMD
 	sd_notify(0, "STATUS=configure");
 #endif
 	post_config_state(DAEMON_CONFIGURE);
 
 	/*
+	 * Trigger all paths to force reconfiguration
+	 */
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(vecs->lock);
+	pthread_testcancel();
+	trigger_devices(vecs);
+	lock_cleanup_pop(vecs->lock);
+
+	/*
 	 * start threads
 	 */
 	if ((rc = pthread_create(&check_thr, &misc_attr, checkerloop, vecs))) {
@@ -1927,6 +1951,8 @@ child (void * param)
 	pid_rc = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
 	/* Ignore errors, we can live without */
 
+	post_config_state(DAEMON_RUNNING);
+
 #ifdef USE_SYSTEMD
 	sd_notify(0, "READY=1\nSTATUS=running");
 #endif
@@ -2129,7 +2155,9 @@ main (int argc, char *argv[])
 			conf->bindings_read_only = 1;
 			break;
 		default:
-			;
+			fprintf(stderr, "Invalid argument '-%c'\n",
+				optopt);
+			exit(1);
 		}
 	}
 	if (optind < argc) {
-- 
1.8.4.5
