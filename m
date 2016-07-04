From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/26] libmultipath: separate out 'udev' config
	entry
Date: Mon,  4 Jul 2016 09:08:34 +0200
Message-ID: <1467616126-10036-15-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Rather than add the 'udev' structure to the config entry we should
be using a separate global variable here. Otherwise we run into
a risk of udev getting out-of-sync internally when recreating
the udev structure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c |  3 ++-
 libmultipath/config.c           |  3 +--
 libmultipath/config.h           |  4 ++--
 libmultipath/configure.c        |  6 +++---
 libmultipath/discovery.c        | 18 +++++++++---------
 libmultipath/print.c            |  4 ++--
 multipath/main.c                |  4 ++--
 multipathd/cli_handlers.c       |  2 +-
 multipathd/main.c               | 12 ++++++------
 9 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index af2374f..dc11d4f 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -34,11 +34,12 @@
 
 #define __STDC_FORMAT_MACROS 1
 
+struct udev *udev;
 
 int
 mpath_lib_init (struct udev *udev)
 {
-	if (load_config(DEFAULT_CONFIGFILE, udev)){
+	if (load_config(DEFAULT_CONFIGFILE)){
 		condlog(0, "Failed to initialize multipath config.");
 		return 1;
 	}
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 137ff6a..3e59205 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -577,7 +577,7 @@ process_config_dir(vector keywords, char *dir)
 }
 
 int
-load_config (char * file, struct udev *udev)
+load_config (char * file)
 {
 	if (!conf)
 		conf = alloc_config();
@@ -591,7 +591,6 @@ load_config (char * file, struct udev *udev)
 	if (!conf->verbosity)
 		conf->verbosity = DEFAULT_VERBOSITY;
 
-	conf->udev = udev;
 	conf->minio = DEFAULT_MINIO;
 	conf->minio_rq = DEFAULT_MINIO_RQ;
 	get_sys_max_fds(&conf->max_fds);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 8ebc43f..4a043b9 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -141,7 +141,6 @@ struct config {
 	int uev_wait_timeout;
 	unsigned int version[3];
 
-	struct udev * udev;
 	char * multipath_dir;
 	char * selector;
 	char * uid_attribute;
@@ -174,6 +173,7 @@ struct config {
 };
 
 struct config * conf;
+extern struct udev * udev;
 
 struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
 struct mpentry * find_mpe (vector mptable, char * wwid);
@@ -189,7 +189,7 @@ void free_mptable (vector mptable);
 
 int store_hwe (vector hwtable, struct hwentry *);
 
-int load_config (char * file, struct udev * udev);
+int load_config (char * file);
 struct config * alloc_config (void);
 void free_config (struct config * conf);
 
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ab53af2..ce07741 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -953,7 +953,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 
 		pp = find_path_by_dev(pathvec, buff);
 		if (!pp) {
-			struct udev_device *udevice = udev_device_new_from_subsystem_sysname(conf->udev, "block", buff);
+			struct udev_device *udevice = udev_device_new_from_subsystem_sysname(udev, "block", buff);
 
 			if (!udevice) {
 				condlog(2, "%s: can't get udev device", buff);
@@ -985,7 +985,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 		}
 		pp = find_path_by_dev(pathvec, buff);
 		if (!pp) {
-			struct udev_device *udevice = udev_device_new_from_devnum(conf->udev, 'b', parse_devt(dev));
+			struct udev_device *udevice = udev_device_new_from_devnum(udev, 'b', parse_devt(dev));
 
 			if (!udevice) {
 				condlog(2, "%s: can't get udev device", dev);
@@ -1010,7 +1010,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 	}
 
 	if (dev_type == DEV_UEVENT) {
-		struct udev_device *udevice = udev_device_new_from_environment(conf->udev);
+		struct udev_device *udevice = udev_device_new_from_environment(udev);
 
 		if (!udevice) {
 			condlog(2, "%s: can't get udev device", dev);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 019faef..d850aba 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -141,7 +141,7 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 	const char *devpath;
 	int num_paths = 0, total_paths = 0;
 
-	udev_iter = udev_enumerate_new(conf->udev);
+	udev_iter = udev_enumerate_new(udev);
 	if (!udev_iter)
 		return -ENOMEM;
 
@@ -154,7 +154,7 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 		const char *devtype;
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
-		udevice = udev_device_new_from_syspath(conf->udev, devpath);
+		udevice = udev_device_new_from_syspath(udev, devpath);
 		if (!udevice) {
 			condlog(4, "%s: no udev information", devpath);
 			continue;
@@ -323,7 +323,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 	value = udev_device_get_sysname(tgtdev);
 	if (sscanf(value, "rport-%d:%d-%d",
 		   &host, &channel, &tgtid) == 3) {
-		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev,
+		tgtdev = udev_device_new_from_subsystem_sysname(udev,
 				"fc_remote_ports", value);
 		if (tgtdev) {
 			condlog(3, "SCSI target %d:%d:%d -> "
@@ -356,7 +356,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 		tgtid = -1;
 	}
 	if (parent && tgtname) {
-		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev,
+		tgtdev = udev_device_new_from_subsystem_sysname(udev,
 				"iscsi_session", tgtname);
 		if (tgtdev) {
 			const char *value;
@@ -430,7 +430,7 @@ int sysfs_get_host_pci_name(struct path *pp, char *pci_name)
 		return 1;
 
 	sprintf(host_name, "host%d", pp->sg_id.host_no);
-	hostdev = udev_device_new_from_subsystem_sysname(conf->udev,
+	hostdev = udev_device_new_from_subsystem_sysname(udev,
 			"scsi_host", host_name);
 	if (!hostdev)
 		return 1;
@@ -466,7 +466,7 @@ int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address)
 	const char *value;
 
 	sprintf(host_name, "host%d", pp->sg_id.host_no);
-	hostdev = udev_device_new_from_subsystem_sysname(conf->udev,
+	hostdev = udev_device_new_from_subsystem_sysname(udev,
 			"iscsi_host", host_name);
 	if (hostdev) {
 		value = udev_device_get_sysattr_value(hostdev,
@@ -492,7 +492,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
-	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+	rport_dev = udev_device_new_from_subsystem_sysname(udev,
 				"fc_remote_ports", rport_id);
 	if (!rport_dev) {
 		condlog(1, "%s: No fc_remote_port device for '%s'", pp->dev,
@@ -596,7 +596,7 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 	char value[11];
 
 	sprintf(session_id, "session%d", pp->sg_id.transport_id);
-	session_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+	session_dev = udev_device_new_from_subsystem_sysname(udev,
 				"iscsi_session", session_id);
 	if (!session_dev) {
 		condlog(1, "%s: No iscsi session for '%s'", pp->dev,
@@ -638,7 +638,7 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 
 	sprintf(end_dev_id, "end_device-%d:%d",
 		pp->sg_id.host_no, pp->sg_id.transport_id);
-	sas_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+	sas_dev = udev_device_new_from_subsystem_sysname(udev,
 				"sas_end_device", end_dev_id);
 	if (!sas_dev) {
 		condlog(1, "%s: No SAS end device for '%s'", pp->dev,
diff --git a/libmultipath/print.c b/libmultipath/print.c
index e3c14b6..03c7859 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -530,7 +530,7 @@ snprint_host_attr (char * buff, size_t len, struct path * pp, char *attr)
 	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
 		return snprintf(buff, len, "[undef]");
 	sprintf(host_id, "host%d", pp->sg_id.host_no);
-	host_dev = udev_device_new_from_subsystem_sysname(conf->udev, "fc_host",
+	host_dev = udev_device_new_from_subsystem_sysname(udev, "fc_host",
 							  host_id);
 	if (!host_dev) {
 		condlog(1, "%s: No fc_host device for '%s'", pp->dev, host_id);
@@ -570,7 +570,7 @@ snprint_tgt_wwpn (char * buff, size_t len, struct path * pp)
 		return snprintf(buff, len, "[undef]");
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
-	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+	rport_dev = udev_device_new_from_subsystem_sysname(udev,
 				"fc_remote_ports", rport_id);
 	if (!rport_dev) {
 		condlog(1, "%s: No fc_remote_port device for '%s'", pp->dev,
diff --git a/multipath/main.c b/multipath/main.c
index 2825c8e..df6a7ca 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -60,6 +60,7 @@
 #include <mpath_cmd.h>
 
 int logsink;
+struct udev *udev;
 
 static int
 filter_pathvec (vector pathvec, char * refwwid)
@@ -474,7 +475,6 @@ get_dev_type(char *dev) {
 int
 main (int argc, char *argv[])
 {
-	struct udev *udev;
 	int arg;
 	extern char *optarg;
 	extern int optind;
@@ -485,7 +485,7 @@ main (int argc, char *argv[])
 
 	udev = udev_new();
 	logsink = 0;
-	if (load_config(DEFAULT_CONFIGFILE, udev))
+	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
 		switch(arg) {
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 05dcb41..c8c712a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -637,7 +637,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	} else {
 		struct udev_device *udevice;
 
-		udevice = udev_device_new_from_subsystem_sysname(conf->udev,
+		udevice = udev_device_new_from_subsystem_sysname(udev,
 								 "block",
 								 param);
 		r = store_pathinfo(vecs->pathvec, conf->hwtable,
diff --git a/multipathd/main.c b/multipathd/main.c
index 6230798..9a44390 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1877,7 +1877,7 @@ reconfigure (struct vectors * vecs)
 	/* Re-read any timezone changes */
 	tzset();
 
-	if (!load_config(DEFAULT_CONFIGFILE, udev)) {
+	if (!load_config(DEFAULT_CONFIGFILE)) {
 		dm_drv_version(conf->version, TGT_MPATH);
 		conf->verbosity = old->verbosity;
 		conf->bindings_read_only = old->bindings_read_only;
@@ -2081,8 +2081,6 @@ child (void * param)
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
 
-	udev = udev_new();
-
 	setup_thread_attr(&misc_attr, 64 * 1024, 1);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 1);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
@@ -2105,7 +2103,7 @@ child (void * param)
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
-	if (load_config(DEFAULT_CONFIGFILE, udev))
+	if (load_config(DEFAULT_CONFIGFILE))
 		goto failed;
 
 	uxsock_timeout = conf->uxsock_timeout;
@@ -2384,6 +2382,8 @@ main (int argc, char *argv[])
 	if (!conf)
 		exit(1);
 
+	udev = udev_new();
+
 	while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
 	switch(arg) {
 		case 'd':
@@ -2403,7 +2403,7 @@ main (int argc, char *argv[])
 			logsink = -1;
 			break;
 		case 'k':
-			if (load_config(DEFAULT_CONFIGFILE, udev_new()))
+			if (load_config(DEFAULT_CONFIGFILE))
 				exit(1);
 			uxclnt(optarg, uxsock_timeout + 100);
 			exit(0);
@@ -2424,7 +2424,7 @@ main (int argc, char *argv[])
 		char * s = cmd;
 		char * c = s;
 
-		if (load_config(DEFAULT_CONFIGFILE, udev_new()))
+		if (load_config(DEFAULT_CONFIGFILE))
 			exit(1);
 		memset(cmd, 0x0, CMDSIZE);
 		while (optind < argc) {
-- 
2.6.6
