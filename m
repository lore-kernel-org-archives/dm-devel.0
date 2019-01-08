From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] libmultipath: fix compilation with older
	kernel headers
Date: Tue,  8 Jan 2019 12:32:44 +0100
Message-ID: <20190108113246.5903-2-mwilck@suse.com>
References: <20190108113246.5903-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108113246.5903-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Compilation fails if the kernel headers don't provide
"linux/nvme_ioctl.h". Fix that by shipping the kernel header
file from nvme-cli.

Fixes: 17c71c79e276 "libmultipath: add wrapper library for nvme ioctls"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc                         |  1 +
 libmultipath/Makefile                | 11 ++---
 libmultipath/foreign/Makefile        |  7 ++-
 libmultipath/nvme/linux/nvme_ioctl.h | 67 ++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 12 deletions(-)
 create mode 100644 libmultipath/nvme/linux/nvme_ioctl.h

diff --git a/Makefile.inc b/Makefile.inc
index a83f02c7..23154fed 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -66,6 +66,7 @@ mpathpersistdir	= $(TOPDIR)/libmpathpersist
 mpathcmddir	= $(TOPDIR)/libmpathcmd
 thirdpartydir	= $(TOPDIR)/third-party
 libdmmpdir	= $(TOPDIR)/libdmmp
+nvmedir		= $(TOPDIR)/libmultipath/nvme
 includedir	= $(prefix)/usr/include
 pkgconfdir	= $(usrlibdir)/pkgconfig
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 78cca5a8..a2be42ea 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -7,7 +7,7 @@ SONAME = 0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 
-CFLAGS += $(LIB_CFLAGS) -I$(mpathcmddir) -I$(mpathpersistdir)
+CFLAGS += $(LIB_CFLAGS) -I$(mpathcmddir) -I$(mpathpersistdir) -I$(nvmedir)
 
 LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu -laio
 
@@ -43,17 +43,12 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
-	io_err_stat.o dm-generic.o generic.o foreign.o
-
-ifneq ($(call check_file,/usr/include/linux/nvme_ioctl.h),0)
-	OBJS += nvme-lib.o
-	CFLAGS += -Invme
-endif
+	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o
 
 all: $(LIBS)
 
 nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
-	$(CC) $(CFLAGS) -Wno-unused-function -I. -Invme -c -o $@ $<
+	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
 
 make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
 
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index 713762cb..fae58a0d 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -1,13 +1,12 @@
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
+TOPDIR=../..
 include ../../Makefile.inc
 
-CFLAGS += $(LIB_CFLAGS) -I.. -I../nvme
+CFLAGS += $(LIB_CFLAGS) -I.. -I$(nvmedir)
 
-# If you add or remove a checker also update multipath/multipath.conf.5
-LIBS= \
-	libforeign-nvme.so
+LIBS = libforeign-nvme.so
 
 all: $(LIBS)
 
diff --git a/libmultipath/nvme/linux/nvme_ioctl.h b/libmultipath/nvme/linux/nvme_ioctl.h
new file mode 100644
index 00000000..d25a5322
--- /dev/null
+++ b/libmultipath/nvme/linux/nvme_ioctl.h
@@ -0,0 +1,67 @@
+/*
+ * Definitions for the NVM Express ioctl interface
+ * Copyright (c) 2011-2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _UAPI_LINUX_NVME_IOCTL_H
+#define _UAPI_LINUX_NVME_IOCTL_H
+
+#include <linux/types.h>
+#include <sys/ioctl.h>
+
+struct nvme_user_io {
+	__u8	opcode;
+	__u8	flags;
+	__u16	control;
+	__u16	nblocks;
+	__u16	rsvd;
+	__u64	metadata;
+	__u64	addr;
+	__u64	slba;
+	__u32	dsmgmt;
+	__u32	reftag;
+	__u16	apptag;
+	__u16	appmask;
+};
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
+#define nvme_admin_cmd nvme_passthru_cmd
+
+#define NVME_IOCTL_ID		_IO('N', 0x40)
+#define NVME_IOCTL_ADMIN_CMD	_IOWR('N', 0x41, struct nvme_admin_cmd)
+#define NVME_IOCTL_SUBMIT_IO	_IOW('N', 0x42, struct nvme_user_io)
+#define NVME_IOCTL_IO_CMD	_IOWR('N', 0x43, struct nvme_passthru_cmd)
+#define NVME_IOCTL_RESET	_IO('N', 0x44)
+#define NVME_IOCTL_SUBSYS_RESET	_IO('N', 0x45)
+#define NVME_IOCTL_RESCAN	_IO('N', 0x46)
+
+#endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
2.19.2
