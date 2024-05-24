Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A0A130ACD
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564643; cv=none; b=btESUjBXtO1c/s12uQf4LSY6u1s7SlRc8O+qJNWLpYZBS4S41lCPaIHQcam2sR+WZdwE7kS7c0WrMuzNtWDOgT7StlS6xxkkTQCtCITDCyTIIea2qaG1H7NTmwbZ/WP0oUr/B6Jts3sokDDN2ZRccS9OWBLkxC/swwNpbuX2V3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564643; c=relaxed/simple;
	bh=KituFP5FWvyk4tf0TCLoKJP1Ug399E1uez9KXSPSXO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fsPzdOs8fGcqDSKHm6KZ76HeeBU2cQh9f1tRDPLVZmwfDVIu9yU70w51EanBI7UV3ssmNNe42xppATNFa9f1ORSj/oVOPI0LJ3KzFJuQsPIHgU60wZFYJi/f2n7krMbIhYJbLFoiGJAHcAjEck6yTwPSBFI56d5T2rHJQs+8Hxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDwrx+C7; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDwrx+C7"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2bded7f6296so212162a91.1
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564641; x=1717169441; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6wGqg1Bkc6VloO/r5wptzdiAzti723DW6TYEbY9ymY=;
        b=mDwrx+C7oOLhrRHMok1mf5wq+TFJP7JP5NhnNzrjFbPawN0i0tRmcDkDVrBHKTrq3c
         P6R+imlcdWzsb5u8S7jlfc5PMSKXHKDPJ0kgT8z5BfVv9BbvSvu8WZ7czdN4PrP8CQUZ
         8lmTuyZwODSxn5Urs+ztkstzsbHtPu1Q/SHz00ojcncdeU+ZWk2vc5Yka/moBKFl4nY7
         lJEFkd3auZOX4nNOfktsKdrLHE2sUbIwjBUzFKE7JVKNipu2/W0R4WsRSAH/BU5/K1bi
         6wGyBcJHospw8iBp14AQQzmPV/phFRy5aYTfXsmdKH1UKpl8h27hwzpbr/zYLkXOZjpx
         gXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564641; x=1717169441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6wGqg1Bkc6VloO/r5wptzdiAzti723DW6TYEbY9ymY=;
        b=InUR6K+7Hvtk0tYPex+zL8tCvVUm1y/gltK+1b9XiiGZQEMiiTNmV1qWjlj6cbwYS+
         MW842G0f23d3l8kIrTQ+kjZDIN0zJ2ABNZ1IhFQYFnReIukkcEBeYk7YGv5m+xes+mTO
         Y17Zpy+ANPxrS3jcqdSdnKNU7o26bWPx2A59E5ytAtM+gX8ZlsrDGElu9zA4KQP/FXSc
         m6FWRE34h92WJ6Yj8dUJVX4OprSB1bkg+WX7jrG/phqEoIcQg3hg3n1KqrgeNcVsL2lq
         h9+2cPcu/N31dIqzMBniVSXShnQODhHE2h0EHqOUE/NitdZIXPD1KjiTJZwN/m7D2iNz
         izPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHL8nyiZqevrbGOWa9MHrekpS0iewoSIijx3jzZ1HeOFLOMoYxd3bARbC4NILalv58SyjisXKZUvVWO0lCvpxQ2lkcmjuWww8=
X-Gm-Message-State: AOJu0YzimfDuA/rFhtXVn/d68cG8gy7HvbxSF3PSqFNf17LAoLCcrdVI
	iMjb8WRfIPTBzfzTtxezW0Ocm8r9Wasetg4jCvEFVSuJr0nU9of9
X-Google-Smtp-Source: AGHT+IEFZigwBsVU3DQ0U9XwesSc/pScEk6hYtsY4XibOuLDALe7YcoghUfWtHqjA5Lb2EftoZr+ZA==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2505228a91.2.1716564641436;
        Fri, 24 May 2024 08:30:41 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:41 -0700 (PDT)
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
Subject: [PATCH v6 07/16] lib min_heap: Add min_heap_full()
Date: Fri, 24 May 2024 23:29:49 +0800
Message-Id: <20240524152958.919343-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index d9c4ae7ad0cc..f41898c05f5a 100644
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

