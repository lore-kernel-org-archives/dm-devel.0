Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D582C14EC71
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054759; cv=none; b=ENeT9LBYBOBXwnwt5zaBGUv/XJzPXSfXalpMFadv8LXACy4ixQd49G1g6+qvMrWogKq4Xx+lUGlD2WzSywlqelKV10MxDvMn4IeoJ3nlkVkmlY9iP1lMITD/ny/KDOMABR8OULNsMwuLxL4XmV+OPKG0eJqgwEKVFoVdzJVV30g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054759; c=relaxed/simple;
	bh=4BdmZ42eGYqkHh7DqsaJJxnA5TQhEtJiFDSi25byrow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LlxN+FkM70P5Z7t2pusgKO2T+BcXAi1f7zYJ7PCTOlDLP0dKHRGpY/7+1I3BiptyuF55/2GrTAifFXoMzMYSwOw6qsGga+ppc9pfZRtkh6Edi2HFJkiwxDi6NU8UsLB78kGFgj7jafgvKyttMZKO1qccqlzi4gXkTEebCX2+Xp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hs2xetEq; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hs2xetEq"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f055602a7bso56732b3a.3
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054756; x=1714659556; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=hs2xetEq6+XnmaE+kj3VSVoj/wHGDGJXavSyrM0qZVKiPgnNv5uRVyM6LQCyJAIQpR
         T3TrWKQ1622ojAD0NVOf8razRaGsceCrMIHjHDhC9EsZ8BSRzb2L5py5wVLe42MTHOVw
         ydCJpBkdbuyJI9e1LBU1xU6Q0NZOvmoTPZ3tm7KCsb/7rWz/zcfXCUQouHuziHIuK/Wt
         sbf7ArtHyg3wO6NWRFTWtAaEN20hrT6tIoR5/LY6kE4QvT76sB8/eFq4kAGseN0pa2pM
         RXC3eB6kTZ46LR4MtZ7ZPVMS+abY9mVjF/B6I8PGPO+htX60FbwikZnE0kSG2p0XhBiy
         1P3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054756; x=1714659556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=FgDGRaE13P10f69ftw3kGPWuWn7I2esKzcduJk4HBhM1IwnnyGBJlhd+Q33XQV5QXV
         S9XoGDdHvu3Ni2zPsKugrRCFGXwOP0prpGP2fnxx+UB0kDIIrso2FCpSQ9TWzMhDKjZe
         DR3DcEOun3+6lOnr3uNnWpQ6isIlQ/3EB5DJLJySP56GRIMYVwCZcNZCPuW+vgxyJbNt
         adkOBXxT8qK6E6jpgYKpvPaVTfSfHmYpgzF0TR74HM3ETO6AD/v/d/izxHHvILocEmVh
         1NYn3aW3/qUGP8aTDy0K5WZ341E02l1T2Jb6A6zfH0ZeUJjverv6Mzdkj+lDIHa8YsPm
         NJjg==
X-Forwarded-Encrypted: i=1; AJvYcCVsuSY8cSXcNKABvodl1XtgEyF98HyGdaGh6urrjyBhoZWAtubIM+lJ33s5NE8JIEyF7XNufxDqqMqdRKfbDYbAn6hvuBbkf7E=
X-Gm-Message-State: AOJu0Yz1xoI92Z2HS0wOjzWx8j3Rt7xvNW7YvwPBns/AXRQbJYb/mrNx
	b7aiB4vIQK3adKyVdijaAJmmVGjr7tJ5dc4qCKoO2pycNY7LkAX1
X-Google-Smtp-Source: AGHT+IHCs2mP2PBWPDpj/ZpcI0qR5WUF5wl8AmiCcNh9Yd7tWrXz9C1cdR5glM/73f83lz2U/XWXhQ==
X-Received: by 2002:a05:6a20:a3a0:b0:1ad:cdc1:a418 with SMTP id w32-20020a056a20a3a000b001adcdc1a418mr876921pzk.5.1714054756137;
        Thu, 25 Apr 2024 07:19:16 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:15 -0700 (PDT)
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
Subject: [PATCH v4 09/16] lib min_heap: Add min_heap_sift_up()
Date: Thu, 25 Apr 2024 22:18:19 +0800
Message-Id: <20240425141826.840077-10-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
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
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 9391f7cc9da9..201f59cb3558 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -111,6 +111,26 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 #define min_heapify(_heap, _pos, _func, _args)	\
 	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
+/* Sift up ith element from the heap, O(log2(nr)). */
+static __always_inline
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
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
+	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-- 
2.34.1

