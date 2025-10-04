Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE73019F111
	for <dm-devel@lists.linux.dev>; Sat,  4 Oct 2025 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759611687; cv=none; b=eQwoDP+VWw6SC1D+UfVlshmeFyAHkP5yW470zkqSNWggXcBMWodaCGuTrPjXu1SZwqe6TME80eStOem6qigguIO5e7TOgfGBsIEkwKtKSK8dxOEpIZTyvlBHKJR5UH1Lpy/7hs/NmasloTw6EQD1ya7/FRhrSE+ddYlKrlOyptU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759611687; c=relaxed/simple;
	bh=WBHUGP/0nJSbi7W8noPOsrBHUFG3SirhTw27vT4/+KE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p2YS7hCOsTUOuIqeV2tflSEv6/wuQZX3hf5Barpfi1MDjPj8OTKm11SVIl/6ZxDGCllMIA+ZweRtCkCiRQfAc80x/b/0GK7bgLDrChc8d0e6bno9RzSafb/StE5hkmkBV8jS/JbiL8HjY2WjZuHBu3G2c5vPr0kJxAl8Fy/r0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/Y3bsPW; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/Y3bsPW"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e38bd65faso4372435e9.2
        for <dm-devel@lists.linux.dev>; Sat, 04 Oct 2025 14:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759611684; x=1760216484; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WXv5MG57QMcG7ZB0A1pyoBhV+ekdeogn1nKmThTS0Lg=;
        b=T/Y3bsPW2nOMi9skuQEB0mD71nGE2IAlmaLTmrIMOR6KvqJdu5d7dusbhd0cPVqKED
         zozfQCQdZjjJoDYoqeDw+F9ozZitU8yiQ32QB9tBL1r8HebMm1C9Tenap9rnIy5Nymiv
         Bc1xOnTrhFdXrpjivMf1szR9ryv7mnhugAcnrSOfv0V0mPc373VjF4OiWMnwlG/dKc19
         gWwXUNTzCUmyC8wkaUv5J3/Lb96zNHDZbNBCwSj6Cirp7zwR1EHTbzBOpq2uHGOcuxNW
         l9NPQMOy3NB913mXPUo2cGhpdH6J2sEky/qNXpHmbqQBDB6ha9RoHduYFmnLCSELEXUa
         5KDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759611684; x=1760216484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXv5MG57QMcG7ZB0A1pyoBhV+ekdeogn1nKmThTS0Lg=;
        b=KKumdcC64Zaeffvpj9IQzzEVQAOi4XLe/F4ulQypo0omxFEtDIJJvzizxk62w7MqrC
         J6IE2ct0/rce9Zswvxwi7CsjuvFtdw4/VzBMaHkPLkeLWHrXWHS/y2/OaFiBwv8H5cxz
         L5iaE8En2/JFwkHmhcOVEITAAM2h0JzrfZgG19XQbuxcWgqgKs7lm1UU5ZKACwDBnGW8
         4pvX+bibnq3/PjocmS4SurWCzU4ZXNYc1pdXaaQlNmQkvdR3PF6krOjJrvbtj6An/hSW
         0N/V8DbBPkt1U3YYDctW4tIxNbk+zWEv/G5t7x/6QfFEQZVEMGyivrZBMzJqJrIp9L6m
         hWTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIJPk2GFRK1WRKnQx5Kw13PYWd3g1yXzCCdVsj3MtbfLYQRz606pIluyZlgzOROntfA28wN0cAbQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzFMbQgq3K7eBQlxl7uOTgTEIBrB4ZOnHccycA7TjyHArEHQPLC
	4dtMfVAnXn9T7SoP14Gi9QT44RiNrQtzuyrf0vl7VIgS5Kb5vGZ+cyI=
X-Gm-Gg: ASbGncvyLGMyvI9nFzmUsV52NwIXfDhjcV/wCjRFku0QYbVR/3UVC51ZWvuEdlpI41z
	YXhV/k8OpeDvjaCqVLOIZzZDOA3I27LOI8ACBzL+fv5kiAplRzpCVBLBZ+fULzAUuZJh4DemNZN
	QftC1Z9SLzE4k7mqj+NaDqwY5kLSA1Vet+RtkKST4RKW/O/xujBpWAt1fYGhxitxVeVRhPRVKRR
	U+/71ht0tKccJNjk9hUxiAL0AxRMTG4uUJYdKc8qtrBQsgn3QlA3taTq5HF9LZyjuyD5IM/COIX
	ZHK9xWpNj5DObYsGPJk/k6fsHXH0d29CbRd6IAU11PhFMkBXI12o9paeQPSgZnEYPjQKVKxR5il
	Jq7RzNw9oL93T+iujc6FzoHnG6dsX8X9OGhW1KjaXJYu9DxXER/pFQoSK52DCxJZhZERYVe6B9S
	uTz0igaWmTSO7Nk3/L/DCs5M8O2sScPjT8J/vk
X-Google-Smtp-Source: AGHT+IFg8L2A1SGlXjdzm9t+iKrqbdIbWFsX9VoIueABTgUvoQVIIWmyMVoYdO6tz0lTNv3R3QgaAw==
X-Received: by 2002:a05:6000:381:b0:3f0:44e3:a70e with SMTP id ffacd0b85a97d-425671c74ffmr2627835f8f.11.1759611683687;
        Sat, 04 Oct 2025 14:01:23 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6daasm13923914f8f.7.2025.10.04.14.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 14:01:23 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 1/3] multipath-tools: add Acronis Cyber Infrastructure to hwtable
Date: Sat,  4 Oct 2025 23:01:22 +0200
Message-ID: <20251004210122.109288-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Sources:
https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructure_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux.html
https://docs.virtuozzo.com/pdf/virtuozzo_hybrid_infrastructure_6_2_users_guide.pdf

v2: replace -FAILBACK_FOLLOWOVER with -FAILBACK_IMMEDIATE

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1a78c36d..f8bbf02d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1371,6 +1371,21 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.no_path_retry = 30,
 	},
+	/*
+	 * Acronis
+	 */
+	{
+		// Cyber Infrastructure
+		.vendor        = "VSTORAGE",
+		.product       = "VSTOR-DISK",
+		.prio_name     = PRIO_ALUA,
+		.pgpolicy      = GROUP_BY_NODE_NAME,
+		.detect_prio   = DETECT_PRIO_OFF,
+		.features      = "2 pg_init_retries 50",
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.flush_on_last_del = FLUSH_ALWAYS,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.51.0

