Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2A65811A
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422134; cv=none; b=p1aubs4uSTfLCLA77hPfw74uLM451kKjd9J6BsDtgGL82MbMfiC5OLuv5EWrrM4g/3yUzDLW0cjZTu5+xShJSg5PE8biEobrDPBO3RIzs3weU7idc3Jvd5KH0bGg8EAmuzqS6y+lwcNi8qgkU3FmaH5PVBxwQ0PA4ae/dmYFgls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422134; c=relaxed/simple;
	bh=nGzZ5R9SZdgLiSQrHDAKei5XKniCC8VqmnZwC34Exuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kOPvlEWi5jzbjVfr9h0yrUJNgoqW/KBgKk1pGsTNPmB0JMPZZYdJ7BEypbZRFEFqLeqBKiC9fIN08COWnr8+pehgcSD09Ay6kQbxOa2QlDruzNfgwgsp6jqSlpc91p5ROmySiHFkPjPqZ3+dnBsaEUaF6lmuIX7i47J83aFGmqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bh4AN8s8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bh4AN8s8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2a2fbbd6cd6so611227a91.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422132; x=1713026932; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUFbtjS0qmDCTon3KqdyHnzuILiHtuPCl7OJb9nludU=;
        b=bh4AN8s8MmKMo1//Baq/CbFiEY2R6WQPfqjb2rCKVK+bgQydzeS9cVYNBQH1Lve9dv
         jCVw8pXBiKFG/lLR2vnWVA+bX3gm/qwRErHZTv51HNUmyErbqnIlND8k5lCQikQvEvgf
         wr2phLgCdEAl0u2T0tJEDZeKbOI47d86v3/8BQAuOFnWO7fPmc1CEkPJNoNqpB/YK1pW
         Ht38+xCetFxqBOorgbvMW6RJx4z7HGC7QGrCemtZ0HxxMlBoZl5UxFyHDIKzFrGoPLy0
         gv5vj2W88LVGVioBEMeuuw94HTkdJ0JBqkeBt9/SBr9+CUJ+hGgYmm7s+rVPkISZvUjn
         DxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422132; x=1713026932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUFbtjS0qmDCTon3KqdyHnzuILiHtuPCl7OJb9nludU=;
        b=FTSwdUbP55ic9C7ZNjClw84knzXC0afUQjR1ZsPVXFYZbQzH8F6aVjBOIiSuaAaoL2
         7alkjBec/vv2l1fdCX9dNVs22mRI1klp+7z+unKaLqwiwC11Y3529hO8/9fr3EBBQX2N
         SdrTtIUI0ivYyKBSAMJyiLAd/mQHKWC6Tl221s+ejJoBs73p0GWEhNH8Nt+94LUa25l2
         C8CCO4KeL/eCRM6lsV7kUeLctWMNlBjjLcUNmQDEt8ygXpP7qeXsCv2LpS0kzfp7t92R
         sRNo3W+CUuThA2WBkV05ONojQvuMqGD5OcKJkQW8mcCHDrlvQzoBZlczJMNzcgwgF8tX
         zutg==
X-Forwarded-Encrypted: i=1; AJvYcCX5ACb7q9T9vgrNHBSmuhFqBpwZKaK018B0Ua12nLaVsV3KBPYaJ1VPGFi7ep3/FFdfCKUkriWI3o2JpdmNn5F3XHfDA9T61S8=
X-Gm-Message-State: AOJu0YwyuzxHA9C6zrU1+0Z2/NFuuJ3xeUvZcXErutfLR2llyDO2NcCS
	bmXGeL+psQCS1iAZa0KfN8Bu1Pg641elrkGmQEXdIqi+TjJSOf/n
X-Google-Smtp-Source: AGHT+IFn7ROdpfvq4Af61VXP9NL1gvD2SbKlCYOri0wmXqQgy51gfkXMrEA0iklwvkQSiS1rBr8X0w==
X-Received: by 2002:a17:902:e811:b0:1dd:da28:e5ca with SMTP id u17-20020a170902e81100b001ddda28e5camr5421423plg.0.1712422132369;
        Sat, 06 Apr 2024 09:48:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:51 -0700 (PDT)
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
Subject: [PATCH v3 15/17] lib/test_min_heap: Add test for heap_del()
Date: Sun,  7 Apr 2024 00:47:25 +0800
Message-Id: <20240406164727.577914-16-visitorckw@gmail.com>
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

Add test cases for the min_heap_del() to ensure its functionality is
thoroughly tested.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 lib/test_min_heap.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 67dd4f644f6c..9d4bbb590a49 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -160,6 +160,40 @@ static __init int test_heap_pop_push(bool min_heap)
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
@@ -170,6 +204,8 @@ static int __init test_min_heap_init(void)
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

