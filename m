Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F001C60885
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605990; cv=none; b=ZUoOxRb9AR9oCQDP5m8vNJotFJLMxK6fAYDRRcK+Vmi2I37K/BioTnvKNhNkDLFiDjkqiQHSUlUvK/740yFeuz59J9x+h7+7xrIHaQ4zG3K9AfUxuUCcDghBSj4k5ezM8R1H+rmZd6mwx6thbSSdYpYnXJfEbF/E1ZF8PtmNOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605990; c=relaxed/simple;
	bh=bRdnyNKa81dUnoj0MB6Zg9a2NEYVmN96xNxLaxLYnG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfPUMhP0wB4omolydO3Nd2MF021CwvaMOXijhe11qVzNuZQW2On+15DjJeLxvOzqE25MGN3qNkzNJlDk97ma2Kd2jcGmsTXPeheVFHPOcAOO6S/njcQgYnv/CGqnEAYPq8GBg5omaJDdnSv01VzAsec2GSwh5obYyx9Kel7Y090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VApt6EE9; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VApt6EE9"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3be90c51299so323350b6e.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605988; x=1707210788; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xblJk8GY6hKfGdpNUu6EAuoAaIEFTkAgpkYfucVU564=;
        b=VApt6EE9UhjjKNYTTa2Xmo5FoI6klkWNOMnP39VX/WILatE4Hii2e/TsG7+xmd7Ore
         50BX5nIAwZFbRY2pN1TZsSBTs4EryQMw4SVZtn8eUKSpagTxWcLkZmYt5xPPR6c0QYh3
         cL3F7Ov5Nw6PmuHh0C/eD348cKy7Fu7AFONrDkqr4WtCOjiYx37CLJ6v/BxeTiwD95gc
         wiYerERZD56bxmLjklSxCRSYCAPsypdTohdFy4AMefZRHEvy7IYsVT45mZExIjdGKN7w
         ZX7rn79HMGyHYLIiihZ4V440r+NYTaf2gq/X7zJpoNxxH8r14i5Y+sF2y4jXEncOjiHF
         7JYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605988; x=1707210788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xblJk8GY6hKfGdpNUu6EAuoAaIEFTkAgpkYfucVU564=;
        b=GnRza/GgtQNDxD/0QaTO1CG5TYIxFwAnKKaWbUA8wT/NzuJxFNUZm5J+CAaUN7NT63
         Cd+zrR833IMSF0MqwqGd5fwNeB+w2UU5LxrKC0Z8RVCOz2Kj+SDs0VvM3Grwjzu9EXRO
         HYdTVWjnNyE/aY5OU5bwc48LgvoXC2Ruo7o0q2d38Vu7BXbNLlftci9KEXsISfwUB2XR
         j/mFgP8j4p/EzMTJ6D6OPVxhp8A75J565QeRGobdptDJXCvTkogzTRnurHepVgdYwyrJ
         Xidq7CXsScOGyXVID+B2dEGEUpKm86W30YVJ+dgKWXABdo5rrZ3CDWb9rZYd52M90vRi
         +uUw==
X-Gm-Message-State: AOJu0Yz4uH14quJmHRZVFJKxOoCU7sPkKMn9VEw0lMTekLESAq+dumf8
	aJ9LvxA33KL5Hv1Pomqa0BCkJPe/o4rRz+k2VaQEEFf7EKmrfSLu
X-Google-Smtp-Source: AGHT+IF74Pvxoh28vY90uV/ZCd6iFVdXKTZ6HNiXo3qs/SUNVF0CwPkYPi5FBG9VCztGQlre04bl1g==
X-Received: by 2002:a05:6808:23ca:b0:3be:453d:e061 with SMTP id bq10-20020a05680823ca00b003be453de061mr6090110oib.6.1706605987791;
        Tue, 30 Jan 2024 01:13:07 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id s184-20020a632cc1000000b005cd835182c5sm6780257pgs.79.2024.01.30.01.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:07 -0800 (PST)
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
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] workqueue: Factor out init_cpu_worker_pool()
Date: Mon, 29 Jan 2024 23:11:49 -1000
Message-ID: <20240130091300.2968534-3-tj@kernel.org>
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

Factor out init_cpu_worker_pool() from workqueue_init_early(). This is pure
reorganization in preparation of BH workqueue support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3f2081bd05a4..f93554e479c4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7135,6 +7135,22 @@ static void __init restrict_unbound_cpumask(const char *name, const struct cpuma
 	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, mask);
 }
 
+static void __init init_cpu_worker_pool(struct worker_pool *pool, int cpu, int nice)
+{
+	BUG_ON(init_worker_pool(pool));
+	pool->cpu = cpu;
+	cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
+	cpumask_copy(pool->attrs->__pod_cpumask, cpumask_of(cpu));
+	pool->attrs->nice = nice;
+	pool->attrs->affn_strict = true;
+	pool->node = cpu_to_node(cpu);
+
+	/* alloc pool ID */
+	mutex_lock(&wq_pool_mutex);
+	BUG_ON(worker_pool_assign_id(pool));
+	mutex_unlock(&wq_pool_mutex);
+}
+
 /**
  * workqueue_init_early - early init for workqueue subsystem
  *
@@ -7195,20 +7211,8 @@ void __init workqueue_init_early(void)
 		struct worker_pool *pool;
 
 		i = 0;
-		for_each_cpu_worker_pool(pool, cpu) {
-			BUG_ON(init_worker_pool(pool));
-			pool->cpu = cpu;
-			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
-			cpumask_copy(pool->attrs->__pod_cpumask, cpumask_of(cpu));
-			pool->attrs->nice = std_nice[i++];
-			pool->attrs->affn_strict = true;
-			pool->node = cpu_to_node(cpu);
-
-			/* alloc pool ID */
-			mutex_lock(&wq_pool_mutex);
-			BUG_ON(worker_pool_assign_id(pool));
-			mutex_unlock(&wq_pool_mutex);
-		}
+		for_each_cpu_worker_pool(pool, cpu)
+			init_cpu_worker_pool(pool, cpu, std_nice[i++]);
 	}
 
 	/* create default unbound and ordered wq attrs */
-- 
2.43.0

