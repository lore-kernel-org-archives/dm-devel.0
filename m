Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975767344C
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 11:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720869035; cv=none; b=puynIHlU7+aPUWi0Kx1oqUUWH6Dzf7gqvmZsEKn+zKOhAjU66OsuWGzQQIuQKFlGr8SY2JFh3L+mfZXnihXBjHY/0hqDq7BbJWrTUwO1inXAg/i+jsIdcX7OHPcJVb2ZoIx5PUyrWDDlxKSoum805WKp5CixdOxyZHSKzbO4lNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720869035; c=relaxed/simple;
	bh=QrlyuTd1BM70cIRhBIKCJpljKvBnBVBuRtzp01V95Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Six7YqpH/IWwOWz4nxZ2LxGzr1eO0kY0mUmh/uuopeHX2SJUvr0T1vr5DrFIp5Acm9PDjFw8LdJehB+GPii7dExWQ7fiVNZvz0P/TNHChyne5YGA/8wF61s4nRTmoSCTFKGMqzXmxPEKRDY4+0cYEB0gv+117ZfQNqyNnvuC2rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0e2PFNM; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0e2PFNM"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-36798ea618bso1663822f8f.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 04:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720869032; x=1721473832; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hy2YGubFs6gCj81H0N6qANNGDUCnqG4ZJmrsWe7Dxzw=;
        b=T0e2PFNMD7siDzmr5OND/MITvB2SFbCEEaigy+AljvPymX60LvrrsP/e2lhRK2yME6
         XaUGiy0cQT3k6pW4erye1N2s7VYMYIqbHtJBjlwz3UHwlSyJ9OP6ZJJhhgWocbCn/6vp
         9mLI7L0jimy6zFSoU3Ew5ltgrY21Q7f3YyVP5N2He46JdX6/QMWAff2nPNQVP+D/8muS
         ysoyEk3p2vjDIFpTBuAuSppBlfjVVb8g1L6vXUhDdd73ldcD/xLEbtiM+1K0Rbx8cOFR
         Dxw9rfbFQf6E+iZvkQYlpZAPJ4VcmjV2OBl4WI0falwiPikP2+IzS//oXBrfKoC73t3m
         gf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720869032; x=1721473832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hy2YGubFs6gCj81H0N6qANNGDUCnqG4ZJmrsWe7Dxzw=;
        b=xUs6RBL/RBSu9AooEILs6IfwNB7/Xw++6HdL1r/lzYak17PFQf9hLVBWgTQIrpRcGL
         eYs/CiBPfx1up7bNiJXL5OTYcneNH5j6RRXnvKwkzB5UVFPL4Me+RsgFb7TOmWYgFzI6
         Izk43JKi6ebEaKpOzAqrPK33aft748f8j2ZXpCV+JaxAdXpxjd8A0k/bnIlNwgDUvNeX
         oxWvfnGvuH8D3yd0zGaoBpI3mhL3gIX1i0hNij1mA9RuexBUcfbfcnwKHuAMzr70lEi3
         kDzTKl2J3XvhBjfCsRlgEoHXmlTYg0c0YzYLAIRQXDUw1VESZmc+etOnABFiVoDN6Ixn
         Uk3Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+ev9oI2oIjZ5R5UlY64WLeKgzQxL+8u9HZlByACoK8ukgmFjmGJfsxKLvyLw0qWBjCeE2Qb3RJaKlO0uUvmb+98MC7Qrhr7s=
X-Gm-Message-State: AOJu0YzSqASuzkVuKnQPWO5zBWhOq3oWbSrpOZ4mW4dpaXQng68r/RVZ
	XPVDOmS2/ygrz/e1P5qALnwgepScoSmt4ByowIz+9TTpO0KmysE=
X-Google-Smtp-Source: AGHT+IFUMujRE6iThO3IGdo/gIUnNqoZNfsdQmtF0ZiA/Uweigfczr8/O5EZ0YCpF4DnbJyIrL4xlw==
X-Received: by 2002:a5d:47c3:0:b0:362:52d8:6788 with SMTP id ffacd0b85a97d-367cea46642mr13294731f8f.2.1720869031568;
        Sat, 13 Jul 2024 04:10:31 -0700 (PDT)
Received: from localhost (14.red-81-44-167.dynamicip.rima-tde.net. [81.44.167.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680db03851sm1121373f8f.90.2024.07.13.04.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 04:10:31 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/2] multipath-tools: add older HUAWEI models
Date: Sat, 13 Jul 2024 13:10:20 +0200
Message-ID: <20240713111025.104048-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240713111025.104048-1-xose.vazquez@gmail.com>
References: <20240713111025.104048-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Taken from Huawei UltraPath multipathing doc:
https://support.huawei.com/enterprise/en/doc/EDOC1100362072/4a563777/showing-array-models-supported-by-the-ultrapath

=====================
HUASY   Dorado2100
HUAWEI  Dorado2100
HUAWEI  Dorado2100 G2
HUASY   Dorado5100
HUAWEI  Dorado5100
HUAWEI  HVS85T
HUAWEI  HVS88T
HS      S2100
HUAWEI  S2100
HUASY   S2200T
HUAWEI  S2200T
HS      S2300
HUAWEI  S2300
HS      S2300E
HUAWEI  S2300E
HS      S2600
HUAWEI  S2600
HS      S2600T
HUASY   S2600T
HUAWEI  S2600T
HUAWEI  S2900
HUASY   S3900
HUAWEI  S3900
HUASY   S3900-M200
HUAWEI  S3900-M200
HUASY   S3900-M300
HUAWEI  S3900-M300
HS      S5100
HUAWEI  S5100
HS      S5300
HUASY   S5300
HUAWEI  S5300
HS      S5500
HUAWEI  S5500
HUASY   S5500T
HUAWEI  S5500T
HS      S5600
HUAWEI  S5600
HUASY   S5600T
HUAWEI  S5600T
HUASY   S5800T
HUAWEI  S5800T
HUASY   S5900-M100
HUAWEI  S5900-M100
HUASY   S5900-M200
HUAWEI  S5900-M200
HS      S6800E
HUAWEI  S6800E
HUASY   S6800T
HUAWEI  S6800T
HUASY   S6900
HUAWEI  S6900
HUASY   S6900-M100
HUAWEI  S6900-M100
HS      S8000
HUAWEI  S8000
HS      S8000-I
HUASY   S8000-I
HUAWEI  S8000-I
HS      V1500
HUAWEI  V1500
HS      V1500N
HUAWEI  V1500N
HS      V1600N
HUAWEI  V1600N
HS      V1800
HUAWEI  V1800
HS      VIS6000
HUAWEI  VIS6000
HS      VIS6000T
HUAWEI  VIS6000T
=====================

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9e008df6..095a9160 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1119,6 +1119,14 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Huawei
 	 */
+	{
+		/* All, except OceanStor V3-V6 */
+		.vendor        = "^(HUAWEI|HUASY|HS)",
+		.product       = "^(Dorado|HVS8|S[23568]|V1[568]|VIS6000)",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 15,
+	},
 	{
 		/* OceanStor V3-V6 */
 		.vendor        = "HUAWEI",
-- 
2.45.2
