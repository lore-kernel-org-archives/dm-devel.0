Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574570;
	b=dJNjAGxTC1xknviAFLDvwHOGbZ3k1bE+g/k33Ed2TZ5FxAIVFEm7C1654+7fJDrOsD+s
	 JR4BVDSP1tyifca/123ccksRl6ZgTmSw0vhJei07FyMriyR+q9nJj5T3P7HdUkwgkHEtH
	 QGqbIGwCQKUDiTsRZ8lNDwLwAYQP6h31QXj7RuohAoNWfh67ban5ePN7G5gJpiAl3rR0v
	 LNYDrqyJ+fSEeSn+4Ubd/VSJ0SX/SVF6p89q+FKxS8B+lqVR+FNMjUxH/w/4NAxTkwV7d
	 nXZKdO6Hu1LH3jlD+76QPNOyo4oLHwtdBRmMIruPQtVsE5V+N+hgxfBy4PKCX5ZE+ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574570;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=aXBpUm6DG3r6Ryboj3dKIc89a6d7jg1zTV4kkzvwm2E=;
	b=wUGy3xMLGwXhKEvEw1rN89CuaLbf05XEQyYKqwJbnGe/bpu4EdMn30SAt5vZHqdRAIil
	 mrsx0JCDUjiZirEwzFWymQJsG16YFnHJ/w963jcpjoqOd8fdq5kshXRm6bsY8C5NufkIM
	 LN2Bbj3cnXYxMCN7AO2zPbgdAZABBdxJTPgEUyp5epiuNgpGAksBiaTNm+fQoyeD4YTxG
	 9PHmAMrZ741ZIO47/IHBGdoY1lN43QrGn/QZN3uc28smZNByhsFgkHRX3jj4bzT4w7ePq
	 +xosV/+e6/Q2z8GKGD5e6oHq3yPfkINvRWBLyuNS2WrG5jsw5uZZ3b88OaHkYAu3b7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vUWN3Kbo;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA24606A339
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFA24606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vUWN3Kbo
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2119feee8so1207105e9.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574568; x=1795179368; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aXBpUm6DG3r6Ryboj3dKIc89a6d7jg1zTV4kkzvwm2E=;
        b=vUWN3Kbowqa3Nu7SamHzk7Pj466dh8cfIfd2wYIRMavsSuS3G/GKjPlHlZe/4lM7MG
         0zJ+8nDUiaticlTrrXD6OXG6Sp3sIUYExAW3xBE9Y6fKwsAvR1obxQy5qgX82k/n3xe8
         2VC57RM2ysEM1/WmOfMgTJk6eHGQ+I83arhfWHpQP8PU8pJxXlWmqLFtrnmFf9LxmA9t
         7xGB29nQ7jPmNsvR0PcIwMZ/Koohui8OUQSiWKoJjwdUQ3iNb16m3C7xwoVTFQC1zpKH
         z2lfkPzidbiSwOa6TQdOTocO+nngwkW5bT7RZzwrh3th9xIWmTqDItScvAFyqjTeeb//
         QDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574568; x=1795179368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aXBpUm6DG3r6Ryboj3dKIc89a6d7jg1zTV4kkzvwm2E=;
        b=wHYIN37lfDOuem1n2luX+ZWuYd4vksKEIruorPbUEpHdrpwD1q/PdcG3vDVrwICGgF
         NW/uZM7SCzkq3caPiqUbqoIRBHgnJGlz3tiAs5DYtIFzKR62fM/g9EKWLbdID7kvu0Y3
         bsdSI4s8/SoENscuqzaISy7zNNL4XCb49q3hcXt2vJOIlhcdIH/W1ZmSB+zK8i/iRPRe
         HzZKw3AUC0XTcr2X8lNB+rDvm32NyXy67/SBhFo+G8jxuPgBe7kWycG0jNrjK4iPlMYp
         nVYQLgvO8uzFbd+W8MeioRLmSU77BH3TDyC3GinVElLUyQcc2UHZdFyf+MTTuxyvWDkz
         eIDg==
X-Forwarded-Encrypted: i=1; AL+hErE8Oz71P3/xI+bZnAqrzI3OvjR9iuTAIERzFj+F7dzrgjEi51EMhXg4+VbjMWslJ8o/dHM+5yVxsg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+/SPZRpTHkt5i89o6c5iaQo+oHvZ5G/x/UjR0OFdZGv2W90dg9
	EFKjCPSv+Vap48QgVq0OBemloBdflHMtCV4NNkDt5hkMXvFBTtS4BEI=
X-Gm-Gg: AYBFou3eqSGpfXxsYEJQIF0/S19oa1FnayrkqdsdqZa2Ef+PPyK33Y+oouy83ECAdQ0
	Js63N4At00jjRPaXaZYeIoYpanjSNiq/cMRvGeeiJNGUS0nJV7cVM23NGYN/abkLyWwV5nFcKzB
	Eb+Fdggq3iyIPr5viRCUJf4Rj5Q8aF0WAGoVtJDnBc0av0HOEx9E4IBBJtUnKf1BMpnjBhKP7gK
	ZCFuOqibR1qdg107sPmJNiaRnv0v/7Rx2cLKjei9S/cmvvYiEAF5R24fSj/cErvbXYTqhQdXVOW
	5VtBtMB0C07nHqfOg261GRTjk3ZIQYpNNFAOZkWtsHdm/QDCiFfzIPYiorVEU8YPS4bZiyFaWtH
	yrlJm0PmkC/jnoxtd4F5IREEAhCtc7NFQRnWUYbuWuLPcbc9PQt6TEY6vsqKmj1S/aQKGlHPrib
	1QEdCqorYnvPIG87nBlmGIAYkpSN6mPJxuI8K0iJBPpJ9jd9F5cK2sFjU0UmlWJXiD6QW/sJ356
	hyMF2aOH0jxsSzn3WWOfeMcPA2gIF+eH5ZXLKAxE9AUMfOg91LbqP48c84qdm+4jDLOL5S46hxW
	5QQt6Du7XO3lL6RzGUo8GNZVNeSdwo7lkvB8fDFS3hWBe/LSpmZcmqVxhdLWLdDnup8=
X-Received: by 2002:a05:600d:644d:20b0:4b2:3c81:103 with SMTP id 5b1f17b1804b1-4bb55a3cf01mr40885895e9.2.1794574568143;
        Fri, 13 Nov 2026 04:56:08 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e28d0b2sm122203685e9.7.2026.11.13.04.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:07 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 02/13] multipath-tools: hwtable: make no_path_retry independent of DEFAULT_CHECKINT
Date: Fri, 13 Nov 2026 13:55:34 +0100
Message-ID: <20261113125549.504780-3-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
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

Avoid relying on DEFAULT_CHECKINT setting by assigning a fixed value of
60 to no_path_retry, in order to prevent unintended changes.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a8fbfa70..8ad3539e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -342,7 +342,7 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "LUNZ",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.no_path_retry = 60,
 		.checker_name  = EMC_CLARIION,
 		.prio_name     = PRIO_EMC,
 		.detect_checker = DETECT_CHECKER_OFF,
@@ -771,13 +771,13 @@ static struct hwentry default_hw[] = {
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
-		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.no_path_retry = 60,
 	},
 	{
 		/* 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303[ ]+NVDISK",
-		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.no_path_retry = 60,
 	},
 	{
 		/* AIX NVDISK */
@@ -785,7 +785,7 @@ static struct hwentry default_hw[] = {
 		.product       = "NVDISK",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.no_path_retry = 60,
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-- 
2.56.1

