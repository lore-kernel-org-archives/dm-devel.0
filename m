Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3141F6EB56
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676519; cv=none; b=igLLn09uH9D0zCRf1YFaQ0uX5MnyWPfh1RPVc4CLY+CkF/qXTwBwGLU6Z57BI6qPjgQ4SYGTImLrwtPi0oExocRTqlIFFOwlnT+8T41CvM2mNebT0tr5wGdGYBBCa9NGr8U6a8+oMEb1PSMzP0lFBKFeqpuuD8+Hsz/cxV8ID+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676519; c=relaxed/simple;
	bh=T8bV4BnctbyRNeSPAOZwi+czorsklhrFY1lqJqcqucQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rFqDir17ZcIUAnfXUuQFKdTFHHeSwfjgUIZXgFRhywQrhzbP0KK6me9bv+4Wze/2X+wAxmTJ2sWT8Oq+USIWW7DIjFNMMM0xTO8t6oX1GiegjfZr3Exx+7U0vjyMoj5hfJU88fZYVclvX1D0Q/xNGtVBjRVumhtqcj0olkt49Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KszMjIl3; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KszMjIl3"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2b8fb581e77so513566a91.1
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676517; x=1716281317; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=KszMjIl38u7e4IPJMkWqEkZyeuK7ZkU+eOqMFM4ka7sXEev0xqdxRR+uPW5c8g5KBQ
         mbczM6jjND56st9H5RIaMogWOzDMoibDtFNbFg2+5xbynpP4aC9+fWfwclINqRlJke0E
         6u/sX6WEfLKMnhEVlA9j9iPDbXYMKQcyULJLPy9GhwlOVcNwR6W9dVwTyBQrP5JzsO9s
         +bfmziZstpIafP2rVu9zf+55BIMXHu7dmh0ypLQcOtm0tTxWOLy+yGFBgdrOi6QPHnjo
         6IXjOjJjxqDCb5AbH8kvqCPlJ+UdQwAon9RWC8/IuBOvHAaOxT0BPkH5d2xZo9QywvQD
         p6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676517; x=1716281317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=XzuHU2SMjDfStrbDa42JGcgUCxlL88qeQGsf18n0WrBvqBXl6iE1fIkB+f35I34V0m
         Qty/5+Bhq9LWpdnUcBfHdIQQ3LK2FuvYsFPw+gWlYa/v12bAr+Hdvfkh/PUjpRPbZvnB
         28dkpG0PuX9VaQTK32phiFDkCYu6gCvwQyjvI5hISJmPGqCTFhgP9/9o+obKdMlgPMid
         cRSrmeFIapw6Ofv7dZ3luxniVKh1eKvX3v3oo1ebu//qZyLBfyQEkLgLCfv6ITC7q2tn
         PetzlYeWw+MGWtocxyPrWTC7CrianVq2ZrOfpd5UxMHEj9dlhL4YGxlYLT2vheHR1Y/B
         5HEg==
X-Forwarded-Encrypted: i=1; AJvYcCUU9sQcaZ5sKO91UcgtNeGBNFz+XzRhw/g2d7E1+mohcj6vtQjieEg1woxMlVPsS1/Ag4c8ZOJsqFxDJrfM9aLWYOuQYfp6FFs=
X-Gm-Message-State: AOJu0YzwSYhPhKDz9YqawqP2yNb1o7FSzdyvRZSrjWdIopOqd1Kl3Co8
	9XrzGip3WFgKYcJfQe0EDidoZfx4O8HgeeWMMd5Z/r7JUpm+HH1m
X-Google-Smtp-Source: AGHT+IEzlf/04lUJoXxSbnAU7zQCtwIAC9yXyQQEJzVOzxmc9j9IenXqL82SIeeytIkK98ac7sU06g==
X-Received: by 2002:a17:90a:e2cd:b0:2b1:88bb:20ed with SMTP id 98e67ed59e1d1-2b6ccd69770mr11166692a91.2.1715676517541;
        Tue, 14 May 2024 01:48:37 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:36 -0700 (PDT)
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
Subject: [RESEND PATCH v5 13/16] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Tue, 14 May 2024 16:47:21 +0800
Message-Id: <20240514084724.557100-14-visitorckw@gmail.com>
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

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index f907c694e852..78de60f6ef1c 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	void *child, *parent;
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
@@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	for (; pos > 0; pos = (pos - 1) / 2) {
-		child = data + (pos * elem_size);
-		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child, args))
-			break;
-		func->swp(parent, child, args);
-	}
+	__min_heap_sift_up(heap, elem_size, pos, func, args);
 
 	return true;
 }
-- 
2.34.1

