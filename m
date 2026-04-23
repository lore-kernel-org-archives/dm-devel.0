Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F85275AF5
	for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 20:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776977107; cv=none; b=dFveMjOd/MYhHC3jXFq5NLB590KR9/XmFg0oKoA7MTLigdwdyMjEW3fbF39yY8Dp7GEtFqCUzjTJzgxildnLtyXd7zcEURAruriwBeuYSBaSvtECvUfHJZ2rgoSyGz9zuQnkRfUwPZLIimIqO6kVXpzsBLGTK7gjJXkZs/17XzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776977107; c=relaxed/simple;
	bh=QR0IAtwTbzz9a9rGja/qJDRSsQSNKiD3Z+fuymvVIRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWbHBoBGiGs965m06jy66mU6ScatygR0o2jPNliNh1D46rMDySauc3/0EIZCuX3LHu9a8uom2+ZD+GHYl39PnDHuu8199m8dVr1zmixaa19kvp1WRCF7MTa0GL1GSoJQmCsLXFkHusYwfIsrQ/W9HNGQfVNCo5+4Ve8nvURm4aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QRj/R/uo; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QRj/R/uo"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43fe62837baso4322315f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 13:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776977104; x=1777581904; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4Q48EDz2T8t0xWbhOaZoteVvRDqzy6HwQLC4yrS3Dg=;
        b=QRj/R/uo87AFWkjiAykIatTfLheiIW/0qX23UUSXgnvcvkqkMOVBuB3pRQN0Mcm0RX
         M46DPjXwJRTL4Zxnzpm9DUQkgUZD2Qifigl2Cb/y2zVHaqgMJLTNZC2DTUoln6v/aD/+
         CHzaVFwYUHGF7+PzX9tUE7Fr91lrR9upkL7tigp9IglD3AkSy3/RRuko1+0KLqtRRJ+Q
         albfRP5WeVQeo9aiehcXlJXrE2l++WWRYoOa71Nnp55fvY8l7EbsZh2PlX+QQ1K4r64g
         vo/ooScXzztBA6wLrjU2ev93rPqHHCoBxk+PE/BoL45/uYoJ9cu/T7ee4TqfDae3hj+W
         3zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776977104; x=1777581904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T4Q48EDz2T8t0xWbhOaZoteVvRDqzy6HwQLC4yrS3Dg=;
        b=M1ZzYeVlQSpEwTUiRJjzLQo9CB5mHZwFnUFPT2xBF1YZyXQVS31PVU4VfTgttreQxV
         EKOXXl329xho9m4JcSmn2fmE22gV1F/1GYMT1KZ5EDnrs78OyDBtgnmkO04PCQ286ftA
         2ojD7rZtI5g61ti32GG02GhUlprfHUtevbJeVpYCnU2uuQENNErYwywu550KXxNevf3l
         0NXDV2JrBylOxpJtzr1PjTdvgn5e3HpFbNgFR7JPzfnNzM7kFvFn9HUlSaeWC38g/5zS
         xcQuUbjYif4ptGfbqQpb+iGjDYXfYDSAWrHlXIWoYa+zD6OX/QFnNZADgLIlphgupASc
         9pjw==
X-Forwarded-Encrypted: i=1; AFNElJ8NDrN7+oxy3aUYgNxWH28hWw3bA7iFfNNxjFCVp2BXEXF+2OOJ4KqhcWYVUjOVdwoK1JimH8BJOQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwV5LRU/TC9K+6PuTui+Ov6hsDumBcR5lHaYW3Q7WQ8tL1Rti3e
	FnAjnkpAG0+YWivtcx4K+rpfODnHHU909ay62JKB8L+9p9MlJfMPKdcnh0BS5l68ZDE=
X-Gm-Gg: AeBDieviN5dkwBpJF4xRUE/BCYaKFiETiGduZMebFcgcKxMfxfH0fu/i+soZpNrEq8Y
	RkUzVyG+2C0CTq9O/XHkKpzitFoCMlGknKyfmyZlHMcDEaJspioLOXN432hYa/JrzVjZDFcXdvT
	l24sGByYkO+bYWXNrRxqpxyrVRNX0nphPaGsmUIVcR0NZFqP0E5xpQtA4M2udkwZYtPKZJe5qqt
	Z66vljM6HuFLnrrw1IsKyCxEnLxM+PxnER/dqp8RVI39Q7pxax3W7JYfOuWWQnNDyFdBZDZ+KQ0
	l2uYdPCnRTfAWcp7ekzknRVBAKpRrHCUOdW3GT1NC+uhG6j0/9jqcxGFg9fknojVlZF44ebi+7C
	TriwoXr1eq27IrPYDeWe1du8AGFJei5RffAPeLW3eet4ZdR4l3m+z8Z71ZmUHFjYkL9lntfJ+DJ
	ol7d9J5oxt3MHw4dzFu6lk1cC3iE0sXGDYb7Q/Gkmlkyy/VtgW25uRRzPi2mgBHy8uV72G7mUsW
	JrXQh6UdM+GauAfQo4BnREN
X-Received: by 2002:a05:6000:288c:b0:43e:a69b:d804 with SMTP id ffacd0b85a97d-43fe3df26b1mr45165295f8f.29.1776977104167;
        Thu, 23 Apr 2026 13:45:04 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4412e36ff8bsm6882788f8f.26.2026.04.23.13.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 13:45:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/5] multipathd: get_new_state: map PATH_TIMEOUT to PATH_DOWN
Date: Thu, 23 Apr 2026 22:44:42 +0200
Message-ID: <20260423204446.472642-2-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423204446.472642-1-mwilck@suse.com>
References: <20260423204446.472642-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We map PATH_TIMEOUT to PATH_DOWN in pathinfo(), but not in get_new_state().
Do it there, too, to treat the states consistently.
This avoids logging "checker timed out" twice in update_path_state(), even
if log_checker_err is set to "once".

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d87c7b1..9bce4d6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2503,8 +2503,10 @@ get_new_state(struct path *pp)
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
 	 * without sending uevents.
+	 * Also, map PATH_TIMEOUT to PATH_DOWN here, like we do in
+	 * pathinfo().
 	 */
-	if (newstate == PATH_REMOVED)
+	if (newstate == PATH_REMOVED || newstate == PATH_TIMEOUT)
 		newstate = PATH_DOWN;
 
 	/*
-- 
2.53.0

