Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB750A93
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422112; cv=none; b=Igq726IYNbUtFe/lIc2scmU7Z3z5kTzvWNhb1h/q6KXrJkOSqyiNVpq5wKlN3Bpk3EXpoabuQj6aT/q0TP+e5FuIcSM9R0QkabgnTCJzTo+5i4sldKabjoipfpg0/xMfn4owK/kg0UMdajmHgVzVHr69FS8hgabPwiaDgl4roW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422112; c=relaxed/simple;
	bh=XnBpK2mdTSiNk8pOWsUbLfl/33hQsrGUFpWaVX3xAZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lTcsTSNh34k93wxAiv0isiSX1Z1Hskt0jdwRNw76NoLHxCKl4DCh5h84TNc7p3A4QdrCSHwbnYhdsHzGEM33f18TbN6DEBBUx8/qGRdBAnzDUcztnW+NyoGL+y6Dof8nLI0+HzYLZ7yw8N+h9xgBqZoXS0yscBLZhrXr4nnydWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kIlgjqzQ; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIlgjqzQ"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2a2fbbd6cd6so611155a91.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422110; x=1713026910; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVjY2hsEP5GavYAiFg2PbPm4ktH1C0XXWqyfqIoZqfc=;
        b=kIlgjqzQth4z1kyI49j2hfeKuHDQDj5U2JRnqI9GAfxh/Nd2FWEOsb0lXliz/ba6+Y
         69EB8DbzsyL4BFO+2yAPeENoy4oYkis/cJLUFQu9Z3BBUEdxeKhOq99GQ8kRobl3oIgb
         ifXfe0KQ/qE7uUE1tKAv7fnspzfIrgm3/eehvTQCyJkA2kMNsk5D5vZXt/7djhsX8NDD
         9jY8aZkx8faABpFjRomo4r0IziYOq7SQVdiEoqIE/9kWHRjnYTdF7Zg/71StpwUuiqo7
         UhN2bdylWGPoZk0iFGSTce3Nu6suteAZDo0cS6X4jb3JwXtc/9csJUda5SLysQvJWwUx
         S9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422110; x=1713026910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVjY2hsEP5GavYAiFg2PbPm4ktH1C0XXWqyfqIoZqfc=;
        b=kxWJTWVr5phTTXoMRfRXaSvZvB4J/4a5TOwXPcl57flTxdgPDp/xfb/RgWtp3xH6rE
         1tZaYsL5Nheh07haOGUC1nWPK907/OqWrpVRNmnMD2dAKx2bXusuAThYLwF/4q1s3X50
         DW/FnXPNjtRVGNcksz9C5FnBai3tfSIMAk8FybSnpRji25X0PUmOK0JroD8xSk7JsJIr
         VcgrGnVhrs0612wwgwe7kEare3OOv77oRc/dvm7qCUcNaQD8LalEInpWBIbIxCIkMKe4
         zIiwBDdyvLp0msc/i39XPNzBBh9cKfLTP2jz6oohXB4ywp8Piw1hvA9zSNzhqRID5i7p
         f5pg==
X-Forwarded-Encrypted: i=1; AJvYcCV218TcrehKtrgazM76zSiI0OmUrTHGwO7ZMSvBW5QXHVvhitvlBB3eLC2HuAygzW0BPYLhAIcIt4QF5I2Mx15Z7AdqK5pWwMg=
X-Gm-Message-State: AOJu0Yx9y9Y6oKVN4sHBoq20f/RebffL7cVubtpwUfFy2lUgAaFrGsqE
	GP4NhQv86aNHXp2Y5aKPDZc7KSJrSsBbz1zyZVNd2KmR5LGxlerX
X-Google-Smtp-Source: AGHT+IEcyJ578ps9gq2LX604ohNhbPbzLtuv6Y3D4F0mKoW9u6iZ8nNcsVBv7jisetv3NOIFQl16OA==
X-Received: by 2002:a17:902:f68e:b0:1dd:a3d6:3aff with SMTP id l14-20020a170902f68e00b001dda3d63affmr5471402plg.3.1712422109909;
        Sat, 06 Apr 2024 09:48:29 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:29 -0700 (PDT)
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
Subject: [PATCH v3 10/17] lib min_heap: Add min_heap_del()
Date: Sun,  7 Apr 2024 00:47:20 +0800
Message-Id: <20240406164727.577914-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v3:
- Fix a bug where we should copy the last element to
  'data + idx * element_size' instead of 'data'.

 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 201f59cb3558..2aee024ca883 100644
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
+	memcpy(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size);
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

