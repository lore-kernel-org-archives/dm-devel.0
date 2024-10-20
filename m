Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C5718EFED
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 04:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396989; cv=none; b=ByokQgVRhLfklPxWjEEkEupLUHWS73C68IvZdjBw2prhmu3NOJIW/M/9bD+24Ialn+7JbIK3+LGVJVEjgKqSp8d1ulETJS0nLFfRE1kEa5/tcDhewRHxW9i7lRMBub94or84HS2niV2tfjDXWccOO3Z1jBvjEJwZuOzGcQBdMNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396989; c=relaxed/simple;
	bh=6iG+P5m+bTysqxHfMQjYbIP6SmuhjAt2CP2aCR2eqWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TcEj9rveGJVhOf4BhEZzzU94yqk/goOiZJskBtVpDaJkwBmH5hIQEK0wd1z3Bb3s1H3MDZ9UzGwWFcVM7ZQa3YEOM/+jafLIfsIeiklbXTvW1KRno1le1uEvw3A7rxwyCIQjUQVjv+u47QJFzQSRFcOcnHYgEfmP2UVeQnPTdh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KrFCzC94; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KrFCzC94"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7ea7d509e61so1536531a12.1
        for <dm-devel@lists.linux.dev>; Sat, 19 Oct 2024 21:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396987; x=1730001787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IpkOmRAz/DQoNyfUWCSgBoembbEPvsuuea47lWbGPwA=;
        b=KrFCzC94szIrUIatGCJctzQV14Cg//EtiWOVZldRADTWlGdJZSHjJUSlZcxuwMncre
         QLfv4/n4aZAky0kQhwIpcJjkibDNKoVmvyeqydYdeMKIIVUb+tmtnu7NJq/2kuLzG/hb
         lmsyf3h066dz2X+TbRNnWtcb/sG625kvj8YUeb5uS8DHFqs5UVMbVSNURYzUDWXcgh7I
         L+0rMiMt5PsXdfHb8DMtj4F8t763hwybICsdVD0YpbUQImyR3JpzjM4HJjg3TFUzVHpQ
         GK8lSBrtDMNJa4M1C1xQhRRHAmgvEFO/Ub0i5XZC/wrzVILD+pHTuhrLhuP6gUeJypHh
         J5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396987; x=1730001787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpkOmRAz/DQoNyfUWCSgBoembbEPvsuuea47lWbGPwA=;
        b=YdWz5NYGOqAPlqLLVjrLsN621IXTsEx2M9WGi+1mktwXCeGC79JoH2QQhPNnHBsm8Q
         57SBIYZOT9dvqzU76KeLSd4BrUqch4Ml+fN6HFz+WPcc6z9Z5j2asRcT9/dosvwlVhmM
         umk5QSGJIPBtI5I0qKnbFrabTGb3S6Y/SAgbL08scCe4ra5rodv3TfXEbUcTa6luRbkt
         y9SIwxD0T/9j81coCL+/n4sLmpePKmbBFU3L/xaGwTkrdIncUIgmPwQBenii9aEUEm5E
         KYvq/VQQNAhaABjCGbP5agwBpp6sFx7hzi+TrRBCB+hPg61C1/YtFrIahpJw0Y2k7HwH
         AQQw==
X-Forwarded-Encrypted: i=1; AJvYcCWElsf+aVQhfOj9z2kMx0AKRnymX/xPlAiVy3ODsSRsYrwrQ0T113EpUZm4cfXvnn5EX+hf0mNhcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj2OJUm85brwSisUbpGPeaBSG62C5d7q2CXyxz5OJqTuEj/NBV
	EsBO72Uivo4f+dJ3dyOV5Z/t+DaqCY15Zy90v9hdexP1SAiUQx4j
X-Google-Smtp-Source: AGHT+IHJf9nXrjmUo/+hBd+ZogFXKHjqpeJ0l0sVyl8/8bUCcHMXr+vmkofLASs6jl6dEFOEoGT9gw==
X-Received: by 2002:a17:90b:1a88:b0:2d8:dd14:79ed with SMTP id 98e67ed59e1d1-2e561900d44mr8457372a91.31.1729396986825;
        Sat, 19 Oct 2024 21:03:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:03:06 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 09/10] bcachefs: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:59 +0800
Message-Id: <20241020040200.939973-10-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the swp function pointer in the min_heap_callbacks of bcachefs
with NULL, allowing direct usage of the default builtin swap
implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/bcachefs/clock.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 1fcfcb5fd44f..1f8e035d7119 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -14,17 +14,9 @@ static inline bool io_timer_cmp(const void *l, const void *r, void __always_unus
 	return (*_l)->expire < (*_r)->expire;
 }
 
-static inline void io_timer_swp(void *l, void *r, void __always_unused *args)
-{
-	struct io_timer **_l = (struct io_timer **)l;
-	struct io_timer **_r = (struct io_timer **)r;
-
-	swap(*_l, *_r);
-}
-
 static const struct min_heap_callbacks callbacks = {
 	.less = io_timer_cmp,
-	.swp = io_timer_swp,
+	.swp = NULL,
 };
 
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
-- 
2.34.1

