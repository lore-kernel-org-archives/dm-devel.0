Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE97B4CB38
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422079; cv=none; b=JYPKqb62Q+//KBqUvRj/mNGS/aanYWcod2ux+uQWp2KL9z7MTUF3g3mDwJL1GoITrFUTechVDPsTLOc8+Gr+l4WJJBZs9j0o+qO1s5ufDEonI/zhIaIv7to+gtlg6YuYrPnTWq9d5z6p/b5Rbq+psgHK8LtrASQ98+nUi4ftW1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422079; c=relaxed/simple;
	bh=bbsjMLDh1vvuNiLRmMV+NcOuKuTi5AyduguPnnDUqk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CoSyCky/BtZJzsvrIsv/ifbOIV6ukNiBN96zRiidfbj8p2T2Yxa8NeCMrLZMkmyQgt2qB2hMP+N4NhfE6PKv+hPX2IW22ltIapkUrnpC4Kd+aPlqMNHoSNcNuhcaiHXQDV+abMl7xnlI3AG7h7Wm7tLQ9Rs0XPN0kJukm+nCfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbKzKdGR; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbKzKdGR"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ecfea4f01cso484022b3a.0
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422077; x=1713026877; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/27PnbbqJIcKzLAMpl2qrWzQcCu2oyEBnQ8NZJ3fd4=;
        b=jbKzKdGRNVqiqsU1zNFZ0JeWjTnBDsLh5Oy1p+fhj1BkSQQYI2xa//iAJnySCtaVW3
         gSQn2T8hZuUgf/WvKf+DbYP4vzDeaqkF+ofJczt7Tr06xO5SjGUD1NBvtG1j70kl5vZb
         zc9cZGCbURq+4Vyj1RroiPBSlxoIoVXvaggKdwXt/8/y0vpmPkio5xM/4I8y/Cqjg0vu
         HR5lRkwLMNjMfy4KPIUxfmk3YXrR3ILPpvJTogDIP1Siulu2jmkwaZmH/voFqhKHlGUy
         pXoSI8G570GhO/6QlxVST0V0MPwIHjHKQfMkO073kxU/y5zZuzcAM6DlHw2CPbwL1pkB
         SE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422077; x=1713026877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/27PnbbqJIcKzLAMpl2qrWzQcCu2oyEBnQ8NZJ3fd4=;
        b=GUTezvwKjCOUccDtH2Mk9RayGv38uvLEq/cB0sBSpUGEMovftPapHSLh1bEV6yl6CR
         s/ot+QGaH971fL0dmgrpUOrE9ACYQ1uj9MW2F6E7K/drlgZGWvM1UTTmgjgslx00H3ld
         OW7qRDO7yE8P6L84OwcV1ujX7Ku4FsWS2gbybDmS6zaUZYAa+di1nyNR/2BK0pPZidEU
         SKxz4HUxxAXz59TrTSxG7qO0gUrLQrS7W7tkvtPtdSgd7eXA9LsgQprmmCnelNOhwDWB
         omSPGAWEnRNS/NAfV0/2NojOrW+h8FDO3dwjK+EbX7izVDjVFn0GUL3kZYNGbX5NqB3q
         IaKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW95Awqs5jSBJEbqSvx3z23gfZObQ5zYPYdslFJaz3HRBVFNlYf35x9s1riuPL4XV8cvd/Vka1g+fTh9VL6knTV5IvTtvBvQxE=
X-Gm-Message-State: AOJu0YxNFuf1dZPs7ZQSGHmHi18ByhjsDXs9i2AY0eEb+2GUurhSYYDb
	28XQOlJ3Vf3S/83kn0KIC1jxdNUWBbS/UATea+8LY9dGWM+aPJje
X-Google-Smtp-Source: AGHT+IFxbiwMKuKp6BX+v4dZDdOTLacbPLhfSVk+cPppFP1Rb7Pkm0sxtLz5sQ9Y+7QstP4MTMJZHg==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5605946plf.5.1712422077130;
        Sat, 06 Apr 2024 09:47:57 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:47:56 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v3 03/17] bcachefs: Fix typo
Date: Sun,  7 Apr 2024 00:47:13 +0800
Message-Id: <20240406164727.577914-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 92c6ad75e702..05ac1b3b0604 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
-- 
2.34.1

