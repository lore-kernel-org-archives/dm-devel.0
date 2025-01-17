Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A7F1AA1EC
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145678; cv=none; b=LAMBtqcihTKUu/Ucfl7f3rSO2HBWnGSmR+elopJ2w/5zUNMOvd6/xwvJ3dDMh4u7KcWtKbPwW/nqezTTr3MHZdkLRu/pPXn5KKwii2fraBZPu6LOzAIG9qKqDSz0TuvOB1e3Nw/f6QEWwKV+FAOEP4M0u7MFViRI1Vk9+GVC7g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145678; c=relaxed/simple;
	bh=+zTaLe2bFCzQIAa1A0FI90UlKpQIZD0lCAuUmCPuTJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDORReJXiF9KeQL9DABYkhy6TvzpulOF8XnGgXpvbmzuDT1u8KDdv+xcaP2+uzfTfRZEUCpDD7KnkadouViNds3aP1qlasp9KHxaUH8JGUq4NDf+nCSjgawiXOe90lgZxTJHTmNDAnnRM4UxmwLSlTfAogfIv6bVij2t6S84GC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WkZOqpSr; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WkZOqpSr"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361f796586so26842625e9.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145674; x=1737750474; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmsdbMUdXouyCIUvFDb9rT9Wa7Cn3qSpvlZNyHArD78=;
        b=WkZOqpSrGuBjGXsA6b8M6ubZ5mnwQy2HepPtBkI42eOrCL02GjqS+rrfP32bnR3RkE
         awgz8hPxpyq+4j/c6x2okGuz1SBPWjhFHvTI7if9m8VUxC48cvAuRmWaoFh3V98Pm9yk
         9PO3/aKg8BQr3LlqI8TujrIujcAknGfp5/x/6hdDnNsK5yLonqlk/IjBT1jsd4F6wK4w
         8kq2+BsBCSVupquvyBevrxgackbjDo5PNrwWy6jhF0AsHv40LnNw9LWVUWPeXIuzb0gv
         n2v29MlLKwTZT8XozCT6A9sAP5kvGoQrmjWsEYEm/jkKFaQusmOqwIonZKGKsQnfMZ1d
         xESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145674; x=1737750474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bmsdbMUdXouyCIUvFDb9rT9Wa7Cn3qSpvlZNyHArD78=;
        b=lLgr80eoIuiTQCPj++/GLmxRIO0xyytdG1iwjHweaKyRQ4p74DxQCxAVOpmlYUbpr9
         hO+hajzJ9l+0JSxQI52m8ddOiVHQSW1gdslNM3CM56RrA3w0+H995D+NY9g6qMlOMZM0
         H6Y6o14BvWzFB5Gp6RjE101iFqHot9NrgQmIRidQPO3yoN2jjT46IW2q72moK5hpsG9k
         1uPIRSrpi9heNDSx13XtdoyEJngKWVLe3BYTJctPMPQma32o/8Yzp2l2JdL4ph2NnQQv
         uy8U3ARKmUboLpOxlkg73+Q2RIWoOlH6CsP/MT77HaEjAmKci2V6iXi33KczpD9KmYhB
         gkhg==
X-Gm-Message-State: AOJu0Yx3yiBu7FyAA9PvzlTepNCYD9/TgGJjEtgf0lXv77/4flnOgBSn
	HZmmVcwj4lVPlr96eYytTwA4iSqxOSK7xKj0Cfj1mKfxSWFJ+th+BL2VhJ2QmBrAR+RywaRKqeg
	C
X-Gm-Gg: ASbGnctw+bKggGAS58GxN8YfT4Jpu814Hoyxme+kN43zl/8fP06n0bPaACQKW9b4MMs
	5zlCQOxVCBaNbnhZ5otjNue4Nfy2bbWyYQUmAT0JX3jkOMCOfYb89ptvvkPdcS+3DIHwNnYbg7R
	hCGyrw0ZI0cUxSm5cgYsbA7zrnvRz0e9cq4gYb8s/oQysqM7tJ1p6GOgO+K973ojIvyRhDH5F2q
	vcPIfW2aPxTDzwITNMQZJFwQmDXmo9tmnyP38FivUCBVar/cxZViRpwFwzdZlhk8roN6iwtgjCq
	SvLngWI9paCmfBfQGeNT7r9BMM+RTGAD5L6NLmUnqBE=
X-Google-Smtp-Source: AGHT+IHlGm64DYoPx0sySMqMkF1D1e1fw10DdJrs77iOW79NsRyIKqpzhLEfETixTYR6s/gkKJ1iSw==
X-Received: by 2002:a05:600c:4ed4:b0:434:f586:7520 with SMTP id 5b1f17b1804b1-438913c5d53mr42709405e9.6.1737145674315;
        Fri, 17 Jan 2025 12:27:54 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c752910esm106956115e9.28.2025.01.17.12.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:54 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 04/15] multipathd: emit a warning if a map remains inconsistent after reload
Date: Fri, 17 Jan 2025 21:27:27 +0100
Message-ID: <20250117202738.126196-5-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250117202738.126196-1-mwilck@suse.com>
References: <20250117202738.126196-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After reading the kernel device-mapper table, update_pathvec_from_dm()
sets the mpp->need_reload flag if an inconsistent state was found (often a
path with wrong WWID). We expect reload_and_sync_map() to fix this situation.
If this is not the case (need_reload still set after map reloading), it's
most probably a bug.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e4e6bf7..ff3031e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3026,13 +3026,20 @@ checkerloop (void *ap)
 							     start_time.tv_sec);
 			if (checker_state == CHECKER_FINISHED) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
+					bool inconsistent;
+
 					sync_mpp(vecs, mpp, ticks);
-					if ((update_mpp_prio(mpp) || mpp->need_reload) &&
+					inconsistent = mpp->need_reload;
+					if ((update_mpp_prio(mpp) || inconsistent) &&
 					    reload_and_sync_map(mpp, vecs) == 2) {
 						/* multipath device deleted */
 						i--;
 						continue;
 					}
+					/* need_reload was cleared in dm_addmap and then set again */
+					if (inconsistent && mpp->need_reload)
+						condlog(1, "BUG: %s; map remained in inconsistent state after reload",
+							mpp->alias);
 				}
 			}
 			lock_cleanup_pop(vecs->lock);
-- 
2.47.1

