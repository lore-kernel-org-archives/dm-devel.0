Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE20A217F2E
	for <dm-devel@lists.linux.dev>; Sun, 21 Dec 2025 02:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766285613; cv=none; b=D+GsoiaOk3TE23uEFdZ15V6aY869y5daGi6ieeI2n00BfunEno/WcWBI9EwzMCIbwY078EkUYITVwlcVRKs8Eh4WGyV5K8jqrMYnM1ycQTfCrqSUotRGYOlr/qIjz8y1EkSleWYRNjqI6Gt8tog9V7uQVXcKTmH31uUDQhQCGjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766285613; c=relaxed/simple;
	bh=XuzBPd7weqP6eKh2byUN6HJgcTxm4e6z9RFRaspbX2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ngs96mOCjK5evrGUosIWS2K1Y2xWt5qWp3mJBA3q8KR+xZ+74EW90nwGpyQ0pjIzLFGjUkqUTyxwpsX30Qs86ulIBo+95tdpYW+tIzpRVD7sfIWpklJXcyhNCnvwgmwRPh3QWO8ToMImXbkQ00QARqu0KuthtiYVhMLnJIESc94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zgc2P9+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zgc2P9+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766285609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4U+/r6sUCuyiDnJIU2RJVG82MRW1R2RHAXhrJ/sLzs=;
	b=Zgc2P9+JkYu9cCuDn3zSTtxpyALKuyir0cl1T6thlffibgdBWRyP93TOQryue2wNKgxznx
	tZCiFM/9NcAHoZo88pqXCCuplU7x9+Ac2Kzo7EV2TciiYIXPx2icAoRQCGx5HDx2PZRv00
	+gNHs6cF7j4TBnCxy3PR3D8SgZm4gJ0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-ugIClds1POG0hGBC36RWNg-1; Sat,
 20 Dec 2025 21:53:24 -0500
X-MC-Unique: ugIClds1POG0hGBC36RWNg-1
X-Mimecast-MFC-AGG-ID: ugIClds1POG0hGBC36RWNg_1766285602
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA1321800451;
	Sun, 21 Dec 2025 02:53:22 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C77DE1800577;
	Sun, 21 Dec 2025 02:53:19 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Satya Tangirala <satyat@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 12/17] bio: do not check bio->bi_status before assigning to it (part 2)
Date: Sun, 21 Dec 2025 03:52:27 +0100
Message-ID: <20251221025233.87087-13-agruenba@redhat.com>
In-Reply-To: <20251221025233.87087-1-agruenba@redhat.com>
References: <20251221025233.87087-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Don't check bio->bi_status before assigning to it.  These are the cases
that involve an errno instead of a block status.

See commit "do not check bio->bi_status before assigning to it" for a
rationale.

Created with Coccinelle using the following semantic patch and option
'--disable-iso unlikely':

@@
expression errno;
struct bio *bio;
@@
-if (unlikely(errno) && !bio->bi_status)
-	bio->bi_status = errno_to_blk_status(errno);
+if (unlikely(errno))
+	bio_set_status(bio, errno_to_blk_status(errno));

@@
expression errno;
struct bio *bio;
@@
-if (errno && !bio->bi_status)
-	bio->bi_status = errno_to_blk_status(errno);
+bio_set_status(bio, errno_to_blk_status(errno));

@@
expression errno;
struct bio bio;
@@
-if (errno < 0 && !bio.bi_status)
-	bio.bi_status = errno_to_blk_status(errno);
+if (errno < 0)
+	bio_set_status(&bio, errno_to_blk_status(errno));

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 drivers/md/dm-integrity.c | 4 ++--
 drivers/md/dm-thin.c      | 3 +--
 fs/erofs/fileio.c         | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c5c7c167b45d..4a6e27c0d510 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1580,8 +1580,8 @@ static void do_endio(struct dm_integrity_c *ic, struct bio *bio)
 	int r;
 
 	r = dm_integrity_failed(ic);
-	if (unlikely(r) && !bio->bi_status)
-		bio->bi_status = errno_to_blk_status(r);
+	if (unlikely(r))
+		bio_set_status(bio, errno_to_blk_status(r));
 	if (unlikely(ic->synchronous_mode) && bio_op(bio) == REQ_OP_WRITE) {
 		unsigned long flags;
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 00ede45a3d27..42261bbe4771 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -422,8 +422,7 @@ static void end_discard(struct discard_op *op, int r)
 	 * Even if r is set, there could be sub discards in flight that we
 	 * need to wait for.
 	 */
-	if (r && !op->parent_bio->bi_status)
-		op->parent_bio->bi_status = errno_to_blk_status(r);
+	bio_set_status(op->parent_bio, errno_to_blk_status(r));
 	bio_endio(op->parent_bio);
 }
 
diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index b7b3432a9882..7ed32cb9e670 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -32,8 +32,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 		ret = 0;
 	}
 	if (rq->bio.bi_end_io) {
-		if (ret < 0 && !rq->bio.bi_status)
-			rq->bio.bi_status = errno_to_blk_status(ret);
+		if (ret < 0)
+			bio_set_status(&rq->bio, errno_to_blk_status(ret));
 		rq->bio.bi_end_io(&rq->bio);
 	} else {
 		bio_for_each_folio_all(fi, &rq->bio) {
-- 
2.52.0

