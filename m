Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6063B295
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871244; cv=none; b=dYjY68bfIOSk7ZAcSFyDRx3PWnzfhNEqWH6H92w7VFasx6jvBBUgk1bGte0Xvlhpmz3tRV1lKYbt/0kPQ2BQp5prKmxJe784A/35goZYAZNXw0drnBKewBfUKeVWTMP5H5aUW7EqiE0dsanRjSmJGFsIToOrJdLUQgqH45+7EdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871244; c=relaxed/simple;
	bh=n8NPWU7TPG0FYu6/1N5UcgjqvR4CgLcQsDnsmf28uBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dJOVssNd/YSFxNINJAJ2/7Fqki5XnJmH4JKdC8btPxEFYrlbZmFTduz6rmXL7qgljTGV6Vkaap+tn9vueNcyoRqmGsDLP9pbGpsWtioO/+tATx+dnBFf6jKXN00uNK0N5q6pAw+JG1/ttN1l3V8eTxxcsGr3XxRf1Hw+eK7SXK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSNLbJhZ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSNLbJhZ"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dd8ee2441dso10459995ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871242; x=1711476042; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFeAQpAK4aUBu/1PW+JMtASIBT0c/sUzFzsKvR09WTg=;
        b=kSNLbJhZOmCeYJXiomC7YDAZX6PyLuPhHLA246SLwhzSK33HolY4vtHaJtF/T9++Cx
         tJk2kFXWB7FXAm1y0X11hFGJgCuZCuppNONQXQeBD+mKOOuOz6iCJL4CSI5Y2KZ45z0G
         0fejDwrOgE/czezZ9AozmTDJydiZPnFhwv2jRRlrpTgkvbcnrST+rXam8fNjlUNNbnbq
         oUbH8eDV9DQz5bglWwQqIWfrcmz5CzBRw65VxRR0RjiVgclozktHfjkJO+mKC3vF8KqV
         HFvoZIKND5Mb/gYkG6c5MkcWOeflyY1nv3/IGa4Lb8yiUG3UMvQcCjgPe4ZzuJBS6Eqm
         FdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871242; x=1711476042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFeAQpAK4aUBu/1PW+JMtASIBT0c/sUzFzsKvR09WTg=;
        b=EwWwR+NdnHj5khyy4nuchtACyTX/yykROnVRO1O23Zx2OckOAT5AChxyyQjJIiYptx
         FIj0YWkDKUfxwUEvk0ohBv2El64yZiQ9LbcfhB0KsRyf0ZnaHx875+wA4PwZ4vQ7vaLk
         /pFKdv+hV2f6Ig5VAnIzdCKoay0FA8Elyr/vAz0ZHp4p7AIAAbRlPLUYS1V6+Wx3rtAT
         wlVlN43DRxj541U1trYKy5nQjouqEPoi6+0gK3RZcF75WLrTuen5An0un+McQpSg7j3v
         YUdEiWoNcVLIahGeqW2DfjiagVHvDYBkTf1b+YYsUWcVvLk9C1PxkjSOidaivwY8buJj
         F4xQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0nhmHWXoYeoUlMUZX+21pnrf33SDzTubYBf0RKhXpAMen70UgtR+za5jwGj/sBrh2B1Im/aHnZw04mzcxgiJgRONQ/6RNasM=
X-Gm-Message-State: AOJu0YzSS1ie7qd49zsmKn2htg6BTmuqP1XLp0zS725nRcgSJ4/Q28WV
	fnBF76OfbJkcI7E7nTuN2fqI37yceF2V9QwO71AAjOfaRrSaryVe
X-Google-Smtp-Source: AGHT+IFB+h3UiEYM4uOMtZyHElq0Cc/LqfYFRVzSSDBHrYR9QcIjIvtermmErDaKNfSoK+egpfDDig==
X-Received: by 2002:a17:902:d4d1:b0:1dd:6f1a:2106 with SMTP id o17-20020a170902d4d100b001dd6f1a2106mr3338647plg.0.1710871242213;
        Tue, 19 Mar 2024 11:00:42 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:41 -0700 (PDT)
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
Subject: [PATCH 06/13] lib min_heap: Add min_heap_peek()
Date: Wed, 20 Mar 2024 01:59:58 +0800
Message-Id: <20240319180005.246930-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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

