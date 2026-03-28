Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3102D2882CD
	for <dm-devel@lists.linux.dev>; Sat, 28 Mar 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774710731; cv=none; b=h5YgzGz4BcH0VDjF6XepYau2i/ZcRbkOLJrJzi8h6sSFy03obue6oJurlmo5CmXaST280iFkwQEXWejfrLVwCelr/lUX5KesGqcNCw2vdPlrTTWdqzOaaF4exqPr8a5a/WlbcsgTD08EqRiRbtup1Gu6+X9M90YtwlE8vJH/paE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774710731; c=relaxed/simple;
	bh=yf3DwBQd/qW8fuDkls3+B+pLlM7AVooziK1M1WkSdbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P1CnYgzBIavbbk/HlRO72DA9XFejqK3sOt7t2sDbu9XpSp5eyO2jT56OEKWMJCbJzZl80oG3Ah1FP3ijiNO38pc7o67kj9jfLryistBM3QPV+th06v4hp1zE+Qm4iGf3gKPQVsyoEdlY892f3hL6UONucmqDXrDx3h7gUNMcBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R6P3G0da; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R6P3G0da"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b97a06d7629so474915366b.0
        for <dm-devel@lists.linux.dev>; Sat, 28 Mar 2026 08:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774710728; x=1775315528; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CG4lhxLbx+R7bqRxSPoGkcp0JFjB9yVrrjNFeLCyhCc=;
        b=R6P3G0da+Px2kjXaObOqO4jRXm400h9yb1ZonxtNz6ZcxgmifJJrjohkd2at9XE4JX
         xt0Q/fYZ10Fhzk2rEjddhM7ChqUZFZV0BUTE+tAhrOGbT9DwNMnmki8n3GC1dqHy2mnz
         hBgD81H+QuvwlK8kucCpEy4k4he8VT9UeJgqApCFOJCTM/PGtbShZhaLb3jBg+R4J3+Y
         iFxHwp/w7O/onxypzMYTw88xyB/wCvcOnJnpJHj+gd1Ojq6siHiPJUlJfsXBQa4ARzVa
         WMEGCrSyn0Nr+sg92y0HeYvuXFp6B72KuEN5zcduqXS7EW/Jt/tUXeO+Gk1h0nbQZGgI
         3oRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774710728; x=1775315528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CG4lhxLbx+R7bqRxSPoGkcp0JFjB9yVrrjNFeLCyhCc=;
        b=nXtW6AMrK3rV7AvsE7pOZ3DlolqwNZ0FXf9xk7L6FuxgV2ecf1S+EzwVycaUNIJv3q
         KCY3YpXGQ0D2DzkizoO1aC0jG9e+mNyYFp5Tdp/EpjP1NAnQhRhrTWPS901zEX05PAl9
         Px8c3UHPoMUA2aju6xH9ZF/vbSvx0dBU89NS5oR0p8XK5Gc00RtndGjJ8pCCsuCfBRQl
         xc/DHWbbPYUr80z4S1AtoIYZIC0wwK9fOtydkufbxB828aWEivzQwMwLwoyuM7CalKOc
         DrQPLrXv9s3to1R9tuvJbDBO1kzBOPejy0C732SD1LOYN8U6vU9jyAFG8XHUmyD/syBm
         d3yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOTZHmYxHW7mvji7jcv5uQIQB9JMIxK/7NqzLROf2tFKJeQzVb15TEDQ+Or4oRPXaxIdHRUJicZw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwOu6qkIcPdmuI9YuZ/4sQGkzNrOz6dyn4WVZfXMjycks/0LaWt
	HFZajmqi9c/vpa4aEJukvIz6r5dTixkKx6ZRFYDWpoqSSf9TnNa108/4kqohaQ==
X-Gm-Gg: ATEYQzzFNtqr5OchTImd9IApHIwvkYRZXKR0wo6kr/MJuBt+yZl4SIcUio30xVs+BPV
	XNiXm5DlY44msTV64vhWQO3MYdmp7ox94j+4TuXc0VdYmTHApWC+7N92D7iBaZLih+vMvWesX2t
	hIvW2u5IR+a/Tp/+GzBEwhydl5oUJbpoVKg5+UIOPPiv4oCuQHn+4iiIWIz9beHXVxSlpw3iOoq
	31sKywl9u4zEsNT8Axdb9w8RHMIB0BoftzvSUIbp2dEK+yxvU8kht7Py3zBl2Zy/6k7nvs/jExg
	bMZoF8IAoDk7ZvcnPgJ3c6/LZICMnfm2wc5vWAL4WYTv0ziOHnc5czKI0zLrQ9W27tJIgnJKyHj
	nYHQiKhZc1M/LkNeCKyd4lDxxjtTtLmjsC8kXLnbUJFu4ylc6UVwxPE1rGvfurqSETeeUZ/8bOo
	KRcQgZ8DpEB5df+IuDPiAMCLjudMxx9fD/
X-Received: by 2002:a05:6000:2409:b0:43b:87bf:89cc with SMTP id ffacd0b85a97d-43b9ea778admr9649428f8f.49.1774701283205;
        Sat, 28 Mar 2026 05:34:43 -0700 (PDT)
Received: from localhost ([87.254.0.141])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf257cbc3sm4616645f8f.35.2026.03.28.05.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 05:34:42 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Matthew Sakai <msakai@redhat.com>,
	dm-devel@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] dm vdo: Fix spelling mistake "postive" -> "positive"
Date: Sat, 28 Mar 2026 12:33:20 +0000
Message-ID: <20260328123320.657837-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a vdo_log_error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 0135a6f941fd..1d8375cc3c3e 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -412,7 +412,7 @@ static int __must_check parse_memory(const char *memory_str,
 
 		result = kstrtouint(memory_str, 10, &value);
 		if (result) {
-			vdo_log_error("optional parameter error: invalid memory size, must be a postive integer");
+			vdo_log_error("optional parameter error: invalid memory size, must be a positive integer");
 			return -EINVAL;
 		}
 
-- 
2.53.0

