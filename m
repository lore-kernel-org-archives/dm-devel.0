Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D641A9B52
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145685; cv=none; b=GZjPQuF/57SUvGkLZ4RkzVosxgZRHP7f4BzbSPZOdMYC14g21ZsBlwoVVNw+kU4Kgd/hlANGLGQDgjm76mrn0LJj7U4o6dVsQVJ6aI6tHKyFwr1Q3pyS7/DdyExZdyQuid6gtqZIZTc0gBoRh3oKA/ptv/e49AiZ6ASmKouuYZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145685; c=relaxed/simple;
	bh=AnDLC+v/JPNkrtIf407oTYN5QdxSdOtQtFe+B6fXHic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh9u5mrAgcU5hxeqRV8OgljorTcvUd3S2j60MkqHSIdCDjIcFDF0V5fHsae9HQlnfPtZP0cvSOIOMGWfnZ42MhJqck4PnLRRGuFIp/IY7F0ummp/oeojdQh2wcyLbttO0jO+CbhXPlwOMUQmhlH/Cin8whptrnCkF71Kj/Ob+Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PJhALILc; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PJhALILc"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38a8b35e168so1759003f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145682; x=1737750482; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMeQ+PvgWZsNNmZZXLtk8WAXyCPBDy2vQ6OusCTBFlE=;
        b=PJhALILc8o1tWHMpWinXMHRlrk+8/6whHoHvdwEQKtejG7auLn6RIGcnfLbdfSx6M4
         VT3SgvI+b1OH8lt2KnD2lrnxSo+9a3Ma02S24ie0zNZPF9NZn927K+//aDb5wFNv0Ekf
         pa/Mgvwd+P1pd4X1zmow7FZiMxRZZZCHImxzUUDqEupSG/PgDeStxg97WH0EVxsBOr3K
         rz5XwR/Fwsq9YbCIcVxH2t/WP3iipJeP3I1paNEbPMSGjOWOz7I/16tQ755XnOxUjylB
         efs7dsBsN1CR5jZ/kZ+CqWFhbK9BrQgQIgXhHzlHrwT/9Cr7rTT1uxcdRM8Ep8nz8x+U
         7p6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145682; x=1737750482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MMeQ+PvgWZsNNmZZXLtk8WAXyCPBDy2vQ6OusCTBFlE=;
        b=KP8tw7PzNvy63ryWLTOUd07sa8+ryjfc0f2XXOK4V0f6P6HsDGlX7cRvvQqVYRem4i
         HU0pQIC94xNXItOM6PV9xEHLL19E6rWzpipG3PQMkgCQFpmY8EWFCD/0nBVI8K6jwcY0
         VDBUzj/9NV96YyOPL3/jV+8N9uL6ELdN5xcuqDbwK4MRa5xeRJe0zg3cERcWkGw32pMD
         3LGTnlfuQfGReLQeXsUQTo3owPyjgoZtvQxdzGT27+d6tMH+5exutECLmtaFVe4HctKo
         mZzN3itrgGe9cJ6Wb5S3fNKivRiCwHOb2b80k2Qj1y5s71wicyp7yXDLujPfbdkz1VNX
         DN6w==
X-Gm-Message-State: AOJu0YwW5CDFUGthHWo0vTxPXjXff6+PLNUDhqO3lIS8j3ylMBXfZwZk
	DNGVOiI+WrmCOxIWvXQmOHZDb3NVtB7VCo4OiixKjyY5sbvFl6L6GsgXe+SfrSo=
X-Gm-Gg: ASbGncvNLoWfILh3AymqD6RKh9G7VsW1ECugGRZZTyL484uTI31MGYz79F0bvZCxhV/
	i6RwH9c5xkQfOTYdX/mjkWI6Ewx+M4EiBgfkJ/GSQpBkhl08HIXjmNPfB9aZ9AoH3vsc7BONpQo
	wdy0yZbxmbHKkGmgRGOw/tJMoxoJdhMIpSN2+ENBdpXMIjEr4/OJ3ERPu40ppzrK9HnAND15oZs
	A6/pBcxtHvKIpiYpJ7neCvKYPxLPRhVe/qUYYUqRGWKB0klZ6oVHEzRAUV9C0vQxvsyWwaPwPib
	aFoFTJOrW7jcLGPVbiGXToig9beo4efGXEakTtaAtXY=
X-Google-Smtp-Source: AGHT+IGDCTdqpS0oNa8VtYUK+RZGjJ1fGrOXu0Nl4ZNqzrtujnmets1+nbtPRSe8u09wncp/pm5gug==
X-Received: by 2002:a5d:648c:0:b0:385:f892:c8be with SMTP id ffacd0b85a97d-38bec54290dmr10006548f8f.23.1737145681913;
        Fri, 17 Jan 2025 12:28:01 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c103f0afsm62738645e9.2.2025.01.17.12.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:01 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 09/15] multipathd: move retry_count_tick() into existing mpvec loop
Date: Fri, 17 Jan 2025 21:27:32 +0100
Message-ID: <20250117202738.126196-10-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8c2712d..753f48c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2095,21 +2095,17 @@ static bool deferred_failback_tick(struct multipath *mpp)
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
 
@@ -2979,8 +2975,8 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		if (inconsistent && mpp->need_reload)
 			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
 				mpp->alias);
+		retry_count_tick(mpp);
 	}
-	retry_count_tick(vecs->mpvec);
 	missing_uev_wait_tick(vecs);
 	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
-- 
2.47.1

