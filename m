Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602379;
	b=Q/czWhJcdNealHMqWwKU7EP+ME6zgQpN792bAbC1nd4Of6ZQForr/TJkhXnhCIdA2P9h
	 78+4FEdNZ0G7VQMeWwTH4WtSBjz94doQuxCSRpap3V+qPGAwPKIocGwZxOdromALEbCE/
	 1L1mXm/HawYFSg8tM0YmGYzIlpt3b0xe+m/IZHwX5s12ulZ3LNKhatH/y+gZ0muxaTWXF
	 HNnTbyipJ1b3rIroM+mhr6Ay7z9+cQYCXv4kNcsZO3whY6z87K8EjIZrXujluDvtV12yP
	 13y8cPn8Gb9pllpapK55/Sxn6G6uRpa+RMh8ppq1EYJGY7dGnLxZgiQlXtCial//HCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=hftjMqamUNNQijw2FAI/U/07ieugluaPKCgfY6qLTFg=;
	b=uslFbnG7o/fvDxQhw3TgHv05Xc3l0+ertW6ocEIcr3UEuZWWooBLKwvtgz2OGWFLciVT
	 TJOlXYy1xw2NhpbUBC9d325asuNa8hoyV7EDyByke3avE4x+xGan7si/K+ehm9mZzowK6
	 0tC7YFoHlE9FGgOxYAn0W26inqjvXG9qR2n+5S0YKK45BvU9FRNr0tPDq2eKi697vwIew
	 i+ufab9lWMfVC4VIlDq3NdLSijjIFFPhxJ4H7c7/jJ40jqFD2a8PfBHTt8t2pOIQRMhBO
	 TqvNpbA7CzVmO7vGotKu3jbRXv3Ce4b8/ZkoYtfACA5rP75f1+6SzKoGNGFjhpoulWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nEP0UUrF;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33941606A31E
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33941606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nEP0UUrF
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4a35df85cc8so454491f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602377; x=1796207177; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hftjMqamUNNQijw2FAI/U/07ieugluaPKCgfY6qLTFg=;
        b=nEP0UUrF5CT9TtjYvgd8OUdFqvkcGwXm86jcPPe+NcxtmWtSqu366W9NfSL3KCOHow
         NtASrhgRsDyG/KKVPOFFzQ47rmx8YfqvfPRmDbRtC+QHMVBg/O1QtbGYQsqPBLz20O/5
         TeJcBZUxlI+PDWMyGYsQPnIeyiS5QBKxZA3NMqMmbYqaUfZoFZDnpPA1UiVFmrjukRS2
         8xsMhJk2aP/Eda4dUeHKiFjGqw6h9ykLukb9Ks+nlUKvz/rvNziF2xFWxYaXun8mX2nE
         JZrkwKDHReYr8ND1dnNHEVVQzeX275Iy/5+I2hxxb23fZDwg1YZiX13aG7M6Eueb0wnv
         w5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602377; x=1796207177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hftjMqamUNNQijw2FAI/U/07ieugluaPKCgfY6qLTFg=;
        b=WQOLv77HhNzusXF8chSsaqEYHyTJben3YGFOyt9C6/6AYMvY0T3Msx+m1eR2SOHNjp
         rl/vxri0zWSOlQCvIv500gnTUzegbi46PybFx49mRyZVK/vVO0y3mBCpBH3arRiyT8hi
         vvBE8yxeeVxEoECrGs2nVHK2rZJJY/P2LsYQ8C9nfRXePF+hvVXCJDyKj6EBvbJvlk7/
         H0vjlAPTeITivdU0d/C3qTopuCgSD/SFWpEDInr6X4ZSrxVZQBnJebMX0HFB+6wBLcpl
         E16D3BujlkNuwi29j9dNucWCX1S7lQC8lM79d+J5qH6swdi5dTGxX1S1/mVouWsULaOW
         gVJA==
X-Forwarded-Encrypted: i=1; AL+hErFyENPnqwWK69q0r41AWGBOoZWZOwWuZoU45//zFOTKs9mwUdSVBWONnEV59nAdjAiyhffl7ilVoA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/Boed32IXYEt+B1qQkl4MEOKJAz+qa5UwWjayCPIzAPJFEzj6h
	iswlYL96AHqjOMXaCk9dn38oJm17iPdZkdz6UIYCWyiFsKwSD6J9vVo=
X-Gm-Gg: AZFdTZfj5ULuMYMHSG0kUY+mQXOzSMu7ILtorVnYiq1VI/dJA61dm9j2w9p4ldPjUDl
	YFYGFB+yGkphpDZYfx7VfPp7993dQWk/ebHeDD2GZUhDtr2wQLlw9XMV3KlPeDayxlzpCr0B6Ss
	kioa7yWiavU7GDt1zHGpeGxbLLjKwnuuqUry2GW6yDbETr/3CdkiYyeNKrdC46OIkZ19m04Hn5Z
	m0gRmmVM9g8BtqC7vEAfuq4rVFs1s0q8sL47noNCCASrm6uHG7VxuHJx36OvmtwPLmteJj9OpNy
	9k2EME3xlvZuVLw70Xm3J/55eLCTT2j7pIu+ulpVN5E1WAjopTvUZ8k8MpDD03qrfxc7K4UyOyC
	GWqr20UDUEeE6nPOw/8it2dMCk+ppfVqJjfRoX93U7Ajv06swtHWdM1TWLcfp0oQckElde0ETir
	EcDm3rIf+m82q4MGs/eY2tzP8u+nLB+foUdJnnygGgLu08JfDSUJb1gkENEdc7dntvFZiYNFmuj
	gBWzKi+0XnzkFJknTIO8V/qyYt7x1KEelLlNgjBs2aS+jEqe6YZ3dNs1yqe+0X1XeAYYjpJkeEQ
	Vsn01v3IaWgutizMLtLbivOWSq4QzslRnzqVL5iNql0q0y4W65JWd7ap2w+NZoJjqQ==
X-Received: by 2002:a05:600c:34c8:b0:4bb:a792:80f7 with SMTP id 5b1f17b1804b1-4bba792818amr18067415e9.0.1795602376688;
        Wed, 25 Nov 2026 02:26:16 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8533579csm443833795e9.2.2026.11.25.02.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:16 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 6/7] multipath-tools: hwtable: add Zadara VPSA
Date: Wed, 25 Nov 2026 11:26:03 +0100
Message-ID: <20261125102605.82009-7-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102605.82009-1-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Config on: https://support.zadarastorage.com/hc/en-us/articles/115003851406-How-To-Configure-Fiber-Channel-Multipath-in-Linux

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ee3cea5a..47d5fcb8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1473,6 +1473,18 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	/*
+	 * Zadara
+	 */
+	{
+		// Virtual Private Storage Array
+		.vendor        = "Zadara",
+		.product       = "VPSA",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 10,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.56.1

