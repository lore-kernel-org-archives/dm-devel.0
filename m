Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8738FBE
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="L5O/cL7N"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD50F21AEC;
	Thu, 26 Oct 2023 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g5MXBqLc61Gesil+YL/O8Pb+VlGxryHXihBbmx0wHBU=;
	b=L5O/cL7NuDbeZ90XjvsF+AgsT7Z/AjsbfJeD5cC6xpKpl2jPw9kkEJR0ubGUcu9t0+Qpr5
	S4NtQcEXW+d+l/KZKYpP+1wV7DWeGM450FCuicsRWB9OnBApIWLAUwiRaeUkakJtIxGtAy
	2DKVSbInAPSYwzw9vXtNlJZSInSheqY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 511EC1358F;
	Thu, 26 Oct 2023 17:42:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id qLqgEAalOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:30 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/14] multipathd.service: require modprobe@dm_multipath.service if available
Date: Thu, 26 Oct 2023 19:41:47 +0200
Message-ID: <20231026174153.1133-9-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026174153.1133-1-mwilck@suse.com>
References: <20231026174153.1133-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -6.10
X-Spamd-Result: default: False [-6.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

systemd v245 and newer provides the modprobe@.service unit, which
can be used to pull in modules via systemd. This is cleaner than
loading dm-multipath unconditionally via modules-load.d. Use it
if the detected systemd version support it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc                                             | 4 +++-
 multipath/Makefile                                       | 6 ++++--
 multipathd/Makefile                                      | 4 ++--
 multipathd/{multipathd.service => multipathd.service.in} | 4 ++--
 4 files changed, 11 insertions(+), 7 deletions(-)
 rename multipathd/{multipathd.service => multipathd.service.in} (85%)

diff --git a/Makefile.inc b/Makefile.inc
index 04bfa56..8655cba 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -90,6 +90,8 @@ ORIG_LDFLAGS     := $(LDFLAGS)
 
 SYSTEMD_CPPFLAGS := $(if $(SYSTEMD),-DUSE_SYSTEMD=$(SYSTEMD))
 SYSTEMD_LIBDEPS := $(if $(SYSTEMD),$(if $(shell test $(SYSTEMD) -gt 209 && echo 1),-lsystemd,-lsystemd-daemon))
+MODPROBE_UNIT := $(shell test "0$(SYSTEMD)" -lt 245 2>/dev/null || \
+			echo "modprobe@dm_multipath.service")
 
 OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
 WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
@@ -144,4 +146,4 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 
 %:	%.in
 	@echo creating $@
-	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g' $< >$@
+	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' $< >$@
diff --git a/multipath/Makefile b/multipath/Makefile
index 68cb5ce..0efb9b2 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -27,14 +27,16 @@ install:
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
-	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
-	$(Q)$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man8
 	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(mandir)/man8
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man5
 	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5 $(DESTDIR)$(mandir)/man5
+	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
+ifeq ($(MODPROBE_UNIT),)
+	$(Q)$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
+endif
 ifneq ($(SCSI_DH_MODULES_PRELOAD),)
 	$(Q)$(INSTALL_PROGRAM) -m 644 scsi_dh.conf $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
 	$(Q)for _x in $(SCSI_DH_MODULES_PRELOAD); do echo "$$_x"; done \
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 0ba6ecb..997b40c 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
 
-all : $(EXEC) $(CLI) $(MANPAGES)
+all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -78,7 +78,7 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES)
+	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
 
 include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
 
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service.in
similarity index 85%
rename from multipathd/multipathd.service
rename to multipathd/multipathd.service.in
index 5a9cde1..6d03ff7 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service.in
@@ -2,8 +2,8 @@
 Description=Device-Mapper Multipath Device Controller
 Before=lvm2-activation-early.service
 Before=local-fs-pre.target blk-availability.service shutdown.target
-Wants=systemd-udevd-kernel.socket
-After=systemd-udevd-kernel.socket
+Wants=systemd-udevd-kernel.socket @MODPROBE_UNIT@
+After=systemd-udevd-kernel.socket @MODPROBE_UNIT@
 After=multipathd.socket systemd-remount-fs.service
 Before=initrd-cleanup.service
 DefaultDependencies=no
-- 
2.42.0

