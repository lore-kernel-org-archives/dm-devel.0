Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8563637152
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676469; cv=none; b=ffqR/3OVYKIwt5p5AdSkwrJtgXFWSFP4M5lYtrUCq2THfHoD/Bs+c2yVnY3joFncDQL+EPOfQA1fN8qBa9l2Je44rtaqsDcaNEKEU3uU96jSEcOVDU/wVtG8EZ2OKt1onX9ctft7oUrfJle07NGRuhjuEuB52DR71EqJeFzP7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676469; c=relaxed/simple;
	bh=F4H9nDZNXyr/ZsFI+cCJhr3OYw8PynR+1AAuPVXPV9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dEqoDRY8YTW+f/o8CVMyvXtF0obF1VLnwZMxgTIRXSnN4wU/rlpmnuLAhNlAn11LrmG6mBlyucH7cdi1sbIHYxmCGoo459uv0VsHwHqUU/fKvwtf/x8axs/xJwbCeCtqm3y5g2ACNSZeFHe/I5NTwwMCN1/fdCrpOqZfvrDKKSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/0NtQYt; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/0NtQYt"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2b620b0662dso1336799a91.0
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676468; x=1716281268; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=M/0NtQYtlxgcYU7Q9SvdyqIU9IQrEFFLCquf2+Nk3k0Qinjl6QK/RpCwVwfQJ+9mCN
         uYopORi4+Md2z99LnZKmQ7swYd62/Ex1cE+m5Jny7TYnpRiWyzZaEPimQAr3oZpdlNUM
         tiMgtFOwqXsJ6nAVf7K7gRvG3Mj8qLGzSV6PQryEye9EQ/pMmhXEKEx/Ak39IBWxAunZ
         Nz5pQSTfBX7zZ7k1ftlRnt5RwhFqv/86/ygR7kYJ2d83zSXr0qCi0Pcol55HSyMnRyZ2
         2F6OBcX6zid72rGOsuxThc5c8isFua3OQJDV8+618ElT7lNGyUZk1ysz3ZPW0E8cUQ6v
         H1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676468; x=1716281268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=KsKeDyw2TEGCtppSV0grt3xy70oibPVUA8tH8KWm6yjR5wECur1Csgsr+fBy9ukc9c
         mRFBXMCbBymYLSd6xOIiYQ5CZvUWs5tRRSaI4IL1/k6BTbN16kSr2YX/jv04ST590m9j
         xItHW7amSz0rS6B61MdgVYBDvPK48vWkbnUbaG6xno37tjq9mWbZ5in5g2dcmXoXNUG/
         0Py4kHc/baQDtpAFF45hl2z6XYB46ifzg7pjncG5IE0+VP1jg558p/w29McVbkj91Zoh
         m3KKxG5rDEkZ1mdr849P/6TIgnWkwjdARojKWDhDRYrA/MMLGeZ8gN6FK9b5q/CbNUX3
         5qCw==
X-Forwarded-Encrypted: i=1; AJvYcCV1LEnNxLADkoCeX50SbLSZ4FXB+P0175K05/ont6vI4gXiyVPGFP3fuQmtDla3UNCGgKvzgsYd9OIWRqNbiDGKdY13qNV+5U0=
X-Gm-Message-State: AOJu0YziMakxWXO/zjPWwixYOrIH+AAs/LZWed8ecK+qpcQGOrDlSiY7
	/GabmdH/o0Jvbm3k19dKFnwI7+NeoP76+6TwVFEwvXS3Il/Spl19
X-Google-Smtp-Source: AGHT+IHT5Fm+YDGnCec0X1e+f4cxpGHHD4p8mj7Rb98W/3AbFrtGCShFZxSTzr0614+V0BxS0fadUw==
X-Received: by 2002:a17:90a:bd0f:b0:2b2:4bff:67b7 with SMTP id 98e67ed59e1d1-2b6ccef5a6emr11238648a91.3.1715676467913;
        Tue, 14 May 2024 01:47:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:47 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [RESEND PATCH v5 03/16] bcachefs: Fix typo
Date: Tue, 14 May 2024 16:47:11 +0800
Message-Id: <20240514084724.557100-4-visitorckw@gmail.com>
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

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 92c6ad75e702..05ac1b3b0604 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
-- 
2.34.1

