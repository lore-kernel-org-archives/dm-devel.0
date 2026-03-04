Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F003DBD6E
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651080; cv=none; b=W1b0EITTNqELmFXiFoDe8oo42qcaf/HhqRNIyE4dFNLBeNDy1iMd8v3NkPzJVadRs8K5ELDd/VSFiyN7zpTV+i63G2vRbE4LdHBDIwHb6OLLFg5sm+BRUsAi8G/RZ5j1T+B2LtuAaHrU6nfIheOL32Zhqxff/IUUKTEIdXMapNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651080; c=relaxed/simple;
	bh=gPdzuSJ4OpIx0ANFGSXNp22Imqcrhnh1C52bd5cSU98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oSpFB+J5iEYoyl3gKgrWApbejSkptZVHZ0d7gPij5PHmuhk/ILwlHf7WdbIGVv+CaV7U3cGPzmd+TWoomeJF57pfLQIgiwuW/3seBOcdts1KgjnZfiAEhEPdyCPvR0EW0TCzJ+j8g9atFcjanEhrAKoTlgGheBILTHt3c18D1H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGFtzyJ6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGFtzyJ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772651078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nM7kNBSEq9uce0DB9nBNjzTI/YSlQuc5UuGQ7K2UugI=;
	b=ZGFtzyJ6rMhLjqqGanCoiJ9tG+w+FFrXYxk7winO8PrIW1pXlh77ZDgabJSoKvLhWvXY3J
	PSnyqC4h3oSG//mT3MW9ORD6+hF+9tNqVTKa4UOSvB1eQnxjzIej1cvTr24xaDmCRUMNXs
	bmqeUCVWQnloZSa9d6F/b//VURiuBmI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-ng3K5dKrOE6uUqSz4RUfzQ-1; Wed,
 04 Mar 2026 14:04:35 -0500
X-MC-Unique: ng3K5dKrOE6uUqSz4RUfzQ-1
X-Mimecast-MFC-AGG-ID: ng3K5dKrOE6uUqSz4RUfzQ_1772651074
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B99019560A3;
	Wed,  4 Mar 2026 19:04:34 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2E941800576;
	Wed,  4 Mar 2026 19:04:31 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] block: get rid of blk_status_to_{errno,str} inconsistency
Date: Wed,  4 Mar 2026 20:04:07 +0100
Message-ID: <20260304190424.291743-3-agruenba@redhat.com>
In-Reply-To: <20260304190424.291743-1-agruenba@redhat.com>
References: <20260304190424.291743-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: c4IK-YsniWcFBIo5xbLf_A9cenU3xFLAxyUg4C-5QbM_1772651074
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Change blk_status_to_str() to be consistent with blk_status_to_errno()
and return "I/O" for undefined status codes.

With that, the fallback case in the blk_errors array can be removed with
no change in behavior.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 block/blk-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 474700ffaa1c..a20042f15790 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -161,9 +161,6 @@ static const struct {
 	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
 
 	[BLK_STS_INVAL]		= { -EINVAL,	"invalid" },
-
-	/* everything else not covered above: */
-	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
 
 blk_status_t errno_to_blk_status(int errno)
@@ -194,7 +191,7 @@ const char *blk_status_to_str(blk_status_t status)
 	int idx = (__force int)status;
 
 	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(blk_errors)))
-		return "<null>";
+		return "I/O";
 	return blk_errors[idx].name;
 }
 EXPORT_SYMBOL_GPL(blk_status_to_str);
-- 
2.52.0

