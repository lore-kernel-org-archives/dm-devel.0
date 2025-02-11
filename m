Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0A7265639
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 19:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739303542; cv=none; b=puYk88AIRszt94vyYXbLDDr5ZM6j9rfB5Xo0yrVeQBFePQggeTNxAPbzdPlmBNvhAUIFh1dE42zqiRDuWKrQ2PjC3zXCdFWuinLYZqgq8U3vgRCuDqE6aWzfm9iyY6abbJvKwtUWGuJfA5s+xs9zb2Nm5yKjXi2rB1FPI4cumMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739303542; c=relaxed/simple;
	bh=4xkOQYl+RIx2EkBgG2RL5FlAz+ZaeqrM4MaUAE/LK3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf5XV/LGuPf3FBkSrMXq3U6eY7xMQfOCah5zyi9YV/4dJFIKOxNrNhMm3NiGbgKdRbkm11zStrsBaCOylh7n9ZvbE00qfWAE8vn2qZ+mAXKg1ODaltruQ2iZIk4AqfsRKkSaPVv0bUMTc1ne1cAOS2J6gJrGKIyo8L6o0FcB4EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NfPT5VMQ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NfPT5VMQ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38de1a5f039so1983369f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 11:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739303538; x=1739908338; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJMhx+1JTRbqFgPhkRl93wpIHovd22LnpjGYIlRsd4U=;
        b=NfPT5VMQ08FpxSXbO/mphoKIDo8M2MzHRv1lr2henQczLZaYoQh2sX9fdm2IXwNvw0
         T4rmPUxqMZg7aMi6+i7FllTf6je5Xs43IOOzGtefWOsCH3b2ZZWrvO+ExD5eUppdVdff
         u115qRuem6n8zZ8YpOCV4INHBNqLK+AV/xegeB0VwLmZ6seSnkNYlUXg5n28mY8s3WKG
         Ld2fP+oxo9l4pB0/JkQ6391tt6L30JDbg4XVrDqjWoUiO5PS+Yg5J8XuugjTZLHdIJOZ
         7m7gXDuUW6YniiUgkrx3q1ezgnq/48+fM+Y+TxWuWLJfzXqz0FjoFPJShVKRzTwugMhV
         MWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739303538; x=1739908338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJMhx+1JTRbqFgPhkRl93wpIHovd22LnpjGYIlRsd4U=;
        b=DrDpsutp1KyH13VLL/vDRbAqpa5ctR6NL/GkLbrrNIxCfRV/5s0NbU8da04DH8ItkR
         C+X/1gXjLSzGGixangTs7GO+HMq9AA2+5A3U5tjfg1qg9W5Ws1Z1z57TF3oDbltbaLv3
         ovBldKUHdAW1mNB1KH7yycM20m3HUQ+DVebw56kV1f0/imqdFTscD+SHA/G0IlrEkskr
         uFwv51WwDSCgCldylVo+KTpC6qWIPOzgv+r6ALKS3JaXUUpcIa+vEH4HY+hZNmqUscSj
         qI0GiedbRv4x6C7VNO+36JgmG67o20Jj/uzPnsxYvu/3pJQ4tnXX2c6qVPmroRmvuyd1
         ZuXQ==
X-Gm-Message-State: AOJu0YyJwobJ8wUWtdV0+oJpX7yGvxqmISMwgVih9dROuQ9dxJy5O82M
	4ZlrS9SQgiV6nNlKMTA1K0Do3Fyf6P+yy+oXvn76Z47fadc3QChmzy0h2X5/Qro=
X-Gm-Gg: ASbGnctn8cVig7VbXd/JorGQiznc880Csbqp36IkpFfGBmWQ0T3l28XgMywcZOOPnv4
	+wOF/Viy0w1Wmy9/zTvVmgnUXFGvReqWf1LQiTCDD8F1W2CS8GBDE97KdQHNHLyLxDC4cRxhspB
	RhbeK7M2RDlmRq4Kc/L7c/o6Je3TQ0Up+sc8oOiG4FJ2NVUVsssRHn8gIHEYab0qjk5V+VB1uoi
	ciSKgp/EXE4NZNLXrIYeTTGo0C3sfBevwgG/IMc1K/UQL/gfxoXzz6/CCgfxqGCVkoMXWov0rck
	m/YtMHmYlgF/yYYvccFv+wWLbGUi6DumABi+fojwhng=
X-Google-Smtp-Source: AGHT+IGKGdIe55JbEl/rCwd1jUAMUEtJow5V4ueplZVz/HXecnjGJwhc81V5zy6xAU3Sz4IkZtBJtQ==
X-Received: by 2002:a5d:5848:0:b0:38d:d632:ae32 with SMTP id ffacd0b85a97d-38dea2e1e37mr237952f8f.50.1739303538138;
        Tue, 11 Feb 2025 11:52:18 -0800 (PST)
Received: from localhost (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38dbde0fd23sm15558186f8f.71.2025.02.11.11.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 11:52:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	afrosi@redhat.com
Subject: [PATCH 2/2] multipath-tools: allow using a regular Unix socket for multipathd
Date: Tue, 11 Feb 2025 20:52:02 +0100
Message-ID: <20250211195202.116307-3-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211195202.116307-1-mwilck@suse.com>
References: <20250211195202.116307-1-mwilck@suse.com>
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

[1] https://github.com/opensvc/multipath-tools/issues/111

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                                    |  1 +
 Makefile.inc                                  |  9 ++++++--
 README.md                                     |  4 ++++
 libmpathcmd/mpath_cmd.c                       |  5 +++--
 libmpathutil/uxsock.c                         | 21 ++++++++++++++++---
 multipathd/Makefile                           |  6 +++---
 ...multipathd.socket => multipathd.socket.in} |  2 +-
 7 files changed, 37 insertions(+), 11 deletions(-)
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
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index a38e8b6..fdc7951 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -100,12 +100,13 @@ int mpath_connect__(int nonblocking)
 	size_t len;
 	struct sockaddr_un addr;
 	int flags = 0;
+	const int offset = USE_REGULAR_SOCKET ? 0 : 1;
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
-	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, sizeof(addr.sun_path) - 1);
-	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
+	strncpy(&addr.sun_path[offset], DEFAULT_SOCKET, sizeof(addr.sun_path) - offset);
+	len = strlen(DEFAULT_SOCKET) + offset + sizeof(sa_family_t);
 	if (len > sizeof(struct sockaddr_un))
 		len = sizeof(struct sockaddr_un);
 
diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 2135476..976a047 100644
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
@@ -45,6 +46,7 @@ int ux_socket_listen(const char *name)
 	int num;
 #endif
 	struct sockaddr_un addr;
+	const int offset = USE_REGULAR_SOCKET ? 0 : 1;
 
 #ifdef USE_SYSTEMD
 	num = sd_listen_fds(0);
@@ -56,6 +58,11 @@ int ux_socket_listen(const char *name)
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
@@ -66,10 +73,10 @@ int ux_socket_listen(const char *name)
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
-	len = strlen(name) + 1;
+	len = strlen(name) + offset;
 	if (len >= sizeof(addr.sun_path))
-		len = sizeof(addr.sun_path) - 1;
-	memcpy(&addr.sun_path[1], name, len);
+		len = sizeof(addr.sun_path);
+	memcpy(&addr.sun_path[offset], name, len);
 
 	len += sizeof(sa_family_t);
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
@@ -78,6 +85,14 @@ int ux_socket_listen(const char *name)
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
index 997b40c..3673b1e 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
 
-all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
+all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -75,10 +75,10 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(CLI).8
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
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

