Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6032D9EF9
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 19:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533341; cv=none; b=TIbdnCfS4oM3mQx1hRVJmgBJkCnqiJNicHd6HaHKGbiUelu9qXaVk0qn4Ht+S5rPdaFqOy6S97wHQMiqMC1KMbDqBx2e43wckNsRrqRUVIsfcWh97KhnbcrXcI23IP6Gc3re99ALGwAz/qoQB1XCD7M+QcMoTOc3ZJDslLi4gf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533341; c=relaxed/simple;
	bh=P1+LsYh9kg5JV83Vk+nh9n7T88gvclihxpUWh5JKLlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTpYvMRXLoBRtkT2yAklXH2SAaEh9LzIv4P5JzCAjy8Lqj+rJKB1ebJkLxSAYsdYz5lj6b0aGTVk2+KrC9B88elJ2aEl6zqPMjHp2Zk3aBMOYlHDHr0p02kU5Ldk6PWKFtvs7qWSUCcux2+izADB0KQNolWR94GuQFoAGqd7tGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2yLCE8s; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2yLCE8s"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45ddfe0b66dso7484925e9.3
        for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 12:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757533338; x=1758138138; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJufIip+hN8q0GcOowLJA6+O9HHAh6rp6slyBmvmTdc=;
        b=U2yLCE8sF/xjkXC6PZVbGwW2lyxnYnizY4O5B/Rain9f1zx9OkIgNUtcDmc+D/2oRB
         DiP3nOCUcd7GvOsEDNTRWRl88L8EIf0zIYTYgvZFtKG5HG4rFxx7o0qIwA5FDSy5TCrY
         NTDfGFk2NLA5ZgXZAYsySdxfMTRnOU942qS3ZKZKZW/Zkjd3BPJIFiNypVlM+/1Jq8IC
         HWGsrk62pDb546v/FLxAqkX9HptZE1jimozHa4R4VwFbdy4Nw0E+wvYXEFBu/qFr1FB1
         W2tu6pNHKj4G/3lAZrSKDx0W84PFY2Z+t8Cw3Vq1/hvf/xuGgkBnPBwNBx/xH+SaQuli
         OGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757533338; x=1758138138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJufIip+hN8q0GcOowLJA6+O9HHAh6rp6slyBmvmTdc=;
        b=rWZjii5PHBZ/vADEUsoLE1b1VwsOKvTtf+zTcTwW/vRP1BryI1JXdXfL6mMc3ns0r3
         B+KnX1tT5NkWFVXt2UXcsvmoc7wUM4fiC0MFMCvCpWxfbF0AO1yt/cWw9wcAAumuZqXL
         21RHSDwjL63RfOy681AsWytq/AaHtFOQKfMtGfOrvyx9i7kgtHUYbuqk4okGNJbrJ0jo
         NqsdD19wE6hsXHenqCGJY3QGHxQRQO3J4SU/pd+sNi7g/CfaEqiFKuz7OuiWxQcMrsAC
         exG+N6tLJ0fGsYJwyFNnbLrSnpbCOY1sgU4e6NudRJmbFINJb2oX7LVa11EPGnGrd2e4
         BZcA==
X-Forwarded-Encrypted: i=1; AJvYcCVOiN2cCcRff1iy8gr6DwSE46NH8+i8n42AUA2jeYOPWIIQaWlJTqmp4MqWUW9D4wm+N96KvFx0LA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRUNEJRyVjUUPb7wQL+L0d2jFblMpby89qEWD5iaBB2ff4P3ei
	eDo7hIPH/j7ie2MhtoSKSEBpxZqeQ1LxXvQqBYB4rIHHSJFDwDClUAQ=
X-Gm-Gg: ASbGncvAJSWd4OgFoeVEksYJqARtkurZF/w1j2LsAPR49cRirprgF7PS3ajn9pArpBX
	5EX43VssYTm23a/1wcFeaS8vnEtq5/8Z35iTTwO6DSXAzm+eKv/Qr33N4z/11/ouKU/sHrrzt1u
	q/VZRn3UsehUK7WkLpZfCg8GjVr3ydkAQHJe4ZJtC78eJa8lZxW5Rc3DbIEV8aRFdkqtXh2qEIB
	DKu+xF6dLMqn4Zvue6dCLdcyliegA8WawuoMl0x0pFP7rvCmkBkH7M73P3YYOu3AKludciYr55j
	+ere2J4GaIAx51VaUQLliVwv5MGOpnpxRKKmX8OoiLylgLRRkFOGT3YguTw1xnTMKVsnlUTex3c
	I4LKsUXpTO/qgx7ZNg9AHUfMeNSbIVPJR/+XIu6DtANOB+YfX0NokpOoLsDny/lzAEYazHbzWjF
	aPuLL0RA==
X-Google-Smtp-Source: AGHT+IHRKZPT6xgfL/BoYSb+ysL+xISEDLYd58h+iYJwfPVvZ/vSXLRA/Gn9rp/f7ciXnlWZTYU8XQ==
X-Received: by 2002:a05:600c:a4a:b0:45d:d33b:4697 with SMTP id 5b1f17b1804b1-45ddded6c69mr80943895e9.3.1757533338176;
        Wed, 10 Sep 2025 12:42:18 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df8225f39sm38967885e9.19.2025.09.10.12.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 12:42:17 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/3] multipath-tools: add Acronis Cyber Infrastructure to hwtable
Date: Wed, 10 Sep 2025 21:41:57 +0200
Message-ID: <20250910194205.145919-2-xose.vazquez@gmail.com>
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

Source: https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructure_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux.html

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1a78c36d..12e10577 100644
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
+		.pgfailback    = -FAILBACK_FOLLOWOVER,
+		.flush_on_last_del = FLUSH_ALWAYS,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.51.0

