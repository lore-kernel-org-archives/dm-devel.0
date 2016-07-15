From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] multipathd: Add 'sysfs' prioritizer
Date: Fri, 15 Jul 2016 08:48:57 +0200
Message-ID: <1468565337-5178-4-git-send-email-hare@suse.de>
References: <1468565337-5178-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468565337-5178-1-git-send-email-hare@suse.de>
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

Recent kernels have an 'access_state' attribute which allows
us to read the asymmetric access state directly from sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c           | 33 +++++++++++++++++++++
 libmultipath/discovery.h           |  2 ++
 libmultipath/prio.h                |  1 +
 libmultipath/prioritizers/Makefile |  3 +-
 libmultipath/prioritizers/sysfs.c  | 61 ++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.c             |  6 +++-
 multipath/multipath.conf.5         | 19 ++++++++++--
 7 files changed, 120 insertions(+), 5 deletions(-)
 create mode 100644 libmultipath/prioritizers/sysfs.c

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e9e0313..07c60cf 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -209,6 +209,8 @@ declare_sysfs_get_str(devtype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
+declare_sysfs_get_str(access_state);
+declare_sysfs_get_str(preferred_path);
 
 ssize_t
 sysfs_get_vpd (struct udev_device * udev, int pg,
@@ -484,6 +486,37 @@ int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address)
 	return 1;
 }
 
+int
+sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
+{
+	struct udev_device *parent = pp->udev;
+	char value[16], *eptr;
+	unsigned int preferred;
+
+	while (parent) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+
+	if (!parent)
+		return -1;
+
+	if (sysfs_get_access_state(parent, buff, buflen) <= 0)
+		return -1;
+
+	if (sysfs_get_preferred_path(parent, value, 16) <= 0)
+		return 0;
+
+	preferred = strtoul(value, &eptr, 0);
+	if (value == eptr || preferred == ULONG_MAX) {
+		/* Parse error, ignore */
+		return 0;
+	}
+	return  preferred;
+}
+
 static void
 sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 321d930..0f5b1e6 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -47,6 +47,8 @@ int sysfs_get_host_pci_name(struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address);
 ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
 		       size_t len);
+int sysfs_get_asymmetric_access_state(struct path *pp,
+				      char *buff, int buflen);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 7195986..032028e 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -30,6 +30,7 @@ struct path;
 #define PRIO_RANDOM		"random"
 #define PRIO_RDAC		"rdac"
 #define PRIO_WEIGHTED_PATH	"weightedpath"
+#define PRIO_SYSFS		"sysfs"
 
 /*
  * Value used to mark the fact prio was not defined
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 903a139..bb76700 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -15,7 +15,8 @@ LIBS = \
 	libprioontap.so \
 	libpriorandom.so \
 	libpriordac.so \
-	libprioweightedpath.so
+	libprioweightedpath.so \
+	libpriosysfs.so
 
 CFLAGS += -I..
 
diff --git a/libmultipath/prioritizers/sysfs.c b/libmultipath/prioritizers/sysfs.c
new file mode 100644
index 0000000..ff567df
--- /dev/null
+++ b/libmultipath/prioritizers/sysfs.c
@@ -0,0 +1,61 @@
+/*
+ * sysfs.c
+ *
+ * Copyright(c) 2016 Hannes Reinecke, SUSE Linux GmbH
+ */
+
+#include <stdio.h>
+
+#include "structs.h"
+#include "discovery.h"
+#include "prio.h"
+
+static const struct {
+	unsigned char value;
+	char *name;
+} sysfs_access_state_map[] = {
+	{ 50, "active/optimized" },
+	{ 10, "active/non-optimized" },
+	{  5, "lba-dependent" },
+	{  1, "standby" },
+};
+
+int get_exclusive_pref_arg(char *args)
+{
+	char *ptr;
+
+	if (args == NULL)
+		return 0;
+	ptr = strstr(args, "exclusive_pref_bit");
+	if (!ptr)
+		return 0;
+	if (ptr[18] != '\0' && ptr[18] != ' ' && ptr[18] != '\t')
+		return 0;
+	if (ptr != args && ptr[-1] != ' ' && ptr[-1] != '\t')
+		return 0;
+	return 1;
+}
+
+int getprio (struct path * pp, char * args, unsigned int timeout)
+{
+	int prio = 0, rc, i;
+	char buff[512];
+	int exclusive_pref;
+
+	exclusive_pref = get_exclusive_pref_arg(args);
+	rc = sysfs_get_asymmetric_access_state(pp, buff, 512);
+	if (rc < 0)
+		return PRIO_UNDEF;
+	prio = 0;
+	for (i = 0; i < 4; i++) {
+		if (!strncmp(buff, sysfs_access_state_map[i].name,
+			     strlen(sysfs_access_state_map[i].name))) {
+			prio = sysfs_access_state_map[i].value;
+			break;
+		}
+	}
+	if (rc > 0 && (prio != 50 || exclusive_pref))
+		prio += 80;
+
+	return prio;
+}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index beb0798..0caf269 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -375,6 +375,8 @@ detect_prio(struct config *conf, struct path * pp)
 	struct prio *p = &pp->prio;
 	int tpgs = 0;
 	unsigned int timeout = conf->checker_timeout;
+	char buff[512];
+	char *default_prio = PRIO_ALUA;
 
 	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0)
 		return;
@@ -384,7 +386,9 @@ detect_prio(struct config *conf, struct path * pp)
 		return;
 	if (get_asymmetric_access_state(pp->fd, ret, timeout) < 0)
 		return;
-	prio_get(conf->multipath_dir, p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
+	if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
+		default_prio = PRIO_SYSFS;
+	prio_get(conf->multipath_dir, p, default_prio, DEFAULT_PRIO_ARGS);
 }
 
 #define set_prio(dir, src, msg)					\
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 709ab3c..fc3877f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -212,6 +212,11 @@ are implemented:
 .I const
 Return a constant priority of \fI1\fR.
 .TP
+.I sysfs
+Use the sysfs attributes \fIaccess_state\fR and \fIpreferred_path\fR to
+generate the path priority. This prioritizer accepts the optional prio_arg
+.I exclusive_pref_bit
+.TP
 .I emc
 (Hardware-dependent)
 Generate the path priority for DGC class arrays as CLARiiON CX/AX and
@@ -277,8 +282,8 @@ these values can be looked up through sysfs or by running
 .I alua
 If
 .I exclusive_pref_bit
-is set, paths with the TPGS pref bit set will always be in their own path
-group.
+is set, paths with the \fIpreferred path\fR bit set will always
+be in their own path group.
 .TP
 .I datacore
 .I preferredsds
@@ -569,8 +574,16 @@ If set to
 .I yes
 , multipath will try to detect if the device supports SCSI-3 ALUA. If so, the
 device will automatically use the
+.I sysfs
+prioritizer if the required sysfs attributes
+.I access_state
+and
+.I preferred_path
+are supported, or the
 .I alua
-prioritizer. If not, the prioritizer will be selected as usual.
+prioritizer if not. If set to
+.I no
+, the prioritizer will be selected as usual.
 .RS
 .TP
 Default value is: \fBno\fR
-- 
2.6.6
