From: Frank Meinl <frank.meinl@live.de>
Subject: [PATCH] libmultipath: Allow discovery of USB devices
Date: Tue, 22 Sep 2020 20:34:30 +0200
Message-ID: <AM0PR09MB289726B5423506E7A0CBFA47FE3B0@AM0PR09MB2897.eurprd09.prod.outlook.com>
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
To: dm-devel@redhat.com
Cc: Frank Meinl <frank.meinl@live.de>, mwilck@suse.com
List-Id: dm-devel.ids

This change adds a new configuration option allow_usb_devices. It is
disabled by default, so that the behavior of existing setups is not
changed. If enabled (via multipath.conf), USB devices will be found
during device discovery and can be used for multipath setups.

Without this option, multipath currently ignores all USB drives, which
is convenient for most users. (refer also to commit 51957eb)

However, it can be beneficial to use the multipath dm-module even if
there is only a single path to an USB attached storage. In combination
with the option 'queue_if_no_path', such a setup survives a temporary
device disconnect without any severe consequences for the running
applications. All I/O is queued until the device reappears.

Signed-off-by: Frank Meinl <frank.meinl@live.de>
---
 libmultipath/config.h      |  1 +
 libmultipath/dict.c        |  4 ++++
 libmultipath/discovery.c   | 13 ++++++++++---
 libmultipath/structs.h     |  1 +
 multipath/multipath.conf.5 | 14 ++++++++++++++
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2bb7153b..290aea58 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -158,6 +158,7 @@ struct config {
 	unsigned int dev_loss;
 	int log_checker_err;
 	int allow_queueing;
+	int allow_usb_devices;
 	int find_multipaths;
 	uid_t uid;
 	gid_t gid;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index feabae56..f12c2e5c 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -543,6 +543,9 @@ snprint_def_queue_without_daemon (struct config *conf,
 declare_def_handler(checker_timeout, set_int)
 declare_def_snprint(checker_timeout, print_nonzero)
 
+declare_def_handler(allow_usb_devices, set_yes_no)
+declare_def_snprint(allow_usb_devices, print_yes_no)
+
 declare_def_handler(flush_on_last_del, set_yes_no_undef)
 declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, DEFAULT_FLUSH)
 declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
@@ -1759,6 +1762,7 @@ init_keywords(vector keywords)
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("queue_without_daemon", &def_queue_without_daemon_handler, &snprint_def_queue_without_daemon);
 	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
+	install_keyword("allow_usb_devices", &def_allow_usb_devices_handler, &snprint_def_allow_usb_devices);
 	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("user_friendly_names", &def_user_friendly_names_handler, &snprint_def_user_friendly_names);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2f301ac4..4b615caa 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -375,11 +375,10 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	while (tgtdev) {
 		value = udev_device_get_subsystem(tgtdev);
 		if (value && !strcmp(value, "usb")) {
-			pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
+			pp->sg_id.proto_id = SCSI_PROTOCOL_UAS;
 			tgtname = udev_device_get_sysname(tgtdev);
 			strlcpy(node, tgtname, NODE_NAME_SIZE);
-			condlog(3, "%s: skip USB device %s", pp->dev, node);
-			return 1;
+			return 0;
 		}
 		tgtdev = udev_device_get_parent(tgtdev);
 	}
@@ -2136,6 +2135,14 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 		if (rc != PATHINFO_OK)
 			return rc;
+
+		if (pp->bus == SYSFS_BUS_SCSI &&
+		    pp->sg_id.proto_id == SCSI_PROTOCOL_UAS &&
+		    !conf->allow_usb_devices) {
+			condlog(3, "%s: skip USB device %s", pp->dev,
+				pp->tgt_node_name);
+			return PATHINFO_SKIPPED;
+		}
 	}
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 4afd3e88..284c1e45 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -174,6 +174,7 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_SAS = 6,
 	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
 	SCSI_PROTOCOL_ATA = 8,
+	SCSI_PROTOCOL_UAS = 9,  /* USB Attached SCSI */
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5adaced6..21b3bfb6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -643,6 +643,20 @@ The default is: in \fB/sys/block/sd<x>/device/timeout\fR
 .
 .
 .TP
+.B allow_usb_devices
+If set to
+.I no
+, all USB devices will be skipped during path discovery. This is convenient
+for most users, as it effectively hides all attached USB disks and flash
+drives from the multipath application. However, if you intend to use multipath
+on USB attached devices, set this to \fIyes\fR.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
 .B flush_on_last_del
 If set to
 .I yes
-- 
2.25.1
