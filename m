Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83651378D77
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831577; cv=none; b=MbmWwdDlrxbt4Jn/dAmRGIAm2r/2C+qrZghob9SuSX0MyxAM5pKjfy+yyGsl9EwJDo+F+spxBP4/04kGGTTijKOhLkUn6i3Ll32hmZfQCmqGKYmohr2kiC7P0si3J0NEAsIEh01iAlxZoKyEmpAMYByXFfxbITGGEZ9lYhIW68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831577; c=relaxed/simple;
	bh=RsR93PcsZIKOMA8BgcA0+hvvShf6Ot8VuNi5wU18Nog=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=YCVroIpMXBfl5w6a17mT6i66Zhec64OrqcNTroQfuTZohvgx9/7Euy87KrPNvbfQ5RXh6pRf8cBJtnhzefhfywjaTInSE7xBK9wcP1/X3VNsivcusBh9Umg61s6wIVokbe3WibwAT/I6z33aJw2p66rBtW4GUOCqhwdOYC0kHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VM3FC4PV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VM3FC4PV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768831572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wQ435I3KwXD+ip22/eNP4psZTujJv8QByglKv/EYHEw=;
	b=VM3FC4PV0oo8986KuoSUWgSkO3P0nolv4zzsiL7zgFtgWBoWK6Tj99q/LPWNy1qrrjlZNI
	JcsQ7GZoeoxDDR2accl9OlXW1XGyg8qv1cmzJyXPz2uBLp6xCvSdb/MStObCKYtcA61Ft9
	vTXOqqd9MTV+XUwup4Y/6O/3jfynGlo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-fVZhzHKeNPePEzy_GqSuTA-1; Mon,
 19 Jan 2026 09:06:10 -0500
X-MC-Unique: fVZhzHKeNPePEzy_GqSuTA-1
X-Mimecast-MFC-AGG-ID: fVZhzHKeNPePEzy_GqSuTA_1768831569
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87198180047F;
	Mon, 19 Jan 2026 14:06:09 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80FFB1800577;
	Mon, 19 Jan 2026 14:06:07 +0000 (UTC)
Date: Mon, 19 Jan 2026 15:06:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix recalculation in bitmap mode
Message-ID: <951dcc10-c271-a257-84d5-81362e81e2b4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fPpRAazm8z_obH5AJYIJP4CPmWaWFk21GOHNGt-voqQ_1768831569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's a logic quirk in the handling of suspend in the bitmap mode:

This is the sequence of calls if we are reloading a dm-integrity table:
* dm_integrity_ctr reads a superblock with the flag SB_FLAG_DIRTY_BITMAP
  set.
* dm_integrity_postsuspend initializes a journal and clears the flag
  SB_FLAG_DIRTY_BITMAP.
* dm_integrity_resume sees the superblock with SB_FLAG_DIRTY_BITMAP set -
  thus it interprets the journal as if it were a bitmap.

This quirk causes recalculation problem if the user increases the size of
the device in the bitmap mode.

Fix this by reading a fresh copy on the superblock in
dm_integrity_resume. This commit also fixes another logic quirk - the
branch that sets bitmap bits if the device was extended should only be
executed if the flag SB_FLAG_DIRTY_BITMAP is set.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-01-16 08:54:47.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2026-01-16 17:17:06.000000000 +0100
@@ -3788,14 +3788,27 @@ static void dm_integrity_resume(struct d
 	struct dm_integrity_c *ic = ti->private;
 	__u64 old_provided_data_sectors = le64_to_cpu(ic->sb->provided_data_sectors);
 	int r;
+	__le32 flags;
 
 	DEBUG_print("resume\n");
 
 	ic->wrote_to_journal = false;
 
+	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING);
+	r = sync_rw_sb(ic, REQ_OP_READ);
+	if (r)
+		dm_integrity_io_error(ic, "reading superblock", r);
+	if ((ic->sb->flags & flags) != flags) {
+		ic->sb->flags |= flags;
+		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+	}
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&
+		    ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP) &&
 		    ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit) {
 			rw_journal_sectors(ic, REQ_OP_READ, 0,
 					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);

