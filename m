Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8897512E1D0
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564638; cv=none; b=aY9YVR9GftTjo3Ar0zVZBE6NYJrqTBG34d4KZkT35N+UBCmCkTkLmNKrVF2SqAYKcCphTPt3XCjXHLXt1G5TOUqRDj9wU2mtfg5xHWlzMO6sno+m5OgO3cmK9rohBCDQ5bzdxzGL3qWDRaRwhQhqnEJUPRt1tZ8u06Bw2bUQkJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564638; c=relaxed/simple;
	bh=CtmjnUhCovWSsS0eLtHZkP1gRg/+o2/rih6xjavgouM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PqUd5ZYSCM7HX+FmvLkrtZxKM1Qu7d2Ih6ncvajH7lkjvEF+1gzVrAtVzviDpjTCaTZPLXxmu9+wKB1Id96BTL7ESiI9q/DkBQanVCoNnhY4RPl2vemtWxYpsz2iFo8qT22h9X7OS0fRHpCV+T7XhWsxTbWvQqtSg/AwGFvuAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPWNVd7p; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPWNVd7p"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103285a91.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564637; x=1717169437; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYJrwbsUSMlgZtHUd20UudtqnzPzA+Nu3Je7Gypyz6k=;
        b=jPWNVd7p/Pf6jqdXRhT+B5OuIbwVf6nhRLEgh1YF2jsnmVyj9QeZgIDpvmU3a0XQkU
         AlYU95zKUw8iOOy7hWhiB1Agvc3TTjEGyXpBf2OX35kN7LPQzOk63+s/BG7+q6Hl+F5H
         K2hJbL2+dP5k27IFYuTojGCbK7zaqoKIZHnbpNQwUsRRKr7G9aokZ8l8FNNjVvjZmjI9
         ue75J1tjrRQpOhE8WaAfVi4SD6q+reZHzfugWqOjpJyajlNtwdvKc9nvEYYwu7R+zeF8
         X5dpGxeLGNRjulOOGkoHYDGlm4dgwQ+zhdvUmBSuGw4RDBYC7IKeaWgMYa/49qQJVZqo
         obJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564637; x=1717169437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYJrwbsUSMlgZtHUd20UudtqnzPzA+Nu3Je7Gypyz6k=;
        b=bNtsPWUYQa6KvVHua/kebObhg0GkzdqlpNL8fOMZXhJ8h9xWgjxhVbo4uumy14hRV9
         nqXqwc3NkgHfIRfsxdWnzYVWO+DGLKB9K8KpxltqWeP/A8wGWcNe5cgsSDi+SlqSsv7k
         D/HddCLAFVGPTx/80Xw4rzSkwpQVz/unbU2gLbizKvWyPUFrcU3f3WSzYDKra/hPerma
         X/R+6kSVZ790vM0uOc5LswzAxi5eRtOPY7NC3dNKTIgFsr2ajz7DselrFRtHdlvFzLlg
         qJ5gf4toaL5e72IdLiybG7Uln8IlvJg3FJl6QrqoWEmg9c5d5TSJpfr8siQQNJBW72u+
         Rt1A==
X-Forwarded-Encrypted: i=1; AJvYcCVNCm6/P1ZAv4kEDa86JaxRtHMpPfUpK6a9ztLpIc0VCq7sTtOVj/52ZA+RbYRw8FT36+SRIHlDmkENl5IWSvrhseJy7PKTfoI=
X-Gm-Message-State: AOJu0YwH5RjbOWjajgBxU808WDKCUpzCVfW0EWA76Ms67IVwIeR/j8Fw
	i+hqejDL8TqnZyOp8HnB837yfw+bwmbPy4ZZ/Tt8UYCRxj5sDB2W
X-Google-Smtp-Source: AGHT+IHoYwOCUaxc1eEkPVdFwpRkMAzYQsOk0wv11TzpiDNFWzl8TbRA7I/ssjXw7Wzjhb+pC2mgVw==
X-Received: by 2002:a17:90b:2286:b0:2bd:e806:49e4 with SMTP id 98e67ed59e1d1-2bf5f511c5amr2497068a91.4.1716564636772;
        Fri, 24 May 2024 08:30:36 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:36 -0700 (PDT)
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
Subject: [PATCH v6 06/16] lib min_heap: Add min_heap_peek()
Date: Fri, 24 May 2024 23:29:48 +0800
Message-Id: <20240524152958.919343-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index b384a4ea2afa..d9c4ae7ad0cc 100644
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

