Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8658AC1
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946519; cv=none; b=P3ROsliM2iRTmfIHZSUVRquvKCUA/1eoF2WnhY3p+2OuyqePeYHoY+oPHv+El4k9SVvB9WhlMZwXaiHu2yGvI0iwo3/JTpDxgYftxqhb1rw0Jwf818Rktfk93MBZDym2YVVha0USHJ2OGFnEaohTpfKfNz19cvSdUllnrrOUo/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946519; c=relaxed/simple;
	bh=syfYOYnUwJ/5pwXO5mVU6Pp5rxMGLYlg5kt0rZBWh54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sE2R4QyS19swMh7Ian1/L6xTJuxM+5C2ETxQM7HXeMIU4OS4wTq2Vb6jLVpG2m96TBPDazOZjtM1Slqz9M6CnrlCOHqfcQQKzGDBdHcHW/wJg/6a0dKYwkzlKsFyMVkz9Xl4piVHr7o4Gv7aNsJNRybCemwbH2YHqOn0KQDIdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lf5+NsQN; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lf5+NsQN"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1def81ee762so9761015ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946517; x=1711551317; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cESTsZP2b4VWyk/Zv78LUG0DCiwWqDlR4UPH+ifArVI=;
        b=lf5+NsQNlYFy1mQSVYJ2TzZRd/vX1w9VARchsqaIOlFXITZCxJO/eHWUq+/erntc7g
         jzh+aSfecudMHrCp4hvSz7N/y+RQjg5IVV3+PSM6A8jGPK5Ua+gLJXDYuHZGj2j9fspc
         aMuTOIArCVWVubt/ebdP1XmHcO+ZMzLZa0ZvrcnUTQlKppOQ2+NIdH2xTIdM5pZtQHsW
         dMH2KKDfcH6LhDYL0rC8q3z0cmirCkCOAed7m5peh5Cqg/k1lJcKPQvZ0h9k5j5ZqeKx
         ahDqq42OzEwjRV44+K9AD5aAhft5R8PnL6i/BcN7FPZuCSyAwwMnCjECWekv3ncpwxvb
         WVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946517; x=1711551317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cESTsZP2b4VWyk/Zv78LUG0DCiwWqDlR4UPH+ifArVI=;
        b=a9kQn8xMzIvBcawA3+OJ5o6v0bahfSm6FK+Sbbot6TDml+VZIj92RsYi3RhR+P/IEe
         AAHL637wvR7QouvTEglC2KNsyVYwqkHQ2YKX2kq2LhMZ0znUAWQv3Gc5W2dN+qHRHXnj
         wbM4N7VbCR0s0rK1IlmlL98JeUSKpEx/gswTFlo/GOlgkUpSRn/yM6FL6SIOUbxQ2WCF
         J1dETsBPumoGPlhlBC7rKP5fg16Qs2cPxgEDeQgd++aT0uZLSIyRvqgZGGvzNv3wycd+
         ACg/6CPSLI60B5dSG4EOt+HezgYUZGjeLK5dddbobsCpfv3xxNQQqfK2PBaipAgb+IKS
         3ZJA==
X-Forwarded-Encrypted: i=1; AJvYcCUvtKE6OITiBXKTfYwVL1Ucs3OfGdBgFt+gpKQGw7MnuI4K3w9g6Jk5Lv5GvL7IlM0or62nXUw02gySVnC5HAr2tySf5XOZsFs=
X-Gm-Message-State: AOJu0Yw1Tv1E0x2Q+5+uRsNiudkNVrJ2/r2IAS8DO4DL25XNTU3S9Ywb
	t5LH94IULIOu6rwVeU36fjjPPRAUw23YNeCEMIxC5A0m3yF3GMW4pfU8V+CWYSEsvQ==
X-Google-Smtp-Source: AGHT+IFyBgv5oFc1N7tzqDalBpTJCZL08QL7Xi0JuKEsJZmPb5q63CmqPKSNUk+sFsubtLKiucyg1g==
X-Received: by 2002:a17:903:2292:b0:1dd:5a49:7a98 with SMTP id b18-20020a170903229200b001dd5a497a98mr6117689plh.3.1710946517076;
        Wed, 20 Mar 2024 07:55:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:16 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 11/15] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Wed, 20 Mar 2024 22:54:13 +0800
Message-Id: <20240320145417.336208-12-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
References: <20240320145417.336208-1-visitorckw@gmail.com>
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
index 879a9d12e030..586965977104 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -130,18 +130,20 @@ void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
+bool __min_heap_pop(struct __min_heap *heap, size_t elem_size,
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
@@ -167,7 +169,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
+bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -175,7 +177,7 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -190,6 +192,8 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1

