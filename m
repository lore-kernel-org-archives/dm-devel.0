Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2791B14E2D4
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054745; cv=none; b=bOOOMHx3r1gHLMbSyDXXedfGKX4GgwiSFS7rQZ04EQAIt7fWCIJytRszdLDuGIkVZ0iDIn6DL6ByL6iFhXAJecQDpGKE0HQvX4wQmYA0y6C5+a0GP6NonY70PCUDmwFjne3fkPoo+Z58eEKVx/WtVfq9JbJYIOK0nhDuMGaUMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054745; c=relaxed/simple;
	bh=9tjNBJoFW/M4N3UyhM3SbO6qdcqZWdxAoa5Ri1G9BtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kiqYx31XJjBXqtyZ1bZ3cYgpsgNzDPEguyl1OtPxa/Xhs4TQ+pkwh4EvfFaX85EHR1c5VG8eOm3sfxLlAP0x2K1ls9S7nd6fTYA8i25FWMVG7RJ2JucjjpzTFBVit6JNVSc0F2MeX5c1FMnlGSA63aPRWfwOsRVXHju18t5qKng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mAfyityu; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAfyityu"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e84787b0a8so133915ad.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054742; x=1714659542; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=mAfyityu9jpz2NqGl9ufKUGUrbMx8UZvwzGaTTVc63v1FWymAdH8ZO56fLrK7oJDaS
         eXAhUrWbQLijPJG5OxWPHiv5pIhfLf02QDA43zGV/O+/Q393KaWKDdMvtDh29+pT2Xv9
         z3QSuWgVVEV58+k+E6pRzjb9+WfTSrZFGq1h5kU0wFt9cflRTHlfGsYiV8x9HxZrGWZL
         0wiVzNABZP2gkUzusJKKVGX6mhVsW4g/3PpMAtOeI05x6DfoXDNdea0oXKnNaCbdPN4o
         kxYMXhFE7wGNufpdaQ7bE0+XHYLen7H4kLXbPlk9rPrvTZ3si3vc/r83r+LpCzzr+E21
         8Nig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054742; x=1714659542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=l9MKSHm00nIAVCXon6jpYSwctnCuoBOWe8yrIOTn8nX4XDQcGE7xGJ/apSx95++wMD
         gZp1o8/oiY7JQAmjYa4BCHT8oByN4bukggXGuD0pTZLVj4v2pYvbM5Qrzb3zx6P+jxed
         39rHJbqpIddslSjpD/p56X1hW3hAES9C2llgbzLwUmF+yea1t6OMeFlFewnSBjdEXSpL
         Z9fttDQlTdPxZIx7BVg1uLiuLPYIQEWqtrgVRQpck8iI2emYL8QuNmZS0zZ7yF6iuPtd
         COXwns6F+afCC16an9eJ3lu4YvqoL1IST4niVM7CiblYQnKxDODtTvDuRHq7fojfsWZJ
         ME0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQ2UQ3CKMiEGDK8Z7zeWyd/yjGJoZHW097m1pC8UKJH2miEN2wBZGcL6VQrXOBL6pKhyA0v+uLrgm+RTcc+AN1fFeVKFmPZkM=
X-Gm-Message-State: AOJu0Ywz6pcmM1mRY4RqRbHgACFgbgmygyGJae4Pvi69xpS/4c3aZIkG
	GtmDlpgthGlyd7NKNWgfn98vNO/c/s3bk8PZEYkhlAqDXTjKm4jB
X-Google-Smtp-Source: AGHT+IFDcj8+z0jNjqj12s9jll0rXA6fAY20FeZPShgwWxxNRxyTRdtb76w4a8W5EzTpPoYKO1G3kw==
X-Received: by 2002:a05:6a20:86a1:b0:1ae:3504:c5e with SMTP id k33-20020a056a2086a100b001ae35040c5emr472761pze.4.1714054742438;
        Thu, 25 Apr 2024 07:19:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:01 -0700 (PDT)
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
Subject: [PATCH v4 06/16] lib min_heap: Add min_heap_peek()
Date: Thu, 25 Apr 2024 22:18:16 +0800
Message-Id: <20240425141826.840077-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index f6b07fb8b2d3..043de539bf71 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -53,6 +53,16 @@ void __min_heap_init(min_heap_char *heap, void *data, int size)
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init((min_heap_char *)_heap, _data, _size)
 
+/* Get the minimum element from the heap. */
+static __always_inline
+void *__min_heap_peek(struct min_heap_char *heap)
+{
+	return heap->nr ? heap->data : NULL;
+}
+
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1

