Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F423B3B2FE4
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625149; cv=none; b=NvIvXVW6118pjgDeWhEj+RyNoXU9OR7FOk6kksrei+j5XT+lhWdWG6iKIrgyd5jLu5OPupb2fny2vuGcuiTEoMNbGRFZMJsP1Dx/VJVW3ROmv/SzWz5+zBgK1+iDMpaCdPggUHd3WdcaJzuVrqX6Mmg/qkyBg0+Eyzoc/kleP/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625149; c=relaxed/simple;
	bh=1UxAJKsFMNNRuW6wR0GeIY/ScsI3rmF9Ag5sgde1rzM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=k6ea10lfI1A1PElq4Hmw2w/uPZRN/8Piz1QTaNsKo/GWveqqI3NldSztHB0tLJX6zOL2b6MWhkWrDUAAD43l7rn7w8R2uiE3TQo/1Hw6jyM+nW6BmhhCzsTKx94ifA3dQeFhPTybQxTTUtpT/zLfS5DUI5QprrR5Fzzgxp+hBDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NSAAAwEI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NSAAAwEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=v7oHW1nmOUPJQSpvuAhyjwdqDoqghVAKUx23LLOCx0Y=;
	b=NSAAAwEIZonHd4xQ+JMgSb9M3cokDajVAhqYxIQJut2t32cfJKJ/Lz7Tx9/O7vQJB3JOXa
	JQXVfrGfJHwRmk5owQdaDFt0P2iCHoRIZEawEzHO3pA39w/cSPOmhXKA4R8L7VAHKg5ni/
	7urVNUwbRKM8uMvBSgs5jrBOyiCNxR0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-FU-tSBaTMyWN5XxxvOvIUg-1; Thu,
 09 Jul 2026 15:25:43 -0400
X-MC-Unique: FU-tSBaTMyWN5XxxvOvIUg-1
X-Mimecast-MFC-AGG-ID: FU-tSBaTMyWN5XxxvOvIUg_1783625142
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C109D18001F0;
	Thu,  9 Jul 2026 19:25:42 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CFF4180058F;
	Thu,  9 Jul 2026 19:25:41 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:25:39 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix a bug if the bio is out of limits
Message-ID: <2e2367ae-d49b-162b-6352-30868ddfd931@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tb9uB3k7SR9qJOREq21vvHhcN7P7wQ__SPiSP4L-ACY_1783625142
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_integrity_check_limits fails, the code would exit with
DM_MAPIO_KILL. However, the range would be already locked at this point,
and it wouldn't be unlocked, resulting in a deadlock. Let's move the
limit check up, so that when it exits, no resources are leaked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-06-29 17:58:18.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-06-29 17:58:18.000000000 +0200
@@ -2520,6 +2520,9 @@ static int dm_integrity_map_inline(struc
 	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0))
 		return DM_MAPIO_REMAPPED;
 
+	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio)))
+		return DM_MAPIO_KILL;
+
 retry:
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
@@ -2584,10 +2587,6 @@ skip_spinlock:
 
 	dio->bio_details.bi_iter = bio->bi_iter;
 
-	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio))) {
-		return DM_MAPIO_KILL;
-	}
-
 	bio->bi_iter.bi_sector += ic->start + SB_SECTORS;
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);

