Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2148A7344C
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720869038; cv=none; b=PM4L/SLVuLoNHONF9Er4MKY3noAZz2QKyhe2fqvKeunBks5NtPTpzvvWC2YjWGnlvzxYOs22g1lYBt4WCX4ujhTBA5MHtegBIXlIZe3/UtKeYdmtbjf9YnpdDG2vpnpAuGEkRfRftWFwuZsUlhzMP8kuiIRx2sVWU5z19KEyUfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720869038; c=relaxed/simple;
	bh=utg1k87WTYjJKA7kNJ5qQGLwYYRMGEzY5my7B6ES458=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3+ZDm0G3P/uAC0jUS5CuvT7nhkvtkmdAct9K4xWK5KAIv+yQ/F5ZBPkQe8frR41P2tRAZwgFLBnjNG4yjj2e9CVtiuz4PyqqUHI9niMWpY4k7mXt3TeiO8rGepk7DSufffg74tSbg5sCgmx8UdVNrb3C3ickOOw1erPRpNe4MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5I2tGK3; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5I2tGK3"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ee9b098bd5so38865921fa.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 04:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720869034; x=1721473834; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXtzMoOYBfvQrgQRVKoLPVySEmdgdfmglMvG1Yfc69w=;
        b=B5I2tGK3JoUq3j5e9f/H0gNV6TJkKkMEP6z2o2a2Y7bec/0lTe1yApE1gA+gXbba+E
         x3tkH0Yv09BOibgyLYBS+m5AmIGqTvOFGCi1Qiwwp+jK9y4UBdgSRCvFkQT8ipriIy/C
         03ov5Ne87glgltfkg19WkDjuJBWBG2o1Nqtu9bVvqBGwvEPt/sJ0Y7nOwprmqd77F2E6
         F5D+CkKmWTI/QUiDc27z91+69BFnPjDVQEDDf2oYexJwz5fZcN/j/0FMCog1tjHEI6gG
         0WYZnr3eGrEpeCars+nemQxafs1Pgqu7b9MQgJ5iq9rsqRaBKk2GrErfXrQH0RlOgcIp
         H6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720869034; x=1721473834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXtzMoOYBfvQrgQRVKoLPVySEmdgdfmglMvG1Yfc69w=;
        b=qWIOfYSE9wYY1PsiUns7G7CN7tDNvk3tdE5DkuZV0hPPa9JWZRgGty0Ay66/Ejs646
         eh6MunJUnu2eyx8oS0jl3vb+NbS/pAXQP5gohP5drQ+gTVcGDE4WqWN2F3NIloLLfZI8
         dZ6ew+31yOIe/Sabvi4JADb+dsLolc8+10uU0iHYMV0DZFOZATKSBdcBlkUZjqZBSlhf
         7Xqff71xgOQ4A3GDTmBJKa0nV6x34/g42HyUv2X0kAxRL0wEqPjyOtatQ4PYGyMkV6jP
         clQCjRdrel3vMggVLJQMPAuyfVcJZ2ugs7l/2etOYY1qh5G0dGkYtrZX1uSeHoTx3N6+
         Mq2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEOeIVF1/lTIVAZbzopZtze/cZnN4Ses2zsCZpe9QpPLm+1DLPk7eXI6u21Fs4N81FypTpvzVwvuzEp1qdxr02akLb83fJ9+M=
X-Gm-Message-State: AOJu0Yz4SSuUvXfvXiOBLgd7AdewZDMEofQJa9pBMLLrq9vGGXBBzx6G
	ZVUUHeBCAWEZJE+LOsQe5h8jsTTJ/4ARjWkIkGNt/Ld4FCRfv28=
X-Google-Smtp-Source: AGHT+IFVbcTIMDddjaXexWhNwYo9lHR40RP7NJohJ/9jpme1D6RXpJ9imYHqPWsCFk3wJcZlHs2MtQ==
X-Received: by 2002:a2e:911a:0:b0:2eb:2e0b:72c with SMTP id 38308e7fff4ca-2eeb30dc843mr106583691fa.16.1720869032915;
        Sat, 13 Jul 2024 04:10:32 -0700 (PDT)
Received: from localhost (14.red-81-44-167.dynamicip.rima-tde.net. [81.44.167.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5e827efsm16780335e9.16.2024.07.13.04.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 04:10:32 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/2] multipath-tools: add more tags XSG1 vendors
Date: Sat, 13 Jul 2024 13:10:21 +0200
Message-ID: <20240713111025.104048-3-xose.vazquez@gmail.com>
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

============
AnyStor XSG1
HUAWEI  XSG1
Marstor XSG1
NETPOSA XSG1
SanM    XSG1
SUGON   XSG1
UDsafe  XSG1
============

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 095a9160..c539a9b5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1129,7 +1129,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* OceanStor V3-V6 */
-		.vendor        = "HUAWEI",
+		.vendor        = "^(HUAWEI|AnyStor|Marstor|NETPOSA|SanM|SUGON|UDsafe)",
 		.product       = "XSG1",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-- 
2.45.2
