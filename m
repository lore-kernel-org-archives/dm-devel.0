Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7813D5237
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 09:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540818; cv=none; b=TE19spD0TpU045vPHg+QezbeTBnaO4gqMu2qqR6S8rNapm40/RckYzDWzdeoI1qYn8BKxmq3A+ErfJs15SmGpI4R5mIZhG6sFryDsh1vAIk+Fg1pBSOGuzodJzyHx5Z9qL62LMMqqsxteO2TPj17UxcCONHpe+e5HfgI+S9utno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540818; c=relaxed/simple;
	bh=Hnhah2ebqec90qcHnlXEAoctQ88fsTS1yJX30sfvTR4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ek4KRnbGiVc6+vwfcU7xEsdo8tns2mlVILNg/In/URQahclIPkns/aDg7auVwOnSl3QBu48QqaB4gA6ZytVEUAdFzzpIEC1gDzrinbH4hcmP/Wno2fgM1GQfb8bteJiLJEv+RSS7PpTldwQt9gRw+Uq5cVW7N9KUfE2Y1R+dYlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DnqiUq8D; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnqiUq8D"
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2cabf1f1051so19554935ad.0
        for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 02:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784540817; x=1785145617; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kM4PYmbDg8H1bvVv6wH9s8WtaVDw/EXpqdeFxSQlUa0=;
        b=DnqiUq8DOVxXDYdnA5/cgX2XsQ904blaUydKXchnqJioLFjvyxJaYrEQLfssnquUWf
         YwmJjFngJHyPC2Vkj92hSCkPxaKfN/56mq9WkgctFV4rgg4Dk6R4Z4Fe7eOnTwBXrdZz
         l9uCrwRlGKhafwolmgvi+fZVUbzq757YpaRjgee6uxyeQeA8LTupJd29bSmvHYBzVjzj
         qKGYnzCXy6CeqXZBcCFfzY0OYIpE8O2afvqX+pLKSKKFiYgU9TIrxDl62Z9lXFsJM2kb
         Sdr5IOq40TzyjjF18g+iWrXU4XWNFM6k0+93kElseFPkvfm0MonQHvoWXUM6l1oiQP67
         3goQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784540817; x=1785145617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kM4PYmbDg8H1bvVv6wH9s8WtaVDw/EXpqdeFxSQlUa0=;
        b=rl4O1FWXfngfLicGFKdHvsdZRGi3nFwDaUn9qc9fTTstTbS+GV2nXIYe2DcgIin07A
         coe+Ozk/c6uSw1RRhiT0xx/d1dA6l4iVvu1JNkIMdbQ5QYrpnb5FvV/RBMSFvc75lD6h
         BQJbhe9yDNQPmxO31k6MshC9VjyHHbSQXbTey/D8U9UNp9+MgeQ/5v9WLvvmThlNMXaj
         WMiWLG85AH1oS+cMJV8xEJHlxOMxzhiIVDXuY3WcHFhhniaeVsEGIJ2HA6PgrG2xFKhG
         1BZmwvghcWpuGAwdPe+9gctyPXDA7uLChqTQlAs7k/vc8SRvP/BEv3rH7JcdkAUwj0Am
         jKpg==
X-Gm-Message-State: AOJu0YyyWikZjh5rROTnNNW64fwGsrTVQNRD+tfdO50lngPsVinYX1mP
	0x8DV99sf/oBhHN6S3zyKjqfS2BJsfadmoOSfz7LBit7ANEjZrNtP12+gXM4K1YTcR4jhwlPaUo
	=
X-Gm-Gg: AfdE7cnt5GdF4nR+wqsqQXdR3sBeaG4CPt8JOtKQlEn8uP4nARg6A/IpB4J4bknQB1R
	XzkixGigUh2HLAzxMn0pQ/4HKHj/hJkk3ayIVy0tekZR2JRRDfOgpcKyuFdxKQjLqs0aLcte+1h
	2GoObK5wywc38SQd+8haOmGuIQe3npXpFiFj1M1FzqSQQnSzXYwXVCYH7PAwhY2IwBDGE4bGBCW
	bGN/sxU2fgHZYbWe/cMC0dSU85TfJm6GSdUX5R1qalbmJh7f31+0Mz/1aJDUiENr17LrXadnYIv
	wzvpBsE68BMHqX5bj7iderZXIqPVH4H8+Tvx0tz63ur8dWgK4IDsyLN8E71ad7T4CAX8vbaf5IN
	RdOR5Gp+a7luJUJvxO6QNLlm5EIgdou06Gx9FrzgMd7CM51142KuBIn2fysXGX0fgSYNUjjP3bX
	BUnMfBDadjkjWlQ2Z2zbYqb8C1NWY=
X-Received: by 2002:a17:903:46ce:b0:2ca:b300:43b7 with SMTP id d9443c01a7336-2cf348507f5mr138480455ad.4.1784540816982;
        Mon, 20 Jul 2026 02:46:56 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf346d9ba9sm54406335ad.48.2026.07.20.02.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:46:56 -0700 (PDT)
From: jianyungao89@gmail.com
To: dm-devel@lists.linux.dev
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm-pcache: fix implicit u8 truncation of gc_percent in message handler
Date: Mon, 20 Jul 2026 17:46:48 +0800
Message-Id: <20260720094649.10104-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

When setting gc_percent via message, kstrtoul parses the input into an
unsigned long, which is then implicitly truncated to u8 when passed to
pcache_cache_set_gc_percent(). For example, value 266 (0x10A) silently
truncates to 10 (0x0A), successfully bypassing the > 90 upper bound
check in pcache_cache_set_gc_percent(), and setting a different value
than the user intended.

Use kstrtou8 directly instead of kstrtoul, so that overflow values are
properly rejected.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/dm_pcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
index d5cfd162c063..645fc27d82ba 100644
--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -439,13 +439,13 @@ static int dm_pcache_message(struct dm_target *ti, unsigned int argc,
 			     char **argv, char *result, unsigned int maxlen)
 {
 	struct dm_pcache *pcache = ti->private;
-	unsigned long val;
+	u8 val;
 
 	if (argc != 2)
 		goto err;
 
 	if (!strcasecmp(argv[0], "gc_percent")) {
-		if (kstrtoul(argv[1], 10, &val))
+		if (kstrtou8(argv[1], 10, &val))
 			goto err;
 
 		return pcache_cache_set_gc_percent(&pcache->cache, val);
-- 
2.34.1

