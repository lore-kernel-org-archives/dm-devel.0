Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497FD6BB4B
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676509; cv=none; b=HL5Ql9Tc7UIAaOYaqb4XftxjZ8G1egGxTl1zlrlCG4G7B61UlaW51fyG679yltehjtVHMOxj5R2QGmtuTbwEWcgRPXOslcUgfCYT0bGLVbrkXfSAKYNlkQQpFAmGa5HccJBXiyUD30zXg5ZZCgJBM7YiWzb1Wnak8eWT3SgKb0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676509; c=relaxed/simple;
	bh=PtYRw7GsavxbiDyoXt/jBI3j/cXrR77rkoPNcWtU+qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SYjBC8wv4gI/YjDTz0iAJruYUgdb++drFG8j3u5pDxYcF3qSfM5hnQYTk1qYKD9kKSenr1yhh1SRHYSyrs3s1z0nWWJ9XHVdnMZ1FGvWzNNLaOy6XVmUsuVmGRaZOTB4NCQWHTWADUVbMC5+gNiO9dUSybWHoyOMT9yrprjJeoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LbayXzLE; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbayXzLE"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2b516b36acfso1394516a91.2
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676507; x=1716281307; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=LbayXzLEssbUwZrStZTuxkg50hDYVPp1NbyERwojm8iRdcvfj57Omi7F9/Qqd5aXzk
         DPlk/5QPBHB3qwXT+8fqcrU7r6RszpH5Jo9MQ2PYR2PkqjWw/wKCDjs8lCcUBSleN561
         rUQq4A3oXapjDLaUNrMzPLDTbnCbK8Q20JVyY9MYthtEmO/G0AQXwOCVI4xdYOqEoOX7
         8Dqge12w/J2nZAor7q7DZRGFGtDMh+SwpumS7at+V2DqqI4BxHjBResAWa9lPLceixbR
         znOkCx+i/MALRkGhCuzsfPQ2iBWlCjn/Hs1X6Bf1J6CbTN3+5K7Pq/VNAs6HPPIw082Q
         P8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676507; x=1716281307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=YZPpRTUNbusEO73wAz7tLIbyHxJrxhGLUmVe1CwDmmb/rv9aQAx7mdT1y9HILjz716
         BOcxSe2Nw5QFg4GlDui1QgLDujJk0gXpTy2k6PK+oW/DuM/revnqNBk2oVccen81EmHC
         giuxvVzMuM2TgvHJ0lmu4O3GzRzNpRZ6w3rLfjpkB/p7odfqjeUnbu+lUIfIHyCT/Gbi
         4N6QOiFpdY7xZGdvm8qOkWEJlJT5fvaPvbjAkZWtIKk7DkIHFsSH7jV0I8y5wLn+JIid
         +gdr/6Nna+H7Cm2twun2RfNSettrjfB3E2wxsyjjOmAMeG1nitEUfQJPq1lgnisXRDFT
         vnyw==
X-Forwarded-Encrypted: i=1; AJvYcCUnTAADuCEQ22w4cMlUiwe1MP8iowcEveKN7C79Kt/F6XtO8PNgc/sq6owQoFULIUn2N/bTpW1NZDcy3VGHnoliPyS5mV5BCUo=
X-Gm-Message-State: AOJu0YwehMRzRKeAMBtPw0oDvYyF2rZQ9GgI548ry6IxsmE5kfAcJSvl
	zW8P/WvgI6aZyN9knl7ej+aornpCO8Rue67xxFJV7OnCHRBIOZ3b
X-Google-Smtp-Source: AGHT+IGfQAYvZHJMtREHiuCy2r7Eecel/8/3etErb19WpLLlg8BfpElH6/usKz1uG/RUviA8uzRF3A==
X-Received: by 2002:a17:90a:e2cd:b0:2b1:88bb:20ed with SMTP id 98e67ed59e1d1-2b6ccd69770mr11166476a91.2.1715676507633;
        Tue, 14 May 2024 01:48:27 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:26 -0700 (PDT)
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
Subject: [RESEND PATCH v5 11/16] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Tue, 14 May 2024 16:47:19 +0800
Message-Id: <20240514084724.557100-12-visitorckw@gmail.com>
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

Modify the min_heap_push() and min_heap_pop() to return a boolean
value. They now return false when the operation fails and true when it
succeeds.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index c94f9d303205..2d080f85ad0d 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(min_heap_char *heap, size_t elem_size,
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
-		return;
+		return false;
 
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
 	__min_heapify(heap, 0, elem_size, func, args);
+
+	return true;
 }
 
 #define min_heap_pop(_heap, _func, _args)	\
@@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1

