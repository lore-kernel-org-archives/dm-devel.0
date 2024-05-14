Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EC53770D
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676524; cv=none; b=Rw420/X+oXtpowO11sjbuuZGvBWtugCBk6dD5bYBhDbfJWmuOOgQjslIEmmLImVHYc264VYQmzCNUbyvuMUria7UIhKEHaS27USLSYBhmdbOuJu4PcQhRpUpPP9RJtWwidBaRkOLrT+2u9lP5oKw9h5tdCXybOnIWs61SDf8JTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676524; c=relaxed/simple;
	bh=6RI5jUBlTt+5u3rxYbD5uAwV2PYZJ9bmstimem/yPPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XR7el/5Jx9T/nDguwfjcw1ukPWGItarSmjY9lkWIrwawTe+oxTqwXd/Shp2eF4NYLTQ23bvdnZ2+YR01T4EnZyB4/AdLjRZ8xq6EzWiWC+JUE95PEXvv1cfeOi/PTrOrCPAvRgSfGb7i9K/eb6FL9zAHbNNkpBYmRZkZ4zeqYxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqfF8ekI; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqfF8ekI"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2b33953a163so1333031a91.2
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676522; x=1716281322; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=DqfF8ekIS9iUevBIdfdXB9K499gVe2m3lvh8UmKQCzG+Ty2UT+q6v0ebGUWhJ7hQlf
         avEGm6mkHgKVyuAQaiOpQOMv7oFlxgohL3k9g1w3hYpG2vfGnp4S/a4f37KB7bLddSxX
         /Gt+IlsWbPuzuxCa4sST0oenuEuIylV6EYML3SYdzMTve6FXXxtCmgn9lTpQ5h22hZME
         2e/p6AT1ObARihH1j8IqToEkWDA5cij996CQyaMg/xatfLnNdRv+2DyMa3IDFifUZykq
         6au8CsLZPh8fbro/wXLhcc1ToMCjuaM8hGHkJC2EVwehvFEXcK5Dhc2Tfv6MrLE4zhVY
         T/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676522; x=1716281322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=bfE6aq4geNHLMwciv49YU7zWM0lqnJT94lOeRTVVdP30t6fLOTXKdL4bq7MgIDghRB
         BNHMXMrSwO0zcQ3AqUbK7Lv4fcH39BvjZo6Vr45vhaIOKuVjPn/ctBwtvnXGouR2ZAIC
         Ah6sukzcVBLOmXsp7aC9KHZw5gUuoXIy23Ecsl+/rzJMXCd10byQ+DBlsv3N6fFsJzR8
         Gixlly9HP5oAhmWG+3aKbKj/cT5RQkLEaL8k7dNkb8HtEUqDX4SgYWAvZDsUC8iez1n4
         GDDsz3EPysQIygnYUi4iJZXRXpgNN4rZGcOSwNFZRiymGDyHikV9PWuGdllA3QJZZ+Tr
         k/sw==
X-Forwarded-Encrypted: i=1; AJvYcCXHCYBx4EcLnM7ThWQi5r94dWPD3oW38XQ2VRr/KKxG+u8jFqr+ceqOqzvdVN9zkeMGq3k5fvVzBjNOILM3EFSfaw8Icc/d8c0=
X-Gm-Message-State: AOJu0Yzwj5GcQ3MMFTAYEG+9z3srRSt9JwYqnHZptfQ/ho3LDZ8lz5f1
	O/jDSvG+lLXL4QG9EbW5400sLyNNjghYCa8m+WbZVTFErcBzvZAI
X-Google-Smtp-Source: AGHT+IE/+k5Tsbp6nBIgFMfvySLFamCErRWzUfdGi9BOaWec59ZSeEqFgNaFrSCJw9WqKK0Y18a7cw==
X-Received: by 2002:a05:6a21:7896:b0:1af:cefe:dba3 with SMTP id adf61e73a8af0-1afddee489emr15338579637.0.1715676522439;
        Tue, 14 May 2024 01:48:42 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:41 -0700 (PDT)
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
	bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [RESEND PATCH v5 14/16] lib/test_min_heap: Add test for heap_del()
Date: Tue, 14 May 2024 16:47:22 +0800
Message-Id: <20240514084724.557100-15-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084724.557100-1-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
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

