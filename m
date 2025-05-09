Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E0F25E820
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746827109; cv=none; b=OfvYhyXhbYBj57Yi2UlazVktK5TZdkLmptjGySGwvlfLSgdDrTEA2z+3ZFWljj08q6AEJr3IKrCfGxhV7gRpbi1L2/U2aXvCVBDdaRwK+WUxm8MrVc/+vvVe3Vs2bS5X7IElkdx7OPB7E7FtI9VKkaVV9zXjHzg/8iITzW/8UYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746827109; c=relaxed/simple;
	bh=VF0CdObRzHySUu3yjZ1cxH8DYGUG2cPDiSNF+qdMjsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PjrolIRABzba6Mswwxw4z2R8K46qNqjDVwByuXwvmcZdN22+JUh68EEi7WJ8OCbAV0qCoghGOZtopaktVn99LJaCidPysTeXYg1TipEahRpQmaBLi3qbNOCcQZDjMsvLhrEgQgksT5Y/fnEEJQHyeC48WjvOmUWVnLu3flAjwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJsZR8mx; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJsZR8mx"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d72b749dcso2689365e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 May 2025 14:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746827105; x=1747431905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Iv1ZCWwCIvPIj6v3lUckMwJPub3FEAxnMV1+b1cBjE4=;
        b=iJsZR8mxj+91m4XWK98eN8OiQ0Oj8l/GbdE9Vomvq6dbaxm9DtDoVU+4cGf9hbpnAI
         6Lq4MwsqqBwBVCHgQ3y5a4Hh2txs/VAsrcZKdA1qpDfu+0gyUMFJoqhHOqyJr7f/Auc2
         BLLrzqzKtjGK9JqJrnI2eMPwU9DQcXFSxZsCGUpocWS3L4/5JiXlK4kq+NbFilpZ3rQk
         WKUIheIeZ4RaD9tQZONuReydwXNCXaahWlayAy0dVQPw8uO5yl7i5GtaYpT72Eg5VJNe
         Ebh3Z77GgW/Kg/0jEN8gWzBXkonVNqLCXXe1mTgJ6WWK6PQPv/+bCyuhCqFxCVXbfmBU
         Padw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746827105; x=1747431905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iv1ZCWwCIvPIj6v3lUckMwJPub3FEAxnMV1+b1cBjE4=;
        b=id2m9dF7kzINR/WVm5AAPjQ8E7ppbHOF0FhuJxa2w/4ZWJDEjoJ9ZJK8Xi5hL9XN27
         Ht99KR8SNoQe8VZr6dBH+AJ2InKqulB5GdcJQ+dzAKQKZ8zK6vYjSPHYAdCYhYRx4dlq
         Y5E1v9JqMyx8BHx3TJh5BtZ98IZ9+8t1qzCY5vmSvTQN7+KNpo/UwZY9zUubmmD6yT6U
         FiVcKCcG4FTahaHAm223PvsZMCvPwqZ4Qa/Ome3VMc5EqL0pbvWrAHS5TvIBJTbAiCVG
         lj/Mwy+RPnRyRlUuIf7OZK3RPzOXRcFlXNuaxQyvYyEtCxEf6IBUJ+4AaQG0/yjX8iui
         OgTw==
X-Forwarded-Encrypted: i=1; AJvYcCVEvh5KB4lQSyb6FdBEYY/DmK/U206Ap7rCRWwq+DOH1Vh8TlKM28b/Drtvgjt4LGHjLEF0vOP4pg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZvL+3O65RBEdSYDgEHawVVkRoUayOaCChfZFEipGa/fD7QMOw
	/2Bw0zclKVecge3niDNqzwG/X2gRHN2e/Gznt1ziRpk3pp8Ay6g=
X-Gm-Gg: ASbGncuZWj7WlG0YmE2sMMRTs5Pxo9fyGbV5aVK9YqKFVIvq7fVW9JgoadxoVt+Eh1i
	Cr6WUAh0/C9hKk8HQWSG0LFyJL4FKWYy1XjsgAIpjrqdA6cBzOXimU3H7Xm+rMj59wTH+SQ7b/L
	yrznmiq1e9pLy3NfNYEGRQQ2cWPNWTAN2G/UfhgRG1cLqjvsxYRsBoeWg0gPFt+45ApHB8GfOSy
	1WuIsthxpdCDtgEuS4zwPOr4kKjzQBWwp1HpQCPTT55++yyiqlKvRCP/JudGeo6res6FcQuYNdd
	/g+epawIL6MSkQXf7QHQC0eIKdDjmxu75xXGBFeIi5vppd8bjD3R/ipxYODBxE4bX+fUJUC1DDI
	b8gvBtmrIGKabdIbGdic=
X-Google-Smtp-Source: AGHT+IHghzgSf0eq7SKU4qcyQmPTHjj4PCz4WfNMlzgw1tkSvri9YOhkL/Bp67Ac0g4QVZTrGB7HtQ==
X-Received: by 2002:a05:6000:1ac9:b0:3a0:89df:3b91 with SMTP id ffacd0b85a97d-3a1f64408acmr1528648f8f.7.1746827105199;
        Fri, 09 May 2025 14:45:05 -0700 (PDT)
Received: from localhost (236.red-80-39-130.dynamicip.rima-tde.net. [80.39.130.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ecaeasm4396507f8f.28.2025.05.09.14.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 14:45:03 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2] multipath-tools: update Path Selector descriptions on the man page
Date: Fri,  9 May 2025 23:45:02 +0200
Message-ID: <20250509214502.334826-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

v2:
at Martin's suggestion:
- change round-robin description
- replace "I/Os" with "I/O requests"
- fix "dinamyc" typo
- remove all path selectors parameters

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
BTW, service-'time' is a very confusing name.
---
 multipath/multipath.conf.5.in | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index d0f6c6ac..f1158f7d 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -197,22 +197,23 @@ kernel multipath target:
 .RS
 .TP 12
 .I "round-robin 0"
-Loop through every path in the path group, sending the same amount of I/O to
-each. Some aspects of behavior can be controlled with the attributes:
-\fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
+Choose the path for the next bunch of I/O by looping through every path in the
+path group, sending \fBthe same number of I/O requests\fR to each path. Some
+aspects of behavior can be controlled with the attributes: \fIrr_min_io\fR,
+\fIrr_min_io_rq\fR and \fIrr_weight\fR.
 .TP
 .I "queue-length 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
-of outstanding I/O to the path.
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
+number of outstanding in-flight I/O requests\fR to the path.
 .TP
 .I "service-time 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
-of outstanding I/O to the path and its relative throughput.
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe
+lowest total size (in bytes) of outstanding in-flight I/O requests\fR to the path.
 .TP
 .I "historical-service-time 0"
-(Since 5.8 kernel) Choose the path for the next bunch of I/O based on the
-estimation of future service time based on the history of previous I/O submitted
-to each path.
+(Since 5.8 kernel) Choose the path for the next bunch of I/O with \fBa dynamic
+algorithm based on the historical service time and the number of outstanding
+in-flight I/O requests\fR to the path.
 .TP
 The default is: \fBservice-time 0\fR
 .RE
-- 
2.49.0

