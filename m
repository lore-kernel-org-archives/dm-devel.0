Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE056DCE8
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676514; cv=none; b=hHYNf6YvLRGTLOWDhEj2tqhKb8fpbjeKRSEh89ytIhMhIlK/uTgRSQg88gwniTw3wHWSBoNGUMFLlGEF5PCk41LJiOW5lSE18HRCL/S7lUk2Eqb6dHmBBrLN73NCMSmTgZWxbgwVZQbh15vyc5opr2j1XzFiUtcmf0nWgXc8how=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676514; c=relaxed/simple;
	bh=5dPWx/XCuPpHn/JbswVAX4unB6CSgL3H/O4srtepiqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LLB1K1HQRrB+SefUz81L/+QTPWHJ8vIu3o3B+JZn06NAcJ2fPESusk800EOmPdjhG0rAjzrNeemm7xdmtqHxew4wvhExuV3x+Uvt12CYTko2oykISyf3yu7J704Eu5RO6AkcFL6oXffV2PMLUHF5GxEJ5JhM7X0/ERmThdsbCKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LvMLj9d+; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvMLj9d+"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2b2aab2d46dso1233053a91.0
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676512; x=1716281312; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qStH8dSNcDcItb1wA2JtX3YjxyreJTEee2fjqsXU5t0=;
        b=LvMLj9d+Vm6O1kK2UJoZA9M0RXqL0U8pqevK/e3frc+eHtM8TaLqtKreIOrvcro3jp
         NhB8TmC4cN02sSg7ueidQOYeoxTQHVzri9+puN2ezTuYB2lNU0qKKSqD+8/bQPqctGOI
         mg5s7Pga1LGalUqyPSnsT19gvJLhD0xaDNPu3TcE6nYgyegbtjnDtFTY54C9hD11V2sk
         tNnzRKCT8AU4FLbn94ky2R0iIw0edYy6UvF4fpUyoRvLK8aGZ3EZhSz3gx7B+lfi4p8R
         8npq549AALlMdeJl1zWP3gaC0UtJ0YEgNwYpRHJoNUEctCSJZ3yPDRFoJ+lrd31RLaUl
         uuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676512; x=1716281312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qStH8dSNcDcItb1wA2JtX3YjxyreJTEee2fjqsXU5t0=;
        b=MIJYnVUCQYmvc/o+kt7+AcUlrzoEfMevrMTISS1uztmuTP2uSMIIy5ZcTSUu3v79WL
         iNt/ttkdnmT+N+0SkL3M7RfcIerLYM8LNxFK8FPIzTc2P/1f9bgwaMl9I1GxBXP+ILst
         TCxxckGt+g7OWJDXbo4oPaDmJZFu86sx3SqITRoBH6f73XHSIkQJ595w5Q2eedvKZTIZ
         BGfz/xDjP6fuwh1ZGUhRUI+4AsLxJk2sjKvZc9Rd9YVLGynegmY1IwWHiXGojMVEOJch
         64F0AD5Ci2LFhGtTvj3KIuHhlJTqbL/dr+6QoDHRS3J+zm0GS9mdzOdAFQdwBDmx1App
         Mm1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWw8oVTDHZqAGGziaXgWOnYLETIp5KBzMQI04YqScwcY4tqYH9S9zIqj/eBj7SHcOIj8Fzdtz9FRiR6K77Ah5Sxmb0X4FFNzAA=
X-Gm-Message-State: AOJu0YwTQnJzoiX16zKK8OAijuSHkF8c/A+Bb5DeakI1Ike8QCZM57nh
	vp4EKUH578P+weR5eD8ICqiLkl4FTChlHnh2cvaPIgUDryVrvQDr
X-Google-Smtp-Source: AGHT+IHAEeLtnkJPSridXVxcM1Lek6wVLa4/x7IxnsemEK0CxdtUzekeg322+ZCpZ1YXDs/kefgzeA==
X-Received: by 2002:a17:90b:354e:b0:2b5:fce8:59ef with SMTP id 98e67ed59e1d1-2b6cc452fb7mr11632999a91.1.1715676512627;
        Tue, 14 May 2024 01:48:32 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:31 -0700 (PDT)
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
Subject: [RESEND PATCH v5 12/16] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Tue, 14 May 2024 16:47:20 +0800
Message-Id: <20240514084724.557100-13-visitorckw@gmail.com>
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

After adding min_heap_sift_up(), the naming convention has been
adjusted to maintain consistency with the min_heap_sift_up().
Consequently, min_heapify() has been renamed to min_heap_sift_down().

Link: https://lkml.kernel.org/CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 drivers/md/dm-vdo/repair.c |  2 +-
 include/linux/min_heap.h   | 14 +++++++-------
 kernel/events/core.c       |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index c1ed3ae823bf..941ac9eda8ca 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -183,7 +183,7 @@ static struct numbered_block_mapping *sort_next_heap_element(struct repair_compl
 	 */
 	last = &repair->entries[--heap->nr];
 	swap_mappings(heap->data, last, NULL);
-	min_heapify(heap, 0, &repair_min_heap, NULL);
+	min_heap_sift_down(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 2d080f85ad0d..f907c694e852 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -75,7 +75,7 @@ bool __min_heap_full(min_heap_char *heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
@@ -108,8 +108,8 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 	}
 }
 
-#define min_heapify(_heap, _pos, _func, _args)	\
-	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
@@ -139,7 +139,7 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func, args);
+		__min_heap_sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all(_heap, _func, _args)	\
@@ -158,7 +158,7 @@ bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
@@ -178,7 +178,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
@@ -232,7 +232,7 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 		return true;
 	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dfd7b5748cbb..82f329c8caea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3792,7 +3792,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
-- 
2.34.1

