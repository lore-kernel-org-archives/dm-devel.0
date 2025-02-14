Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C2B1FC0E0
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571030; cv=none; b=f7civVx5JctbmLxddCUXGlRiiQ6r6Rkef6T/EV7/2tnwHVrjdLE0fSTj5sAnTpVNQJ3OHZBQOiwvthDc5nQbY6NVwGW7yvcauwZaQgD6PsDJmHVjuOFIaP5p+kt4vB8LHi8JqMl5qdmNwj3wlzb2dis49b9CN7EjFNGxbEt7ptk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571030; c=relaxed/simple;
	bh=/E05KXQ4194m1gdad5uvswZz9gjlXIg7Mhf6fcFxmc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9Tk6GOeC7o+0j+lWr3Kgtqy/Dr9SRZ5OFx1XXH1iZXbxi4VwtfvHWXWaNEVPH6Xc9Wnq7RCJ0zH6bsof6FBueTlWo2UrVC6DNzNya4K+ZikSR6q4cTPR4Wqc7IpSr8VZl2xBEUojWz9P4gQaUKKwCCqNzJYxrTdP+XaPsjuwwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V0ld+7l6; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V0ld+7l6"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so4505515a12.1
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571025; x=1740175825; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOYjrERQAbKxd+P3j9lRvvt4TSnywH6bWoTyatpPUIE=;
        b=V0ld+7l6CX8QJgFSWXidEksz93gCfqoefCOXNf8pXAU+VHWs0IDkvtPlSCXxSonKZY
         CHt1g6hHNIBbQmegfHxI4h6b3sZfl9oU6smp4HAxdKDGpCnXAp5f1qWfViOVvCFo53IE
         HUDQVqcunFy5zcpF6/aD1/TsbM/SO6SO2jtXUdCEnYm48yF/jshd2bJmegtUfMgd997J
         8AS51RnEuljyp0XPSuVYUGL61uTckQn77sOcDMXqUkv7mlDeqQzOTQ1az3cWrBN5Jqxy
         HtV7occy+LbeBeuGggA9lP0csBn6cEt2NxHhepWi7BxIw98oG9DqmJQZORoMVW34lYDS
         RWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571025; x=1740175825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOYjrERQAbKxd+P3j9lRvvt4TSnywH6bWoTyatpPUIE=;
        b=VRIiyCsdY98dWyduccdJTbnPORX3Ffo69d5r9Wlg543VQos8RJcdyWt5I+2nMJrQ35
         UCP5yad8R6bfG3/MbWx9O5rIJd0Ngv0EWbhk4ihcafqbBf7oQdyJ6umNo2/7dP8Z9TeN
         IV2/+UWOUK++SyXn3syTg8x6K7Fi/WBUbcokuiNAsvEt/fXLzAKZsHgUYRrbI6dkApZN
         Pr+Prtdnrg9chkHT8pDxy8K21N0/1imSxxasLQ4nRT3ACozWynCe1uGWNTfLDdheEfVO
         +n8UB/WWJh6AaKZ/j7VM6jiLR0OGiTKDo5Mzj2KOSsMYd43SplmrrOAS/SFtctPM+1NU
         v9UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNkA3oS2ktm91RH5kdmMMQI9AQ+KDnG6wM5J+c6JLY+3palcsDIUtGXovXE1Z4XBEEH3b8GjFj3A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyUYY3EJFuNkm5baJplezzYdrst82ENUisIS4h0xdx41BWKtwc7
	n8SpNoRL8ye9Pusm3aFI/bUIMIBN69fA1RVO8bbCqzRIkneksPG0qzGQlpnnHGo=
X-Gm-Gg: ASbGncvqXxjxNFWxnAt4bUmTafD2xD1bcijLBUp/Mu7m9BkOC4Q0+5hFnQKePB5bLfn
	RVsgbUkvYHcGvX0l9KRne5NjfXZNhm/7ecH+YkiOrKlrIdbBc5PQX4wKGXgAxnFpVF0I/1Oy59I
	Num4CpW+pW6KLwQWPm3agocJuDmx3HrzxXJRz3/6JN17WlNXEhA/Fg1CILSQyBNlXckAmuTLFtd
	cvgKsLApUz6AyPdZHUif/wphgI0x5iunKjME8KSHMBZmEHb5yu/Dxbbo64q03HiMXyRZfGGMyke
	IqIpubupiFnndMTfbRTyzV2e9jNRvTRnqYU2u2oIktEBDYHSOfjPhCg94icAhcwr6zVJNs6EQVz
	zDg==
X-Google-Smtp-Source: AGHT+IGNY5MyMneLhMGT/CfglrlVO5hfud30BrgtI5vINd8aF5AMFgvo/5frxf1mcCPzoYlqFD4SrQ==
X-Received: by 2002:a17:907:7f27:b0:ab7:f096:61d8 with SMTP id a640c23a62f3a-abb70bfc808mr85680566b.29.1739571024791;
        Fri, 14 Feb 2025 14:10:24 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abb7200144fsm27207566b.184.2025.02.14.14.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:24 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 02/10] multipath-tools: add helper mpath_fill_sockaddr__()
Date: Fri, 14 Feb 2025 23:10:03 +0100
Message-ID: <20250214221011.136762-3-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214221011.136762-1-mwilck@suse.com>
References: <20250214221011.136762-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a static new helper function which is used by both libmpathcmd
and libmpathutil and fills in the socket address name from the compile-time
default. The function is able to handle both abstract and pathname sockets,
but more changes are needed to make the latter actually work.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                                    |  1 +
 Makefile.inc                                  |  7 ++--
 create-config.mk                              |  1 +
 libmpathcmd/mpath_cmd.c                       | 11 ++-----
 libmpathcmd/mpath_fill_sockaddr.c             | 32 +++++++++++++++++++
 libmpathutil/uxsock.c                         | 15 ++++-----
 multipathd/Makefile                           |  4 +--
 ...multipathd.socket => multipathd.socket.in} |  2 +-
 8 files changed, 51 insertions(+), 22 deletions(-)
 create mode 100644 libmpathcmd/mpath_fill_sockaddr.c
 rename multipathd/{multipathd.socket => multipathd.socket.in} (87%)

diff --git a/.gitignore b/.gitignore
index 4548cfb..6a1f6fc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -24,6 +24,7 @@ multipathd/multipathd
 multipathd/multipathd.8
 multipathd/multipathc
 multipathd/multipathd.service
+multipathd/multipathd.socket
 mpathpersist/mpathpersist
 mpathpersist/mpathpersist.8
 abi.tar.gz
diff --git a/Makefile.inc b/Makefile.inc
index 76efeb9..4015006 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -79,7 +79,7 @@ libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr
 kernel_incdir	:= /usr/include
 sysdir_bin      := $(sys_execprefix)bin
 
-abstract_socket := /org/kernel/linux/storage/multipathd
+abstract_socket := @/org/kernel/linux/storage/multipathd
 
 ifeq ($(V),)
 Q		:= @
@@ -117,7 +117,9 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" \
-		   -DDEFAULT_SOCKET=\"$(abstract_socket)\" -MMD -MP
+		   -DDEFAULT_SOCKET=\"$(abstract_socket)\" \
+		   -DWSTRINGOP_TRUNCATION=$(if $(WSTRINGOP_TRUNCATION),1,0) \
+		   -MMD -MP
 CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -fexceptions
 BIN_CFLAGS	:= -fPIE -DPIE
@@ -170,4 +172,5 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 		-e 's:@SYSDIR_BIN@:'$(sysdir_bin)': g' \
 		-e 's:@RUNTIME_DIR@:'$(runtimedir)':g' \
 		-e 's/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' \
+		-e 's,@MPATH_SOCKET@,'$(abstract_socket)',g' \
 		$< >$@
diff --git a/create-config.mk b/create-config.mk
index ab163ed..f05fdab 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -191,6 +191,7 @@ $(TOPDIR)/config.mk:	$(multipathdir)/autoconfig.h
 	@echo "ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)" >>$@
 	@echo "WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)" >>$@
 	@echo "WFORMATOVERFLOW := $(call TEST_CC_OPTION,-Wformat-overflow=2,)" >>$@
+	@echo "WSTRINGOP_TRUNCATION := $(call TEST_CC_OPTION,-Wstringop-truncation)" >>$@
 	@echo "W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)" >>$@
 	@echo "W_URCU_TYPE_LIMITS := $(call TEST_URCU_TYPE_LIMITS)" >>$@
 	@echo "ENABLE_LIBDMMP := $(ENABLE_LIBDMMP)" >>$@
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index a38e8b6..5a39471 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -24,11 +24,13 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <poll.h>
+#include <stddef.h>
 #include <string.h>
 #include <errno.h>
 #include <fcntl.h>
 
 #include "mpath_cmd.h"
+#include "mpath_fill_sockaddr.c"
 
 /*
  * keep reading until its all read
@@ -101,14 +103,6 @@ int mpath_connect__(int nonblocking)
 	struct sockaddr_un addr;
 	int flags = 0;
 
-	memset(&addr, 0, sizeof(addr));
-	addr.sun_family = AF_LOCAL;
-	addr.sun_path[0] = '\0';
-	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, sizeof(addr.sun_path) - 1);
-	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
-	if (len > sizeof(struct sockaddr_un))
-		len = sizeof(struct sockaddr_un);
-
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1)
 		return -1;
@@ -119,6 +113,7 @@ int mpath_connect__(int nonblocking)
 			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
 	}
 
+	len = mpath_fill_sockaddr__(&addr, DEFAULT_SOCKET);
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
 		int err = errno;
 
diff --git a/libmpathcmd/mpath_fill_sockaddr.c b/libmpathcmd/mpath_fill_sockaddr.c
new file mode 100644
index 0000000..750ef3e
--- /dev/null
+++ b/libmpathcmd/mpath_fill_sockaddr.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2025 SUSE LLC
+ * SPDX-license-identifier: LGPL-2.1-or-newer
+ */
+
+static size_t mpath_fill_sockaddr__(struct sockaddr_un *addr, const char *name)
+{
+	size_t len;
+
+	addr->sun_family = AF_LOCAL;
+
+	if (name[0] != '@') {
+		/* Pathname socket. This should be NULL-terminated. */
+		strncpy(&addr->sun_path[0], name, sizeof(addr->sun_path) - 1);
+		addr->sun_path[sizeof(addr->sun_path) - 1] = '\0';
+		len = offsetof(struct sockaddr_un, sun_path) + strlen(name) + 1;
+	} else {
+		addr->sun_path[0] = '\0';
+		/*
+		 * The abstract socket's name doesn't need to be NULL terminated.
+		 * Actually, a trailing NULL would be considered part of the socket name.
+		 */
+#pragma GCC diagnostic push
+#if WSTRINGOP_TRUNCATION
+#pragma GCC diagnostic ignored "-Wstringop-truncation"
+#endif
+		strncpy(&addr->sun_path[1], &name[1], sizeof(addr->sun_path) - 1);
+#pragma GCC diagnostic pop
+		len = offsetof(struct sockaddr_un, sun_path) + strlen(name);
+	}
+	return len > sizeof(*addr) ? sizeof(*addr) : len;
+}
diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 2135476..12c4608 100644
--- a/libmpathutil/uxsock.c
+++ b/libmpathutil/uxsock.c
@@ -6,12 +6,15 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <unistd.h>
 #include <stdarg.h>
+#include <stddef.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <sys/stat.h>
 #include <sys/un.h>
 #include <poll.h>
 #include <signal.h>
@@ -33,6 +36,8 @@
 static int _recv_packet(int fd, char **buf, unsigned int timeout,
 			ssize_t limit);
 
+#include "../libmpathcmd/mpath_fill_sockaddr.c"
+
 /*
  * create a unix domain socket and start listening on it
  * return a file descriptor open on the socket
@@ -63,15 +68,7 @@ int ux_socket_listen(const char *name)
 		return -1;
 	}
 
-	memset(&addr, 0, sizeof(addr));
-	addr.sun_family = AF_LOCAL;
-	addr.sun_path[0] = '\0';
-	len = strlen(name) + 1;
-	if (len >= sizeof(addr.sun_path))
-		len = sizeof(addr.sun_path) - 1;
-	memcpy(&addr.sun_path[1], name, len);
-
-	len += sizeof(sa_family_t);
+	len = mpath_fill_sockaddr__(&addr, name);
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
 		condlog(3, "Couldn't bind to ux_socket, error %d", errno);
 		close(fd);
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 997b40c..61cf1af 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
 
-all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
+all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -78,7 +78,7 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
+	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
 
 include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
 
diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket.in
similarity index 87%
rename from multipathd/multipathd.socket
rename to multipathd/multipathd.socket.in
index 6a62f5f..c0e86c3 100644
--- a/multipathd/multipathd.socket
+++ b/multipathd/multipathd.socket.in
@@ -7,7 +7,7 @@ ConditionVirtualization=!container
 Before=sockets.target
 
 [Socket]
-ListenStream=@/org/kernel/linux/storage/multipathd
+ListenStream=@MPATH_SOCKET@
 
 [Install]
 # Socket activation for multipathd is disabled by default.
-- 
2.48.1

