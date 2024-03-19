Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DE286AD
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871268; cv=none; b=U1yxLUbpNIXqlCNnC0MkKX+Ovl3qt6t2dkWz4SQ3fDPWQPhCFNPsRuBJeWRbXRdcOGSIUHYdJwRxnnfX3s92DSiBDtjWnbWoeJx1Gd/VyNBhwXwRTsLXQTIOrQM6DV6DvKiH3ylMKNjaknojtCTbWO1IyFWXFxxOsyPTEznsiDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871268; c=relaxed/simple;
	bh=DaiE46aVxWHt/auXpAOLOuGHx89UIZWSzrLRvoly4ig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tkc+HF6oD2OYfrAxd4j26QLOHdlWXpK4xCk+ybt2VJvf+FaODEFrMIeO9EiGUz5e6nqvoyOZqZFLbUVxd2EHwHZP3I5SuReC/EqFaQ0tKgLtTyHAKo2Aa1Ra2WL9jIKm1O/I2xnsdgKNERyeZeivBW1mWf+KYVO7biA16iYwoOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlnAbkvk; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlnAbkvk"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dee6672526so5309265ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871266; x=1711476066; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIhnZ2ZNiWUepm6TjWG9gskFjBN2pbtB8loOlyqrj3U=;
        b=nlnAbkvkbXBHgXgOYZlRYAGUu1u5QZJ/bI117eZfvzUJ6gapOJ6FJj7WW+Ek9ka6s9
         j2FgSv4EFnsAl+WzEnOipvz3PBKm+A4hmG5oUAGKJIrXKTqn5qfefGQsWQadrK6+L6oU
         g8LSOHZs5hj1IDxoJdE09sV1CV7/A6qgMtnnWetntsTLk7MZnEHO3Gzgb3lWhcY3MVQI
         uXZ1QEH9oRh6wxqLbrE1DM5FSFjkyOr1y/k/cMmeB1H8IdY5YPn8FSMkEPYdnHqgpPI2
         3fVhfUd4wBR/S3OsrfPCzQPxQkq9QVptSwhTJ2o/vDKBedn/q8WfgHSw/PKYxu2zBMZN
         OA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871266; x=1711476066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JIhnZ2ZNiWUepm6TjWG9gskFjBN2pbtB8loOlyqrj3U=;
        b=r054HPZQ51HJ+4O2hxsaM6d6+GMZ9tisSEV32Tkol5nuqZFO+bAgXJMWBflSFzwd6H
         eyyVGeU+MVrvUBvmS3nY2HoFQkj2ltXASukv7tI/ak9NTpVaiBK7YxGEEa5wtcjY1GII
         38ofwk9RAUfunfigIaoOhOqDpKYCgZcxMiyBDgUfGmjSwDyM/u2ifEhkvDfsgbUeecbC
         avPytrEzKwboA+Ha37/saoc+pTFqn7ZvafPKoIbhW9jWTvb3v2hGVzrNkAPmkply8b8b
         bVCX/+C49xs1jnaMLuRXC+rNj7Hj2tvfVM2PYyPEqM6Gv+jWq/nbcsikyGkhM9/n20Ph
         7qRg==
X-Forwarded-Encrypted: i=1; AJvYcCUT8Fi1W2+lwk5jLTdyfbtg4mcDJOIwcQetHK3SCFGciLO03vtoynaKrcrjM+3J9eWIxpLKbkWPk/V5QmNtZD+TfQBlHMEHBWg=
X-Gm-Message-State: AOJu0YxqQoitPdVUp2SJQi7lcBDIkgwnb0U7h3urusxqrV4tCQBUdxpF
	tLfPImgrFVOsfz0jpzFftnTjfYEc4HubFBJXm8+w5N74U/0V75cF
X-Google-Smtp-Source: AGHT+IG0Z0ZjYaV7oFCEX12jN1Clo3Wx+9dfnihvM1D8PQqVB+cVf/xolig1GQ3Nnap/p/L4r1uyiw==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr17605167plg.2.1710871266314;
        Tue, 19 Mar 2024 11:01:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:01:05 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 11/13] lib min_heap: Add min_heap_del()
Date: Wed, 20 Mar 2024 02:00:03 +0800
Message-Id: <20240319180005.246930-12-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 154ac2102114..ce085137fce7 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -199,4 +199,28 @@ bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
 
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

