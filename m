Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9321F156644
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713210571; cv=none; b=A9TbDCYkH2GFVuixVTKkWMuKjQbT951w/TaUAGnMpw7n0UTqXZ7CzCiouQi2wn1s87rrWBi5i3fDATAK2wOsFllgfI7fgv4nZ0FL6GqMxwf3RAS1DPwTJaPCuALEB4nVEmq1cDxTXbb6L4/g2pPTneHU8TwMLfBG7ngqmvmisq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713210571; c=relaxed/simple;
	bh=NFbCstpZ5RRgQEDVh+ETz0L+LNvbESu1uz/39Ycxj8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IZhK6IVOBMN+6PqQFmdYYE+ZI6hJOEjumeNTWx1a6m04GKJ+QPkZicToIIXCyrUyZUrKzzBS2VQZBTZ2HfQebBiisPZWy3IMfK8/TfOUTkqOLWDiJ/yyBcZ4xQgtg5ZFwZOsYa90H1txITkRAi38Ijs/Z/hlHYkVKBEVCHtVNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mfh9fpZu; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mfh9fpZu"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VJHn606g5z6Cnk8t;
	Mon, 15 Apr 2024 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1713210565; x=1715802566; bh=zl8tqsLft0ikguPVXC2WkShAIfWKvvycaTJ
	nEdM0E30=; b=Mfh9fpZuOT95cXW3XOhoZVTxPa2QcW1WtWNFgOx5UBlxETZNPBr
	bbANgKamnaELAK6yk9fpMwYcukKy0V2kns/3HWORFlm91iht4Hfhi57cY4dn8e8q
	O4SUtHGCMDw05CUOjpWhU1tJ7HrmiPur2KgWIvJnIe7c2S39VHFiA7+whCRSHrVg
	yoo5kMnv354dKzJIdKLjeA4icqRx/UH6+GTz7cVcjCD0EqgC4ttgmmdGuu7+6iQC
	TFEahrMxIMoj6O+rslu/2Hb+Yo13cljYzNddDealebFY2MCFE2sceP6M2i2o1w/C
	lPJ4zRdxF8NFDUx4LHgNKgH25zU8wCdL73Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Kg_uBXSKOTAy; Mon, 15 Apr 2024 19:49:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VJHn05PZqz6Cnk8m;
	Mon, 15 Apr 2024 19:49:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Daniel Lee <chullee@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] dm: Change the default value of rq_affinity from 0 into 1
Date: Mon, 15 Apr 2024 12:49:21 -0700
Message-ID: <20240415194921.6404-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The following behavior is inconsistent:
* For request-based dm queues the default value of rq_affinity is 1.
* For bio-based dm queues the default value of rq_affinity is 0.

The default value for request-based dm queues is 1 because of the followi=
ng
code in blk_mq_init_allocated_queue():

    q->queue_flags |=3D QUEUE_FLAG_MQ_DEFAULT;

From <linux/blkdev.h>:

    #define QUEUE_FLAG_MQ_DEFAULT ((1UL << QUEUE_FLAG_IO_STAT) |	\
				   (1UL << QUEUE_FLAG_SAME_COMP) |	\
				   (1UL << QUEUE_FLAG_NOWAIT))

The default value of rq_affinity for bio-based dm queues is 0 because the
dm alloc_dev() function does not set any of the QUEUE_FLAG_SAME_* flags. =
I
think the different default values are the result of an oversight when
blk-mq support was added in the device mapper code. Hence this patch that
changes the default value of rq_affinity from 0 to 1 for bio-based dm
queues.

This patch reduces the boot time from 12.23 to 12.20 seconds on my test
setup, a Pixel 2023 development board. The storage controller on that tes=
t
setup supports a single completion interrupt and hence benefits from
redirecting I/O completions to a CPU core that is closer to the submitter=
.

Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Daniel Lee <chullee@google.com>
Cc: stable@vger.kernel.org
Fixes: bfebd1cdb497 ("dm: add full blk-mq support to request-based DM")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56aa2a8b9d71..9af216c11cf7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2106,6 +2106,7 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ERR(md->disk))
 		goto bad;
 	md->queue =3D md->disk->queue;
+	blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, md->queue);
=20
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
