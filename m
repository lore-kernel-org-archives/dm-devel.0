Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243B71F2389
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957997; cv=none; b=PdX5oSXj+XewoLB4IvXelFK0pJTzwKNSHkqBtyS5/Y2WHYWBSH6RoyMprW3UH24D2A8hNmxIeg+jik9fNgAJo6++cC3VQllQPEeXmPFYi52qz/1Xhbk/mcYFW4QnBrKwQR4hW2Ryv3m7C2dBFIo0c3cpwKrzB3m2uANBFOStMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957997; c=relaxed/simple;
	bh=tWypuwsBZgszVd5P2iVnWGb+Ioh5M62qWPDIKairgAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTPyv1qa4MY9/+ly8H5Sa2K0aqfnp9gtOgiJVuzPlz++BBwClYJOouqfjbI2aPIe4AcZGASFcUiAMern3DiPk68SRXkW12gL1A2VNdoGNiJ8wR8dwOYYoqicV7Y/uvexc0uT7iOXUBjUAk2vY+x0kEsV0FNFlAiALtI+vZyIc50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=En/MLn3r; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="En/MLn3r"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa6a3c42400so2850966b.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957993; x=1734562793; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3z17tnm1wh1xKDgev0yQso5nOZtnMTXuHE3R/kRp8V0=;
        b=En/MLn3rMl3H8p7p3CDGU1+I6fs+XOh4rMUziUkvhgtxQ+rPQVFoUiuYONPLUZ22yI
         3RHC/XTEBE9GekrGgkMtXJ/mS2Lvl+ACKr0pDbbdEkG64mhmXbkRGWQlDW96Mk8PemLA
         MLzbfuICV+Xkzu/1yT3T7/NRKFpa870i5i0kU2w544JasypYCJA0SSittLWKHe/UOKzH
         S55OSFW8wLJwY8T9tVLJ9o4b2pjjYAI9OtQ/W8H5p2olrodhjulRJkLtAJUY5ZPQCgr+
         g3l6jEaz62xsDaJgWzvenSAnyl7U/rTB+4D/u0EIChShVcvyrwMfrl/xjJgU+EvwH1kx
         WiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957993; x=1734562793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3z17tnm1wh1xKDgev0yQso5nOZtnMTXuHE3R/kRp8V0=;
        b=a4AhtfXkbkZQM5yD5Q494JwaW8NmQDvvQqIHZR6G+/bIk1dPsbNCf0EpZKqSzahkew
         VFA1/ER2jG4O0wYXIH/G4Jr3JqYWpzCkXTAzMi37KjvFxkPO2q3+y77NqjsFcPkKic6v
         PWxjCmXp0Gm+g2T7ehRw4L0Dj1wiUZf4MyOINl9Y7QWhKHJqNUe0to3rfh45vqn3fbpS
         B0wZD++SbpBa5lO2ZytP6EtjUfwXt1HqpUCKTSiqtP888+47mhZEtZetBYY7P2+aH14Y
         qwXryVKfEAhElo+V/uHf4/4Vaiw0Kww7Z2CvnlPjb2re8BcbFbDARyUwN2BXTGF6elj/
         BzmA==
X-Gm-Message-State: AOJu0Yw8VY9sTq1ahQQOawGfRUVel/8tM095q0Euz1k3qSiH9ITxJJmO
	rdMi8KQZ5yMAKWli5hiCw4qnX7bvOr3LSV8+Um38tAdpHgd+C6awd/CzVbTaGs3FbVekefm6lg5
	T
X-Gm-Gg: ASbGnctzF3w+06GVtHHFMDkmTmNbUyT47rUQyAY4aof01rVYQo1og1oHR3nPAx+11q+
	jcMeNIgw6nKNV06O4E1bOCb+D/LzK3g3OB9iCRkbBqb+w70WLzvBgIcAWVieTWbQMbWmofVDE2X
	QoL2SIKWB1LoCYW9hxEfI4797T/zXVOZ9vdTkN8YpK7+4ZxXkq2Qx/LgwwOFFOM0bxSquTpwyr6
	pZttLSv2jG0BIykQN8hVQ65zL9JWGVjWjhPnwDsw7v5v9gfpK7xxcxLHFV6Y04ooLU+8ki42ytZ
	fcZnSemJDYWNbzc3sU5U+DNhrAijQF0Nqs+Yf8RO
X-Google-Smtp-Source: AGHT+IHugIJWWxwjb+uZykgpN4cqR0nWCA+fKEz+iZM2PaerA3TbYNEcmGSHfMbaz4KXajO/baq2qw==
X-Received: by 2002:a17:907:7246:b0:aa6:bcc2:3f02 with SMTP id a640c23a62f3a-aa6c4197545mr99297366b.29.1733957993121;
        Wed, 11 Dec 2024 14:59:53 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa66b96a26fsm683197066b.35.2024.12.11.14.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:52 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/14] multipathd: remove non-existent maps in checkerloop
Date: Wed, 11 Dec 2024 23:59:08 +0100
Message-ID: <20241211225909.298770-14-mwilck@suse.com>
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

If update_multipath_strings() returns DMP_NOT_FOUND for a map that
we are tracking in the checker, the map must have been removed by
an external entity. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8d8b237..138ddd0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2411,7 +2411,7 @@ get_new_state(struct path *pp)
 	return newstate;
 }
 
-static void
+static int
 do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 {
 	int i, ret;
@@ -2424,21 +2424,22 @@ do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
 			"couldn't synchronize with kernel state");
 		vector_foreach_slot (mpp->paths, pp, i)
 			pp->dmstate = PSTATE_UNDEF;
-		return;
+		return ret;
 	}
 	set_no_path_retry(mpp);
+	return ret;
 }
 
-static void
+static int
 sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 {
 	if (mpp->sync_tick)
 		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
 				  mpp->sync_tick;
 	if (mpp->sync_tick && !mpp->checker_count)
-		return;
+		return DMP_OK;
 
-	do_sync_mpp(vecs, mpp);
+	return do_sync_mpp(vecs, mpp);
 }
 
 static int
@@ -2942,7 +2943,11 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		bool inconsistent, prio_reload, failback_reload;
 		bool uev_wait_reload, ghost_reload;
 
-		sync_mpp(vecs, mpp, ticks);
+		if (sync_mpp(vecs, mpp, ticks) == DMP_NOT_FOUND) {
+			remove_map_and_stop_waiter(mpp, vecs);
+			i--;
+			continue;
+		}
 		inconsistent = mpp->need_reload;
 		prio_reload = update_mpp_prio(mpp);
 		failback_reload = deferred_failback_tick(mpp);
-- 
2.47.0

