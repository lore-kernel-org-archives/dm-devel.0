From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/19] libmultipath: add wrapper library for nvme
	ioctls
Date: Wed, 19 Dec 2018 00:19:25 +0100
Message-ID: <20181218231931.10762-14-mwilck@suse.com>
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

Create a small wrapper around the code from nvme-cli provide
the necessary functionality (and only that) for libmultipath.

libmultipath code should include "nvme-lib.h" and possibly
"nvme.h" (the latter with -Invme"). The nvme-cli code is
rewritten, changing all functions to static linkage, and
included by nvme-lib.c, so that only those functions that
are actually exported via nvme-lib.c become part of
libmultipath.

This allows us to include the nvme-cli code without modifications,
and at the same time not carry around binary code for stuff we
don't need.

When additional functionality from nvme-cli is needed, more
wrappers need to be added to nvme-lib.[hc].

Cc: lijie <lijie34@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile   | 17 ++++++++++++++++-
 libmultipath/nvme-lib.c | 36 ++++++++++++++++++++++++++++++++++++
 libmultipath/nvme-lib.h | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100644 libmultipath/nvme-lib.c
 create mode 100644 libmultipath/nvme-lib.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 33f52691..7d27ea7f 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -45,8 +45,23 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
 	io_err_stat.o dm-generic.o generic.o foreign.o
 
+ifneq ($(call check_file,/usr/include/linux/nvme_ioctl.h),0)
+	OBJS += nvme-lib.o
+endif
+
 all: $(LIBS)
 
+nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
+	$(CC) $(CFLAGS) -Wno-unused-function -I. -Invme -c -o $@ $<
+
+make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
+
+nvme-ioctl.c: nvme/nvme-ioctl.c
+	$(call make_static,$<,$@)
+
+nvme-ioctl.h: nvme/nvme-ioctl.h
+	$(call make_static,$<,$@)
+
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
 	$(LN) $@ $(DEVLIB)
@@ -62,7 +77,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz
+	$(RM) core *.a *.o *.so *.so.* *.gz nvme-ioctl.c nvme-ioctl.h
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmultipath/nvme-lib.c b/libmultipath/nvme-lib.c
new file mode 100644
index 00000000..9c32f369
--- /dev/null
+++ b/libmultipath/nvme-lib.c
@@ -0,0 +1,36 @@
+#include <sys/types.h>
+/* avoid inclusion of standard API */
+#define _NVME_LIB_C 1
+#include "nvme-lib.h"
+#include "nvme-ioctl.c"
+#include "debug.h"
+
+int log_nvme_errcode(int err, const char *dev, const char *msg)
+{
+	if (err > 0)
+		condlog(3, "%s: %s: NVMe status %d", dev, msg, err);
+	else if (err < 0)
+		condlog(3, "%s: %s: %s", dev, msg, strerror(errno));
+	return err;
+}
+
+int libmp_nvme_get_nsid(int fd)
+{
+	return nvme_get_nsid(fd);
+}
+
+int libmp_nvme_identify_ctrl(int fd, struct nvme_id_ctrl *ctrl)
+{
+	return nvme_identify_ctrl(fd, ctrl);
+}
+
+int libmp_nvme_identify_ns(int fd, __u32 nsid, bool present,
+			   struct nvme_id_ns *ns)
+{
+	return nvme_identify_ns(fd, nsid, present, ns);
+}
+
+int libmp_nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo)
+{
+	return nvme_ana_log(fd, ana_log, ana_log_len, rgo);
+}
diff --git a/libmultipath/nvme-lib.h b/libmultipath/nvme-lib.h
new file mode 100644
index 00000000..445c4f46
--- /dev/null
+++ b/libmultipath/nvme-lib.h
@@ -0,0 +1,33 @@
+#ifndef NVME_LIB_H
+#define NVME_LIB_H
+
+#include "nvme.h"
+
+int log_nvme_errcode(int err, const char *dev, const char *msg);
+int libmp_nvme_get_nsid(int fd);
+int libmp_nvme_identify_ctrl(int fd, struct nvme_id_ctrl *ctrl);
+int libmp_nvme_identify_ns(int fd, __u32 nsid, bool present,
+			   struct nvme_id_ns *ns);
+int libmp_nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo);
+
+#ifndef _NVME_LIB_C
+/*
+ * In all files except nvme-lib.c, the nvme functions can be called
+ * by their usual name.
+ */
+#define nvme_get_nsid libmp_nvme_get_nsid
+#define nvme_identify_ctrl libmp_nvme_identify_ctrl
+#define nvme_identify_ns libmp_nvme_identify_ns
+#define nvme_ana_log libmp_nvme_ana_log
+/*
+ * Undefine these to avoid clashes with libmultipath's byteorder.h
+ */
+#undef cpu_to_le16
+#undef cpu_to_le32
+#undef cpu_to_le64
+#undef le16_to_cpu
+#undef le32_to_cpu
+#undef le64_to_cpu
+#endif
+
+#endif /* NVME_LIB_H */
-- 
2.19.2
