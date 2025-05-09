Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33637228C99
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 11:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790112; cv=none; b=AvyhsQADikPKzNZBU/KsELtmr4Ii7LzqmMPkUoEzPtBTO8i8kcE8LC27+15GUdpxzYJrOVrVz0qFMr2Ba4VW2esTBFbiMC2l//XKLDqWMbOzYopO4Oav3IzJ9l7mg/AnfvVOa1qmdrEXY1vvWj1w6Non+K+kt8Ffr15//ui3YS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790112; c=relaxed/simple;
	bh=tu80DNVpnz5t4GFcZzC68uNGZVPr5QrMESsPNH/bqXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dtaVLyJv5p4qpk9CBffYd7s0OQyheumyjSaFLz6nVFoIZAUyYAnAiaL7UC+qynD7DL3N8GZEjTepP66q7Tj6X0dL/hqDzDb1JVM6Bv++4SC7qF5z8JXlKok86rIMo/DBiHkPhbtpmUHze+ubYdsQJBmbg2/foAlBTraQSqDT670=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GzZyJTkf; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzZyJTkf"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a0b4c828c1so261052f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 09 May 2025 04:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746790108; x=1747394908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AbyRapRzhznsq/jcd9lNfW+7cJJS4148F4Ep/+nQTsI=;
        b=GzZyJTkfavD3t00WM1XUnKXFEwhqCcvRBfiQvKCMuFw2yZ8XHmEf9dpFMJ8clIVzsU
         37xZLIJhCkqVmHLOaL2Tryv9k2kklQXvOiFSaYip2PyUStQeMg8vfDb9E6vdJhSkzN3o
         O6UNtShZj+aqA15pXxCzHXpg/eaOKB8qxOmT4wnp/Vjg52SylEPtqekWBY5P5IDdbL2P
         8jEtt1oLkBFATjg5pbOx/2NS2Ogv/jD9Sd1YeBdf0Mx2q6qYnLBMY+XP0lZDGorWu831
         Dmk5OK01iXCVtAhLmKkEED7v4XKcDuAE3PjzS6oqWj+SJt/hudHH/0ubxXIeKgyTpUWj
         QonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746790108; x=1747394908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AbyRapRzhznsq/jcd9lNfW+7cJJS4148F4Ep/+nQTsI=;
        b=TGHUKMd3lztkyXzW1amlUoE/xaH/jeaLSL1siEGl0hd2l3Xf0WdE4dkpsd7VQD6J93
         mC3LGKoEQ5niiCapuPnbeyeVgNRLwEJzxWuSvJM01m5uMths3bCNpJlaFADLBqEunGQv
         8oQF1HCF/YnPyoNe1iP+pVMe9cf5H+Aa0N3mCmPdHeNlv9bBneUZbseiCjO4q8HOwv9t
         0FfVbe77KSrjkrXBndIGXEVMQGAPY0EK+7WxMt0LWRyy7Pw7IxEnaGyYLzErt9nZ8gtz
         DYMLybY5E+/+QahbhLn0NhLdkt/fAaayizzAimcN5cJ1qteJPuDgqhPGX+ZJ4BLIt431
         dlKA==
X-Forwarded-Encrypted: i=1; AJvYcCXUxfCJRgOdY0Kz0EIkMysDPzAUNMt0kWMGkzsJdSOPLEZN7LM0Q5bkRAMzBksWNnU0a3zjpxxXpg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwBq+WyEQU1wR2kwrNQrScqypx6EiJk5A3X5tGglDwHYjZqvMye
	Wz9MkWFLOwaFaOADepk6rFY7j45LD4tQrroxDJGTT0e+sWZHjLM=
X-Gm-Gg: ASbGnctwse5QHWOsoMoKTbM3wqJOrn9JdHREpXgMP8YicnkDIXvlZ0Wp39TpV6qdPV1
	K0/x/nBXzeyW95N36u53k9KXq2TArVOe/wLlcLfD3gBuPSMghm2jOuvu12pYwUkMxSA+ej9PcH9
	Y8LnU5bo2Nu3XA7Jn7Y1UxUpPU+1YjHQWRuPJNmVcdAO5ZrPPlSlP+YrF2ydvkwZWFe0ZD5KaeZ
	6S5ImXzzdEhvK0cr0uHHX3yg4T0+CypR06vswR71hU540LdvqHmCNIvUYx89HqfrSfB1sz4ExIb
	V6Ug2dKriO/IncyQD8AgRt1EO78+GeC37VZnUd3tZdelRFT6XFR4ST0vsKFa63BUp5M4Hr0k9dA
	J1/PlFEug
X-Google-Smtp-Source: AGHT+IE5h+4Bg8qZyaJR0EY/RsJpnNske/bd70rHX1jav3JUUD063ML54O+IY2WyVROlldONf3mOhQ==
X-Received: by 2002:a05:6000:420f:b0:3a1:f535:e9bb with SMTP id ffacd0b85a97d-3a1f64328d9mr967043f8f.5.1746790108277;
        Fri, 09 May 2025 04:28:28 -0700 (PDT)
Received: from localhost (236.red-80-39-130.dynamicip.rima-tde.net. [80.39.130.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4c78fsm2984553f8f.97.2025.05.09.04.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:28:27 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: update Path Selector descriptions on the man page
Date: Fri,  9 May 2025 13:28:26 +0200
Message-ID: <20250509112826.160900-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
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
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5.in | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index d0f6c6ac..9884df93 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -197,22 +197,25 @@ kernel multipath target:
 .RS
 .TP 12
 .I "round-robin 0"
-Loop through every path in the path group, sending the same amount of I/O to
-each. Some aspects of behavior can be controlled with the attributes:
-\fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
+Choose the path for the next bunch of I/O based on a rotational distribution,
+sending \fBthe same number of I/Os\fR to each path. Some aspects of behavior can be
+controlled with the attributes: \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
 .TP
 .I "queue-length 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
-of outstanding I/O to the path.
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
+number of outstanding in-flight I/Os\fR to the path.
 .TP
 .I "service-time 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
-of outstanding I/O to the path and its relative throughput.
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe
+lowest total size (in bytes) of outstanding in-flight I/Os\fR to the path. If
+\fIrelative_throughput\fR argument is defined for each path, it's also used to
+calculate the best service time.
 .TP
 .I "historical-service-time 0"
-(Since 5.8 kernel) Choose the path for the next bunch of I/O based on the
-estimation of future service time based on the history of previous I/O submitted
-to each path.
+(Since 5.8 kernel) Choose the path for the next bunch of I/O with \fBa dinamyc
+algorithm based on the historical service time and the number outstanding
+in-flight I/Os\fR to the path. It can be tuning with \fIbase_weight\fR and
+\fIthreshold_multiplier\fR arguments.
 .TP
 The default is: \fBservice-time 0\fR
 .RE
-- 
2.49.0

