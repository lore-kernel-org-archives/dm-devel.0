Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7581CEEBB
	for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729540508; cv=none; b=N4ySfVq2mqktUCH8woMuRfBHUuRScTZrTvgrV/e/jA5LR2glTTzwphn+PD+83xCrBoIZr7wsUOC5Z+TygTRRzthkQ/Rd6Zhc6IovWJ23fxZKlbb+jh2g3sJsuC+Tgv5nCvrxYGw0RTWTMFv3P3XID295AA3S8amsERGZ2OnUhVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729540508; c=relaxed/simple;
	bh=zumXDRytnD0gytZLritbd5U0x7pIvjiTTT5QZmHWlvw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J6PyJw0KXFA59l1Vkv4gsay5D8ptLnFOe6H8E4UGapv9Nz2f4JEX2aiYMMyRDvCdbzWH7fE8jq4XWAOcuv3gc25llCOqjBlZQiEAUtD0qgkPcDTj+WApPr0Zy4dIjKLrHmizB1sRWlJD4NTez1CJ3+ZXJjyrdEeyzxm8TYBXVXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THxCLJBw; arc=none smtp.client-ip=209.85.222.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THxCLJBw"
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-7b155cca097so316959185a.1
        for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 12:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729540506; x=1730145306; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NoB96vqf07bgO8TLKXEoddJsTDp29hkCSzGD992tAew=;
        b=THxCLJBwtDINXh2bYPHKwafNh7Ioqddc+EvKa+349q7uUs7fUJsTTdPegS69kYOpA8
         h/vSBTRZ/3KPzQf5Q8ei8Vge4Rj5+sUEF/HMek0X2qm5BYxZxClaxuy8TLfjpbBOtMiB
         1VLwmSrBzUZStb119asz7muVfjhkr8iQ3Q8YwcF1eSToFPKSovVS4VWRMt4gULFxKlC7
         rAQPx94VPb0243qcNK9nFDqrfsRLWSnqvvKP+Shx33kmS/FVRpOpJSoHzEUeZSwey778
         eo3EP+U6wa2y9CfGtzS/Pxl64wLoCH2+RQbh/9Wl+P5QJh9GSGDnzPC5Ih21j8avzUXb
         PHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729540506; x=1730145306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NoB96vqf07bgO8TLKXEoddJsTDp29hkCSzGD992tAew=;
        b=vX7LI7zmS2Z33leedlcjjlznA8M0H7UXhC39bUTtGh89C30Q9zkMtWiTys7nzlGVYs
         18rHVi+7oeeo1GcZ0ePRgRMj4WPqJq9e1rNqj2YO+SoKoImb0vHtV4cbAyLPXf5aT7EB
         gX3vJXZlYiGnTLFE/rnrgEE9t4/DDl8R293+bJztoOgXeUPRFh3jIA7ncUW8ftwhdDck
         0Qg+IvYlGfUVjpT8/kedc9hhKDUURzSvwNlVSzsl91egyn3bEBByiS/3f41GpAC2Sckf
         Y2ko931+P4zRxW4a38zj8R4cRmsq505WM3MMHzm7quNqXZeu16lL2JEhMHOmE9thKzPi
         yM+A==
X-Gm-Message-State: AOJu0YzOegqT9c5cq8wZD5D6XusDk3vdHrDabpNde+f/Sl84gUftb3fK
	4dHuSin8xWWQEjRV1/bM+iZqkfk4cMQj3ZBW9fZdrmCX5Qn0JrB9o8PnnIV/mqYxPkDQv38=
X-Google-Smtp-Source: AGHT+IHNyXERodpxsHI7szIu81Mr/2Z6QrSLHF/qrZuMGUVynYBM/zqTBRGy8BeEI1oeXH/nVsFr9Q==
X-Received: by 2002:a05:620a:4481:b0:7a9:b2f4:42e0 with SMTP id af79cd13be357-7b175596368mr139304085a.15.1729540505748;
        Mon, 21 Oct 2024 12:55:05 -0700 (PDT)
Received: from localhost.localdomain (mobile-130-126-255-54.near.illinois.edu. [130.126.255.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ce009ffeebsm20658646d6.138.2024.10.21.12.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 12:55:05 -0700 (PDT)
From: Gax-c <zichenxie0106@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	heinzm@redhat.com,
	kbusch@kernel.org,
	scott.bauer@intel.com
Cc: dm-devel@lists.linux.dev,
	zzjas98@gmail.com,
	chenyuan0y@gmail.com,
	Zichen Xie <zichenxie0106@gmail.com>
Subject: [PATCH] dm: Cast an operand to sector_t to prevent potential uint32_t overflow in unstripe_ctr()
Date: Mon, 21 Oct 2024 14:54:45 -0500
Message-Id: <20241021195444.13237-1-zichenxie0106@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zichen Xie <zichenxie0106@gmail.com>

This was found by a static analyzer.
There may be a potential integer overflow issue in
unstripe_ctr(). uc->unstripe_offset and uc->unstripe_width are
defined as "sector_t"(uint64_t), while uc->unstripe,
uc->chunk_size and uc->stripes are all defined as "uint32_t".
The result of the calculation will be limited to "uint32_t"
without correct casting.
So, we recommend adding an extra cast to prevent potential
integer overflow.

Fixes: 18a5bf270532 ("dm: add unstriped target")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
---
 drivers/md/dm-unstripe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 48587c16c445..e8a9432057dc 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -85,8 +85,8 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	uc->physical_start = start;
 
-	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
-	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
+	uc->unstripe_offset = (sector_t)uc->unstripe * uc->chunk_size;
+	uc->unstripe_width = (sector_t)(uc->stripes - 1) * uc->chunk_size;
 	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
 
 	tmp_len = ti->len;
-- 
2.34.1

