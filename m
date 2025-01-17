Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358EF1AA1EE
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145693; cv=none; b=fQW0GGkuuxipBRl7g6koB7kI0fmpPkuk2/5M4PhXaJINYomI8hx/WZ/EOw62y1xgJsV6FbIh82u79O+NxvL6Xjnh+UfS0fgfg+lSdHtfAOXiphyvaybWiay+oT1JMJefapVGVVAPUGL4AJVOUqRsAhXqSDQAStydaH1ZSg1E/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145693; c=relaxed/simple;
	bh=xHUkZazwHyAeG2ZMNzJppLmTlvbRddij360Ud39JZwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSvXgX0XC2Hkd/vQ/u2XBbZ1H9tVQG07+rTiJ9bCJ6bGxEU9oxNmtgxBIQLn8TpAuOq+aWXGx94Q7lEZfxb1Ozg2pbidcXQlWRS47M2KkCk/3SK9QYCAu8d1rW+G+wRNbro5ANM1ZdqFaVwHCQQvj/+A5LAJl1Sf5a+8ctWpLZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BOQoJH0W; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BOQoJH0W"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3863494591bso1336376f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145689; x=1737750489; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Jn6VGB92oWmdvSOIXLOBrkwFqlI6GUN+yj8zQcJ41Y=;
        b=BOQoJH0WI19wMm0nfLXZXjoo9fCqz7bfNdC+vAOBrzvkCi4COBcFqAmUDoahZk9XpE
         yYL+ftvV1mbR5ODtQ/BMcsQLI6JE+YYyzAG4+cDM6fhyYyRl7gO7VBgA9onN2X8L1JsS
         mmOD0SpBBrSeWftdS57C+2MC+uGhslLsyf7zNoAnrF5p5lG3sGlLrrKTXfh1BJnwwL0U
         VsME5t1gPEsUMtfXSmOmxUYEMgoqBXM8yJvPwpE2SA/x2kZB73zRwP4QgovM4jl2rzwS
         FEn1Tnnam/26Oi3OoGgibDIZVrT8vlEhZHPiIiWka53+zg80JzLfqkNJqJfPgefu5QLy
         QE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145689; x=1737750489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Jn6VGB92oWmdvSOIXLOBrkwFqlI6GUN+yj8zQcJ41Y=;
        b=u8Oac13W1cqX/75tUIERwKvnMBrvQhC5RV2nG43+XNRbxE88DstWW9V/DEkmKf7Je9
         /ZagQrH34+qa8ffSkf+md0ycCuFA7zu6IqT0kySapmT1Aexgo+S/IcAYy+JzOza6mQzT
         Hmf1yTM4zPr0p6rt5Gr8XPXADHgE7mCHkl9LV1K7Upfh3Wf5RxLhFREk6UnmX1IDSsN8
         SPBmE0Ax6jZJ8qRo1cs42aTWFGlQ+KG0da0RrSS/Ig2PI5hJf/BIe/v5eG8ubvbB6gO3
         OeHE1M+bCauHiH6ZePE5P6iktPE5SOtjehShUb2FuQsKz0NLBarEnFguP/utpPH/we4Y
         hV0Q==
X-Gm-Message-State: AOJu0Yx67TQr2I1azypgpXd96A4qcQ6bBN1CGOmawd1SB4zhQhaUev2e
	wWH4Ltl/aIkZwRRoXyj4MMT4Vi4kpan1sK/DA/7HOMVbsNSEsdoLSJ6krGCbO7Q=
X-Gm-Gg: ASbGncu/Z8jHFzey5lemjCR2MPu6M9VLcQ3A+KPEIUE7TfEln+9QDH3d4iIyNGDeQK4
	pQVrBOUj0Z5o7gq8ahge65DjH0ONmCzKeGdSQk7vJDd40sWh9ovIRU945S0SvLMR2jKCKEotXyU
	moLHdTVkjCeFUFWmsgd2ph8XYSpSnoG+LcBufD6ZFp5//24VffGZUQfuVSADmouQKiXn4fNmoIZ
	aD7G25qK1a6QlVf3IS/YMuCfm3Q0JevDTKLV0OBjlYGT34+IDuBGbT+BNoiFD1qZS7nks4jDnwh
	RwpdW2XDt2NoUKBNde+RVgT5I3zP9qjYRTvpc5d4DUk=
X-Google-Smtp-Source: AGHT+IFHJfWZMtxq7nT9c4IrZ2Ke9cYInCf50b8yJimUl5ZazhH6IhGhnMtCebl6Vl+Cj0l+b7FBQw==
X-Received: by 2002:a5d:64a1:0:b0:38b:da32:4f40 with SMTP id ffacd0b85a97d-38bf566e69cmr4270162f8f.2.1737145689310;
        Fri, 17 Jan 2025 12:28:09 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4389046bab0sm43257205e9.38.2025.01.17.12.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:08 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 14/15] multipathd: remove mpvec_garbage_collector()
Date: Fri, 17 Jan 2025 21:27:37 +0100
Message-ID: <20250117202738.126196-15-mwilck@suse.com>
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

This function duplicates functionality that we now have in the
checker_finished() code path. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 792b94a..310d7ef 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1967,24 +1967,6 @@ enable_group(struct path * pp)
 	}
 }
 
-static void
-mpvec_garbage_collector (struct vectors * vecs)
-{
-	struct multipath * mpp;
-	int i;
-
-	if (!vecs->mpvec)
-		return;
-
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp && mpp->alias && !dm_map_present(mpp->alias)) {
-			condlog(2, "%s: remove dead map", mpp->alias);
-			remove_map_and_stop_waiter(mpp, vecs);
-			i--;
-		}
-	}
-}
-
 /* This is called after a path has started working again. It the multipath
  * device for this path uses the followover failback type, and this is the
  * best pathgroup, and this is the first path in the pathgroup to come back
@@ -2983,7 +2965,6 @@ checkerloop (void *ap)
 {
 	struct vectors *vecs;
 	struct path *pp;
-	int count = 0;
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
@@ -3050,18 +3031,6 @@ checkerloop (void *ap)
 			lock_cleanup_pop(vecs->lock);
 		}
 
-		if (count)
-			count--;
-		else {
-			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(&vecs->lock);
-			pthread_testcancel();
-			condlog(4, "map garbage collection");
-			mpvec_garbage_collector(vecs);
-			count = MAPGCINT;
-			lock_cleanup_pop(vecs->lock);
-		}
-
 		get_monotonic_time(&end_time);
 		timespecsub(&end_time, &start_time, &diff_time);
 		if (num_paths) {
-- 
2.47.1

