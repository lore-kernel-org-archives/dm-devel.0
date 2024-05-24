Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13C131BDB
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564667; cv=none; b=ij2nOLEBIghiHwwHKFNFEFvzb1unLMebZghfWiFpEOgBzG2576QpgqmEiWb22oOW1NkvYjxfdtT8EA16Y6s5v7CRiuC8EcJaMrcNR+jRkg9XlLFaw94YsrjI6cUOHTW7BeFIPIjJJKH/UIs3heb1UCx53ER6ONVJsSryhlqSIj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564667; c=relaxed/simple;
	bh=XBbTFxTKTTd12S0apVryE3PcI4APeLL8xosQ1q7yRmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DzS+aX8Y5heC+xRXn2kn847Kngbz8K4OZdp5CuxiCrDbJmpDtH/W2lwHMwHmrvdkBtAWovfyAGBaVbfTtkzddFVQQ8/gVt1KcPox029qkHtEWMrNh91DYt3V4afr+zQ2hMfQL0GWXcbd7QklB8KCZHjyQ1D49Pi3M3EYsnLbgGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JNFhGm+V; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JNFhGm+V"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2bdf439c664so314843a91.3
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564665; x=1717169465; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJxc7A3KFbtC/I5z6jADokbslyusd4Od8ho0PKKKHBc=;
        b=JNFhGm+VdvrxL3KSSHiaph4EnxLGJhOntIvekahr75gzPmhffetuiETUSuLsS/BwIn
         is4mJUBydK+9GmGZ+v+R2ctveTazyKKC/lwVFPFOTXuvUwojlGFuP4AecOtr9WOLNZqr
         A3HjngsFOxX+QIGafiSZTWSZr6TsX1bu3IHUFUz8T2Gy5rf7dYatOPz+Fwc0Gxf9oWsl
         FD7UtuvRqcJ4kK1kb/CCZWu1/0NVovnBGLv6t5XWk4qI5fcuyXxYVdUL5sB7TBdxE7f/
         3xNhOOn+lTvo6C57SxEXC5OL2ekbWdkYByiSALCDtEv5BxrMmGkB9j2favqODqhYvK8A
         KMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564665; x=1717169465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJxc7A3KFbtC/I5z6jADokbslyusd4Od8ho0PKKKHBc=;
        b=noCQ2XigeqXyKtuuW8LEdTyrhDTN9pf0COWgDu9fAK32knMrAcrnkZB3gOG+OecYzR
         UscMkLD0Nhxy9Yh4WE5isfSdr4AFyzRf49lgni3gF1i/TuNEXUY86R1VPmW4j9dWrNCv
         DUedctl6P6ji7ueqtNjx0S9wZSgRAQgDEYdJiutWekbpgqz/oFDBHvYKikR9LzLheBe0
         tOsjwJQaJL/ED30c9+nMGN5ntruNOXrbYIZbrAuROPGLBwwXW76B79ShDdcYzHOPKDwm
         WWMkbhRQPyNTXdlujnKAJa2mXT3ZZO5eigxeAhhrGcxPkCu+V2TWT+VD/axtSOLZ5F0V
         imkA==
X-Forwarded-Encrypted: i=1; AJvYcCVFulPMbUq3UL6tn+GHs7i1dgMC4y0vNEjuSSO8PbM+Pe7KZsfyi+cfpwL0fNf1u8yRjhKJRCHosgzn2Eabcl1ORAQ0UMQFx7k=
X-Gm-Message-State: AOJu0YwTV9xRWVJl8scubnKL26JzcoDqMsicEFPw6M1fT+4aWwHFVXj6
	swUUxBDqsAvxjm+P+rXniVYI9Gs3rC5qQSjfw0uzj7Ki48HxU6uI
X-Google-Smtp-Source: AGHT+IEuU6jpX9orINJlPXkOYySiaFGvoUViUJAIEwsd0ETqDsNgaoXn1NDqH0zGyIfxWZx4lsu+oQ==
X-Received: by 2002:a17:90b:4fc8:b0:2af:6b92:ff6a with SMTP id 98e67ed59e1d1-2bf5f30e8a2mr2443714a91.3.1716564665094;
        Fri, 24 May 2024 08:31:05 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:31:04 -0700 (PDT)
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
Subject: [PATCH v6 12/16] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Fri, 24 May 2024 23:29:54 +0800
Message-Id: <20240524152958.919343-13-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524152958.919343-1-visitorckw@gmail.com>
References: <20240524152958.919343-1-visitorckw@gmail.com>
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
index eae990859db4..ff09e4a14333 100644
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
index 3410a5f907ad..0baee5787247 100644
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
index c843af8fa6f0..fad272aaeb65 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3795,7 +3795,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
-- 
2.34.1

