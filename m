Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243D91E485
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720108142; cv=none; b=mVUJBhcplRuonGKBxRSY09svV6lQqMFc7TWf2OJSHdQbSsPUdBOXs7QSKoZGYx0sQr7av0U1gExffxup5EdALubg/Y1dvIK7kXcBYkJ36MkltFeArY+ABEiRYqSQ+At6EYVQZjqR/K4EUjVKD5a6tmqrfudutw5VvzRiTwl68R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720108142; c=relaxed/simple;
	bh=qRZ5FWIaNCdcu34FsfrG0wHzHZsxU7LZPcZQsTwOy28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lBHIZq0PtlB8ciFbyA3W9qXGaYepS62CW6crpZ3Ef3Jx+sKr5yC8TPB/5+WmF2q8QgGyMcp9r0Ly2HREpeJxYpzpuutuNK7VARHS5z5KB83hZ+S7dBFS9kfJFtaYGFDdIEpIKdqNbRyJj/k/8xwHacv2CZJTrTaAU23Uv/PUdbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QzirVZFc; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzirVZFc"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3679f806223so443789f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 04 Jul 2024 08:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720108139; x=1720712939; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkDRRotccD4WYePv/X/yK+dxfE2ksbbYKz3vB7yB3VM=;
        b=QzirVZFcXrwpe2rLz0pylcZ7MRTlZQL8FrzglLIq79b7nBrVR9K8IOAo5Ciy5OIHyY
         asSi60TxWK00eso05ouZR+gismc7nLKwWXNqHZLtRzujl644Jm8RCT0PpkSod2frXBm0
         HPT56x3mNk9s7DZEexLHmcwF3GX7p72a6Tsemb+evsQEC010oW9D1BmH538LdvYMS+fb
         WLxzBWMIpeEOXyKx7Xkf8OKdhbudlszEW1Y5eVbioLL65kpD6Vc0kxZxzIXEL0L6TEmn
         4n/rH0ZHmkp+fALs9q8f8QUhRGWT0/Lvmqed77ohgqdDsDZOsoEQftdzWrVRGcf1X+hE
         3Mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720108139; x=1720712939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nkDRRotccD4WYePv/X/yK+dxfE2ksbbYKz3vB7yB3VM=;
        b=XlzLDCv5p+672mdAvpM58p4m1JoS+3mk/zCnGZ7f1vUWB68l6rUWdWtErQU+L4VHUZ
         1u9S/FfbVFkOqPGNZndi5KNNj0kafHEc9iWHBmfmXmO3FQQ7QDm7N17EFHBJVKD53ZeZ
         iuXGpTygJY1FoKFNzsrGii8LdDZe1s/bUtRCZktviCXcf73RzW2MuF8Uq0izlb6RQGzz
         p0cKBoAQ/h0yyQFMvS2ho4ph+iVMCLKt/8mnLSb8DCmgovCjzNSKeF2d9Ed6Jv52Q4vv
         fYLNFV6KrdiYfUsimZEsVJuH8GPXi+f/j8qqzkonf2zLTCqZC1VTP5Vzd16/Pxdm+AB/
         N3aQ==
X-Gm-Message-State: AOJu0Ywq1qnnx6JdQhj4U4HqsVQKsYHUNWRwGuAmi8J5Z5qdNzhm6p5t
	97T7CJtvURaLfeVHSNvKJU87L+WHf+ql6luI9q3WhzIpiZr3fc0c0uBqmg==
X-Google-Smtp-Source: AGHT+IHwja3RV8S7zMe5UaeuUB+naoAsZR6pXMD7O1/6X0vl2AwXf22MOt6Z/uKH3lKsYYaxVYwL7g==
X-Received: by 2002:adf:fa92:0:b0:360:866f:5083 with SMTP id ffacd0b85a97d-3679f739c45mr1794874f8f.32.1720108139101;
        Thu, 04 Jul 2024 08:48:59 -0700 (PDT)
Received: from localhost ([137.220.120.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367a2c2e438sm837553f8f.20.2024.07.04.08.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 08:48:58 -0700 (PDT)
From: luca.boccassi@gmail.com
To: dm-devel@lists.linux.dev
Cc: snitzer@kernel.org,
	jmorris@namei.org,
	paul@paul-moore.com,
	James.Bottomley@hansenpartnership.com,
	linux-security-module@vger.kernel.org
Subject: [PATCH v2] dm verity: add support for signature verification with platform keyring
Date: Thu,  4 Jul 2024 16:48:49 +0100
Message-Id: <20240704154849.3751846-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240617220037.594792-1-luca.boccassi@gmail.com>
References: <20240617220037.594792-1-luca.boccassi@gmail.com>
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
which is populated using the UEFI DB certificates.

This is useful for self-enrolled systems that do not use MOK, as the
secondary keyring which is already used for verification, if the
relevant kconfig is enabled, is linked to the machine keyring, which
gets its certificates loaded from MOK. On some datacenter/virtual/cloud
deployments that roll their own OS it can happen to deploy one's own
certificate chain directly in DB on first boot in unattended mode,
rather than relying on MOK, as the latter typically requires
interactive authentication to enroll. Another use case is for those who
self-enroll on their laptop/desktop, and do not use shim/mok at all.
This is quite common, for example it's the main way Arch users do
SecureBoot, and there's an entire ecosystem around this workflow, using
sbctl and friends. systemd-boot provides facilities to self-enroll on
first boot, for example. Another use case is in CIs, where we boot with
a locally built systemd-boot, self-enroll in EDK2, run some tests, and
then throw away the VM. This is the case in systemd's upstream CI that
uses mkosi, for example.

Default to the same value as DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
if not otherwise specified, as it is likely that if one wants to use
MOK certificates to verify dm-verity volumes, DB certificates are going
to be used too. Those who do not wish for the DB certificates to make
their way in the kernel keyrings can already set the MokIgnoreDB UEFI
variable, and importing will be skipped. This changes fully respects
that workflow, as it just uses the platform keyring if it is populated,
and changes nothing otherwise.

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v2: update commit message to better reflect the use case and the functionality,
    as per feedback from James

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

