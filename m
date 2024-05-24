Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8097013048C
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564633; cv=none; b=qBKadgoo8TyYVIYwTQopsZva/6sjoY6c7pTuYKaNAOT+ZzJX+lCcfsl2lpRURgTSAOlL1fYBinNGRRAlFUTWD4idJ3q68y/8kXFQNjDHIqrRtmtz33SXhDwGnRVlWLMyb+PwxTcL6qGieCEBvBoMBmUK2Ks3JKp+RscdOk9JWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564633; c=relaxed/simple;
	bh=3Cv/NEYxtL7rses18dsQW99Ih1hbxSO8VST7jRlzjCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsGRT7I3UBf3+QUz0wWLItOwsqWsJ4bAib2Z8FoakGRFTzvM60qyJiKIidfvYOMd4pNV+GbdlwtV/oMGRSLSAoDZeIrSWG8JHjtZ5zSk61MmoDAtYIBgwtvSUPkEHJIYqK+3ZAS40ZvgsKRR1KYIKgaoDH7G8Ei4IOkZQJXBbZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FuTuJO2D; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FuTuJO2D"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2bdf439c664so314755a91.3
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564632; x=1717169432; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0fYqR9rcSvYbrkD+sBe/h5jrjzbrTBXD1r+tuRTAZk=;
        b=FuTuJO2DB/zF301QpjfcAEhFydBM0MDlPK7ikszCM1J+0b/C16IDDw7NVraQirG/mL
         OJo/quwoPbYq1NtHFfy0EOORgbL0EWFe8zRJgH9gMkLoSmqggd8ZKhpaWQJYPKwdHkme
         ESvjb4GbR7Keyl4GVyAITJgFK1Dh0agLiu9/82DAHPpmvQZ++oLzPrtDnvRuvJVw4L+A
         Ts+yxxQhjv6mvrHOdJGLoAKD0bPOllYwF05jToVVYJOy6faDrLZ70IRml8+iHSPCF4jF
         jtvmHUBoFl9ypMKFCm1kUGErZVNs0TQqoiHNnFJlZckD03c5D6XG+sS+vZlPg6hw8mpW
         vWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564632; x=1717169432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0fYqR9rcSvYbrkD+sBe/h5jrjzbrTBXD1r+tuRTAZk=;
        b=J4VqFs3dl2Y8FR9dlqDaD6ZKb8utbqtZQS1ZUc5OW4Fovr+UO/i5MYfEnVCPPgN3Uy
         Kgrgks3VDGwD92N++Iky+wPFA0/MPqi9aLPB+VshGjuiXxXWCNUTtgsVFMNfyCw1/ENr
         VsTpQVkOFsz04kbio0142TFIgL9l/uFKUdLb0FT3JkdZxl1NTm4fUIK4ZdOrg4rajMVD
         wka4ZwH3tsqa6kbXt9Q9vr0mSRxgmz0HkPtNY6wIjqJDHM/6jsacc44cra1cR9bYukTZ
         Z7olgLN0zGA6seKmSYtuR9YupPC2DJzs95u5OLI0tlUN1tRGoLS955GEsrv14PcU3avU
         1dKA==
X-Forwarded-Encrypted: i=1; AJvYcCWb+z1+v2fQoB0IvxgHNupS6u88Hewg43qEeE5Tl0g/ltX49YeWXK2iu6vbEq+oVjDFXgnszkTWkY9wF8VicXDc5t6O3qjvX3Y=
X-Gm-Message-State: AOJu0Yzxo6VHLb7N+QcP8tc4NB5eLpEKZdxL1f0Z1hdoVJOfsSk3xhWh
	FsNo3/fp3OuxOLbGhmEH/Tou8yMT1frRnjvU2YvYov24Ku6XlJTt
X-Google-Smtp-Source: AGHT+IF8luE1cdHm1AfcM0WoDjZHudhzFqofZ1FcFKJ69yRGqwL7AZUhIIsbkDXV3LM7TdHAleFXCQ==
X-Received: by 2002:a17:90b:230e:b0:2bd:76ee:48c2 with SMTP id 98e67ed59e1d1-2bf5e0a7a56mr2494152a91.0.1716564631729;
        Fri, 24 May 2024 08:30:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:31 -0700 (PDT)
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
Subject: [PATCH v6 05/16] lib min_heap: Add min_heap_init()
Date: Fri, 24 May 2024 23:29:47 +0800
Message-Id: <20240524152958.919343-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 92830f41642a..b384a4ea2afa 100644
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

