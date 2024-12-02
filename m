Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1920A5CA
	for <dm-devel@lists.linux.dev>; Mon,  2 Dec 2024 12:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140990; cv=none; b=fMrDEZL0MH91zIJYTuUDZsKsSfUEEG1pdgxViAnu3XcGzKguXATG7S7+rDh05oPOW46pOre/luEyVZbqbFK6UXvvC5z94/xbAdkffOANH9k0ZdbuKrwEDptN7C8MQh/KOBL2Eh7RfZZ8aRF5z4kAqPUgh2bILi0ILQGu1AZZAZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140990; c=relaxed/simple;
	bh=IN6etAo6wtAFxbXGT9XJbAOrzWvZ9os6hEZ0IsjibBE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=knj9sWxOWTNQwJ4pYSydM7HPcZcYQhb5OSSSwoo2J+0jGl7y67CC7GQ/e2jHDh/Y2W0q8l9Hifkj3D6/rcGslsoTpQc4diougifyT0mYrFShFIrZU5XOPPeYJPVChPwr/vQMBUPwdrjgmbT2oBRX1dL7sPsrQBGWeNyfi3SiNFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=ZrFC+H/i; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="ZrFC+H/i"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434a10588f3so25932805e9.1
        for <dm-devel@lists.linux.dev>; Mon, 02 Dec 2024 04:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140986; x=1733745786; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R7TOWAjI6mgo3typHSgU/6g6JMqxt2KgeMAkh5f6OGU=;
        b=ZrFC+H/ivBf9Ig5xC8mX3ezZYUJy7IF9XIZB5q+VdbQK4c+5E0QvAOSPf4ro3KZt4R
         JKZ12BfP0ju5mRgVlbqPL+9VjNw6EG2+dmGgJLgZla7IagbDvzggDXelttKB8xAukbQG
         p4YpBIOYp5sxwKdBcft1vaE0RMBWHvHR4uGb36omIhG9FTZRN5q5Ogu67d7IgreO7JWO
         QSAxcaBmUJ9eZ3mGk+A6ghSNXoqUZRWybs9JsxFexM4+BpCOy9+Ev+6hfPG/QG6voFGR
         6izUNnBN1Y+nulMvQmP08avRgUbsi677gt/iMmS+hTj8RE67RLcDo2F4V0vWKwHRRTse
         bF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140986; x=1733745786;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R7TOWAjI6mgo3typHSgU/6g6JMqxt2KgeMAkh5f6OGU=;
        b=HhT89mOZeIYwZQFY6Bz3jInVjF3SfYmXWy1/nrgGF+C+oQmISTWhGRwOb4W6a+wddu
         eSRbfJsmeOif6mmN1ZzQEDBVds8jbWj934gNGbcuLbyqRL83b6tJaIsYLXiHmL5JklcF
         HhPPKxvH9a/cdX3spkeAzWhRiCs0fCPjtHt8yswyQ/wKlDNJEc++5VdSAZdjswD4mKZR
         0LXCNt2e37iHCNXHC/m2SZt464v1hX/Sj5nTxDfgtKQlVX3XEa9E004HPjrDyGbSN7dT
         la3b709+D3eztVLumVYcAO1IwLTjbrM6fYiselh1mpMhIsZoQbhamK+XBnmRe6Q6vhwr
         nsjA==
X-Forwarded-Encrypted: i=1; AJvYcCXsr5DY4sR0IngD4Nt/KWYQtZNl/oM/qt3OSWqu2Q5Wn3GktcEfUNhvK76lKcqdlZMi1Leu/295pQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuAVjqCiXr1WHtdsalV+Emp3wBVlnDPnFj8iNcyx/LgrS2DFYT
	0UfCSlkTBJZD9iGJau53MGYzKgHiKWQKh0LF0Vo7Fbd4x5O/MAovEbCXCmXSBYQ=
X-Gm-Gg: ASbGncsp891evyb+pS5dM12FU9TJzkatWLdCA83Kk55QMyqWsOpbTLvoGRAyOTJFqyJ
	JufFfh9jXjPU+SkhdJL7DXHidfVYJokbjvhUnRxdj1qESjDdEugrkEg881eWLaRT7JMlzjT8agG
	M2pALvi931Ux0bYr0H936KVEMhtGt1qQoQvmZCJ6rftm45nwdcq5T36Buvrhd3FQj1rg7cLe6B+
	W7HqG7aKOOqc34VbxdjoMYwtJPxgVWjr3L5iA/a
X-Google-Smtp-Source: AGHT+IEblIdLaPCkPWIaBiUzUXooM1nm9pS8RLKm1Rnw6SlcAmQnVQ8kz2BvOTzozxeqidhfvRPTjw==
X-Received: by 2002:a05:600c:1f06:b0:431:2b66:44f7 with SMTP id 5b1f17b1804b1-434a9df7a8dmr222885245e9.31.1733140985417;
        Mon, 02 Dec 2024 04:03:05 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:03:05 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:30 +0100
Subject: [PATCH RESEND v7 14/17] ufs: core: add support for generating,
 importing and preparing keys
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-14-67c3ca3f3282@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2597;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=vY4XQO43wfRW3xI/7uuZkDLPJhyrBjrY4cfeoG+PMz8=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHWIEnk3YZilaM3RjOTRCNfoccxXCgiWgs21
 PjJLQo3KemJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1gAKCRARpy6gFHHX
 cqWwD/9s/QIp9RedYoUmJr1mV39dwfCeiVoo/zmuH5/kRvjp3XhFzfg2DqWPpeeuZzf4R7gl4pa
 TGNNYvSnl0SfdPXR12dGxbYjuFmeOT87jjfu45B3lEI1Np4kftp7cteHHlfW+FxPN5KhvcblES7
 QxdHm2LrduuzMq0/FxM+hC9DpQt/+OXlvWsKWAlKSGMlQcipS1S3CMf5yD7Z1vDCL8NipDuYgCZ
 ttVGBqJFaSM5AWdLgyem1tjCDr3RPe6Vc1Un8Q9DaIoQU8S3oe6/c8asuBo/mUhCMeykG/D0Edi
 uVZActTVn61PZqT12d9/TmzqFi5l/MfPLYfm77QxR7kz/uN7OalyD4IoESTVgIXDmBOFpaE6eHq
 rCGy3veOw29fuN/M3FQnZJ7I7j/HR2ZNlLHIDdRuNXJjO7EUv3bHh3y+9ivDCUgP/5VadNva9Xn
 Z5msG0AiQLYeJP79rSFnBcyGtkZtoy/GIZje927jyU/40K+nCgN5O8VMIIgu4QNc3rr88zolZ6j
 T4NapWeYPWTFd/Adi4kGJWvbB+HTASJdsR6vQgA/iCQctW/qjmhY41Di1IdWa5RGS3QQPfl19cV
 jSN9v+ZDOJXkQpuBbWU4ZDxTX7sgO2MqUqTO7YMBZm1deTKc8QnTBCqzgkTdfjjsEQMm6JnQwlY
 OYJxCc9PqOLjdOw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

The block layer now allows storage controllers to implement the
operations for handling wrapped keys. We can now extend the UFS core to
also support them by reaching into the block layer. Add hooks
corresponding with the existing crypto operations lower on the stack.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/ufs/core/ufshcd-crypto.c | 41 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 2530239d42afa..49c0784f2432d 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -145,10 +145,51 @@ bool ufshcd_crypto_enable(struct ufs_hba *hba)
 	return true;
 }
 
+static int ufshcd_crypto_generate_key(struct blk_crypto_profile *profile,
+				      u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->generate_key)
+		return hba->vops->generate_key(hba, lt_key);
+
+	return -EOPNOTSUPP;
+}
+
+static int ufshcd_crypto_prepare_key(struct blk_crypto_profile *profile,
+				     const u8 *lt_key, size_t lt_key_size,
+				     u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->prepare_key)
+		return hba->vops->prepare_key(hba, lt_key, lt_key_size, eph_key);
+
+	return -EOPNOTSUPP;
+}
+
+static int ufshcd_crypto_import_key(struct blk_crypto_profile *profile,
+				    const u8 *imp_key, size_t imp_key_size,
+				    u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->import_key)
+		return hba->vops->import_key(hba, imp_key, imp_key_size, lt_key);
+
+	return -EOPNOTSUPP;
+}
+
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
 	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
 	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
+	.generate_key		= ufshcd_crypto_generate_key,
+	.prepare_key		= ufshcd_crypto_prepare_key,
+	.import_key		= ufshcd_crypto_import_key,
 };
 
 static enum blk_crypto_mode_num

-- 
2.45.2

