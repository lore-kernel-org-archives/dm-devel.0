Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2611BC085
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957981; cv=none; b=G3UZC/QWQspxgQHjb0WMFxq/fAe+VFVDlcZxrgtfOp6dnnyzZv/YR6zPF4g/eMMVquynkdMYBNOgj0cfLzcWMdCSxpJzurnUKe0rilFf9tRnOyMfH0ZtwKXR6g55WtQzVtdditjCSMeifjSs0B7Bbehei9GNbPI/PPNH/W66F8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957981; c=relaxed/simple;
	bh=l1zcAdauQ5HWKjJElzIGYPbPGwY5spwBFDiUUilZKww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVHLYmhKnRrDuZvlEqgegyGhtGJiqkIBlTsYWDDLfDS4G1HvtSKgMpAPHgYP8vE6UFqHyXezli9g+spm9u1n/PkztyLODDLjTRikZfmarZGfOQKDTOjD/DPJGYOh+hvp5+aIRi+UjbpvDVAj9OraoMmMz8VvkWrIP3/s8ICJmvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y4mv5DsT; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y4mv5DsT"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cf6f804233so9284225a12.2
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957978; x=1734562778; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqFw13jiQyGBvKaQM3cuMvdhGtZMk5NrzcPULqi9Gao=;
        b=Y4mv5DsT40ZyEjhmFC9LypYNp0ioTTa2vvbIwr9dYFAeonVWVewy6SrXZTyCXmMf6P
         4FjP4kS0NnJd9mOAOR3PI0VbsA1vFD2joK+Rwq/E0cC9SP0wRstpzvN+IHAYaQd1bRNV
         oiUohXAXQ+1AM0F2ro3tadiEUkjGSctS1ukmKNqLb+LfC+mvp3Ti94zrwadBGUN5bc2z
         3uDcGbpxVEd+NdcABAJ/qFz86tS0PhrxqxGdUYgD1EroZ43DAWt2KvQDU13AlPDGGedG
         cThd0DHtbUjxrqMejLFvDqe7/Y4nOZYmGqAGuRfASSk+IlHGbc+6DoIewBlm5rU040Th
         PvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957978; x=1734562778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqFw13jiQyGBvKaQM3cuMvdhGtZMk5NrzcPULqi9Gao=;
        b=T3WZuvb+QlWgYBCVWtuKezb5aeBEiDXUxKIKISMGgyVKBv398nQMxYoxXSa+w1sAg8
         MtJXSAJe4IzVP3xmWk2mC9ihRa0d/MXtIpziDzEadMXzzUrBdyy+IPQ+Gr7T9utigFfk
         BdK0+wY0H593B6FzcWVQUDxpU7EBI1PUz03cPfYHuZYCgA4lF5d91KdIuoXsi2ShI4VR
         kUyXpawhEhwvaOcAf+sNgaMfN1B3If75blUDwZfNN0cN2hqlfWYSHojvJx0e9/QYtYIp
         H10Sg/ENiblp456v/iNIhyh0IZjeNbJPGzyHVkJxgOBpJfLOyk6VdhbDJ/iTzcrsuFp4
         3AWw==
X-Gm-Message-State: AOJu0YwZWSY33FUIoIGGBcc3lcxbTsy+9GG5uXHegq9J2faKVVZ3DPym
	+4TXY4+UM1lEe8B04/Q1UE28ukX8M+ahddH3NlmhzazpGmj2Ns/7oQW0waFw+sk=
X-Gm-Gg: ASbGncsLGu+b+zdU65CLb2pIgNxuqiHkanH2aBk+xwZCtXRxIxQ1bNe1d9FW2FjC5Kw
	VpFW720bWSa6rigvwxq/DeGbXCYIyKYK46x6olzGMvfOYEPrLIvDDCEfSmjphlUrP/3Ab8x877/
	aCcw3+czymwZQalAhpfjylr87cPygUbcjT3t+QQkhbXC96p3wdaH9doXlT1bbD0RwLs7TzwcIvy
	lCF0MgwjcDjexe/gNg3CdjBV7IrHCo26tl1gYKl4mRxQhxFPD3TCF0SEy0lq9wziReJ9BpYv0Vv
	vq/OXfY/SPIeR6mPhnWyCZZ6UXEDk7dFKPha3sM8
X-Google-Smtp-Source: AGHT+IEoLflzmqd05uUiRtpZk6OC1xZTsUhI08b4OVVIuW24vbDxtBEufRxQz81u3VQG5MT4XMSMPA==
X-Received: by 2002:a17:906:9a95:b0:aa6:5d30:d971 with SMTP id a640c23a62f3a-aa6b11419f5mr384629766b.11.1733957977466;
        Wed, 11 Dec 2024 14:59:37 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa68880b344sm516989866b.184.2024.12.11.14.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:37 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/14] multipathd: don't reload map in update_mpp_prio()
Date: Wed, 11 Dec 2024 23:58:56 +0100
Message-ID: <20241211225909.298770-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
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
2.47.0

