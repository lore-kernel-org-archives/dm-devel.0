Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E21F2DF7D
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871258; cv=none; b=uouMY0NxB0wHf6HpfVQtEkRGA6llrKu7q2tMR7TyY0J+WHsw+lw5LHVue+QMM3Ze5UIbibgemttvfeW3eR9g8rXs5WptEoK320Qs+An7D9e1Giq4k5eLF697b9Ea8EEx0lOQCgsZBThOoJh3sJldYfbTUBkGI79yH6eDXI0kN3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871258; c=relaxed/simple;
	bh=B6aRAqV6zp5QyTg3WPpruzaUQrG1xvKUJStbcNeX4Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QdsT3l86t28mc2g5FycbpWll6aEUONdcTfUhLScZj4JFMMMtXTo5kSRSuoIzJshopPbzC7W+BUmGspyuFOOcc0NG8YJEU/QhV2SY/F13CFr+xlWBbtT71tpobPX+TYKn9mhxJnCAbaGlKpeBxT638iSpY0vYu0YN8JCPSrDik9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P1cGcKvk; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1cGcKvk"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dde367a10aso4303315ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871256; x=1711476056; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXm1fu9C4vX46h0sj29/lTEeornZUsKUb3fjEsz6jiw=;
        b=P1cGcKvkTMIinROkD0rBxv/8W06VeRwvOZEzQ//uM2N28Q6bqV7uYfh1YhBq2hnud0
         618iEPDWkOPLmeJ3Su4+BY2Ugj+he32GHTJHLP3yWkZNqGCzMtnicKCclrBcMv5/Jhfd
         TNUXGz5MK4teHoITAKhY3AaFNtlWhty5zS/g4HQfL3fnuRxTXDAX21LeqsGk5LzmcnTI
         Mydv/pGcPK+acBSnldGsSUT0YQCAo+EHCo2Z7I4b/GTGe3f6ryOZMTn8aSt26Lx21fsG
         sjJvYZFsC79XRk/RCYKGNgJYMS6EI59sVKNt+JMfah/P0g0WmjsMA5pXIQOG6byOwgym
         TqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871256; x=1711476056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXm1fu9C4vX46h0sj29/lTEeornZUsKUb3fjEsz6jiw=;
        b=UJoMqFmb2CzFhQI50i++eexLsVC0CHLorU/Gem6FPgpva5jMyuxRFmFPizbO+G203d
         YVWeP9ViwODf+aE0VhFwnT0sQCEE4lq7XuMOGmHQjazAksec19CVZ0EnRr6EkIp9f/XN
         qAUuhZKnAMMRjtn0Vp4bGPlFtF0Xia5y/Sj2zBJ8Y5cMtSAO5p8hnWiZ7NJBI2Peb06w
         a9hfe1K3pF9ppfZeEv5AE1zk8b3mfMk8ecAEbmN3M0UuhXCGnNV2OfTR3ldpODp7lfbw
         QTyYCD17JotVMjG5qNEscKz7o8TVzKhhr2l4P9zfUTJ8uy99b1B94V6EkfP0gjPi1aOE
         GOGA==
X-Forwarded-Encrypted: i=1; AJvYcCUyEf83vtY1DTlyPO0ByTE1Vb5EOaCy/RTkgkvsYJtM87ZcVht7P83vyX83WS105LhmaRfSx+f7TrI1JnO7ZmkTgyWJS2kcBpQ=
X-Gm-Message-State: AOJu0Yw4uVsocDR2vVtTk56JJGLj4rVAh2ynJQFz9PZ5UFcX+vlQb0Aw
	WyO5w3JFd5nBDb74UQBApSUxp3Zik2HdQfNWpZSLo/024KcusXO1
X-Google-Smtp-Source: AGHT+IHz2e9HCL5b8g4rCYp5kejors7FezHFbQ8oKlKDPjYAYoLpn1/27z4UODGEQE8Y/aKdKY5Jfw==
X-Received: by 2002:a17:902:e84a:b0:1dd:b883:3398 with SMTP id t10-20020a170902e84a00b001ddb8833398mr3095419plg.4.1710871256326;
        Tue, 19 Mar 2024 11:00:56 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:55 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 09/13] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Wed, 20 Mar 2024 02:00:01 +0800
Message-Id: <20240319180005.246930-10-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
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
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 97d8ba5c32e6..154ac2102114 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -130,18 +130,20 @@ void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
+bool __min_heap_pop(struct __min_heap *heap, size_t elem_size,
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
@@ -167,7 +169,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
+bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -175,7 +177,7 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -190,6 +192,8 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1

