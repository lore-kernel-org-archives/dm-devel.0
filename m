Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BC2E647
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676499; cv=none; b=fmZiDUhfQrtfe7mIcmflP0l6zAFXhqKgjgbZwWpz00yRGdo8YLR1fzXWhtbBqp+VAONIAWHkNo2cccznl2CNSjl+MqatDYWEI/TGE5Pe8qMJVhtZ/PKo445hBZE+klyuY6J4nR1AgFhp0svW/tsMG7CcSUbG724rk174+bKcnlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676499; c=relaxed/simple;
	bh=4BdmZ42eGYqkHh7DqsaJJxnA5TQhEtJiFDSi25byrow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t89TDqXxdSgOf3Hf0N/mTB32xPb8+5WP30AR6pmnYvPtJTKwOEvN6ak7+46lk0nfhtltwmMRKm17vpeNh3fkUFi5tZAtpRdYAAfskLU4Zc1snGelo3Hx9z9Lle/e9+py4QZ5xbLGOlLYFwJyMXoceMEdud92+UH44X7FsoPbfzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chHq+fEw; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chHq+fEw"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2b360096cc4so1334716a91.1
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676497; x=1716281297; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=chHq+fEwU/w2xEr/eX2FlmjfkbCFca2Uu+UvDV2wh6moq6K5vKaz2ndktX6eqYf4Eu
         zwNtM6BoeMf8JslgBVsNxragJABogESpVzuAO/FIyIzAtt0thYdvDtmjrODAT1QmSdSW
         NvZLsBSnIreruNTgVgKxuhcCZIXKE/C8r5iwpcfCfzljhr6fPcp/v+Mq4cTsh2jf8fzr
         T8I/54u9rTCRFK2TDEpPi/2bmgCSjd+eHQEhhLHzCRR08hclI0NJVF+6WO3qAATW4YN2
         R6hjw9lRo1SdNxz+dNIHp0l7Xzkyvfl1nU+1rWZ1IVvWBP0arhevliFxlKOgSlRsLBoP
         riuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676497; x=1716281297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=w+7pFteIxXYWyXemvX98aAkox2Ela7pIXJg0ZqZPSRlptvNmNLtf0U/dVwJKULdyIG
         g9s3sDsavVxAXctRsGdMFmcDzdOv3LZYKZivSMRhCuHbiqntD27PTc/s9EMrFFgi+/dv
         GIGAVysguFmnL20l1G2CTpmlLPtdOTPY8c2fyFNXVZkX/lb7GCvIOmatlhNb4S7w6MR3
         Yj2vyqaxNYPL34ACNz+OKCVvwRM65f7K6k6vjGGjWatADm9SEbJiLupYbzewuq9+jmDI
         jJqWE3Lu7qTzMHZaGSEvJ0sZ7EwfgGbOPSD/d7Vyxp7qykOp2FdZJG+inZD23/aK+WJk
         4S0g==
X-Forwarded-Encrypted: i=1; AJvYcCVW+S9/PeA65pUTkEj5fy9ODn+j1WTc9IWDuMPqpJXEh1JyFFmUjceJPMVhaohjBumy2XphXooPu0iAuu/cDz5uAbq7x1FTt/I=
X-Gm-Message-State: AOJu0YwztZzeeDBxXLb04BujXAxoWeTWDH2mgC1pPWJX+UI9dR+3irZ/
	+WE8dQL57DywgVEger+5eB3y+fcXgaxGyotmoqZ2NHBJOxhlnB/U
X-Google-Smtp-Source: AGHT+IF1tB3asVOcIehbdULs2Db+i3/DdCJln4N3P8SkwIhnJXqJQWr4URVvswDXe1xPOx3i62bGnQ==
X-Received: by 2002:a05:6a21:329d:b0:1af:a5e8:d184 with SMTP id adf61e73a8af0-1afde224bd1mr14425374637.5.1715676497576;
        Tue, 14 May 2024 01:48:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:16 -0700 (PDT)
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
Subject: [RESEND PATCH v5 09/16] lib min_heap: Add min_heap_sift_up()
Date: Tue, 14 May 2024 16:47:17 +0800
Message-Id: <20240514084724.557100-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
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

