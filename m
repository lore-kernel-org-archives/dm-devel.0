Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20A145B11
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 19:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970687; cv=none; b=AKW6rQ4UPuI+eJYQ5swUbVRAYKvWkg5CVUUmkhPIF1EMGhp97xpxcQjSAvQpsKo4j4xn8l/+djx/wEdkLBuuPnYxXvizLUkn6/vJvWbzvDCeUh6uzFVR8S9aHTu1DS2MQScmsgB0xDQFmL+nFLk3BmhYbkSfA3MftpcgtDvXUnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970687; c=relaxed/simple;
	bh=WvjstLf+KGPD8snagiTxe/ygja4Gxv5AYXOqkEju+Tg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=HvnH98g7jTMRI/OuBsThI9pMCNjXYHMx8nju4IQIh7kC/RvqXyRB45jiAQnTpi1xnnq1oqOGyNbPlkix+2cVrWvHWKXvpG5KTyOF4WHjXwwRKu/eidkAVjCIS7Ec5YdZ0b3Z4IpRWmst94qjp0V/TrOZU3Cm87NrOKvnkqvtSRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=akYqfvkn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akYqfvkn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783970685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=8P+JqHMLNrA08v0lmL6WHOsXTparuUm/BE8Z9tbM68s=;
	b=akYqfvkn3hBENKWMEezvdAeYU6Uq1ALTu4OLjC1nDrJPjfwOH60oc4onJs2d0zI09s98KE
	yKaaMj/hPPdxPQEm1BVz2lT9zk/PPegtBMYFHeyIGAapEyodDimOh1sFPbrdbAuCN77h0+
	PhlsNZO02J/fONVU1KSFQB/sL/tMrxs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-324-AEsCcMn6OTOzarbfavIJJw-1; Mon,
 13 Jul 2026 15:24:43 -0400
X-MC-Unique: AEsCcMn6OTOzarbfavIJJw-1
X-Mimecast-MFC-AGG-ID: AEsCcMn6OTOzarbfavIJJw_1783970682
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1C8B1800576;
	Mon, 13 Jul 2026 19:24:42 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66ED81800595;
	Mon, 13 Jul 2026 19:24:41 +0000 (UTC)
Date: Mon, 13 Jul 2026 21:24:38 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix wrong fallthrough in integrity_bio_wait
Message-ID: <0927bc98-95e5-954d-cf9d-d858f054ee9c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xL8KwsF7HdQ2i074fFFmUSdSce_kaIeIUScEgGoFoaQ_1783970682
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_integrity_map_inline returned DM_MAPIO_KILL, the code would set
status BLK_STS_IOERR and then incorrectly fall through and submit the
bio. Luckily, dm_integrity_map_inline can't return DM_MAPIO_KILL at this
point, so the bug is just theoretical.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6

---
 drivers/md/dm-integrity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-07-13 21:00:46.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-07-13 21:00:46.000000000 +0200
@@ -2782,7 +2782,8 @@ static void integrity_bio_wait(struct wo
 		switch (r) {
 			case DM_MAPIO_KILL:
 				bio->bi_status = BLK_STS_IOERR;
-				fallthrough;
+				bio_endio(bio);
+				return;
 			case DM_MAPIO_REMAPPED:
 				submit_bio_noacct(bio);
 				fallthrough;

