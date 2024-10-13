Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608C883CD6
	for <dm-devel@lists.linux.dev>; Sun, 13 Oct 2024 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845248; cv=none; b=Rwx+eyXbfCASeUOqhxjwIVi6NTQdCTM+0HX7+yFlbnZ2USwYWv+0/lO0fWK5jt9VMmDpnmHEvlCg8ZDgJhmQI7sK6D3E6tySP6r1lIgU4Y79FLQGvWbmaO5qMSbsWlYEwjC+asBcTKfxoR+rSvEz0v9xliYPuhTh67d+w23Z754=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845248; c=relaxed/simple;
	bh=Kb7aX7slRhx0WODloa6fxT3r3WjHydojQpLCssKONZg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ONsEJ/B100QXkx8cNPvpSO6jfhzdlE9hPGTC9VxDdzGthjbZ1g7ANrCy7b0W8v6PWBjY83eqwRVz7ySkNRKkHFzglTxlD6oadh1Df8ulQKteG+V9oACtjcjsFnR7Bri1lPansVx5LV//GXNfqPTm6Pk88rvqpo72RGw6c5hYVXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4aysYq7; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4aysYq7"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cd76c513cso4321515ad.3
        for <dm-devel@lists.linux.dev>; Sun, 13 Oct 2024 11:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845246; x=1729450046; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AcT+988WrW3AMkjQ8YktZMykd7mkHA4KLE0Ju/bOgnY=;
        b=m4aysYq7jaekEvnSBtMDMbtbEr1/2BLK0Jqo7E+3ARoKlnzGLPhok9aBNfDymodDFP
         RfhyAuvHr0V+zlT7SN/C6GqtIJeBmPJNk1qFfFhSYgqb492OFDA0rLsC+uaZWHrZ5l15
         fXvdGvmfBB2327vBW88sjaH2aVMbKX2REfSVWJJon9KXfF4wzT4JCicYqiJNHWoqEo5A
         TueyM+Ke4LhAiKVi6fWS4VLaKp4ANuSdWGCiFFGtJ2xF5RT70n85/CuLFOWNUQFz8Wh1
         +JV1UoeIZLngQnb9kgjntht9ZaaprrdsdT3GZC9mEq3+598Dy9nl9GipssWeBqx0lYkN
         S9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845246; x=1729450046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AcT+988WrW3AMkjQ8YktZMykd7mkHA4KLE0Ju/bOgnY=;
        b=a6gnOzyliIgGVivop2A7pAa3dtIx74yNmerQk46WBB7ClhS4PzdKBh77XdCDXYWia5
         N8pmAgsVf/w2fiN9sPyUKezm8kaomKSZpyla8FzVL5hafPzcWHJttd1tSEzncKc9cI15
         7Oel7OD7MBrdx3+29t/cHByZx6uq15xGj/pG5bkoXEmpHoKcDkG4JzJFex8a+CsCx9rH
         VkzO5S7rIGs/kAUvylnLnaWzTlZtDdOVSnuDrDSY/CZuLYJ4upPcQmohp7ijae1Jai7l
         /3PHutkpE+YT3lqC8ACtaCsWQp4Vzf8Jk7tSODc4RWf3odUQQbcuhQUS/SylHEivu8hm
         RchQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdowWoRsIdsSkYaVlrr6OtE1ya2O0pcJymPl3RyNhnsZZMXxTjXbDqNKVB/NAu4+oIjyuwALtChA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHxhwPb6+XRJ1/LzJlg6FblwG7C2JKMEBhDeqq+0RqfP8pIaP7
	v1qvYMIcnxPwB6CAQY2HRbSOGU2Q5f+HZvHaO0AsWSZZQalSM4mE
X-Google-Smtp-Source: AGHT+IEe7vhlIAeDY/l9HRi57nmdwBnO4mPv9Nua8spEcdISEd1nxQi0dLK2zEHQj5HT3Dg6I+5azw==
X-Received: by 2002:a17:902:ecc3:b0:20c:f3be:2f8b with SMTP id d9443c01a7336-20cf3be31f0mr10163475ad.30.1728845246588;
        Sun, 13 Oct 2024 11:47:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c348f41sm52681965ad.289.2024.10.13.11.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:47:26 -0700 (PDT)
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
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 0/3] Enhance min heap API with non-inline functions and optimizations
Date: Mon, 14 Oct 2024 02:47:00 +0800
Message-Id: <20241013184703.659652-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add non-inline versions of the min heap API functions in lib/min_heap.c
and updates all users outside of kernel/events/core.c to use these
non-inline versions. Additionally, it micro-optimizes the efficiency of
the min heap by pre-scaling the counter, following the same approach as
in lib/sort.c. Documentation for the min heap API has also been added
to the core-api section.

Regards,
Kuan-Wei

Kuan-Wei Chiu (3):
  lib/min_heap: Introduce non-inline versions of min heap API functions
  lib min_heap: Optimize min heap by prescaling counters for better
    performance
  Documentation/core-api: Add min heap API introduction

 Documentation/core-api/index.rst    |   1 +
 Documentation/core-api/min_heap.rst | 291 ++++++++++++++++++++++++++++
 drivers/md/bcache/Kconfig           |   1 +
 drivers/md/dm-vdo/Kconfig           |   1 +
 fs/bcachefs/Kconfig                 |   1 +
 include/linux/min_heap.h            | 202 ++++++++++++-------
 kernel/events/core.c                |   6 +-
 lib/Kconfig                         |   3 +
 lib/Kconfig.debug                   |   1 +
 lib/Makefile                        |   1 +
 lib/min_heap.c                      |  70 +++++++
 11 files changed, 508 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/core-api/min_heap.rst
 create mode 100644 lib/min_heap.c

-- 
2.34.1

