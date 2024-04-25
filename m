Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B516814D701
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054740; cv=none; b=BXVpz/QI1MsgXCFcgdnONMlwP5IsM8f16/xfsZ6VBsh6DogEUNv9tF1uQe4qC2SOmDKrn0lBvV7ZZgCDsJkiXJIw1HB5D0ojRtKpa6AIdC1xrofknx9mHWrqMftZJ7j40+GqGaE5RXUTXHnsPLLtckQT91mgVG4VfI+SZRAgjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054740; c=relaxed/simple;
	bh=b5Qix40IYcfncBwAyPvMRSLFUIF05YVbAb9l7ZjOFyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z0fcDvvDGcXKgM1tJJNvUIJOutct38Q0j06EuZvD4mPb0jy5YjylgF0fJLRENmVOEFRKeNK6mafHZCarkto6aZ4hSLm2P9ZR4m3KSJEYGCSe13lB5GoYF4yTV/XJqNNP8aGBrsmJ9+Yl0Cwz7gKWT3VU5A8mVHQ04RQdOL0ExxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9IZ4VWb; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9IZ4VWb"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e825c89532so163105ad.2
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054738; x=1714659538; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=K9IZ4VWbdmyDP5G6phJd3sdyQM0ggTNf+Lu5NP2aPk7hXwVwpCf4eazCy9H6aCMTKI
         waXxLnrm2hT3KVXXZqczYvc6ecuc7v5KwjKBhyAa5uDu8mN+1VH3wPi2WQXZhIkgYLkP
         DJoIissM+1NmD2WRxBvxmDUSO+q3Ykj4c9Z13HE5rAMVI0/pUJ8T0PNgFtgZSwV2flml
         3U8CCPqrGYrROOE1RLu3w2KCcrzwuKseH8XeHwDIeM9aA0L4kTPp9k3RZJnAd1X2AuuH
         pTrQpsgWwjTXW60Rl/HPpWOFSrO9La+NYX8vcmq50KOJAecO2NI1VTZcAGSEl1p0K3Qo
         +pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054738; x=1714659538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=Uf4PVXRbSIIniaHEnwW+XQNnZ5vQDKsthyXXZa6wRrMnVqLdrCiWi7XdczrDSo3BZK
         iBcAg+JNd+wqwFuKUQTyV0uyZ+D/x2bmeh/cGGjnk/rQ+F5fW1jKDzaeq4+K0Si6QI2a
         qRnuH995YhvCOPvuSlqZoPlir1XzuxEahxLO/gNZdwvnTuxbhoDYc8twBXlJ3XtiGQoL
         tQg7CTVvR5ezfUL/dUlqdy1e6TcT45AIucT+p8FQNahZX4Dmtauo5tMhFXJs4fkVRQqg
         4DavtUaIrzOhRGYroBj8jzt36ADCNXCknA4et2aZZKMA1G689EXx88ghl7nduGRvlINt
         PJnA==
X-Forwarded-Encrypted: i=1; AJvYcCXhVf9UPD6HHjkmFgdGu6Bmp54ZyEKcbIX82b7WxeFpn4EiG2B0rzKdqtgBufHLkmnIqUZbrXT/wfrIiZv6dfgFJKUo1QqcYko=
X-Gm-Message-State: AOJu0Yxgdc2rZz0Ur/1/NYuHWXbtIIdIv0IqyMBNV3U1VsVA2bmMO9Pk
	t6jXF6sbgpjhgED6AcdbaLEfZwHk4TVmys255ez+OyNhJsfqhVBY
X-Google-Smtp-Source: AGHT+IGXAZ+ZP5Nps5IYlgwSWGtymGMbytP6tQx4Ugz1Rte5D4xcYm+mR/lUyzNPTJOSXRVvfLBAGA==
X-Received: by 2002:a05:6a00:99a:b0:6ed:cc50:36cd with SMTP id u26-20020a056a00099a00b006edcc5036cdmr6925931pfg.2.1714054737797;
        Thu, 25 Apr 2024 07:18:57 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:57 -0700 (PDT)
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
Subject: [PATCH v4 05/16] lib min_heap: Add min_heap_init()
Date: Thu, 25 Apr 2024 22:18:15 +0800
Message-Id: <20240425141826.840077-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 87737cadb9a5..f6b07fb8b2d3 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -38,6 +38,21 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	heap->nr = 0;
+	heap->size = size;
+	if (data)
+		heap->data = data;
+	else
+		heap->data = heap->preallocated;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1

