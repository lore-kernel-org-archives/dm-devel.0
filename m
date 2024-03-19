Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742C39FCE
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871240; cv=none; b=eqx1oXyUb9GWRMemefVIgW8xs4MaYAksn2/+I7wVGnFYhWihKKA9fLG7N6ytVtuneDzw3ONSBeKl312dtI9UIvQLFhheYpABC3LeC7Z2ayKoXetYlhCNxJ5zi/xh8djOrDz2ixb4O94ak8vvBPtgk2r1kaVQb7jiK7+USaTTnQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871240; c=relaxed/simple;
	bh=1kcI5O448ZoSUJqM7Fwo+CLjTMdYaBqUzIGDOV4I8Wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S3hXn+8w0FUKlfsAPr/cyLYhyTSS9qdU+QpRDWdu/3+JnSoYpRgXVvcPbhJcBeEHr0Irly4HDQ3yINfGxnJXM2jrnN4ubBgYBBoo79uFPl4q8LoxA4T8M3G+gUJz8/Ug+uihODZ6YHRkXm2sen/u3Q8Lz84x5CJ+b9aaY+waYL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qbf1XYWq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qbf1XYWq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1def81ee762so8052575ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871238; x=1711476038; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=Qbf1XYWqEw4F5y8Il/uRbniJZTLr83LbYG05VYe5wYWC1kYq8bI2kuG0603ePUCqup
         90lWdJaLT9d4QVNacuqe+abYpyUAT1vkmzWiAv3OBUCSOtyaq8bScLq8QEDYEgbPmNis
         43pPpkxiFOGx/+MjnjS/oAM7qBcFpDL8rdEWG4pwwNni+aIHTjCkZ5qV5Yn+dBsNRa5n
         HYP9T4LjrfUcHTSpxrQwHZNf8vBkiTlUf0DYGoPM4+7mZjN4J4gtt+rSlgvrtTxojbU4
         /7evVfA8UHT1DOcLJhv1jcRBNj6nhubUqhBgBh9A7iRoJDcVU4doeJ2PGFbNgnAMfOC8
         s0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871238; x=1711476038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=TqGtd3yii15wNra8ZaHAZBzC1JN+naFslLbxVWrHZVc78xCd78BkN26DIahmwKhL/0
         uGx3z2F0yuN2LrqwtNxGjMorkowoGObjonzjwAzcYw/pn5jlrBTCrV1G1qBOvU3yVW2W
         VczigP/xV31gxOh0+ciWjYGjFaZfLAjQBO/rwaewZrE2PCeFQR03vDc4ZeFP7oYSjMgs
         GTkn+MKctsAFvFHIt04IaW+vT/k27Fovu6m86/1hHHC4QeW+9V4as/2QZy23FFd2fzBh
         UoqpJYVb9bY5p1AID1TqrF8VXxawR9TRat9TNGYkSq4CEaeqeUqnasDsLyGRm0tuicDW
         aAEg==
X-Forwarded-Encrypted: i=1; AJvYcCWYbCp3sGsquIrDRZ2Peka0M6nzFJzOnzApPMnPCGEFpkGLmXxQxQXQfI8p8iHPwO3F7h85MxmlOO/sTjSeL76MsjFdn5ggp8U=
X-Gm-Message-State: AOJu0YyLCIcZSCP3f983WknaRxMpRLVnjqozWmBC3L01drg0+1hk6N6h
	lOLUvE3Rvl59P6vglsYvsvWhduhg8X2+YygcwQ+wYYzom2OlKBGq
X-Google-Smtp-Source: AGHT+IEmG62jJmsoaRkrpL1XhfpAvR+sBzrjaRo0zakUg8127IT9z6Y2bZCHFDgurpvJ46NmFObQhQ==
X-Received: by 2002:a17:902:f547:b0:1dc:c28e:2236 with SMTP id h7-20020a170902f54700b001dcc28e2236mr3253079plf.2.1710871237779;
        Tue, 19 Mar 2024 11:00:37 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:37 -0700 (PDT)
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
Subject: [PATCH 05/13] lib min_heap: Add min_heap_init()
Date: Wed, 20 Mar 2024 01:59:57 +0800
Message-Id: <20240319180005.246930-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index c3635a7fdb88..ed462f194b88 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -44,6 +44,18 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(struct __min_heap *heap, void *data, int size)
+{
+	heap->data = data;
+	heap->nr = 0;
+	heap->size = size;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init(&(_heap)->heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1

