Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F5D1A9B35
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145674; cv=none; b=jQ3w3iXkUqEzJOxrjOnW5kyJDCTUFEmozW5PzZ+qsTgJ4lwTI94HoO+7duMoDf+lf5lUyEezkF5DryFatumH34kLwNkUtve841slvQdMSu4aK1C2aRzm2Y5dc272AFZRZcrQFN/aBJT0FtQd2r0zvrjJ0A16bwcZ6B8oHwkM/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145674; c=relaxed/simple;
	bh=mx9FCNoo0d/uPokublpadfRFC2BTsVSJkkff2e1vtyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJJA1vFinCqX+MF46nk8x/L8hmm8ZWC+VTtpB7P1ivTKb44l05WU4480O1hHNJ4Ciej8f2c7YebWvLnc9nso+9LCGM5AZfzb2FkHsjQqt22QCWgeJ5qKpyswehSHKtocR4r5tYMWDZONRfO4u3sbGJlSCZhiY5U3fWjL7qhxj0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BgLauj4X; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BgLauj4X"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385eed29d17so1417869f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145670; x=1737750470; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJ0ZegHoOh0cxTfqSdDN2GCuoOF3B9WnLGcL5GyVqeM=;
        b=BgLauj4X9tqQD4rIQwUOdS9+D8Au0eMrV59dH/AmxuKvT5Srh2qPN33U/8Swng3pUR
         tRtSlVayVtXAGeeJTDduTtEpV2tbkctNxJwx+QOwq3F+FTefqKwHbkHGmFLKhywsQR9g
         0brzJRgj55gKcK+5z9kpMMw2n0qR3crEbI0EobFifLUZcxHeMwrQePB31lIM4rDZBB8N
         IG4edlFkmBCg4NVCjIA31e55/yh9mp13UHojDSRYcekyXVEog1kmaaD37JZKCBbG/VV0
         3mDOa6dY4Ut5zorc1PrwrT5oDZeZm5cgK1Sb//qRDpDLqduQ66aR85ocSf+hvH8Lja/G
         0blg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145670; x=1737750470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cJ0ZegHoOh0cxTfqSdDN2GCuoOF3B9WnLGcL5GyVqeM=;
        b=WX8QOXjha9mgLxkU+tiXVOo3nTJVrURXJiIlb1lbEFaMSUcBEA6L/NxPkMmuW6EuVQ
         qB3MH+ZHonrHfYp6KZ0cAM5Vqs31YTvFF4lM4kKr5QeAGMXUUuMal7y6K+w/CCwPm2VB
         dRfGjfDa727ZuZ8zLsTKl0odWG6Oni517Cdjap6Um9BB+mN8i8uZuvSi2PLjXL+PZN9x
         ZFHl0MNMot36ymkshQHYYq/TGKJ9+uMPwvoeX+4QSREl1IbDcEiyBiJAIeX77EBSXR+G
         ItKp1QiRa5rWUj2q/bkiSwndXUoxE7pv6uutIYdr3saYzJKYuNEm73N9Fq+pZ9uTirGa
         IzHQ==
X-Gm-Message-State: AOJu0Yx7dmuUjBLhKqPe2uMnje20yYOjc3+3WJezu0/rSce8AkOh6w8o
	CLRRA3mBPfGp0FgB5qAoarNvIfKD+WfoUngzE4/z5mAqMCmt3a8l3qBBEmuzGKQx86OnqXX6k48
	v
X-Gm-Gg: ASbGncvCea7QHqPHy3hbW1C6MFsowS0Qgre0x5G7QaHDB2h5u2+gQxJnGil/oJQUiM1
	hXbzjodFtjryuOw9dim4nozDhqie1Y+grtv+0jLDO+X9gnFMDt847LM/LboihtCCP+212sykeiK
	AHUlsuQn4jUZQ0W7LN2N3G4q1H4/ol3eGVWOl37SKe2wYuLo9M9tiNwVMcpoVrTspDN7WiAn2Ir
	ykcUUj6fEl316S/jUGB9VQmcUysFYPerFJLeYnkS6WnWE2aXgCrSVTLlCA5GHRtE+QpIkhiaFFH
	CVXtEX0etpYa03jA1WenRLb+Lbz2e2ljSHQkZy3Hdd0=
X-Google-Smtp-Source: AGHT+IHYuUYempRdGg8AC/lhZFLvPenkPtm+xAZrVuVVnUJJvfhjXIdvb78TUiBL0l3AW5DD1Wvm3Q==
X-Received: by 2002:a05:6000:1863:b0:385:ec6e:e872 with SMTP id ffacd0b85a97d-38bf57a6839mr5496027f8f.38.1737145669929;
        Fri, 17 Jan 2025 12:27:49 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38bf3279388sm3318558f8f.75.2025.01.17.12.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:49 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 01/15] multipathd: don't reload map in update_mpp_prio()
Date: Fri, 17 Jan 2025 21:27:24 +0100
Message-ID: <20250117202738.126196-2-mwilck@suse.com>
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

Rather, return a bool indicating whether checkerloop() should call
reload_and_sync_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d7d4a26..fa684e6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2689,25 +2689,25 @@ update_path_state (struct vectors * vecs, struct path * pp)
 	return chkr_new_path_up ? CHECK_PATH_NEW_UP : CHECK_PATH_CHECKED;
 }
 
-static int
-update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
+/* Return value: true if the map needs to be reloaded */
+static bool update_mpp_prio(struct multipath *mpp)
 {
 	bool need_reload, changed;
 	enum prio_update_type prio_update = mpp->prio_update;
 	mpp->prio_update = PRIO_UPDATE_NONE;
 
 	if (mpp->wait_for_udev || prio_update == PRIO_UPDATE_NONE)
-		return 0;
+		return false;
 	condlog(4, "prio refresh");
 
 	changed = update_prio(mpp, prio_update != PRIO_UPDATE_NORMAL);
 	if (prio_update == PRIO_UPDATE_MARGINAL)
-		return reload_and_sync_map(mpp, vecs);
+		return true;
 	if (changed && mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
 	    mpp->pgfailback == -FAILBACK_IMMEDIATE) {
 		condlog(2, "%s: path priorities changed. reloading",
 			mpp->alias);
-		return reload_and_sync_map(mpp, vecs);
+		return true;
 	}
 	if (need_switch_pathgroup(mpp, &need_reload)) {
 		if (mpp->pgfailback > 0 &&
@@ -2718,12 +2718,12 @@ update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
 			 (prio_update == PRIO_UPDATE_NEW_PATH &&
 			  followover_should_failback(mpp))) {
 			if (need_reload)
-				return reload_and_sync_map(mpp, vecs);
+				return true;
 			else
 				switch_pathgroup(mpp);
 		}
 	}
-	return 0;
+	return false;
 }
 
 static int
@@ -3040,13 +3040,11 @@ checkerloop (void *ap)
 							     start_time.tv_sec);
 			if (checker_state == CHECKER_FINISHED) {
 				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					if (update_mpp_prio(vecs, mpp) == 2 ||
-					    (mpp->need_reload &&
-					     mpp->synced_count > 0 &&
-					     reload_and_sync_map(mpp, vecs) == 2)) {
+					if ((update_mpp_prio(mpp) ||
+					     (mpp->need_reload && mpp->synced_count > 0)) &&
+					    reload_and_sync_map(mpp, vecs) == 2)
 						/* multipath device deleted */
 						i--;
-					}
 				}
 			}
 			lock_cleanup_pop(vecs->lock);
-- 
2.47.1

