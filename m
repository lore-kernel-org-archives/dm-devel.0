Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE11153810
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054783; cv=none; b=Y0Gj1MzsDyTcnw4bv2e3u1g2NyiCVx4vtCYMe1ywLUaW8TpQVrsy29kFg7Tu3LIwGhYhxj4NdYGTeaT+7YPPEcmKTi/oLrPgiOfaxzIFSMBHgz+/1SkhRfXfzL0+CpDvJAT826I7NJLjcJf+cPXpREr32/76j6oM+QAJ/bO3zbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054783; c=relaxed/simple;
	bh=6RI5jUBlTt+5u3rxYbD5uAwV2PYZJ9bmstimem/yPPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=remFW8QcLu0c9alVLUwg+VcBGfw1uI2m8ezHaC4tgTQjYy0qHcq1GKiSIjPBlqmxSZSNxLJQbcy22cMUCOQIYF8KzgPsiTbRv2XpwnlQkECA3WNvh/BmK7MgqLqVGIjaKjmdMq6kZgp5UqkyANesYiM9f7lwOgy7C1XZmV1d8Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QhcQ+bZQ; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QhcQ+bZQ"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2a2d37b8c4fso277520a91.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054780; x=1714659580; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=QhcQ+bZQBouz07/f2Se13oTaJpEd18w5VTkmhBf6OnTrs58bHX4bUaX2NXXE4+KR1K
         ODhcG413NX51LeSm/zxwcLRpCuYxa4PpXcXMdvv5KHE8FHpka7pZJLQJmFSPgQ9FQXKP
         QhqqgofL2Qx2tbNkeBX9i/r8gZgqgGz+zU1mbsNhG0eZtQjThNnVpo7vt6AWgbfcjsv0
         CKUApv/LnrrGW8lyrZaRZ5WeM2Q0uGf+Ci7X5cQWcFbdV1a+MEUSZQQX9A2EX9JX1imK
         Q/LFMziEnvrTusISUM+eO2slOjgWDHpWOlIjGYA7RnFXFKJvfhPVJXO4bqzndQRcR6mA
         fFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054780; x=1714659580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=AwDiNvVPVL50rs50o5lyarlXt667XPPJcm2ttXPYCBtBSoNSVQQYOVnapPesVX1NBT
         W5x7tUu+PwuRBIvPHcPOjFGXdRFPcWwwJ7dsVp0+FSS/xSzxpEFJ4ZxE1bE5QG2xYdG3
         q7xjy3nXHlhYqXLiwS1gLjAQ8Rr758tBjZypPfJBW5juiCI9PSZTRIBPR975BMSzamM/
         u0TJDu7JQx1Pspl1rToZirycM7kHBLNFs+VIUEkUvBPusr+HkdfsyYlU20+qUPWXEm7+
         dSIhNv5kU0/cdcJe5C8fSDfPjnb4LSoyoqSSxt3/KfjGAm0Rhvy6chnkLSn8EwiAXiVw
         5ZaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtJpGBvwHjgE9EMrVOm130OP8RxiQdxuNHoE71skqDmp1CCwN88yoBOpKXq3RXqAtT16F+kOwhyIGDisKAUOAd1DVI9XAf31k=
X-Gm-Message-State: AOJu0YzslQiFO2MpPQZYJar6/6IjACGgT0ASclcLkZME9KTyehQBFbR1
	DbM5r94omCq3PCHwxwlE8G+9J4dEHFQ+6VivQvZu/o4fNevuTV5Z
X-Google-Smtp-Source: AGHT+IGLtr8gNAowqrhYxdb7nL/pPUMKK9j1lIpP3T8Y0HSP5yJ+WzDtVU99hrbxcwsvMSorDEfYsA==
X-Received: by 2002:a05:6a20:2624:b0:1ac:41c7:d2e2 with SMTP id i36-20020a056a20262400b001ac41c7d2e2mr5389786pze.0.1714054780149;
        Thu, 25 Apr 2024 07:19:40 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:39 -0700 (PDT)
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
Subject: [PATCH v4 14/16] lib/test_min_heap: Add test for heap_del()
Date: Thu, 25 Apr 2024 22:18:24 +0800
Message-Id: <20240425141826.840077-15-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add test cases for the min_heap_del() to ensure its functionality is
thoroughly tested.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 lib/test_min_heap.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 0b5037b4bd68..d40851cfd824 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -165,6 +165,40 @@ static __init int test_heap_pop_push(bool min_heap)
 	return err;
 }
 
+static __init int test_heap_del(bool min_heap)
+{
+	int values[] = { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
+			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
+	struct min_heap_test heap;
+
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
+	heap.nr = ARRAY_SIZE(values);
+	struct min_heap_callbacks funcs = {
+		.less = min_heap ? less_than : greater_than,
+		.swp = swap_ints,
+	};
+	int i, err;
+
+	/* Test with known set of values. */
+	min_heapify_all(&heap, &funcs, NULL);
+	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
+		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+	err = pop_verify_heap(min_heap, &heap, &funcs);
+
+
+	/* Test with randomly generated values. */
+	heap.nr = ARRAY_SIZE(values);
+	for (i = 0; i < heap.nr; i++)
+		values[i] = get_random_u32();
+	min_heapify_all(&heap, &funcs, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
+		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+	err += pop_verify_heap(min_heap, &heap, &funcs);
+
+	return err;
+}
+
 static int __init test_min_heap_init(void)
 {
 	int err = 0;
@@ -175,6 +209,8 @@ static int __init test_min_heap_init(void)
 	err += test_heap_push(false);
 	err += test_heap_pop_push(true);
 	err += test_heap_pop_push(false);
+	err += test_heap_del(true);
+	err += test_heap_del(false);
 	if (err) {
 		pr_err("test failed with %d errors\n", err);
 		return -EINVAL;
-- 
2.34.1

