Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1DD3AC00
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pLxyl24p"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CEA921B1A;
	Thu, 26 Oct 2023 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KV9MWduVHN8UHQaKOkYE7JYxQVIq0rCIGeAqzWEydtU=;
	b=pLxyl24pdYRkG+bUJTRlmKgKkLKBiIKPlXFx3DaoAsaZeHbVCR3rlYV7p/C+x64OM8D+UX
	IPrIOnP8DHDRy8HC+zM8xtbZdTFnzqYvsgIoPwxugU2kup56AYfm1IhkzB4QyR4C6S4cxP
	HAnrejq7pgdLR9NwGxh79+s8ymwQJTk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1705D13A96;
	Thu, 26 Oct 2023 17:42:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id EGwbBAilOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:32 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 12/14] README.md: update mailing list and contributing information
Date: Thu, 26 Oct 2023 19:41:51 +0200
Message-ID: <20231026174153.1133-13-mwilck@suse.com>
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
X-Spam-Score: -4.60
X-Spamd-Result: default: False [-4.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
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

Create a "Contributing" section. Move the the current sections
related to contributing into that section.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md | 56 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/README.md b/README.md
index 25ce963..b2ed1f2 100644
--- a/README.md
+++ b/README.md
@@ -42,14 +42,6 @@ Go to: https://github.com/opensvc/multipath-tools/tags
 Select a release-tag and then click on "zip" or "tar.gz".
 
 
-Devel code
-==========
-
-To get latest devel code:
-
-    git clone -b queue https://github.com/openSUSE/multipath-tools
-
-
 Building multipath-tools
 ========================
 
@@ -188,19 +180,45 @@ The following targets are intended for developers only.
  * `make compile-commands.json` to create input for [clangd](https://clangd.llvm.org/).
 
 
-Add storage devices
-===================
-
-Follow the instructions in the `libmultipath/hwtable.c` header.
-
-
-Mailing list
+Contributing
 ============
 
-(subscribers-only)
-To subscribe and archives: https://listman.redhat.com/mailman/listinfo/dm-devel
-Searchable: https://marc.info/?l=dm-devel
+Please send patches or contributions for general discussion about
+multipath tools to the mailing list (see below). You can also create
+issues or pull requests on
+[GitHub](https://github.com/opensvc/multipath-tools).
+You will be asked to send your patches to the mailing list
+unless your patch is trivial.
 
+Mailing list
+------------
+
+The mailing list for multipath-tools is `dm-devel@lists.linux.dev`.
+To subscribe, send an email to `dm-devel+subscribe@lists.linux.dev`.
+Mailing list archives are available on
+[lore.kernel.org](https://lore.kernel.org/dm-devel/) and
+[marc.info](https://marc.info/?l=dm-devel). See also the
+[lists.linux.dev home page](https://subspace.kernel.org/lists.linux.dev.html).
+
+When sending patches to the mailing list, lease add a `Signed-off-by:`
+tag, and add Benjamin Marzinski <bmarzins@redhat.com> and 
+Martin Wilck <mwilck@suse.com> to the Cc list.
+
+Staging area
+------------
+
+Between releases, the latest reviewed code can be obtained from
+[the queue branch](https://github.com/openSUSE/multipath-tools/tree/queue)
+in the openSUSE/multipath-tools repository on GitHub. From there,
+pull requests for new releases in the master repository are
+created roughly every 3 months.
+
+Adding new storage devices
+--------------------------
+
+If you want to add special settings for a storage device which is
+new on the market, follow the instructions at the top of the
+file `libmultipath/hwtable.c`.
 
 Changelog
 =========
@@ -213,7 +231,7 @@ Maintainer
 ==========
 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
-Device-mapper development mailing list <dm-devel@redhat.com>
+Device-mapper development mailing list <dm-devel@lists.linux.dev>
 
 
 Licence
-- 
2.42.0

