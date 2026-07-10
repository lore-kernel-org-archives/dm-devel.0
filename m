Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345FC426410
	for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783701185; cv=none; b=i7meEjyPeh2QUCO0zXkM7BoqctU2PGncvgs0o1B+ZBKUlMbnOSyiEZukFbMMQyBm285LCy/zt9ILB7DmHooNnM432UidoGuEyQt9Gxzpfsya1+8b0aHsbGh0asby4l3XlRtQ0A3rtsRSGTzKe02HxwS5i4NmZNg8weMyLx3OS2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783701185; c=relaxed/simple;
	bh=HHrwV/JUjyn3pokePkOkDGa6RU9D0hT6qWVA3KRI7Z8=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=qCvrclqaJwOx2DhOxuqZuQA/MM88i24uyPQFQpkIB6R5JE9050WnmmVLJiGQ2nkBVH6aK9qdJ6RnVjvEQMoMVs+z+W4E0oJ6L4OA5uE9BKFKZJhiVSw+D/hf41zfJ/phQIYRbmJXuq0zx49ZxUPfstL8OBRZaAYshZGhhQc0RDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LjfU+/pm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LjfU+/pm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783701183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YjPN4Xow1t0IRsL4RC2+9rVNed3XWiBbl9Ph7UZTsFI=;
	b=LjfU+/pmfIMIbYyQByfnoJcOq7xTtyTZbsiZJWKDV8MxZltuczzzDmz/Oq0sh4WNGzZNsj
	hUzPS0ej7QzU0WeRGrdiaARv65bpQSavULYbO1tVPi6uH33x8liTkKzS41WZEmeXfk8FQz
	QaeW92KYgY+QTMPRx1v1RNPluVFTd54=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-e6SnEphDMHKqzbclgxiG1w-1; Fri,
 10 Jul 2026 12:32:59 -0400
X-MC-Unique: e6SnEphDMHKqzbclgxiG1w-1
X-Mimecast-MFC-AGG-ID: e6SnEphDMHKqzbclgxiG1w_1783701178
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 591741800867;
	Fri, 10 Jul 2026 16:32:58 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDB5B1800661;
	Fri, 10 Jul 2026 16:32:55 +0000 (UTC)
Date: Fri, 10 Jul 2026 18:32:49 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-bufio: fix wrong count calculation in
 dm_bufio_issue_discard
Message-ID: <f8619252-31af-5224-cd74-0dbac2bf7a1e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6q_7omctOfHyQ2HWlPrngPPfdJEBb4jWqh-v22hOJMI_1783701178
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

block_to_sector converts a block number to a sector number and adds
c->start to the result. It is inappropriate to use this function for
converting the number of blocks to a number to sectors because c->start
would be incorrectly added to the result.

Luckily, the only target that uses dm_bufio_issue_discard is dm-ebs,
which sets c->start to 0, so this bug is latent.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: 6fbeb0048e6b ("dm bufio: implement discard")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2026-04-27 19:06:34.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2026-07-10 15:18:11.000000000 +0200
@@ -2238,7 +2238,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))

