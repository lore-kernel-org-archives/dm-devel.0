Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08E2EB844
	for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 13:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757768550; cv=none; b=Fo0E6EoJZemsi7ZWyQ5mpo22HfoOdn/6sEJYsmOUXoxiE4F2y2/TPLVkaZRr4myPYEJAPGe1XU2Lux6uK48VWoDFLLxS2+jh2nYqFwlxp/Y/rFnuj4SdDR06xgVhgyVOMphhHtqBwPf9Hts8ba9+ySCLUCvuT3B3HPfwdnPqo7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757768550; c=relaxed/simple;
	bh=+YwBCDMHfW76wx9MAg+Griq8J/yH7OjY+7p7S0dJ0VY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O44z6JSiNKEAsarg05hYjYtX+mZSylpDN3qUICoUFT+qkx7oNMOEdPS2w3/gXK6NQT21PLuc9hozfyoQwYBVbrGQZBb+sVel7KbTJhUGiYik+g8IZNS7ooD3UPch8OqK68DuTQjYXljki/gU64f9GjjOIOf4gRTjgLmLbgF9k4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cQF/CqRD; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cQF/CqRD"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45de4ebe79eso4119785e9.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 06:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757768547; x=1758373347; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9z1e3bLd5rIQFxR6N4eoH2aUokSnikVaSoff5sLfYUI=;
        b=cQF/CqRD2FHK6oii/WFyTOUUEH0zkFRAaroVm5GTWTVzNRF1yxfvFZpw8VIqntF2VE
         gpmQwhYwxK3RJlvJTKWi04UKr6ZIog0+4zspQNMoWRhnjzbttKBTUyKuWLTw8gsY+3ZG
         IdLVwNrZIwJtDUqRkpqf8TjpA9McmZYjRhELYI1kWoY2Pg89MgUsXb+zTOjvn69bJkXJ
         iEFFR1qlyq697WXAKVkBsDh/8bbU+AMIoZuqC/xxVk3m6l2LPCnCLxZpcMoo3zfcpbbg
         8et6OfmKlBP9yXMeacSw+3Xopzl8ePgTYFCzFKL3DCMIpsJM/IMo0LaXzehcsHeqqr4r
         jkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757768547; x=1758373347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9z1e3bLd5rIQFxR6N4eoH2aUokSnikVaSoff5sLfYUI=;
        b=q5Rmsli1g1+BVYjJ9/+GA/BibT+RvwgXe4NQs+MPqE4PIIlqgSU8TrQ+ZBR8RyJ7RT
         zuY3B4txuVM0QMwQEadb56kWvoqpH84/aTw3XuoJR9SWs2f4dzgWqW6geL5072OoX8qW
         98C96jnjZesL5/+Xy0dF1taVYcZDldp4xwKpGJw+MGZrFmUWI/npDT/6Uc7uwXJ/Hk4M
         BUy8i2h2qlKm27NExhr+J0MCZsbdhJhNA1ZcCgxxtcrOHnJRkel1/5Qc/hG0Vq8IFWD9
         A55pdlNeJRKdTv7U+ikKQc/1D4gKuE9UD8EX6q7vvRO9SWmAim/xXKBTa1F46r4MGB41
         D8LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXUSjBw4yxDNTs+T5HizJls+gUTzkhQnKQ0pDy4XcI1YgXuBbVvEaAM5hcui4D2iptGM1xMux11A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd/LrLatCdj6yDUpWLsgnqYU6VCGqGQLWDIA2In/JwOTpwNunb
	+SqQ2xMlVJZNNxB/Zrqc/W1l5JCTUnJBXnaAvRZt76idt8w/w4O5yUs=
X-Gm-Gg: ASbGncuAwtYU29mC/fTl+HO93PydGXOv0f54bzne5V8XsxafD+LRIDOdUbZ1BEP+9wg
	4r3DIT5m+gTOY08FnT/C6laLiY7Dp3oNfHD8ctW4PmwAXLqjm7eshgBri25NCd3wbBBsafmzCK8
	mvfsKlwXCrOVgBartlHShmntm0CANLR9d03Q0BXTbliwEJiU/aN2Sja5BkCD2MInJUbiVogKHi6
	nBQJh85/0z0wVu1NdE1a1sIXCFnYe85spi5ogI/iwNUwP3uidG/yANZllSI6uTr/+gv0TydlZXI
	AjcVqhzgszFxwaewCyB28lNqh87yyNOcf1Df9sY8DPkrCAUoyEV1yei0K5kPjKJnYwPznUHQ0Uh
	6iDuBfid+mI6YqWiJYu92eEPDJRngP9MghxyRIInKQkbTMSmRlLWNPg4AOcWI5fiIcBpCq1Y=
X-Google-Smtp-Source: AGHT+IHvWx5DL1hSXbUKMcvdUh8mwK1mywM2bjTA9AJk2ntMVco59K9H+ZvQAsBuH5d0OQd09refWw==
X-Received: by 2002:a05:600c:8b86:b0:45d:d57b:69c0 with SMTP id 5b1f17b1804b1-45f21201b02mr26849415e9.5.1757768546244;
        Sat, 13 Sep 2025 06:02:26 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7d9844d24sm4421859f8f.46.2025.09.13.06.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 06:02:25 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Steven Schremmer <Steve.Schremmer@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/4] multipath-tools: add new NVMe devices to hwtable
Date: Sat, 13 Sep 2025 15:02:12 +0200
Message-ID: <20250913130221.35073-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Even if they work with the generic NVME config. It is convenient to have
them as an independent config to tweak their options, compare dm-multipath
against the NVMe subsystem, ...

Only two of them are missing ("Fujitsu ETERNUS AB/HB Series" and "NetApp E-Series")
as requested by its vendor: https://marc.info/?t=165256933900004

Xose Vazquez Perez (4):
 multipath-tools: remove checker from Huawei OceanStor NVMe
 multipath-tools: add HITACHI VSP NVMe to hwtable
 multipath-tools: add Infinidat InfiniBox NVMe to hwtable
 multipath-tools: add VASTData Block Subsystem NVMe to hwtable

 libmultipath/hwtable.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

Cc: Steven Schremmer <Steve.Schremmer@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.51.0

