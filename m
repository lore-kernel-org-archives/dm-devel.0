Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DAB339AA
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qddffMYV"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 760D621906;
	Tue, 24 Oct 2023 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698166188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+5ArAMBWtpzfkzm4P7AZGVUlihkL7cX/mKRSC6lTUNU=;
	b=qddffMYVPsI/acYJONQdCTD3X13NqH2G0wiPqKSyNPUyifmuyb5JGKOiX9bsOfn3pNwk7l
	9NLlu1BMper6jT/+bvXvizk0p++rn2hsvI98OOS//R6uFZPfVQiyRna5IivmQH4zpfnydl
	xn0u/meadbvRi7ySaA+9e76Kid1DuNQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D64C134F5;
	Tue, 24 Oct 2023 16:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id mMWGDKz1N2VadQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 24 Oct 2023 16:49:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 5/6] multipath-tools: systemd: require modprobe@dm_multipath.service
Date: Tue, 24 Oct 2023 18:49:36 +0200
Message-ID: <20231024164937.14684-6-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024164937.14684-1-mwilck@suse.com>
References: <20231024164937.14684-1-mwilck@suse.com>
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
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[6];
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

Since 92f0893 ("multipath-tools: install modules-load.d/multipath.conf"), we
use modules-load.d to load the dm-multipath module early on. That isn't
optimal, because the module will always be loaded, even if multipathd is
not running.

Use systemd's "modprobe@.service" instead to make sure the module is loaded
before multipathd starts. If "multipath -u" is invoked from udev rules
before multipathd.service has been started, it will access the socket,
which will autostart multipathd via socket activation and cause the
dm-multipath module to be loaded.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/Makefile            | 2 --
 multipath/modules-load.conf   | 3 ---
 multipathd/multipathd.service | 2 ++
 3 files changed, 2 insertions(+), 5 deletions(-)
 delete mode 100644 multipath/modules-load.conf

diff --git a/multipath/Makefile b/multipath/Makefile
index 68cb5ce..a69262b 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -28,7 +28,6 @@ install:
 	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
-	$(Q)$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man8
@@ -44,7 +43,6 @@ endif
 uninstall:
 	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
-	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
 	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
diff --git a/multipath/modules-load.conf b/multipath/modules-load.conf
deleted file mode 100644
index b517d32..0000000
--- a/multipath/modules-load.conf
+++ /dev/null
@@ -1,3 +0,0 @@
-# load dm-multipath early, both multipathd and multipath depend on it
-# (note that multipath may be called from udev rules!)
-dm-multipath
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 5a9cde1..40cf32c 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -3,6 +3,8 @@ Description=Device-Mapper Multipath Device Controller
 Before=lvm2-activation-early.service
 Before=local-fs-pre.target blk-availability.service shutdown.target
 Wants=systemd-udevd-kernel.socket
+Requires=modprobe@dm_multipath.service
+After=modprobe@dm_multipath.service
 After=systemd-udevd-kernel.socket
 After=multipathd.socket systemd-remount-fs.service
 Before=initrd-cleanup.service
-- 
2.42.0

