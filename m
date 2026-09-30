Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1B64119FA
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 19:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796942; cv=none; b=Cb5uwbk4hSgB85FH2nJEQr4srau+GPinGZe/XXyzcPFDya5hYT2VjdbNcwi0VcMltWCfnWprn18BG1NH4n7kdXg8YaQez9po3G0r0iO0Gh11Ui0/U2B++Lq7+cbnSmVSqYbKoXq3YapXqqi3/mm6CCx04KtbyF8mE61ZOULuUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796942; c=relaxed/simple;
	bh=2Gkn/h2iEqoG6jUOfUZVvm6XJd0AGTHFi7Zm9wAMtPE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=SqjSaaSvpgiYOlNZyZ2B0/YP1yygi9mfk5asdP/WCye+8IwIbbJXf3w61H2dENqWjW6f5tuLBKU82yo4jvmnjHR4NHzqixHvdVp2lHrxRqEwUnLem6he/i5AXLpTB7UIcKeXhNyWv1vuv5uQ7V37mhkRLOR9m2Hnc5E1a/SvNT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gLSbJUP5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gLSbJUP5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790796939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=xEkT4vRC9b6VikE5fa+kfHE+PxOmrP1y9Cc4gbkbq7o=;
	b=gLSbJUP51JhUY8WiNFIEtrfXpL+dxXaGrwI8S2B+8TySWlJ+udFFje7Xx0A+A+NsbFDXVi
	RyjC9Tyg1T78tLf/XWaYyuogX4rSz4SmGCUIPRlB5vh9jbnjlrwVcEaa0b/A/PftG3NLFn
	tCQukdxWr5dnspqPL2Rhyzkczntg3y8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-eZadIMCVM--zF56totmLeg-1; Wed,
 30 Sep 2026 15:35:36 -0400
X-MC-Unique: eZadIMCVM--zF56totmLeg-1
X-Mimecast-MFC-AGG-ID: eZadIMCVM--zF56totmLeg_1790796935
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 424401840C55;
	Wed, 30 Sep 2026 19:35:35 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4D4D418;
	Wed, 30 Sep 2026 19:35:33 +0000 (UTC)
Date: Wed, 30 Sep 2026 21:35:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: fix a bug in dm_accept_partial_bio
Message-ID: <8acbc139-1284-b505-dd15-bbec1aec06e2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KubcDt1LjDsbglVxmUUBHIxEGLAPiaJyuFmGDp-D0VU_1790796935
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

dm-writecache doesn't work in pmem mode - mkfs.ext4 and the following
fsck.ext4 fail with data corruption reported.

The commit 7dd76d1feec7 ("dm: improve bio splitting and associated IO
accounting") introduced a latent bug in dm_accept_partial_bio - it set
tio->io->sectors = n_sectors;. This is incorrect, according to the
diagram in the source code at dm_accept_partial_bio, it should be the
size of regions 1+2, not the region 2 alone.

The latent bug become real bug with the commit 8b211aaccb91 ("dm: add two
stage requeue mechanism").

dm-writecache in pmem mode is the only target that actually advances bio
with bio_advance and then calls dm_accept_partial_bio (so, the region 1
is non-empty). All the other targets call dm_accept_partial_bio with
region 1 empty, so bug went unnoticed for so long.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 8b211aaccb91 ("dm: add two stage requeue mechanism")

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1350,7 +1350,7 @@ void dm_accept_partial_bio(struct bio *b
 	 * for accounting but it is being reduced so update accordingly.
 	 */
 	dm_io_set_flag(io, DM_IO_WAS_SPLIT);
-	io->sectors = n_sectors;
+	io->sectors = *tio->len_ptr;
 	io->sector_offset = bio_sectors(io->orig_bio);
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);

