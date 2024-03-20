Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB5958113
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946509; cv=none; b=LkZ4tEkLQSyUVzKTEyiSUq3cMEOjZi0VzAQximy2gxzMB6xcx7oKVZGGDumYiVDhtRj16b4xlciMzYXBHrXHdYY2mKg34UZ5QICoeMRWjV2EUqgusWVhl9QaBSqywG9EK41VuQnEA40ZgGLAOSCxg8M9jJIgxjRVVURDiKUTRX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946509; c=relaxed/simple;
	bh=3u7SHTx5BWR6PFeMX82UOtRGC+rWOaoSO0kUgAe6Dt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KKFvjk+wVYyMOPLm+wdUO+to26lldec2qIwSjI6wBoBn8jFXQtKQ9V1AlL9rBCfT5ZR/ILbeyZSLkkHdlVt1I3z+DfHNBkjDC1HG5YogiikZgPy8RwI13naEMEOgtNF0MDQXqP9d+DqYOiBKO6z5lfdDmkSOzsZNyiWkxBiMz5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lz3N1YIu; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lz3N1YIu"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dde24ec08cso8716855ad.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946508; x=1711551308; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaX+3tHSfR6Y1hlzEWAzFG8m2A4U3O7BTlzKixVR79s=;
        b=Lz3N1YIu7FtUGBdgNmjItSJ316cEsWaLJCsc1zUFVbV13A52eGoivicYTenIqiZQjA
         0D2kuzHXGemD2bTXGbZOo9HBUKBrdrV7L2ZgD0P0Yg0SfmRZuVDvTdrFZfK/vCjlyLpy
         5L23civhaUiuN4nP3qzYSi4wHm7yQYKumFlIfI72UZUjS2+MnLUeA7yA6AgJROeRiLLj
         CS71z1Zuqm3tW8JPuoNicAdwr91WMw69MbI+unU94IBAmLahH86qTH2sksPi7b5oyqdB
         z+qaPaAyBbD8dSM3II4ajBiA2kybotbWcy+4ipakv1xt6fuw7N5jEwKCbB9Vpoq+8sbp
         vinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946508; x=1711551308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BaX+3tHSfR6Y1hlzEWAzFG8m2A4U3O7BTlzKixVR79s=;
        b=F4/0W1yBUpJOqteRu1uc7arl9TVWoqOgMgAIbTNSj+eJbcWT5hACdwOaDPlAhgh+Uj
         XWax3eWaJPhp/zKo8U/BoGIvLRWjHqQE0TW2KluY0/sTX+ntaLxjXo/g8mBjGnsGskG+
         +G6uWmCwUTkqvur8xzupU4IdMhl3oqAWvfRtEwuHi6ZGWSZsSgoDf5rTTouV2YIvgkSB
         /uLAGE2u2pj5OCfUiIWxphf1kzIesP0unFmh3LZwDfh+LTAZ8xmwBhrhmbnSZnuW8CtL
         xu4tcKSIGyTcThMm9/vlQYRXkfGbjVqfP+N/5GWK4Xwexf7s1lRLTtUykmOH/EElm9/0
         aRew==
X-Forwarded-Encrypted: i=1; AJvYcCUbIGTeT3Jp0jvBjx2BP4JRpgkflNgvQhwC+1hNuLF1Z1LV8+DePmPh1fEoYtJJOhsRulg6ycqlUPmW97cwaVHKpK0yl6msMsw=
X-Gm-Message-State: AOJu0YxyoCC10gQ3nzVfDRv6TQMKT7MtW+VCZD4v9QzokIJf5WVqUS9L
	hD2qzl0/Pv9zPQO+wZAQ74E82PcqaQ7lh9wgoD0CH/Lz10uuV14i
X-Google-Smtp-Source: AGHT+IGd6DO4qwAk4p4e7JmQ1R4ZPRJj4m0jMv3XVjEK0nV1sCafyICIXS1wY7+2qQE9k1iEQlC2Rw==
X-Received: by 2002:a17:903:18e:b0:1dd:b54c:df51 with SMTP id z14-20020a170903018e00b001ddb54cdf51mr6005831plg.4.1710946507885;
        Wed, 20 Mar 2024 07:55:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:07 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
Date: Wed, 20 Mar 2024 22:54:11 +0800
Message-Id: <20240320145417.336208-10-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
References: <20240320145417.336208-1-visitorckw@gmail.com>
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
index 36023e0be232..af12531474a4 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
 
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

