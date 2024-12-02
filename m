Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3D220B80A
	for <dm-devel@lists.linux.dev>; Mon,  2 Dec 2024 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140996; cv=none; b=t/M9Bw4QlWRa2+LPISm74TayQhbIDxbKwtf9SteyQ/kOknZkY5hMEErJx2KWoNUaxTdakF0Izy8I4/6wF3OILXGUUqSUQz2xs3YqMIJ77RKrb1SlN1HLMba3OZGQXYx4qh/XPxkiEc8GfRfy6BvnoFEn/3DshtxJb6YpXu8h3U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140996; c=relaxed/simple;
	bh=SXqWmFdKruhDvAdboiSEhg1Z6NA3pG4WBm4XMylxPB0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q2QEm3C5VBfRBTP03X2xYGT/meqY+ulbBUrPBT5DhyaOc208oTyy3dUMX6COB1/Kb6oqHnDMrWKjZeZnSaUDyE/UxhWlG72Qn0A5LlTisA4hKl4CkJI5A8++mNpwm8GZhQUYQDW1Px6cudi6AHDB4xN1SwfNxVr/n6n19Hu5dow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=I4fRSzRz; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="I4fRSzRz"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434a9f2da82so35792075e9.2
        for <dm-devel@lists.linux.dev>; Mon, 02 Dec 2024 04:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140992; x=1733745792; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/OaNa1GU6C5pLmKUM+e3Rmrgncx6u+ty/51M3vyn6vY=;
        b=I4fRSzRzVPUoIPieMTc4gbkpP9NXLOBJM7S9myrfovIgbXBDSiwJFKRVdyKKh0xNQm
         zXivZMg+Qu4l3sB0VLNCGlXn4KHf8ipW1HwqBz+1gmUjFPr+UNntsBtZ67g+egLboRNT
         dw3441uBzcny+C4F5UQpJyqpI4UXHwJW7c0h2+zQeodrkb/CDY8lUAoGdBWBb0WQpzgP
         O/yKFXYhwzdxmbJLDJ/1FgQSDTZSy01baw01i4i0SOBK37voLZwkZyRA6B6+xGHOkR/h
         zVctth24otOCmGt6Aqw9g2r0hjT/CToh3/RRi0BHPMH02dtyecmH6eA6nH/Q4XOXo/WP
         XDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140992; x=1733745792;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/OaNa1GU6C5pLmKUM+e3Rmrgncx6u+ty/51M3vyn6vY=;
        b=LPoQ4/TvIloKkRmsuMp1pYypsL51Oaw+dXdsbBrsHGPmVDDD/jVK6GqsS97EsTD9sx
         7CUv3bL0xwV4HjL3aIbLXP3aMoTIOMNIaRoT3yr3oWir2JALKn470YerZjX/5w4fhni1
         qKzYlSjezF2nkwQS+mQnckt2fJw5+pKRJA7tD+z3StZTtpiIiS5S+kLGLwmoQ+LLw2bz
         Xqdu+fs/mVZSeWNwi0s79eie5rLcLsjhkdjLdxAztlIixR0eOjXJpSS+RtNZA445bvEq
         CX1hGYdp+dRB5+T8B/Eq7wMe6kX7IPGScIK64SC8bRvOxj9WlxOHd2axuEfPdrhPF/Fq
         9Hjw==
X-Forwarded-Encrypted: i=1; AJvYcCV8TfGVkt/KPCyADGz8JKBGI1eV/lvZFoKE27/6zOcU5gwwCZLX/dYYYTpmAnjtiX3jd8pSs6ukIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwVh5PMrTuoO5/s36BKKQSWHfa7KTPyLekl3DVEaIYv0ouinaE4
	jYg1qNYj3kqDlqGlTpEHj1x1rraAjB3yYlFzoDxhT5mek9sz/w6aHmN+qQTKIsg=
X-Gm-Gg: ASbGncs55VLkpTeXDSoAboHh/PmwxhIyYMNPjGIpKcs4TNGDnTFcJ5HosqUgIeCseCr
	FqUXWvYaFrH8lpYZPoFyRDgCS3m85RWFm0nuDMwqk79x7rPRaA1mtkEiYhFjy44VObZSlGME0FI
	WDNrI3fJZrc2ajxZlC7TYKI4nyr8Aw4XP4Hc/mwAOeGywpB7+0Se8Qdrpryups0QzV5aMPmdQmS
	/j1cGkiM7yoErIT5KxfcuaC1TtcHBPrUcmlt2DR
X-Google-Smtp-Source: AGHT+IGWc47EwqH71rhHjv/KfoAe6eeXRpWu/7Snf36bMmrQREw14b0jX49/ol9dK3YY1FcYfUD0BA==
X-Received: by 2002:a05:600c:3aca:b0:434:a7f1:6545 with SMTP id 5b1f17b1804b1-434a9dfbe52mr188320625e9.27.1733140992113;
        Mon, 02 Dec 2024 04:03:12 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:03:11 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:33 +0100
Subject: [PATCH RESEND v7 17/17] ufs: host: add support for generating,
 importing and preparing wrapped keys
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-17-67c3ca3f3282@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4284;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=3S2Zj/hLbrM4DjwdvlxVSy1kmPJ99K5Qvwb4G0BsQ0U=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHXzRXDCRoQFXnAuSVzn467NjNF+9zLmE0aj
 0uunEU1gB2JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1wAKCRARpy6gFHHX
 cuOpD/47sYsAvMcTPt3gWFt5Ys+R87FxssehI6pHubn+78bsn3A96WfHX3VZdjGFkUwzq7viptr
 RlKwm+AjcRkZCIAp+ugg5N9+8vPcTORKyP9xbzi7EASkZpDo+IU4OlmiCU4v2zTgcGAcyyrfoZZ
 5Mqwy0vmUjKyZIpos5R7Vo7shS5vI07xLGO+HJdM1HDJKzWrKAvLgFlfxMI3mifhdVSnObs7sIz
 PZ0CGeMWoJohiueJpkAyQXRZfbSFlm74sgWDPkoi6v9jF9xQfmm0fDXDP3mtTwiZ9rmwRUDILhm
 80/0JruiNWEcI6DgtbnR9LCRn9NVRiEcj/CFI6fUpD/g0u1FlzFrOIsV+3vyMqwTigQfduAHnaf
 sKpjFNq+0F+G6zwx+qfv6+m6l0/FqibL/QD368m/6UWEOuA5QdztggCXz/CeAUKS8LnrO1qFpRm
 3NMlOEksrfrnKJDsL5h7Brl5U9AHsY2VotvmZOOv7oBITkFrqej9++l0E1DEoLLnSev9qv0SQ53
 JG5CKq3vK049drq4KYMkWXs/rp3EA3Sa2NOQHBpKztdYLU7AvN67AK6kkGthMVGHTmiamfx7I5V
 SZKIg7FYbj/sALZWC0cI58VEgRQI/d2RllME12D+mExb4lYIMiN+FEzToGsTZKmVFXGfyQzL+jF
 9XB34b80/dF528w==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Extend the UFS core ops to include callbacks for generating, importing
and prepating HW wrapped keys using the lower-level block crypto
operations and implement them for QCom UFS.

Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 34 ++++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h        | 11 +++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 0da2674777d2c..58a310e2571b2 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -195,10 +195,41 @@ static int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 wkey[],
 	return qcom_ice_derive_sw_secret(host->ice, wkey, wkey_size, sw_secret);
 }
 
+static int ufs_qcom_ice_generate_key(struct ufs_hba *hba,
+				     u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_generate_key(host->ice, lt_key);
+}
+
+static int ufs_qcom_ice_prepare_key(struct ufs_hba *hba,
+				    const u8 *lt_key, size_t lt_key_size,
+				    u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size,
+				    eph_key);
+}
+
+static int ufs_qcom_ice_import_key(struct ufs_hba *hba,
+				   const u8 *imp_key, size_t imp_key_size,
+				   u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_import_key(host->ice, imp_key, imp_key_size,
+				   lt_key);
+}
+
 #else
 
 #define ufs_qcom_ice_program_key NULL
 #define ufs_qcom_ice_derive_sw_secret NULL
+#define ufs_qcom_ice_generate_key NULL
+#define ufs_qcom_ice_prepare_key NULL
+#define ufs_qcom_ice_import_key NULL
 
 static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
@@ -1848,6 +1879,9 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
 	.derive_sw_secret	= ufs_qcom_ice_derive_sw_secret,
+	.generate_key		= ufs_qcom_ice_generate_key,
+	.prepare_key		= ufs_qcom_ice_prepare_key,
+	.import_key		= ufs_qcom_ice_import_key,
 	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dc8c055eae79a..df51c0a96c675 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -326,6 +326,9 @@ struct ufs_pwr_mode_info {
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
  * @derive_sw_secret: derive sw secret from a wrapped key
+ * @generate_key: generate a storage key and return longterm wrapped key
+ * @prepare_key: unwrap longterm key and return ephemeral wrapped key
+ * @import_key: import sw storage key and return longterm wrapped key
  * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
@@ -379,6 +382,14 @@ struct ufs_hba_variant_ops {
 	int	(*derive_sw_secret)(struct ufs_hba *hba, const u8 wkey[],
 				    unsigned int wkey_size,
 				    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+	int	(*generate_key)(struct ufs_hba *hba,
+				u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*prepare_key)(struct ufs_hba *hba,
+			       const u8 *lt_key, size_t lt_key_size,
+			       u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*import_key)(struct ufs_hba *hba,
+			      const u8 *imp_key, size_t imp_key_size,
+			      u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
 				    const struct bio_crypt_ctx *crypt_ctx,
 				    void *prdt, unsigned int num_segments);

-- 
2.45.2

