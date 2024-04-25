Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF5E14C5B5
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054730; cv=none; b=Z4EvcJ4rCZFr+pLzAti3J4pKnOoeN4mznBnCzCK9Wa76Ka8ApWylA41fpS4i7wkEqrvdRIsAXi91Lb1DC9lNDj+lozi0gzwwoJjQG81oy67kvOWGJr6s4dosI+D+D4AgxKgxRDVgKbywtFR7yqFE3fq4VdqXUPe88xIKOlFyCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054730; c=relaxed/simple;
	bh=F4H9nDZNXyr/ZsFI+cCJhr3OYw8PynR+1AAuPVXPV9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VD9xaV7edg3lpA0j/teanCs0ie8I/2N+j5MEwzc3TBsrzDNHXhxv6qpJl6N0z+XpvkaLLLxk/0US0eF2T4efWvDZPTdFJYnJyUX7TTQui1OTmzTrUtx9Ug439RF1Zpb5Ovhjfyr0jt2USq9g4h8RH7yuhyivbVYPgaqJi3hBmSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXPW32Vs; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXPW32Vs"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e825c65c9bso116005ad.2
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054729; x=1714659529; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=DXPW32VsyRxz2CaKW8dRjQfE9cQ7J2pddkv5lwhb4bGAxYdeUSvOKHcz88JT1cA3QO
         MMfuB6fx2BSxJdZnJ74gTcXz6tzx6jOOfEwF1Zw6AttvQNEDxaAzsYz2Nq0bTnRM+51f
         7HuS33Br3iqvjF0QSHlKOEY4RY42TK8Xtup9iHh9jzJ/MnLiLe2PLtq/P0bK+DejmiDo
         9hTTTFK3u4gV+INVSOE/FWAetVeSlx25YRqE5ILBbVeBi8Gbq7WRCrJ4+RAOdqaYjaVW
         ehzNiryjpWyzfuilSKe6+Z4Onv9f5nFJEe/N0A+Wuj4KuQ374XhvlQsEK7KJUm7VNaCT
         fb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054729; x=1714659529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=P1fDQgQ8YmD8TFLTbLDUJ3OW3DjZQq5S0fNteMGViKgSSZ5vTXAonW6Psnny9sg6ak
         YwTRIYPGSd1DlF5btFJBNqaaueipeRb8bPIN8cMVMnKbmjIKISC79F9AH+FnNUZNcUp5
         m1HxatHEGdssyYVzxCx6mwozKbpdqKTI2zBHUSqL1uDobGFksfyWN5PRtMPcKmB2SwFQ
         bayXS4sx1UYu8hepnEuGrc7WzZ1CiThNC6wNKhf1zwoSA+rqKC4XdhjH4JM6Slc1ejxT
         Ws2+OxS/MvBrwWNKDQPzfcbjE6FdKSgzLhx4GyTfOyHdQO1HlZGcwlHHelMz1cRucKEC
         L32w==
X-Forwarded-Encrypted: i=1; AJvYcCUm6pcicNky4Kd/YjWe+6sldhI6JCfoGgf1rJMN72F20XiDK0fk+7E9Rkcdo+w8AxzlEX/5EqZ3GDhLpfpYTMCel5lQiPsyFHo=
X-Gm-Message-State: AOJu0YxRN4uir++I1hh7DoX1kaabqhr9NFDky8p7K4ZgP48/Yu9VUEpt
	wHjXxis74x2b7R4i93hYZCtZHe0aIWoCn9ad9bN2rFZNLdQQKw9v
X-Google-Smtp-Source: AGHT+IFAco8SS+QgCQv0p+fueHlybivSKvhE5qQYuUi+dWforsZMvlEpw0tqxGG/Sh3EeDZa7lb0cg==
X-Received: by 2002:a05:6a00:8985:b0:6ec:f406:ab17 with SMTP id hx5-20020a056a00898500b006ecf406ab17mr6515587pfb.0.1714054728656;
        Thu, 25 Apr 2024 07:18:48 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:48 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v4 03/16] bcachefs: Fix typo
Date: Thu, 25 Apr 2024 22:18:13 +0800
Message-Id: <20240425141826.840077-4-visitorckw@gmail.com>
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

