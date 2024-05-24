Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0A9131192
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564652; cv=none; b=gxQj8J6F1WnMv8ANyhKRuoqfNOUKa9D+h0cUDoE3YBUbbYK7ks4iAFb1d0Tvg6GIrlA7teTjdbs0WeayqU70F3FaJ+kjwlCH6yO+aSi1oj54ybUwFaHzskczVnyC7x7t7K0cr+OVDLzOOqft9Y77TkL0ncHcZUPUwUGbYRMai58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564652; c=relaxed/simple;
	bh=tby2ZpUX+BlnLTwxvgk6fPnVU4TaOjJxMlCJa4gIREI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eHjC8JWhFHakWcIB9uBNzsLAbMo0zDYCGVV7pZM5VxOhOzFOQw46TvsgnoQ44yGRZq3d+6L5JacbR4JFNs8B+6WvPUBJyCwNPc/aqeQhM5nMRrQwNHdmKlmRdQ93uWtGGWsyQARXO1CDHdm5AM+mmravOaJwKpjOqeGvz21ciXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/MiqY5a; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/MiqY5a"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103334a91.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564651; x=1717169451; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uvl2xRBhY8ekhTJXesACHkl46vqc2VrA3GO40P8QBlE=;
        b=A/MiqY5a8fJKeh8iTjPf92FtcvQxLX6Ank93mCIwOvH7wwFJHorhTMXWieyU7lPX8g
         SoZ2cUgPHIOglSZ41mhs8dfn065SYJMXiqVscFz8ubjqd8+oWHsS3S6SqMvxNLBvLMIK
         HbyRSRJjEPYvkOT+9shq7gIIUrO5Uva4QcxNS+1r5c1mKS3w+zaJMlwh5OIyaGFtopOU
         YG+/HhWnCE8lMqUrGlVOcMSDSnQAtaHFsJIAs9sSzxkfhp0dp2Af7xn7x0dQofaVV89G
         q1bJz1ZGtuQLSS620IeIueN200FywszFMlCWKuLhcHQbxrivb36fZ/Vf83GMf0whUQ67
         zpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564651; x=1717169451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uvl2xRBhY8ekhTJXesACHkl46vqc2VrA3GO40P8QBlE=;
        b=clwV1s/dNh503rm/sM8MA9Gah3D7fiqhbBNUpVG/LTi97Q1/g/gonlWQxSD2KUmBmN
         xUIhMCnAAh3v1kZRS2YLGcRFZAeGtbbrPznUuRV2eywh06ZrGanrOJHgzzXt6L/Gl7Rr
         sZ8t7uWOVwxXJAsagfelFvja17zzs4Gw7WHqiYQgdzy2VFiZ/PQkZ10VLWXZWwLinrxN
         mOfWdvvmcu0TETtdeja3NNzg2/Em9b0LL3zaPk0bvQtIXQtVW2sEjSKbbgKOIIarmKH4
         8jHhbxlIPiWeYIykYnhC6+Vv7kvLfq9ubeLg17RyEKB01S09yMtrvQx5KTMusAd5XGRd
         /wvA==
X-Forwarded-Encrypted: i=1; AJvYcCWdIee1SPyNCuT+nUk1v2NCoBvJ8XFSU/mOQ1j8rsbvByS/LPYP0EiBghSaxItac3E5RIR8wlrXs3irAg38OaTij1Y+D5AFmqs=
X-Gm-Message-State: AOJu0Yw3VQxVfU0wlVRZRhGStnBPNlu8dJlTmwp/0ANg8En6NEOYPvAY
	ccwJC3o+XBkkBPYBMTJjti/YGp/8v8g0CY6tvShqK+9/yNP2u7tc
X-Google-Smtp-Source: AGHT+IFsxgebjZlr1dxx1chJSleAIrK43REkyeW81P4lfYkP9NwmgKQYjYTGz/eljOWV8fOLiCwwGQ==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2505679a91.2.1716564650793;
        Fri, 24 May 2024 08:30:50 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:50 -0700 (PDT)
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
Subject: [PATCH v6 09/16] lib min_heap: Add min_heap_sift_up()
Date: Fri, 24 May 2024 23:29:51 +0800
Message-Id: <20240524152958.919343-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 4acd0f4b3faf..ddd0186afb77 100644
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

