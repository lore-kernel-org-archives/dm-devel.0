Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B053BBF6
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676489; cv=none; b=fJE2eY5rlEohUpgDRRFnAp31OndAgRm95661Ubltey4iwmz4wD2dQw4ITgdoNAnR8ryH12wkPajEV+NHBGrEGZcUPjIHkl63VsvV5zMr3nXitJS+V4YRxN07a1wy0gL8IH+5IUuN6aNvdPLnwQR5GpNoaiVfVLpxrDTSKpT3x+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676489; c=relaxed/simple;
	bh=45DqO8bF1UCi5bfdHVSu4s8AvmjNFknYLPsfVsf4ic0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ALVD6ZMzhZMtmBKQVLxAi5RoEqTew3xkIqY6EOe/uX9SXhhhjIgPs1O26JF2RF2n+kbWU/Rigo2ifbGZ5XGGmxQsPFqBEo1x+KyfISCsBuD1YI7v6JEZ5uKuyvDckZC9ka5zh+l+F/eiDur4nPFmqtDqMdlEV5/Fmolwd13Imow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l+5+ppok; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+5+ppok"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ab48c14334so1226285a91.3
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676487; x=1716281287; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=l+5+ppokiCs5ZdkMv/xc94BgUGo3tZMOKI54FLy5grl3uacWCY+IHj3aJQy5kf4+hj
         WxOSylbsXX1nQ9LNNo0mJR2j2BrL/ZBp4mUyQjAofsQS1Zq0IDQ8580ezSk9oH2Bt8Lh
         P0Couk8ybQ4u68ZYsQzj4/hJcoO3E7oD1o6qwQTR/ik0k6T52JolD92BF5dTj3uA8owf
         ammpw6yOzaOpKSg47nDTxsj9JrLtMFl62l6HOyUkHgg7J7edLqCc/j4yFZO85xTFyZqU
         3PcCJSVfmue9exY1mrwmlFcM16LNv4YT+/+pjLgBdecWdMqJ+QtQb3iyzedNbTm2mCuh
         Pm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676487; x=1716281287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=mGXr3tad021DYNHlw7JyqtUy6Wx014bU8bqEzaz7UcFLyXP7ZcqLk7Ra2lPaJg2Fxc
         7603KFvOxQI/EGKDR/GOMiIsj0Ejlpv0h5S0JgRREDN+NIO+D9Dl3DjB3ZfukXEAZbVp
         +IuwRMci4jYtKgbVrRaFrn4T34h55YpX5/WVMHMH1MKCk4BoPJ4DJ9eTdJl7D9Uqli8D
         xEIa4owybcPzqXhpU8uSyl4N2rgu/paDNULnB/glcTZUbfoCT0LlK8IAcKLuxhXOaoKR
         9ZvUZGVZrTsFnsDtKEmCDG2CwTAsPyHmc8PA799hzg4IXE150c/w46j6WMONuUTuLYpg
         93jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfmIbMohfIDSEpS2FFEMo4yzgO5npg9jsK/Ij3txyWNJFHhIYQYcf/JhLJ5TrnDqU7ckIU4FndW/XDuwXLFkNFVfYtZvjjtMY=
X-Gm-Message-State: AOJu0Yw7XHLx9jWFB4FQPd0fUUE2tir/oAZtirmxSwZM9MZSMljvJw92
	pXIg9QUkjFBhxo5SxD/ZAbjiesjY8TsAjx+pbXczDBKbWaOqzRv8
X-Google-Smtp-Source: AGHT+IFfbcYjY4P31J+W01r/olfC4xhBU+O158w6dnsjPNmjyg3v+UZI7gGddaCiTE5ahTFLgPOTnQ==
X-Received: by 2002:a17:90a:f3d3:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2b6cceb5dd3mr11609526a91.2.1715676487641;
        Tue, 14 May 2024 01:48:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:06 -0700 (PDT)
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
Subject: [RESEND PATCH v5 07/16] lib min_heap: Add min_heap_full()
Date: Tue, 14 May 2024 16:47:15 +0800
Message-Id: <20240514084724.557100-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 043de539bf71..d4ec7e749280 100644
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

