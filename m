Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895981514CE
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054762; cv=none; b=dUpfmLq7hf4qtVvo5QlbE06CqlDkNQLp8Lq6kt3r/HQXpDEW9K0eXnB2ohuPVZ317+E3ddV22vtveqnv3HJAMNmloZVhOWF/MJypFmDne6mNl9WcaEcC3lC7+sExcdT6fpMgD3Dgkin8oFbybkb+R7gf+AvboCdGulbpEFuxmms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054762; c=relaxed/simple;
	bh=tJ7jRhX3JE0weNjdlxeuKf0kQodyCJ3KEJ6yl72FH+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qPZFShiw166D0P3yYJnGtlX1ksQnk07cdwKy/DK6r8GDHkeLHcpS0jDSru1Za3iubEJv/expbIhxvDxclFg5GUE0PM46wA2SSqZvXNlShZMlBT11m6HX84fFs6uh7JA/RVbK9ZnFxcvj9HRde2yCQ+hUUP9F/sX8kT66W4oevZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gpss5Rlk; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gpss5Rlk"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ead2c5f3f0so109915ad.0
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054761; x=1714659561; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hB1FNdY/u34MXPrD/nJEK2rp5x/YUSa36ZwVtrLJjE=;
        b=Gpss5Rlk6Jmrgt7RYPzJooxhMHoN8Ka93qo3v6pkbbArSyBYCrPHF+FM/ofOjGjGEJ
         eLmaPKNF8Pjx9tJwzXpUZ3PGwaCWTRbF1NyKYgLnn5coWl/B+hFjwoeqQCkN8d2uIGzP
         gPkBImpDQW3rLRFpnS5BwuxXtaMj7vOjnjqstXfgziKQmvrS5fTu+wdm1c6fKtp7kmCG
         evYhklW7USgpVOAr606Lpb479ghtLYWcPCEw+GJx2rxJ0Q8ko2WOaaDmLj+Cuy4JiEoP
         EVACgaxqNmqd9LlYDjm4kok8w6CCCgZYXKlpZMu5b1Fi9AEjuq00KE1iuqPJtQD4+CEi
         EDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054761; x=1714659561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hB1FNdY/u34MXPrD/nJEK2rp5x/YUSa36ZwVtrLJjE=;
        b=FnMvLc7K5D3Yo8lJzk/VEQqYw8Ub9MLr1Kp125kChUnqidC95KGvFBEDR0qKJQ1Uzk
         aa9JtJMUGyw2Eixlrd/Z1AiPmMs/DjMRYpF1P3hXuzBQZ1o4dhZK/ULJCduyN4AWjyaX
         fwx8qyipF+7dBHGzF+MAuFj4ubHsdMOrF0cPbR9tvMz2t9tzq3fpYabQM4082+NM6PES
         PJWgE087Elk1R3nY8jLUV+Ew5c69dXr4LX0ZDeggq6BACRPWxtI8AO222dCmEZV6qxpf
         f6oh7hUeI8A+y31ifaIwbuYvzFxMeW4aEipbM+sLfKeiCcOuTYb9tKADgRmQCNebQ8cl
         1JRw==
X-Forwarded-Encrypted: i=1; AJvYcCX2AuPFYeQKFDMlgsHUlo6euy4e8BR20omq05YjPQQXPFTeO3goLwUWx14F5GuPn72FRHnbXWDUDiAPfXbhU74t3EQTLHCMpSc=
X-Gm-Message-State: AOJu0Ywh1zn4ZAztKPZXuK3EfagdS+33AVF3znfmdrDegZSkitStJrYa
	852x9JNwbD9mQql+HKqzBPiDyj9mwjjI7GRWTOvXgW+Howwx94Ba
X-Google-Smtp-Source: AGHT+IGPJ9qEIg5OOvnVBaHQxsAeXsNBJGcq6V1gONZPwX1npRJHljeenUCpAetAla6YwfnwY4G9iQ==
X-Received: by 2002:a05:6a20:12cb:b0:1ad:8df7:6127 with SMTP id v11-20020a056a2012cb00b001ad8df76127mr4575398pzg.0.1714054760834;
        Thu, 25 Apr 2024 07:19:20 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:20 -0700 (PDT)
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
Subject: [PATCH v4 10/16] lib min_heap: Add min_heap_del()
Date: Thu, 25 Apr 2024 22:18:20 +0800
Message-Id: <20240425141826.840077-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v4:
- Replace memcpy() with func->swp() in heap_del() due to issues with
  set_backpointer in bcachefs when setting idx.

 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 201f59cb3558..c94f9d303205 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -212,4 +212,28 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+
+	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
+		return false;
+
+	/* Place last element at the root (position 0) and then sift down. */
+	heap->nr--;
+	if (idx == heap->nr)
+		return true;
+	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
-- 
2.34.1

