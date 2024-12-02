Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7874720966B
	for <dm-devel@lists.linux.dev>; Mon,  2 Dec 2024 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140986; cv=none; b=IeNIlktDWk5xf5Tv929CPR3o+QI1PQyJZLoDwhjYl4uzBctosicQv3GIabBYu5mym6mXvdlqim5Tn11u8GUZrYuyniWV3cgTC7xsxqD/GVXEA+9XyKZO7YrEY9QR4WWDUbUuLwdSEbfHeW4qHp77MZ6VpzKTduiSnL5hTHfIbW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140986; c=relaxed/simple;
	bh=AqF63O/Ib0+mAPITy6g8+BVgv9brQasaHdYYrdxQTrk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=annOs/+PFf1QxI3esnewG+ZYW03jUkaVTzgY62zOSJWFI7MAJd7hXI/QD8kyV4MVIwX+IDDvx6BRkH2fkcageHHKZLXbl60Pu3R3r/dVivsjHU1yZ2rnMayhosVmTwM/7fNUkgqtxG7Zp4uAa67m8aXxhMKlVihul2ftZhMFPZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=r0ndFjja; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="r0ndFjja"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-434acf1f9abso38164235e9.2
        for <dm-devel@lists.linux.dev>; Mon, 02 Dec 2024 04:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140981; x=1733745781; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYruTmcB1Bftzc/voPlNnlx7ouCt6Ma+mW6cK8AFUIA=;
        b=r0ndFjjazWFIJ16Np5dcXc8In/9D+tn/zH5ZuROG+be49K+A4t3vqkj60JzyGLa561
         KYgoz+k03DZHidHtJi59m5cn+QHUrefQuiakK+2NXMS9NXVpjFFbIUrazR4f6uwKD8ZL
         RWdKbit8MQ4VqgohaWrxJzHN96Zr2k06Rz9lRWjhAUzYxBIMPIiFSdVH7kFgiQC9abrc
         1QOAr79o2Iw9g+5ybow5rHHhZ6zQpZl+pF1zN88g+GDFLzMvrANOK4wDVSZJpnNlxSa8
         hEMftWgU4RFtd7+cmeyB7Us7cNEf2lVlBZ5mlhsf45RG22LXDcjXSXFQwvaG97zh25KP
         Tiaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140981; x=1733745781;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYruTmcB1Bftzc/voPlNnlx7ouCt6Ma+mW6cK8AFUIA=;
        b=jXxdwCCT+rUgti0GNtxRqIVJXylJzrR2qeQ9sjwZtIk9v8995wDdyda5T5kenpQefi
         w+FXXgIhINOfPzUU17YD6QbR9oqyvdsWkguy+P8FfJqHgN86fe1B14iyi3vHFt6T7b1Z
         NXpL0P3Au2VtAdAmI9qFfVvlBMIiN4DM8ujkJQKrviviLC3dvYkFyWhfc8vzUHO3xbZJ
         MmRiDYnS7obMC59WT4nLx44FPapdf5hfiiSvkg663APcwklWGis/4SwjPQNxUFztIHKX
         D/EVEVQu2cmKf2t/MjbSX9bV2ZSbiUDWANgzsIWJosizGct0pQmXZiT6qSB01q5fLVKe
         B5mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUo0FJuMGjNSoNhqO/+XWTDF3mIfafcwERcu0aLNdvtFwP9zqr1BgkaONXYt6QHV57r1IZALFFv9w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq6L37yFoPIa3TW/O3+wOWc6wyM0Td/LIqXc1aY8A8NtTcmNKz
	SIuXkcgIKIqTTWioarkMciiQ76+1u1Z3cyef0wKZNVwIbG6rHlHMuwlbkoffEY8=
X-Gm-Gg: ASbGncskeMLaJxGKaurdWOMhQCKCiSmw7NUPR8/Etw+0PHTtIZm4LS92TEYVmdlVLN1
	VWEotln3H5L5CDlsIh+xv2GSfjexxhi4oiKSBpPW3bBer0HSPAMRu2XCx85lxFfnsZOGstfWoFs
	F4xZjVx4sL/nkfW/13A1xtNjDn8P9XAbFp5l3Fpa+9ZoeH2loT3Aljw+JLReTKlAIUl2NSmndAF
	hePXT6zqIsHAqCmPLVZP5xkmeD6wsGjXCVPExMz
X-Google-Smtp-Source: AGHT+IH2nzvAB3orz8c5uRDN7301DF9ak1WkbxvD6Xg2UwkFlwWmF7C9APA4wxhU1G0XcB5G0CCeWg==
X-Received: by 2002:a05:600c:1e06:b0:42c:b187:bde9 with SMTP id 5b1f17b1804b1-434a9e0bc3fmr222546695e9.30.1733140981243;
        Mon, 02 Dec 2024 04:03:01 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:03:00 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:28 +0100
Subject: [PATCH RESEND v7 12/17] ufs: core: add support for wrapped keys to
 UFS core
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-12-67c3ca3f3282@linaro.org>
References: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
In-Reply-To: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2886;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=KDRiDKGiOR40fLHLM58rwn0K0j6tx7t9Y60UZCPt2/Y=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHVRwop+WnyjY5L41879Dt/Woqbv2vxlbW7D
 sSLqwx1OkKJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1QAKCRARpy6gFHHX
 ctOvEACAFUZHNYcJjh/LSB8KSkFcf+ZYvmftdMT8boQLn7AnmN4Ei4Hw0XHry5lTmJ0qMJAtqVb
 cd8ABKa59peuhCt4FgaE5Vkoa0o0dvA6+gUlGoh/77zfb1/o3ysp2LZiYSP5NzRKfasuAGM6pWS
 lENKbBd/ZfT0QV6T8NsmHxgFiwH0GUqw7cgpVOS0f/udj7J416/Km+3rMmmz+2XFP0VwAx1WZJO
 wGyvNhCUCHVJfWyvkrsQoe2fuE+qy1F9Iw9KmSU2LH0jmfFHfVMxrABQZgllsVHEKgkzC8VbLkf
 HJFMqgkGOJRzWwpaSdJV9YjgrfRCBCxbCRTjRUDgvF5hLUl6qe4pDLgVDW3j8ighcfCAjgRJljz
 /2gM+bUOISVp0/xZMaBQChDVxjjjY4IA0jCSGaPwoEXWagvenW2KZVHnzSlxFg9wnb57gp+hx8J
 BFkdZrUmHdSt1WN0cvyWGuw2qOfSlWI+0Uy9npKT5zOqOymbC44Y6wr7MWQ6sHovB4JDTY7EvgX
 cyVV+mi8sKc2+DMLouyOtdqY6Ty7HfKcLjcdn9o5b3r7mBnVc7v40npv16zlDP20Hl6D/IfJpGe
 ojN4SC46+97/DDpRkafl6PZtbHlYMJbr0ojcZQLsJAlJYrEQNxysJgZ7kkXIJ0m3SVjlysufQj0
 ob47mYBh8sQ4FVQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Add a new UFS capability flag indicating that the controller supports HW
wrapped keys and use it to determine which mechanism to use in UFS core.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/ufs/core/ufshcd-crypto.c | 24 ++++++++++++++++--------
 include/ufs/ufshcd.h             |  5 +++++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 33083e0cad6e1..64389e8769108 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -81,13 +81,15 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 	cfg.crypto_cap_idx = cap_idx;
 	cfg.config_enable = UFS_CRYPTO_CONFIGURATION_ENABLE;
 
-	if (ccap_array[cap_idx].algorithm_id == UFS_CRYPTO_ALG_AES_XTS) {
-		/* In XTS mode, the blk_crypto_key's size is already doubled */
-		memcpy(cfg.crypto_key, key->raw, key->size/2);
-		memcpy(cfg.crypto_key + UFS_CRYPTO_KEY_MAX_SIZE/2,
-		       key->raw + key->size/2, key->size/2);
-	} else {
-		memcpy(cfg.crypto_key, key->raw, key->size);
+	if (key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
+		if (ccap_array[cap_idx].algorithm_id == UFS_CRYPTO_ALG_AES_XTS) {
+			/* In XTS mode, the blk_crypto_key's size is already doubled */
+			memcpy(cfg.crypto_key, key->raw, key->size / 2);
+			memcpy(cfg.crypto_key + UFS_CRYPTO_KEY_MAX_SIZE / 2,
+			       key->raw + key->size / 2, key->size / 2);
+		} else {
+			memcpy(cfg.crypto_key, key->raw, key->size);
+		}
 	}
 
 	err = ufshcd_program_key(hba, key, &cfg, slot);
@@ -196,7 +198,13 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
 	/* UFS only supports 8 bytes for any DUN */
 	hba->crypto_profile.max_dun_bytes_supported = 8;
-	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
+	if (hba->caps & UFSHCD_CAP_WRAPPED_CRYPTO_KEYS)
+		hba->crypto_profile.key_types_supported =
+				BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+	else
+		hba->crypto_profile.key_types_supported =
+				BLK_CRYPTO_KEY_TYPE_STANDARD;
+
 	hba->crypto_profile.dev = hba->dev;
 
 	/*
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bc6f08397769c..db2b71f760717 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -761,6 +761,11 @@ enum ufshcd_caps {
 	 * WriteBooster when scaling the clock down.
 	 */
 	UFSHCD_CAP_WB_WITH_CLK_SCALING			= 1 << 12,
+
+	/*
+	 * UFS controller supports HW wrapped keys when using inline encryption.
+	 */
+	UFSHCD_CAP_WRAPPED_CRYPTO_KEYS			= 1 << 13,
 };
 
 struct ufs_hba_variant_params {

-- 
2.45.2

