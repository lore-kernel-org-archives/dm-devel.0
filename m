Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF523748
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676484; cv=none; b=AecWhMerO4s9lYNNq3IYjKCeGcP+yiLpSSff6FCGr4lmQnIbwstR6yFCyrsKzKJAcboNwJggcYUeDhjvfEgEko1mwbbsv+Khf2Ozr2lLLe82H/ex2LYk+tGJiF8NIIIbrrfLCl/xZLKJ3jFnvzmZbtN5GGT/efMSrZWn3anA5x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676484; c=relaxed/simple;
	bh=9tjNBJoFW/M4N3UyhM3SbO6qdcqZWdxAoa5Ri1G9BtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dJQgBQiBGVWCeNjGzPs0JhYjRclltIzNhY0BAtXFQTdxFeotphsTB3X1cb5B3mJ4LBSynt04lPYRBAzXz4fntXQCpzn1K+wDL6V+UdXmpOAg3SaH95jYitYI7wGDPNXGYaoTVdkaVtVWUaza6HiWF3K6pCd9z7dSA/gLE51luzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKNgF8Tf; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKNgF8Tf"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2b432ae7dabso1398246a91.0
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676483; x=1716281283; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=AKNgF8TfDNXYyLTFPUtcZejyVQfTIzKRbYp2kAoMTGBdjkK3De9B6bO6qID2xTKeNB
         HzWwkjbo+A8/Ic+YGyMNvybU37xeg/KNFcmY6iilrWHd262VRvY3SxRgZ5UJs/gUgOtb
         gZ5cFIGjww4LNi2RpzjVP1NtFNpJmcD7k3D3mV0zX3qXZPb3wmjJ60bykcUbgqrx6h0/
         xqmB5VnOjwXIVJ/iLzLQxW8+doTsSn89pmZdcdTOcz+j/4Pd2VU4R4pXOkPN4UzuVWfy
         WvT2P9xtlJubyjQ7uJmGOxcUd3cvXpITJTmgJm60jJe+4EceEciF8NXJ2tWakixANEqh
         asNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676483; x=1716281283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=Kpr14keVWvUECXJPxBLt5mez6pn/OFILJIGW4rLtzXkbkLgVg20Q8pFBcLKc9QXJVh
         LkC3wvlafsarMQF5tFT4TIn+fn7MzZ+oVNHOKcG4Olsz76ds7qP1IwGLmkpS6srgCvJt
         Ev38atMPJTEUVD3kSONHQSqA7ASRQ/KsT6r1+sBksqOYY8U0o/ZXflxykcDPUCfPBVVD
         Mg971pUtMg0zfGxX1XoNrcKwrZoP6hJ16d35E9pkZXLOd/MrYZOdhLls59OkuGy6dmM8
         rh3ouNJC2IzXDzShUcmnbZT4+XSS6gtUCy6J7RQh1x/vsq58U0JknwrjXHkTSPleSaOQ
         pS4Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7Z3KeAvtq0iUoi/P4wPwOuiZIWqYb3JcN0amQ2A5kfPgwWxo1dD3GM2WMgH8VwZkKpiMScV/COkiT5FuKI7gchb8GN6fyH8Q=
X-Gm-Message-State: AOJu0YxOHLsrY0yYgm0jMAslFd445hAI1aedAL1GgYT0HOGCTqY1PfK/
	90ORjoeBD8fhBg+OVIB0suQUJbLF3w+IB6ikgJJTNT+79eExIF+J
X-Google-Smtp-Source: AGHT+IE1patJmPNchHUnX39Zems7iVVjiSomR0wHWIH7h7asJlDmxjS39dyTAxeWrilwIpfx2hdfuQ==
X-Received: by 2002:a05:6a21:7896:b0:1ae:42c8:4f69 with SMTP id adf61e73a8af0-1afddf12a2cmr15147500637.0.1715676482845;
        Tue, 14 May 2024 01:48:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:02 -0700 (PDT)
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
Subject: [RESEND PATCH v5 06/16] lib min_heap: Add min_heap_peek()
Date: Tue, 14 May 2024 16:47:14 +0800
Message-Id: <20240514084724.557100-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index f6b07fb8b2d3..043de539bf71 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -53,6 +53,16 @@ void __min_heap_init(min_heap_char *heap, void *data, int size)
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init((min_heap_char *)_heap, _data, _size)
 
+/* Get the minimum element from the heap. */
+static __always_inline
+void *__min_heap_peek(struct min_heap_char *heap)
+{
+	return heap->nr ? heap->data : NULL;
+}
+
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1

