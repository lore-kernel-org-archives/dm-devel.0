Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14693241F7
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705578443; cv=none; b=Rn5ASkt6a87UvfzGbtjVEyP+JeDIlcfHYXjooV/bO8DKGAY8BGBzV/ZB4yyU4hMmoqluL1HQUCw0xEX+S4i/3YvmvpprBOn8MkGmt2YQfU+qMf6rD+iv+U0Jhbrq3zjagutRzZtW9R2RYNjBAApmbPzHByWs5A9CysmVxd+JQMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705578443; c=relaxed/simple;
	bh=KNkwFjASPrdcgY6omO5rYMIsnJpNlkW2yRIU8CQZFwY=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding; b=T/0XRxrTiA+rAtVXjesEonG/dGwhP5YVWDUZWcczX+wT59NMwT29BLwkf5joHbO4t/TyvvRUW1jd4OiMc4UOq5mNoypf5t+2R5fPEHgf+0a5XEX3vpgvoUZCP/okI2Qxlrksu0wPLvilg23Ca1sAm8aCEIXdKWXbgCe7z0V6dd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GZezRZWM; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GZezRZWM"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-337d6d7fbd5so98249f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 03:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705578438; x=1706183238; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6vyAziq7y5yCnhMRHNZOKc0bmdZ/DzJosfFDilDZWo=;
        b=GZezRZWM6pSI1py6DxH858UJjZCU83dvHsRd4twW14RjfEqVsfdd6hACJdutRlKtrD
         SEmQM4U0PYpT5PWWnLFVdnKbc4sSJhzVeglZ0H1M0MtaLjcywHvBEWiG6MryGHEN3KTh
         +kwKwOLVBiAq8hhsh2jADgkXcy5UhQ1Xlt4KB9ox+cVovW9aVwq88jbJ4sgSqwPEbCF8
         tYxD5P1iUZ3InQRhhpYeyfjuzVkcfbCsvMuPt4QCdOziWXSUwfiv4tUJyHT3bBW33wcx
         a83zF5XCfFVrJ8YNTxPscIgQfBDIJ7yuXa3knDlmwVKva5CJdINWq+yjjWKZZqSOTDkc
         9Z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705578438; x=1706183238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6vyAziq7y5yCnhMRHNZOKc0bmdZ/DzJosfFDilDZWo=;
        b=wuFFlgfiUgnyCUyrsZu4B5GONMMvYVoFEOYYkbWE21dnou/lduucBr1NiSpqsrEteS
         ro+jxhryIIOKWOonk17GbrZUILRpfoH5R+4gz1maiS6YJnI29D+HaBZO+F3KH2PAb+kZ
         jC9DkrozUi3EIwr3fuz4Her3LAIJqhxZrqmaOxtupKYJJP/Gl/RWjerC7yqcRpvEp0YN
         CULOwYLvMbGXWUQNwEotXnMu/JPc5eH3tpu9SlhqW2VA6eUw3uVVC0/OZXD8sXC0rFIS
         6iHRDE9pX7zbBn7yURQ+OA2eT3OqxYFIZ3FkbKawwzUN8g+01iu7oSe5yzCL3Ff4i3JZ
         5F1w==
X-Gm-Message-State: AOJu0Ywb0sUpUqO/lrHypzbryJnQqDxN4AojOE62L75y6wetUp65rCaR
	hKRNVK94zrsPBGTYb+VtQB9K1XwPw1B2WVDVUJRcNWvJSFK7FFAMLto2f5cUYOc=
X-Google-Smtp-Source: AGHT+IFq8bOEc6OQ4CLoXjNmX4uKVdD2hI+8kB0QWOPVACrMmrh2hje4tUMbPDBNCPkNIIUHgJfUIw==
X-Received: by 2002:a05:600c:154c:b0:40e:4a2c:f0a3 with SMTP id f12-20020a05600c154c00b0040e4a2cf0a3mr495386wmg.132.1705578438397;
        Thu, 18 Jan 2024 03:47:18 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id t10-20020a5d6a4a000000b00337b0374a3dsm3844864wrw.57.2024.01.18.03.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 03:47:18 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/2] multipathd: make update_prio static, and rename refresh_all param
Date: Thu, 18 Jan 2024 12:47:14 +0100
Message-ID: <20240118114714.3391-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118114714.3391-1-mwilck@suse.com>
References: <20240118114714.3391-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the "refresh_all" parameter so that its semantic
becomes more obvious. Commit 6ccd7b8 ("multipathd: only refresh
priorities in update_prio()") explains it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2cddd85..6193e69 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2099,7 +2099,7 @@ partial_retrigger_tick(vector pathvec)
 	}
 }
 
-int update_prio(struct path *pp, int refresh_all)
+static int update_prio(struct path *pp, int force_refresh_all)
 {
 	int oldpriority;
 	struct path *pp1;
@@ -2117,7 +2117,7 @@ int update_prio(struct path *pp, int refresh_all)
 
 	if (pp->priority != oldpriority)
 		changed = 1;
-	else if (!refresh_all)
+	else if (!force_refresh_all)
 		return 0;
 
 	vector_foreach_slot (pp->mpp->pg, pgp, i) {
-- 
2.43.0

