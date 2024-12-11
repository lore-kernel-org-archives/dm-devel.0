Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281331F2C26
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957989; cv=none; b=c+djid0h8/1DhgNZgCfJsbmu7MRLIql2b5VRTwwdnJv/MWzKkygN+pifuVaS8vAF4RYRqT0jqdjH3dnbhRf1tqYm6/BF+cG8EZmtl4rkoevtlLch6dAWl9Q+GyGHyi7IzASB27//rS+JYObQKef0ElGoTx4n+4JJxANa3AWCux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957989; c=relaxed/simple;
	bh=23tMk1gvk75fa694f+c6lxylDpacU2XQOIyyvgWccUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfiDu2l2HsrAODJkIRTDIOUNXnD7PwYgZcs5XO7bArESN50lvQ5/GDAWDpN5gRVQFDC8gQDWVI3SrrzabNGF4cCJ4vx8v27Fif1XnI7zAgvKcuFZcmVAePYN6O/R44RvyowjFcx68LMcNiY5meXD+W5XJrG18DV0pruO2Brd+r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N2zecpdO; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N2zecpdO"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so1068120266b.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957985; x=1734562785; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCUSrMdqyV1npUI+0UOzEh5Y+9S73CsLFqrJUT60//0=;
        b=N2zecpdOWHL6bwEmC3NA9GRlIPdlta6bnf0JyIaX2gUVg6dqwP8dv27fl1pFGsMV8K
         Vmus6Ts5xkkN2l8+UMzkodWbFtA14MHY+pRwxxK+bVyrUYiUof5MRZRcDljz9qA45Lu/
         /Pvflet4biY1ddxzrOEZgzu4mFLJgMEul5cI1p4qMNQlsSNtGF3cvW7///tQ7johwv8J
         OPI5nTO1GA9YoDGjEPvufK8SP4vYB9C/jIkGY9A9vy9DFthZqyeX5OyrkCHjQIKPR9WY
         7jxc8S4qAXxvJ4jUPU9B4ZaRoZEEBtAsdqKQeDtAEMJgwbm3mzl+gZR+Ny9ercoxuHus
         0+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957985; x=1734562785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCUSrMdqyV1npUI+0UOzEh5Y+9S73CsLFqrJUT60//0=;
        b=pqLbY94/HW2aaWOHn54vmOMLe8mrgs+srpwStLpPfU9dcpndXUNpJOnf4Jn5fYsU7i
         a/fFgX/fkUR3WbTO+JVAjo98zvab6hnkhsxpBYd/trYGS4LmfP1ysjqmPIu3WP6m5EgP
         frif17k6M2uiN8jX6m1chG+60uOFSGljFwz4wvYmTDHcgPdZ6gvubV6y9i5L236jaMFK
         iDrIUFCSAM69a0GmBk+FZN/e8Vht3azj8JORe2J0DeiZ6IfW9jkow4IJeT1klBL5gLgr
         nKCS0iQqenPOBwd70B/6fTp09dbCjDP/3FbWkBmNHYB1fpBUrLovpqwXoSAy9h+mQ85H
         uMOw==
X-Gm-Message-State: AOJu0YzpYq6N+Y0m9dIs8WskrhiqlPJZwXEnyGBpGMQmshkl95Pk5ahy
	oeH+1hueNJqjrEjgerotZRzsdrEcr03KDcRQ7VjdC1K7LfUc/FvFqN7wiwBo8wc=
X-Gm-Gg: ASbGncuUbwqbUO4ZK5GjHu4NtuQypbEEkDWxM8mdguv6uFn0LR1Wy/Smi1kcChdbSD8
	faPD6iCNgEsE8jkjHU62/p0V+NyvNFkqjpUIh46ufQo5cLPhTLLjbDtRRZ3L/n3UN6RfiS0Xq3d
	YxtWApwURux1C35SEy3w4uA0GyHKYfwlaIHfMzNoQ5qv/qxdSbUu3+eB9GEUyknKILwAK9qlXfy
	Osvs9HX5F8MvoHc+Z/5Yh6M/TYltbxRLzr0sGU+SQ2gpXDlyaCMksR4iPtw5a5Ny8eTevGQJEiu
	T4MWy5GnpvBQ4uPzZKO8mmCGQjQbUmN+NrxkztSL
X-Google-Smtp-Source: AGHT+IG3szGzCLcJVlPi3P6n9SX7JijFCvE7rrDGkudV1CVCCDnoIN5rXdsgg3uVvd/S8vp+z1zY9Q==
X-Received: by 2002:a17:906:3114:b0:aa6:2fdc:db1a with SMTP id a640c23a62f3a-aa6b1394613mr456137566b.38.1733957985219;
        Wed, 11 Dec 2024 14:59:45 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa651ea3160sm745373566b.174.2024.12.11.14.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:44 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/14] multipathd: move "tick" calls into checker_finished()
Date: Wed, 11 Dec 2024 23:59:02 +0100
Message-ID: <20241211225909.298770-8-mwilck@suse.com>
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

The various "tick" functions will only be called after CHECKER_FINISHED
is reached. So we might as well move them into the respective code block
into checker_finished(). This way don't have to drop and re-take he lock
when all paths have been checked.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0823484..b045f8b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2990,6 +2990,11 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		if (inconsistent)
 			mpp->sync_tick = 1;
 	}
+	deferred_failback_tick(vecs);
+	retry_count_tick(vecs->mpvec);
+	missing_uev_wait_tick(vecs);
+	ghost_delay_tick(vecs);
+	partial_retrigger_tick(vecs->pathvec);
 }
 
 static void *
@@ -3064,16 +3069,6 @@ checkerloop (void *ap)
 			lock_cleanup_pop(vecs->lock);
 		}
 
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(&vecs->lock);
-		pthread_testcancel();
-		deferred_failback_tick(vecs);
-		retry_count_tick(vecs->mpvec);
-		missing_uev_wait_tick(vecs);
-		ghost_delay_tick(vecs);
-		partial_retrigger_tick(vecs->pathvec);
-		lock_cleanup_pop(vecs->lock);
-
 		if (count)
 			count--;
 		else {
-- 
2.47.0

