Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E1537E2
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422116; cv=none; b=fYd9P5barOEizYa2PeTycGU8iiGL9fFZTUzhCPSiEBO0trp2fhfVwD3KKHBLONmeUklm8KUabTaymUl0KzsrAfoGxOR2tLgLKeon14rjtum+6MbHqIUsAmLRlp/9dudBzFhmnQ8YH8FMJuhjYUZVxx0K87OhIrStq3YoEhud4xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422116; c=relaxed/simple;
	bh=P6OD1w/ffLuZA93dq3GjSiXVcdPqNBMmEYdRRZgPTYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c5ZEcDLI+ymZCFzP/MmZL1GN2U1dAw8enwxxudTsKnoliBXHlu5DqBOkRqK6d6PZdrjcD0wwChT3C/PpT3JHQ5kRl+UmZY5Lheb3foprYPHcHfGeGyQOlSZiR78W+RhzvmqPH4MYLDYKezsrTxCBHGmVaPCVGEIQWVJ5Pg8Y3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmps1W5G; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmps1W5G"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e2a307902cso4973015ad.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422114; x=1713026914; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3v/S/N1hN0Q2k246igfeXq323YyFr+V6BvOJzuDRd68=;
        b=hmps1W5G7MDs853v+laArOQ/JBR865xUtYe4ovQChpHt4aoG6X8fo+S8xVBzM/qyrM
         k3l93nHB5IpHIs1jUYjOLxymaO1RM8DR3P/KUricC+asAF5vN3Wq4R1KPsa0TKoeoWL3
         Ji7tDkc8p/fU8VixGE0VhbDOTbsLyQVeLr4R8hf1cBIpTZ7HwbAWquivDLRP6go113u/
         +jWmzUspz15IOQkBal+eyYenYb7xLsOiue6OZL6Ql4ap+c+CeXxHXDjvE1KHNipb/ond
         wVh3NjsosUh6L3VdTSSuI0BgTxc9qWnWKNtFQepqfczUdX8bO+W4hqyE+DWPmlrHR36w
         p7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422114; x=1713026914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3v/S/N1hN0Q2k246igfeXq323YyFr+V6BvOJzuDRd68=;
        b=C9BqBHDUmO9OKHC3JD3ykg4lhTXhUri6HzpAF6RHUK+5nHLwsTC4XyEvoZZqPa3uPY
         TabVQxIc0m8qQqi10ioyWblaWRs5eTNApt1h7F+SeeEMZ0HXWjrniUtNqX5Een6vPBbq
         IdnPYmT1aXE6SutjXcmEqS6s2LbYti1GfD+Pyo4Q6AQUthbFHdTtmJYJKuuh8Brp8aNy
         NQtxc1ul/Iah4PhrWXPC5fD0H2RAds8sygpp41sus9tRXpbBqE0cB5DO/8MHpvPRDE4K
         lAxugWPL59+YnWBpvH6dwLT9SGbVpxCrsniBOKh6EOFFOL6PVW9Wl1KscppNYd5SdEaq
         KSaw==
X-Forwarded-Encrypted: i=1; AJvYcCUiai/KDZoDPOw8ksglTKVqC+oxQbfkHrlp0ITnjLoZxfnBm0grOFxm0Hse+vwvqs3B76qBmx5uK01z0yWEWlt94+UaEZZNErc=
X-Gm-Message-State: AOJu0YxdXnMbKJ6cXWc7x3bkTm3mU3VbyajgkH0ahGOBdI3CZp0jTZBn
	k8PssNn1VR2fN40v06H/UNt9tDhNdfzZHzxidjfXn6m/MjBmunCv
X-Google-Smtp-Source: AGHT+IEnvMJdcT9OxwgIRlFw/EFRCmFP3zZM4r7rk+irBAJtT3Oz4tYkzVHkMXa+EYYD8N3SS8ILGQ==
X-Received: by 2002:a17:902:e5c1:b0:1e0:99b2:8a91 with SMTP id u1-20020a170902e5c100b001e099b28a91mr5339831plf.4.1712422114345;
        Sat, 06 Apr 2024 09:48:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:33 -0700 (PDT)
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
Subject: [PATCH v3 11/17] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Sun,  7 Apr 2024 00:47:21 +0800
Message-Id: <20240406164727.577914-12-visitorckw@gmail.com>
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

Modify the min_heap_push() and min_heap_pop() to return a boolean
value. They now return false when the operation fails and true when it
succeeds.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 2aee024ca883..889d410862c7 100644
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

