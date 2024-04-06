Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579384F1FC
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422093; cv=none; b=ZGfM9r98VGnjRl1unWPnlHz9BUG3L22NvKb9Ep/iMPiJeimmDaPZ5NMzVWo2G2VlATe30n64qx1RBHmx4JSeUmGruYHn3D7AeoxHVm0kCGIa5KDZ91QtmPDSf930e4lz1+6hjbkKmd1jg69JtJAWRoULbnTCAkNUs0qVuZv+J28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422093; c=relaxed/simple;
	bh=9tjNBJoFW/M4N3UyhM3SbO6qdcqZWdxAoa5Ri1G9BtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oobgmu8hb9Cgguh8qJLNg9qu91OhchloGR/SPm90cRCcuyMrG6oV2mp1/QSwt2hmidIM6dMtswuB1ZLXTTFR9hSDagpREPXg3VIhu0evqITAmQ3PQ2KUobOzSKCJyarL3VNq51spOUWwGjJk+gDYw2ltrCxKU2Sk3mgmvB6QsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bF8BesTx; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bF8BesTx"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2a49986efc0so371120a91.0
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422092; x=1713026892; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=bF8BesTx0uDE/ACs/hSbPXtcdKL005duAt9GP4SBqk4SEwW4uBGW0mE4uK31Ska9NY
         Kum3W044dtgpROQndwCLdcF1qJYQfnKQ9VOajOCa06c5cwG5jpx62Arp9G4STca40Kyz
         pe1qFHLfx/FlQiQmjXlNxlEHXFp3m4ybAw5AyzZp5208SJZV4xc1h1eUamXO2o0L+P3I
         O3Jl61tE8iUUjhQzgEAXksKgCP+idyE0JKMU6GmnrcgDDUsTr6ZHo33QXG9Ad/d6jKiJ
         dYAAVB5h+dEA5DGBwcUKw5W/20N+rlMZgPK57adtcQXApA+cBSeqErL4KpUp4f08V80k
         KGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422092; x=1713026892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=d/97fLwSA3uhMawDMjvEWpfBNg3fhnux0d48HZ2DwuH3s8UEa6eQMBos7BuNay5nc4
         TBtxTePz/ocA1sDWVN2sbnHJc0KxciXu7f+RgfuDxxf4Y9qI6E7UdsNa6F2dymHg7pov
         9wZCjqqCdvaAM9iofHqEYeZKY4SlMjySI7GtMQEblCN3K29Pxp/buUPGEBMJ9/u8k1gA
         N61sGdMOLXmCKgRLzavw8XehXpDMrQUQmybn3Jjq3tTuldvwm/lu9MjmgO+V3w73Q1kt
         +n5iEbPW71FUE/Yq7vumVAuMH2O7gkfQGY1KEKON9HqLfGy4kDVACPL0G7vKCxH4cvpa
         q9Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVGY/wr4ud9YmVYIt8dqMOcu+RORxlI4ExaVwroq6r1aeweIznwZhH5kO6JFIooXYvR5GY/AauuRIajQlYIehzId9w8rAvZx+M=
X-Gm-Message-State: AOJu0YyhVlNKY6kdgwp+gjbT0O+7ckx5RMYedcU7z+7/ZXJ3LZlARQs8
	GTFH1t86EnzMghXgfaDZKdQm1RxIizl6uiLb19F7bOzsAUyIc4k4
X-Google-Smtp-Source: AGHT+IHNQdh+85x0jYef49alqMxJn+SN5Nch0RwAutvyCaUxP71hmbuD4ujDNqcWCeX9cqd56fRLlQ==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5606643plf.5.1712422091701;
        Sat, 06 Apr 2024 09:48:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:11 -0700 (PDT)
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
Subject: [PATCH v3 06/17] lib min_heap: Add min_heap_peek()
Date: Sun,  7 Apr 2024 00:47:16 +0800
Message-Id: <20240406164727.577914-7-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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

