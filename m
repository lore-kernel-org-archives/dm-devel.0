Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E788182A6D
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561196; cv=none; b=VXGb2ZLv/g2SGdPMZXju+AHltzfz0/yQcNGhSYXeq/LM7e8ACfkO3eYp8UKGhl+Z3qd9tEugNoT87c9iz+xdmUSDfgBX0eKVTSYRGwvBmMf3olNyDNwoksg0LkFa+07zb0vsW+b8YPMHB+IZ7PLvIxW8Jw+krlfrP5XGOXt7sQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561196; c=relaxed/simple;
	bh=T7Mq5cGilLHFMYJlP7yXIK3yW/5RLpMi4ELfKJcGt9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boBr/1foEd/fkJ4V+szXyIOXK8KPnHMgFDyB1mUHFSwy8P0cARrr54WTTdcc5OQgbR1QD5NTEHx4EnevR6bNfFvS24/fWE1+YP1zK+ooHEUoJlzxuz4v6hzssl+Zuw/X6rf49X9YZ1uEzDD9H8dB1dU+fGQtvaCMUc+UIdkk1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QuDXsOc6; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QuDXsOc6"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77e6dd7f72so408141266b.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561192; x=1721165992; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8z3x5Wiqhv2IfIl/eMb9I2plOqBG+uOhq9CkDfhkfBo=;
        b=QuDXsOc64FVljiUkKSXApvExLXT9yFL4qJfHDCFM0Kfkak6eA5jyTHsunsjnPfeWEV
         QG4GNc8xLGKxnnFomoPbokqj/XmY19/tP7mCvWm3rpMMgHwkQryTIsz4v2F07rb8afP2
         uq6QxrwivTXGQfKZoPUfHldh0M28HL4HsAiQCxGbNEVGS1cDr6p8Wo/AZPK5Gb1euq0c
         LrlsScbutEc/ARCayaveEvF2EAZyvG9UR99iBZ4oSEqT+it2JcOBHhHZlVmVtOaFer4H
         3FuNfxTIRT3HkSpaAqBlo5fbSN+Do3dsLjSktkUQ1UJyJgCmzPydPvkJk4Gh1iT53NcM
         bSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561192; x=1721165992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8z3x5Wiqhv2IfIl/eMb9I2plOqBG+uOhq9CkDfhkfBo=;
        b=h16xzzujuotom9KvYi6ZWrmD5wxC/CkkOwO9fCal/1BjUlgqFtqUe69pHxLKwDDYgX
         f85M2pyFs2zDPEP+RnKsOnk3PCvsX2Z79VDwcyfXvM5TgusrPN1ttojei+Xzh+IpM8tW
         PYjvpcHah9R5cUEy5OqKRsB7e/ZQZyHurPCnWVlxarLTfRBp3H3nmlSnmutXEMEp1eUj
         v7GJniRf4a0OoV2jU4YZ9vFV3yP1J5flAITWMyidQnO9z7z0SusuqUYgtxsrQeoNRkKg
         9J8c4mEMYKn5FBeq3utLHIjL18m+My07uEehAU3IsHuUh8vPKSW6v/IBluH7Sx19AAuC
         9TPw==
X-Gm-Message-State: AOJu0Yzi9Ewg8QKe6kaKhtULZArX/mM3YRcHV4Bphjy+kkQZ7AoNO98r
	BPpWM2X+PeO2kWLqw2rR6j/Xne/tiZRG7/YgnVKe28KOpXcyFqD7Oa1DtsRIgpM=
X-Google-Smtp-Source: AGHT+IGPkL0rqnbWDZoBCpMEQ8naFQGcqyxQKYx6g363YGVpMspyLq2OLi4oQwlVh9d7MyK15DAU9g==
X-Received: by 2002:a17:906:c107:b0:a72:9d25:8ad3 with SMTP id a640c23a62f3a-a780b68891cmr344255266b.9.1720561192196;
        Tue, 09 Jul 2024 14:39:52 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bd45a1absm1497489a12.77.2024.07.09.14.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:52 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 07/44] multipath-tools: Remove hard-coded paths to executables
Date: Tue,  9 Jul 2024 23:38:58 +0200
Message-ID: <20240709213935.177028-8-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
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

