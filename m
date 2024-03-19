Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5C5FF0E
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871273; cv=none; b=rBNqHST2KgF5BLVch8CT17l3TuBnFD6RyEeAzK6ILaDS4VjDTNww/1qHcmT6mKhtKO49xhTZ0shXXlGursqWeFAZNlMVxiFhMLJ4/qEnMU9mDcL+lyzhtKXkVSrpwBn9UefslmwpwBN7Mkl1SDeaPx7j5qhAsoougo24/gdtOPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871273; c=relaxed/simple;
	bh=zN440LBYznGYuwtfOCQ791ERSZb6vpOQUzA6Ge0oSZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dvdeeHvf06WXDKkmEszRcr75Sh9zc8nNSmdjdZAxnOwqVLt06Hx2abJn0CHzTG+DexcOMR2XYv9eVUCBTnPMxcEEyhlLS8uoQCjx2D6bPacWGz0DDklMHaF7KkfdgHApwl6RrL2bzITAiwUevtZmhbzUuz/DT59/DdINA0IBwkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FDkDkYQS; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FDkDkYQS"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dd8ee2441dso10461785ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871271; x=1711476071; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpLdHE6T1HFPzXRXZUEmHqfSXSlfR4maqjXPuXkrLoU=;
        b=FDkDkYQSNt2DE0iksu4P+uhSEmxGxfSD3H5Ocw7L7J8dB0FzB5BGiVA+S/JKYFOrac
         ZHBIjH2zRon707yoCypjOw6MMCn3UFvuot/5qKxgKUqf2wLkecoh+sujl8yG7jw9K8vO
         OPzeRyJWHo0QWshWP/kOFrNiUH6b04oxrw/yoVUILZ0vQn5XfOQTx38ZRGrWF2Di9YXV
         vGpCBTr77XTVXCV3zY0qMrY5UQmrdP/a82PFIVD3qeD/dXpSDBlyQ30gG7sdNp3G6tZe
         /94ijGw0BGltcm4kuXvLkWjAi7uLYvZEcsT1gDNxww4bxsHutjFNyicCTafrEaTISDhi
         lyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871271; x=1711476071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpLdHE6T1HFPzXRXZUEmHqfSXSlfR4maqjXPuXkrLoU=;
        b=j6zTjQud9vJi+0OecOFTYcINRI17D4iNqFeweNeqDJsgpxJvcU9GQMgBLQUbWo5aHM
         8XpgpMb8RKon7WU5U7vLmJt7DUOAo+Nuu2udoKUdrZLsDRZkHvEr7O1fqfpYA4qB/4bp
         5g2HKPpVp7C97mLHzOnOYGngQiEJH1mZ5cVFz8IHgQzC6rWXwhPxIbBIzuJU/0Ix7+Os
         jCNaXd3uifq37Zt4aQLj37qA3ImlwQ25ZYb9GPUPBhhj2iRRqv/FWylMKy/NXzlwmQ3U
         lnulSzGpz5tFV2wJH5AWERAv6/CaGjPrNZNQNgx1bKs+BuJUIiSRvkfImIC3bcc1TBpU
         oZ9w==
X-Forwarded-Encrypted: i=1; AJvYcCU8AnNN1bXCr4A+VxZ0ztgknOUnvSMK2WMXSBOx4zZ7YclNMGAX+t/cSaByBR/G+vec794Xtuj1cW8IpHIO/G7vVbMqiyjeFPI=
X-Gm-Message-State: AOJu0YwGrwNUSLohJ4zI9sz4Q16ZBSpIdIuWlPJua8ksXbW2tRT+KMsW
	AVEmkfVqJtmifMmWf3FGO79xkaQ3RsjsJb2ata0wR2Jdw0WfxrqV
X-Google-Smtp-Source: AGHT+IGw1tSDvoLNGEGY0M0BpGhYAxmYXXUZM6IM61Eb1OllvzIJtHYB3YwGJRIcRAUGbxId1L1ZfA==
X-Received: by 2002:a17:902:ec8e:b0:1db:ce31:96b1 with SMTP id x14-20020a170902ec8e00b001dbce3196b1mr3201058plg.6.1710871270937;
        Tue, 19 Mar 2024 11:01:10 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:01:10 -0700 (PDT)
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
Subject: [PATCH 12/13] lib min_heap: Add min_heap_sift_up()
Date: Wed, 20 Mar 2024 02:00:04 +0800
Message-Id: <20240319180005.246930-13-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index ce085137fce7..586965977104 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -199,6 +199,26 @@ bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
 
+/* Sift up ith element from the heap, O(log2(nr)). */
+static __always_inline
+void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	size_t parent;
+
+	while (idx) {
+		parent = (idx - 1) / 2;
+		if (func->less(data + parent * elem_size, data + idx * elem_size, args))
+			break;
+		func->swp(data + parent * elem_size, data + idx * elem_size, args);
+		idx = parent;
+	}
+}
+
+#define min_heap_sift_up(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
-- 
2.34.1

