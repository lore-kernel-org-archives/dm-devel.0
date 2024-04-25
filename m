Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D2149E0C
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054767; cv=none; b=tYLcLrFMfEX95eVsINNBt7TfFLKn5fW3fVSQJ3dzuWW+gGJESXeDuJ1P3ZDV3m7hb7wrntYEOJbHe0j6ohe/Xln19fxxWNFj0O4n6v0iKZ7aS71MKp+csi9kIxeZh4gLF7iGiXF3QjSKjl4xw++00+4bkjO5kh76DCfrhtYE+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054767; c=relaxed/simple;
	bh=PtYRw7GsavxbiDyoXt/jBI3j/cXrR77rkoPNcWtU+qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sHjzfk8Kk7rFQXRZalrNe5kG1mJhSwekArvBaYIu+4fKu4xtkW4e7kzn57Ms/b85AdEXLeBBfpOmZ4olmMx6PFDPpjrLcq/Ii0ixvDGp3thoL1Kj7Fnloix//FOmO/H4qHqkkb7P1PmWyzWHM7HOv5TioIVBigJ8uonQgNYGt/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnrgztXm; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnrgztXm"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f055602a7bso56762b3a.3
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054765; x=1714659565; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=RnrgztXmMJjeIucW8M5U1nEoj3x7sQ7NorCYE0Q2tJePuXCvHkTM+acbVnRDMJLueL
         IdDZ7apdTMmpkPKyBYMKoakugIj1Et+IGFjDN7uYdxR7q0qWryW0iRQs0fvAGQUePwO9
         JoEX0+KOyC8O7DbRA4VfOoaT5cyBBMETcvmF4zHXoyqQ+Zh7IpIwXEXGi6QJCf+2tssR
         bJ+Tz8vQv4mIWOULyohhs9lmBE2s8Hszj3ozI/mDXN2yA5gNlmWLLrHLPywyD+js7MN6
         cognof2q3XBncpmWRvXeO90fUGi+TAIUPJ+/IVUmmOB4T5Zldtc44xT5BqqdVngcOXUU
         /qxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054766; x=1714659566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=a9IIzi2j+Pab32CmAMGtcktbfpHbs1al5PIp/EyPqsShIM1HwGJTLqDhnXfAGOR+t9
         DyJ4219GTyZrb2poaZRoVOf+IhuSR7S41WMEOUyxngzKorBiInc9R4PXQ1g5AX40SV/m
         ny3W6W9C/35cdWsLZorOWTThRmElAvdhm8PlVMe4sMSiZAch4Q3mbf2EaiSVERLR5vcO
         J0q+yXYYXQsBht1iRxpwKNx4eswBHNScKQrbbVPFppX7Cyvd22ZeRcqAqEFbC2kR9h0b
         GbQ1j+h5UauVcBcOY5n9Dq2U5LSyB5O67G3tE5DOXtRMGeYKemC1KoPM5aLn5VD0tmF/
         WGHA==
X-Forwarded-Encrypted: i=1; AJvYcCWL7v6X3mkDhgR820g52EAponsmfkwmzzf43kOPR5UBfeSh0MW/3fKFMbOHr/ejBko2TIUSpgIZibsqpQEqtF7rmxM0kpkgQjU=
X-Gm-Message-State: AOJu0YyQQbios6CguuSBazy2MZYXV5ItilBZeQz7/jzjkLbfTNZT1/fi
	TiBf14rlnK9LuPtNXZMmfW7ZFB+YNWY4s8oCA9D4G4FQ0sp6Bxs34lVZBecy
X-Google-Smtp-Source: AGHT+IH3qvR8DEaNgNGZh5Udg5FgEG5PQHj+EW7uZq/SkmKUq2NA7t4laHBCtISEgyrlq7ewHbhqhA==
X-Received: by 2002:a05:6a20:158c:b0:1aa:68c4:3271 with SMTP id h12-20020a056a20158c00b001aa68c43271mr7357457pzj.3.1714054765579;
        Thu, 25 Apr 2024 07:19:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:25 -0700 (PDT)
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
Subject: [PATCH v4 11/16] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Thu, 25 Apr 2024 22:18:21 +0800
Message-Id: <20240425141826.840077-12-visitorckw@gmail.com>
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

