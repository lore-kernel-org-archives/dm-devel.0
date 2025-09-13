Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9D82EC573
	for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757768552; cv=none; b=Qi2BdbsFMd4gnZBKXO9xworMNdi3sIIIyVsXazN1SZmiD0VuJyl4eaXkO89foe3yF7ogTwgdjTYvp+Pp0HpVXCEL/4LHz3g8DtnTxUmFspBwjZJDYJxvbMqiEvh6rsX6F6QGMHHA2VceK0kTTKe4UYqbE+hxzRtKIGOcsaeG00A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757768552; c=relaxed/simple;
	bh=rQG9HTe33s5ZbpNOnpPgtyXHMgfM6a3j1vhugraGac0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXUvScSguROvmGQXG9GKhBhsM9lKniMxwMYL8xlSfIVcwLwmUAnOGvbjFjtkpDJdyTOCMOW04t7yCvtVS9t8geEWTNMrjTex5fD0eUTsi2QIOd2ArklVMolDGgiJoon0uPW1pOx1eWjQXW/1EQsEEnBYw/wM4zQ6fS+cAcPWRD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4k7FML6; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4k7FML6"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e81d32c0c5so10586f8f.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 06:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757768549; x=1758373349; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iApmt86QFvbIhA4B6XX3hU+Kqm7WocByEhnAmHWIsys=;
        b=k4k7FML6IrJ3FPtselcv3/vYCZNUPACl6j6yYcu8W4JTKhkLLMeOmCbsGwn8TrLBT+
         PYz2n41JQ+67ebv276nNEk+upiHM1zAw42uJUk6IFVERM+RaG8Xnq4JA8dppnyl02PEJ
         c2zmveXDnQNe8Bky5pMOmq5v1/wad1Ki/8eynmvXfALGmQOdPpdjFxLonf5HTBhaUHyX
         gDnO+pUzFzydCwwdalAH/Di4oQ+JxGECSALiysA2daFpJojavxdYUQLf/UsrkdqRG7C4
         1/tOUASzl0pdR8YBTz3CHO0IOpaBbXS09/GbLLq8CHsrt6aKjvLVWgKRZ1KA9rQyqTY+
         2DTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757768549; x=1758373349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iApmt86QFvbIhA4B6XX3hU+Kqm7WocByEhnAmHWIsys=;
        b=Um4KVL3UGLONQwDVi6fTK+gzBWWnlH9u3a8nV0s++lYMx0goAWocA62qKnElprfNiC
         TZKB12NVhS6wfgSv9NZT8O/fO7yrrW5ufln/41EkW7F1N8WhG9/kXompY163b926TPtH
         PcuqKzePbUyikSmMNtgbRlpSfgCQjh4YajafSqBtPuPb4cpz0mf9GKn8kSmkho+yUiv2
         11wRSDncRi8vUyxzveZK84S+Us5mNHwqFIVYMpbJp2HsC9sw7wWEEMHL3NXlzliy+jTB
         +zS6mwrDiVeH0sqEsK12jcaXCCfxSZxNwX5XcFyRyBh+c4chygnGFUu2K6AdgRM4undE
         1bIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNocJreXnDtukisXOrYyH1/eDDH/JTRstxhwiilV9TcN0fmGKz4CbKj1Blp62+62PFuKhPRKX2LQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6CRlkYxDwDOjp9lBupp6fbNEfNnWf8VxLWEm4TO3byNozdz9i
	UHmJkeujbVe5bvjTLhTm1dVP3rmE8DEUdAglgeQFAdkqL7c69/9xhHE=
X-Gm-Gg: ASbGncvKyKSq8/17c94luEwMtLJljtw/aYtf+7gyYjT2AdDovLQ0VGeNqnWi7ZPMuWZ
	F8d1qpgInWO+dgYXq6nvFKcEtvfLvoqblH6YNza8E06i+mC7zbMkaksNw7VuOWEj4V5vAOyQOzO
	+1Ldzjhj9jLVirzyD7c0P6aGw3kbZL/MVymNunz6KT+0HJ9XWZwQvzxfVefM7PaQuo0ioQJBTii
	+3pQPjAYNkN4S/Eq9Qwd/6B0juWmxgwdmsxDvQVo6DqFypwqiMRBNtU2F3NlSYz2OBdSWtTVYqt
	CN5g2sIzszINFWQ8XRrpo2Rw745cGiPEgv9eYAvaxzYhLBhKVynqsYoxOoiza4rpFdgqBSzZBU+
	mO//CgtnYc9Zme/mtDvgouS2cD5bACY4P7HJtShbAX7FNrfY5T+h+WeEzAzirfExSqXbPUDY=
X-Google-Smtp-Source: AGHT+IFxg7DjaIOwDtV5y6+LgtaiLV4vV65WhmBSNJ6s8MXhac1dkW0Sxs3azWQRhc0g1eyEnfrXvQ==
X-Received: by 2002:a05:6000:2481:b0:3e7:41bf:e631 with SMTP id ffacd0b85a97d-3e765a51edemr2972689f8f.6.1757768548594;
        Sat, 13 Sep 2025 06:02:28 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e86602a7d5sm2775257f8f.62.2025.09.13.06.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 06:02:28 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 1/4] multipath-tools: remove checker from Huawei OceanStor NVMe
Date: Sat, 13 Sep 2025 15:02:13 +0200
Message-ID: <20250913130221.35073-2-xose.vazquez@gmail.com>
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

Based on info from fbe89f4. It was deleted from default NVMe config:
"hwtable: set 'none' as default checker for NVMe

We shouldn't be using the directio checker for NVMe, as this might
cause spurious path failures under high load.
As the 'state' attribute provides reliable information about the link
status it's sufficient to just check this and don't call any
path checkers."

v2: add info from fbe89f4

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d9723f87..399545ae 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1121,7 +1121,6 @@ static struct hwentry default_hw[] = {
 		/* OceanStor NVMe */
 		.vendor        = "NVME",
 		.product       = "Huawei-XSG1",
-		.checker_name  = DIRECTIO,
 		.no_path_retry = 12,
 	},
 	/*
-- 
2.51.0

