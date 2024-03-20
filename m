Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2F44C3CD
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946500; cv=none; b=OSWJUG7S++0ZF6hbDIhikgFVTWK+sQsvElOnr1JHJbX/LDchHHhFcsI+Pm6of/EBwKCqijTTGvA3UZCMluiRiJwHTPBsDCri46vld2NWIq4z0M9rV8/4J4XA+whjoac1KbDpNpp3CrELF+ncutJuPsVGb+V8JS+SNtmhoacyEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946500; c=relaxed/simple;
	bh=87oXCcVzX378JZ7P9KHFZTxbp5kTVN7ioJ6nxJ/kTRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sPODTd6DSQ6UBv62fCqJsTZXQ6pOPhT4VIdo/UEaVPrcHG0ykwHgtBeCcJsbfsJ+KJ2sZTmzKcJNngKiMorbI7z2lmbRExs2UANMEmmlzk4SpUel3sGc/dy82G3ElKdQN7zBNsIZ6FY5KHVE/QeOpiRgEdGV76xPg1W5OuTjZuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+r/YpOK; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+r/YpOK"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e0678265b3so618355ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946498; x=1711551298; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wlW/VG1bZr/fW5x2pRSDPzGgSGqgaQobdRLr7/yKpQ=;
        b=a+r/YpOKp+Vte8lRlzYGEGiwhPvKy0Fx0VgZp/oVKzisqcC/Xv0HFw3naJl8EEDfQH
         cNQake1nnwmDqDjd49CC8Oa3XvJ4Lb4pFiQhkbaPfUgQoW0yFWR70l28Fwg9ybU8QJ+V
         6KINhfCnNJc1v81/yQl99OO2udUENogDobuJBjKOmHagCtarLguQWYY53ooI370n7/pX
         omhTLKIPI7WFDqrhHuX9dC/kaBbsFxKZ4u/7kIYOkIh4OBvBmVgCPrKiq3JoLZFtizCL
         CwkurKa7EUJsgOvvwFqwQQI+Cxapf/jERvTzq87Pl+GUFqujwtcsjfYsZQSeeNt6NzpF
         p2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946498; x=1711551298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wlW/VG1bZr/fW5x2pRSDPzGgSGqgaQobdRLr7/yKpQ=;
        b=Nk/n+wy8BwsLSdOxo0jPuoXL2CJK/MGbdTUTmaK3ca+6jIn/XBmr/C8R+rE9L3++Se
         x+/les8O++s+elZNE/Jv6kOD1XDsBdaCNsFUbYnoKiF6RxAQqHJDzR0ZS9ci1PKxOGUA
         89ZCLKTfImtfV+b+W21eKWOsGSUG++ewLlKJH52r//IcQSgiO3sYq75qzVcSQZMRcsov
         P3JXVkL4ZFroXjPfJ+lmJYu/rHPX53/AWCVGBEAcYdrM9p4uHEf/OrOObBtOfxQ7vwxV
         p5sMpVFAw9GFnoonYq5VZoW+t4N+3WopKbQ7CHxHHwMKcx+OA4TIeAHYrBkfwaLcfzfY
         TPvw==
X-Forwarded-Encrypted: i=1; AJvYcCVaUSu+xM1EKBRjBfgiwnTlo5vYoW3rbEYMcw+0uuyxLp/g4vS/u/973P4EARLB53RBir1OJpPCTqaI0SSGKqiILgZV3eBN7UA=
X-Gm-Message-State: AOJu0YxSl2zaYog5iA4J8srXHC7DIjRJpAbYf7LwOe6qwJJQTFpC3q9/
	WTY19iLPbnGDaI0t3Ix+Cyx3JXLtgONiO6A6Ow82AV+wlWQlZw2PLXBtr9WmSM2O7A==
X-Google-Smtp-Source: AGHT+IHPNXqxNRiHHdL94gEllLU3VLR0+ZSU1ayFv4vdbYAP2+XpkPoVncG1MrhmG5iQ5COCDdzKFQ==
X-Received: by 2002:a17:903:1c1:b0:1dd:7c4c:c6b6 with SMTP id e1-20020a17090301c100b001dd7c4cc6b6mr19250306plh.5.1710946498281;
        Wed, 20 Mar 2024 07:54:58 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:57 -0700 (PDT)
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
Subject: [PATCH v2 07/15] lib min_heap: Add min_heap_full()
Date: Wed, 20 Mar 2024 22:54:09 +0800
Message-Id: <20240320145417.336208-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 7c1fd1ddc71a..b1d874f4d536 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -66,6 +66,16 @@ void *__min_heap_peek(struct __min_heap *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(struct __min_heap *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full(&(_heap)->heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1

