From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 09/11] libmultipath:
	retain_attached_hw_handler obsolete with 4.3+
Date: Thu, 22 Jun 2017 16:59:11 +0200
Message-ID: <20170622145913.23714-10-mwilck@suse.com>
References: <20170622145913.23714-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Kernels 4.3 and newer (commit 1bab0de0 "dm-mpath, scsi_dh: don't
let dm detach device handlers") imply "retain_attached_hw_handler yes".

Clarify this in the propsel code, log messages, and documentation.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c   |  3 ++-
 libmultipath/dmparser.c    |  3 ++-
 libmultipath/propsel.c     |  7 ++++++-
 libmultipath/util.c        | 36 ++++++++++++++++++++++++++++++++++++
 libmultipath/util.h        |  2 ++
 multipath/multipath.conf.5 | 15 +++++++++++----
 6 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a7f2b443..74b6f52a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -572,7 +572,8 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	}
 
 	if (mpp->retain_hwhandler != RETAIN_HWHANDLER_UNDEF &&
-	    mpp->retain_hwhandler != cmpp->retain_hwhandler) {
+	    mpp->retain_hwhandler != cmpp->retain_hwhandler &&
+	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0)) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (retain_hwhandler change)",
 			mpp->alias);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 1121c715..b647c256 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -97,7 +97,8 @@ assemble_map (struct multipath * mp, char * params, int len)
 	} else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF) {
 		add_feature(&f, no_path_retry);
 	}
-	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON)
+	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON &&
+	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
 		add_feature(&f, retain_hwhandler);
 
 	APPEND(p, end, "%s %s %i %i", f, mp->hwhandler, nr_priority_groups,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index e885a845..d609394e 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -628,7 +628,12 @@ int select_retain_hwhandler(struct config *conf, struct multipath *mp)
 
 	if (!VERSION_GE(conf->version, minv_dm_retain)) {
 		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
-		origin = "(setting: WARNING, requires kernel version >= 1.5.0)";
+		origin = "(setting: WARNING, requires kernel dm-mpath version >= 1.5.0)";
+		goto out;
+	}
+	if (get_linux_version_code() >= KERNEL_VERSION(4, 3, 0)) {
+		mp->retain_hwhandler = RETAIN_HWHANDLER_ON;
+		origin = "(setting: implied in kernel >= 4.3.0)";
 		goto out;
 	}
 	mp_set_ovr(retain_hwhandler);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index b90cd8b0..dff2ed3c 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -6,6 +6,7 @@
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include <sys/types.h>
+#include <sys/utsname.h>
 #include <dirent.h>
 #include <unistd.h>
 #include <errno.h>
@@ -380,3 +381,38 @@ int systemd_service_enabled(const char *dev)
 		found = systemd_service_enabled_in(dev, "/run");
 	return found;
 }
+
+static int _linux_version_code;
+static pthread_once_t _lvc_initialized = PTHREAD_ONCE_INIT;
+
+/* Returns current kernel version encoded as major*65536 + minor*256 + patch,
+ * so, for example,  to check if the kernel is greater than 2.2.11:
+ *
+ *     if (get_linux_version_code() > KERNEL_VERSION(2,2,11)) { <stuff> }
+ *
+ * Copyright (C) 1999-2004 by Erik Andersen <andersen@codepoet.org>
+ * Code copied from busybox (GPLv2 or later)
+ */
+static void
+_set_linux_version_code(void)
+{
+	struct utsname name;
+	char *t;
+	int i, r;
+
+	uname(&name); /* never fails */
+	t = name.release;
+	r = 0;
+	for (i = 0; i < 3; i++) {
+		t = strtok(t, ".");
+		r = r * 256 + (t ? atoi(t) : 0);
+		t = NULL;
+	}
+	_linux_version_code = r;
+}
+
+int get_linux_version_code(void)
+{
+	pthread_once(&_lvc_initialized, _set_linux_version_code);
+	return _linux_version_code;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index b087e32e..45291be8 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -15,6 +15,8 @@ char *convert_dev(char *dev, int is_path_device);
 char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 int systemd_service_enabled(const char *dev);
+int get_linux_version_code(void);
+#define KERNEL_VERSION(maj, min, ptc) ((((maj) * 256) + (min)) * 256 + (ptc))
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b32d0383..3b4e5187 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -698,15 +698,16 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B retain_attached_hw_handler
-If set to
+(Obsolete for kernels >= 4.3) If set to
 .I yes
 and the SCSI layer has already attached a hardware_handler to the device,
 multipath will not force the device to use the hardware_handler specified by
 mutipath.conf. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
-.TP
-The default is: \fByes\fR
+.PP
+The default is: \fByes\fR. Linux kernel 4.3 or newer always behaves as if
+\fB"retain_attached_hw_handler yes"\fR was set.
 .RE
 .
 .
@@ -1182,8 +1183,14 @@ Active/Standby mode exclusively.
 .I 1 alua
 (Hardware-dependent)
 Hardware handler for SCSI-3 ALUA compatible arrays.
-.TP
+.PP
 The default is: \fB<unset>\fR
+.PP
+\fBImportant Note:\fR Linux kernels 4.3 and newer automatically attach a device
+handler to known devices (which includes all devices supporting SCSI-3 ALUA)
+and disallow changing the handler
+afterwards. Setting \fBhardware_handler\fR for such devices on these kernels
+has no effect.
 .RE
 .
 .
-- 
2.13.1
