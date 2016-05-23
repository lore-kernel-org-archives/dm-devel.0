From: Hannes Reinecke <hare@suse.de>
Subject: multipathd: Add 'sysfs' prioritizer
Date: Mon, 23 May 2016 12:20:28 +0200
Message-ID: <1463998828-28133-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Recent kernels have an 'access_state' attribute which allows
us to read the asymmetric access state directly from sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c           | 33 +++++++++++++++++++++++++++++
 libmultipath/discovery.h           |  2 ++
 libmultipath/prio.h                |  1 +
 libmultipath/prioritizers/Makefile |  3 ++-
 libmultipath/prioritizers/sysfs.c  | 43 ++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.c             |  6 +++++-
 multipath/multipath.conf.5         | 14 ++++++++++++-
 7 files changed, 99 insertions(+), 3 deletions(-)
 create mode 100644 libmultipath/prioritizers/sysfs.c

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index a364056..4a4b828 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -208,6 +208,8 @@ declare_sysfs_get_str(devtype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
+declare_sysfs_get_str(access_state);
+declare_sysfs_get_str(preferred_path);
 
 ssize_t
 sysfs_get_vpd (struct udev_device * udev, int pg,
@@ -483,6 +485,37 @@ int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address)
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
index 5931bc6..b45c802 100644
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
index 495688f..65abf54 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -29,6 +29,7 @@ struct path;
 #define PRIO_RDAC "rdac"
 #define PRIO_DATACORE "datacore"
 #define PRIO_WEIGHTED_PATH "weightedpath"
+#define PRIO_SYSFS "sysfs"
 
 /*
  * Value used to mark the fact prio was not defined
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 6cfac88..0d1857f 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -15,7 +15,8 @@ LIBS = \
 	libpriodatacore.so \
 	libpriohds.so \
 	libprioweightedpath.so \
-	libprioiet.so
+	libprioiet.so \
+	libpriosysfs.so
 
 CFLAGS += -I..
 
diff --git a/libmultipath/prioritizers/sysfs.c b/libmultipath/prioritizers/sysfs.c
new file mode 100644
index 0000000..35a5c83
--- /dev/null
+++ b/libmultipath/prioritizers/sysfs.c
@@ -0,0 +1,43 @@
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
+int getprio (struct path * pp, char * args)
+{
+	int prio = 0, rc, i;
+	char buff[512];
+
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
+	if (rc > 0)
+		prio += 80;
+
+	return prio;
+}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 8abe360..b0182de 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -374,6 +374,7 @@ detect_prio(struct path * pp)
 	int ret;
 	struct prio *p = &pp->prio;
 	int tpgs = 0;
+	char buff[512];
 
 	if ((tpgs = get_target_port_group_support(pp->fd)) <= 0)
 		return;
@@ -383,7 +384,10 @@ detect_prio(struct path * pp)
 		return;
 	if (get_asymmetric_access_state(pp->fd, ret) < 0)
 		return;
-	prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
+	if (sysfs_get_asymmetric_access_state(pp, buff, 512) < 0)
+		prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
+	else
+		prio_get(p, PRIO_SYSFS, DEFAULT_PRIO_ARGS);
 }
 
 #define set_prio(src, msg)						\
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 2ff88c4..aaaa01b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -203,6 +203,10 @@ Generate the path priority for NetApp arrays.
 .B rdac
 Generate the path priority for LSI/Engenio/NetApp E-Series RDAC controller.
 .TP
+.B sysfs
+Use the sysfs attributes access_state and preferred_path to generate the
+path priority.
+.TP
 .B hp_sw
 Generate the path priority for Compaq/HP controller in
 active/standby mode.
@@ -449,8 +453,16 @@ If set to
 .I yes
 , multipath will try to detect if the device supports ALUA. If so, the device
 will automatically use the
+.I sysfs
+prioritizer if the required sysfs attributes
+.I access_state
+and
+.I preferred_path
+are supported, or the
 .I alua
-prioritizer. If not, the prioritizer will be selected as usual. Default is
+prioritizer if not. If set to
+.I no
+, the prioritizer will be selected as usual. Default is
 .I no
 .TP
 .B force_sync
-- 
2.6.6
