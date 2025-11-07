Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D8031A541
	for <dm-devel@lists.linux.dev>; Fri,  7 Nov 2025 11:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762515808; cv=none; b=Cc6ZzaR5L0dX7HVeNVL3Xm6+Qxv/EIDCsINwDntrUYQTtU8oZnA/EvPSFYNn7T21XBq2p4nvYGNpu+I6TWp3lPlOMbIDO0zEmJXVRWlpwy6i5yKjpxwKdGmTuon3wYLrN0m7Et5MTnrrbo6ylAMpAdPyjxpdMI3oTTfTjQ/boYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762515808; c=relaxed/simple;
	bh=igxcugRo2gsC7ToIarEn9D9lM1HOHbVKL+npVMN4tqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qyUD7rlVQ7NH/68mG0256nItJ15hgBJIy0RJfI4ZI4DBo9jPJbpN56PAx0WCdABxZaImyPjBa6407zYR4ArPHIXnnTASozdaaoFY8TYM8jm7MkfAe8SMIlThbzsTuSREULwaEulMcYYowenZbY4UHxyFoTzQ0CmPHzelKLDTSVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fScJZUzw; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fScJZUzw"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-429c7e438a8so601288f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 07 Nov 2025 03:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762515805; x=1763120605; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DtU5xQgGX5yGwiOtiwdnNsANwvMzJtrcdDz0DORVP0k=;
        b=fScJZUzwIh5H1PGqJEn8eLXwCeU5+VQS/G5e0oFaohPBEyW5j7QbOpRooqC+PyifDC
         6tNn+WfS2RZru2dKsCYKXMfgfPUY2TjHImM0k7+rMe91wHw+WBhdSdKC4MaDuhL1poyE
         b64kZxPvU/j1m5Q4g235R/uS6CPEpheIJU+3rLWIwlZa40RLkcT3nxRzWGNSWludDRh6
         AlWSufrvQSOAbawAdLOfk/jcm7kmjZbq8gTYLrZA+B26mj+qTWkyrTzp8GLB92luormn
         HnGhz17bm6usS6x2D7JqC9W7xOH1Daxqb7jj7bPjb7NkwzTEgSMV0MzPhYF5Y1I80mMK
         WHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762515805; x=1763120605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtU5xQgGX5yGwiOtiwdnNsANwvMzJtrcdDz0DORVP0k=;
        b=DPwCvJ/ZDKAXwhctLCJlGSuVHx64TbqB/YNgmzILW7GmsJNtRY8Ojl4DGEXDgA5VUd
         WHA115RWkm+VIwTNfVy7mmFz21kbThj07XhgrHC7qnisoOuSYQCufgkIl9okSIMOHuG6
         OzmxNF8P9wYHdvo3F3XKgA4G2vkWgHs6vHqiiYMaV61qvDOUD36MX3YUa19nWdUxmh+t
         WIji/qJjGlM9fKHzItjfIZuzf/bB/PrfnYtx4mbQSPrvCd2hVug2AH/xOEmYTkMHx7Ct
         k1JViyCJD1tIl/LL3knBtZHZ/jJ3f+z9vhnApIFMGDid5V8eYIEY4sA7wXVjb35vLAoy
         so/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7loM1eIN8pgDlI8B6MDOc6lTObgQO1RPsybL2YRt8FH2wpKc3BxTSXlAVlmv3IuOBBicvG/hGew==@lists.linux.dev
X-Gm-Message-State: AOJu0YyV2UdGu+cOClVL6uUV3kCrCSFU0yQZvJK/snbw784oqSrcF2H/
	gjn5KIJL47X94yKgekbhwL4nknA9POrwkdE2poGirV+pyqiHO+MMyM0Z4QnpoUKlrgU=
X-Gm-Gg: ASbGncsiInRAi0xtcl4X3E+zCkv65m3kAQrbl9S2fBCx9ojTD0eeSMusbOk+sXqQmj7
	2b6Do26WydT1GASSumn9OmqM99Z4wKO6Sm0DAeEzB/6rIW8lo5BuXIMOE2WOQLV1Hg1wiROmpvt
	n40Ft9o2OYOWuBHgXr3K2EObfuKq7OXJNV+t6i0wXe9uKLHXvK/vzx9/5EccvbTPruFAcuYWyNO
	bBaMCojIow00xOCCwpcHHYfmxsx+CMBDWd3s38iqgkLADiCevK8o+gLJfl+k3M48XZoEqdFuRRW
	Iy0CcizbuWy8R+U8i8wqdUqYkGxFZDJ1ihux23dQ4qtTGYzp29I91jfNfbyyVPYxwGWYEZmBdhh
	DZYPposiZZeOwhv9F441qW8tiwDY6IbpfUGu5EwCFvyp48p2jQxRNVVZVrBV3wal8LOAQY0t8z3
	mgsbh9CH8s2BcJxmkxiBFwPoi1
X-Google-Smtp-Source: AGHT+IE71d1qwFCKRyct0sR3hoeElw0JEYM50BDNUYXDvLimPs82nxZjGLhOCDMs0ycfoeg2TKW09w==
X-Received: by 2002:a05:6000:2210:b0:429:d437:cdd7 with SMTP id ffacd0b85a97d-42ae5aefd48mr2333132f8f.52.1762515804767;
        Fri, 07 Nov 2025 03:43:24 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679c5dcsm5705754f8f.44.2025.11.07.03.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 03:43:24 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Subject: [PATCH] drm/bridge: anx7625: add WQ_PERCPU add to alloc_workqueue users
Date: Fri,  7 Nov 2025 12:43:18 +0100
Message-ID: <20251107114318.163015-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 6f3fdcb6afdb..4bd34b9825a0 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2668,7 +2668,8 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 	if (platform->pdata.intp_irq) {
 		INIT_WORK(&platform->work, anx7625_work_func);
 		platform->workqueue = alloc_workqueue("anx7625_work",
-						      WQ_FREEZABLE | WQ_MEM_RECLAIM, 1);
+						      WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU,
+						      1);
 		if (!platform->workqueue) {
 			DRM_DEV_ERROR(dev, "fail to create work queue\n");
 			ret = -ENOMEM;
-- 
2.51.1

