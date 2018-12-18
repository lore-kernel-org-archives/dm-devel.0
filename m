From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 16/19] libmultipath: detect_prio: try ANA for NVMe
Date: Wed, 19 Dec 2018 00:19:28 +0100
Message-ID: <20181218231931.10762-17-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Check NVMe devices support ANA, and if yes, use ANA
for priority checks. The patch moves the ANA detection
functionality from the ANA prioritizer into generic code,
and uses it.

Cc: lijie <lijie34@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile           |  1 +
 libmultipath/nvme-lib.c         | 13 +++++++++++++
 libmultipath/nvme-lib.h         |  6 ++++++
 libmultipath/prioritizers/ana.c |  6 ++----
 libmultipath/propsel.c          | 25 +++++++++++++++++++------
 5 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 7d27ea7f..78cca5a8 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -47,6 +47,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 
 ifneq ($(call check_file,/usr/include/linux/nvme_ioctl.h),0)
 	OBJS += nvme-lib.o
+	CFLAGS += -Invme
 endif
 
 all: $(LIBS)
diff --git a/libmultipath/nvme-lib.c b/libmultipath/nvme-lib.c
index 9c32f369..f30e7698 100644
--- a/libmultipath/nvme-lib.c
+++ b/libmultipath/nvme-lib.c
@@ -34,3 +34,16 @@ int libmp_nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo)
 {
 	return nvme_ana_log(fd, ana_log, ana_log_len, rgo);
 }
+
+int nvme_id_ctrl_ana(int fd, struct nvme_id_ctrl *ctrl)
+{
+	int rc;
+	struct nvme_id_ctrl c;
+
+	rc = nvme_identify_ctrl(fd, &c);
+	if (rc < 0)
+		return rc;
+	if (ctrl)
+		*ctrl = c;
+	return c.cmic & (1 << 3) ? 1 : 0;
+}
diff --git a/libmultipath/nvme-lib.h b/libmultipath/nvme-lib.h
index 445c4f46..448dd993 100644
--- a/libmultipath/nvme-lib.h
+++ b/libmultipath/nvme-lib.h
@@ -9,6 +9,12 @@ int libmp_nvme_identify_ctrl(int fd, struct nvme_id_ctrl *ctrl);
 int libmp_nvme_identify_ns(int fd, __u32 nsid, bool present,
 			   struct nvme_id_ns *ns);
 int libmp_nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo);
+/*
+ * Identify controller, and return true if ANA is supported
+ * ctrl will be filled in if controller is identified, even w/o ANA
+ * ctrl may be NULL
+ */
+int nvme_id_ctrl_ana(int fd, struct nvme_id_ctrl *ctrl);
 
 #ifndef _NVME_LIB_C
 /*
diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index 88edb224..b22e7b4a 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -125,13 +125,11 @@ int get_ana_info(struct path * pp, unsigned int timeout)
 	size_t ana_log_len;
 	bool is_anagrpid_const;
 
-	rc = nvme_identify_ctrl(pp->fd, &ctrl);
+	rc = nvme_id_ctrl_ana(pp->fd, &ctrl);
 	if (rc < 0) {
 		log_nvme_errcode(rc, pp->dev, "nvme_identify_ctrl");
 		return -ANA_ERR_GETCTRL_FAILED;
-	}
-
-	if(!(ctrl.cmic & (1 << 3)))
+	} else if (rc == 0)
 		return -ANA_ERR_NOT_SUPPORTED;
 
 	nsid = nvme_get_nsid(pp->fd);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f5d87786..98068f34 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -5,6 +5,7 @@
  */
 #include <stdio.h>
 
+#include "nvme-lib.h"
 #include "checkers.h"
 #include "memory.h"
 #include "vector.h"
@@ -550,13 +551,25 @@ detect_prio(struct config *conf, struct path * pp)
 {
 	struct prio *p = &pp->prio;
 	char buff[512];
-	char *default_prio = PRIO_ALUA;
-
-	if (pp->tpgs <= 0)
-		return;
-	if (pp->tpgs == 2 || !check_rdac(pp)) {
-		if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
+	char *default_prio;
+
+	switch(pp->bus) {
+	case SYSFS_BUS_NVME:
+		if (nvme_id_ctrl_ana(pp->fd, NULL) == 0)
+			return;
+		default_prio = PRIO_ANA;
+		break;
+	case SYSFS_BUS_SCSI:
+		if (pp->tpgs <= 0)
+			return;
+		if ((pp->tpgs == 2 || !check_rdac(pp)) &&
+		    sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
 			default_prio = PRIO_SYSFS;
+		else
+			default_prio = PRIO_ALUA;
+		break;
+	default:
+		return;
 	}
 	prio_get(conf->multipath_dir, p, default_prio, DEFAULT_PRIO_ARGS);
 }
-- 
2.19.2
