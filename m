From: Zou Ming <zouming.zouming@huawei.com>
Subject: [PATCH] multipath-tools: Add Huawei prioritizer for nvme
Date: Fri, 21 Apr 2017 10:27:58 +0000
Message-ID: <1492770478-14848-1-git-send-email-zouming.zouming@huawei.com>
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
Cc: zouming.zouming@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

Tool to make use of a NVMe-feature called HUAWEI Asymmetric Namespace Access.
It determines the ANA state of a device and prints a priority value to stdout.
---
 .../libmultipath/discovery.c                       |  31 ++-
 .../libmultipath/prioritizers/Makefile             |   1 +
 .../libmultipath/prioritizers/huawei_ana.c         | 222 +++++++++++++++++++++
 .../libmultipath/prioritizers/huawei_ana.h         | 191 ++++++++++++++++++
 .../libmultipath/structs.h                         |   6 +
 5 files changed, 449 insertions(+), 2 deletions(-)
 create mode 100644 multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.c
 create mode 100644 multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.h

diff --git a/multipath-tools-HEAD-be1191b/libmultipath/discovery.c b/multipath-tools-HEAD-be1191b/libmultipath/discovery.c
index 663c8ea..6d5acab 100644
--- a/multipath-tools-HEAD-be1191b/libmultipath/discovery.c
+++ b/multipath-tools-HEAD-be1191b/libmultipath/discovery.c
@@ -1195,6 +1195,8 @@ static int
 nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	struct udev_device *parent, *nvme = NULL;
+    char value[16];
+    int ret;
 
 	parent = pp->udev;
 	while (parent) {
@@ -1209,13 +1211,38 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 	if (!nvme)
 		return 1;
 
+    ret = sysfs_attr_get_value(pp->udev, "nsid", value, 16);
+    if (ret <= 0) {
+		condlog(0, "%s: failed to read nsid value, "
+			"error %d",  pp->dev, -ret);
+		return 1;
+	}
+
+    ret = sscanf(value, "%u\n", &pp->nvme_id.nsid);
+	if (ret != 1) {
+		condlog(0, "%s: Cannot parse nsid attribute", pp->dev);
+		return 1;
+	}
+
+    ret = sysfs_attr_get_value(nvme, "cntlid", value, 16);
+    if (ret <= 0) {
+		condlog(0, "%s: failed to read cntlid value, "
+			"error %d",  pp->dev, -ret);
+		return 1;
+	}
+
+    ret = sscanf(value, "%d\n", &pp->nvme_id.cntl_id);
+	if (ret != 1) {
+		condlog(0, "%s: Cannot parse cntlid attribute", pp->dev);
+		return 1;
+	}
 	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
 	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s", udev_device_get_sysattr_value(nvme, "model"));
 	snprintf(pp->serial, SERIAL_SIZE, "%s", udev_device_get_sysattr_value(nvme, "serial"));
 	snprintf(pp->rev, SCSI_REV_SIZE, "%s", udev_device_get_sysattr_value(nvme, "firmware_rev"));
 
-	condlog(3, "%s: vendor:%s product:%s serial:%s rev:%s", pp->dev,
-		pp->vendor_id, pp->product_id, pp->serial, pp->rev);
+	condlog(3, "%s: ctrl id:%d,nsid:%d,vendor:%s product:%s serial:%s rev:%s", pp->dev,pp->nvme_id.cntl_id,
+		pp->nvme_id.nsid,pp->vendor_id, pp->product_id, pp->serial, pp->rev);
 	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
 
 	return 0;
diff --git a/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/Makefile b/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/Makefile
index 36b42e4..395a65b 100644
--- a/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/Makefile
+++ b/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/Makefile
@@ -17,6 +17,7 @@ LIBS = \
 	libprioontap.so \
 	libpriorandom.so \
 	libpriordac.so \
+	libpriohuawei_ana.so \
 	libprioweightedpath.so \
 	libpriosysfs.so
 
diff --git a/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.c b/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.c
new file mode 100644
index 0000000..1d64da2
--- /dev/null
+++ b/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.c
@@ -0,0 +1,222 @@
+/*
+ * (C) Copyright HUAWEI Technology Corp. 2017   All Rights Reserved.
+ *
+ * huawei_ana.c
+ * Version 1.00
+ *
+ * Tool to make use of a NVMe-feature called HUAWEI Asymmetric Namespace Access.
+ * It determines the ANA state of a device and prints a priority value to stdout. 
+ *
+ * Author(s): Zou Ming <zouming.zouming@huawei.com>
+ *            Yang Feng <philip.yang@huawei.com>
+ *
+ * This file is released under the GPL.
+ */
+#include <stdio.h>
+#include <sys/ioctl.h>
+
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+
+#include "huawei_ana.h"
+
+#define ANA_GETSUPPORT_FAILED       1
+#define ANA_NOT_SUPPORTED           2
+#define ANA_GETNSG_FAILED           3
+#define ANA_GETAAS_FAILED           4
+#define ANA_NO_INFORMATION		    5
+
+#define ANA_SUPPORT            0
+#define ANA_NOT_SUPPORT        1
+
+#define NVME_ANA_LOG_PAGE 0xc0 
+
+#define NVME_SUPPORT_ANA (1 << 3)
+
+#define min(x, y) ((x) > (y) ? (y) : (x))
+
+static const char * anas_string[] = {
+	[ANAS_OPTIMIZED]		= "active/optimized",
+	[ANAS_NON_OPTIMIZED]	= "active/non-optimized",
+	[ANAS_INAVAILABLE]	    = "inaccessible",
+    [ANAS_TRANSITIONING]    = "transitioning between states",
+	[ANAS_RESERVED]		    = "ARRAY BUG: invalid namespace group state!",
+};
+
+static const char *aas_print_string(int rc)
+{
+    rc &= 0x7f;
+    
+    if (rc > ANAS_TRANSITIONING)
+        return anas_string[ANAS_RESERVED];
+
+    return anas_string[rc];
+}
+
+static int nvme_submit_admin_passthru(int fd, struct nvme_passthru_cmd *cmd)
+{
+	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, cmd);
+}
+
+
+int nvme_get_log(int fd, __u32 nsid, __u8 log_id, __u32 data_len, void *data)
+{
+	struct nvme_admin_cmd cmd = {
+		.opcode		= nvme_admin_get_log_page,
+		.nsid		= nsid,
+		.addr		= (__u64)(uintptr_t) data,
+		.data_len	= data_len,
+	};
+	__u32 numd = (data_len >> 2) - 1;
+	__u16 numdu = numd >> 16, numdl = numd & 0xffff;
+
+	cmd.cdw10 = log_id | (numdl << 16);
+	cmd.cdw11 = numdu;
+
+	return nvme_submit_admin_passthru(fd, &cmd);
+}
+
+
+int nvme_identify(int fd, __u32 nsid, __u32 cdw10, void *data)
+{
+	struct nvme_admin_cmd cmd = {
+		.opcode		= nvme_admin_identify,
+		.nsid		= nsid,
+		.addr		= (__u64)(uintptr_t) data,
+		.data_len	= 0x1000,
+		.cdw10		= cdw10,
+	};
+
+	return nvme_submit_admin_passthru(fd, &cmd);
+}
+
+static int get_ana_support(struct path * pp)
+{
+    int rc;
+    struct nvme_id_ctrl ctrl;
+    
+    rc = nvme_identify(pp->fd, 0, 1, &ctrl);
+    if (rc)
+        return -ANA_GETSUPPORT_FAILED;
+    
+    if(ctrl.cmic & NVME_SUPPORT_ANA) {
+        return ANA_SUPPORT;
+    }
+    
+    return ANA_NOT_SUPPORT;
+}
+
+static int get_namespace_group(struct path * pp, __u32 *nsg)
+{
+    int rc;
+    struct nvme_id_ns ns;
+
+    rc = nvme_identify(pp->fd, pp->nvme_id.nsid, 0, &ns);
+    if (rc)
+        return -ANA_GETNSG_FAILED;
+    
+    *nsg = le32_to_cpu(ns.nsg);
+    return 0;
+}
+
+static int get_asymmetric_access_state(int fd, __u32 nsg)
+{
+    int rc;
+    struct nvme_ana_log ana_log;
+    int i,nsg_num;
+    int nsg_size;
+    struct namespace_group_desc *nsgd;
+
+    rc = nvme_get_log(fd, 0xffffffff, NVME_ANA_LOG_PAGE, sizeof(struct nvme_ana_log), &ana_log);
+    if (rc)
+        return -ANA_GETAAS_FAILED;
+
+    nsg_size = ana_log.nsgdsz;
+    if (nsg_size < sizeof(struct namespace_group_desc)) {
+        condlog(3, "get namespace group desc num equal %d", nsg_size);
+        return -ANA_GETAAS_FAILED;
+    }
+    nsg_num = min(le16_to_cpu(ana_log.nsgdn), (ANA_LOG_LEN - ANA_LOG_HEAD)/nsg_size);
+       
+    for (i = 0; i < nsg_num; i++) {
+        nsgd = ( struct namespace_group_desc *) (ana_log.nsgd + i*nsg_size);
+        if (nsg == le32_to_cpu(nsgd->nsgid))
+            return nsgd->anas;
+    }
+
+    return -ANA_GETAAS_FAILED;
+}
+
+int get_ana_info(struct path * pp, unsigned int timeout)
+{
+	int	rc;
+	__u32 nsg;
+
+    rc = get_ana_support(pp);
+    if (rc < 0)
+			return -ANA_GETSUPPORT_FAILED;
+	if (rc != ANA_SUPPORT)
+		return -ANA_NOT_SUPPORTED;
+
+	rc = get_namespace_group(pp, &nsg);
+	if (rc < 0) {
+		return -ANA_GETNSG_FAILED;
+	}
+    
+	condlog(3, "%s: reported namespace group is %u", pp->dev, nsg);
+	rc = get_asymmetric_access_state(pp->fd, nsg);
+	if (rc < 0)
+		return -ANA_GETAAS_FAILED;
+
+	condlog(3, "%s: aas = %02x [%s]", pp->dev, rc, aas_print_string(rc));
+    
+	return rc;
+}
+
+
+int getprio (struct path * pp, char * args, unsigned int timeout)
+{
+	int rc;
+	int aas;
+
+	if (pp->fd < 0)
+		return -ANA_NO_INFORMATION;
+
+	rc = get_ana_info(pp, timeout);
+	if (rc >= 0) {
+		aas = (rc & 0x0f);
+		switch(aas) {
+		case ANAS_OPTIMIZED:
+			rc = 50;
+			break;
+		case ANAS_NON_OPTIMIZED:
+			rc = 10;
+			break;
+		case ANAS_TRANSITIONING:
+			rc = 5;
+			break;
+		case ANAS_INAVAILABLE:
+			rc = 1;
+			break;
+		default:
+			rc = 0;
+		}
+	} else {
+		switch(-rc) {
+		case ANA_NOT_SUPPORTED:
+			condlog(0, "%s: ana not supported", pp->dev);
+			break;
+		case ANA_GETSUPPORT_FAILED:
+			condlog(0, "%s: couldn't get support ana", pp->dev);
+			break;
+		case ANA_GETNSG_FAILED:
+			condlog(0, "%s: couldn't get namespace group", pp->dev);
+			break;
+		case ANA_GETAAS_FAILED:
+			condlog(3, "%s: couldn't get  ana states", pp->dev);
+			break;
+		}
+	}
+	return rc;
+}
diff --git a/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.h b/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.h
new file mode 100644
index 0000000..c66d5d5
--- /dev/null
+++ b/multipath-tools-HEAD-be1191b/libmultipath/prioritizers/huawei_ana.h
@@ -0,0 +1,191 @@
+#ifndef _ANA_HUAWEI_H
+#define _ANA_HUAWEI_H 
+
+#include <linux/types.h>
+
+#define ANAS_OPTIMIZED			0x01
+#define ANAS_NON_OPTIMIZED		0x02
+#define ANAS_INAVAILABLE        0x03
+#define ANAS_TRANSITIONING		0x04
+#define ANAS_RESERVED			0x05
+
+#define nvme_admin_get_log_page 0x02
+#define nvme_admin_identify		0x06
+
+#ifdef __CHECKER__
+#define __force       __attribute__((force))
+#else
+#define __force
+#endif
+
+#define le16_to_cpu(x) \
+	le16toh((__force __u16)(x))
+#define le32_to_cpu(x) \
+	le32toh((__force __u32)(x))
+#define le64_to_cpu(x) \
+	le64toh((__force __u64)(x))
+
+struct nvme_passthru_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32	result;
+};
+
+struct nvme_id_power_state {
+	__le16			max_power;	/* centiwatts */
+	__u8			rsvd2;
+	__u8			flags;
+	__le32			entry_lat;	/* microseconds */
+	__le32			exit_lat;	/* microseconds */
+	__u8			read_tput;
+	__u8			read_lat;
+	__u8			write_tput;
+	__u8			write_lat;
+	__le16			idle_power;
+	__u8			idle_scale;
+	__u8			rsvd19;
+	__le16			active_power;
+	__u8			active_work_scale;
+	__u8			rsvd23[9];
+};
+
+struct nvme_lbaf {
+	__le16			ms;
+	__u8			ds;
+	__u8			rp;
+};
+
+struct nvme_id_ctrl {
+	__le16			vid;
+	__le16			ssvid;
+	char			sn[20];
+	char			mn[40];
+	char			fr[8];
+	__u8			rab;
+	__u8			ieee[3];
+	__u8			cmic;
+	__u8			mdts;
+	__le16			cntlid;
+	__le32			ver;
+	__le32			rtd3r;
+	__le32			rtd3e;
+	__le32			oaes;
+	__le32			ctratt;
+	__u8			rsvd100[156];
+	__le16			oacs;
+	__u8			acl;
+	__u8			aerl;
+	__u8			frmw;
+	__u8			lpa;
+	__u8			elpe;
+	__u8			npss;
+	__u8			avscc;
+	__u8			apsta;
+	__le16			wctemp;
+	__le16			cctemp;
+	__le16			mtfa;
+	__le32			hmpre;
+	__le32			hmmin;
+	__u8			tnvmcap[16];
+	__u8			unvmcap[16];
+	__le32			rpmbs;
+	__u8			rsvd316[4];
+	__le16			kas;
+	__u8			rsvd322[190];
+	__u8			sqes;
+	__u8			cqes;
+	__le16			maxcmd;
+	__le32			nn;
+	__le16			oncs;
+	__le16			fuses;
+	__u8			fna;
+	__u8			vwc;
+	__le16			awun;
+	__le16			awupf;
+	__u8			nvscc;
+	__u8			rsvd531;
+	__le16			acwu;
+	__u8			rsvd534[2];
+	__le32			sgls;
+	__u8			rsvd540[228];
+	char			subnqn[256];
+	__u8			rsvd1024[768];
+	__le32			ioccsz;
+	__le32			iorcsz;
+	__le16			icdoff;
+	__u8			ctrattr;
+	__u8			msdbd;
+	__u8			rsvd1804[244];
+	struct nvme_id_power_state	psd[32];
+	__u8			vs[1024];
+};
+
+struct nvme_id_ns {
+	__le64			nsze;
+	__le64			ncap;
+	__le64			nuse;
+	__u8			nsfeat;
+	__u8			nlbaf;
+	__u8			flbas;
+	__u8			mc;
+	__u8			dpc;
+	__u8			dps;
+	__u8			nmic;
+	__u8			rescap;
+	__u8			fpi;
+	__u8			rsvd33;
+	__le16			nawun;
+	__le16			nawupf;
+	__le16			nacwu;
+	__le16			nabsn;
+	__le16			nabo;
+	__le16			nabspf;
+	__u16			rsvd46;
+	__u8			nvmcap[16];
+	__u8			rsvd64[40];
+	__u8			nguid[16];
+	__u8			eui64[8];
+	struct nvme_lbaf	lbaf[16];
+    __le32          nsg;
+	__u8			rsvd188[188];
+	__u8			vs[3712];
+};
+
+#define nvme_admin_cmd nvme_passthru_cmd
+
+#define NVME_IOCTL_ID		    _IO('N', 0x40)
+#define NVME_IOCTL_ADMIN_CMD	_IOWR('N', 0x41, struct nvme_admin_cmd)
+#define NVME_IOCTL_IO_CMD	    _IOWR('N', 0x43, struct nvme_passthru_cmd)
+
+#define ANA_LOG_LEN 4096
+#define ANA_LOG_HEAD 16
+
+struct nvme_ana_log {
+    __le64 change_count;
+    __le16 nsgdn;
+    __u8   nsgdsz;
+    __u8   trans_time;
+    __u8   rsvd4[4];
+    __u8   nsgd[ANA_LOG_LEN - ANA_LOG_HEAD];
+};
+struct namespace_group_desc {    
+    __u32 nsgid;    
+    __u8  anas;/*0x01->Optimized, 0x02->Non-Optimized, 0x03->Inaccessible, 0x4->Transitioning*/
+};
+
+#endif
diff --git a/multipath-tools-HEAD-be1191b/libmultipath/structs.h b/multipath-tools-HEAD-be1191b/libmultipath/structs.h
index 98e13e4..d1a7721 100644
--- a/multipath-tools-HEAD-be1191b/libmultipath/structs.h
+++ b/multipath-tools-HEAD-be1191b/libmultipath/structs.h
@@ -182,6 +182,11 @@ struct sg_id {
 	int transport_id;
 };
 
+struct nvme_id
+{
+  int cntl_id;
+  unsigned int nsid;
+};
 # ifndef HDIO_GETGEO
 #  define HDIO_GETGEO	0x0301	/* get device geometry */
 
@@ -198,6 +203,7 @@ struct path {
 	char dev_t[BLK_DEV_SIZE];
 	struct udev_device *udev;
 	struct sg_id sg_id;
+    struct nvme_id nvme_id;
 	struct hd_geometry geom;
 	char wwid[WWID_SIZE];
 	char vendor_id[SCSI_VENDOR_SIZE];
-- 
2.6.4.windows.1
