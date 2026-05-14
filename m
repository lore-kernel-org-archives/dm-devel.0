Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD3C305E1F
	for <dm-devel@lists.linux.dev>; Thu, 14 May 2026 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770894; cv=none; b=Vv9LWNfXzl9lcaCjJV7TReRmasbW68Ld6TxoIlg0XqpBEMB8BOH19ZAwq1vQESH5ez4A9LkoJjyN3JbR8aRjPaexO9Wdodu16+qGC6iqZDZqrte6oPWgjwUf3Wik36gEPdyeXbhFQFvFPucKSQIyG2KwXnTUIwTKM2iE8aaQOJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770894; c=relaxed/simple;
	bh=wYW9g5vK1nyNe6v4Fuf3ppadgNuotQCNavcLJHVI5S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U5t6z5Meg2bNcKdAGc9O7vbT6WXnIBZZV4VNCuxveGLCu7V+RzcMkRBFQt7sGyohQ3oNqUcmlRWR01di3Mal3fKr/CPSAnzJurSuTn6qFjaMGGP6q9pp3f4ueBG5By++UGbRtLcTkc2TFw+uAGHUJDOa7XbbXnnzUxTQKua3V6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=evwLvh1M; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="evwLvh1M"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so95733995e9.0
        for <dm-devel@lists.linux.dev>; Thu, 14 May 2026 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778770891; x=1779375691; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=diuAufbHkvbjLvqNxdhhXWPXrjL35cOU+2nrbhSglC4=;
        b=evwLvh1MsBHhx3OeJsNzJhPWq8n68V/Mb0OHAvRRQ4GH5seZtPec5FRRnDquPNCrqN
         onc88ITvYRgOVTwdn4f4+6+C4KMjgWcnSQV2uA3Ud4ZFPJix7UCZC/rb2N3A5vL/73vJ
         jXW6Zvcv13Rl39X2/hz4lcDg4oPLgjUawlXax0Ow63KWMwOyLmvfEK4hOsc0DIBTENj2
         j99wpljBLaycgFES6k2+xb3gVI22Z5QAlEA59kG0p7rb1mjG0arQhmtfJrRwOZEuEyki
         68i49MLkVSaEtDrZBKCEFCw+D8E6lUdDEYjYd3viz2x8onYrCDbpzG6NUt1KsQ412aqP
         Q4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778770891; x=1779375691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diuAufbHkvbjLvqNxdhhXWPXrjL35cOU+2nrbhSglC4=;
        b=Sfnm49vElORUuKPnSRmNOvAYbpxxCFYyGSFX26uHwzJfnjiYXdCCQZ0fzuFXeQFDI6
         eb+71526xKvXp4E9ip4DxEj7uIRmOyzQixrWocZ1zdRDn2nUXIL6zk3qcbZ5TJZi8LPd
         FPY7yS/gTvCTin2AxPEiBqqsfQLwhynaMEBoGCBen6dJqUoBm44DIruGZJQd3sa1iYx1
         FyRAx8/vFIEKsG/jWadNMO3W5u0dI12iF6N94ALHQChO3eblv8/kTu7kKfm9k5lCYg4x
         XxljAiWMWaI2xtwM45XCdBUOkLkM+e3d1QVVJ3H2aAC6eagNZcgGtoz6JYV6IHGCtzM4
         u3RA==
X-Forwarded-Encrypted: i=1; AFNElJ8yOJR/ptSBjSewhWbtAGoO7tMEfwJfVUOZ78zvIdl2A2/ioCPcs5aC+FU+q9mTDswvf7cxeR9+4g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/y8I7xTEFp+bDNuGCR2ZCnC3M/okAJhBs+Id82lvu/fC+75FG
	Y1i3AlOscuTa26Y3u/EiVfdsEG0t5wYUjPlsHdlWlH/yAMBog7OtsZEqPRQISxoQV91pNpBCjIx
	g8tY5Okw=
X-Gm-Gg: Acq92OGcTTqhvKDzD7JXTctRPZZxICtvLiIcvOi5fV0DoxCfen4JyP+MfvOBmlVP9pm
	Gi2+ZlOVzFmRNDmYUPTiWmwKKy8VajQDiqgaZCkGVwiI/a5ZUYrot9SHfCqFLUBd4o68Y3rH+ey
	6sV1n5GN/4MPjYWH+ZoMezYNjUd+lOxIkwcF2pZmNsKCue0Rbrz8gBA6R1rW/9ZXF3H5fDLPjhU
	O1aiiJgFJcj+yVGWD6B6Z81ukKirB79Ov6jwzd3uKzdI1Lq3thgThCtdHDgZ+b6D7GEis0OXi41
	sDUgFsJX+kYvBnP0qqylqRjdSumyeaNcPMKYsFZxCfyOyGLTZkUBil/PhcF/yNzPMz/2o9d1BzY
	H7y8527/NMoKQ34bkxDeQZzC05SAy4KSuWEyXlA1lk9yuVbnZMkJWIgUSMldSDt1mTr4/9CUTgq
	HJ0MW50wdOln1rTEodczeHqtdPxt3KkadP/xQXC2DusKUoiu0=
X-Received: by 2002:a05:600c:45cd:b0:489:1ff1:74d3 with SMTP id 5b1f17b1804b1-48fc9a3abcdmr123117235e9.20.1778770891168;
        Thu, 14 May 2026 08:01:31 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767ee0sm7153523f8f.1.2026.05.14.08.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 08:01:30 -0700 (PDT)
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
Subject: [PATCH v2] drm/bridge: anx7625: Add WQ_PERCPU add to alloc_workqueue
Date: Thu, 14 May 2026 17:01:22 +0200
Message-ID: <20260514150122.357883-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU. For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
Changes in v2:
- Improved commit log

- Rebased on v7.1-rc3

Link to v1: https://lore.kernel.org/all/20251107114318.163015-1-marco.crivellari@suse.com/

 drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 54b02242d6db..8c3154817896 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2849,7 +2849,8 @@ static int anx7625_i2c_probe(struct i2c_client *client)
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
2.54.0

