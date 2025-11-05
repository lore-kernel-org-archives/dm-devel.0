Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F846221269
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354946; cv=none; b=YeqfBnuIKOgBuTgRZdlkuj5J3nbRSswZX4UNAD2qx6Ucz00FJ2PWZRaivTyzos5glPjosDBU7g7/Nl/rfOHdYnx9M+NoSb6n5i5U8PeIL10LQQzlBsbWsu/Qkwhm/bZaqBYseKo83Z2sUrfQtvpyZqO9cPGsHk0IlB2NEFFst+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354946; c=relaxed/simple;
	bh=KtiuOwa9eTErc3AYIl9H6xV+DPCpoCOxr/wiZyOVrU0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=btFEFAHXA0WDysb7xoxwV2Qh4zqYpODDdV2mOelH/esc0emjdUUT1PLGs5qjBQsV+uCJzkBVFcPnGnkibqTYNd0rB8Hytvls2HBFpbMY86d1v0cjWGEXz+P7szhwMAsQj+q1Mb5BLFmj0DCWL1v4c2v6jEC67ITUchMSMyYntHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQo5Zk8e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQo5Zk8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762354943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=CMBmq6bwVg86963BFywA1HPHWJ4O2UqqnK1nfIyJZgE=;
	b=HQo5Zk8ethTVGyrwH1Kc5CVoE7Ti5aarvB0dUTCerUg+auSkS8wMvSJL2DRu/osPnhV3R3
	SWy2M0kBDSrg1vx6vPQaPb08M5R9OWLt9YatAEQOCCMBfIaVgsYLZ2YN1wtEOn2JBLVoQi
	2oHdXjyaJsg442X8dtqKn2wXmxrfdyA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-uKVDQ27sM8quUrHxATmZfA-1; Wed,
 05 Nov 2025 10:02:20 -0500
X-MC-Unique: uKVDQ27sM8quUrHxATmZfA-1
X-Mimecast-MFC-AGG-ID: uKVDQ27sM8quUrHxATmZfA_1762354935
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D14901829E2C;
	Wed,  5 Nov 2025 15:01:37 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBCAB19560B2;
	Wed,  5 Nov 2025 15:01:35 +0000 (UTC)
Date: Wed, 5 Nov 2025 16:01:33 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org, 
    dm-devel@lists.linux.dev, michael.christie@oracle.com, 
    martin.petersen@oracle.com
Subject: [PATCH 1/2] dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
Message-ID: <6428d43a-ded8-c368-2057-39620bdf8546@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JsAZ-ZjmktqpTYt7Kpc6s1ZOqjZuBJBDJcDI4NL-5Y0_1762354935
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Any bio with REQ_ATOMIC flag set should never be split or partially
completed, so BUG_ON() on this scenario in dm_accept_partial_bio() (whose
intent is to allow partial completions).

Also, we must reject atomic bio to targets that don't support them,
otherwise this BUG could could be triggered by stray bios that have the
REQ_ATOMIC set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2025-10-13 21:42:47.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2025-11-05 14:43:32.000000000 +0100
@@ -1321,6 +1321,7 @@ void dm_accept_partial_bio(struct bio *b
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 	BUG_ON(bio_sectors > *tio->len_ptr);
 	BUG_ON(n_sectors > bio_sectors);
+	BUG_ON(bio->bi_opf & REQ_ATOMIC);
 
 	if (static_branch_unlikely(&zoned_enabled) &&
 	    unlikely(bdev_is_zoned(bio->bi_bdev))) {
@@ -1735,8 +1736,12 @@ static blk_status_t __split_and_process_
 	ci->submit_as_polled = !!(ci->bio->bi_opf & REQ_POLLED);
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
-	if (ci->bio->bi_opf & REQ_ATOMIC && len != ci->sector_count)
-		return BLK_STS_IOERR;
+	if (ci->bio->bi_opf & REQ_ATOMIC) {
+		if (unlikely(!dm_target_supports_atomic_writes(ti->type)))
+			return BLK_STS_IOERR;
+		if (unlikely(len != ci->sector_count))
+			return BLK_STS_IOERR;
+	}
 
 	setup_split_accounting(ci, len);
 

