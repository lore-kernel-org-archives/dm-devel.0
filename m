Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A8E317719
	for <dm-devel@lists.linux.dev>; Sat, 16 Aug 2025 18:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755368189; cv=none; b=jzv3AsiBfcBVirFkTDrVR502S/5EWTeSl9r92YcbC2Hft5u29ji5/lUMyzMgpJi2+T7e3DqD+k32z7idQFl6gZ3nhw9bnR2WR1kfIexCzp2eCsqxd6gXqB0jQfHXzL4FwtEmA6HwMy+EwQcK1xN1HJpJaVEpHuy8ZNBxw0Fc8wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755368189; c=relaxed/simple;
	bh=rnDavEjvVPD/XRT18zhQVKoCg6CXkbBMGxDjlWr4tHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gW60MwW13gxSNpL2lFD2mzLK2I/5GQkYNy+oR6B3eMOwAZUhQ7UQiwGOcCwUwgXstMsil/NLOln0PukY7kDlv3ztC5GBf8YrxkuHKEwbx8TFZj+TD8T8SZBmR5egj7oiyOjhscmlWEy6fCKJWHvQjMtqxE4CtSZ5fXtbuGjwywk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kM1nSMQO; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kM1nSMQO"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9dc5641f9so510064f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 16 Aug 2025 11:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755368186; x=1755972986; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wWx9SKLImVaTdNLbgHbz/EEEhxgHbVX38v0gaA18a1U=;
        b=kM1nSMQO90BU2+fXHO/yUY0c6I3DkAjzQIlUjyLAfZHAbYv/1BsrT4Op8Er76rUkaP
         2HvWPQozfyP8Ft7X2j0/nmusyFFyo2wZDme/10pDGiMesk8lZ6yonM9/BOo7POfoWq4u
         SkMAhImrEApEjW6Ke/WzvtJ9QLzyg5NJJO2OL7y1NkQOonSt7mF5OHba5/xyP74/MsHz
         rqnj0Bx55fKl6TxnJo+ps7ILSlkZPYizF9mDonRBmmTvRuTaAny3f3P5oCrbihqMRLw7
         i0y52wfiM79sIfCY6zi4vSzVd0kFkO2tFkLgbkH+rmq4Th+g6RieFv6aEZQC6++PYewi
         Vw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755368186; x=1755972986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wWx9SKLImVaTdNLbgHbz/EEEhxgHbVX38v0gaA18a1U=;
        b=Cp2kk7HLTnp3FVaVM2XXIzgWKcmumEmR8yNS7q+JpzhhMBy/xi0m1IwWN7ezf4DXSU
         S8RHNwlUkyTbwritLrqVCthWiIQ40BCUN3WA0iYRq04/SL6qP5d0Ipgy4wegJfz31R6t
         PELd4SWlWs65PzNzSR6h571PNCdTkb+xS4iqLwzJKV/Np2tENMOa7Xlk+tvPHLDCfD6U
         3O4IjftD20FRziMXyq3jZw2UbF5bPmExsGAbXn4U3DaK/j9e1N8Jg41NuKy3qyzXu/Gf
         W5KpdQ/w8PDJcwowN1Ow0d8oWfq1w5DG/e7Y/urdgnMRsM8dJIkW+2GtZq7CgrEx1dnT
         YUcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhKnx/oB+N5hahvZF9AFYFKTURMH82u+l+J7odaNHeTrm8RkHU0ViK4DCghP2KKrNVUjtaXJh5Vw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyXrOf4AzrB2iI/TJ+vWsvBUSuGjyMakVMkcffF6mYuDUh2qtoh
	Xc8noiwgUifmygryu+To94ZanLCQIpK6o1gsP9pq93qRGlnYTXeJ/Ng=
X-Gm-Gg: ASbGnctLoWAsREbpQpVjQyr15oHSex6g2htewJ6qSZWxYwggI3LcSM6CtsB/qkjKb+E
	XiKMHaIIcLoddHiX1lUNJtHREnU2a8B6s1eAWQ0Sej0NQtnvD/Hcwv8UfI/N63qZWTMbeOd/E50
	f1O1czDonyqcZ2807HzvDYpbh8whSgCNAy5kgOlU9vQ2IeyCuOKih741cwV9AnYZZ1QzwcErZxO
	+UjOBCe1HkPTgnL5gkJqamJE9nUVG+y2Eas+YqILeZAiCKKfkSSLQv7B7cgx3KdfYlxMF6t8Bnm
	nA0gq+qWyzgCeuxZIeMNSqMcJAKQJy6gzkkop0B9gQXueLw7C4VuiDJfEkrKX3QkUcePFvDKLNN
	EvSyaa72HBwu/KN6mnwSxPFJjBycTZ2NQbJ9Arurqt1gBAIaGdkefXBGlMG7vnb9cBj8lJYg=
X-Google-Smtp-Source: AGHT+IGyY9OmzUvdrMQYNekO9mvlGC8E3BHvyGW2vGdilDjYcZOOHx8zD2ed9taSNusXjk6PKKMDMg==
X-Received: by 2002:a05:6000:40ca:b0:3b8:f45c:b60f with SMTP id ffacd0b85a97d-3bb671f56d3mr1985460f8f.4.1755368185600;
        Sat, 16 Aug 2025 11:16:25 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758441sm6592951f8f.13.2025.08.16.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 11:16:25 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: update NFINIDAT/InfiniBox config in hwtable
Date: Sat, 16 Aug 2025 20:16:23 +0200
Message-ID: <20250816181623.180892-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

New recommended values for SLES-15, RHEL-8, and Ubuntu-22, or above:
https://lh3.googleusercontent.com/pw/AP1GczMchJ6bcMIohp_g3Ik5DS6BZv_IW0iwaEXf968sJsR8fr_p3mR4ThRpmHpZE_VMnlcV8j0uuuI2kz-eoqekRCUBxyTBKS7n-4WFMsUiecq8i7nIjEuhfZFrV54DBQLDzGt6ofakAAF1L-ZcAuCWW18=w0-h0

device {
   vendor "NFINIDAT"
   product "InfiniBox"
   path_grouping_policy "group_by_prio"
   path_checker "tur"
   features 0
   hardware_handler "1 alua"
   prio "alua"
   rr_weight "priorities"
   no_path_retry "queue"
   rr_min_io 1
   rr_min_io_rq 1
   flush_on_last_del "yes"
   fast_io_fail_tmo 15
   dev_loss_tmo "infinity"
   path_selector "service-time 0"
   failback "immediate"
   detect_prio "no"
   user_friendly_names "no"
  }

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 20fb67a3..aedf4b88 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1134,14 +1134,13 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NFINIDAT",
 		.product       = "InfiniBox",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = 30,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
-		.selector      = "round-robin 0",
-		.rr_weight     = RR_WEIGHT_PRIO,
-		.no_path_retry = NO_PATH_RETRY_FAIL,
-		.minio         = 1,
-		.minio_rq      = 1,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.flush_on_last_del = FLUSH_ALWAYS,
 		.fast_io_fail  = 15,
+		.dev_loss      = MAX_DEV_LOSS_TMO,
+		.detect_prio   = DETECT_PRIO_OFF,
 	},
 	/*
 	 * Kaminario
-- 
2.50.1

