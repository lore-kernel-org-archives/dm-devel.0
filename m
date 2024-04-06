Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDB84438A
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422088; cv=none; b=fNjMFoaPS2reU3PBUxMnRsaVHo8u06YV2hm3VzoDxF59IGBaWdrXNuV8lfoYUJW/xhQiDunWF4LH7JtiSNshMOmijDBN9ihp/UAp+pwiekA0Q/iLjnS2eC0xkJnusUB7ucAeVGLe7jF7kiAOuXecN3L/6CAcpPp5t9qCEZ/Raik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422088; c=relaxed/simple;
	bh=41wIMMrsMcV2JAh2IuFxgje7q/XR6YKUnX/6Mr8hZpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QKOoKPi+rW3Z/hlS8hT3n36zFxFZ+KPzguowzsnOsIO8L8jVXRW9OqvxfROWhE24742Nx5GUzIB+3nl0nX0pqegoYEJ9XL3Liy4SoMTo47lITreNkMtNApx1Tu1PDbyexxb+6tsMyYIx4+JMqntxSct/30YBzBVScA/ToaxTTvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpXB6S+J; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpXB6S+J"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e2ae3a3f66so5426905ad.0
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422087; x=1713026887; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUGTczp2Kn8XprLlzlIe26wHtjou4WYa/rxGIi1PK80=;
        b=GpXB6S+J6Bw9NKm/xzwVEsqOIoy3D8lJbpIr8t6Ia1C9AXSAEXcDcO+BLjHhorXv7l
         Sx7E93FZy1U8u8aKBmwzQSGI5y4p2rmpebDhVCfXS3WJe++sDtY324f7hG8nZHzetfyd
         /2zun96kR3Dib7biJNS/PQkfT8A8OWx7eZSKq8/THvrNyxji6nMgwvV2X6LQtZ1ECOFE
         BHJZNgceVzoYGoNa0/qvaBSY1maZkoJGO15rBbrTDltzmWbWxKrmgQ7+T1fyXO36heSd
         nT0NIuIE/tvfLZUinlFNxqqX2HxlPDir57K3T+JWio2hxz6OOHOFmryd8G7d8ozraJAv
         hIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422087; x=1713026887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mUGTczp2Kn8XprLlzlIe26wHtjou4WYa/rxGIi1PK80=;
        b=ItQc3FuBuGuExzRmLmpolKYF3lFHZ1vgFgA6PUAQggamLJ9mD8p8yjTIyarShVNO9y
         ooawjTWSdy/GXTvdjoX3+kgXJAp2rbRUzKNRLFOajFTZfO/JnJqx9IS5RDp3h75cQKGS
         /0KjrHjRTt45hJLo5hcAErlc7fG1Ef0N39OPwReayanjptoWxYwg54bGBFGyNNKcsMEV
         Nu3BWeFcoDKUgd6L5UkcEdyRUUrXF01XJ76JP2uH3JlvQNNcg+k7aORxfafP8uxu9QFT
         X0vDgd0Bw4o752Xx2hIiwDFK+N8H1Ei95GrkDuOuLEp+rJRPfloFEkae+treMPDhtdJx
         JuZw==
X-Forwarded-Encrypted: i=1; AJvYcCUBWDZejNQ6mPdpqSZdFIq9aw2x/pzjS0nK6ekT7DRl/V9r/O2PAI0gi0DN7XyQ6s2m1m5RzF1uvSTO6u/AwLqRVPRwvH/9nRk=
X-Gm-Message-State: AOJu0YxTEEfwdlVASeWwS8Scr8EkOshkN5z7ksBVGasXm8t5OPIWIQG9
	ZMWDu5BAMFPrSpgfnVfGxXW7wG3ikpxYUjKLlX2g2GRKtutVRzoi
X-Google-Smtp-Source: AGHT+IEfdT0u+GNUvqc2IQqievgBGrYbYzE6csgkYg+ooNoxAHp4tOGUzoKNnscpqMdglSVxGHUWwA==
X-Received: by 2002:a17:902:ea01:b0:1e2:c1ce:5b9d with SMTP id s1-20020a170902ea0100b001e2c1ce5b9dmr5303688plg.2.1712422086668;
        Sat, 06 Apr 2024 09:48:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:06 -0700 (PDT)
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
Subject: [PATCH v3 05/17] lib min_heap: Add min_heap_init()
Date: Sun,  7 Apr 2024 00:47:15 +0800
Message-Id: <20240406164727.577914-6-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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
Changes in v3:
- If the 'data' parameter is NULL, we now make the data pointer in the
  heap point to the preallocated.

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

