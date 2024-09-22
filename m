Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CABD2CA7
	for <dm-devel@lists.linux.dev>; Sun, 22 Sep 2024 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727021888; cv=none; b=QvBPfDLS++ykA/m8DxxBMS7uhiKhZRMbad5QGmnUCgXb5rZTRiSUrdbog8+6VeFYPPe2KKa9PyKeA5A6R6Ih8rpqz+x4XlvbxW86NmyLQQkeNiL77ztvvtqHB0chcuUKafj65GR4HoETxUvl7r+gotAuXMpHiB9Jmq8dYJqIMRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727021888; c=relaxed/simple;
	bh=/WSpxNXVkatENcrgjo7eHFmuAPp/rWba37N1OeGRVvc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uZnUz8/LYv2ABClQ0yRcudfkgwMmEhWmm/iy9M3nLAiHq8Du6mNsQ4YSHh3eEyhuGZ9AThmfOpiIhixL9r24soRIhGzWf+lfQKWyL9eVEBX5hQSxCoU35ioAK/L9YRvFAL1s5EEqX7X3OC0swk7n5gtazDwDGJtC/laAi/nV2W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6flNAZA; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6flNAZA"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-374c3eef39eso2179349f8f.0
        for <dm-devel@lists.linux.dev>; Sun, 22 Sep 2024 09:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727021885; x=1727626685; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Puegst2ejpLkuqHyRgQXh9ZXrrFgmDdlPJkqKeUUU5Q=;
        b=d6flNAZABoOHRj7IjjTDvCc+c6EUiimcWw6UI0mi467L3LweEmUUKTlT2Gc4/L8zOh
         730VUEthb4UP6I8stsT7DJiRDiJ9GMuUiPOcB1UzFAQ9C2WeTjdQ71jWrKCqaotGLGBU
         td9K8rustYU3XH6afVaKgKn0TwxQHrmIRovWtghk5GxTy0W6CUQUfHSxzydIRdXGfVP7
         s49WzEjAWQTwlZGHJ6CCIyEba+UC1VFZlt7xYtYQahcCih6wfEN1D7G6ugg3nPqJ20lY
         /nzSbKkrnMm6MfuzeU8FSE/KCmOPy4bTb67wyQ1KiGAu4BLJJr70vjrdppTzTqKdnIrA
         7CuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727021885; x=1727626685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Puegst2ejpLkuqHyRgQXh9ZXrrFgmDdlPJkqKeUUU5Q=;
        b=vWKMeHTngKsRznXbFHDhO9751iPysWQguX5vu50UI7rqYCWnS7X7cfZoq4sYPRUzwT
         VjL3QwqDkZocMiVAQA4AWPZ0xL5xQfx4wNKUvNsG/GHaJdiAAfhqrMOMSCXg9C6Gylie
         XWYSKA7F76CWZ5Gorfvn1fhY4EcpI9b83Av6B+rIxhT4dW8SV2rNiHFw9B50km6SjYI0
         bdF0LLP/9iichtu1enMtU9BlAA43V1Swvx2tjvZOgE1W/xbAN2CDfo6CGxKXH6fjxKJK
         X1WWAtGg2Yb3nlgk0/U76fKcM5zeE+5MKW8koJypiruhushf+kGLfQUQjhHgcMFO3e0h
         GuDw==
X-Gm-Message-State: AOJu0YzJ2ZgwcBkj52TXKH62BHnk0AnuBnDajIQLewlLmTdsmn8dEvNZ
	qHIJUUmG7g33j8hdveryjFFUBbv/8v6ou1ynzfMHYifIS+y+ZD6Qn+8nNYcuI2o=
X-Google-Smtp-Source: AGHT+IEdf+2h8kB4vdBghOhYJbmVfrzapdmladFmJscY0ErwheLAzkEpmAojptZn/qn1uCxru09azQ==
X-Received: by 2002:a05:6000:88e:b0:374:c17a:55b5 with SMTP id ffacd0b85a97d-37a4226bb7bmr4769848f8f.14.1727021884432;
        Sun, 22 Sep 2024 09:18:04 -0700 (PDT)
Received: from localhost (ip-185-104-138-53.ptr.icomera.net. [185.104.138.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e7543ac4fsm104229525e9.19.2024.09.22.09.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2024 09:18:03 -0700 (PDT)
From: luca.boccassi@gmail.com
To: dm-devel@lists.linux.dev
Cc: snitzer@kernel.org,
	serge@hallyn.com,
	mpatocka@redhat.com,
	wufan@linux.microsoft.com
Subject: [PATCH] dm verity: fallback to platform keyring also if key in trusted keyring is rejected
Date: Sun, 22 Sep 2024 18:17:53 +0200
Message-Id: <20240922161753.244476-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luca Boccassi <bluca@debian.org>

If enabled, we fallback to the platform keyring if the trusted keyring doesn't have
the key used to sign the roothash. But if pkcs7_verify() rejects the key for other
reasons, such as usage restrictions, we do not fallback. Do so.

Follow-up for 6fce1f40e95182ebbfe1ee3096b8fc0b37903269

Suggested-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 drivers/md/dm-verity-verify-sig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index d351d7d39c60..a9e2c6c0a33c 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -127,7 +127,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 #endif
 				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
 #ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
-	if (ret == -ENOKEY)
+	if (ret == -ENOKEY || ret == -EKEYREJECTED)
 		ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
 					sig_len,
 					VERIFY_USE_PLATFORM_KEYRING,
-- 
2.39.5

