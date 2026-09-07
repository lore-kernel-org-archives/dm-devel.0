Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F3B3F1078
	for <dm-devel@lists.linux.dev>; Mon,  7 Sep 2026 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.212.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801657; cv=none; b=ZozR/ijpwxqs8FwDj/1q4qqfh+3DPih3t9CF54i2c+cMPsMrE1Ajcu3cCD+FnbQlwabw6Z+ExmPIVs20eAjVr0a9fxsTkTNrhIDRJRWkWmPTaYDLo0rtG+T+PCw+FCcyDNsKdgDgA4jtcJdyuoSqVD6z32XnGhM5QPclPJb/OKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801657; c=relaxed/simple;
	bh=3nTEFFutEHpB2+1O678dGGnisQRT4iuoBriSb3BiG3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qnjoERpI7mp06cGZu4xkcZ0eLrL+Xp8ST0tXpMj6VMaBHUaFHr1wXbFjOSmNSIpZwBb/XF/DCABA251I2ERZ2mAnzpBy8YtSBgW4rt7JKO/aahgrjfetzR7iCXcDKyXjZdUf2i4ZfAZBi8CJiHGfel5f3Dhr4VV7nSs5/XRCzRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embetrix.com; spf=none smtp.mailfrom=embetrix.com; dkim=pass (2048-bit key) header.d=embetrix.com header.i=@embetrix.com header.b=gw/YVvym; dkim=permerror (0-bit key) header.d=embetrix.com header.i=@embetrix.com header.b=04y/wQjg; arc=none smtp.client-ip=46.30.212.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embetrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=embetrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embetrix.com header.i=@embetrix.com header.b="gw/YVvym";
	dkim=permerror (0-bit key) header.d=embetrix.com header.i=@embetrix.com header.b="04y/wQjg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788801582; x=1789406382;
	d=embetrix.com; s=rsa2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=nTcsBJLmFu8dYMLn+V9Q/4af4M3A3nE5vl3NtUhRMU8=;
	b=gw/YVvymdZ8+gZgNXCdhQtu+WXCdmrmUxyezOalZKMUkQGQtmqA9Aew61pQ2Xjxq7k81BN6nDVQaR
	 6fKQup7jrHw9Fejai4Nu1cjEpJIE3I/61ePSCDF4wmiq0RvlqePRM5zsCTIFTHw+RgNWv2kUrzOaiz
	 vx8P71gPKyChS+PzJQwiKNMo3IaUawOyfwgUs3HRUUJN3tQCGeu90FtfCt6dHgpyL2GWUu9JAf47Il
	 S4L9gH2bh8gqs+zYCxxJUmzrSYRlZ0nz1HTVHIYsizuouh9QgvYfQo7TrmIdLtL2y/00PLkObzNl4B
	 CSNY7pWgnM7lceHzaMNFPORz7xkmZ9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788801582; x=1789406382;
	d=embetrix.com; s=ed2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=nTcsBJLmFu8dYMLn+V9Q/4af4M3A3nE5vl3NtUhRMU8=;
	b=04y/wQjg+9nLAx6LFS8sICVNa00JQBh2H0BEDhfXjZth+CgoJJQBAs5A0Rb0HN2fSxDKi3UILgK++
	 kR6r3lFBA==
X-HalOne-ID: 4eb452ed-aae0-11f1-9c77-f14abb5dfc6c
Received: from xps-13.fritz.box (dynamic-2a02-3102-8c10-1ae0-2993-9966-0174-5d77.310.pool.telefonica.de [2a02:3102:8c10:1ae0:2993:9966:174:5d77])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 4eb452ed-aae0-11f1-9c77-f14abb5dfc6c;
	Mon, 07 Sep 2026 17:19:41 +0000 (UTC)
From: Ayoub Zaki <ayoub.zaki@embetrix.com>
To: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	Ayoub Zaki <ayoub.zaki@embetrix.com>
Subject: [PATCH] dm-verity: add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
Date: Mon,  7 Sep 2026 19:19:38 +0200
Message-ID: <20260907171939.355472-1-ayoub.zaki@embetrix.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE Kconfig option.  When enabled,
dm-verity always requires a valid root hash signature: require_signatures
defaults to true and can no longer be cleared on the command line.  When
disabled, the existing require_signatures module parameter controls
enforcement.

Signed-off-by: Ayoub Zaki <ayoub.zaki@embetrix.com>
---
 Documentation/admin-guide/device-mapper/verity.rst |  5 +++++
 drivers/md/Kconfig                                 | 14 ++++++++++++++
 drivers/md/dm-verity-verify-sig.c                  |  4 ++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index eb9475d7e196..bb48c001aeac 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -163,6 +163,11 @@ root_hash_sig_key_desc <key_description>
     also gain new certificates at run time if they are signed by a certificate
     already in the secondary trusted keyring.
 
+    Whether a signature is required for every dm-verity device is controlled by
+    the dm_verity.require_signatures parameter which defaults to off. Setting
+    DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE makes it default to on in which case it
+    can no longer be turned off.
+
 try_verify_in_tasklet
     If verity hashes are in cache and the IO size does not exceed the limit,
     verify data blocks in bottom half instead of workqueue. This option can
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index df27c7d066d2..59098d1f4534 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -610,6 +610,20 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
 
 	  If unsure, say N.
 
+config DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
+	bool "Require dm-verity root hash signature verification"
+	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
+	help
+	  Reject dm-verity devices that are created without a valid root hash
+	  signature.  Without this, whether a signature is required is decided
+	  at boot time by the dm_verity.require_signatures parameter which
+	  defaults to off.
+
+	  Enabling this makes that parameter default to on and it can then no
+	  longer be turned off.
+
+	  If unsure, say N.
+
 config DM_VERITY_FEC
 	bool "Verity forward error correction support"
 	depends on DM_VERITY
diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index b2b55c41e2cb..aadcf5e4a47c 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -21,8 +21,8 @@ static bool dm_verity_keyring_unsealed __ro_after_init;
 module_param_named(keyring_unsealed, dm_verity_keyring_unsealed, bool, 0444);
 MODULE_PARM_DESC(keyring_unsealed, "Leave the dm-verity keyring unsealed");
 
-static bool require_signatures;
-module_param(require_signatures, bool, 0444);
+static bool require_signatures = IS_ENABLED(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE);
+module_param(require_signatures, bool_enable_only, 0444);
 MODULE_PARM_DESC(require_signatures,
 		"Verify the roothash of dm-verity hash tree");
 

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0

