Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269B5212FB3
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528221; cv=none; b=DWltz38j9jqZ5xAue1upIqdQ5A2sFaRmDWsGnsdce/K3Zly9IqgWTADLwCWU09DVR6MaYUqu+YpsCMC/YzkMEwZ82yrlYj4kw0IOyoMIzKo4Pf40U/LBEm54VlKU35te0sxcMnyXaNChXefSWziZv04mT7VN4L8Yp4sk2ly1eNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528221; c=relaxed/simple;
	bh=TRqhWHgH+AzImzjo3waFv0T9gLn7dfgtOGPpGqmkugc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnNoc4bxl/U543VBU/qgA6ZVWCkwqGvxfkzpAvnCzwtkZYx+q32KwIikzwFDJ0RU+18+Mc/hjnS3fsToMoRQSb+5s62hmg5pseAMK0JyvTT0sz0IMVdfb0v/1rH93+gnnYHzWzde+RhxDPjiZtxoPMs/hhiLP2QC+EI85YBahPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TaAZgWlb; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TaAZgWlb"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-434e84b65e7so1976845e9.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528217; x=1734133017; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2Ee4y7zBb9XuPKxkrgzZL0Igd4w44GZZQWAh8Lp0rs=;
        b=TaAZgWlbObLIkN1sLbYoiUr9OdcelfXBrvKtF5r3tXVWFRmkv1KZVkfqtJzmOL3n72
         Cdl0Ax3ILX/yeuGyGw0b0xbJg5nW9zoRej3FDWe0WCIh+SVuZpSoZVxeY7haQtxfRMCU
         b86pMMEHdI9RtXZ6M09QxEL1IO3pXC2Z7y464fOPDUMotcZiUgBkFLSGMwHvsPx6A4Al
         I3JJpsfs9WY7omsZHrlVvu/LGY6SITTHr14i79z50p3Eza9ZzDzHRPt19JA8c07rZqO1
         4s4DVXTNlozTmDzdlsmuUICGJp0Vm3UNoX5w59FlfzD0slTACe36StuYO/gY9DQ8/TeC
         wZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528217; x=1734133017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2Ee4y7zBb9XuPKxkrgzZL0Igd4w44GZZQWAh8Lp0rs=;
        b=I01/IiIUNrAl1/yQprcpqQsZ8x7vB7h4SZNUv0zjGPHapSn9j13yLd2dG5FKG+LkGH
         ytXJakHplmHALzH0wv5+u+XoXMIJT7jKJYtVSpbfWQbWoxiL/9+b5Pg5uROXYCHOASBJ
         92FAheg4e8daDXcBKQ70SxVQ2fXvUHoHy4jp3rLecc3iH88RtF7X4RQwuWFLwF2XKuok
         +oQ2nLYTCgxtTGxA82ewmx3uFzMRSTQvOeANS79B2gSlhVtRN/sjtBqZHwsbUq7Urf+A
         jESqNHMqJvfcM8norFBn2r5WJgt8GpkS1asQMuhhKrQliPZvT3kIZ6zETo6/aCfH4GMj
         p57g==
X-Gm-Message-State: AOJu0Yx87Tfeoby2c7DHS0nsqMvHKdpojKXulXynYtTLCK2AQdIUQg6H
	pw4Ic5R7cFfqTMrj0VfLR645/+iem+JaqmmktJGWcnVWxbgHJxOfW/ltxKORKelL2yx+T6fCYji
	/
X-Gm-Gg: ASbGncsD114MjfLePRbcVp1w32/tlZ7bGZOW1luyCMzcwso51cPwf2dUjzYETg4ZRl1
	i0SwH/g71G8F6vTY8bVdyjaO6m9w6/Hml14zcxRbeHkTX5OLx8yk3Fy7mw/rASblu5hrK5bhpKn
	MlWPD5tIYmffELuFZtKnJSaE/CW3VklnYbAGOZZw2aQPake4VYg/Y1ALyPHtqQkddxdESqvZkC4
	9iwAJ/mXVHkJ9x8bA094mFxhvQS8ehVGPO7t4vCKDa9psV9F45+BE4rTiHpxFvFOYzXMCnr5WID
	iW6Ms2tVcuGPrwx8M1VOa3dgl3NpK/keMhPG
X-Google-Smtp-Source: AGHT+IHtWenoLuiqq6p4/lFYrzNPq5L5jEdRZUypKD55JtdTyC6H+FmmXmsh2s/GXNaq5bt1gYdV6Q==
X-Received: by 2002:a5d:6c6a:0:b0:385:dedb:a156 with SMTP id ffacd0b85a97d-3862b332737mr3863032f8f.6.1733528217243;
        Fri, 06 Dec 2024 15:36:57 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d14c799224sm2705203a12.69.2024.12.06.15.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:56 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/13] multipathd: don't call udpate_map() from ghost_delay_tick()
Date: Sat,  7 Dec 2024 00:36:16 +0100
Message-ID: <20241206233617.382200-13-mwilck@suse.com>
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

Instead, move the call into the existing mpvec loop and call update_map()
from checker_finished().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4478cc9..e48fa79 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2026,26 +2026,17 @@ missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
 	return false;
 }
 
-static void
-ghost_delay_tick(struct vectors *vecs)
+static bool
+ghost_delay_tick(struct  multipath * mpp)
 {
-	struct multipath * mpp;
-	int i;
-
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp->ghost_delay_tick <= 0)
-			continue;
-		if (--mpp->ghost_delay_tick <= 0) {
-			condlog(0, "%s: timed out waiting for active path",
-				mpp->alias);
-			mpp->force_udev_reload = 1;
-			if (update_map(mpp, vecs, 0) != 0) {
-				/* update_map removed map */
-				i--;
-				continue;
-			}
-		}
+	if (mpp->ghost_delay_tick <= 0)
+		return false;
+	if (--mpp->ghost_delay_tick <= 0) {
+		condlog(0, "%s: timed out waiting for active path", mpp->alias);
+		mpp->force_udev_reload = 1;
+		return true;
 	}
+	return false;
 }
 
 static bool deferred_failback_tick(struct multipath *mpp)
@@ -2941,7 +2932,8 @@ static void checker_finished(struct vectors *vecs)
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (missing_uev_wait_tick(mpp, &uev_timed_out) &&
+		if ((missing_uev_wait_tick(mpp, &uev_timed_out) ||
+		     ghost_delay_tick(mpp)) &&
 		    update_map(mpp, vecs, 0)) {
 			/* multipath device deleted */
 			i--;
@@ -2958,7 +2950,6 @@ static void checker_finished(struct vectors *vecs)
 	}
 	if (uev_timed_out && !need_to_delay_reconfig(vecs))
 		unblock_reconfigure();
-	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
 }
 
-- 
2.47.0

