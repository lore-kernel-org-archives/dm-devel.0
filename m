Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45DD2C84C
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871249; cv=none; b=K6tp0dcuVGKrvGqtX8FY1VOIKoWS2EahVRq7Z4Zbuq6oUII0aZ7fDzxEMjg4NSw2uf2dvThTlX6it7JCnRKDYIqu37RaRixLYv7UHpwok18gVvpCcGm0deYWYOyBOuPTavayXnZjPPPYMamZB7PFeM+EmBOFYxmRCHEflFCzu6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871249; c=relaxed/simple;
	bh=yTJX4YtdwgEulmGVYBrgLkPT5pZIiK7xGcI0Hsz9HoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RR5dONb+P4Oer2uX2wYT8MG8dpv51X9Vya7iO5747c2VVbiHYA0VfLZMczp8JrtbpNefUhEAWnT+s30sRmquvURuGDmTVH0cr56CM2uROclt+M3kuYxxqs4DXvvB2zzDqKguMtLbz9Iy50Fq9VBuIk3dc+/2eHBe+etIUIQ8gTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhC2HvFu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhC2HvFu"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dee5daedf6so7812775ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871247; x=1711476047; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0us8+h8cbtOm/cTnK778odLRaJj/mu367/JnBXEvBM0=;
        b=hhC2HvFupKTLny7i0CLnvdFCWsf8+E+1XRST72rHeRvaIyBZcvck8j2hya1sM0rOOg
         cLBgYnNYxP53IJYaExM/PcPEdeDbTwvfvTyLjmpM927d+2HOqhMwzMNAwkRKjqqWKsq7
         5k4qkuiEfCqRVzXAYZub22pE/cyG0haPe+YgHry5hguZQhLdEvT0fm9xC1G4Wf6wfsqQ
         qh7qWUv4vx7CtOa+vh1T36qGUfn6/wTui8n+nbR+Ty3I/27+u6R+uq6uaMtQ+haZG8c0
         5ZiFigBdGAlVl4zksQqHOSI0uU7W1BLUGG733yNIG9T7jD9U6eCAWquyoSgHME1whzqt
         tlow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871247; x=1711476047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0us8+h8cbtOm/cTnK778odLRaJj/mu367/JnBXEvBM0=;
        b=uPZQI2GC6pKFaxPXubH62WyckiC/g+tcUCbbPTkK0oV28xQ8OAc69d4clcq5Rvw5Rj
         xli9TtAbMj7RTg0+RjeVYuZssrkzuGSS3s84twupbwTOL5bc0cBsm133mVct+d//LDWz
         5Yp/k6Dva1JAYBKfGkieyxPj8IQ3lA7j5YW8lo//IS9V+q5/ietZXXt+I0YYtdjtarPS
         YON+EZ3Pc/HQA8mulHA6VTdLhp2pnmV23CCIGsLcIVRe2ItizuR4Uy7zCf82ArCXZmGp
         z4pMZ50IgqFfNh/SetpYpJFQn9tE5ig764sZunty1n1jJZsbdTTZCSwkIytYzJKK/xAS
         IQ/g==
X-Forwarded-Encrypted: i=1; AJvYcCVHcseq6KbEyoWx5pvfcJ8zztccUOZivmLJAsLC6r876AOlkE7sgsTaTTmBTf1w9TXx7RpKkp0257Fp/6T89dhcmTpGvaaK5Bk=
X-Gm-Message-State: AOJu0YzwGn6N4blgB886faNg/meb2UI8gMCOW+JqDAROlOV61ge/lt7N
	y7LTR85dT/kUOZJd4u6KsTRyYx3QV1zQJeuKCDe/4qyy2KFkFo3W
X-Google-Smtp-Source: AGHT+IFaDQPKXrZW+fS7R5CytoBAvc38atn+/rwr+gJqsg0kfZROW3rrwE051quXouo0EjA3EYSr5A==
X-Received: by 2002:a17:902:d4c6:b0:1dd:e128:16b1 with SMTP id o6-20020a170902d4c600b001dde12816b1mr3109208plg.6.1710871247072;
        Tue, 19 Mar 2024 11:00:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:46 -0700 (PDT)
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
Subject: [PATCH 07/13] lib min_heap: Add min_heap_full()
Date: Wed, 20 Mar 2024 01:59:59 +0800
Message-Id: <20240319180005.246930-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 7c1fd1ddc71a..b1d874f4d536 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -66,6 +66,16 @@ void *__min_heap_peek(struct __min_heap *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(struct __min_heap *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full(&(_heap)->heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1

