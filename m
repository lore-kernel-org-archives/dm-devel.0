Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07206268FE8
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 22:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739312496; cv=none; b=sOAhauoP03xeQi1kMSrmQvhSQVC42oWu4h5cZqvQGe7WpAJgIww4traiq4/VkVPa7prHimm3r/BuSvMctxsaX4S8qzzfL90CCUgBQfK2cArCX+fzkfsxd2bg7KzLoZWsNbKYEOJOW1dYS8tEMQyEhtKEXx3kOqZ6S04I0j04iow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739312496; c=relaxed/simple;
	bh=JMEYD3hpHIcw0M1YMsi0inq/uGaY5Bo25PmCheDRJ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGyeUBpEdBFKB0yDA5CsCRwjDj7q8hPZyFRIjler6OtE330UBwOb8bfkDoCt+1kPupu8Q4x3jzE3tTWKavuQw7sHnTwiGD2yd8tJl0MJIvnu4AlFmkmMdxgjcRQkbj8hvkh2Z6t2l9I3C9io5I3tUyJAhIOGDQGQXZbJAG5BaD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d0HwmJuW; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d0HwmJuW"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4395a06cf43so284915e9.2
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 14:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739312492; x=1739917292; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hm4cZB7GEnYMn9FTjkv1jtPXqvDXCPq09G/huzYoyno=;
        b=d0HwmJuW+NHew4AjEFkbg4kdJemOu527yCol+hI2qJdek+t/I9pglk8tdYmYnGFK0G
         Azbd+xWZck6oFr/m+5z0Srqe6mEf6Os7ieTiqYPbHREt4A9THU8Z4sFvnWsWbN/6d4JS
         BbNzd2V57li1uleR9N3TFMvLoM8WzCNLWCq62afpoWfu5sdeZGj08NA4wBEzyTzKUdOn
         96KXP+SbhU6I3fWev7DNJmNvJX6EyIepRmfw/KJoXuLtMtjRuNH98uEh/FszrxA5khqW
         wFc+JpBZSTuujRBqbxUXnDFSyo4BJRa8ghmbOL2QjHoJDEz69A3X7OqjVfubLJzs7bxr
         T/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739312492; x=1739917292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hm4cZB7GEnYMn9FTjkv1jtPXqvDXCPq09G/huzYoyno=;
        b=H1A2r0dDH5v37rHCPRKLCHiAMa//9Dwgun6pqMpeWw4kxpCSPVkCoeES8xdITUa+RG
         7lh+7rpzjYMOu6KMzcZiKuwwNw+bPwRYULpLAa7uphY1Wm2dMFC5yLQt/uNfvHpUTBEk
         UAZsua+nfchoDuieWqRYX3VcIEt+3mhdX8HXvJ92iBt8TaAfaveDc7R4EUfhEkZ8WfhR
         ujZadL+BJxFCH6JscDDaAxQAatj9L4YzQQ+5pLxGN/eNclxDUwnCc1YSqHBHi/ysaZNe
         f+1ppuL53BXL81/zkxjaX9Ic5gJPVmP4kcTYOdepoVlwFak27EDkHHmb+ZeyXSeafg3M
         uEGg==
X-Gm-Message-State: AOJu0Yw/vcl6q5pxWAx6J3lMi9/6LksNcAak/D201AHd3G7+IPZZ/d3/
	CON3iG/JdQ9/b+8PQEToTGTDvbvf2oQ1Nq2Mz5646kTqdVDursRz0pXcCrD+nyU=
X-Gm-Gg: ASbGncvOO/x7V7jaEISwA57YbinZMHgAaSiX+9MINnitIkBTRpGWagNRSKBXdeUSMNe
	WVA1sHbDT9ICaRTxkH9lFyMp0+KsIkV4fQMc59MNTuolCG9GAANRKbqPE2WFTYIgkewCTW/B1Ip
	rji/Mgv0z496Bl1gqUBy+gNJ93tbwB6lCOlElS3wVPUAbddHYD0Pl9O5So5uR31Le3y+zRc3Naj
	Sn+vr0Kk42V74w20EqnMQdSlaZDpi8Ct/Ljyg5WpUc6ItsD3jd7/fSQlIOKNTrKfuxtQ9yhQWQr
	gpke/dQ8JCquYo4EbboV/AXOUA0PO+MzYWvHnO1O0W0=
X-Google-Smtp-Source: AGHT+IG2b9VuXugtsWsdbzEI0r24vj9LQx4m5VTUjpTQe5OGmq3Wv5AcVTU8lO3Pcgk1Hdm6k62UMA==
X-Received: by 2002:a05:600c:1552:b0:439:4036:e925 with SMTP id 5b1f17b1804b1-43958176876mr10408775e9.11.1739312491877;
        Tue, 11 Feb 2025 14:21:31 -0800 (PST)
Received: from localhost (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4395a053f46sm977575e9.14.2025.02.11.14.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 14:21:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	afrosi@redhat.com
Subject: [PATCH v2 2/2] multipath-tools: allow using a regular Unix socket for multipathd
Date: Tue, 11 Feb 2025 23:21:26 +0100
Message-ID: <20250211222126.182370-3-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211222126.182370-1-mwilck@suse.com>
References: <20250211222126.182370-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Accessing multipathd's socket from a different network namespace (e.g. from a
container) is impossible with an abstract socket. Add the option to compile
multipathd using a regular Unix socket instead, by compiling with the flag
"use_regular_socket=1". By default, the socket path is /run/multipathd.

While at it, introduce a common helper function for filling in the struct
sockaddr_un correctly, and make sure the socket name is properly
NULL-terminated.

[1] https://github.com/opensvc/multipath-tools/issues/111

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                                    |  1 +
 Makefile.inc                                  |  9 +++++--
 README.md                                     |  4 +++
 libmpathcmd/libmpathcmd.version               |  5 ++++
 libmpathcmd/mpath_cmd.c                       | 27 +++++++++++++------
 libmpathcmd/mpath_cmd.h                       |  6 +++++
 libmpathutil/uxsock.c                         | 24 ++++++++++-------
 multipathd/Makefile                           |  7 +++--
 ...multipathd.socket => multipathd.socket.in} |  2 +-
 9 files changed, 61 insertions(+), 24 deletions(-)
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
index 949e7b5..104aeaf 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -79,8 +79,11 @@ libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr
 kernel_incdir	:= /usr/include
 sysdir_bin      := $(sys_execprefix)bin
 
+use_regular_socket   :=
+regular_socket_path  := /run/multipathd.socket
 abstract_socket_path := /org/kernel/linux/storage/multipathd
-mpath_socket         := $(abstract_socket_path)
+mpath_socket         := $(if $(use_regular_socket),$(regular_socket_path),$(abstract_socket_path))
+mpath_socket_systemd := $(if $(use_regular_socket),$(regular_socket_path),@$(abstract_socket_path))
 
 ifeq ($(V),)
 Q		:= @
@@ -118,7 +121,8 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" \
-		   -DDEFAULT_SOCKET=\"$(mpath_socket)\" -MMD -MP
+		   -DDEFAULT_SOCKET=\"$(mpath_socket)\" -DUSE_REGULAR_SOCKET=$(if $(use_regular_socket),1,0) \
+		   -MMD -MP
 CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -fexceptions
 BIN_CFLAGS	:= -fPIE -DPIE
@@ -171,4 +175,5 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 		-e 's:@SYSDIR_BIN@:'$(sysdir_bin)': g' \
 		-e 's:@RUNTIME_DIR@:'$(runtimedir)':g' \
 		-e 's/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' \
+		-e 's,@MPATH_SOCKET@,'$(mpath_socket_systemd)',g' \
 		$< >$@
diff --git a/README.md b/README.md
index 530caed..f6cf675 100644
--- a/README.md
+++ b/README.md
@@ -121,6 +121,10 @@ The following variables can be passed to the `make` command line:
     stores run-time settings that need persist between reboots, such as known
 	WWIDs, user-friendly names, and persistent reservation keys.
 	The default is `$(etc_prefix)/etc/multipath`.
+ * `use_regular_socket`: if unset (default), use an abstract socket, which is
+   invisible in the file system. Otherwise, if set to 1, use the regular unix socket
+   `/run/multipathd.socket`. Setting this to 1 is necessary in order to
+   communicate with **multipathd** from containers.
  * `READLINE=libedit` or `READLINE=libreadline`: enable command line history
     and TAB completion in the interactive mode *(which is entered with `multipathd -k` or `multipathc`)*.
     The respective development package will be required for building.
diff --git a/libmpathcmd/libmpathcmd.version b/libmpathcmd/libmpathcmd.version
index 81bdb2b..85ed6d2 100644
--- a/libmpathcmd/libmpathcmd.version
+++ b/libmpathcmd/libmpathcmd.version
@@ -27,3 +27,8 @@ LIBMPATHCMD_1.1.0 {
 global:
 	mpath_connect__;
 } LIBMPATHCMD_1.0.0;
+
+LIBMPATHCMD_1.2.0 {
+global:
+	mpath_fill_sockaddr;
+} LIBMPATHCMD_1.1.0;
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index a38e8b6..6e65ffe 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -91,6 +91,24 @@ static size_t write_all(int fd, const void *buf, size_t len)
 	return total;
 }
 
+size_t mpath_fill_sockaddr(struct sockaddr_un *addr, const char *name)
+{
+	size_t len;
+
+	addr->sun_family = AF_LOCAL;
+
+#if USE_REGULAR_SOCKET
+	strncpy(&addr->sun_path[0], name, sizeof(addr->sun_path) - 1);
+	len = offsetof(struct sockaddr_un, sun_path) + strlen(name) + 1;
+#else
+	addr->sun_path[0] = '\0';
+	strncpy(&addr->sun_path[1], name, sizeof(addr->sun_path) - 2);
+	len = offsetof(struct sockaddr_un, sun_path) + strlen(name) + 2;
+#endif
+	addr->sun_path[sizeof(addr->sun_path) - 1] = '\0';
+	return len > sizeof(*addr) ? sizeof(*addr) : len;
+}
+
 /*
  * connect to a unix domain socket
  */
@@ -101,14 +119,6 @@ int mpath_connect__(int nonblocking)
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
@@ -119,6 +129,7 @@ int mpath_connect__(int nonblocking)
 			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
 	}
 
+	len = mpath_fill_sockaddr(&addr, DEFAULT_SOCKET);
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
 		int err = errno;
 
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index c96fabc..e68607d 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -19,6 +19,7 @@
 
 #ifndef MPATH_CMD_H_INCLUDED
 #define MPATH_CMD_H_INCLUDED
+#include <sys/un.h>
 
 /*
  * This should be sufficient for json output for >10000 maps,
@@ -32,6 +33,11 @@ extern "C" {
 
 #define DEFAULT_REPLY_TIMEOUT	4000
 
+/*
+ * DESCRIPTION:
+ *	Helper to fill in the socket name.
+ */
+size_t mpath_fill_sockaddr(struct sockaddr_un *addr, const char *name);
 
 /*
  * DESCRIPTION:
diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 2135476..3fcc2d9 100644
--- a/libmpathutil/uxsock.c
+++ b/libmpathutil/uxsock.c
@@ -12,6 +12,7 @@
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <sys/stat.h>
 #include <sys/un.h>
 #include <poll.h>
 #include <signal.h>
@@ -56,6 +57,11 @@ int ux_socket_listen(const char *name)
 		condlog(3, "using fd %d from sd_listen_fds", fd);
 		return fd;
 	}
+#endif
+#if USE_REGULAR_SOCKET
+	/* This is after the PID check, so unlinking should be fine */
+	if (unlink(name) == -1 && errno != ENOENT)
+		condlog(1, "Failed to unlink %s", name);
 #endif
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) {
@@ -63,21 +69,21 @@ int ux_socket_listen(const char *name)
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
+	len = mpath_fill_sockaddr(&addr, name);
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
 		condlog(3, "Couldn't bind to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
 
+#if USE_REGULAR_SOCKET
+	/*
+	 * Socket needs to have rw permissions for everone.
+	 * SO_PEERCRED makes sure that only root can modify things.
+	 */
+	if (chmod(name, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) == -1)
+		condlog(3, "failed to set permissions on %s: %s", name, strerror(errno));
+#endif
 	if (listen(fd, 10) == -1) {
 		condlog(3, "Couldn't listen to ux_socket, error %d", errno);
 		close(fd);
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 997b40c..bb9b828 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
 
-all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
+all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -74,11 +74,10 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/$(CLI)
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(CLI).8
-	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
-	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
+	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket $(EXEC).service
 
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

