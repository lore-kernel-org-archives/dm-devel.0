Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155FA18FC80
	for <dm-devel@lists.linux.dev>; Mon, 17 Jun 2024 22:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718661648; cv=none; b=UItSd1zCYgi5cu1kemd5ZZ8UiJ3Hlm4JvREmliGZF29myHrQ/osTIFLhAWYWtHHMigyg4cf3BalaDkgiSmrzMxJYsaQTZuNDO38TJ0m7MiuwHGR8bvY+TN9I4qPDSZjsNaATw0ov7dLoVIXAng7J3AIMsRC8Ad4gmgU1IaRzZWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718661648; c=relaxed/simple;
	bh=h7LURKeDgeg16GkoPLAlSuc+hn1Z/vmMkPRPbzPj/J0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QBbIkMrRHXMXHO4bwgCBLYZqQfI2npLIHiNnp5sUabPlqaVX+1MYkgrgiCjEmYtXkG4lmiDcAtezA+A7oZCFMZ9c5WUJRuVvqyjJwPkTLh2SUR2cBylV3RucMo/FswfOJxDNr613cyYKxTKVaNZrHbWtRWx/Y2o7mo8OqLD/eDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aCSL9zP7; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCSL9zP7"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-361c709e456so87421f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 17 Jun 2024 15:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718661645; x=1719266445; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=416KkWXnjfFLt2Oo+8HRRnLDLrRrd/88t5tWGKXPE9M=;
        b=aCSL9zP7L1vwyQ5DQjDnISfaavntTumEi5qKVA0SrM+HJKBN9hFryXuPZNBXzdsMK8
         +O/9WZQU9If9JNweid47sLuaE1Zkb00m28xnWxUFYjpuau0WhvDQltpJmasQ3C4+YKOU
         l1CnnOTh12ddrc2vZvfj1PgZh7MMBCNU6FDoTPEuHIliOrwWGFMILMA8rfAPGU8ovsWw
         2hL9XDzM4GhbGKpls24CcEmTyBLv4EDabVdoO0qPbK3Hm4flljJK3D9FsXqDlRUuowX5
         acGR7EoDzq/4YEE7aL3nfeMWJCV9foFdCiL7Ez33ej6FVWlIpcEelUH4hx2JPV4g8FLi
         SOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718661645; x=1719266445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=416KkWXnjfFLt2Oo+8HRRnLDLrRrd/88t5tWGKXPE9M=;
        b=gpbCO8p6F+PVCzUSFdVksCquoRTotFA0Gk3el0X5/zNueEmzNz/Y43G6Bz/UDTHcWI
         jsqlrWsXX/nUFz2SX8XmEXdzwdCpNnc5i0hTP7g+gObjnXspaXUapWx3PnrSTUp6LXe9
         THH56NoNBRwMi2yv9u7HXzNm3G34N3iTj9mWEMka02AfBT+YMk8j6A5D/NjJl1Pn4qYK
         3eexPZHPXU+BvCDJUUNzBKxit4v2Pd+C+eeuKSAcSna+u0TzQk4IuI15bo2riyyfAHed
         VGvaNAwcovtehUJLCClIUnLsGm8/8WGegoaau9BVJMBVmWm7b/yFQv1eL93EjEakyB5j
         yeeQ==
X-Gm-Message-State: AOJu0YwHq6X88QRTSmijEO3JEwlWRTG6SCK31kD2og+K164d57lRuSQt
	4Tf78cZOzH2hXnI3gsUfipNhLG3pC7thVPknikmv7naPadcQQ6tnSLdvHNty
X-Google-Smtp-Source: AGHT+IG5o4xZH4kzZgF4fnraRgX4xcrN+D3eUp8tmvJLGmDFU5B6UcPqxhBpoqlk5VM3k+yxOapp4w==
X-Received: by 2002:a5d:65ca:0:b0:360:7139:ba28 with SMTP id ffacd0b85a97d-3607a783459mr9465144f8f.53.1718661644897;
        Mon, 17 Jun 2024 15:00:44 -0700 (PDT)
Received: from localhost ([137.220.120.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c878sm12812355f8f.37.2024.06.17.15.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 15:00:44 -0700 (PDT)
From: luca.boccassi@gmail.com
To: dm-devel@lists.linux.dev
Cc: snitzer@kernel.org,
	jmorris@namei.org,
	paul@paul-moore.com
Subject: [PATCH] dm verity: add support for signature verification with platform keyring
Date: Mon, 17 Jun 2024 23:00:37 +0100
Message-Id: <20240617220037.594792-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luca Boccassi <bluca@debian.org>

Add a new configuration CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
that enables verifying dm-verity signatures using the platform keyring,
which is populated using the UEFI DB certificates. This is useful for
self-enrolled systems that do not use MOK, as the secondary keyring which
is already used for verification, if the relevant kconfig is enabled, is
linked to the machine keyring, which gets its certificates loaded from MOK.
On datacenter/virtual/cloud deployments it is more common to deploy one's
own certificate chain directly in DB on first boot in unattended mode,
rather than relying on MOK, as the latter typically requires interactive
authentication to enroll, and is more suited for personal machines.

Default to the same value as DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
if not otherwise specified, as it is likely that if one wants to use
MOK certificates to verify dm-verity volumes, DB certificates are
going to be used too. Keys in DB are allowed to load a full kernel
already anyway, so they are already highly privileged.

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 drivers/md/Kconfig                | 10 ++++++++++
 drivers/md/dm-verity-verify-sig.c |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 35b1080752cd..1e9db8e4acdf 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -540,6 +540,16 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
 
 	  If unsure, say N.
 
+config DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
+	bool "Verity data device root hash signature verification with platform keyring"
+	default DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
+	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
+	depends on INTEGRITY_PLATFORM_KEYRING
+	help
+	  Rely also on the platform keyring to verify dm-verity signatures.
+
+	  If unsure, say N.
+
 config DM_VERITY_FEC
 	bool "Verity forward error correction support"
 	depends on DM_VERITY
diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index 4836508ea50c..d351d7d39c60 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -126,6 +126,13 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 				NULL,
 #endif
 				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
+#ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
+	if (ret == -ENOKEY)
+		ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
+					sig_len,
+					VERIFY_USE_PLATFORM_KEYRING,
+					VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
+#endif
 
 	return ret;
 }
-- 
2.39.2

