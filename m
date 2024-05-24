Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A896F132484
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564672; cv=none; b=Dfhmri8R93YzFI09SLPzFplv3J79iF+fs+cMZQeamX83sFHaJ0hob1Wkjn5Hm6rgAU9mlhd6RhgDpZHhuxKENBQ+EPcXpugyDA3EJ1FoD/RkhSfPsBsEueuRzXwUBXvtVNWTHzo/1h2MTKOYDA2GmkwUiZrm8kfsTXw1OHjz8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564672; c=relaxed/simple;
	bh=77HUtebVrJzxuUnhxHqdoyCrlqlYVs7r4OSNokoaFRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BrrPsPUWeaYKNsyn05vBXt2yrJGMyM3hD0Sw2zzp+JoNjmDT38TK64Xrh2U5c6WReQ/Mo4za09MC1vSbHWRqgR/7SB/k6wVfrVKipj3HRH1tSuHq8AozSVJ0WLh5iMLpKt575TGz5HcLIEexzhhA4vCMp8CxS/6iX7umcv0QDaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L87ma+aR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L87ma+aR"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2bf196037a7so247050a91.1
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564670; x=1717169470; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JeiLg0XMliHOkIglYnFk3DvCIMxfANwaibZSEhPQVEc=;
        b=L87ma+aRxElyfg1oaDJmOKiAh4a+WigJ0uYjac+r5NqaBHXKSstTtO30ZYfxYWtgod
         L/NpwEby4MrqgTAjR6OTM/AKwWT+NufS0UJIgr8lGkZSHsh5hdfxdGEzoER3l/1iUT8y
         ubHrKW+SbaiX1F5ycCXY6OZ/tg/wLX/iHDHeqcrai9Owk802pqVaaqn05QdQ4WX110lu
         AG1PXao7pELSxfbZG501UMAczTpWFpED9aSMiRXq2lefgA+HZ7b+IpL2UI88qnCrfYvi
         /+dbWwXcokaJviVm7fUbip6PE5hywPNtga+x22RGcwmIjAJAuqzHVeFQ3lFXUoyzqIdp
         ixAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564670; x=1717169470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JeiLg0XMliHOkIglYnFk3DvCIMxfANwaibZSEhPQVEc=;
        b=GSt7oEflf4MR/X86cZHwam9kYo8oH/Ewy2hjRObinloXngJGXTCgbr72H9iQtJsMqK
         91TQxfD8EPUKuW6icHq9y2BkKJ4/iWYECXM5P2Y2gEyubtijiM4f3AReiVVmCT60RlF9
         sY+atjUdS1cLV1iGbBsDs5DouGnS6ekel0znXIulMq2J5ZGYsY0+3CtBFFSY9FLOy/jt
         ZUmvMsA2KQe3O9o174KQs7iE+rUR0/XtQVbt73f3B2kXtDhaKIDMqlyxBwnYdDa2k3+1
         gT4il/TvoQ1mMcOV1vxpfspt1tNZCclzRUQoJpSeTbNbFv2ZcdSf+AQHMm48OSYLJEza
         Qruw==
X-Forwarded-Encrypted: i=1; AJvYcCWjC75P6MUoXRvRPFc2MhxvCB50Qjuy8xEOKXepVmwkPZjTjFrGgY2yX/g/BfzvwdArSaiHasA0FY7lyzrgpj8a11DcxbgVjgk=
X-Gm-Message-State: AOJu0YwguUX/daWBYcld5ZfSlt9GVRe3UtHpHUUxwx3a/31FqjFsfbb6
	JqgVCPAjWnB3bEIqMIx8Zy47YBV7vQHgVxWpWMrgyWPo0C045ZXn
X-Google-Smtp-Source: AGHT+IHbcXWiDmwxfe4l1q+/LLknHHuRnxu4d+1rEJ1rLFTk0UBMcC74U6va1+XSc6Jx655Pg8nFDA==
X-Received: by 2002:a17:90b:8b:b0:2bf:7c50:1f6c with SMTP id 98e67ed59e1d1-2bf7c502036mr785217a91.2.1716564670052;
        Fri, 24 May 2024 08:31:10 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:31:09 -0700 (PDT)
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
Subject: [PATCH v6 13/16] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Fri, 24 May 2024 23:29:55 +0800
Message-Id: <20240524152958.919343-14-visitorckw@gmail.com>
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

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 0baee5787247..43a7b9dcf15e 100644
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

