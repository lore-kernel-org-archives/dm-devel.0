Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0464D3DEAEB
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 19:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651084; cv=none; b=EW0ABjT0OM8rg1EkbsretI9Pp1xr6f349cIQngrVRQQeE202+3L4OgPwtLn1rnj5lVapdTew6vse0csvCyU6oDrIbtQ1XTgZBlsmYXVWtCcWzNSQ35Mdyv3fTlxUFFmldkAI9JoMegRgFDmDj7T76VzNK+FopW6Rm6+75Ok/F3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651084; c=relaxed/simple;
	bh=Mlj/9K3KlIWlpIMKlBt+1viGCig6d33F+gd4tCZ6LAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ZnTRHDgo1gkYGyPhxshanBcUQ6IWSoAbe1ezHLaamuTLI8WOkM2NCrtpfNwmhBinXm99feLzQX+7Gzb6s8Tq3efwWl/tS7Ao1YnNXQ9UF39rbKxSr1BPjbxHqyUnlTh25ZWzd2WN2bf3v0qyKRUcK1zJGQ8b0GaY+6FtPQVsacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWC/RD1p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWC/RD1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772651082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4/gvWAc7jMA8PiPw4OjdtXDR+vFdse+XnqHD39G+E8=;
	b=BWC/RD1p5kPNHbZO+MbJoUWjQco8JqK9WYC8SHzdKrW01MbVuDZhG4VRKR2Dhe0BJ9soFQ
	oJSDuPzGyAaRaE1EPkDqIGnGUbO4XRHgTrSZ5aq7MJq/Inozqy/Kqvm6SiUYf9NFWJg4Uh
	4T6iVeDGzalS024hzrQKo1zRImgJi/A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-2-RnlrEz9nMkejANd1DJV44g-1; Wed,
 04 Mar 2026 14:04:39 -0500
X-MC-Unique: RnlrEz9nMkejANd1DJV44g-1
X-Mimecast-MFC-AGG-ID: RnlrEz9nMkejANd1DJV44g_1772651077
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C4491956088;
	Wed,  4 Mar 2026 19:04:37 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D82EB1800576;
	Wed,  4 Mar 2026 19:04:34 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] bio: rename bio_chain arguments
Date: Wed,  4 Mar 2026 20:04:08 +0100
Message-ID: <20260304190424.291743-4-agruenba@redhat.com>
In-Reply-To: <20260304190424.291743-1-agruenba@redhat.com>
References: <20260304190424.291743-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: TdREPDaAZvJpKrw7l6mrSsd2kzvpoecFulCfuTvmtIk_1772651077
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Use the same argument names in bio_chain() as in bio_chain_and_submit()
to be consistent.  Slightly improve the function description.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index eadf4c1e9994..5e60bf3730af 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -369,22 +369,22 @@ static void bio_chain_endio(struct bio *bio)
 
 /**
  * bio_chain - chain bio completions
- * @bio: the target bio
- * @parent: the parent bio of @bio
+ * @prev: the bio to chain
+ * @new: the bio to chain to
  *
- * The caller won't have a bi_end_io called when @bio completes - instead,
- * @parent's bi_end_io won't be called until both @parent and @bio have
- * completed; the chained bio will also be freed when it completes.
+ * The caller won't have a bi_end_io called when @prev completes.  Instead,
+ * @new's bi_end_io will be called once both @new and @prev have completed.
+ * Like an unchained bio, @prev will be put when it completes.
  *
- * The caller must not set bi_private or bi_end_io in @bio.
+ * The caller must not set bi_private or bi_end_io in @prev.
  */
-void bio_chain(struct bio *bio, struct bio *parent)
+void bio_chain(struct bio *prev, struct bio *new)
 {
-	BUG_ON(bio->bi_private || bio->bi_end_io);
+	BUG_ON(prev->bi_private || prev->bi_end_io);
 
-	bio->bi_private = parent;
-	bio->bi_end_io	= bio_chain_endio;
-	bio_inc_remaining(parent);
+	prev->bi_private = new;
+	prev->bi_end_io	= bio_chain_endio;
+	bio_inc_remaining(new);
 }
 EXPORT_SYMBOL(bio_chain);
 
-- 
2.52.0

