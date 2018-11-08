From: lijie <lijie34@huawei.com>
Subject: [PATCH] multipath-tools: add ANA support for NVMe device
Date: Thu, 8 Nov 2018 14:09:41 +0800
Message-ID: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: lijie34@huawei.com, wangzhoumengjian@huawei.com, shenhong09@huawei.com, chengjike.cheng@huawei.com
List-Id: dm-devel.ids

Add support for Asynchronous Namespace Access as specified in NVMe 1.3
TP 4004. The states are updated through reading the ANA log page.

By default, the native nvme multipath takes over the nvme device.
We can pass a false to the parameter 'multipath' of the nvme-core.ko
module,when we want to use multipath-tools.
---
 libmultipath/prio.h                |   1 +
 libmultipath/prioritizers/Makefile |   1 +
 libmultipath/prioritizers/ana.c    | 292 +++++++++++++++++++++++++++++++++++++
 libmultipath/prioritizers/ana.h    | 221 ++++++++++++++++++++++++++++
 multipath/multipath.conf.5         |   8 +
 5 files changed, 523 insertions(+)
 create mode 100644 libmultipath/prioritizers/ana.c
 create mode 100644 libmultipath/prioritizers/ana.h

diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index aa587cc..599d1d8 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -30,6 +30,7 @@ struct path;
 #define PRIO_WEIGHTED_PATH	"weightedpath"
 #define PRIO_SYSFS		"sysfs"
 #define PRIO_PATH_LATENCY	"path_latency"
+#define PRIO_ANA		"ana"
 
 /*
  * Value used to mark the fact prio was not defined
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index ab7bc07..15afaba 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -19,6 +19,7 @@ LIBS = \
 	libpriordac.so \
 	libprioweightedpath.so \
 	libpriopath_latency.so \
+	libprioana.so \
 	libpriosysfs.so
 
 all: $(LIBS)
diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
new file mode 100644
index 0000000..c5aaa5f
--- /dev/null
+++ b/libmultipath/prioritizers/ana.c
@@ -0,0 +1,292 @@
+/*
+ * (C) Copyright HUAWEI Technology Corp. 2017   All Rights Reserved.
+ *
+ * ana.c
+ * Version 1.00
+ *
+ * Tool to make use of a NVMe-feature called  Asymmetric Namespace Access.
+ * It determines the ANA state of a device and prints a priority value to stdout.
+ *
+ * Author(s): Cheng Jike <chengjike.cheng@huawei.com>
+ *            Li Jie <lijie34@huawei.com>
+ *
+ * This file is released under the GPL version 2, or any later version.
+ */
+#include <stdio.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <stdbool.h>
+
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+#include "ana.h"
+
+enum {
+	ANA_PRIO_OPTIMIZED		= 50,
+	ANA_PRIO_NONOPTIMIZED		= 10,
+	ANA_PRIO_INACCESSIBLE		= 5,
+	ANA_PRIO_PERSISTENT_LOSS	= 1,
+	ANA_PRIO_CHANGE			= 0,
+	ANA_PRIO_RESERVED		= 0,
+	ANA_PRIO_GETCTRL_FAILED		= -1,
+	ANA_PRIO_NOT_SUPPORTED		= -2,
+	ANA_PRIO_GETANAS_FAILED		= -3,
+	ANA_PRIO_GETANALOG_FAILED	= -4,
+	ANA_PRIO_GETNSID_FAILED		= -5,
+	ANA_PRIO_GETNS_FAILED		= -6,
+	ANA_PRIO_NO_MEMORY		= -7,
+	ANA_PRIO_NO_INFORMATION		= -8,
+};
+
+static const char * anas_string[] = {
+	[NVME_ANA_OPTIMIZED]			= "ANA Optimized State",
+	[NVME_ANA_NONOPTIMIZED]			= "ANA Non-Optimized State",
+	[NVME_ANA_INACCESSIBLE]			= "ANA Inaccessible State",
+	[NVME_ANA_PERSISTENT_LOSS]		= "ANA Persistent Loss State",
+	[NVME_ANA_CHANGE]			= "ANA Change state",
+	[NVME_ANA_RESERVED]			= "Invalid namespace group state!",
+};
+
+static const char *aas_print_string(int rc)
+{
+	rc &= 0xff;
+
+	switch(rc) {
+	case NVME_ANA_OPTIMIZED:
+	case NVME_ANA_NONOPTIMIZED:
+	case NVME_ANA_INACCESSIBLE:
+	case NVME_ANA_PERSISTENT_LOSS:
+	case NVME_ANA_CHANGE:
+		return anas_string[rc];
+	default:
+		return anas_string[NVME_ANA_RESERVED];
+	}
+
+	return anas_string[NVME_ANA_RESERVED];
+}
+
+static int nvme_get_nsid(int fd, unsigned *nsid)
+{
+	static struct stat nvme_stat;
+	int err = fstat(fd, &nvme_stat);
+	if (err < 0)
+		return 1;
+
+	if (!S_ISBLK(nvme_stat.st_mode)) {
+		condlog(0, "Error: requesting namespace-id from non-block device\n");
+		return 1;
+	}
+
+	*nsid = ioctl(fd, NVME_IOCTL_ID);
+	return 0;
+}
+
+static int nvme_submit_admin_passthru(int fd, struct nvme_passthru_cmd *cmd)
+{
+	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, cmd);
+}
+
+int nvme_get_log13(int fd, __u32 nsid, __u8 log_id, __u8 lsp, __u64 lpo,
+                 __u16 lsi, bool rae, __u32 data_len, void *data)
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
+	cmd.cdw10 = log_id | (numdl << 16) | (rae ? 1 << 15 : 0);
+	if (lsp)
+		cmd.cdw10 |= lsp << 8;
+
+	cmd.cdw11 = numdu | (lsi << 16);
+	cmd.cdw12 = lpo;
+	cmd.cdw13 = (lpo >> 32);
+
+	return nvme_submit_admin_passthru(fd, &cmd);
+
+}
+
+int nvme_identify13(int fd, __u32 nsid, __u32 cdw10, __u32 cdw11, void *data)
+{
+	struct nvme_admin_cmd cmd = {
+		.opcode		= nvme_admin_identify,
+		.nsid		= nsid,
+		.addr		= (__u64)(uintptr_t) data,
+		.data_len	= NVME_IDENTIFY_DATA_SIZE,
+		.cdw10		= cdw10,
+		.cdw11		= cdw11,
+	};
+
+	return nvme_submit_admin_passthru(fd, &cmd);
+}
+
+int nvme_identify(int fd, __u32 nsid, __u32 cdw10, void *data)
+{
+	return nvme_identify13(fd, nsid, cdw10, 0, data);
+}
+
+int nvme_identify_ctrl(int fd, void *data)
+{
+	return nvme_identify(fd, 0, NVME_ID_CNS_CTRL, data);
+}
+
+int nvme_identify_ns(int fd, __u32 nsid, void *data)
+{
+	return nvme_identify(fd, nsid, NVME_ID_CNS_NS, data);
+}
+
+int nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo)
+{
+	__u64 lpo = 0;
+
+	return nvme_get_log13(fd, NVME_NSID_ALL, NVME_LOG_ANA, rgo, lpo, 0,
+			true, ana_log_len, ana_log);
+}
+
+static int get_ana_state(__u32 nsid, __u32 anagrpid, void *ana_log)
+{
+	int	rc = ANA_PRIO_GETANAS_FAILED;
+	void *base = ana_log;
+	struct nvme_ana_rsp_hdr *hdr = base;
+	struct nvme_ana_group_desc *ana_desc;
+	int offset = sizeof(struct nvme_ana_rsp_hdr);
+	__u32 nr_nsids;
+	size_t nsid_buf_size;
+	int i, j;
+
+	for (i = 0; i < le16_to_cpu(hdr->ngrps); i++) {
+		ana_desc = base + offset;
+		nr_nsids = le32_to_cpu(ana_desc->nnsids);
+		nsid_buf_size = nr_nsids * sizeof(__le32);
+
+		offset += sizeof(*ana_desc);
+
+		for (j = 0; j < nr_nsids; j++) {
+			if (nsid == le32_to_cpu(ana_desc->nsids[j]))
+				return ana_desc->state;
+		}
+
+		if (anagrpid != 0 && anagrpid == le32_to_cpu(ana_desc->grpid))
+			rc = ana_desc->state;
+
+		offset += nsid_buf_size;
+	}
+
+	return rc;
+}
+
+int get_ana_info(struct path * pp, unsigned int timeout)
+{
+	int	rc;
+	__u32 nsid;
+	struct nvme_id_ctrl ctrl;
+	struct nvme_id_ns ns;
+	void *ana_log;
+	size_t ana_log_len;
+
+	rc = nvme_identify_ctrl(pp->fd, &ctrl);
+	if (rc)
+		return ANA_PRIO_GETCTRL_FAILED;
+
+	if(!(ctrl.cmic & (1 << 3)))
+		return ANA_PRIO_NOT_SUPPORTED;
+
+	rc = nvme_get_nsid(pp->fd, &nsid);
+	if (rc)
+		return ANA_PRIO_GETNSID_FAILED;
+
+	rc = nvme_identify_ns(pp->fd, nsid, &ns);
+	if (rc)
+		return ANA_PRIO_GETNS_FAILED;
+
+	ana_log_len = sizeof(struct nvme_ana_rsp_hdr) +
+		le32_to_cpu(ctrl.nanagrpid) * sizeof(struct nvme_ana_group_desc);
+	if (!(ctrl.anacap & (1 << 6)))
+		ana_log_len += le32_to_cpu(ctrl.mnan) * sizeof(__le32);
+
+	ana_log = malloc(ana_log_len);
+	if (!ana_log)
+		return ANA_PRIO_NO_MEMORY;
+
+	rc = nvme_ana_log(pp->fd, ana_log, ana_log_len,
+		(ctrl.anacap & (1 << 6)) ? NVME_ANA_LOG_RGO : 0);
+	if (rc) {
+		free(ana_log);
+		return ANA_PRIO_GETANALOG_FAILED;
+	}
+
+	rc = get_ana_state(nsid, le32_to_cpu(ns.anagrpid), ana_log);
+	if (rc < 0){
+		free(ana_log);
+		return ANA_PRIO_GETANAS_FAILED;
+	}
+
+	free(ana_log);
+	condlog(3, "%s: ana state = %02x [%s]", pp->dev, rc, aas_print_string(rc));
+
+	return rc;
+}
+
+int getprio(struct path * pp, char * args, unsigned int timeout)
+{
+	int rc;
+
+	if (pp->fd < 0)
+		return ANA_PRIO_NO_INFORMATION;
+
+	rc = get_ana_info(pp, timeout);
+	if (rc >= 0) {
+		rc &= 0x0f;
+		switch(rc) {
+		case NVME_ANA_OPTIMIZED:
+			rc = ANA_PRIO_OPTIMIZED;
+			break;
+		case NVME_ANA_NONOPTIMIZED:
+			rc = ANA_PRIO_NONOPTIMIZED;
+			break;
+		case NVME_ANA_INACCESSIBLE:
+			rc = ANA_PRIO_INACCESSIBLE;
+			break;
+		case NVME_ANA_PERSISTENT_LOSS:
+			rc = ANA_PRIO_PERSISTENT_LOSS;
+			break;
+		case NVME_ANA_CHANGE:
+			rc = ANA_PRIO_CHANGE;
+			break;
+		default:
+			rc = ANA_PRIO_RESERVED;
+		}
+	} else {
+		switch(rc) {
+		case ANA_PRIO_GETCTRL_FAILED:
+			condlog(0, "%s: couldn't get ctrl info", pp->dev);
+			break;
+		case ANA_PRIO_NOT_SUPPORTED:
+			condlog(0, "%s: ana not supported", pp->dev);
+			break;
+		case ANA_PRIO_GETANAS_FAILED:
+			condlog(0, "%s: couldn't get ana state", pp->dev);
+			break;
+		case ANA_PRIO_GETANALOG_FAILED:
+			condlog(0, "%s: couldn't get ana log", pp->dev);
+			break;
+		case ANA_PRIO_GETNS_FAILED:
+			condlog(0, "%s: couldn't get namespace", pp->dev);
+			break;
+		case ANA_PRIO_GETNSID_FAILED:
+			condlog(0, "%s: couldn't get namespace id", pp->dev);
+			break;
+		case ANA_PRIO_NO_MEMORY:
+			condlog(0, "%s: couldn't alloc memory", pp->dev);
+			break;
+		}
+	}
+	return rc;
+}
+
diff --git a/libmultipath/prioritizers/ana.h b/libmultipath/prioritizers/ana.h
new file mode 100644
index 0000000..92cfa9e
--- /dev/null
+++ b/libmultipath/prioritizers/ana.h
@@ -0,0 +1,221 @@
+#ifndef _ANA_H
+#define _ANA_H
+
+#include <linux/types.h>
+
+#define NVME_NSID_ALL			0xffffffff
+#define NVME_IDENTIFY_DATA_SIZE 	4096
+
+#define NVME_LOG_ANA			0x0c
+
+/* Admin commands */
+enum nvme_admin_opcode {
+	nvme_admin_get_log_page		= 0x02,
+	nvme_admin_identify		= 0x06,
+};
+
+enum {
+	NVME_ID_CNS_NS			= 0x00,
+	NVME_ID_CNS_CTRL		= 0x01,
+};
+
+/* nvme ioctl start */
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
+#define nvme_admin_cmd nvme_passthru_cmd
+
+#define NVME_IOCTL_ID		_IO('N', 0x40)
+#define NVME_IOCTL_ADMIN_CMD	_IOWR('N', 0x41, struct nvme_admin_cmd)
+/* nvme ioctl end */
+
+/* nvme id ctrl start */
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
+	__le16			edstt;
+	__u8			dsto;
+	__u8			fwug;
+	__le16			kas;
+	__le16			hctma;
+	__le16			mntmt;
+	__le16			mxtmt;
+	__le32			sanicap;
+	__le32			hmminds;
+	__le16			hmmaxd;
+	__u8			rsvd338[4];
+	__u8			anatt;
+	__u8			anacap;
+	__le32			anagrpmax;
+	__le32			nanagrpid;
+	__u8			rsvd352[160];
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
+	__u8			nwpc;
+	__le16			acwu;
+	__u8			rsvd534[2];
+	__le32			sgls;
+	__le32			mnan;
+	__u8			rsvd544[224];
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
+/* nvme id ctrl end */
+
+/* nvme id ns start */
+struct nvme_lbaf {
+	__le16			ms;
+	__u8			ds;
+	__u8			rp;
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
+	__le16			noiob;
+	__u8			nvmcap[16];
+	__u8			rsvd64[28];
+	__le32			anagrpid;
+	__u8			rsvd96[3];
+	__u8			nsattr;
+	__u8			rsvd100[4];
+	__u8			nguid[16];
+	__u8			eui64[8];
+	struct nvme_lbaf	lbaf[16];
+	__u8			rsvd192[192];
+	__u8			vs[3712];
+};
+/* nvme id ns end */
+
+/* nvme ana start */
+enum nvme_ana_state {
+	NVME_ANA_OPTIMIZED		= 0x01,
+	NVME_ANA_NONOPTIMIZED		= 0x02,
+	NVME_ANA_INACCESSIBLE		= 0x03,
+	NVME_ANA_PERSISTENT_LOSS	= 0x04,
+	NVME_ANA_CHANGE			= 0x0f,
+	NVME_ANA_RESERVED		= 0x05,
+};
+
+struct nvme_ana_rsp_hdr {
+	__le64	chgcnt;
+	__le16	ngrps;
+	__le16	rsvd10[3];
+};
+
+struct nvme_ana_group_desc {
+	__le32	grpid;
+	__le32	nnsids;
+	__le64	chgcnt;
+	__u8	state;
+	__u8	rsvd17[15];
+	__le32	nsids[];
+};
+
+/* flag for the log specific field of the ANA log */
+#define NVME_ANA_LOG_RGO	(1 << 0)
+
+/* nvme ana end */
+
+#endif
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6333366..c5b2fb6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -334,6 +334,10 @@ priority provided as argument. Requires prio_args keyword.
 Generate the path priority based on a latency algorithm.
 Requires prio_args keyword.
 .TP
+.I ana
+(Hardware-dependent)
+Generate the path priority based on the NVMe ANA settings.
+.TP
 .I datacore
 (Hardware-dependent)
 Generate the path priority for some DataCore storage arrays. Requires prio_args
@@ -1391,6 +1395,10 @@ Active/Standby mode exclusively.
 .I 1 alua
 (Hardware-dependent)
 Hardware handler for SCSI-3 ALUA compatible arrays.
+.TP
+.I 1 ana
+(Hardware-dependent)
+Hardware handler for NVMe ANA compatible arrays.
 .PP
 The default is: \fB<unset>\fR
 .PP
-- 
2.6.4.windows.1
