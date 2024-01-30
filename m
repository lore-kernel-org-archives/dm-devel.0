Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD49657C0
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605993; cv=none; b=DkWSjKHfDmGExTdNAaOF2nqqBgWPJz6KPy0Cs/1W8qGvR3LDokocjn8L7xzL8jEs4IgsLYsbHhJU46ujeSU0DVBG0+3r4ANz8x/bikUkT6RxZPeBK8wd4xbkk4upwxZLNhzfIShbl51G8VHPDrYTCou8chfnTxgkHNIwn7rKjqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605993; c=relaxed/simple;
	bh=phi5T2izEMsiOsO8bLtfMS+kNUjV4V4DeiWbRLOq9mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqHcNTEQgCyjocXxz8CAttyG+WVBrGUN9PqzcLrUizFqSgXLyJ3lOKJq+l2trHWWKj21VcIhP48Nbim2McV2Pv8WbFKHuDzkWeXNM8S58EP26zenmPMiQwAjfMrq0KSUv+dLMcZ2qn2YPOJH1Gj7Z0Ohz+EtuEON0l9ulBpnCoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8XYCXsN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8XYCXsN"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d8ef977f1eso8944965ad.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605991; x=1707210791; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IweQZX1rrzr6gibPdXDs6vE0Yntn8jSnRWjOw+ZAuiQ=;
        b=M8XYCXsN/IySZyAyLHjNY7UB6Gu1Lt4xemc4LxfMX9MkpGpqHJo/22GrD4LVhsY8n8
         KmoAxdtdetSdMIqR9aIQ3hvTJtkcslUUtB5ics5Rh7nW7tQyMZpQ3awn47OMfB5phJxV
         4qBuL6dY1uKyPvVo2GBntIL7qPLilLUiqNepFYDSpwXA3E2ZBDmpmmd1enVVPhT4dg6x
         suXiZGrf+ZSOJVSw1J82+++bZhFjWXYM3EXucReyMVcpBdnCK49MaOUoiFO9CjREZmXt
         0j/6xmAnIkhABX1/dVvCPmd6yh/L1UDt7rfVX/luuOwhn5XSyTshETYo+k0dS1V2wifK
         hfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605991; x=1707210791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IweQZX1rrzr6gibPdXDs6vE0Yntn8jSnRWjOw+ZAuiQ=;
        b=jlS2b+wPlrnwxowIEMH7vavhGFSwDkn87RTIMNZtdnutIqlJ8Kezs1HLTDG0mJ0tFI
         0T1JWB7gsypvx78S/D6cJbVHDwDv0WGiwjccOzEpg8YIXwzBHd2mud5yVKEqOMrniwMF
         daL7afQbOxJApW8id/M9aGGdx9wCjjK74m6fTXuAZ9jmG6a/NniJfncpXD6SaOUQBnw2
         i25x7HnCgrkcZ2kKJPVKjMTI21Zn0wKHlMc5hs4rZ219C/qXa8OQmJD+PKnWxg6hBpk2
         feP9A9zeRipfKRk+aWoxtF+bLYD15flhdPjme+Kq8NztaSsmGZaLeC0TeB/e1n07TTiB
         /tmA==
X-Gm-Message-State: AOJu0YxdC/AV2fe3o9aZtbsi3ag9P1nmlnd0Oz9Goqk8brzyOTNpNoMF
	Tvnls1b+SDTN0fzkSElp1Xeip9hrv/nyQrSmKaaXoyWvdGD4IOjT
X-Google-Smtp-Source: AGHT+IGYhVaGIj5DWHqtUhr2Kt2mmgKziOlN4O7Skqws3YGQXAGVxoBC24HM0zRZrGiTaUbKWwB5Eg==
X-Received: by 2002:a17:902:fc8d:b0:1d6:fa0b:4949 with SMTP id mf13-20020a170902fc8d00b001d6fa0b4949mr5439018plb.38.1706605991070;
        Tue, 30 Jan 2024 01:13:11 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902a61100b001d6f8b31ddcsm6703203plq.3.2024.01.30.01.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:10 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org,
	mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	ignat@cloudflare.com,
	damien.lemoal@wdc.com,
	bob.liu@oracle.com,
	houtao1@huawei.com,
	peterz@infradead.org,
	mingo@kernel.org,
	netdev@vger.kernel.org,
	allen.lkml@gmail.com,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 4/8] backtracetest: Convert from tasklet to BH workqueue
Date: Mon, 29 Jan 2024 23:11:51 -1000
Message-ID: <20240130091300.2968534-5-tj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>
References: <20240130091300.2968534-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only generic interface to execute asynchronously in the BH context is
tasklet; however, it's marked deprecated and has some design flaws. To
replace tasklets, BH workqueue support was recently added. A BH workqueue
behaves similarly to regular workqueues except that the queued work items
are executed in the BH context.

This patch converts backtracetest from tasklet to BH workqueue.

- Replace "irq" with "bh" in names and message to better reflect what's
  happening.

- Replace completion usage with a flush_work() call.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/backtracetest.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index 370217dd7e39..a4181234232b 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -21,24 +21,20 @@ static void backtrace_test_normal(void)
 	dump_stack();
 }
 
-static DECLARE_COMPLETION(backtrace_work);
-
-static void backtrace_test_irq_callback(unsigned long data)
+static void backtrace_test_bh_workfn(struct work_struct *work)
 {
 	dump_stack();
-	complete(&backtrace_work);
 }
 
-static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback);
+static DECLARE_WORK(backtrace_bh_work, &backtrace_test_bh_workfn);
 
-static void backtrace_test_irq(void)
+static void backtrace_test_bh(void)
 {
-	pr_info("Testing a backtrace from irq context.\n");
+	pr_info("Testing a backtrace from BH context.\n");
 	pr_info("The following trace is a kernel self test and not a bug!\n");
 
-	init_completion(&backtrace_work);
-	tasklet_schedule(&backtrace_tasklet);
-	wait_for_completion(&backtrace_work);
+	queue_work(system_bh_wq, &backtrace_bh_work);
+	flush_work(&backtrace_bh_work);
 }
 
 #ifdef CONFIG_STACKTRACE
@@ -65,7 +61,7 @@ static int backtrace_regression_test(void)
 	pr_info("====[ backtrace testing ]===========\n");
 
 	backtrace_test_normal();
-	backtrace_test_irq();
+	backtrace_test_bh();
 	backtrace_test_saved();
 
 	pr_info("====[ end of backtrace testing ]====\n");
-- 
2.43.0

