Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D990F2AEFE
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 21:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728423166; cv=none; b=qnu31dTWbvem0mKdpU+8lH/wJWFCFGrxAT5cLafwqL72Gfk3bHflROwpPs2rKgYqSS3PysU3L+rRSVQBv+OZJCdg0iuizqBpkejrj3d2zF5Pvb++AelUvrD6FC0AvKNUO8FGv5LAgmSRLODIY7gSADzJrFKIOZO+T7a4b4yqZvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728423166; c=relaxed/simple;
	bh=eFJ1ie/RYBsqXDiDeGdCUQQ31HX+Mr2w3Ji/EyEXKTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nuxM5hUpuATi4f9jB4Nv1iK74uuHO1Y083qkSzZpTQsIHoVowM1WVXAVJZeSR2tFL3EqsqCWBwLEi4lZXHd1OP3KdyQCECaT6llur5uVh2n1Q/nsyjZlEcdXYj+Y+57imjzRThvFQM/SE8cr5dsuzvP7Op7oeE+4NycWWwvpXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a23hAdpI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a23hAdpI"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42cae563348so10169095e9.0
        for <dm-devel@lists.linux.dev>; Tue, 08 Oct 2024 14:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728423163; x=1729027963; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dpf/YQh4qLyXuyP2PMsH+RDCgsU+3V8RGUA7JrjOw4s=;
        b=a23hAdpIPzVXg6Fk0aqIJgrHz34470dJjhGFnSjh/gm+6NlCOAPAIKYIL1mABJd4dp
         BUhvl6uOmCesaPRQqReCnuNw620uJTxUhTuzbrrDgm4TnlgaW3BZcvhWTSbPCxrNuah+
         AxR8m8ce+cgtVs17OsuVFz8MQBzmnXr/mtwuwCVK4bcsabrciPCiBxMgjlRVAu2YSenS
         DpXG8qZa7Uv0CfxIqPeZxg8PGJhB7HOugRQ1BQ9z7KIiSeyTnTlBtbEhHpt4sC+EdkYO
         lQGS4+CHjRa764TvdRkPaf4RJtJWXEfW69M1ANjaMN9gSp0PUpMBGBqlVnf1o2RZVXZb
         ixjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728423163; x=1729027963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dpf/YQh4qLyXuyP2PMsH+RDCgsU+3V8RGUA7JrjOw4s=;
        b=vUHfA89sKPw3sgNC9R6BKExFc2v5uZIHNavo1ZOlJMHJCT6SgKzsFBmlWt+pkt9z5r
         L+aEwIoOXmfnkrclDXmYX/ooL62k2f2i/h3ui7ijbAuggBsTBX4KJp6H9x61ctAL4IOD
         5ypRTP3xbAIOBX1DRKiR+LbpQBAHOiruFuw4m9/yYyGkf45Au9qbDv4py5H4tN0x9W/E
         sa/PsIU2pRdrXGL6J2vMbKH+OflLNKd8CeYlVWq+SFAiW/+FyK52Fn6k1JfTgqHVBZJJ
         ITaDwSRRb/BRhlaRUKK7EVqoVv3WMDGQl8rGmoYoKDmAK5lpLQYbXdOYb/EpvUHRSOCT
         m+Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWZNnlSlsMji/Au4tLGVhRHlgbeh5ZBHr5KCbUMnMiJZhGAR8aPFS3YKj0hFd0XM01bd4gwuZjuvw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4MbLlDHNxLbUZ67krWFDcU9c4j75Hpyd/pdRi2rYRDdK/3Hj+
	ue6uF8Pmnpo85NkT4R7uWP3WtFfwxq1RTJ4hNlmu67Ra2S8SxSc=
X-Google-Smtp-Source: AGHT+IGcjDKvnPbOL9T3H/Lxh+3Ta3CrnmxUypOixESA3c5XeMJmuFwIYRH8eZgK2Hd7wB5zZyu3+Q==
X-Received: by 2002:a05:600c:5250:b0:42c:ba83:3efa with SMTP id 5b1f17b1804b1-430c3a9a95fmr507105e9.0.1728423162824;
        Tue, 08 Oct 2024 14:32:42 -0700 (PDT)
Received: from localhost (62.red-81-44-152.dynamicip.rima-tde.net. [81.44.152.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf5f3adsm866705e9.22.2024.10.08.14.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 14:32:42 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: update comments in hwtable
Date: Tue,  8 Oct 2024 23:32:40 +0200
Message-ID: <20241008213241.144185-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Update description of Alletra NVMe.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 01d50303..74575eb1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -123,7 +123,8 @@ static struct hwentry default_hw[] = {
 		.vpd_vendor_id = VPD_VP_HP3PAR,
 	},
 	{
-		/* Alletra 9000 NVMe */
+		// Alletra 9000 NVMe / Alletra Storage MP
+		// GreenLake Block Storage MP
 		.vendor        = "NVME",
 		.product       = "HPE Alletra",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.46.2

