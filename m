Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C81224503E
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 09:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745163; cv=none; b=t2ljsmeCvoOTW5o+D9cD9jupuXUyhkYLvPWL60raFqAaVJesNVG72PWZJWTBuiWUxelR/KD9qZ7KObn5GFetbVNAbUEHQQtZZKrY4CG5HUItA48Qyljt+TrFY0LmrBs8Z0/rhPik16xNL6PeGLGTeUb5ZsT0LM2zaaNjmGLe6Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745163; c=relaxed/simple;
	bh=PXmyjLlsfJQb3MrzHKwXR3ZAEn3kR3I+ymWaJsaafQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ix11fcP4HYUmYv1/E7tDpdOIZ/91tlnGxSvhyIY3EkdgVhhUIiLbbpUPlmlpSo3b6s5VfE0J1qf8Q+Y1JCZ3LAJdC9Gn2S+toIVqmGy8P/axiaZiMJdKp/Jis8LiGVmRim2kHRGpmsNdyjnZp72UoIApvfrITqgcumK7yPC0YdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKcj6PaY; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKcj6PaY"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-391295490c8so268553f8f.3
        for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 02:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745745159; x=1746349959; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9X202SE33MveczkeG5NEXWixARwd0Ywb+MPj57VcnA=;
        b=YKcj6PaYAcmvbtw2OW/vjmUJ2xXMvaG6Ry6lO399VlnrFkfnHZu6q2Tt8dMjhm48+a
         lCJPH9+3TocRZ+SHZGpX9i/1qGtkkHKdhugZpgtAgj9a/B0iZmYoNE8ukCccrSJ5BZlQ
         HUEQnGwllRt6r3gvcRrHoFSllksUiWrR47IawEijLzktyfegP3fFQfiQMeuXfBkUZG/Q
         YkZeSWMRF/sAcC28ZCEcb31Ya5msGGvd0eM43hKfJNGMfkOTO2s8pk7uRmx2F7rFcy8E
         xSRuSB84H5HFx/AS8+lIqqrlkWNgDCAK1EOPVeV+fqcQcMRCS5rZVetYkIvtGVDn6VJN
         6LLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745745159; x=1746349959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9X202SE33MveczkeG5NEXWixARwd0Ywb+MPj57VcnA=;
        b=Qd6BH/4K6s+V/tbvP/UGmbHngGjbK8MUoJOCfyZXM7XaPIiqaeIgxpJDhSh69PlEdX
         gDuP9xeNvkqUzM+mwrHdW03oJ+MkXD8XqaeEeOw8QRL+qQRsrQqVqrRJIYyuEErHJuMB
         rwzjonhvdXzMMkfDRzA3vr9TRX3MjpJMvb2O6dTK7nG72avyYfvmwpUs7RGUw3Jn6/7O
         /D+1M1oxVwJXG060qFMKhc9atYD2Ei6qYfUtaHRctNtZmTQvW8x9QO11DtqB3EIeEUSh
         PboFNTlxXwqP2Sg8rx77H524dq3+FFlsxXDCvZNyqVXDVDHz80/8ROmewpSQIewc49h9
         qdGw==
X-Forwarded-Encrypted: i=1; AJvYcCVMg4c5P68qRRzM7oMWkp6Gn8o7UiRfb0bf+vq20s3yP3TpQwEX62/XX1gdUqNOzlIDAZWY+y1RQw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwfR81+Qzv1vDpwbMm/2cIVspeHj1FUSMIdNWyn0YH6LryiiRgu
	d/wCvWTTFt8+c/iuiP0HGKcVso7GyFLD2Nxoa75mdQGDrqwvJ+Q=
X-Gm-Gg: ASbGnculI58UTZkrEMOdsT1USBehMKz974KgdEsBAsK58z6KS4MtNRDay3LplnTRNlC
	Uk2i7dH+DPk3A3ovsbel4mqMOSrozRcf9PJ29mZvOU8mtRYs0evOeCbS9DQRjBLAYJhF8t3nWwg
	gjJoeSFgWghTGiwuNAhwrOS+7O5R/NvFbjO5Xgp6NNPSacwSMr+sdhWDOc/+btog7ObhIRYBN+L
	XUZjp0bthCbcq3Jd08zbaWiU0UyCeBBFbR3XXsfTCb7oap/HBx7vuet4ztcUeb+/PSOfobjxQxu
	23KE+hZbJtUX9XrBIn4cH9aUk2hBe+fkA3/EYrevPi8aaR+ylaN1dndqUSTXaLQoxEkQv9gy1lq
	koET8CiX9
X-Google-Smtp-Source: AGHT+IGB5UgGimbVYKwZR2pV9POXdQ/5m3hybBgDVbo1NY/GGobOb1K92camV/Tm4o/sLakBjXOSoQ==
X-Received: by 2002:a05:6000:2505:b0:391:c42:dae with SMTP id ffacd0b85a97d-3a074e19ac5mr2406137f8f.4.1745745159250;
        Sun, 27 Apr 2025 02:12:39 -0700 (PDT)
Received: from localhost (234.red-80-39-170.dynamicip.rima-tde.net. [80.39.170.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073ccb8e1sm7976279f8f.59.2025.04.27.02.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Apr 2025 02:12:38 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: replace dead url
Date: Sun, 27 Apr 2025 11:12:37 +0200
Message-ID: <20250427091237.218458-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Original url at Wayback Machine:
https://web.archive.org/web/20230820174630/https://listman.redhat.com/archives/dm-devel/2017-September/msg00326.html

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Should this code be replaced with DETECT_CHECKER_OFF in hwtable ???
---
 libmultipath/propsel.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ad771d35..52a10765 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -642,13 +642,12 @@ out:
 }
 
 /*
- * Current RDAC (NetApp E/EF Series) firmware relies
- * on periodic REPORT TARGET PORT GROUPS for
- * internal load balancing.
+ * Current RDAC (NetApp E/EF Series) firmware relies on periodic
+ * REPORT TARGET PORT GROUPS for internal load balancing.
  * Using the sysfs priority checker defeats this purpose.
  *
- * Moreover, NetApp would also prefer the RDAC checker over ALUA.
- * (https://listman.redhat.com/archives/dm-devel/2017-September/msg00326.html)
+ * Moreover, NetApp would also prefer the RDAC checker over ALUA:
+ * (https://lore.kernel.org/dm-devel/D4D7BCD8-EB06-4B76-920D-4D5101851498@netapp.com/)
  */
 static int
 check_rdac(struct path * pp)
-- 
2.49.0

