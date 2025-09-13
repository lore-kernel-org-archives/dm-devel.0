Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5782ECEA2
	for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 13:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757768554; cv=none; b=BSu0Qh5TUrH9B1IVY9UumD0CSW9Q7dk6IApIcEd8wzuxc7GLJYNUkYfNERxGzQBFV3RfUe+kP4wxT1KoP26y0GunGetbDUplbFLfFArW3eJMKNNka/DfiA8R+8hUs+ak07BFJe3S0Ci4iiG0/tqB7rE14OBwTP676D4ACsmIgKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757768554; c=relaxed/simple;
	bh=qdOaPxfxB+rMa3bHuUtBxdyA7hYoNAxcCqeT28LHpvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3Ollqar8OGrobGXDJVL4kOe7QLhu3JJhYi/LltsM0x7mrT8Q8sRxZV0ofqLfy73Gvg4wvHo5T9N/047EffQllH50bYeLgunzmlS+XMqBng70VVivGSRl9YPq6O0MsvJebcPtCJJf6quUWoJtSypw1XKGgJYhapKwxyLugcNygs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TsArqkC/; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsArqkC/"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3e93c6c4b20so24027f8f.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 06:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757768551; x=1758373351; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MGBUlQzFuc1ZmY+eWlybeNXm6RHophLI4xHJ5YbJPs=;
        b=TsArqkC/pMS42L9rt7qpGics26c115+aH+yL2mxLAk2UUo6RJvQ+XMi/ORys0HuUyc
         1P9KbEtRvdlPA3IwpSCRNQ8Mnl26VhOqKFmiJ1blefMpG7iEssIHVh6Dcfp76/t35cRq
         9eksvgxG/qLgl6CpRPaQgknEeKFCqVroSfxh2joGQb5D9VcdH9f1xOhNQjfZXInEDeez
         ztOmuLnSWWTyypmquce2SEezvAQ8fCQ/HMtGD+d4f1wl0ZS/1K397WVKi+GPvj/jkyah
         Xh+F/AQRDc4AOSNHNlkC/eYYQH/E94UHqodkOKJQCZ/mhuGPEmXVV23iN8z50b3CmTf7
         biug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757768551; x=1758373351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8MGBUlQzFuc1ZmY+eWlybeNXm6RHophLI4xHJ5YbJPs=;
        b=PYGhjsD1tkBwg6xQq5JMNt+TESqEyNqO/2bylh4M5o/NncF2H+j2hW6lLRdIMM3ZWC
         ttc71dJzFkIW6Z9cuk89l3N5WNm+tq7LQb0vP343WCVGh4tW4mXgEfFz5bxfjAEnmIgj
         EAbzvidj3XbiLOFhesZM6FYJ6RReere1+PZg17MiaJ7vwwwbkB1chc2WxFxHwneWig62
         /gN3bKN9xkVQrM/8c/1xJZvAzjPxefChF9TUWdFkwKxpt317STCDEaRU0keDnloKFg+R
         ujMeFCJSm+peb3QWazS4fq1wLPR4MtyK6rgjhM+YAOMWvVV7ljASi7aa4JXmyupj+Aoe
         IbLA==
X-Forwarded-Encrypted: i=1; AJvYcCVIWwtXYDy0qmsu/lTQSCXnJStRBqcvMmbTtFc3QawSnIhq1NeEVYPdPyVA2Kx7QrWZs7RmkSOMhQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxD/6pHcwfBuJNuFyAswHrnwApvn/NML3mQshDSEHwqNNuOoDY5
	2+okdLYNcBP6tDn4/IjFcQ9gp8ahyprnlX2ymWMvJkqdTyhxbPn3d5U=
X-Gm-Gg: ASbGnctY6IoeNANKAsKjKlvxdD0U59Xu/u0KO+WFev9S9Y8plaG1eiuy+YVJaAVdT0C
	kVYP4OSGYWssveRHNft9+Il7reV3yicDogQqSFJXTFCMs5vB7zA12W8xIktbFx9xP2qOXH9zgFf
	e6OXklT3KNRBI58B+MJe9nXwtphxhBQ/Iq8YKvNionIusgffe+nHk6gUKPWvJllwdNqA6CjdVBC
	TyLrOBRPKETlgPZE0CHR4pL38sY3fH+TseFcSJ0AAkR0/VkELMczsJOtE7MoyXEBIBxNjUsbzKC
	xsdvpQ9YNP4TrZLifJ86tiPJvVIrQuh0FUymZFwzu2VcazvNjB/Rw0XeKmlaqSiYzClzTm74Z+t
	YZfAN3wzz/4aVDycsJQcQ6fJ3UdLIIMIM+dbpcJyusxwclMNAEhRZ/akcN88S/ROYiDaxBFULtl
	am8vEpQQ==
X-Google-Smtp-Source: AGHT+IGT+smkrqtOu6jqg1vJE7avJjzYiHV66ks94gnhu2pyd6k7WQawVMOd1hDygsqoIZjnyUG2Gw==
X-Received: by 2002:a05:600c:8b86:b0:45d:da89:b7da with SMTP id 5b1f17b1804b1-45f21200e40mr27199205e9.6.1757768551391;
        Sat, 13 Sep 2025 06:02:31 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037c4490sm98092535e9.19.2025.09.13.06.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 06:02:31 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 3/4] multipath-tools: add Infinidat InfiniBox NVMe to hwtable
Date: Sat, 13 Sep 2025 15:02:15 +0200
Message-ID: <20250913130221.35073-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250913130221.35073-1-xose.vazquez@gmail.com>
References: <20250913130221.35073-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fb446856..dd3bd30c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1154,6 +1154,12 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.detect_prio   = DETECT_PRIO_OFF,
 	},
+	{
+		// InfiniBox NVMe
+		.vendor        = "NVME",
+		.product       = "InfiniBox",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * Kaminario
 	 */
-- 
2.51.0

