Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA98F3A26D
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JRUM+iHe"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A8111FE88;
	Thu, 26 Oct 2023 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7t5ecdfwJlChCH7XOrRPmYVbOhCF6X4x77xh/yUKoXk=;
	b=JRUM+iHewMlgseZBkJwkqL84fUArwZw0QrFNqzoZ+vcilCtvM5G8qPfvCLUgLKaSuUyPGq
	V17eLUo4jZZWQEz5pwrCHAPU1MKRQWW/PAZEJQr3NVsAIBz+KBND0y2XfXc9iF5R4guKXG
	CcMpXFH7vjQ0Gix6WClI/yUfgDiZIyQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B47EE1358F;
	Thu, 26 Oct 2023 17:42:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 2IEhKgelOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:31 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 11/14] Makefile.inc, README.md: fix docs for prefix in split-usr case
Date: Thu, 26 Oct 2023 19:41:50 +0200
Message-ID: <20231026174153.1133-12-mwilck@suse.com>
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
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.60
X-Spamd-Result: default: False [-4.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TAGGED_RCPT(0.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 REPLY(-4.00)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[];
	 FREEMAIL_CC(0.00)[lists.linux.dev,suse.com,gmail.com]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

systemd with "split-usr=true" uses rootprefixdir as prefix for
units and for udev libraries and rules ("udevlibexecdir" in
systemd). Fix the documentation for this case. Also, slightly
improve the paragraph about SCSI module loading.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc |  6 ++++--
 README.md    | 25 ++++++++++++++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 8655cba..a20e2ce 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -40,8 +40,10 @@ usr_prefix	:= $(prefix)
 # Prefix for configfuration files (multipath.conf)
 etc_prefix	:= $(prefix)
 # Where to install systemd-related files. systemd is usually installed under /usr
-# Note: some systemd installations use separate "prefix" and "rootprefix".
-# In this case, override only unitdir to use systemd's "rootprefix" instead of $(systemd_prefix)
+# Note: systemd installations with "split-usr=true" use separate "prefixdir" and
+# "rootprefixdir". Our systemd_prefix corresponds to "prefixdir".
+# In this case, override only unitdir and libudevdir below to use
+# systemd's "rootprefixdir" instead of $(systemd_prefix)
 systemd_prefix  := /usr
 
 # Make sure all prefix variables end in "/"
diff --git a/README.md b/README.md
index 524c9fb..25ce963 100644
--- a/README.md
+++ b/README.md
@@ -111,6 +111,13 @@ The following variables can be passed to the `make` command line:
    polling API. For use with pre-5.0 kernels that don't support dmevent polling
    (but even if you don't use this option, multipath-tools will work with
    these kernels).
+ * `SYSTEMD`: The version number of systemd (e.g. "244") to compile the code for.
+   The default is autodetected, assuming that the systemd version in the build
+   environment is the same as on the target system. Override the value to
+   build for a different systemd version, or set it to `""` to build for a
+   system without systemd.
+   **Caution:** multipathd without systemd has been largely untested by the
+   upstream maintainers since at least 2020.
  * `SCSI_DH_MODULES_PRELOAD="(list)"`: specify a space-separated list of SCSI
    device handler kernel modules to load early during boot. Some
    multipath-tools functionality depends on these modules being loaded
@@ -122,7 +129,9 @@ The following variables can be passed to the `make` command line:
    It's especially useful if `scsi_mod` is builtin but `scsi_dh_alua` and
    other device handler modules are built as modules. If `scsi_mod` itself is compiled
    as a module, it might make more sense to use a module softdep for the same
-   purpose.
+   purpose by creating a `modprobe.d` file like this:
+       
+        softdep scsi_mod post: scsi_dh_alua scsi_dh_rdac
 
 ### Installation Paths
 
@@ -133,9 +142,9 @@ The following variables can be passed to the `make` command line:
    for booting. Non-usr-merged distributions[^systemd] may want to set this to
    `/usr`. The default is `$(prefix)`.
  * `systemd_prefix`: Prefix for systemd-related files[^systemd]. The default is `/usr`.
- * `etc_prefix`: The prefix for configuration files. "Usr-merged"
+ * `etc_prefix`: The prefix for configuration files. "usr-merged"
    distributions with immutable `/usr`[^systemd] may want to set this to
-   `/etc`. The default is `$(prefix)`.
+   `""`. The default is `$(prefix)`.
  * `LIB`: the subdirectory under `prefix` where shared libraries will be
    installed. By default, the makefile uses `/lib64` if this directory is
    found on the build system, and `/lib` otherwise.
@@ -144,10 +153,12 @@ The options `configdir`, `plugindir`, `configfile`, and `statedir` above can
 be used for setting individual paths where the `prefix` variables don't provide
 sufficient control. See `Makefile.inc` for even more fine-grained control.
 
-[^systemd]: Some systemd installations use separate `prefix` and `rootprefix`. 
-	On such a distribution, set `prefix`, and override `unitdir` to use systemd's
-   `rootprefix`. Recent systemd releases generally require everything to be
-	installed under `/usr` (so-called "usr-merged" distribution). On "usr-
+[^systemd]: systemd installations up to v254 which have been built with
+    `split-usr=true` may use separate `prefixdir` and `rootprefixdir`
+    directories, where `prefixdir` is a subdirectory of `rootprefixdir`.
+	multipath-tools' `systemd_prefix` corresponds to systemd's `prefixdir`.
+	On such distributions, override `unitdir` and `libudevdir` to use systemd's
+   `rootprefix`: `make libudevdir=/lib/udev unitdir=/lib/systemd/system`
 
 ### Compiler Options
 
-- 
2.42.0

