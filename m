Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC333B9927
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468304; cv=none; b=Kg/xpW1xsfLm2584P4gy7bCBN6RibmGEf8yDkPQ07Y9af3T5+tiV5XvGm+UzL/PX91mYrIsAvzCV22aY9MvNU6DkqlZcXoD+5VEDF6RW+LgqLsHTHCk8m4JH8VhOJZcxMWbzaFf66Zcz9PtBkmqTF1AoxYxBfzL6p74uftO0aWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468304; c=relaxed/simple;
	bh=buA3tlCAkiRzJqqWHhFXYXvzZUfpumJ563hhjoW5FB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qfk3xbnyw8RhKveUlzh1kTZWUHCT2msbPrArqtYS3V/Hg3xGKY0NZt4IUr9qjU6t9eALffF73EJHRoCq3189ZJDiJ11n5Zmcp9+SSpbt/HKDuAve3Bz98ndUUm91kEQfBqnd54sYqZyTbOwpIAj+YtkZ5RDuuRrEU2RPLw5n038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aiwDrrdQ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aiwDrrdQ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48d146705b4so80874485e9.3
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468302; x=1780073102; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJOZOAQiI+SkuPkRgxKGnlS7bF/MABYzBAY8TGxl+3M=;
        b=aiwDrrdQFh8urXhXBcJmKS1kiPxT5Zr3maBQll32CMZ8HzHGaYqcBlm0KBdiBb7Gwc
         jI0W66lxTKjX40O/w5Xc4luOZfuuyj+vmR5AHKUGzjrk9VWY8LLjnoQl4Uy/u44jaRgV
         IvLCex6ririyNo3juPPrliEO9kZbCxHETiuEtj72nqlo0UKABxTfu4RqtoKIslq47+AW
         OycZXyXAk0Xm6L7rHkq56NYf304RqylEgE2EIO5zD/e+imIYpG4bbW+d4e5bqO6qJbBK
         7wM27ZqvnDH0DVTXjO0hsB98/XQyLR6UerUaf1lfL3NwB9iBGccpB2mDh2X36dBX1dpM
         sQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468302; x=1780073102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJOZOAQiI+SkuPkRgxKGnlS7bF/MABYzBAY8TGxl+3M=;
        b=fOMUjXG+GoAhjE/ryIxbJWER5yhYz3wFiNVAqxtt1F4La5wQFGPW15qWdFYsR7ZV1S
         grCkAsvQ4jxIW4CQe3ySrX3nFBNWZqVpgNQBjT61sJCf1/2E1a6EtAbkXtYhl2XkZdMP
         AN7yn+sk7MndHoS6BwTBEFKIDJ5fncp1shJoS0u/fhw8tQeJNS9ooLX/fCLIk7JDM7D6
         JhVIHoDJupzwcAR1UC9/cyB2u3ukeNzfOo/1saTh0YHH/udwMZe4XglkyYdwzUDhAMmU
         jLFPv34oqGXi9EfP22VkJwJEc42l91hlkRrud0mxVQLgNJbM41coet46z5K8rLJhtrLh
         MPhw==
X-Forwarded-Encrypted: i=1; AFNElJ94sA+oBTHFUk6GqTJNGfcQwoYA9J3jpqEDqksKRneHXDnvaE5G+QYuBwPkf45Fv4qt91DCFX9glw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyiSPqiAnx8njYJ8xALZfSFtlmhyiROwqFVENRZs7A0qqihc+MN
	c/MlMq1BrL8fatFrY5pMnsLhXa4doUpx5BAQwpHpcXSTsQoFFZOn05wiwoJSHPqYYaAll4youEO
	6LNmUDzM=
X-Gm-Gg: Acq92OEcJwAsRG1pq88BOp44Ax7E/L9DTX3G0FASz5+M78/9ZPd7hK5ahmPlrisR7mT
	bqK5aNrj1gsemhJ/2t6Ju3WSLosgf3x57PUiRqcNKt8gzwFX/cIEJsOdV72C/jjLtrqevvFOEoV
	7NTu5Zis1J8UmT05/3ULnpNnLayYnuXK8HfdqlAxiRkm7l2uv5s5oqRurfSB9eQOjCYhUpFK7RV
	BT/ZiVZ7v+c5JhUVB1Q1ui85uRPOH2S6eDly9t6HncLr9Jw/I9Wmu1aRQROIsbE0XBl/NjYmiO9
	jm96lqISRKDh/EXcUhxOQi+LhBFo4OasFDzBbHsqg8hHcMIpgKL/QeZgxUAaRYf8VtHVpZlesxB
	xt/63glNcMJhmtJ8x18vCo2zU9TfLaSzuEnmYgfmsSL7n/5XTQMctbW0AqKxXm5BdxW7zK8Io4W
	sSfDcZR86ZCvssmQBCD7FxYpvv54LQgfPZ1QcVnapSJKl7vGuH0glG2TuzpNycaTXRTzRflpzph
	lGjftzDAbRPFA==
X-Received: by 2002:a05:600c:a402:b0:488:9bf8:7f17 with SMTP id 5b1f17b1804b1-490425ad10cmr53163875e9.14.1779468301567;
        Fri, 22 May 2026 09:45:01 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490424974a8sm30443885e9.4.2026.05.22.09.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:45:00 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/19] libmultipath: async_checker: add context_size and init symbols
Date: Fri, 22 May 2026 18:44:12 +0200
Message-ID: <20260522164415.846589-17-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two symbols that can be read from checker .so files with dlsym():
"libcheck_async_context_size" for defining the size of a checker-private
context, and "libcheck_async_init" for initializing this context.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/async_checker.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/libmultipath/async_checker.c b/libmultipath/async_checker.c
index 02fe765..7a7bfc1 100644
--- a/libmultipath/async_checker.c
+++ b/libmultipath/async_checker.c
@@ -6,35 +6,62 @@
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
+	p_ctx_size = dlsym(c->cls->handle, "libcheck_async_context_size");
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
+	acc->async_init = (int (*)(struct runner_data *))
+		dlsym(c->cls->handle, "libcheck_async_init");
+	errstr = dlerror();
+
 	acc->rdata.state = PATH_UNCHECKED;
 	acc->rdata.fd = -1;
 	if (fstat(c->fd, &sb) == 0)
 		acc->rdata.devt = sb.st_rdev;
 	c->context = acc;
+	if (acc->async_init)
+		return acc->async_init(&acc->rdata);
 	return 0;
 }
 
-- 
2.54.0

