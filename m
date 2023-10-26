Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C983A280
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eVX8uaRA"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 923BE1FD99;
	Thu, 26 Oct 2023 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqJQ7XYjSFPXhy+SoeL5KJNRDAarnTYDkzmkWBWDYrA=;
	b=eVX8uaRAmlIgBoCUhdyIXk83zpk6bBqTKBFYDvdUmd9zlwV5F9DrI2hXDY6DyZVPvcJLdb
	iygjB6fFjRJRIuT3+u11lb2gasAOgp4mnexczLycNtsWdUraPqCjIIW6Zxi3H7tixZedzn
	x0akkxyJCSoqeoHFUJzFGb5KghZW9QE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59B601358F;
	Thu, 26 Oct 2023 17:42:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id ABpUFAilOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:32 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 13/14] README.md: Extend the section about NVMe
Date: Thu, 26 Oct 2023 19:41:52 +0200
Message-ID: <20231026174153.1133-14-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/README.md b/README.md
index b2ed1f2..2fb423b 100644
--- a/README.md
+++ b/README.md
@@ -273,15 +273,25 @@ To enable ALUA, the following options should be changed:
 
 NVMe
 ====
-To use Device Mapper/multipath-tools with NVMe devices,
-if the Native NVMe Multipath subsystem is enabled
-( "Y" in `/sys/module/nvme_core/parameters/multipath` ),
-it has to be disabled:
 
-`echo "options nvme_core multipath=N" > /etc/modprobe.d/01-nvme_core-mp.conf`,
-regenerate the initramfs (`dracut -f` or `update-initramfs`) and reboot.
+Using dm-multipath with NVMe
+----------------------------
 
-Check that it is disabled(N) with:
-`cat /sys/module/nvme_core/parameters/multipath`
-or
-`systool -m nvme_core -A multipath`
+NVMe multipath is natively supported by the Linux kernel. If for some reason
+you prefer using device mapper multipath with NVMe devices,
+you need to disable native multipathing first:
+
+    echo "options nvme_core multipath=N" > /etc/modprobe.d/01-nvme_core-mp.conf
+
+Afterwards, regenerate the initramfs (`dracut -f` or `update-initramfs`) and reboot.
+
+Using multipath-tools with native NVMe multipath
+------------------------------------------------
+
+If native NVMe multipathing is enabled, you can still use multipath-tools
+for displaying the topology and some other information about native NVMe
+multipath setups. This feature is disabled by default. To enable it, set
+`enable_foreign nvme` in the `defaults` section of `multipath.conf`.
+Commands like `multipath -ll` will then display information about NVMe
+native multipath. This support is read-only; modifying the native multipath
+configuration is not supported.
-- 
2.42.0

