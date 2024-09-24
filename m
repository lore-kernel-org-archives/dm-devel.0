Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4E18953E
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 23:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727222132; cv=none; b=aBdy75doJvFGjzARHrX5lkItyPAIO6aSJiXMETjJmG63tsiWeepAi5pWCfqtTTvsZqFdcy1X5bVs0HxKgKcyu2oIU9hZkYIwQFnLZYv7OO6P70ikNf+1PKdgW3hHXo7g7/UELUi0SWiQ4oCqWGGML1aOYB2/WdZBNCdHUt2+KIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727222132; c=relaxed/simple;
	bh=MRgaVgxUkqIT4yn8DK1jnYAaqCTbG8HVnzvFLPMbOPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CG1pS+hjm/EsDEkRpe5neSzj9tedkDh0SCFKQcxGLCuvTku3GlF6y3uizcCtXVBiatFMPbgkaBD5dOkbgVWejpvhh2eh+nyzZHXrufRIYTBLKG6gJnYK7WTczEN3J1pnz4714tH4IKjU64D76QszTH7ppJvJ3fKGGt/9JWvTWXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tb1QsU5S; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tb1QsU5S"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cbadbefe1so8376465e9.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727222128; x=1727826928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3xtUOCC3HYC8gb7eixuUnJ2MkEwcfPhcq2/X+pVOuKc=;
        b=Tb1QsU5SLXpkzUAgnei0Bp6syNnW+7RJYIdRt59jO09wv6a3i3nSRfRbyaD3LlwZY7
         bXyRT3hkHN/ib0HxI62UFbZvmpyaWtEIBT6Qz6B4NbNfeZuyGuJrsEXP7Muv17AR6EKy
         1qhZmx2OMDg6eZVCHwrkQjkXmNknwLqGnmRRGmVKstRrZplHqdhfNzVfoOGwCtWERcD2
         Wc3iB8oOoKOqIpvWohXnp51Se2O5ZNSgX7tbjQ9q935uaYb5PsnMRKdF/T0EGC06teLX
         8eBfROP6iHmufwstciDqK0H9UhiQTuS1XkO7TpNKJyxcnGRQiT0g8vLXze4nRDxPUEJs
         /U8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727222128; x=1727826928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3xtUOCC3HYC8gb7eixuUnJ2MkEwcfPhcq2/X+pVOuKc=;
        b=aKVkIylru1bLpCBVQAC+H1jm9DWZznps/RfkFD+MSO5ZFU4uBBBjgk1Z5NZyY9wEcz
         M4Q/8KrbkKsxAi/OPjQCwhd5o3IX5tDEhTq88HxLyaVeftus6JNGMQS4UOrp/GhlvOcd
         N0C8glRfRzapXXMr9Ta6cFEqAJ/tiU7Q/Bt62iQT6o4wy2wwn6bNY4JD7X1SSFeK4Kfg
         atZlrqPEEgcIgPfAgiKO35qWWR57PTXftdKdnz6tp6lgH2WmfwFVPrk5QT4kgAvCBeTs
         cn2mdY+9m5EBvbb3NUJHsQess3WdYnh1rFjJLTYs9VdWK6rg8KWBsRn9njFMgWupLTvo
         +D3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfPovFLa0IejnkPpx54HsscdBHLVGQI32NjDzQW5gwRCTRRMTYFMX1qZgKe6xKoK1ZJRZ67ltwwg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzUuDaddGbqGHMVDG5ad+iJ+TdnysHDHbWtMFzVzZ8X73q6hsF
	puU7zS9nXFLhPy//4Jn2aqdZwCtRBDpX4IGYhMQb3c9AVK5Mo8o=
X-Google-Smtp-Source: AGHT+IEY8ggQoF7qV9M+wg0JLmQ1T1h+pEQmwjuijrt9zHi/X9rk7ReYajjkpky+rzWdRjeYOdUJ0g==
X-Received: by 2002:a05:600c:1d25:b0:42c:d084:ed69 with SMTP id 5b1f17b1804b1-42e96145556mr2011915e9.4.1727222127910;
        Tue, 24 Sep 2024 16:55:27 -0700 (PDT)
Received: from localhost (62.red-81-44-152.dynamicip.rima-tde.net. [81.44.152.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e96a165dasm2158615e9.31.2024.09.24.16.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 16:55:27 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: hwtable housekeeping
Date: Wed, 25 Sep 2024 01:55:22 +0200
Message-ID: <20240924235523.56471-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Update some descriptions. And limit the Dorado regex,
because "Dorado "is used as a generic brand by Huawei.

=====================    
HUASY   Dorado2100
HUAWEI  Dorado2100
HUAWEI  Dorado2100 G2
HUASY   Dorado5100
HUAWEI  Dorado5100
=====================    

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c539a9b5..01d50303 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -819,7 +819,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/*
-		 * ONTAP FAS/AFF Series
+		 * ONTAP FAS/AFF/ASA Series
 		 *
 		 * Maintainer: Martin George <marting@netapp.com>
 		 */
@@ -1099,7 +1099,7 @@ static struct hwentry default_hw[] = {
 	 * Pure Storage
 	 */
 	{
-		/* FlashArray */
+		/* FlashArray family */
 		.vendor        = "PURE",
 		.product       = "FlashArray",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1120,15 +1120,15 @@ static struct hwentry default_hw[] = {
 	 * Huawei
 	 */
 	{
-		/* All, except OceanStor V3-V6 */
+		/* Older than OceanStor V3 */
 		.vendor        = "^(HUAWEI|HUASY|HS)",
-		.product       = "^(Dorado|HVS8|S[23568]|V1[568]|VIS6000)",
+		.product       = "^(Dorado[25]|HVS8|S[23568]|V1[568]|VIS6000)",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 15,
 	},
 	{
-		/* OceanStor V3-V6 */
+		/* OceanStor V3 or better */
 		.vendor        = "^(HUAWEI|AnyStor|Marstor|NETPOSA|SanM|SUGON|UDsafe)",
 		.product       = "XSG1",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.46.1

