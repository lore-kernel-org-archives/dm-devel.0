Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8E640855
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 04:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396964; cv=none; b=hl3Dvw4pUMrBepjN3Y4BgIi/NckPQh0JR9pKP9M73j3W8cz4dOCUaA8JNvsLmWBOA6jhEa6cxWUzPe2siR5wyPI2p+EW4bI3RpP/vw+l/tyxcxHmSK00y7dSg2kQioxdpvlx1u1ck7Af+Gkmr2uyRGq9g0oWTqDhYX6DnZoTPCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396964; c=relaxed/simple;
	bh=uWD7X4+G72y+WuvTqwWeg7t00M9IRkb3ifQpqG/L/hM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mU3BKeGqdOXPzy7+RL4tMFXGPzAZxCmMEz2gbDsShzDYzL9TeCzGuqUMOKNDLl/F8Rzq9RjQKjuaD0yfocdy8q1ezLS6jKB/hGsb8oIrdKLobasXTt6za/wol7naGHdH/cqJ05YsW+EI9AFbi5aLPTcM0a+LkIUVb2ai4VwSLCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QENr7SZB; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QENr7SZB"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e2ed59a35eso2850457a91.0
        for <dm-devel@lists.linux.dev>; Sat, 19 Oct 2024 21:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396961; x=1730001761; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSsO9eyAnWGRK9JqMw2hZIz60NRvRqk+DUJGCBdVXsc=;
        b=QENr7SZBiNRnyMrAkGJ8Gdl0f11a/ca0eMYClUXDHbm0PO0ffI8GHuRThnupfzBkUj
         St9dMauL4E88YYHsECm2PPT5ycwXMph2jqWHtFFXU+nRXK9IJAz6E30qLDR273CN7ioL
         GtrZCjMFnRU4KVssUcJjmZqDMWpx6Eddy8PzILTehU20Rpn7caD2ug5JT08jDqhcfVvx
         dx4qgWM5683ZagqgV75ZW+8xJ2H4yegqupMoqFF1SRSY72rAqevheJXPpEmlSEm4T3S/
         7aZlIE9M/HiUUcSGK1Crjut2Rl13uYzaLGWViGNqwzcOwhThaFo90xtsy2Q7G1P4BPDy
         HqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396961; x=1730001761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rSsO9eyAnWGRK9JqMw2hZIz60NRvRqk+DUJGCBdVXsc=;
        b=Ctuy3hgv5vle4tmGkqrXBQm2poKXwy7Y2a3hJFRA+l/BxS+gnxaCn9IAQ7Rxwqcx8U
         8UXNsXKKoRghsApXtJDftZsufRw/vU4PMnHSBIY9t/tgBHJQEy/YWC+E+1XSct5SP2vq
         mPaHpBYPuEfoSGQAYmngyAmnkE7ycVk55cfCZFLnFxqsouFb8z3y2XY0NrrQU4GhG9fR
         Xx1LWD6OXqpDwKIsoDqXNPqOc7tuc9m7q/e8KLHgZxYJFjYCTARt2K43OTsT9ASlQ+rB
         E7eRNsMvSKWb6V5QD6c7bo4CBhpr8XFRIhZ2baeZY1VJZHqIyObdlrckcoFkh/lOla0S
         XUog==
X-Forwarded-Encrypted: i=1; AJvYcCXqqA+fjJt0YEoSS6oItsxv7cJE3wdXgdxiFDBufPKFaGOS+Vg+Tr1pzEkEGCVY+y5WpfKvObRoLQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz028D4DrVdvGG6kf5kLOY4r6xrKkEylwS8DSUxrgWIgzb56cID
	Jz1qOXad4oNIe30Cx4uov9xAbscHsKh9rRIMLeoaciiwXONWT31t
X-Google-Smtp-Source: AGHT+IGdWI08SJwvOyOfpihMxUYT3OOzFomu22UrUlY7s271MCitpKDj02EZ1IaoGzOFhlnHCnE38Q==
X-Received: by 2002:a17:90b:3c47:b0:2e2:bd68:b8d8 with SMTP id 98e67ed59e1d1-2e5616dea4dmr8067411a91.8.1729396961160;
        Sat, 19 Oct 2024 21:02:41 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:40 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 04/10] lib/test_min_heap: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:54 +0800
Message-Id: <20241020040200.939973-5-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the swp function pointer in the min_heap_callbacks of
test_min_heap with NULL, allowing direct usage of the default builtin
swap implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Tested with test_min_heap module.

 lib/test_min_heap.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 64c877e73b64..e6fbb798558b 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -23,14 +23,6 @@ static __init bool greater_than(const void *lhs, const void *rhs, void __always_
 	return *(int *)lhs > *(int *)rhs;
 }
 
-static __init void swap_ints(void *lhs, void *rhs, void __always_unused *args)
-{
-	int temp = *(int *)lhs;
-
-	*(int *)lhs = *(int *)rhs;
-	*(int *)rhs = temp;
-}
-
 static __init int pop_verify_heap(bool min_heap,
 				struct min_heap_test *heap,
 				const struct min_heap_callbacks *funcs)
@@ -72,7 +64,7 @@ static __init int test_heapify_all(bool min_heap)
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, err;
 
@@ -104,7 +96,7 @@ static __init int test_heap_push(bool min_heap)
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, temp, err;
 
@@ -136,7 +128,7 @@ static __init int test_heap_pop_push(bool min_heap)
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, temp, err;
 
@@ -175,7 +167,7 @@ static __init int test_heap_del(bool min_heap)
 	heap.nr = ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, err;
 
-- 
2.34.1

