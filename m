Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02925363C50
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995848; cv=none; b=us4D/Fsukj7ib+j2x+Hbou+Y7eXVqeNNtEa06hUUjz0+Sc0qcsS79cLVNwvjqgix8qsK4R4ae6nV63do2aeQK7STe3es5JcxB1LFWfxxR27Fx0P6o17t89C3wO1BWXd2An3QBk9r8VXfwVQGDkYd38hniID1Jxcb/t5MedvyLFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995848; c=relaxed/simple;
	bh=bm8MegvtKBtQrllYm4eyIH1N858bSX99YaLAntytSLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqNJVdJE8JF5007+4Q9AxBnxPiWe8Sl7tK4TW8kXYOQB4pdcThkpIgU3jAYr1l512oDusRRiuPe6RCVoVl1UOEozI5R2UlJlVMz5EF8t4OxTXr/YXzeipNQh6Zlhu+vNi27MnOQ57d1K7Q0qwA7540uX3Pc7RW2KRf2D8Chklxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HYQe2rkn; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HYQe2rkn"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso57268365e9.3
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995845; x=1778600645; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgZAnWY76QzxafX7OFqjmcuO7MYsiwWfzi6HzdbAd/0=;
        b=HYQe2rkn5CwCvFUTP8DrRQs0Ju7vCl1MV3H5yqDoQLRvam1Y+qk0AdubckjY3d0gyB
         YCpz+BhDxOE2OAerg/wfcbYFwL9EfEEXGee1O4MTb1vpU3TQhJaLOVlZwvyD0wdUKLfm
         4K3aanfuXM8fpIOQrwP6uKJBsjdqs+MuQUrU2Ss5nFu9p9gqm8WGXI7RDc6b+P5/6IJP
         1tFgReezm7x4OgyO97+2FDQNBvN3C/fJcAcMPm10detYmfJAmRY0vbq8Iue9iK0zNdBo
         TDPlB1ajwcsFIYNKOIUXYdZ/nHpJ5mGyaQGXIJAGChaE1Zk6j3D+3a7EfEzyzt8dYygT
         4/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995845; x=1778600645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CgZAnWY76QzxafX7OFqjmcuO7MYsiwWfzi6HzdbAd/0=;
        b=eIYizC+ar9utjAUhn1Gxp3e1zqCqaA/2SwRnUIJ8B3eKzOxvIVKXdvGND/ks40IFIU
         BQKhJbM1QW9m53YzyVa23vkyM9Ar3DgJw26VH6IfZuCjUctQu5NAfy01CBKfJYlBncwB
         v3l8YxCtxhjm8wA09BLR60odlVr0MvK0CNzmyBDw+hiTq1ClwhuSwE1HQ9Em+T6F/8z6
         j72uwce4dqVXeUm487DTf/CuzyzD7WgS2OaFKhNaEwgP2W2xNVQhA/7+e/ukdqphFl9q
         YdBmk4lpg5+Yis/RcMWwevLzGIWwnxmm1TmfgrWy4h/N1ivrxkdnlIWkqSwi6RNJ40HK
         vw0Q==
X-Forwarded-Encrypted: i=1; AFNElJ9F07TQ97X8T8ljLtanYM/tzQ9czkOQSwehoWxBdMj61qUOTwbJtnCA2T74rf+jKSIYia3j7V1iwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxdh9hkEfX2OIr6E5oTZabsrMcDVSyWWTnBbBPE70n+/rCAduP6
	0103ub0S6lNgIiSudFblOsNFrCbqLvNntzMzePWngUC9Y+/+0A6lPvsQuYNu26IC/Tg=
X-Gm-Gg: AeBDietlu5Vt4KuhztzYq6P0JaGCQneiHcRvX5NBOC+HfL+EjYGYbFbM6HCA0LE7CQn
	2JX3Q7COKZKkRs1vLBuQc3luFsEu0uqXbM0uQuU2/01LRv3u91dNpc/hOlMPQtqQjHCb5iHuD71
	iSQCHIgfV/Wjh/3VqjdOFlxt6+eO3S8fz4OJDjTWvzoqipHNFjUIubceSovjQSOGJ88C31am4jX
	WmVlRQCmxbL8+gGiiHKVSIZkGMFxBtC2QQ6wBs9Anf9sv2188yeUYrTGOEmMuFFWYADMua0KXpz
	6pbPGY9lEDfQsdI6X9MR9Yk9iRtCd4W093OYZOWYkheqePbs2WJ98TAMl4sL3hg0V7VNeDZqI/E
	OTgeS4jaCCINIJDAYsePMbnFw9bSrvt9+twgGd+bGxUwY49TqZF6Em44jihgKxtdP7KNlDYIQuO
	UErT+i2djU9nI0IJWr/Q0rkmh/Gqu2/qUvXF13fOsjlS0N6Rrqwb8LA0LKjHtnuCpCkkE8v4eQb
	vKVCrOFXRVhxBVpEG+R9bEvvjy2/oWl058=
X-Received: by 2002:a05:600c:a305:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-48e51a2cfd4mr279095e9.0.1777995845258;
        Tue, 05 May 2026 08:44:05 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48af0d5a613sm155409145e9.2.2026.05.05.08.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 16/18] libmultipath: async_checker: add context_size and init symbols
Date: Tue,  5 May 2026 17:43:30 +0200
Message-ID: <20260505154332.448054-17-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two symbols that can be read from checker .so files with dlsym():
"async_context_size" for defining the size of a checker-private context,
and "async_init" for initializing this context.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/async_checker.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/libmultipath/async_checker.c b/libmultipath/async_checker.c
index 06159dd..52e24f2 100644
--- a/libmultipath/async_checker.c
+++ b/libmultipath/async_checker.c
@@ -6,37 +6,64 @@
 #include <sys/stat.h>
 #include <stdlib.h>
 #include <stdbool.h>
+#include <dlfcn.h>
 #include "async_checker.h"
 #include "checkers.h"
 #include "debug.h"
 #include "runner.h"
 
 #define MAX_NR_TIMEOUTS 1
+typedef int (*async_init_func)(struct runner_data *);
 
 struct async_checker_context {
 	struct checker_context chkr;
 	int last_runner_state;
 	unsigned int nr_timeouts;
 	struct runner_context *rtx;
+	async_init_func async_init;
+	int async_context_size;
 	struct runner_data rdata;
 };
 
-#define rdata_size(acc) (sizeof(acc->rdata))
+#define rdata_size(acc) (sizeof(acc->rdata) + acc->async_context_size)
 
 int async_check_init(struct checker *c)
 {
 	struct async_checker_context *acc;
 	struct stat sb;
+	const int *p_ctx_size;
+	int ctx_size;
+	char *errstr __attribute__((unused));
 
-	acc = calloc(1, sizeof(*acc));
+	p_ctx_size = dlsym(c->cls->handle, "async_context_size");
+	errstr = dlerror();
+	if (p_ctx_size)
+		ctx_size = *p_ctx_size;
+	else
+		ctx_size = 0;
+
+	if (ctx_size < 0 || ctx_size > CHECKER_MAX_CONTEXT_SIZE) {
+		condlog(0, "%s: invalid context size %d", __func__, ctx_size);
+		return -1;
+	}
+	condlog(3, "%s: extra context size: %d", __func__, ctx_size);
+	acc = calloc(1, sizeof(*acc) + ctx_size);
 	if (!acc)
 		return -1;
+
+	acc->async_context_size = ctx_size;
+	acc->async_init =
+		(int (*)(struct runner_data *))dlsym(c->cls->handle, "async_init");
+	errstr = dlerror();
+
 	acc->rdata.state = PATH_UNCHECKED;
 	acc->rdata.fd = -1;
 	if (fstat(c->fd, &sb) == 0)
 		acc->rdata.devt = sb.st_rdev;
 	acc->chkr.cls = c->cls;
 	c->context = acc;
+	if (acc->async_init)
+		return acc->async_init(&acc->rdata);
 	return 0;
 }
 
-- 
2.54.0

