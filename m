Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E185646D
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946495; cv=none; b=QEs4UX8/X6AqqYwVGlKJ7t25vMzufyE3wwpEgerEuxRRo37I5xkbmP0+0gO9ZBv85lqVczHZVYlbmQnG/g1M0eXtEsdKDZzo9rjkrgbLAhooGGY7iP1u3+jwULMabiBrRQ83mCgfxf7wi4ahe04vH1SG9v4B0U/NnQuU1YAMNSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946495; c=relaxed/simple;
	bh=8a68K+W3qZD++KgYqdJ8QFpXlGJ3ofQ9m/5i3nVK9u0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xjar9W0Dp6Dc6GldK1R94zhZc8Tn4T4d5EXHSDnVEhzq2rBT0FjWsBa1HqRz/zIzMUqol4wDPm6/f9MgbHUtFlrA36JRJwGd+k9Qpu/vIZBtuUmlE2PMY2hGmcAIqdKXCOK3mEJ64XoN5+8NquAu21XMn/2Tbw2T2ShfjqaHBSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlaEoQiq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlaEoQiq"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dee6672526so6079175ad.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946493; x=1711551293; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5/a5el4a61wFJIBzCgWNmWU3XZlSJ2PCR5OhDq59lw=;
        b=IlaEoQiq1arkQITXLUfZzvmdq2KCmJi6m1CmhBDDUXQ4KneY2p1sp7SMHU7SHnlZd0
         tImwyRO9HwpQ5FxIH4K8kSDqKCIo6Sk9QrGjtRJsZfBhgifEI0LT4t4FyaMseer9CQ7T
         s4xrZwAHmAdtxZQGpla/2buJGt8fv/pheKjV0YqxT1uMqArm/inNcUlWbhR9xNAEQu9E
         EXRfOeMiTxvCNn8eKNqM1tP75ZXeQtxR/jg5k0HIJpyEqTBYUBkdkcPOnyW8QN32nlw5
         lahVkrLzJHdL/RbnyCP+lBfxv2LSoHFRwjR9T97PayOgPC01Qf6jw/vHR8YG7JSREfPo
         GipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946493; x=1711551293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5/a5el4a61wFJIBzCgWNmWU3XZlSJ2PCR5OhDq59lw=;
        b=bhamGwbIfY2jojavbMn5XhaBS9bqn+3qO5eqHq0nzCPx08/RyySxKXXCQDkUIXfqya
         wF0Ge2C+4jsCITTIC8gY5C4ZPqQgUs+b/iX68rOm+W2zoFMoAKIESYkzdQkNCbGJAOwk
         3bB93J1/8NsRTieOhxQBf6kAlgFu8HGhvG8H4hRH146+vyOKPXJ1klS1tUHAAHbPf0Us
         3uBVHAiAPyEFwKxjzj/zcuYMonUBrNuNIGlajH9TgICdkbcm9hvGTt9szKncg53r7Qvf
         iYw5A21Gs5PwFjmyik7pu1+KMvEducu/aoMGb1cngtY2Oud4iJWX0HtIm2pJdqOM1DI7
         SeYg==
X-Forwarded-Encrypted: i=1; AJvYcCV9h9zLqht11FqeCgZbeaO+1qLa7Sq5bgv78Wy2PnFIbkFia9VVUN2L5jCozXOue5cL60ln+TTQmRF8sJqmMXr1tLqaIexoFDg=
X-Gm-Message-State: AOJu0Yy0+KvXt7hphLSIUuf0yBXDnQRLc30azRSJQ1WdIgzkw6XXScys
	QFyYQY6tp6o0mne1EshxvEaVpLOjLA8TyT2U2fMFjS0eWOOTdN3l
X-Google-Smtp-Source: AGHT+IGvhyqndniFbkMNrKQajfiHJUdmj6ZvIM3gEC4yAeOXQXFolKTC1Reahvgx53VYp1rBgyowXg==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr20347899plg.2.1710946492946;
        Wed, 20 Mar 2024 07:54:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:52 -0700 (PDT)
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
Subject: [PATCH v2 06/15] lib min_heap: Add min_heap_peek()
Date: Wed, 20 Mar 2024 22:54:08 +0800
Message-Id: <20240320145417.336208-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index ed462f194b88..7c1fd1ddc71a 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -56,6 +56,16 @@ void __min_heap_init(struct __min_heap *heap, void *data, int size)
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init(&(_heap)->heap, _data, _size)
 
+/* Get the minimum element from the heap. */
+static __always_inline
+void *__min_heap_peek(struct __min_heap *heap)
+{
+	return heap->nr ? heap->data : NULL;
+}
+
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1

