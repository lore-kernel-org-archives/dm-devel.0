Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3567F131195
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564657; cv=none; b=D4Te7TDacYBgT3zVWYXEEbnu+1exxe15ZZ+X7KjO86BTM2bWCQafYNAUuU654GBiwkyqOj6KHooAkIpFfChPq1GZ0UR01mBTB6g0XD9pcFV+nd7k4qqwuGgHTtL7Gm5oYCeuLLgxp9tEBMKRorbDYPrq0CjlE9y+M4qvx+xFmx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564657; c=relaxed/simple;
	bh=sJJvbSyrqr9RfqPlGBQxs9diGbsYUKhy8zMD1EMctXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X0swQvJQ+FSnHbaCXS1MpNKVF5MoXPB6u13fpHE+eHkpnUnhNF9/jlYYdyotx7NfcyBL7Y+UBro0O+1QMHOYd4RyIOv36aRtBj3uACMPnN1FscAb0d6ds7GEbnkz3Z5toczLsDKv69csWanCiY+D/UtMixoyn+WloYNsFq3+cqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mx9guNG8; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mx9guNG8"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103354a91.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564655; x=1717169455; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lfmbsG5rvd+B8+9dE2AYffkU5kvksfUycCfh2ZKaE4=;
        b=mx9guNG8WlNz/2YUraB2IZEKAiyiTtPa9SAluKzIi77UZwu0A+Dms4/KImLOt9Kf64
         LLi9kF0Ugf0wvBQjXVGvzj9VDw48Vp4feoDiZ5hNzttCBL3N/3pZP5HSSYEy7o3eK1Bw
         x5uKqhT/W/OF+k+2KXXOR2myBtNu24RgRLFk7Fx4+3uLj0ViKHn9fwid9tT7O7B7Z/Nc
         mUQjNAK1Z7BOxT4KV6vajnLtTBhEQfZACT2c25hr2qEHIvAjC5cGp4onLAXarnOFziOM
         DIcbL/I34yNACBwom82hcUAdxASarP3d7gFKjrgc39bielq9Q8YKYrcuLwWwiNYm86C+
         XKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564655; x=1717169455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lfmbsG5rvd+B8+9dE2AYffkU5kvksfUycCfh2ZKaE4=;
        b=kz8GgQD1BGkRgfU9QBIXLAHkDhf9VsNuvQvMhwLj7lkhA9YMDf+uHcu+ry8dX95izp
         UbmaB+frQzlUJkCGTAF+cFnsYGxd89JlS3eEok1rLk9toBqm6C3wByIo3bp5A7CEXARv
         Vt54U8bYceoJ2LG8xY1u3Xfncd9/3SDBcBw3aB7+kYZfeSd5pM6/7DFwZXqpt5StC8fT
         JNHAhwMu/oJpuD2rJw6S8MHbqWb39bfUQFPmRXCxihGgkPIxAjXjuCYsKFfcnNEkdXBH
         pC5SHMbuK8wEIhi6YZyJaVwAg3cLeYiGipt1bZt8GvSd8L4VH4BitLzK5xnLhRV2nVhm
         cJnA==
X-Forwarded-Encrypted: i=1; AJvYcCV+2QY6lHOwSSaL4FJ1DhT7dlamUJ1QwOiJpZrDUYfvgJpvIkz0w2u+bdm3aXwU7Pcu4iuS0VxhRVlOlgfYROnAUoCNwfPE3Qo=
X-Gm-Message-State: AOJu0YxfluA0uqIAtNpkfp/B5WM0Q+U36DH4qDQP+k3W3eOVmv4YCfDh
	R9WgDSN5xfe98M3FMcZCB5fFMLRbLEnn2YBAV1TbBLpqQMp+c7+W
X-Google-Smtp-Source: AGHT+IGLW9yYebnTwkf31N4DQ42MfzPeT3rNQKrGi7/d2boEiBvS/PxpOdbDpM6nd0O3UUnbvMIB5A==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2505960a91.2.1716564655542;
        Fri, 24 May 2024 08:30:55 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:55 -0700 (PDT)
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
Subject: [PATCH v6 10/16] lib min_heap: Add min_heap_del()
Date: Fri, 24 May 2024 23:29:52 +0800
Message-Id: <20240524152958.919343-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index ddd0186afb77..98e838195e7e 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -212,4 +212,28 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+
+	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
+		return false;
+
+	/* Place last element at the root (position 0) and then sift down. */
+	heap->nr--;
+	if (idx == heap->nr)
+		return true;
+	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
-- 
2.34.1

