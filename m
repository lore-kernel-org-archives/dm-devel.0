Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795077586;
	b=h5igTxql4ufp5VUOFdlDGMmPu/tFMr/YQBooO0FsfAsAZgTeBEUWMs6PwYvw8AWHWeRR
	 oYX6vWSAkBWkZNrzrCe+lWkrcNrgWhOvNnd1xvmsAt+GHbnhF7zZSJsS/qV/TN2B6OIs0
	 NLn0yVsq0MTBH7BvYyqpnUobVZN1d5cQypnNQWT7yqvFEpXVEIi3iO/Dqxcyg8E0fIono
	 4y97/cOZNHOBrjstuo3qiMrSA8Ehfe1JuSyVvJfQ7fvYQSIQXrO2irMD62OutiVTw9pnk
	 SeT+gDNnk6umkjSu+EuogSwl0CJ+aAyLZr8Z1yE3U4boZnGxDM2AMEcYWGnnZ1lwFQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=4z80GR7E/oj8Jzk4s+La8dms3HBSpmGy1dOcebi8EJ0=;
	b=QArtLLf0bMHZ3tnJ5k+FDf85DkXg4FaSyT05/RTTAJ/fR9oob3k241G77H7Zz2N7Vj8B
	 FPKL4Bk5Dur4wN7pVMR4CVuqIS3Mvbd2aSvBjDaNwu1nnUETvFyL+Kwupmzq8sMKbQ/l7
	 PSOHROQH4uBTKHnAobTJ3UQJt0vIxmQbMK7fICTOGeOIgYu1bzZfeQTWOEaWsFM3qbXb2
	 OU1DAaXOo0bQwg72Y4kI5FSCz7on05xJHjh2yxWYz7cGSUbqPO4A2j12jh/fnGNPTGkD9
	 E0qFN3Q5czDFgCc5xBbLWyeU5QuHee46BZreidHLS5PNDu49JZ3B7Wp0/JtriQaY1kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dpMsy7B0;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168B860A260D
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:39:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 168B860A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dpMsy7B0
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso3660585e9.1
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 00:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795077584; x=1795682384; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4z80GR7E/oj8Jzk4s+La8dms3HBSpmGy1dOcebi8EJ0=;
        b=dpMsy7B0H6FI8rmCZ0tMZjT6pJibKALI+XowP7eKpaPrnEKy1hSzVHsSJEnvlp+JHS
         OfstUEx5Waiqxu6PNZouItIYkY9SzF2gqgrmIYWhJR8bLqbL0eLHt9Z+eyaBYiOO+i7k
         MMRTWnVyjTrzE3VTvV6bn+St+fvydDU6BvzooiFJ3qXZ2laXSEwoBnM7Jc0gjQYci8Qx
         nW6xATM26c3BDsUYOY8wo08qKnDp5YrCHzsE1TKvLOG4QZTuQizlzTA0/zYjDkzefuiN
         yjsIZt6zOtKywKmNuUKqUR5L4U79+N0lASyAua0tJkmH/+NepKXEbtuBoVG9HF6hIBHP
         iyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795077584; x=1795682384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4z80GR7E/oj8Jzk4s+La8dms3HBSpmGy1dOcebi8EJ0=;
        b=BZcDIUufScIpuI0BKvgR2L407p0yZ5u5krcgpm8tKsH/1fmlqst7ptMRKRlih0nqJn
         FPVKhNn/wj8uu764IJw6UU5bEs0oLFdv/yPxn3U7a4QsanPm6JmxeBKtgiG/hOg6+/kJ
         8BXoAoa/eCDRvmm2zf+owqPwvtUMxtr00+gLT2keeLnhekVGZPxoEtVFRMvyBhETNIgM
         rWtMuYNP5BltviV2wbhUD2rlB49P+AIkmZl+H7qu+n9MKuMetUa9APzKD1NK/yv2F7dv
         Y4GqICOg78JaDo3u+2EWUG1eI8oSecXpI9yOp+RFkOnD6k0CsrO1s/r9WQiC+7lM8MRB
         mXOw==
X-Forwarded-Encrypted: i=1; AL+hErFwV/E4mhBA63Q4H5+sLm0KmEHimhEcHwwaNVM7uAbTYjbn0CoPSjf5dn/LNDXcsc4xfm1UIup5dQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+GgHZxRfz2lOj/T/eiDXSe8V5qn3pRZdk6s6XlZ/wul+xl442l
	HjkC+XW2bpO6SZZXfCMZZTXPQHkS4piPgclS2bzaqrC2ATysLjSZld5BnTiisCI=
X-Gm-Gg: AYBFou3bAS9gm9w1vMaE3XTwePaWbJmzFuHAgM/lGGwL68jNkX2Hv92Dcjewzn7SU7i
	RV1KfA+wr+D90U0ZxGSB3kICwaoxmO36fMHc+HZltv6aS10xnjOlQibmanUa3HogwVOaLBrAHEm
	Dw2I6E5kQLLO+3E7vKtgxIk0vs58i2Pb916xdnHR89CmT/xC6prHibQM+oms9GiZ1DquBsrg8LO
	0D+oQY/OW3Tr4jFqjp82XB5xIqMAibNObRuhos3qrqtHxzdPgfMDnSKr3D4yHpO/a9Ds0mT7MQ5
	ne5mip9ZyPVmLpc2a4I3fEZSKk3HTC2n/Dwj9mG0WgJXqqxtCicsaSaQSFG/1m+EUOW4DXM6FnC
	Oomo72bO5ibTst6h75PB9xGhWvN27jCfAcP5E8HtKnbWNXuJWTnYrfbLgSTSVSGbg27bByorfvV
	wkquzFOeAtRFsa2cFJlng/lm7RnqqgApQ0ZcxFBoJubGzW6MagIzHfYePGHONCefiMUfXd5OvMl
	JmCtK1y7ImDph1NMZSZCTwGdZ3xkXKdwjmeCF6FkMp/0QJN0awRw+JcrqYc7E7ZcCf2nH/a06tV
	0QTp3sVwMrVweNbMwo2QNj0ekimFNfInfikvQNBwgx4qsuuh/TyectivrFIr8AXRWw==
X-Received: by 2002:a05:600d:8642:20b0:4bb:732a:2837 with SMTP id 5b1f17b1804b1-4bb7d712f44mr76757495e9.1.1795077584250;
        Thu, 19 Nov 2026 00:39:44 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853ca452sm20551145e9.15.2026.11.19.00.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 00:39:43 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 08/13] multipath-tools: hwtable: add EMC/Celerra
Date: Thu, 19 Nov 2026 09:39:42 +0100
Message-ID: <20261119083942.194958-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

From "Dell Technologies Host Connectivity Guide for Linux" (May 2024, #102):
vendor "EMC"
product "Celerra"
path_grouping_policy "multibus"
path_checker "tur"
no_path_retry "30"

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: Move product description inside the braces and drop the vendor name
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index aab7bbd2..859a33b9 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -412,6 +412,13 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
+	{
+		// Celerra
+		.vendor        = "EMC",
+		.product       = "Celerra",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.56.1

