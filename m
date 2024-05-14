Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE5208CA
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676505; cv=none; b=F/6Oytje0bZeovfujMuZnI7Z6x1/neldQKOpVHYFmXGjIm8WUYuRvY5tEW61FfHKdAebcHzXbzFM9OOpY+0jIo7e9HY3uZPw7OzHRSyCZ15KHQ9XB6s97kKLoQfIGZJc2lsEle0L6/jbAm8I4bqNDmOlKqQPvvlqsl8UECdahk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676505; c=relaxed/simple;
	bh=8grIJogka79sG9/+DDK77OmBdavevP9vGHfoCgHyPhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GHYCR5ACaBQ1cytg92wIOVGA/DzqA4OAqQctfvbIWNR+FS0APsxDFiCKgpL59PcS0F/ZHVXyaxg++26l4yagxAusH31GVNGzQBJFWB1O4xmoVQxyRAlJ0mk7CE7eFj3A97lfoiV4ls45HBzQ/ZUBIsQq3wVGkWFVnSmPF/OgcAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UdW/n20Z; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UdW/n20Z"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2b2aab2d46dso1233028a91.0
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676502; x=1716281302; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSnssd6hPC3K4+9QwFoXbrNCoJbqsVd1VI58MolSit4=;
        b=UdW/n20Z3h5UPpta+KITqKnWFDkQwUjwK5ag7FRALydUukpAYJNcS1ElElKxIVz9Us
         pybxEcV0ougogp3XE2eELOYMJ8m7/tI5fAvAGXCsKpy1Dmx7CJxYpiZ1cm1OfT2bi4tA
         wQ1CKO0Uk60zEHdmHCOuSH1uVDV4nLpD5b/KMTXq0Cw9RKrLk85ZsefizoQe4jEaNoU3
         vLdGAaTGLlCvWvMW5G8VHtr2XflCOPNIrPDKc+qbhpLU9HyaEAQa/DZhqPALoXx7ZCWa
         UFB01bsZz7hSML/pOyH3wBhRwWTCJx1WGIcVekaY/y54FBYXYRfOu365cu7SdOxDBhRk
         nUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676502; x=1716281302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSnssd6hPC3K4+9QwFoXbrNCoJbqsVd1VI58MolSit4=;
        b=ls/ZDdzj838aK4nHko41v6XHUKjptuvXXebtOKwLVT0U80xC0FTxdiPJff5XFj1BfJ
         X40IMlwt4MPwL+4LfumyT9y9swwIKFhQyu4YWRMcAQ1KaUS+3UKXQgstBg0gENyZtw0c
         soPO1SyiFjUaG0Ou1NhydsH0mxNz+o+FQpfkWW+RX+daQhRqL/lc2T16rH1M+rYHZTJ3
         7U6jhHS+tjG8aM2ThR2ay3CTOqiew+WvJbshJrwi2xqh4tONzolC+R6W0aNvb8eLxIyW
         NUAvv/MbpuSSeoUpMSokPP8I//pMufvLAGDLQKiPoTtVsHtfL5cQQWcuU/5F+W9qeMnZ
         6vUA==
X-Forwarded-Encrypted: i=1; AJvYcCXehnjaAE7skvD2p8lXdYr8VWJiClpTjQgFntKvSZ2gKlq1UMngpvv62fqq9afdIWWo91GPbf4DNng5t7F+3NMuyUEjYLauq/0=
X-Gm-Message-State: AOJu0YykTJwv0CHTdXh4pMenoWGmmGI6J/LlFjMdB0+YyainmETezB52
	ugU2DLabZN+L9pIS+cvIMa7WXdA6RFWOmYLoGaH3bSQvrfkkciQ5
X-Google-Smtp-Source: AGHT+IFPNI9RtyTNoKPikm+afe8TVCRh8CRN1TwrBLiqKxWH2jb9eMRvsssng1X4+/efPHjACEXLew==
X-Received: by 2002:a17:90b:354e:b0:2b5:fce8:59ef with SMTP id 98e67ed59e1d1-2b6cc452fb7mr11632747a91.1.1715676502501;
        Tue, 14 May 2024 01:48:22 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:21 -0700 (PDT)
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
Subject: [RESEND PATCH v5 10/16] lib min_heap: Add min_heap_del()
Date: Tue, 14 May 2024 16:47:18 +0800
Message-Id: <20240514084724.557100-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 201f59cb3558..c94f9d303205 100644
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

