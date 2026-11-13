Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574577;
	b=MxZ6p9QlvhzFhGrckUe5IwTgVO/kQvCaGb6TNRRanA+0lIjwKLi9netXX/qmbrTn30Fz
	 jKLV6HWvX2ma8Eg6xbhKOuuYjB5NAexnajQQfg0MzCTnTJlBJhQaG9ilNu85jEUvD5+JK
	 umGFMhj4eZHMk0s1CvaFAvZXTbqm8N9sBw9+h466b+77TJa9voq5kjr4W8gAwGqhCEBi+
	 P4iradELL2squbJmZkxB1y551z0LjPzN759Y0Giz8eH3J5Xk5//2IQdo5iaQzsPdnyAMb
	 6z1qfwRVJYsoEDUlz7vrZ8sXwERMfXtToWNpYoRcS7jcysQqhbHwaQdLIhMPVDCnQtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574577;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=Y/SC1eCPRVMVibRnfEnUIA/e3ESSwrxp/mcjoE6+2aI=;
	b=idlzpYJZ+/gpvAzEb3HzC2GCUSl6ZKVnTbNg91PjRn1gFcfFAnCxvhFy4M/u4GfbvT6n
	 4Vs4MiUiJ2DTSV1nzhZ9jYNSvqeqgmt8pTsydG1dSRk9sZEgb3o9p4+60mwIpOMDPSbve
	 GR/S87ws2op9KNWBy2FjCLRsW9EzcFktPyhT34U5RSgIk68Z38zS+HYXUqr/Pa6HU5SMi
	 zCPOp4Iw1fddnR1tuFU6QgLDePRV046IJSgQq2CgmYdGpeF3yDm/kuOJMOqb1WAhVH5Ah
	 MZiAgMgcE7OHSh/tm2t63K6O10QxGdsM4rQiFiqF2Ipc5/Qa9wBwylsux5e+pJ2mkBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u3L1Q4Cr;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9C9606A333
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B9C9606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u3L1Q4Cr
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso2973265e9.1
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574575; x=1795179375; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y/SC1eCPRVMVibRnfEnUIA/e3ESSwrxp/mcjoE6+2aI=;
        b=u3L1Q4CrRybzFhq9+/AZfrPtVMT5Yzt7lX1bXUwysIX8/Gdd4JfxaPzOhikoX4PmKq
         Lo1jwOO4WacdmJRyuJkPEsjdaNlFxp1XxKC5qXOzNw1mzGPHJLBkeKOFob/R+fC/tx0B
         xgcHLVFC+SXVIlDj+i8RwJOdz8P925qjINUDRYDTkT8Xm0ngV1lLKKZMTPd3aiXFKdtq
         sKr7cDISGyn7iYJ0yKHd2lNttPTB2yCJtTPqNPYu6P6VSFDGjd+Bpndr9MkOodm9Ltbr
         emJmoAoBpmUkBrsaXSGnSgB3ipec6O7E0pPzVpdUdc+xhqZ0oV52WEHquwY+KopPFSuJ
         uLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574575; x=1795179375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y/SC1eCPRVMVibRnfEnUIA/e3ESSwrxp/mcjoE6+2aI=;
        b=yKVRM1fy7A4VkhFV9pLHnWasyrChpyJZvfGETICuzUf2hh155Vc088lPrVyiMgVHlr
         zt2qEr3Xfts37lrfLCW5nJsFQpeo3nf2amYu/Q9EORu0Su/wOJwwSYsQjg0B8bVAEr6K
         mQO1eV9mVsarTkDXFpr4x14rZuRrGMNqUhrBS5D29yZhEQUIRxW+Q+zJeEnpO2AlhbFZ
         qWxbCtm5OGARlIOP0jeTGODl9zD5YLBDnGEvTh9EVsWgoyXvEE0MN2argDDGcnaBu0bL
         /CW77VmhewnCI2vBQCsRw0IX2wy45lf/bSOrSOM0KYRMpbkWJnaNstOtHbzbS0qJRQlJ
         FQVA==
X-Forwarded-Encrypted: i=1; AL+hErGwmtCuh8z5nODsoGbKkNLEvGb6cYW76kHqqEunvInm8085XhQjVttB6pB552NKnQMJtqZfXKeSnw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/duxs5YpaynkfzV2y55EHV097q8Q//TeXmFkkI5rQ/829W4M87
	oyIux9782JtSLfIr2htq40+1MJlSdOy/zPjhCmDbm4BCGa5ZHMmx/0s=
X-Gm-Gg: AYBFou0pPuchjxsHriZYBFe0pzRqt2bOtzaqlgWAYLtvWwSO9HYu+downlVUADT3cQv
	hZs4V1NLmwgTPRYip/SiveJyHszmXaOvPl256Un9yxdxp3X0uUNZbyWjgjyuTHpPq06oT6uEKKz
	2gpl3TkRqJuDZyLTNIOCk6IBX0bv06wAUf55Wj9SIN1CY75IMi4LL5hf92o672MJabeH1oMZYzK
	d2VG2HmJvZAhs/ZRW3HNbwEujwTD1TTuSpBnnnUWArY5TqalY6f4P6f2QX89M+M2WVUob5POUzO
	BTKYVvz8MIjQXa+ndeD8i3kS28IxVZqMySECxMksY6e090Hop4CwCJrBAgoLodicelkBJL9jdjt
	VwcqWwtOTiQczic99zxmzad7SZUXNm8FgtMQa7oMcR5RBp+AyakxdZqdi0gZfqEan2Rdz/aBqW0
	osYn1nENkjLXyKtTkW+uWTSQHuMSG1oAGXuMyU1f79dmZRv77WLW3x0SIonwEuNEHFWyoX/CKsY
	lISka1wIdiOyctACBtE9hg2bmsNIpK1Kj5yYetVkVARVn+PzyoW1oEOTOcaccVEdF7HjpSHr8zK
	GAjCWlLN5XIQmYIlV6A2Akn2NLdbbRAdiXWRYYd/QExdKEhRda0bomTDGyzLgDIPfA==
X-Received: by 2002:a05:600d:8642:10b0:4a1:715d:1913 with SMTP id 5b1f17b1804b1-4bb55a4b85cmr40456885e9.1.1794574575472;
        Fri, 13 Nov 2026 04:56:15 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56f8d054sm33979235e9.3.2026.11.13.04.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:13 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Bart Brooks <Bart.Brooks@Quantum.Com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 06/13] multipath-tools: hwtable: update Pivot3 maintainer email address
Date: Fri, 13 Nov 2026 13:55:38 +0100
Message-ID: <20261113125549.504780-7-xose.vazquez@gmail.com>
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

Cc: Bart Brooks <Bart.Brooks@Quantum.Com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c9f12b26..a0befb0a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1013,7 +1013,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Pivot3
 	 *
-	 * Maintainer: Bart Brooks <bartb@pivot3.com>
+	 * Maintainer: Bart Brooks <Bart.Brooks@Quantum.Com>
 	 */
 	{
 		/* Raige */
-- 
2.56.1

