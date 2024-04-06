Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF66054900
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422125; cv=none; b=XwxNSOyb2R+6O5kWMB37V9acg53JKvJQxwzYaW9LjqobxQLkLkVIOQTZYmu1Acxp/7oFYCGLFuZXTQsMHqpGV35vkJOvdbXYYw8iW8knDBqflclk2HejuBNn97Z6o2nAgDjzfa6YBPNM4jGRsCwnwe207Nd0SkK6vyFTzON6/iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422125; c=relaxed/simple;
	bh=jbKOXPA+Gl6IpPqMVqcysMX060d8McJnMIlICl/F5mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r4GVd9LCDBLIQqHwHpKGZ6MUGl3yLMZKUy5PHyufeqkZy7wLaq2emPT+iSoVmyRvjXamSraJVh6GffvYf89DUE3UxZWHzTwyDjRnHl+GQkR3JzI6i38Q9FcTuQ6Ndd+TxpJG2ZwmCw+l8TNE7jdAZRmxOZ2Yp9U6mGZTsAGP7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pv7l68z8; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pv7l68z8"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2a2d37b8c4fso743479a91.1
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422123; x=1713026923; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVBRW4eof9PowDsAk296tfYzBeUuniogKOiljPXuw18=;
        b=Pv7l68z8Ke+lGM2o+becGWwNxzW6SzG8CdQ1qQIHvlQwIJ46YOnJMELpEK8Jj5S1f/
         uF1ttbhIAO3M97CpTVDprIApBUaq+Y86LMoKfqBrzZjZcpkDtcT3+clQX/QUeWSmRWkP
         JqBD4rwGMbRcop8tSiRFLau9lxSE5Z8jKNsQZEZdAAo9a4jQb46BbQMPjZQXIZiSlmpl
         pQluudUtUhYHsHRBwX13qn3AhGyWylDyx4HCbnN4CfHv+by+O+OIO7kwItpKqevAGT0X
         cLSZkqSAZ7b+tYjxB1sTpN071w0lT6FDf8lu4BskfiEl1jKLX2Zc7dDJqslxBkDbWJDF
         0ZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422123; x=1713026923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mVBRW4eof9PowDsAk296tfYzBeUuniogKOiljPXuw18=;
        b=MPEgDYVmXVK6e84KNc81uaaQeT7eqzeg969UGRxpBn0V2BBL+tr9T8M/GMgA0DOWWE
         xePcCdAX3Qu2smLLnCUd26dpo58vuYF8EucLy0eUrg6l7RlZEWSlO52FGho40CEZqZ6/
         Nw4yqKFJ57+vrhcZ7NecDoyYD7wKgfle8j02MOEYwc/7yD7+oI2RFjkvJtcrYH9pQerc
         aiOhNCN4SnLKk2i31B7RlSy/Iwcv/Jb9WXRIiTnVaIIlonsCimNsh7GRZCxfq2Cwu7Ax
         AZVGoXYRyt9C2qMgG9XSIai0BvZbgzieVpTMdiN/82METkgFvFfszTCpIpY5+AvyOziV
         kLWA==
X-Forwarded-Encrypted: i=1; AJvYcCUyFu92ypg7gtqmFILrwLJWkwefmWqdDDMyJRKWp+VDrTB5aUoDLlIL1OvAss6PbW/x5FeIg0dyTb8iXajRrBpSvHkaamPhgY8=
X-Gm-Message-State: AOJu0Yxe3iTxaqC3b5wc/zA/4h0csoiWLEHX49TULzFDgqQJbnDDFrSS
	2dLdgC3qnPGRulbEGA/4XXhNbL6aHg+gCb5WP+VMtdl5QTTGaVED
X-Google-Smtp-Source: AGHT+IERmlFQH0vffhtfBW7h0zEYLfp3+ry7ehJ/YlP1A2Hxhl1UdWDOsD2vemJY5geJTKGS8TJGYA==
X-Received: by 2002:a17:902:cecf:b0:1dd:85eb:b11 with SMTP id d15-20020a170902cecf00b001dd85eb0b11mr5562644plg.1.1712422123243;
        Sat, 06 Apr 2024 09:48:43 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:42 -0700 (PDT)
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
Subject: [PATCH v3 13/17] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Sun,  7 Apr 2024 00:47:23 +0800
Message-Id: <20240406164727.577914-14-visitorckw@gmail.com>
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

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 3086612d7cd5..fe037eb5952e 100644
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

