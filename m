Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F2A209F24
	for <dm-devel@lists.linux.dev>; Mon,  2 Dec 2024 12:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140989; cv=none; b=QCtNPHMeeC7pdTvcgs7ivpDr3aLTocFVCv3ju2xlkmWsTeWDgrtVrKJEuzbe9XRHTNSX89GnO1DfYwYW5K3cM4QpNlA8M81sTUk01xgTSE5ddNZyGOgmeTMXJV7xTtYj1nANPjkESlA7BtNhEI/ktB4GSKYp8kxZBW4VGiBYmfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140989; c=relaxed/simple;
	bh=rDgzjyrCxow20O57yxOKv5Dt7aQaZyB78v7qF4RvpKA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iFIfrCk0GWyCll0MCi+UWHE9aV/f2qGt4/AJSq90LjG5ebXvYxpwCV1hzhKIO2x49OOJP6VIoNXZylUbTFNo+odD06K84a/mAvHeU6Ta/T75mVIvWYCIS+6c6j9TPoJUCFJeE2LQXg3sOKM38TMpAe7MZkDhcxo/jf/v/R0w5qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=ZXOesDt8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="ZXOesDt8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385e3621518so1526623f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 02 Dec 2024 04:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140984; x=1733745784; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KbT2yjWECByZX4YoBFRCDGctDmzwqVa2hRpV/DsyHrc=;
        b=ZXOesDt8Uho7Fe8yVCSQKc6z4aRXhTOdIxKt1H4aAnDJUn4fQ/Cmx8/HqHRiAShTDN
         YM9XDKHm8Fu05TZwITgO503ohYOamfYbwzxMbVnUf29vauoEjEBiyBPq+Pa0HUzGYWPV
         GWW0rEYPTRdN4XQE6mewEho3iNGlOG6Tmc1z5lkseRc1w90naLSgC5BGsVZtPG6T0zkv
         MhSxY4KPImqYKXH91ZNUEyXhmHS9Oto4ofqQWSyEgy6Pd7zV1rjWfIGZiVqatZ6j5ncG
         sOMUwRDhtXym/aKXRTuomtWlUoAg3WpHfS9yATwP16uC+zohMFBvNJO8s0WbIxfZRSQn
         ZJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140984; x=1733745784;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KbT2yjWECByZX4YoBFRCDGctDmzwqVa2hRpV/DsyHrc=;
        b=ptUbWiP+cWEmyE3oSGUEC5e0zaSR5H/WVfEm8mbtOQOJGEjYicp2u/U14Ue6v6+Ljv
         Gfq+w3abd4cl2ijIJ28kWPReZGw5bGeXw4n23bN0iGEnDhrmquEt3u+BxzxZf5uknRVI
         9ZBPrY7r/aSugaYum3VklyW6RAWCzXzD3AkwzOO0R3vo5QeuxwNDWYtvRN4pVa4l6lEC
         OAl3OwmtXf/nJbOt4DYsDi9VpKzHyVDS0jWliS7Gc5RumoKDj0btRMEoWG7mLm0pd/KE
         CtuuTnt5k1FP+YohLu3anPCULSuBxtYGjPr/0snUfhtOu9gJNNcdksM51s7OYj89/fRe
         LBVw==
X-Forwarded-Encrypted: i=1; AJvYcCVDuwHapLKXuTgs/5doAp6Qiy8UTYC6AJSm8DV7Aormh1kXWfaNtAdWoA/1cG6ERIiw4uRtZ9FxwA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy1DHSShPYvPZ5qEYzaPhVA8UqixUfOfFokNIUMrKWuY4hihOW
	5Nem4j0w3Qm7NCABvm81CJ0pf4uJIyAiFYK+bGNgadCUHZTcgjfIS5lmlz47dPk=
X-Gm-Gg: ASbGncs2hoNehXqvy+MQlAqMi3Hqj2WB/9LcLQBHbMMTYNRTdkuN82TpQpTvLyDiUl6
	n7a0Fw2ahhlHnsRO6HEaxC+1cRUvJRy88eRyavR35ipfq1LCbsbIEbohEuw9bCxmjvLnQ08QHaF
	KZTaXbcPjhRUMlymc3lPgyBv9oulDbXbv5+BECPrSzz4S4fGjE9dkbBE9bH1SPa1LHShAQLupNI
	Ds2KE4p2JXJMT8xA+k49gMVgSNHQj6JEIdSwAJB
X-Google-Smtp-Source: AGHT+IE8InKM+5p5YhbHKlZqW5eKtWZzURRtuhs650gYc2AEjKaWvw/sZZSN1CqSTaFlPcWax4Q/Mw==
X-Received: by 2002:a5d:64ee:0:b0:385:f677:859b with SMTP id ffacd0b85a97d-385f67789a8mr1422366f8f.10.1733140983205;
        Mon, 02 Dec 2024 04:03:03 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:03:02 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:29 +0100
Subject: [PATCH RESEND v7 13/17] ufs: core: add support for deriving the
 software secret
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-13-67c3ca3f3282@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Om Prakash Singh <quic_omprsing@quicinc.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2650;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=MQigyGWoS7egCiFabEGvOIGlVmzO1zHpQlE1Kmp4zmE=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHVIFBM1y8uWTaoURGUfuIgsk9gDANWKQCsa
 8zWklwoa4iJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1QAKCRARpy6gFHHX
 cgLDEADBrjGlnEDnOX6YzXmxa3INqU5S9zTFOsYDq/wb2dUpJF462gP2OnwVdwfJVV0cyWufaVS
 0/l0ZqTS3zvGBArVt6A1c8blcMiztmUuVjRcwhKHNRnzbf2JIZlGbgd1I7b6YYS1twaziT+9c25
 iG3kbnS9u10fc7U4HqOOd+9DpVXJ4uxY3DPvP8W3gh0lJGfxeNmnlXwItZIB0EJ3Zi/0K4lJcg5
 cKDNcTr2MQlnc2WZ1G/nsWB2Ar2LoP61yARuh5xaLaD0dAK+iQ4CqDdzazIw+hiko+8Tx9zoxSY
 cHdvYsWKYYgEnzt8DkEmZH8/QYKXAYxgwL1HP49sIGLwq2NRREAXQCmXXJZ7NihiNinLMQsl5Et
 pKNVMm/VP27H3ysZv1Es74K+PkL9uC5yzLEHbnElaGefcEfoZW9elsd6PHdxKkZ7HHVPg0CH6Gz
 EwYJUrlucD2BHHbfFT5OFScj583jzecNIRSnYLsbhT2npxqsG5fhEamL9RaDwexQ/32+qZeaogO
 Gz7hx9WMoOAy8hfUXGhlKuY8R6kammvqYgztudMdbTxwkPFfipCHbXUr9lXjNVBV6fAoB1KuIAT
 jLGh8Hk2Aigj6gUSpjqyX5uG+LzT9c1GHeN0XsOW/MxPLokfo/7Eat/kVPMFFdjUuL13y5zqNwx
 wlUgeZoRfVCAaMw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Extend the UFS core to allow calling the block layer's callback for
deriving the software secret from a wrapped key. This is needed as in
most cases the wrapped key support will be vendor-specific and the
implementation will live in the specific UFS driver.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/ufs/core/ufshcd-crypto.c | 15 +++++++++++++++
 include/ufs/ufshcd.h             |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 64389e8769108..2530239d42afa 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -113,6 +113,20 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 	return ufshcd_program_key(hba, NULL, &cfg, slot);
 }
 
+static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
+					  const u8 wkey[], size_t wkey_size,
+					  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->derive_sw_secret)
+		return hba->vops->derive_sw_secret(hba, wkey, wkey_size,
+						   sw_secret);
+
+	return -EOPNOTSUPP;
+}
+
 /*
  * Reprogram the keyslots if needed, and return true if CRYPTO_GENERAL_ENABLE
  * should be used in the host controller initialization sequence.
@@ -134,6 +148,7 @@ bool ufshcd_crypto_enable(struct ufs_hba *hba)
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
 	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
+	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
 };
 
 static enum blk_crypto_mode_num
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index db2b71f760717..1b7c36e5347b2 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -375,6 +375,9 @@ struct ufs_hba_variant_ops {
 	int	(*program_key)(struct ufs_hba *hba,
 			       const struct blk_crypto_key *bkey,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	int	(*derive_sw_secret)(struct ufs_hba *hba, const u8 wkey[],
+				    unsigned int wkey_size,
+				    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
 				    const struct bio_crypt_ctx *crypt_ctx,
 				    void *prdt, unsigned int num_segments);

-- 
2.45.2

