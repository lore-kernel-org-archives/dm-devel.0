From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 07/17] libmultipath: Cut down on alua prioritizer
	ioctls
Date: Mon, 28 Mar 2016 22:13:04 -0500
Message-ID: <1459221194-23222-8-git-send-email-bmarzins@redhat.com>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Currently, running the alua prioritizer on a path causes 5 ioctls on
many devices.  get_target_port_group_support() returns whether alua is
supported. get_target_port_group() gets the TPG id. This often takes two
ioctls because 128 bytes is not a large enough buffer size on many
devices. Finally, get_asymmetric_access_state() also often takes two
ioctls because of the buffer size. This can get to be problematic when
there are thousands of paths.  The goal of this patch to to cut this
down to one call in the usual case.

In order to do this, get_target_port_group_support() is now only called
when get_target_port_group() fails, to provide a more useful error
message. Also, before doing an SGIO ioctl to get the vpd83 data,
multipath first tries to read it from sysfs.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.h              |  2 +
 libmultipath/prioritizers/alua.c      | 24 ++++++------
 libmultipath/prioritizers/alua_rtpg.c | 69 ++++++++++++++++++++++++-----------
 libmultipath/prioritizers/alua_rtpg.h |  2 +-
 libmultipath/propsel.c                |  2 +-
 5 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index da7652c..5931bc6 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -45,6 +45,8 @@ int sysfs_set_scsi_tmo (struct multipath *mpp);
 int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
 int sysfs_get_host_pci_name(struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address);
+ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
+		       size_t len);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 39ed1c8..0bd374f 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -51,24 +51,22 @@ static const char *aas_print_string(int rc)
 }
 
 int
-get_alua_info(int fd)
+get_alua_info(struct path * pp)
 {
 	int	rc;
 	int	tpg;
 
-	rc = get_target_port_group_support(fd);
-	if (rc < 0)
-		return -ALUA_PRIO_TPGS_FAILED;
-
-	if (rc == TPGS_NONE)
-		return -ALUA_PRIO_NOT_SUPPORTED;
-
-	tpg = get_target_port_group(fd);
-	if (tpg < 0)
+	tpg = get_target_port_group(pp);
+	if (tpg < 0) {
+		rc = get_target_port_group_support(pp->fd);
+		if (rc < 0)
+			return -ALUA_PRIO_TPGS_FAILED;
+		if (rc == TPGS_NONE)
+			return -ALUA_PRIO_NOT_SUPPORTED;
 		return -ALUA_PRIO_RTPG_FAILED;
-
+	}
 	condlog(3, "reported target port group is %i", tpg);
-	rc = get_asymmetric_access_state(fd, tpg);
+	rc = get_asymmetric_access_state(pp->fd, tpg);
 	if (rc < 0)
 		return -ALUA_PRIO_GETAAS_FAILED;
 
@@ -86,7 +84,7 @@ int getprio (struct path * pp, char * args)
 	if (pp->fd < 0)
 		return -ALUA_PRIO_NO_INFORMATION;
 
-	rc = get_alua_info(pp->fd);
+	rc = get_alua_info(pp);
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
 		priopath = (rc & 0x80);
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 6d04fc1..636aae5 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -17,15 +17,18 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
+#include <libudev.h>
 
 #define __user
 #include <scsi/sg.h>
 
+#include "../structs.h"
 #include "../prio.h"
+#include "../discovery.h"
 #include "alua_rtpg.h"
 
 #define SENSE_BUFF_LEN  32
-#define DEF_TIMEOUT     60000
+#define SGIO_TIMEOUT     60000
 
 /*
  * Macro used to print debug messaged.
@@ -135,7 +138,7 @@ do_inquiry(int fd, int evpd, unsigned int codepage, void *resp, int resplen)
 	hdr.dxfer_len		= resplen;
 	hdr.sbp			= sense;
 	hdr.mx_sb_len		= sizeof(sense);
-	hdr.timeout		= get_prio_timeout(DEF_TIMEOUT);
+	hdr.timeout		= get_prio_timeout(SGIO_TIMEOUT);
 
 	if (ioctl(fd, SG_IO, &hdr) < 0) {
 		PRINT_DEBUG("do_inquiry: IOCTL failed!\n");
@@ -170,8 +173,27 @@ get_target_port_group_support(int fd)
 	return rc;
 }
 
+static int
+get_sysfs_pg83(struct path *pp, unsigned char *buff, int buflen)
+{
+	struct udev_device *parent = pp->udev;
+
+	while (parent) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+
+	if (!parent || sysfs_get_vpd(parent, 0x83, buff, buflen) <= 0) {
+		PRINT_DEBUG("failed to read sysfs vpd pg83\n");
+		return -1;
+	}
+	return 0;
+}
+
 int
-get_target_port_group(int fd)
+get_target_port_group(struct path * pp)
 {
 	unsigned char		*buf;
 	struct vpd83_data *	vpd83;
@@ -179,7 +201,7 @@ get_target_port_group(int fd)
 	int			rc;
 	int			buflen, scsi_buflen;
 
-	buflen = 128; /* Lets start from 128 */
+	buflen = 4096;
 	buf = (unsigned char *)malloc(buflen);
 	if (!buf) {
 		PRINT_DEBUG("malloc failed: could not allocate"
@@ -188,24 +210,29 @@ get_target_port_group(int fd)
 	}
 
 	memset(buf, 0, buflen);
-	rc = do_inquiry(fd, 1, 0x83, buf, buflen);
-	if (rc < 0)
-		goto out;
 
-	scsi_buflen = (buf[2] << 8 | buf[3]) + 4;
-	if (buflen < scsi_buflen) {
-		free(buf);
-		buf = (unsigned char *)malloc(scsi_buflen);
-		if (!buf) {
-			PRINT_DEBUG("malloc failed: could not allocate"
-				     "%u bytes\n", scsi_buflen);
-			return -RTPG_RTPG_FAILED;
-		}
-		buflen = scsi_buflen;
-		memset(buf, 0, buflen);
-		rc = do_inquiry(fd, 1, 0x83, buf, buflen);
+	rc = get_sysfs_pg83(pp, buf, buflen);
+
+	if (rc < 0) {
+		rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen);
 		if (rc < 0)
 			goto out;
+
+		scsi_buflen = (buf[2] << 8 | buf[3]) + 4;
+		if (buflen < scsi_buflen) {
+			free(buf);
+			buf = (unsigned char *)malloc(scsi_buflen);
+			if (!buf) {
+				PRINT_DEBUG("malloc failed: could not allocate"
+					    "%u bytes\n", scsi_buflen);
+				return -RTPG_RTPG_FAILED;
+			}
+			buflen = scsi_buflen;
+			memset(buf, 0, buflen);
+			rc = do_inquiry(pp->fd, 1, 0x83, buf, buflen);
+			if (rc < 0)
+				goto out;
+		}
 	}
 
 	vpd83 = (struct vpd83_data *) buf;
@@ -254,7 +281,7 @@ do_rtpg(int fd, void* resp, long resplen)
 	hdr.dxfer_len		= resplen;
 	hdr.mx_sb_len		= sizeof(sense);
 	hdr.sbp			= sense;
-	hdr.timeout		= get_prio_timeout(DEF_TIMEOUT);
+	hdr.timeout		= get_prio_timeout(SGIO_TIMEOUT);
 
 	if (ioctl(fd, SG_IO, &hdr) < 0)
 		return -RTPG_RTPG_FAILED;
@@ -278,7 +305,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 	int			buflen;
 	uint32_t		scsi_buflen;
 
-	buflen = 128; /* Initial value from old code */
+	buflen = 4096;
 	buf = (unsigned char *)malloc(buflen);
 	if (!buf) {
 		PRINT_DEBUG ("malloc failed: could not allocate"
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index c43e0a9..91a15a4 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -23,7 +23,7 @@
 #define RTPG_TPG_NOT_FOUND			4
 
 int get_target_port_group_support(int fd);
-int get_target_port_group(int fd);
+int get_target_port_group(struct path * pp);
 int get_asymmetric_access_state(int fd, unsigned int tpg);
 
 #endif /* __RTPG_H__ */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 890d4b1..8abe360 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -378,7 +378,7 @@ detect_prio(struct path * pp)
 	if ((tpgs = get_target_port_group_support(pp->fd)) <= 0)
 		return;
 	pp->tpgs = tpgs;
-	ret = get_target_port_group(pp->fd);
+	ret = get_target_port_group(pp);
 	if (ret < 0)
 		return;
 	if (get_asymmetric_access_state(pp->fd, ret) < 0)
-- 
1.8.3.1
