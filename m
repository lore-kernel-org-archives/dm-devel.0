Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7926C54670
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422121; cv=none; b=Mn3lLIsBUYM49xUXWbZW8VeC5mDNOYqKk4H/2s8T0y6F5E7q5KZG9pAsCHOjM73JGq2m/p0GWe6Esj16HGuuKSzZJYK/kwl3AAVbO9Hf4W/wfj7ouBI1CjLJgIO2RU3cOy3/DRlv/mYXIZBGzY2P/dsShzJqMFeRGU4Ss2u4QCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422121; c=relaxed/simple;
	bh=ILK0WtUWi96BNQKLJsyDtg90NnSDdPoSsO445/1dQII=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aLCyoI3HPL1TGkWiUoGUEgVgx1lI+FFiL0rFGacKUfUWsNB0iDducu3L8/WNkAm1EEvy9M0Yx4whE6W0gPrqzlxVFyijMLGRgyccf0WKIR164NisOOmCv6EElp6rDifcnmC8wq+BVJZmweM1+dMYOTYG6m5jpExgzIZnAmoFvBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQdhbChq; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQdhbChq"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d862e8b163so659554a12.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422119; x=1713026919; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kgfux8MfAeQS6+qFfIDDQF2LPwPsL6hthHkisyhefZY=;
        b=PQdhbChqappEzX3SgMqdrGKTea9gXNAiu6lr3rfMlgDw62Ec0ixEXK0GwXVq+WVauC
         vl2NdcATJrRH1SxahUvoOCjSpDLGS4zhHKPjBeDg4/oc+XKNxFxKvLDa02lSXquXpMVP
         W9LyONZW7si0pnITErLVLdS/VNJOhVNnHE0KiGDY12LegMMFyP6waoSs2BuDN+m+lCSW
         0mWV1yt/J/gpQnvCGlHYkJYA6JPkb9fv2FKQD/OLtBMf1i+IVjlNinKg5Rmu97uCT+Pb
         n01C4CbqxdtWz1tCsZlsgWlnhImBWEC8ICQoKn82iSKIOsrQrBcxb5CRO8xjzYIree/f
         SUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422119; x=1713026919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kgfux8MfAeQS6+qFfIDDQF2LPwPsL6hthHkisyhefZY=;
        b=oP7TqHLJOZ7ywY1yXF1UuRYViREqHG+kbA/UugmrA4m0DHUzG2EvZBaaBvuKguEiSs
         FZ3vs7gLmd1lCWVw2wS9CVY3ynlZ3L2jRG63fmvyPsz7XjFFLXMHOk6GhOyGFZJVE/gR
         XzoXM7z9EKqWe3boehxH5dcHifsiy4Q+gj2cWurY3KVNYNeCGiAUGvoMRAu+KGhiC8YZ
         +C3nUpX8wzLOMZHy6jQMt/rk1gNHRLdJxV9qp1dABxlnDV6mhzwy0Q/snuoQ7u0M0f1D
         9ZnjhyYPZ/ZE28zRnT5MmPI/8YYcMAGBm4Ypbg6stv8ZhjD1OumKI1at4mhER2OBHkPv
         tB0A==
X-Forwarded-Encrypted: i=1; AJvYcCWIvKv3ZjQd8nXxTm/WwGsUcU8/jPrr7ZRzDN4W2bNjlCzDjifbnnzteEu6C03rZKYdEvHbU/Bqzayjp4h1DsR199v8xImk/vg=
X-Gm-Message-State: AOJu0Yx4UTBWPEErHnl3VwNUJ057wH2VJevdzBk0aRLsR7+87R9feq1q
	6K4qa6aQ97lNuGRAn+PfVoromC8E6kJqrAtfhPoOVCtGSc9nCMtu
X-Google-Smtp-Source: AGHT+IHzFYEQ+Y8lB65YH/xq+fXDSfemv04Nu9isKsBYZjxWX2yXJ9bDEy0Igzc2DcHRS0YhkyUIZw==
X-Received: by 2002:a17:902:ecd2:b0:1dd:e128:16b1 with SMTP id a18-20020a170902ecd200b001dde12816b1mr5497792plh.6.1712422118743;
        Sat, 06 Apr 2024 09:48:38 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:38 -0700 (PDT)
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
Subject: [PATCH v3 12/17] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Sun,  7 Apr 2024 00:47:22 +0800
Message-Id: <20240406164727.577914-13-visitorckw@gmail.com>
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
index 5fe93868b33b..b7a66bfab9e6 100644
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
index 889d410862c7..3086612d7cd5 100644
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
 	memcpy(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 80f497683cf9..a64a8337d9df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3788,7 +3788,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
-- 
2.34.1

