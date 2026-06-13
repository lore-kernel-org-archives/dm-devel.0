Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2FB26ED46
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781356208; cv=none; b=efNZU5O08Xws/O+yosmDVzhbX+l5yhNA7nZGxLZ0yFY69w5q5fhkYGRYu0Gs1ZX9A8cIVaRfY9weinCSO2AmboE9cFa8i+/wzHZ4L7H8qturFLN5AY6tc+cSVjVT8TfNivY3uJupWNQFG3XpuJIgp809C1OseFkIEbyUtXJI7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781356208; c=relaxed/simple;
	bh=5heY7y7nWVBd2d5lGZqjKLz1DjAJNf5hizgtnuGhLY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itAOjx8reEiYpCEZFjPwI2oH7eSSeNqlX7PuNub8PAW3Lbl0bcmJNwT5YwzPnAXJcFmE2JTWOehtrfrm2SlU4u7q4L/mzT8IuAdRp65CI8vU0C1h653oqkRBHw17u4FtrqdaQadccfKO0734GD2btqJhHpVGV8OB51kbIAR79R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKw3VR+h; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKw3VR+h"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490a78fbd7bso2139325e9.2
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 06:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781356205; x=1781961005; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zl9ZcOzKlg3knkATN4lAe1O25NVNDEaw9K9Ekg8S6Sg=;
        b=mKw3VR+hG+xNd/FZ0XAVGIaeuc0ZHghOpQR8IMCf64a89t5DMYr+Te3cLiG+UD44GN
         NUPteGOaei2EdnNwvgUZk/dW5QtlsGej+GQRslgdYRewtAgTnZRb2l1JuS2qCO1lGLz6
         iDjIoGpwuxjxtSvI06a2P0P02aujPnu4n/mUsWcy4DwMg6Rc7d6MLCP2qsXS95SrbkRG
         0sB5qBKiGRriohM71oaJApg6MBK7yS6wCHPsNifWXjDKD+tkcaT9DLmTE2yRG7rykQZM
         TKZFkynHB9t77Xe3Ue7Uuahrz/Sc2c4TUphWM30lDSX7CIHBjqFCIQpH4Za/gx587sND
         Zbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781356205; x=1781961005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zl9ZcOzKlg3knkATN4lAe1O25NVNDEaw9K9Ekg8S6Sg=;
        b=O8XWBGtYvrw4+aXH7ERvVggqQViQx1TPmiGP/UheX146c4lC1PgDJxVx1jJHVTRi8z
         Luz8FOwYuWtT8L6na59+5FZ238xaxYiOVfFV+nrBrMKbaLiBOPmf/VYqw2CYeDcL/Bgd
         Bl1aw/dszbYIAH3bRe2Ys4NUf+uTt2xUzHS8IyV5r03Eu/g89qp9B49OxKZLLDTX71Xy
         auPMR2y94Zk46kpURDauQNp7atXT40nUelaQZXJ44P7sita8OSaEGJ++WvunlbyM/UI2
         VwQFrw4Am8wLvqw53ROxGxSI3hfR5gD64UMvFs1zpkTqfkzWfxnVxy+au4m+qTiKxa+Y
         M+2Q==
X-Forwarded-Encrypted: i=1; AFNElJ88ltec0vqEv26p/u6J9I4s2GPiakG05BPLAFxMG0gd0fHKgyQ8wif4k8NTLujs/akon8Mbd3tcUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzWK8K8cMEDWt2mARb7876Cp+SzF6N7UCE2aNKcAIqOpG87uLTw
	sycSrnqlqV/SfKNa+v0F/TaylXevFla5s/IY84vfcweMET1fNjS3O6Q=
X-Gm-Gg: Acq92OHxeOsmJM863Z/P6m/TM+bV50sxi3hUxLP9BnHNQoSuqxyISACzo2t08TJpFOo
	8sXLZR2fbwbzVx2Q/fnwQhjefyeam0aPLDNfzH52tipgUwYU4hQBcP6ischCKA0V1Z4I60VGPQj
	8kzF6k0nH5rIuR2Hv0znHhng9mlm1L9biMYUhIalNkvhrbOzeNHO2VX4eSOYB5Bmakxi15Md/on
	g43kEyyNvri7mDSef3dDHdW1IJ1sL6XWk3qVSF+1YStV5x7pZUPh2ytU063bxdePKvbt3gAUCjf
	M1dA8OEypFTCVoSn/HLfbXz7v+2wuI8yKHgjtApvW6Fw/ZL+pG5kqZFWxkmeX4k6A1rbXGr/jRF
	esHEVn5v6l37t4M3EILYnf1AC5k+8OmMt3kCXp8I+EKy1PAYOWL3CMVSJV6zYZLA2q+raUqKeRq
	RAtD7SikILP/JIzmlWGWpRb6EzJp6Cos14jAgnhRLu3lfFqxx/o0CYxohzHTsAVYw8
X-Received: by 2002:a05:600c:3550:b0:490:b4d4:5c16 with SMTP id 5b1f17b1804b1-490ec5320eemr45690785e9.8.1781356205400;
        Sat, 13 Jun 2026 06:10:05 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3782sm13560274f8f.25.2026.06.13.06.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 06:10:05 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/5] multipath-tools: clarify path selector descriptions in multipath.conf.5
Date: Sat, 13 Jun 2026 15:09:57 +0200
Message-ID: <20260613131002.144263-3-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613131002.144263-1-xose.vazquez@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5.in | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 422ab120..287441bd 100644
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
+Choose the path for the next I/O request by \fBcycling through the path group\fR.
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

