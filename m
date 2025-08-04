Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777B12264B8
	for <dm-devel@lists.linux.dev>; Mon,  4 Aug 2025 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754351713; cv=none; b=QuBW+bjQBXgIPoV4nJB15JMqXTzNxnqE6LVsN7lhTjdkDnozzSesr2MRz+IFf/BIWwY3Yl/QpOuHpPHpLjMlOvPMe1NMm9x0oWmMqulOPssrV2gKxqyDwhEh5gIfEJ2mW8S/bYaohZHw4pyHQ8zJ0IxYB2Y5vW4O1Fao/vUZsG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754351713; c=relaxed/simple;
	bh=KyoJEVRr17ax2aRkVS7OyjR8b2NT2BPtcqO+8pCg+OY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=leQISprTpkaGUmoMXCkSKQnzm41YNn53aayL5z7taklSQ7GiAX+V4Rd+BziBIEXh4mftak6wmcdy4ym1cAjDuxY21uS3/AKqFwukVRt8uQk0Ghcx+ec8d3sISN57yy5fX9XJxWP6hXEXOOo5EMVMsYfj7vKPnTcAhqjdJr/fuBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hqf3013K; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hqf3013K"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4535fc0485dso10079495e9.0
        for <dm-devel@lists.linux.dev>; Mon, 04 Aug 2025 16:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754351709; x=1754956509; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k35UCy1kAUuZY4u0ZYQsyKL0uz3gXjYuqId/Ijlbz6c=;
        b=Hqf3013K1bXPJW9DdWDcoPyTHFLdOVaJPLWZk5VBZCOTF3yPgeBTDZuV0YzIvWW5Ua
         xjxSW4g9km6veVwMbj4KMDGJzK5eIQ5ODsRO8Q8DMAW914axk/88TIhxWxRHiwh+oALD
         OprBIb5XEzBO6l49rSp6sWlBvVH7+6mOXd84c1rCJHuzjpMRPPNfm6VKH/0UnRq3SFau
         D2uj3WVkkC/6TYU1T66vHlX/otgc2uq1VMBHGJQpj8YK2Am34qxFpQXSeEi6l7kWflwN
         AM5OOqWgkcZDO3kOgf30VVRdMcWsW/Z7okOCWUdodKKdRnOa0Q7RYZ5JBgeOpe9nWCiT
         xLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754351709; x=1754956509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k35UCy1kAUuZY4u0ZYQsyKL0uz3gXjYuqId/Ijlbz6c=;
        b=JkebNrCktRCH7E1qCZt517Ki15Ls3yooOgZT/G0t52fn8ca+M0vQc9LSl1bQ81zmWG
         gG96Vd6V/pL1gSpYlpMzwRT5XCaJTSrBFvb8UwfgYd3riYTcv4AwlixGs9uG2pW/nxwc
         l3aSgcpmCUlTNTvM66NE6s+Y22oKZkI+9nYbe0Z2WBLa/uHLLBudeuHW612vcWofNl7c
         /gTyRBljJv/EzqlNWNewPDAddJPy9voGTLIIUX1Gaf/zIlUEFutYOwmllmAHYmIVC+e7
         pvWSkydT8EIW1NxgNWex9TUBCEtcosw5+mYBrt8HzBnXwSSXnUkxyqPjhMU2wpv8Uuak
         MpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCX68+HrNQPmPoqgw3qyKM53VCQaPIWkwrS8jfRGkAfNHRWP43FojgpIuW/Rpj+MBhQoa+yopOucmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YySW2cDQdhlPAhF3dw9haSeqLZVHqukx0vsp6DEX6Gbz9VXp6FG
	5XEb2gw/Oyes+b9xPsgA3YGRBl6K9n1Ptgli2cH49x457bLAOMKmLXY=
X-Gm-Gg: ASbGncsWv6GZRARE9zXCqIy84JY0vhsjBGctC8Be9gOrnTHpPmpwH8wC4jki8vQRV7Q
	NM6GzhnOw+UQsoBGMnw/giHOp6TesdDjbC3kieD2lt/t3+5nfsp5ndpiOh41TcpUdPoW+U/kk6w
	34yeQcm6rZV10+PeJFbpHpJh+Q67aCiv+dM4b8GYm/QYFzgUqXAKwrSNrqaJHmAYeMOmXaDYK5/
	Ai1FXycxh5dRxVwKVDebEbeXFhn9Y0OuojEVNAu3dNm30zqO0RmX6UY4tBXdhZprrY9yd4Tz0Mh
	uFF5CL4ZPlgFP5euLJNPveRacbK6yUVgMalDrp9Zp+v1nyikiGNhOMxFvLdDyPAVi+tUNibG70l
	5GOe0jcSKyFLGgoWlP3rBEMMhWfV5uwR9ik43+ixXO3YF2WdGrIsuCfPmlWk=
X-Google-Smtp-Source: AGHT+IGbWx5EkBYpUny/gLZyDY1FwPedEK9cC6zA+eNfKjZYWcxZVpsXIPni4deeBHyKaEbGPGNtaw==
X-Received: by 2002:a05:6000:40cb:b0:3b7:95ad:a6d9 with SMTP id ffacd0b85a97d-3b8d9465ec4mr3938577f8f.1.1754351709363;
        Mon, 04 Aug 2025 16:55:09 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589536b3b4sm224755375e9.3.2025.08.04.16.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 16:55:08 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add HITACHI VSP One SDS Block to hwtable
Date: Tue,  5 Aug 2025 01:55:07 +0200
Message-ID: <20250804235507.149544-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Info from #11-12 pages:
https://docs.hitachivantara.com/api/khub/documents/E1h3w1EJLDYuE5Yde3tQfw/content?Ft-Calling-App=ft%2Fturnkey-portal&Ft-Calling-App-Version=5.1.38#

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 65e7604c..48ec449e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -492,6 +492,17 @@ static struct hwentry default_hw[] = {
 		.product       = "^DF600F",
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		/* VSP One SDS Block */
+		.vendor        = "HITACHI",
+		.product       = "Hi-SDS",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 6,
+		.prio_name     = PRIO_ALUA,
+		.checker_name  = DIRECTIO,
+		.detect_checker = DETECT_CHECKER_OFF,
+	},
 	/*
 	 * IBM
 	 */
-- 
2.50.1

