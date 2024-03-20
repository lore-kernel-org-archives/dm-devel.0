Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7C65730D
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946505; cv=none; b=AjUnWen5k5dySlOUifRmi1ldzy6O+iK2YkTYGhgo/c16RvDjODu4AQvbqjdok1u21eQOsVdgJxa6+deWfA3oIOid8x/GIi0CzPC4ilDL7a9jCsWaoa/YqTXBVvQUtztD+reL8ddR9IHGuf8RWX1f2heImlGHZ+oRYA2QVWHG5tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946505; c=relaxed/simple;
	bh=qteByzsELspBqYOuIARYBU2Zdpp8cSKVC+Oyjn250gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rOWKuEwU1egLjLvYUndtCalgQaQaK82b2fUkYWl5qDB6BPWsbEFQrHnyw1jUo9tSlWzQhnIaGizM8d1KMbrx6pOwptSyLUIGPIPSxMaSwLD+3rW6F1pJOQ3i92oiKEcnY2yaM9FEBEr5JKPGUmkecJDEDdJz/qgaOg+jG/E5L8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F46rLZe8; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F46rLZe8"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1def81ee762so9760675ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946503; x=1711551303; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQWgWJZiZRkB0L8mwTWbJhKi4LMazpagttqLDd/n3Ao=;
        b=F46rLZe8jEuJE4ZKuooXmFYy7sz6yN0YSovZrHAnTTkwKn+N1Xw0y42RPzHmVgt0Xm
         KatITplXq/7aYsMfyci9NAV9airfzzBjJsltPZJjR2X26jmVXENGEkVrXP8FNmXT9YLI
         pVGqt9DaCoryKDRsfgAQKP+Jz/tM3sjHCrXxVEX/tlYBN4lZWxBnQtQXlXUvMvoe25zH
         eQDk7tAkUUsiF3yLTUjIZXN6/RBgeAiKilnmZ11rXVU3QVyrZ/1+OM3IJC4p+qI6EFFX
         3lIAJDHZHWMFWyBBIvUAZSMWAIuplRYddypCEJE0I2EQ0YNSqLQN1fvlA241DhPlikNP
         JQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946503; x=1711551303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQWgWJZiZRkB0L8mwTWbJhKi4LMazpagttqLDd/n3Ao=;
        b=pTEKuH85EiOvfQbN/OEY2U7K9GHnImPPooeX/7f1wyCPktAJCuEinEUxrQjPFQ2t2Y
         0AKlOAGQVJHEqyF/tkpBmDm0oS4/QRsFjYWazcpHAPjQv0H4ja1p9dF1rJ4llbUF4CN6
         g0uo4Pm22s2Dow6kE6OC7ls4j2WUR/jdiyuzGcgbu9ZH6XJ9LYmHSF5sVxPQnJdpU7mv
         c+/6OF+m6V7ZyiHdUtQ//bUCISQWixyatga5Y5pcHPPNbMGfWGLwghX14niZLTt5a7PA
         1359Fed0JrEUxkxiU3UjHdnrQ7jIsFY5MztEjg84HkQMFLsgOL8pebJTKHfMelr3vfHH
         bwsg==
X-Forwarded-Encrypted: i=1; AJvYcCVl9Z68xVOUhKsWmi2KIY33lAqFpAd51saJ9HiHqavt49HG4wZpYCtA+UE9l+9QbSZeRyuXnEE77lvJYl4cLgacG+vJb/sUdyg=
X-Gm-Message-State: AOJu0YxlnftMuVQE6mSdJ6xWqFV6dVJBOFaul/lsYICkClxcy1qcnsvW
	uuVJbWMwJNOt0kP5VqzUleFAUT1RuLBwrAFiFM/7EjXTIIHluaXEuAxo+x5KotNr7w==
X-Google-Smtp-Source: AGHT+IHQMu7VAPDiqxJgKvWwfBIcERpY9KKEw9e5I4279Pib64kSmLnENjmLOaIX8wFBH1sb7n9z5Q==
X-Received: by 2002:a17:902:c94d:b0:1dc:e469:6f5d with SMTP id i13-20020a170902c94d00b001dce4696f5dmr6103504pla.4.1710946503210;
        Wed, 20 Mar 2024 07:55:03 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:02 -0700 (PDT)
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
Subject: [PATCH v2 08/15] lib min_heap: Add min_heap_del()
Date: Wed, 20 Mar 2024 22:54:10 +0800
Message-Id: <20240320145417.336208-9-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index b1d874f4d536..36023e0be232 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -194,4 +194,28 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
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
+	memcpy(data, data + (heap->nr * elem_size), elem_size);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
-- 
2.34.1

