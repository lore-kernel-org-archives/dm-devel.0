Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23E73FE31
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422107; cv=none; b=N2a7xxvVLUeyF2cncLyLzv0ziLtuDzThPWJrvjEgI8gN9fLmejFH2wbgvO85SbqaoxDz3c4A1vfLycMmXiuiGlvljCjAO9N1xlCmGAAPVx0ImfDNYvhO3I9hmgvftG3FmBg5JF0shzKuNRzog5xxztQe3ERCDfMciup915iRE1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422107; c=relaxed/simple;
	bh=jqo3ElORw266U/MGKhXJRdr9MiE1XqbwT/kp886Mo2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KEpZdFiMymOI9u8SFTvfHKOFhaz4m4D+FZ9PRQJ2JLnXwXI5aP/AhN9PdDEx70Z6EKBEKgFfqrlITZjAI4RHK5ge8jr1u2iMWESEUFISa1vPLRM5VRR9T97KmfN/n3mFFBRrZweVRV0t1H6RyCV1LJIHKF/s2jVBJCPM8F5/QO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ur0k6IfC; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ur0k6IfC"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2a2fbbd6cd6so611144a91.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422105; x=1713026905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kzwb7BmcuGuHI8BmCOZ60hhRkppr+jH4uHUv532UMj4=;
        b=Ur0k6IfCys8ZfV/CHoaVdx7GA00KBAFcj0klK17X1kQ/ptZ5nUT0pXyPJ1rvXAMBuD
         mWP6Zbc+d+Nl7fcTRbBNNPJrhXyx8dYq9gsDbTazu9X4UrmhdVpcowgcXrmZO/fewlCJ
         6A0Bl0LdpvX3/MFwpJZeZD6mriJl0smbKeDPi+YYoF8HI3oGkWOtuV/h6yjaaLwooiwq
         MXoQuKC1xQPFlFHcij60CG2gRHf5bNRCFv3ZajNRWeLLaoY0EDR3PImJYpXcDS4D0VDt
         1NHSDzZWEBTd/M0+dtPN5bS9lWVRijoQE8FoHioYBv4uZ0aaTMw4DmjSPzhcwdLrqRaK
         Rj2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422105; x=1713026905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kzwb7BmcuGuHI8BmCOZ60hhRkppr+jH4uHUv532UMj4=;
        b=AWQ2g9XvER7VVFSquBn5Ji1VgNKMxFXtcEA4DjP7xDXX7WrbH0iJ7ZA38g103NWN7n
         zP6oc8lQ3ZWHykE2Oh4qRTDBp9TK8yMCAxRWyH1Iu5Y4VaJH+0qb5oATkyXeTQMg0GS9
         qgKiM8bkfKgGTae0gEYccDWVIsIIXmE8LLnQMg/qibJjU4YoCZC1ubCcX1fDBYlaRU31
         U/OZjG23J1KW6OTNyZInKDp0Gty9nKSA23f05u4dhLDFhUheOvP5N9ZWD212P491r12a
         7o4k+4rFoQLOndZWDCFaAITWDXg+KMBuwyCTZbDqCVMD9KKSzWJyt+Ou85AUpa5TxBNg
         EqCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgm2FjAd+PkoFZPjEpFeXrSam0T/SdEMJpuGuwJ8NSSzEXHIHS6CXRfr/flHgN9asnzde+hQXoimTi4nLjM6OHWFD+Zd1o9eA=
X-Gm-Message-State: AOJu0YwGOVr2GoJ2FdFm+l8t3nG6QrXjTpfEiLO3hylmFrHooO0osy/D
	SJo+De1L0wGL0oQL8MDOZ5OwSpAE+WTVTEueEexbjcFprE1i+uH0
X-Google-Smtp-Source: AGHT+IECRUIgpwBjY9GlZnxntOAI/Gdn79r75bpaZK5qjV3HmrL7hNrxJ0ZSi2AQZhcLSinS0naEIQ==
X-Received: by 2002:a17:903:22c5:b0:1e3:e08e:d812 with SMTP id y5-20020a17090322c500b001e3e08ed812mr1765450plg.5.1712422105286;
        Sat, 06 Apr 2024 09:48:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:24 -0700 (PDT)
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
Subject: [PATCH v3 09/17] lib min_heap: Add min_heap_sift_up()
Date: Sun,  7 Apr 2024 00:47:19 +0800
Message-Id: <20240406164727.577914-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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

