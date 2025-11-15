Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC7614A60C
	for <dm-devel@lists.linux.dev>; Sat, 15 Nov 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763218216; cv=none; b=OHTE4xVqFUoEM8eSkqhEV3ljzUj8pq9OyC5/c883kTtjl3K1+F9FUOCax+Nh8B1nzDuLsKsV/etwcdaCGhQRfqIgruW/wNdEFOxPt7fx3UCumJD3QLHS5EYy0/867wELs6FD19QUWLbtyluHsYU8JlIt2bPGfw3MTDgA4vp/aOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763218216; c=relaxed/simple;
	bh=13A3T1fB/CHqFDIg7ZtoJhZoNfQ7i/sk+AMaQJTB2RU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=am2i+0clIPVO+FwBoLPWs+Ky1ch61U2DnVUgZn4IMid66Pld5h+4JJQVG61ZHBJxdECPfsVoomzNYjPCufLs2xR5aZ+At0qqql7+5EQjHQxwpu6ZRbar5cm6IhwA40oGmCOTKxagDlIWkFLYu7yioVIzctKCL9Tig0evqfzfOhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EBfyRyqf; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EBfyRyqf"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4779cd413b4so337565e9.2
        for <dm-devel@lists.linux.dev>; Sat, 15 Nov 2025 06:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763218213; x=1763823013; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+f2J98XjLVTlxUCnNogqe0eEc0sQ48Q+UtUL70XUoT4=;
        b=EBfyRyqf7JzUYm8oAWhUGfo1z4nZ0ubIDxd8g+l/DV4YYfQGCxtyW4vhqQmR7K2dEV
         IOpR+KIvfq7KXZOhKvlVJlHbqR2Ok5+vyIb190ViM/9ZB2tzubbv2R42qE8TZYqShIST
         BrX6vZ00zlC1OeLceNNGNvxIx/dkohN0Lo4CpY39e5vNUJi3RfaQPmC4WwsS5AS+pryV
         KhHQuj8jhpCMF2fdHi52VQDs56wIvO7j95CwxD9qucWUexEmfgQKNxuVLizCgdySC8iq
         zuudHgUgClBcdDxWlkIBrVwHDmUsnr12MQ52Ty4Nz0lZGnriHXHkzhDZAXj8OARQLUjN
         BT4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763218213; x=1763823013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+f2J98XjLVTlxUCnNogqe0eEc0sQ48Q+UtUL70XUoT4=;
        b=u6PG+2XE/3OGBHmx0gvF+pIYEQor9xdPiKvpiHREZDSFsxiGxPKD2c3xG4LcCJPWTb
         z8APXquzy8MDOf8L4DrKnMC1UEqjwfdDKaeigSFm9GC5nghyJuxSH8MSJXfsqMXCUtMo
         P4Hpgf6MYE3Adw/LfZOPkPsfygUauqgqQ4FW7oXIWELk96n1KIHc0CY8Vj8HZOJ3RZ87
         Q4kAa+gkKOklbAiHPKkiHnlTm8y13Etax3osFpjbtloSBttVF4kp0T0UUcGZuF8PEsHw
         Jgh+fSVdYj/PAL0pNWGiY3ViO+tlJAFCA1+yxwysy1+ioKiEjfCBjtVOi/aLhPZ2uCcZ
         8wfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD/7nddkfO5aHkWOCBUs1hY821/xxukP3fevqx4AviQFgbILN4GXSECxP6lhPPHQ5pnj7+QV8wIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHN3YhyTCdaBvf/Ro7y2ntqtmP5Tg/VHx3eTvrkRa4sZvrpwdL
	fsa+y486kl5HBcja4tY900SzPpnPrInZSKIGUKHqvxIu2lAGrlDf38w=
X-Gm-Gg: ASbGnctKlXa6FIuVpPekvLEZpXdUE0lXCeyKPkM1HhNGnRa2NXdxhj47yMQjrHI98D7
	e0WXRNkkjIMU8CtPvnPDjnpbOoN3yhjCQGDp5i2oteZHqsT4mDSUGdUqhU9k5Wrr/MU32KItAGq
	OmVKKm2UulUzzwO9J1XKy/JQL39LBpBMRp4jSzAYpKwQWIKYBP5DX6uy+G0NDGJgmqnM1mH/h2k
	wgKM+glbqnXj0aI6964hJFYAXA1u74OBtiVrke5C58nCmkihA8gax+K5eF+fIpBLrlofj8Rx4qD
	olFyH93ZRFwfukfCj0XxGPd73MC50vUXzcyTIf34QqVHWH3SvRJiEDk/mg/NLImKRuTvm3IGRfe
	Dwa6XmFFXX02oA0YdnAAuKBjGAnG0z8hWVfMaCAq4rs0TK+x4WCfRNRm0334mSygcDsKnRjKCy4
	f0qma+ukcTzs0uhnyr4FeHDx7joIWMwO28eoBAvQ==
X-Google-Smtp-Source: AGHT+IEms82mcw0T5rP0G7xmFOsrfJEoqRkEXWqavmeG0jqD+TUSFEJ+ETfBpsLF21aVfosnsE45vg==
X-Received: by 2002:a05:6000:2c05:b0:42b:4219:268 with SMTP id ffacd0b85a97d-42b593456d1mr3387383f8f.4.1763218212450;
        Sat, 15 Nov 2025 06:50:12 -0800 (PST)
Received: from localhost (39.red-80-39-34.staticip.rima-tde.net. [80.39.34.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f206e2sm16355968f8f.41.2025.11.15.06.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 06:50:11 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add Seagate Exos and Nytro series to hwtable
Date: Sat, 15 Nov 2025 15:50:10 +0100
Message-ID: <20251115145010.470404-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Config from, #102:
https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/support-content/raid-storage-systems/corvault/_shared/files/205042000-01-B_CORVAULT_SMG.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 92523042..2734b78e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1326,6 +1326,15 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
+	{
+		// Exos / Nytro series
+		.vendor        = "SEAGATE",
+		.product       = "^[456]",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * AccelStor
 	 */
-- 
2.51.1

