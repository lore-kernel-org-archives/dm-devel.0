Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965AB15AE1
	for <dm-devel@lists.linux.dev>; Mon, 13 Nov 2023 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ob4M0+h8"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B98DC218F6;
	Mon, 13 Nov 2023 14:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699884516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uczpq09DJbHGv1Yscq3ZSH3BO4ciRZDDAtMGFqYdE60=;
	b=ob4M0+h8apb0ucbl2bSBEsazH/MHDBR1rIlIo4bd5cPn6RId8KQOJkL7PihioRNjuxYODz
	Y8roQvi30zyEGZzGP+j40A/nfzGCwVcW9UkqwE78zIZ5U9NbGRKJQXUDKa5HDQbO60F3mQ
	rvcjy4SZL0uqLWGQLTrtGzGhp30ck5U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86E7E13398;
	Mon, 13 Nov 2023 14:08:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id eepEH+QtUmV/HwAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 13 Nov 2023 14:08:36 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipath-tools: set usr_prefix to /usr in default configuration
Date: Mon, 13 Nov 2023 15:08:26 +0100
Message-ID: <20231113140826.15399-1-mwilck@suse.com>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Martin Wilck <mwilck@suse.com>

In the default configuration (both prefix and usr_prefix unset),
we'd install man pages and headers under /share/man and /include,
respectively, which is very unusual. Have usr_prefix default to
/usr in (the default) case where prefix is empty, and set it equal
to /prefix otherwise.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---

This is submitted as an alternative approach to Ben Marzinski's
late patch set "Makefile cleanups."

---
 Makefile.inc | 2 +-
 README.md    | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index a20e2ce..6b45430 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -36,7 +36,7 @@ prefix		:=
 # Prefix for binaries
 exec_prefix	:= $(prefix)
 # Prefix for non-essential libraries (libdmmp)
-usr_prefix	:= $(prefix)
+usr_prefix	:= $(if $(prefix),$(prefix),/usr)
 # Prefix for configfuration files (multipath.conf)
 etc_prefix	:= $(prefix)
 # Where to install systemd-related files. systemd is usually installed under /usr
diff --git a/README.md b/README.md
index db03a33..d4f35f5 100644
--- a/README.md
+++ b/README.md
@@ -131,8 +131,7 @@ The following variables can be passed to the `make` command line:
    "Usr-merged" distributions[^systemd] may want to set this to `/usr`. The
    default is empty (`""`).
  * `usr_prefix`: where to install those parts of the code that aren't necessary
-   for booting. Non-usr-merged distributions[^systemd] may want to set this to
-   `/usr`. The default is `$(prefix)`.
+   for booting. The default is `/usr` if `$(prefix)` is empty, and `$(prefix)` otherwise.
  * `systemd_prefix`: Prefix for systemd-related files[^systemd]. The default is `/usr`.
  * `etc_prefix`: The prefix for configuration files. "usr-merged"
    distributions with immutable `/usr`[^systemd] may want to set this to
-- 
2.42.1

