Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF4171085
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804541; cv=none; b=iY05T688UFNphQBY2fRPYCex/JWYJUF+BxWX2sg6H44Hqfh6CsKx32Ncj+iArxUL2mIyVe1LL5D7GZHM/F11MWB9E1GgxIV8/HR/W0GHBOxeo8NtuDstCymw6H3voAz4SfR8inKXyCfcAtH5rx2ZzM/p8nMqOc359oDoRyCo3yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804541; c=relaxed/simple;
	bh=rDlaQHCWZ3uVd71QutXHQDhnycZROvvbRCXjPGmZAXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2MP5Mab3pwuo4jHwVE8foKeV2hjgnAbyy0LUmlI3HAaAAGax76EFph6GrSMsI4n24hERCBl6Q78JYn9JPF/7eiX/Mr1tXQslBqhufKfDe91kaJMukB//TrL2K3NIUY87O7BiwO82XNoXFtbssE0Q510/q/zcBC5XNokZqjhki8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cK0HahNz; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cK0HahNz"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77c080b521so282396966b.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804537; x=1721409337; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5J2XfElcXeeLrNofeMINOOTkKDTQ2yjH7D1MMLUFCq0=;
        b=cK0HahNzwQIDJz+ugx2Y41MNgGS7NDtOlIqv/KN3xs84CFGWLJ3tXouluKnKHsaCAl
         dqnZAVRW8Pc7l7xApO5S57QJXdnxLIbRBX1c1fGTuR4oJYJMEmlBJHEd5HWo0O3zRBY+
         y1LYWhh3PqegjnrJnq/JNMqOXBdztq3xpm4jSwAynd8zFGDZZg2Tx2MBalRuU9OshQbk
         u3wKhzB+civfxLqay3srZK8E0jqwgj+db5MQk4W1QsGwhp82NnmzLVc+QXC4bVU7lG56
         /CwX0XnSJXyLuIV1eI9dydWcBMZdyeMoS3G/9sEp2bkZzLn8eCcMwURv5n1SisfG+Alq
         fV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804537; x=1721409337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5J2XfElcXeeLrNofeMINOOTkKDTQ2yjH7D1MMLUFCq0=;
        b=mvRb5SMq1OqMkyAuIIw0lC1TICakZFG4fr9iCbFB9a9iAS3FsgVo7U/IyiQmjAdQxb
         w+kyFJvRAD6C6miMW2HQ89z2LefzzeaKdN/OpelDdBAuUo73nKWTz1WevEMjbA1muswZ
         6RSlmVUztjIOorQtK1S3I4Kk/5Gr3iT6rnQJwyrwhyOpw+mLtvdJtRfDBjNzIBpbId5u
         i0p7SuavZWa0IvtCcUbLc0MhvFWVkIPoGZMYvxd/2ZAX+wyyFO4Jy9kgV6f41a3k2/si
         w/+t6XcEsn2dxYyGH2v21fPiAryCjfeRbIIJwBm8I80Ac9jmwRwsHTX6oahlq8dplCiT
         y4wQ==
X-Gm-Message-State: AOJu0YxDjlwEv22NNlc2RZbSnEhMzWPm55vgBLWO9Bvg105QPLwugTeS
	YfHd1ZWfEQBonItYv7yBFPZFil0n/4/L4ijVE/Fp/8O82qrVJxb5MMUwqel5n1A=
X-Google-Smtp-Source: AGHT+IF1YdZkB3WbL3rviyIfzeHOH9AlApQQj3c4ha6/qKT3aZUShbEr5XWRGjbs0JdqmkniHz3OZQ==
X-Received: by 2002:a17:906:5a92:b0:a6f:51d8:1963 with SMTP id a640c23a62f3a-a780b6ff67amr803651066b.43.1720804536975;
        Fri, 12 Jul 2024 10:15:36 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bcc8csm367681966b.17.2024.07.12.10.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:36 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/49] multipath-tools: Remove hard-coded paths to executables
Date: Fri, 12 Jul 2024 19:14:15 +0200
Message-ID: <20240712171458.77611-8-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                   | 17 ++++++++++++++---
 kpartx/kpartx_id               |  8 ++++----
 multipath/11-dm-mpath.rules.in |  4 ++--
 multipath/multipath.rules.in   |  6 +++---
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 28b6032..fe9f1bf 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -42,9 +42,11 @@ etc_prefix	:= $(prefix)
 # Where to install systemd-related files. systemd is usually installed under /usr
 # Note: systemd installations with "split-usr=true" use separate "prefixdir" and
 # "rootprefixdir". Our systemd_prefix corresponds to "prefixdir".
-# In this case, override only unitdir and libudevdir below to use
-# systemd's "rootprefixdir" instead of $(systemd_prefix)
+# In this case, override only unitdir, libudevdir and sys_execprefix below
+# to use systemd's "rootprefixdir" instead of $(systemd_prefix)
 systemd_prefix  := /usr
+# Prefix for binaries that are owned by other packages (including systemd)
+sys_execprefix  := /usr
 
 # Make sure all prefix variables end in "/"
 append-slash = $(1)$(if $(filter %/,$(1)),,/)
@@ -53,6 +55,7 @@ override exec_prefix     := $(call append-slash,$(exec_prefix))
 override usr_prefix      := $(call append-slash,$(usr_prefix))
 override etc_prefix      := $(call append-slash,$(etc_prefix))
 override systemd_prefix  := $(call append-slash,$(systemd_prefix))
+override sys_execprefix  := $(call append-slash,$(sys_execprefix))
 
 unitdir		:= $(systemd_prefix)lib/systemd/system
 tmpfilesdir	:= $(systemd_prefix)lib/tmpfiles.d
@@ -74,6 +77,7 @@ runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/ru
 devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
 libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
 kernel_incdir	:= /usr/include
+sysdir_bin      := $(sys_execprefix)bin
 
 ifeq ($(V),)
 Q		:= @
@@ -150,4 +154,11 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 
 %:	%.in
 	@echo creating $@
-	$(Q)sed 's:@CONFIGFILE@:'$(TGTDIR)$(configfile)':g;s:@CONFIGDIR@:'$(TGTDIR)$(configdir)':g;s:@STATE_DIR@:'$(TGTDIR)$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(TGTDIR)$(bindir)':g' $< >$@
+	$(Q)sed -e 's:@CONFIGFILE@:'$(TGTDIR)$(configfile)':g' \
+		-e 's:@CONFIGDIR@:'$(TGTDIR)$(configdir)':g' \
+		-e 's:@STATE_DIR@:'$(TGTDIR)$(statedir)':g' \
+		-e 's:@BINDIR@:'$(TGTDIR)$(bindir)':g' \
+		-e 's:@SYSDIR_BIN@:'$(sysdir_bin)': g' \
+		-e 's:@RUNTIME_DIR@:'$(runtimedir)':g' \
+		-e 's/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' \
+		$< >$@
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index 4672927..f9211d2 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -21,8 +21,6 @@
 # sent upstream but has not been accepted yet.
 #
 
-DMSETUP=/sbin/dmsetup
-
 MAJOR=$1
 MINOR=$2
 UUID=$3
@@ -32,12 +30,14 @@ if [ -z "$MAJOR" -o -z "$MINOR" ]; then
     exit 1;
 fi
 
+DMSETUP=$(command -v dmsetup) || DMSETUP=/sbin/dmsetup
+
 # Device-mapper not installed; not an error
-if [ ! -x $DMSETUP ] ; then
+if [ ! -x "$DMSETUP" ] ; then
+    echo "$0: dmsetup not found" >&2
     exit 0
 fi
 
-
 # Table UUIDs are always '<type>-<uuid>'.
 dmuuid=${UUID#*-}
 dmtbl=${UUID%%-*}
diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 0562edd..30647b9 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -9,7 +9,7 @@ ENV{.DM_SUSPENDED}!="?*", ENV{.DM_SUSPENDED}="$env{DM_SUSPENDED}"
 
 # Coldplug event while device is suspended (e.g. during a reload)
 ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{.DM_SUSPENDED}=="1", \
-	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
+	PROGRAM="@SYSDIR_BIN@/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
 
 # Coldplug event. Import previously set properties.
@@ -70,7 +70,7 @@ LABEL="check_mpath_unchanged"
 IMPORT{db}="DM_COLDPLUG_SUSPENDED"
 ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
 	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
-	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
+	PROGRAM="@SYSDIR_BIN@/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
 	GOTO="check_mpath_ready"
 
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
diff --git a/multipath/multipath.rules.in b/multipath/multipath.rules.in
index 780bf85..2ac1972 100644
--- a/multipath/multipath.rules.in
+++ b/multipath/multipath.rules.in
@@ -2,7 +2,7 @@
 SUBSYSTEM!="block", GOTO="end_mpath"
 KERNEL!="sd*|dasd*|nvme*", GOTO="end_mpath"
 ACTION=="remove", TEST=="@RUNTIME_DIR@/multipath/find_multipaths/$major:$minor", \
-	RUN+="/usr/bin/rm -f @RUNTIME_DIR@/multipath/find_multipaths/$major:$minor"
+	RUN+="@SYSDIR_BIN@/rm -f @RUNTIME_DIR@/multipath/find_multipaths/$major:$minor"
 ACTION!="add|change", GOTO="end_mpath"
 
 IMPORT{cmdline}="nompath"
@@ -69,7 +69,7 @@ ENV{.SAVED_FM_WAIT_UNTIL}=="?*", GOTO="pretend_mpath"
 #
 # We must trigger an "add" event because LVM2 will only act on those.
 
-RUN+="/usr/bin/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property Conflicts=initrd-cleanup.service --timer-property Before=initrd-cleanup.service --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Conflicts=initrd-cleanup.service --property Before=initrd-cleanup.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} /usr/bin/udevadm trigger --action=add $sys$devpath"
+RUN+="@SYSDIR_BIN@/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property Conflicts=initrd-cleanup.service --timer-property Before=initrd-cleanup.service --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Conflicts=initrd-cleanup.service --property Before=initrd-cleanup.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger --action=add $sys$devpath"
 
 LABEL="pretend_mpath"
 ENV{DM_MULTIPATH_DEVICE_PATH}="1"
@@ -85,7 +85,7 @@ ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", GOTO="end_mpath"
 ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="0", GOTO="end_mpath"
 
 ENV{FIND_MULTIPATHS_WAIT_CANCELLED}="1"
-RUN+="/usr/bin/systemctl stop cancel-multipath-wait-$kernel.timer"
+RUN+="@SYSDIR_BIN@/systemctl stop cancel-multipath-wait-$kernel.timer"
 
 # If "multipath -u" failed, no values are imported from the program,
 # and we are still using the values for DM_MULTIPATH_DEVICE_PATH and
-- 
2.45.2

