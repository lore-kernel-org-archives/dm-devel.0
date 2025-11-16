Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B181E2834
	for <dm-devel@lists.linux.dev>; Sun, 16 Nov 2025 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763302825; cv=none; b=ZG8LJ9J+JXuDrxXh2ixE4RuMSiRULpyVZ36yJsrb59NK+g9hWPZH/5RA2AMUHgS4BXz8L+SdM4CBrams0A9J2Ubcdw2IOQX0ngmvc50Xm03M0hSdlQHwn94MrPGcBMmxKHhRWDyFkP9LuyGA/zTmiHBE8dVIB/BP8778s5KFP00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763302825; c=relaxed/simple;
	bh=cSuH7JVctiky67bgUSIjWU0qNTRA0wXoD4/pDvq5bmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BK1qSehVrFgCaTazex7Y2tKOLTUsro49wxl/19Qy35VDaMjJIbdr7m9Qy44hWi89LTa09SR8Lx0O5P9PdJIXWrdTfdVTdeaV5ROvSaQwTnZck3iGrtzQQigybhVZlQqzcYLTYIMzsWelSivLXClk0Eb2mdj07n9qJc6jKnZsuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PFEgeOZX; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFEgeOZX"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47797676c62so563915e9.1
        for <dm-devel@lists.linux.dev>; Sun, 16 Nov 2025 06:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763302822; x=1763907622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=muAb0DqJ6rA75Km0hljunPWDTyH5qd+hTTZJ15zgiG4=;
        b=PFEgeOZXnmo7/N19CHZg536RIGWKCPAy6gMHwhG8GJeUwZs73eneDvgpAcieqD6XLB
         Qm6zfOK1Ddtz4BnfkrwG1zBiBMI3rpH4dyCkp2CTXMSk8OtqFOytozl/wLzu7DjumpkX
         daS5nrIgG6dmaZT01vcYiPsSJu7z5AwKMYkXleweN2g8GtdOB5pCSn8CTSD2bE+X5Bjf
         ICZT4kKd5F5hkZFHi2pN3BP/vnrPOdtVxLgam4VhEbByYzSRsotZbTbKeXV+wLFxfWPR
         AMlF8KJWItCYJL4tcy4MMaavEI/9FibSMDaS9A/ELHlZI3YF64CtW4P0roO32QxUd9NZ
         XrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763302822; x=1763907622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muAb0DqJ6rA75Km0hljunPWDTyH5qd+hTTZJ15zgiG4=;
        b=pd3bW8a0ZFTgFHN4HUljy56a6NyAWYmiO8BY+zNobdlfea9FAINSJ+1Djs0F5QUW3i
         W7CJMH6RocNR0T0lTIkQXXC+yxs25VRFPm6Ie+T5osW01ETC8V9DPHFmpYdN5lDlTK2y
         MnTdFrhPi7so64OfjEvL7V2m+imSNaOELZ9aOJAh6KOaeHMQlzSP0bGP6/r5BukeNXZk
         PBIoyKFbPvQg6k3B0kfHxVP6wEyqbqBpStJmoMZvh328pYXGmUpFS3ybAoEwsOXZQvfN
         rsWuyrP/1jM7X2dBMjXXhCyFY4qpXbiTzNNdd9s0Evo6pduNVPdfBm+EgG+9qimPH3uw
         QPxg==
X-Forwarded-Encrypted: i=1; AJvYcCWCHqgnSTg4jzIW+MM0159HTP7234RRcTieR8+VCMo3IfFE3hMu1ubDYYvqbxRjmkaVz6HFxhE3zg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvNpAuWPuy7y7UgcJFyDk3DljvTbWf4wn+hNNE9ELTOecLg16h
	PTJQBQKwHFHhjR9nPrkhH2aEf5TRsGLRJe4gM0x0FUPW6JenLRanD5c=
X-Gm-Gg: ASbGncsqGUEsjoTfLrOrCpg8xL5y2ZfAys9RDMNvm0m/VrVU1GqtkyQ8eH4/J7NGgU0
	bqNpFwGzYkojtktkM1+J4Y6XWG/X86fLwOoTTywrjrlctA8RfGiufAcl3HgC3gM1RGZqTWJ2MaT
	1xdydcAik38CPv+5XWVxnYV8OWkVjWDv0cw7oVHQpsAE63W3gRW626X/Er0TD80QqBi1Ol7FX9E
	Q8LjvwF8qqHXXOw0fxm5y7SgWRBCWw10V5XFovzlp1BuRdl/1leMAhATjMEKEKtTLTsTZJhhqeO
	yH0QprsIzq4hyQwE3sSvF6QwpkJhGSHW2tz6M4AR9jZEEF+5LGWMOBtHBOdo0g5g47PnmFDVCFm
	4Jn0Dnz7NceEXjBRjCVMKWow/iBVWVndYJbYBwD2jaStaQw/bHmoiDUaupXDAc2TKq6won2V/OX
	I8dTgWF70FBrdKJc0rzTp8lMPR6OyGj02PT8KJQP1fPtOEyN9o2brBxIouZ/8=
X-Google-Smtp-Source: AGHT+IHcBSVOtDeb0aGTZ88/4IY8Tr8xmjZmsf1s8vVCODTxHZr6FFXTwF3tLt9keotk+tsXMW6e2g==
X-Received: by 2002:a05:6000:2884:b0:42b:13cb:41bf with SMTP id ffacd0b85a97d-42b5a9a33ebmr4500162f8f.9.1763302821710;
        Sun, 16 Nov 2025 06:20:21 -0800 (PST)
Received: from localhost (39.red-80-39-34.staticip.rima-tde.net. [80.39.34.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f0b622sm20603997f8f.29.2025.11.16.06.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 06:20:21 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: identify more Storwize models
Date: Sun, 16 Nov 2025 15:20:19 +0100
Message-ID: <20251116142020.346811-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

multipath is also supported by V3500 and V3700

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 92523042..23187a83 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -682,7 +682,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
-		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC)
+		// Storwize V3x00/V5000/V7000 lines / SAN Volume Controller (SVC)
 		// Flex System V7000 / FlashSystem V840/V9000 and 5x00/7x00/9x00/Cx00
 		.vendor        = "IBM",
 		.product       = "^2145",
-- 
2.51.1

