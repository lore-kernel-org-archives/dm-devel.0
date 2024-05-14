Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7B322F14
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676479; cv=none; b=OxKbnPFrycphysO/oWP1+FShOJCakZWK0nBmEdNLWA5zaB/swbpwyVghdAnsuUdun1I6CubVt4dX05kcxOnAdGtMeVTzlx2ZgsDJoh4UpNMA3LbW/T67r7p7AC979no3TRDIrsRMbQaThAfuMjMHNT5DWtcY9jQHZgxS0uPKPqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676479; c=relaxed/simple;
	bh=b5Qix40IYcfncBwAyPvMRSLFUIF05YVbAb9l7ZjOFyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tFMZj2+iLzFvvsioj9nMiDFmfMiZq7fV1+FAZRj4ql9TG75NgBIMaCDI7Nst6K9yy9rnaKwG8acm+CZzqLo5WZPoEUbw77s6m3nD0lUSJxzcrt/MjInuaR/bSO37Oyic24QUoYnGyD2qeEEUx7/Rm23H3vMvvSuiDPZSdqmFcmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lb7Qew1i; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lb7Qew1i"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-64f12fc9661so65492a12.3
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676478; x=1716281278; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=lb7Qew1iYaOKV04xkWIwlNwvq1kmdA9k2DNFl6nsyqtqyKb3X/4JGH/IWT43a7QRnD
         sqNgKW5Mt49o5IgiXcgcseXERaSWsw9a7ybJRdfVH9cZfVl0GxdAKH89p3oZFXo58Ivs
         m05sWyzplyhQ1byvB6NCrCbKkjdKE7wc/R91a86m4ybSVo7Cnpez2nsr5XtRW2CIrU1D
         ykDB4+OxKa1uBpnEGNxQ537TWFHF6sgkTF0FVKkmrChIO1T17i0J1bFVbm+jtXFv6E/x
         nJT86XpW0DFzlIsAw7UC1yfpZ6XDalDYyX48Gf7zp6pJEIu/A1HZlnCOAPdJE+ufPF1o
         G6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676478; x=1716281278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=e/qbbNbBZipi6shvwtUXsndwQJO1/GptNGatV1zHRXi/CS13i+ZdwfJIZvUMd8YX/y
         cHJnA/mn7p51TgaIwwsiW1ajXpxjr9bjejXbQTThHh8vgXP32IsGwx3R2c/4Zve6aPwc
         tfMyiYcNTH4i1o9o2dbgnNBNuLS2Ju4hs1m5TCnl0xN1WxXr7nj3BJIq0UDMHY18I1V0
         NrJDlAq/Vj81Uuk7FFjODi7cCxn1nvKaYWb6jYRBrrYGtLc+PxxTHlhUpr3gYqXhJ//i
         kMy9dWJPJ5qAs3UbvtLMfU2LVRHcMP8lDESKYxvaRUAUXAg+U7aDZSWxVn+39ZusDGtN
         xAeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPRwncth/xcAK5x+JF8/f+0gMuN4StqPsYTVjOcyBmbM4x1Z+TxmcCVxNS0xSdMtg3Lm1945jBpflBxSk2SixcWyRpbfstDyo=
X-Gm-Message-State: AOJu0YzSw/3amnqcQSEylnzCptrnwOTqBAIFVQtkEr6/V+KV9RYhxYnZ
	tXCzcdlNbCsWloheeM3T1hxDmVTu591j0g3/Z5/bc7xvvcE5swB/
X-Google-Smtp-Source: AGHT+IFna34DmfsGRr4HQsSkrsjPDrFZM+b+BeRj2Nqh3t73q4AJ1ts++l6Quzf18v9kLyQZ1vDgLg==
X-Received: by 2002:a05:6a21:8191:b0:1af:d51a:1b9d with SMTP id adf61e73a8af0-1afde09ec47mr12142159637.1.1715676478018;
        Tue, 14 May 2024 01:47:58 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:57 -0700 (PDT)
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
Subject: [RESEND PATCH v5 05/16] lib min_heap: Add min_heap_init()
Date: Tue, 14 May 2024 16:47:13 +0800
Message-Id: <20240514084724.557100-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 87737cadb9a5..f6b07fb8b2d3 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -38,6 +38,21 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	heap->nr = 0;
+	heap->size = size;
+	if (data)
+		heap->data = data;
+	else
+		heap->data = heap->preallocated;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1

