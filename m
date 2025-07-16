Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC02EE5EC
	for <dm-devel@lists.linux.dev>; Wed, 16 Jul 2025 22:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752703937; cv=none; b=ZkJcnw+deoNt+B/ewUGBkz1W9wvX5gSsn1K+XLQ6m/4Mojsev5eo+7v+bhCjatri6Uhl4IGDSvCtCMPSa7aZEnePrCxB47AWi1W/gbNi004nhpYq7yMHlAV2Qp0HidBe0D8so+LexMknm4Bu/JlYXG7eL1502uAxkKPcjdxfquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752703937; c=relaxed/simple;
	bh=6BbQ3JN8tkPu4H1UDgBRGfOofWpezL//959SPvzCPrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lA7MgnQ7GKM6E28j1hEU3D5MH5NDVOosVEUDRpJj/Rz3h+PcjeS4zCoyrv462PLzIcsTR2Spa+9UEZIfg1FhvxUfalNfMCfFh2Rvbmdgi64u/BxBRHOa718DeJwAI+6VPbjEbyDjdxDOcEv6zrdgHFcBVRuuqQFwgpwBRE2wjwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ks4cq/qC; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ks4cq/qC"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a4eed70f24so52907f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 16 Jul 2025 15:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752703934; x=1753308734; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MV9JJ+jwpBErPBkuNfiEQ4mvMEWB/brJTpppbmas6tE=;
        b=Ks4cq/qC1DwBE8Pn8tKpErfBr1bb613h87YNoh56kW530190lybALwcuhqJltLEpNc
         w7n/d353NUHQFnNSTn4Mt0mO/I1EPu2wHqIvFlBHphzAOC0Sl3Dpnjkqr+UW5Fnqt8BF
         Ahsslk8AywbeMJOJRyAukWDJGQpQ6WbjzgaxHN7RFqWVWjO9/DIdoUWqszENnr1++V1T
         qmJUuHi34zJqrDwe5dnLzkMaC5mbh17rVU2F9q8jt0eROYmw+ewonKFZnsVjFT8OO0HT
         rHT8SfH9CRiOMxUeu59ehw6SY/pgsJ4RuqnPFKbwab31FCokwan3RTFFDkf6et5H+8aG
         IJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752703934; x=1753308734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MV9JJ+jwpBErPBkuNfiEQ4mvMEWB/brJTpppbmas6tE=;
        b=FWVcuvEirRxFfZqqjhFKcmAWFUmOqynkmooIrS5GsPI3+ws7KvTULsqEcdGrKoNNGW
         veJiIBCulIjIfQDv9EBFMDyth0eqplzkxTu71u9/q6aepPKguPo3QB5ieGSROUtlofq5
         4IuU77wnntTlGSMLhqEFXuDraxS0v+YuEudvv/KNBAjmCGWwTRYPZoiQw5TVEoxrDMAy
         IFsRyqCq/LlKK4idNflPX0shyAH/gk2QWGma1Lq08VZHUxbbA/V+hB3VHzOohFmmUWOq
         nCRLcu9hqrG3CBC3l2GacZcbV2Fyz6OzE5v9VJsXIc0gKXsrzMKpzclzcJiau4nBy6S6
         JcQA==
X-Forwarded-Encrypted: i=1; AJvYcCVazzfS5L+GtxBsIs6GcqlML/1HzRvgtBdZ0eS/e8dM7g5kM2jmia5aopS+nHQzSRJ1rhREHcV0eQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxmoBotdUw2vHKBXP8hq6k1JooZo1IDs89HIGwdGWDE+RmbZNlr
	JeVQ9MgC9sFKu7OGu8aCRS29N5jEeUmay+FM25lwePrLAAa2mrTl7nU=
X-Gm-Gg: ASbGncvK9w56nieMglWk18BX49MezFYpRevVsfmgOQqL9yiWJdAJXXO4v1UFmHd+oOS
	SWscAUodcsdKYBimxBRPAQNDr76mJoaiksj6jMQkstGBQgDH4eodtdN+xDQPPY8FcqiS93Vdzpt
	v6TfvfRY1afnejRw7Bn8HZP7P7o5Uu/regcp8z2m6yGgLgtNNQIgAxzjSt3dXyMf+3vruqvTXpg
	UoKN3//ObiLsgraBXwsrjVnyY5IQ/P8mCdobEPVh0epNbH4CTtyHHgu9TOv+Rm6GgagTgFgeZD7
	X0GPhWTNvAQoxphq+ZNDM/R/bmqrZkfcahhwMH8yiQ1v/f6MQVupNie6HOAycKuB/ehvu3L4E1p
	IxoQGp85PR4LbMtpfMTryVI3im933u/TJnxrrNVs6I2qFmhSwb8c7qg93RdaIteRtRQ==
X-Google-Smtp-Source: AGHT+IHT/y2X7VZLJG0aOTd7F7Lm3MTvzdGjN07/gZK6mY+b0ugElWkhO5/yBySwP7PeM7XXLT+lYg==
X-Received: by 2002:a05:600c:548b:b0:456:23d4:4ef9 with SMTP id 5b1f17b1804b1-4562e0462d4mr19664965e9.3.1752703934056;
        Wed, 16 Jul 2025 15:12:14 -0700 (PDT)
Received: from localhost (179.red-80-39-133.dynamicip.rima-tde.net. [80.39.133.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e25e75sm18842595f8f.87.2025.07.16.15.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 15:12:13 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Nigel Hislop <hislop_nigel@emc.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	S390-ML <linux-s390@vger.kernel.org>,
	DM-DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add a comment about DASD arrays vendors
Date: Thu, 17 Jul 2025 00:12:11 +0200
Message-ID: <20250716221212.83597-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

vendorid for DASD devices is always identified as "IBM",
but EMC or HITACHI/HPE arrays are also supported.

Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: S390-ML <linux-s390@vger.kernel.org>
Cc: DM-DEVEL-ML <dm-devel@lists.linux.dev> 
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c4bc6df6..a2fe28eb 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1669,6 +1669,7 @@ ccw_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 	if (!parent)
 		return PATHINFO_FAILED;
 
+	// Identified as IBM, but EMC or HITACHI/HPE arrays are also supported
 	sprintf(pp->vendor_id, "IBM");
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
-- 
2.50.1

