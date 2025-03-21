Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9341E7C10
	for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742546815; cv=none; b=bepl4JHFv/WsuaRf7+gMj0AAQSnqW5baztuxCwtWygMj2J0Dp84p61+7emOk5SUXwKkn3c8GF5kGFw9zwy89HDpCZR5p+QYGIYZmmnRfrIPhBaviMACbmIx89h81jdq7OvlXuuUCFgUDiApelsTlULcaQUuDgW4vPmKJcrFFuKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742546815; c=relaxed/simple;
	bh=vIpTmPNUcJi90YWCAmpcfJ5CjFPG/rSj/DAWD8BbCjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cxiryZOGlkgUozKkzK79npm66hS2DdnKVQM9V2gvvXMWZUFsA/lZaCAivBGsTLiVz1OQts+HqHtAy+Rg9XgKX/tsf7S7xgGsKOj0JAkiej5wETwHZZaJSqhRF3tgi3OlOUOSLZITnmvMOgRvSVyoxt1y60z82CmqxSZEbCGwSa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TH44cBPu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TH44cBPu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43d4ff56136so1114785e9.3
        for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742546812; x=1743151612; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=137lmC1zv84xYThSPt3yBlH0x7SyLOL4v8kVOV2BYL4=;
        b=TH44cBPuENSa3QN0jod3AzncN2MXs7holV9daWK2exoJ/ptKDGjrui2bz9qSPVhIQ/
         iv1gyYp3xFAhEu2dZyR+m/xOufnelfWNYk56OurJpcnuZoIpqIkYdHq5ebzvTcr2torv
         vX3H+uQmn6Ft7ObPu4am/uLr6/7g2/NNhhdYGuc0cqTx65tF650kv+MzrBlE6DXG1VNu
         2NoM6a3mgULzbbXqyAFlkmV7Nn5KQNy9EGu0x62mjm2rtwiCW8RZ4DVwDCSr0+Ibq0q0
         n5ZlMti4Zqzkgg3y8stQxtKLvTd5G1BOGPT9kOO7BRcnI9RzdlXJO5hx16X+/Z3q88vl
         H4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742546812; x=1743151612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=137lmC1zv84xYThSPt3yBlH0x7SyLOL4v8kVOV2BYL4=;
        b=Ug4caK92nQZxH8Vz/8DbSEDTHv2LZ59TDiDmm/XpVO3gajI4isn+1pEO46Jb4VrfXN
         11QgpbdWCew6FmQ4NanFcdZx+kPIpKa6Q4Hd2mi4dOuS7W5LqOWIiXi17Vybvhl1Qr/G
         vfodjUuN38PbWX/SGEJ8UP9HdphW9rKLYzrMvt5KVAb6EHPOPLmByMpadqF7YEoZhOdP
         jFFzibmSVQxzTPKdk+S+bgnqH8ehxjPCnL3nuMasaKu3gSb0IHEm1RLoYhS50tGA+GfU
         fi24CIPWxBEdgzQsOOeScd3NvyFAj5THzMnBKeuwqjFIltLzQZQN822w/BRgMZVa9cvq
         I+3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/FI6khfUU9wZs3+c+fgr/3whiCyorQrBkBmKOCbKV9Dc00PfnDpLrQXsu1+OUhv+PTGgCD5+Phw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwpZRoNn5ZQNHacvxG7wT0M5Erhrir0ESdyD10Z8DnxdjcxbI4E
	3Gi8WUsKF7X4uxCM4flkCK+i+v7z/y8hZ69HSFzGoG7uMp2bo4o=
X-Gm-Gg: ASbGnctfOwinEurctXz/SRhdbyoADEK2A8DKKfQ8VpeEWT1Rr0jgncfRMd0RS9HaFfD
	jTs77QfhnXftTH7/TZl2VDc7DrIebIDZm3N4K/VyqYCXoY7yBuciCzg/Dfq9W3WiX+sLIrirVpy
	Rggs9NhY2Okja7NHvjtM8lLsmM3G32AvYuC6nC76suDcCJScwkWfgpH2TaI+6qV92pwle3JnbG+
	cJrvfMHYLDgoRcRhq0pyCNrLHfNUZzSI66YPbtkQuMusoYqURTo5rgJ/C/JGGTwraN7T1O/sCr7
	jhRnVu8Ieyq544Nenr8/2VAqVWil6RolTza/qJ39WsZwwYsgv6/cHMzM3IAlF7+X2nJKzaM2qnz
	a1sAifc9eutmR
X-Google-Smtp-Source: AGHT+IGpueOfGyK+Gw2rtQIwAqw4WOIwEi3gl2DITVyuNUDWwHvXjZelK7t9jccZ7IgRec4ivR79NQ==
X-Received: by 2002:a05:600c:4587:b0:439:9a1f:d73d with SMTP id 5b1f17b1804b1-43d5171da8bmr4578815e9.8.1742546811784;
        Fri, 21 Mar 2025 01:46:51 -0700 (PDT)
Received: from localhost (242.red-80-39-144.dynamicip.rima-tde.net. [80.39.144.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43fdab7asm71402325e9.29.2025.03.21.01.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 01:46:50 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: remove checker from Huawei OceanStor NVMe
Date: Fri, 21 Mar 2025 09:46:48 +0100
Message-ID: <20250321084649.16093-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

A keep alive timer is implemented in the NVMe-oF protocol by default,
which acts like a path checker.
Therefore, change path_checker to default, "none" for NVMe arrays.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index cf39a50d..862bfdaa 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1100,7 +1100,6 @@ static struct hwentry default_hw[] = {
 		/* OceanStor NVMe */
 		.vendor        = "NVM[eE]",
 		.product       = "Huawei-XSG1",
-		.checker_name  = DIRECTIO,
 		.no_path_retry = 12,
 	},
 	/*
-- 
2.47.0
