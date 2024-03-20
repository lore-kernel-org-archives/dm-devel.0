Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1965FDA3
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946528; cv=none; b=R6UoBqmJu2ryEF+Mm0HPDMl1g51GB28opouMDB1neaRayr+82dwxsKdJlqJHdX82ykJuMLpys6CG9WY50b7T03/0UNrrE5n4DOxOkaWbVGQ9rd8go5h6WCvzz44sDPNFZaFVclV45TjWQocetxl0HPwS4sYz3VHSxjQMxfhvy3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946528; c=relaxed/simple;
	bh=GQUVsfUcpz8LUorm5To23Yew7xCHJVZumueYQTygjj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bRwEFiBfKxFslTswaYYIp3VyK4JIhjIoBY6fj1nDL+K8eHMq2SxGm4JsZ6zr9+HmGN5IeB/oJEXw1mMR1qXTrCqGbRVhsOqter4R4URCZHLQycIe4xdtokq88pOw1u7ihrpPWAx+MqnZAjCmh+CXYjqcMaRSCcbLXe5Bwh/Gyx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBcehHWp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBcehHWp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e0678265b3so619465ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946526; x=1711551326; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmVSQEC3TeRF4GcV4dCeypJopsqrkB0AwEs9FDrz4eI=;
        b=UBcehHWp7Iuia8KIZZvSANe87O3+TtHsDjjlDXFLC7k9K8ATrUNBYXEa/TWHzJgPBI
         VXoPJTaYL1sIXbvYPRo0aEy2SUD6cA3fz7EYQq7UBmWVd2sN8SCOfWIFfsVhkg/Nx0uP
         5WYK6J0DaGdhlaM0zi3qqlmBhj5EMEHzpzeZZqAJ6vIbBjPoRyVFkdvVwELhByDhSEUH
         yFCmVWYIYunjiwKk7V0BHfSQGexm73QHfbmjmNapdoxjm5cu3VV8OAVXZ1Ia4K3FR087
         uIFaXRT19zQRx9rgYHx5/WqJCbXWxcayG9F2L4Sq5hCZXAYIVjvzZmCr6iOVw5Fe0462
         ZjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946526; x=1711551326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmVSQEC3TeRF4GcV4dCeypJopsqrkB0AwEs9FDrz4eI=;
        b=A5NLuOaV/2odK9Pa18vOZjISufWTnczk09iy2o4RUpwpugly46vGd9ORVa0K7zZYuW
         v0Un/9I2xTT5qcFaDYc5CIWxvlfX26tmqjmeOSI7uxuVcy0wG9tWY6SE1btt/Zwfs7Rh
         nGs+a1cbislwvoCaev/wpRsX3YeMun0rwMWGhsgd5RRpHu/dciVa779lDR6JrgRtyHfp
         yH8kO6JowVsTgn49mQTaOZbDy/qyoaYgegJ2kep/KzBWLWY7/+/oqapdZb8sJjOfTuWa
         YkmCdzNDL/Wae7DtbCtGuHiNMiNLi6qiy5ELrVec1uteC/LHzIu2FjWNm5girvNLgJN9
         K/pA==
X-Forwarded-Encrypted: i=1; AJvYcCVM3ykyjJVrcH68pBMYjrUIiUR+tf6AwYXO+KE6oP4sZM0mF3zPI3vHhA2NTk4fR39dRNDVFZFKCbtEQo1UXnxxFmBy9DyjQck=
X-Gm-Message-State: AOJu0YwK2ikyE949y1yDN4cKhn9XQlDQejaX4JrkLEYp3I1/UKZxfPID
	0OJyO1XqJ4wxHeyRqrOTtkacZ4vFrg0t2eBF3qjOuuCug+Qis1Ip
X-Google-Smtp-Source: AGHT+IH+g3VQKU1UT+u7hlzLEfuAex2ovVYbYrYQpeOaTt68BlJN4QEvWb+lKyawL0mHCNYzU4yQXQ==
X-Received: by 2002:a17:903:1c1:b0:1dd:7c4c:c6b6 with SMTP id e1-20020a17090301c100b001dd7c4cc6b6mr19251572plh.5.1710946526585;
        Wed, 20 Mar 2024 07:55:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:26 -0700 (PDT)
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
Subject: [PATCH v2 13/15] lib/test_min_heap: Use min_heap_init() for initializing
Date: Wed, 20 Mar 2024 22:54:15 +0800
Message-Id: <20240320145417.336208-14-visitorckw@gmail.com>
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

Replace direct assignment of values to heap data members with
min_heap_init() for better code readability and maintainability.

Link: https://lkml.kernel.org/CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 lib/test_min_heap.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 062e908e9fa3..8d25fc8256db 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -67,9 +67,8 @@ static __init int test_heapify_all(bool min_heap)
 			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
 	struct min_heap_test heap;
 
-	heap.heap.data = values;
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	heap.heap.nr = ARRAY_SIZE(values);
-	heap.heap.size =  ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
@@ -99,9 +98,7 @@ static __init int test_heap_push(bool min_heap)
 	int values[ARRAY_SIZE(data)];
 	struct min_heap_test heap;
 
-	heap.heap.data = values;
-	heap.heap.nr = 0;
-	heap.heap.size =  ARRAY_SIZE(values);
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
@@ -131,9 +128,7 @@ static __init int test_heap_pop_push(bool min_heap)
 	int values[ARRAY_SIZE(data)];
 	struct min_heap_test heap;
 
-	heap.heap.data = values;
-	heap.heap.nr = 0;
-	heap.heap.size =  ARRAY_SIZE(values);
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
-- 
2.34.1

