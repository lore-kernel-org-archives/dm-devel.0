Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50F1AA1EE
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145690; cv=none; b=YMh8IQb10OTp3raAhOhNDfVsYveBI9VERX7KUNsiwWstx6RKOrSzTpEdo2131MvdgWzsc1UZTYhOdpKoXnD6paO7dX4TLmTgaw35niGvQEl+n9EfaOzqZwfftLqogaCtbEUcvF1vOOw6PGp+ZLDAbPIbR4T7xtBxntF1IYgdd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145690; c=relaxed/simple;
	bh=vWCCqSymVQVZJjUaDKlnAIn/GTnVLywSJ81chCvk9Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etx1Cc/SslRWSud7Jxc+LgW6nDOBy+uyWRVOxkYwy1H1XbYVtYgMirdJ7NnKYBA+nuLHa8W9YSIkq06HZeBFvOuKZMZ//KTfoR8unUrIdiY0/MBMOLjJ2iaz+718peXjEBA0IXgwCZe6BKsxgZamqQYiIjRVabGDz6gLPNQ2dIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vcm/VU0R; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vcm/VU0R"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43635796b48so16255115e9.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145687; x=1737750487; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7X1RAB9tHrujYQWSoZq/+1EvABXkN+c5dE+6ufibWnE=;
        b=Vcm/VU0RkMFA8e8DlSsdmOoGN15c4mH4StuPVjjzLkqqdtJDZx2i2BaPtiWOKrSems
         GtUlSi4bXpRE0MNUmdtxbYJUCA2a6x8QJieq98kJmwHcSP/+Wf2zScb3peyJFmckih1A
         /AZ1lq0LPgA5SWvXQtncUDjp93bvIYO8dKMpdY48W9+6IXDgKW1IN9mrkezv1yY9xmHO
         AIDc0Uq8ijflp3JrnVV64jj1emUQ9xmG873Z/+RD/DGWfKqtuCGlyXgldG/RGIyZ5KaG
         GkOMTR63+G53qNOF9bxLWtiKoc815wBsCuOJbd7quaY0jdH2oS1ITnx81ekmZbgCjuFU
         VMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145687; x=1737750487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7X1RAB9tHrujYQWSoZq/+1EvABXkN+c5dE+6ufibWnE=;
        b=TvStyhxP5cxKCEG6h/lp8cBWLgCsrxyfiI3xtPLhSlpdvK72z+13IfUjXugVPx6e0j
         5gzlJUb5qEFeTwNQKskbwTpU18euX200BWV7Oo7PbmuTtRfVnGH5HsqJrsGfR+S5B5vZ
         8XciWaCHKNz07MbFwyn1Z2zPL8eSjBpZok9VSQcbZSsxCbtm7H+Ci7fd0akd+NoG/YbS
         FVQM3AH4itIBnXX3I2YOv9UxqTbdcG1YAy+0/bOIDD0sXCDIROye+Y8aeGKR4QPgv0y3
         rMTCmsf+GmbF4Wh53V8UoMqiMyKi5ChPPYnmcFMQT/dBqqUuAhy5Yo8aq6IsGaxeSQaD
         Xp2w==
X-Gm-Message-State: AOJu0Yw2x9M5jKh1Deud5SccXmtTgAVvFZhYTm2Av5CKC04az/K801Nm
	9pnZEqS2oBLEyFrqt7cm/8ACbBFmbCunsCJXDcV0dNc0ztbQho+FBQ5sJPX4AWs=
X-Gm-Gg: ASbGncugxJD5ZvVw9ZY34Ht67EF3qP3DtPFKPLsNOKwmZZ+6hxGKEvGT1p9bH4UwWa9
	kIohZGb7l/PZY35FR7GslkGDDNy6cGnqemiANbmBYzps+r3ZgAlaBWP0Rf70lsUSsZkexwUZONa
	g/gdXJzc9aJ0Rrxus1+vLqO3KCyb4vQPVK83FYqj8dtqb0sLmnPr1caoTnKWrZFG1jlUQm+CybB
	VN2e1FPbCqpl33avSr1Jxu6tZfdpYWueXZhucszCaSjDBWSF4o+1hda4yi4syxvrTIIN/SU2qk3
	qnNpvDDiOyECjz9EeELpJAkcOzwxwapv53/G/LV6FCo=
X-Google-Smtp-Source: AGHT+IEGRda2LntKUBBZ+wbfr17D5WBxBrBgbHAtoFmAXdqM/zzmkh42I43W7B1Hva1U238MYUDDpg==
X-Received: by 2002:a05:600c:3d89:b0:438:9280:61d5 with SMTP id 5b1f17b1804b1-43892806237mr29965525e9.5.1737145686549;
        Fri, 17 Jan 2025 12:28:06 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c74ac604sm104017515e9.13.2025.01.17.12.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:05 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 12/15] multipathd: only call reload_and_sync_map() when ghost delay expires
Date: Fri, 17 Jan 2025 21:27:35 +0100
Message-ID: <20250117202738.126196-13-mwilck@suse.com>
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

While we're waiting for active paths to appear when ghost delay is
enabled, we do add new paths to multipathd's internal mpp data structure
as they are discovered (unlike missing uevent case, where we orphan
the paths instead). When the ghost_delay timer expires, it should be
sufficient to call the more light-weight reload_and_sync_map() instead
of update_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 176d9bf..4063e82 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2950,13 +2950,13 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		failback_reload = deferred_failback_tick(mpp);
 		uev_wait_reload = missing_uev_wait_tick(mpp, &uev_timed_out);
 		ghost_reload = ghost_delay_tick(mpp);
-		if (uev_wait_reload || ghost_reload) {
+		if (uev_wait_reload) {
 			if (update_map(mpp, vecs, 0)) {
 				/* multipath device deleted */
 				i--;
 				continue;
 			}
-		} else if (prio_reload || failback_reload || inconsistent)
+		} else if (prio_reload || failback_reload || ghost_reload || inconsistent)
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
-- 
2.47.1

