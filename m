Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521D4131752
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564663; cv=none; b=i3ay/sWps2hpytrGg7vbrO2tHi4yiIsGed9OUdq2E+0BX2GeOV2vehD4Rdj3agxovbV/KTLIryK5YdxLs1Bndwyq+vLE812bzTFrF15xihfAunD75AN70EBoKOFiMUIdtHhUUG8Zynb4h/awtE8T7JItRT3Cur44nudIQ05VTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564663; c=relaxed/simple;
	bh=FajLBoy+P54V5d595ptYE3zStWRI7+JF3jA/AgpkBC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jjcMYoekgvWsJx8XlaLp5Ichq2b90jKImfq6BDzWaDXkvee5afG1n/EoHmG1FlvvFkWOpRnG+VFecrbLwY6LQ7752w5Ra8xWy4FcqSTiqdErHQ23eIPGs2qSisUXS8Mn73koXlujJO+TNeux12QAW9uuBn/9CQGjKGjwUAWKSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQfhmZ43; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQfhmZ43"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-64ecc2f111dso453237a12.2
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564660; x=1717169460; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHh8oRo5IgsV+IU2cDnhd1mUOloCdZwamTIL5z7K9Kg=;
        b=AQfhmZ432p0MEv27C7P6RsMQY/Iyjw/utAA1A6k4cXadv+ns0guD9TwIwrVyY0UFFl
         o9CtA4IRfPb7RpzzIXIV1X/Av93KwfQlO47fFoJX6lRDuy7BXbjWHzEzOjWYmmgU3gLL
         F44IAVRQ/QUGMEagoM0EcfyUmgaGgnBcPi8ptmCDRTRvy6O3K5Yh8RiMxCfssWQ57kwa
         3+07/W+wEA4q3YySm6T87ym8ACAogDfKjh559m/OklwOC9oeHJddgF3ZSSEUP07OvluW
         djLf/ByEg1oN3YbScZ57keVjoLkl1AhzhQPgE4/tCIaxvFObcNGy4vX3PgE8u7poYzxo
         sZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564660; x=1717169460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHh8oRo5IgsV+IU2cDnhd1mUOloCdZwamTIL5z7K9Kg=;
        b=v5iGqgT1xfvXzPo/3RbXEhijiyXFC6QrktRrKZOfWFKTr/5Yxq/hDdySqyySDhX7MP
         6BX0rHUSI/pg/+uI8dqqs+Wbzu+hY81LT0D+hU7bhEop4XBl64iJ3KMC2neK0HjkeeT4
         8+PtEszg9AQJHo4Vs/0eqE6ba7f6S0e/kEWmprw7felSQXQoIRbeJQ2yqFLT6jEbXAly
         gh0itNohPrTnRsZADSUYJp3B+vIR13ROrb9XaFaF8Y/AjM6k70MVWzo/3vxiuj/SFRJG
         DXJ0CwAznd+v+imVbqx8fciGDIqZwZEk5hKLuWyjFvhgIpD0NGzhmY27eEDeFSyjlEtS
         +Nmg==
X-Forwarded-Encrypted: i=1; AJvYcCUeLSnBOSigXGY8TC93SffYg8V1Qk/wf80magpBr15eKbz+S6UX4v0f1EUEjlu/p3QGyk4CPE+ccWO7ShNhNP4CCHBdvKV5kls=
X-Gm-Message-State: AOJu0YwmWigEr68MVsrwc1xToE0BSlS6oxfJQb/8d8nEAHt57MS2Cy4Y
	fuRTx0AK+cNn89CKL/s3TQt4JNl5HPkRkYPNb8MU14ssF6x5Ubi+
X-Google-Smtp-Source: AGHT+IFciQWF2Y7yTOkGCbHq/4hq/tcnGDrn20ayUbkM9iebbc5ly95hjv5xZNwCquKeXBM/4haULQ==
X-Received: by 2002:a17:90b:230e:b0:2bd:76ee:48c2 with SMTP id 98e67ed59e1d1-2bf5e0a7a56mr2495670a91.0.1716564660327;
        Fri, 24 May 2024 08:31:00 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:59 -0700 (PDT)
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
Subject: [PATCH v6 11/16] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Fri, 24 May 2024 23:29:53 +0800
Message-Id: <20240524152958.919343-12-visitorckw@gmail.com>
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

Modify the min_heap_push() and min_heap_pop() to return a boolean
value. They now return false when the operation fails and true when it
succeeds.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 98e838195e7e..3410a5f907ad 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(min_heap_char *heap, size_t elem_size,
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
-		return;
+		return false;
 
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
 	__min_heapify(heap, 0, elem_size, func, args);
+
+	return true;
 }
 
 #define min_heap_pop(_heap, _func, _args)	\
@@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1

