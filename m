Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C121950269
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422098; cv=none; b=VqQRe08W3zoab+HacOGzNsgYhS39PLZd/4WxtZydrSBX3/+viYzVKL+OUq2+wDMUlKQ2e6JFFuFC5yYn1A2uDQniqmZa2WW7A5WzCIkYAFD2R1oHWRx0RVx7ucH68uIM+TP8kwVPgSrKEa8sUpsyvKsfFL8mIa5sSJcPUGoFM2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422098; c=relaxed/simple;
	bh=45DqO8bF1UCi5bfdHVSu4s8AvmjNFknYLPsfVsf4ic0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EMNDEthNwWr7gjwqcgOMLJEC3M/VTkJvq3roASfmULaFMUTWZRIiO7rm8ItklCBD+UmIsHLY32AZaLaezB3tz7N0JJ6SGd1wZvD8+cudiTaC39ZhXoV1ox8KlX46tX2iVoYqfTnj4gyyE02poOiSH1M64G4i8NGArGtVRaeDPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtqbBs7f; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtqbBs7f"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ea729f2e38so812943b3a.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422096; x=1713026896; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=WtqbBs7f8ae/TWgLa3BgecOrmuP2uXYDMZV+IxXonanWj6a/r+mPw1/9FKWUjzbM7K
         evE6R5/wlulgZZFXzIrR78CBVM5tzKtxsnekZG51hjSdVifERSDrfT/UdyaXH4/XH2Jh
         9WUUib9oNyITWEQoLic1KTbqsQYg8rQeYjShoSRQuM3Jo7NJGbVdGDpFwTrNjqIgh+2h
         NP4vlpDA9eWXkDXwmTAJ5z8h5V4tN+Z77HyHFHHpuYlmJ6geB53I9Hsj4U3Wn8Hq9DRi
         xovGPudlSM/DWkPBlqprprLBvRYxdQaf5Dkl5yZ6NgONP9hCFHO3vuPibW4vvUO8FXqC
         dUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422096; x=1713026896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=XR29+pOjyv4nCMFB7eex9RITTCXvlOlS5u5pFv2y1mFKNEwS4nNAnscQg+5dDPSX4H
         d1VebQTXLYJ855MlfKv13CFMUcIQMsO/RSJEQmRhVgAquBnUj86ds/2RHQD+vt7wtfDu
         qk2j1S1bllUQt38NoV9pbad89Kq9o8kjFM/2AgjQ5RbrpsHJ8c2IeiSKjZnnM64GFu6e
         QZp7suSQ7Nq5ut0KfdC9KviXJ6Tylxldw4FlKBg+FG634maAWZBIJuxmcN9D0/55r81K
         FF+SamTNMHVNpR08Sxz2Y++Ew5Y1FXdn5IWYseZsPeqvP8g+gOi0oVxx/0BEFHj8OfoG
         0lYA==
X-Forwarded-Encrypted: i=1; AJvYcCWzqBeB4rJmHGaydMmcaK4Qr1V/eUdMwE1vSGJnLQLfcpkGbLq/ZuLHVCFJP1t4rPtyxsSKj0+NT5Wehbec9j9g9MeklMG+k5w=
X-Gm-Message-State: AOJu0YyJQksai/Qp6TD8SJdWxkCcPw9Z7mEMdVR/cRnmqWyfL1nElRPC
	1Tp4FcdwLt9rP3ImCHam38/kOLRxZTI4EnhP67h8CCHtNwFoDI1Y
X-Google-Smtp-Source: AGHT+IENEdTgv8ntqVO1lAQSXYbpZoDkpljQUWa9D+grA8nMWQft+HCdVeMd2pRFMDlJsaRZRQvFGg==
X-Received: by 2002:a17:902:ce87:b0:1db:ce31:96b1 with SMTP id f7-20020a170902ce8700b001dbce3196b1mr5553914plg.6.1712422096122;
        Sat, 06 Apr 2024 09:48:16 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:15 -0700 (PDT)
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
Subject: [PATCH v3 07/17] lib min_heap: Add min_heap_full()
Date: Sun,  7 Apr 2024 00:47:17 +0800
Message-Id: <20240406164727.577914-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 043de539bf71..d4ec7e749280 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -63,6 +63,16 @@ void *__min_heap_peek(struct min_heap_char *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(min_heap_char *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full((min_heap_char *)_heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1

