Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E0152DEA
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054777; cv=none; b=MUCJodl2+k1q1aCwFg/hDCKvOyMFY+p36OxB1sR93PUVKQluSRNp5AjbuDKw1XvolNT9flJ9szlyBOuOO7r1kQhxUP3dacEU/EITWOHDVHl4xho1Vlz+6j949PNg0axqGZ0Fj6K/oEhubsObNzC6xntWKFF98vdEqLGoEs05oAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054777; c=relaxed/simple;
	bh=T8bV4BnctbyRNeSPAOZwi+czorsklhrFY1lqJqcqucQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PR9kMDd0AiaOQWMBMeeAy8QasIbLGwIJlQj9TZl7XyfdMMNXFYdodvgV3N28I9KrFoV6nL7QpF38WIKnqPaUxrekgEPqu9Rjv07E/StXoZoEHO+BY2/sWlngOapOBbIPucdBtJJYX3bs7PTXsiOcZe74GGY6GPPC0w7rMRvTRJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PFc7stEs; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFc7stEs"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2af71daeec1so280006a91.0
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054775; x=1714659575; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=PFc7stEsOziphpPHa4f9z975mIQcOE0gJlin1vc5ZCPaRJA/iopJ9rR862fu9l9Sfj
         Ai2U4O+uVJ3w2sApu+DjTIB9DZTxDBQQjyreFPVaecft/KqIHcoXqZyz8lfb6+MjFYFH
         tdAwtoDUrMPHqxNp+G2x6gAn8d+CqU6YF3js/ltLw7qFcVQb1Z7LQWEtVvgsF4sE8uME
         e5l3WyT3rW01O5IqN/lJIdDN6dc3jsnOaD9c9pD8xcI+VSkrE6CABP5hBZKCucP0Itv0
         E/Rk4C5ganJuNWUeHMqy9VyLjrrpC0Gyk4uAW9mYY0fVFrWqXO4Ffg396SWiz3BRZwLB
         hicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054775; x=1714659575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=dpxcXbgTxmWcghniREvFiE6nQNTGJP716CAlLA323k5/AUQ8yGpJF6qdE+algHdtNH
         FUc7XhWlgus6DZznK9xDdBM4MEpBpY2Qbu9dYVoQH840D9yEDUPXsAMbqGPo7gxvmExC
         DmsRkFXPECQbGB72/wq1ElyH/iNZsmC9eqV5DZfJNVQBMFxFfoPVW45Xu5ZXU0yOKJbn
         E6iQqXycjGo6aiA/6Hv1+yFOb21ZVHss26eiZ1U82ZXZqysRuA7+n5VTEQMaoAFzDg8d
         GXi+ElRLrgLsDCuDM974y4kVtzBCyjv733OKZ9In1doB+Z3dLJgY52Or0JM3UvrPDEpG
         f5CA==
X-Forwarded-Encrypted: i=1; AJvYcCU+m/GsG6BzA5Jm7PFV1U4aJ30XtW3lf13dauYIIvtImiEj4j274ShrdQalhSBoasPLomadgb8oLtAeYhlpAgs2EOk00Kbwwug=
X-Gm-Message-State: AOJu0Yzf/vczjQFYBYDJgYya8pw7lTbbTHKKEkbfillMRDp+gmOwi2KB
	/1OsXrANuiv1q1otR0+Y/NtdSn8MybAKb3xqCrltJFqoUT9OSGk9
X-Google-Smtp-Source: AGHT+IGBe8hgFGbuBC4ekuepdUwdxdD7VhNw1epIWU2Vo3BxbYXI3OtABFUKqTWAQLQkoTbbEGxrVA==
X-Received: by 2002:aa7:8d15:0:b0:6ec:f5d2:f641 with SMTP id j21-20020aa78d15000000b006ecf5d2f641mr6845273pfe.1.1714054775411;
        Thu, 25 Apr 2024 07:19:35 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:34 -0700 (PDT)
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
Subject: [PATCH v4 13/16] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Thu, 25 Apr 2024 22:18:23 +0800
Message-Id: <20240425141826.840077-14-visitorckw@gmail.com>
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

