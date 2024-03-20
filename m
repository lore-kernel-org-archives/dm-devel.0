Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0385254BFE
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946491; cv=none; b=a2KxfPIgxSawQ6oJjjwPZyoQ7oAUvn+TiRqE4H8FdL4qW12nqESn7UmCj9hPa1/rvWUleCyj3wytgg05BhCVGVumcl7MOz5/Lz9oBQcSq8tfXfWYRG7sYh5L6WNaxti1lWlIF1bGP27ZMKdwf07x9e/OVjw+uTxL2LCDQLDlluc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946491; c=relaxed/simple;
	bh=1kcI5O448ZoSUJqM7Fwo+CLjTMdYaBqUzIGDOV4I8Wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V52eWv9/ZEhVlOZM4HssBS/Oaw7ePo2epACw3LX0cN1seBv4kHY3mvtLb92mOS6nQ47eCwScRyUk7fRzxZBqcAY6Mz3XIT5XdvEOc8LnTBx1A0KOA7w2kqioC9zDrKP/WENAOgECbIMVG7Mm9+aeoNxEEbh4p10IQJia5q/uZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZLNKyzRG; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZLNKyzRG"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd8ee2441dso11936285ad.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946488; x=1711551288; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=ZLNKyzRG9ZxpuDamuM1zrvOvHhbjfsBBbDKKuiBA7PillK6IsnmXHRMBRe+iDCFr0C
         0jcHVROdG1/wh2qUemtaqP3u1ROHu/McwzsV8XbTLypR9YT4S3roltQ3uCg4EYG3O0YB
         5yKyARgt7KNMs2b4BEF2JG6bWGxSy1VRDPD76jOCW/5/pKrBtiWBlTpkR7aO3nl/yEdF
         jCfDqAv1WvbeSa6SD4+ZxkxYEqrfTN35PQXoCPJSueW7IRtwD6V173waR9at0g9tLc2F
         snj4s0NsRx2Xa7Nq3IqHhJiixEypjVufOpoJCmGqhZ/+qmndhePEx2SAXcumfFuztuzW
         yn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946488; x=1711551288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=M4Tk7lCQI623QjTS2RdOcsFCF9depWg60pL5mVNqGtbsWVgH+rOW0mi4fN/22aZHz3
         098sCY65O0krDJcDMj5a2qW5+7jXVjmhxR4Q0bjPBMevC+9DRELeVkZQsTpn0npFdC1O
         wokRVXGX9KKmXUEMd8PHKZTnNYaXH1h73fhxwaRy7atq8P7UAUeTJLptEramf4oMLVT0
         zWQArtX7P5B615WwYqsfJ4zj1gcIsWNCtDCmM5aP0ZwlfJ3x6tqWg0F/qSaHD4eVJ7S9
         Gb/2s2iyaduaFXqt1sVrLRIFdxq1VvzHUKdX3FpYy4e9zQzyCQdD3O7b3S0T7xiDa3EQ
         d3lA==
X-Forwarded-Encrypted: i=1; AJvYcCWGXpZq9Kh450oLPSi0wWAzrAkEk/cua+njdrXIlqzBqhVoyWOseXoIdn+4+OPT9oiUp1aan+WRZaFMFbOR7oT0j4onWqqEAsE=
X-Gm-Message-State: AOJu0YwQSxxh6Eo5URzYA0IqtTNzJ4551Pxd4Oa0wvgIQITXL/Gs+rvg
	Glhhk85VEkSMZfxEK82AU5GkEWSNFwehPD53ybQuMUB2IMzOHC7g
X-Google-Smtp-Source: AGHT+IGcYha2L/klvjE95SX1NwjIcrrjx6lhQgqEP8rC4e+/MaAzigVjqy5yAHiaD5OOHjIki9QMLg==
X-Received: by 2002:a17:902:d4d1:b0:1dd:6f1a:2106 with SMTP id o17-20020a170902d4d100b001dd6f1a2106mr6183213plg.0.1710946488296;
        Wed, 20 Mar 2024 07:54:48 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:47 -0700 (PDT)
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
Subject: [PATCH v2 05/15] lib min_heap: Add min_heap_init()
Date: Wed, 20 Mar 2024 22:54:07 +0800
Message-Id: <20240320145417.336208-6-visitorckw@gmail.com>
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

