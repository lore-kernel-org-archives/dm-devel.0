Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68D82D8DAA
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 19:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533346; cv=none; b=m0e8Ne1hg0U8DHtjPii4vktopG7qyZRGz/IrCsKrMAnjqC/AL3Qwslgv8hCucSsUzVLPLS1MBbbyI9KyhO4VZmHmdaBGQsFL3AWXujVh3rh03zC3O47Rwwahc7P1JxiTnrRSJabRdCywfncnws2/kDvm4ehEaxKutFSYkA3b/GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533346; c=relaxed/simple;
	bh=ME80zHgOaAVwkx4tjj9Xww+oOgwGcuaB5do5GjZA6pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud9WCyia+88w8y1Ha6+Xt/7a2ySGasYuoYh883PioIy32hq4JCLuO3FqTdO5t3k7FUT529j9+ggfeHinPocFdn8HMC7EcuVbU9nc83yAt43JLxEKBjhDCBFVXDqExQxBYSArZQL+Bfn1goK16H2s57Q4vXHJ+P/5ZsD7Yqm4zvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=We4QugTj; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="We4QugTj"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45dec4289f0so1671705e9.3
        for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 12:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757533343; x=1758138143; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eorexIkUM3X9pJjoHXtxVsQXMCaesHbb1QaHvf0aKVI=;
        b=We4QugTj46j5+HDKLj7uVp0mYZgKDYJMxZyE5otPSk8ThX8JieFktbqB7thWgeojxE
         8i7FzhXWFoTDwoBLqLZ4Gwp4k66rI+oJp7vc0CNDefvYrOPrbFqnLxsxtuZ1oz1Wth9n
         gH2was/ZIo64RgrP65fdJ+tQw5craMgTgAm6ojkKqy1givdMEdwbocvLpQsF5VqxMDaD
         ANKmc1AZjpYE0gO3uuHzZ1UEhV95ZTEndx/ZYWModv9kxGb9LIvgo+noJyOd8W0o8g/J
         lj29RIBXp6yM7Mbx05zWFrkYQc2/TEvZn8875OcobiO+sjeithkR11rRDhcYrsN3zlcA
         nkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757533343; x=1758138143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eorexIkUM3X9pJjoHXtxVsQXMCaesHbb1QaHvf0aKVI=;
        b=mhyvkNxA1sUFNH9Mej0qv0vWYg6Yc+GktVmy/vHKmyXu31mIrTx6fYgV0SqITwRPqe
         cZtZXTd9NA1W2RVVtZalsS4TMRoJq98o07iC+XOxd+Q5HbDWllI7pX2Lo2KyJfO5fZ79
         L6yUXF9GNi95/oXcSTGsiak03u1E5v0vf8iXkNds36kWRe3OKc2dIsWVSmyoZnWpM6lV
         jqtq1v7uLg1YR+do18h2/AGicBpvVjXZRzlaTVpDm7Ym3fOEnSVxzSrfJPdLJJsr9r22
         5A6XlSB1OwR2uPu/9hx705eVbnZ0DZAmOj2ftN5NX89l4x5P58GQR0lsEeGOyqeFtl9w
         7iGg==
X-Forwarded-Encrypted: i=1; AJvYcCVZDBZgNPuFlaK6AQu+jbyL1mqpi+2VNrS+FoDNCa5z9YkM3BS6Uhzj9W/9GWdbKj8UdA8EGOPI7w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxCalRPO3SI2szz9JchWOeVrOdhHzXOwrnywpZuTEU/kQod6QCk
	DYHfLKb1J9zzyzmZg9Vbujo4CiUpMP67Dr0pQX78hMV899GaY6++uN4=
X-Gm-Gg: ASbGncvizugbShmKsRyIwjgGoHF4+e//fDpcx1JrRIoy64Xe/ggMkJ5TUwYP+rycUO7
	DTvvrtQJMOXG7wB6X94F4CjXmlRBFLEkp/uNWf1LtK8PGo29L6L8EG+pkjZWeppJXIiTjI6dRy+
	t/sDy7Bt3x/9cmcuVchWs6tu/WEJ7C0JtFYn6htFuUWAekNPIAzH3UCiM53Cim87bHVYg2xQo67
	y6+8UZMl1+VHCqh1ijbq/brr1oYk5hNmQ2LTa8wuDh2SahgyHJtXA31uInG/IAPhjuPkBcRg1G3
	iYPa6BMksXVZWBsQno8M7/mV4/sKWRRTS5hkXjY0/zLrrFT94610V5o19oO/8z4b2dHf7MLccX5
	azwEm9OSrM3kd+NvOeF9PrBuWq3YYMNo+zuVXnscbP8m2P6kf2X85ag2q4iBqTIrOV14cs38=
X-Google-Smtp-Source: AGHT+IHTgld25PKNSxA24FN0t8rONWVAn5jDpkub37uNhkKUmQkcFEQvvkeHHIH9Ahlrijaa+4eFQg==
X-Received: by 2002:a5d:5f96:0:b0:3c9:774f:6484 with SMTP id ffacd0b85a97d-3e642027566mr6794278f8f.5.1757533342883;
        Wed, 10 Sep 2025 12:42:22 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df81c72e0sm44719525e9.3.2025.09.10.12.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 12:42:21 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 3/3] multipath-tools: add QSAN to hwtable
Date: Wed, 10 Sep 2025 21:41:59 +0200
Message-ID: <20250910194205.145919-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910194205.145919-1-xose.vazquez@gmail.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Source #13/15: https://www.qsan.com/data/dl_files/qs_wp_iSCSI-MPIO-in-Linux%20(en).pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 80e76fed..d9723f87 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1393,6 +1393,18 @@ static struct hwentry default_hw[] = {
 		.flush_on_last_del = FLUSH_ALWAYS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
+	/*
+	 * QSAN
+	 */
+	{
+		// XF / XCubeFAS / XCubeSAN / XN / XCubeNXT Series
+		.vendor        = "^Qsan",
+		.product       = ".*",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+		.prio_args     = "exclusive_pref_bit",
+	},
 	/*
 	 * EOL
 	 */
-- 
2.51.0

