Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BDC213E8A
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528218; cv=none; b=ITMLgyf0XqTRssFFX67ykU7rrDe4IEjUMYvrcPoX4n9V2V+FpfQdSgXwakBCU86FcQzWFcDzaxk/5sb/kxAAIpfrxUDPRS6bBchnsDKAwxxqaEhQQM9G7esrITvuz6r1p925p1a/KWsEee2cEpwMQg1rM8kC5o1btEolBnIIak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528218; c=relaxed/simple;
	bh=l6SC/jpGQaefnzqXbcgUuZAJpoows7qZvlwO/1AzCaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4/EUWaFkHGdiFS08AVXP6Wicer9eE4+fLQVB8QOouE3ybE+3UBxZAvosVSbi5UjzcoJapcF74i3HwBDYxh9FhcJjG6hAuU+JDy93aksbZRh6+g+5nc5VtMf/oC0LM8wILmsKehdh7rXErzrZ2A1sqLrXvAQE/J8Ld2Zlnjwbmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eZ7u2v8k; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eZ7u2v8k"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d10f713ef0so6657980a12.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528215; x=1734133015; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+d+XUK832XvlbtJeH+2ZHBRzFYINiQsf7HIrK0yqbA=;
        b=eZ7u2v8kmTL/nwPgAfD/gwS8a2Wv/pHNWlhDBm7JjO4Za1GCL9P+rhDr5ASI7atjPd
         LMYe65obPFpxWOJOodWurN4EVZMlUJVMx0DiC2K3xLtaWFIgq57l8Ux6lg/YlZXnMa9h
         iCfUuCreJafan1huUfdUrMwzMB2n2pQbTQYhLxmL8DtiwABtWb9AW9+gXi4lmTwtO6JJ
         +gcc6h4cbi2DU+OZfVUmpPQfuHdLcVZjM7KUaqve3OTQwfg9usb9GYQESPK3JShiD7iG
         hQnWDFPf+10RGsRElmPmjMz4rAu6FSS1HzjF/6+CKWxRFnYaSLLBa1eQtUqjVZoqG6fS
         Z2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528215; x=1734133015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+d+XUK832XvlbtJeH+2ZHBRzFYINiQsf7HIrK0yqbA=;
        b=DeBnPZci2erMNLAfkGgK88xUSSAW5sUCZLmHXPrMmkyDM6qEHLZ13rPV1l5K4MM66s
         uASQ6YVfqU7JsqsV5Pqgm+XnMqlFO7WXkZdVpRhcF2UhO5bsdOna7YJ3scbTTZQCw9b5
         0sbAIVoS9Di8Pu32LgY5UMgAFBnQq0ZHL+cdeG1sMUQws4q3WzpLb4ffEIyuYs+ZKt+9
         0sEl9kr8n/8pnOQr8nxpRb7BVn7ahAPq/CcLWxBSNdE8hTOIqoPz2L1cCb0GZtgEnzTB
         riHURQxNeZpDfChR9YtS+9PQUJZ9uiEThUVmRW/AXjBjASzC6m0TfSutMtKXcrplO7iz
         f4nQ==
X-Gm-Message-State: AOJu0Yze4+8GHKkTSrHtu8CVuKyLwhb6kRqg8yhr3IjQxm1VaMS+h7l3
	g+0K2yte7e+bgGM2cemj8k2GfzyEmwqZxSUMm/Dmw1nVt39xzmbfwO+2tTk2shB/5seTJxgdOK5
	K
X-Gm-Gg: ASbGncsn8jDtLaPu0/MsNH/Xy0WIQdmcz51qblKbR6d0pAgW6xsFcuL7tqEDHcR2gVL
	nIxuHIDijzx5ytzxOXOD0aQqIdNbq+7UlPdmZ+7WZNWC5TJDpW3sIt4PFSBg+aH26Bo8KDvJW5Z
	rv1fqPsssbxpP5tzC7hjG7YVjQ1uw5AOqoW0leE2YWpqwa7bG2uRjrEurt5SH1E4z/H9xt9gJoa
	c7RpMbAfBNCRljQRlW70IpCySgu0N3yFYaCy4Fm8buF2bmFWeTQ5NjLNkULOxZ1abvrhNtYKr9L
	+b6mlmehi+qA30gs6A6HZk+f+KqRO7nPRDAh
X-Google-Smtp-Source: AGHT+IGlXAswTLo7zT5zN3vW7Oem6p4lpLTr2qH9kyRUpnPaTKEfsd/bZoT9W8Hg+QnybOiUPN6KbQ==
X-Received: by 2002:a17:906:8a4a:b0:aa6:19c9:ad0a with SMTP id a640c23a62f3a-aa637626ac8mr476283366b.29.1733528214827;
        Fri, 06 Dec 2024 15:36:54 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa625e4db4csm302704766b.34.2024.12.06.15.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:54 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/13] multipathd: move retry_count_tick() into existing mpvec loop
Date: Sat,  7 Dec 2024 00:36:14 +0100
Message-ID: <20241206233617.382200-11-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8425354..4cf5493 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2075,21 +2075,17 @@ static bool deferred_failback_tick(struct multipath *mpp)
 }
 
 static void
-retry_count_tick(vector mpvec)
+retry_count_tick(struct multipath *mpp)
 {
-	struct multipath *mpp;
-	unsigned int i;
+	if (mpp->retry_tick <= 0)
+		return;
 
-	vector_foreach_slot (mpvec, mpp, i) {
-		if (mpp->retry_tick > 0) {
-			mpp->stat_total_queueing_time++;
-			condlog(4, "%s: Retrying.. No active path", mpp->alias);
-			if(--mpp->retry_tick == 0) {
-				mpp->stat_map_failures++;
-				dm_queue_if_no_path(mpp, 0);
-				condlog(2, "%s: Disable queueing", mpp->alias);
-			}
-		}
+	mpp->stat_total_queueing_time++;
+	condlog(4, "%s: Retrying.. No active path", mpp->alias);
+	if(--mpp->retry_tick == 0) {
+		mpp->stat_map_failures++;
+		dm_queue_if_no_path(mpp, 0);
+		condlog(2, "%s: Disable queueing", mpp->alias);
 	}
 }
 
@@ -2960,8 +2956,9 @@ static void checker_finished(struct vectors *vecs)
 		    reload_and_sync_map(mpp, vecs) == 2)
 			/* multipath device deleted */
 			i--;
+		else
+			retry_count_tick(mpp);
 	}
-	retry_count_tick(vecs->mpvec);
 	missing_uev_wait_tick(vecs);
 	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
-- 
2.47.0

