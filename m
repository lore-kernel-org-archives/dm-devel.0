Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B218735E1A8
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612963; cv=none; b=mmElw5FnJXrR0PJ749+/wOp4SzDOgGAfgzXk7UTWHjtZQJD9P4wBYhs8SzhEuvPefR98gvo7hxQrkCMWpW4bj93AnqYnVx33DD9Czz1LOOZf3CfHier4zU2xCaEAU1Xh5jBa+AvX2BWIrnnunk98UHyl4EQvF7GHADNjeVcT0Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612963; c=relaxed/simple;
	bh=MGD4sJqi1J48Ftq2SqhnnMm/AFUZLHFGgTuBOtTcx5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHO55bhjICxPt4p1Wg2FH6818JspRiaFUGW9Qkys2CtqzwqfFLb4RoSXmS33ajpLV58YeuSrxAn++B70kQBhB8Nc8MMM48YI3IPUQQKFlP5C5GW4pXY3/gGgiEi6Q10InZ2LmH7bIS2566nyrzMv3f89zmFEBZI8tzA3OnUqwHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsEyZjOf; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsEyZjOf"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490a78fbd7bso4711285e9.2
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612960; x=1782217760; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VVhi0QbnR9vlwqKq6lxh+5FyacG0zRP5mZ9muyK/6k=;
        b=OsEyZjOfshKZyk/0ZbZEgZUba5A35DpAIJctZ5dTpQn7Xv/QJOEzveEAITfhCI9NJH
         leGueQmmsPuSbBH1BLuXavIukUpgNTxFkQiOzA6Hoy4Ri8fxXWAAtUCQVpSNpDS/zl+D
         3uZ9kw6db6dmAnCKiR9Id2PrK/NOT874XgH8d5wrQGTnpaHaPqo+leMlNxPI2CSNgTux
         FzCONJxLLM+tE+14Bq452B3PQqthLoUmcBvbyYqYrsSLgFjUvhrz4qnfgQagWoBqm5sm
         EEIcm/gP2Zh1cm+f6UyJERzawI6nUuKYlaH4jgivJD04sSuERT/KhTpiifsERVvJSf+f
         J7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612960; x=1782217760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/VVhi0QbnR9vlwqKq6lxh+5FyacG0zRP5mZ9muyK/6k=;
        b=kzgRWTXIZCnBFfFjzRx+J4ecnINYTFKzMY45CfrMI9N0OPb0+XmtX4ONvJIZ1b0X56
         DxjbD2uVJiNnDbfOxc82reQVDUgsoIHi4gQdEQc5aHGksC1Rw2AfxNDHdroOGPXuheMw
         WXvCNFYiP57gSsI73NYbKazLBhv6y4ak6rBqRXa6oEAiL7Xw2j92r0HG/rubS/4eTRaC
         jdY5vR7tdw/gEAxNgTH/fFGObD7vj1IJ1xj3oLoQ9X4BsNvYWkdT1TvNAWNPXw43KsxU
         AnUnyD8L7hw6reHjN89RHp4thO69ufF6T8FG+scPJrt9CAG0RmmiNsc/QpiGnBsXCYi3
         5MWg==
X-Forwarded-Encrypted: i=1; AFNElJ+148Mj3cDJ1EBYWbVfsMACSDTtCIjzRiiBYOw3HiO29mDHarvrV6LXcEy8zWisYzimSv14G/q8Ew==@lists.linux.dev
X-Gm-Message-State: AOJu0YwsVA+3nqNHWN/81mQW3UPWdiYzEUXhGNs9UQOzqb5B2p3J1xWj
	izE2tmO3huhX5bYSzWSE9vGxvOiUrokxLsGhkCBYaljgTsUcL918Z1o=
X-Gm-Gg: Acq92OGXR3vKM+YmyFt7gYS2LVSCj+jUndyke4ui4aT/el155aJmYGTEv5GfQEzfkdR
	HrPOGDclyAtFlINkZn2gTXxHUjN0A/AiuPsDf0E2eVDAwICKv/1KMyJ2CQneoR/xrDGTkj871Jw
	sey517U2W6ezwZ67yjQpfuJyvUYcM2bpbtOLKakcZZjW1b17ASXdsCetnwsdYsSFvLas4lQEhFJ
	Ver+26UCshFUDxoyRRmH0iLOQRY2vrQaVIqFU3gbIA7nQ8R3QQAszXKO0AfpN0UCO4Vs7XoFDqe
	Uohgxru4PTFAoM5iUKgkJvksI0gdk8g/VU7K8WSmd8thm9VTsF7Gv17Pu9u8YK/epdoqtvXFp8k
	AALuJ9Hps1Q5giQdgHvMZzTg3FsfYZTWXW2bE6TCS9AhaTrEvlHGfNt9FPOXpOeow3537hPEsSG
	dFEXOCm8megsnZNCV4BiGg3bDrGrlEIGYCXk09CSUSdClEShShPJ6DyMaZ+QAcLjK09mOyXlboX
	Vs=
X-Received: by 2002:a05:600c:c05b:b0:492:2ea0:c1cd with SMTP id 5b1f17b1804b1-4922ea0c216mr20609485e9.5.1781612960036;
        Tue, 16 Jun 2026 05:29:20 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-461eaa0d275sm876475f8f.2.2026.06.16.05.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:19 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 5/8] multipath-tools: clarify path selector descriptions in multipath.conf.5
Date: Tue, 16 Jun 2026 14:29:01 +0200
Message-ID: <20260616122909.244619-6-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616122909.244619-1-xose.vazquez@gmail.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Selectors operate on the next individual I/O request rather
than a "bunch" of I/O.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: fix typo, s/group/groups (spotted by Martin)

 multipath/multipath.conf.5.in | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 422ab120..5b730801 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -2,7 +2,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2026-05-27 Linux
+.TH MULTIPATH.CONF 5 2026-06-13 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -193,20 +193,18 @@ kernel multipath target:
 .RS
 .TP
 .I "round-robin 0"
-Choose the path for the next bunch of I/O by looping through every path in the
-path group, sending \fBthe same number of I/O requests\fR to each path.
-
+Choose the path for the next I/O request by \fBcycling through the path groups\fR.
 .TP
 .I "queue-length 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
+(Since 2.6.31 kernel) Choose the path for the next I/O request based on \fBthe lowest
 number of outstanding in-flight I/O requests\fR to the path.
 .TP
 .I "service-time 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe
+(Since 2.6.31 kernel) Choose the path for the next I/O request based on \fBthe
 lowest total size (in bytes) of outstanding in-flight I/O requests\fR to the path.
 .TP
 .I "historical-service-time 0"
-(Since 5.8 kernel) Choose the path for the next bunch of I/O with \fBa dynamic
+(Since 5.8 kernel) Choose the path for the next I/O request with \fBa dynamic
 algorithm based on the historical service time and the number of outstanding
 in-flight I/O requests\fR to the path.
 .TP
-- 
2.54.0

