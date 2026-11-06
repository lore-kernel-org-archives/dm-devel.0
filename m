Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990525;
	b=GOQLUKUBxAtGY+IzQwSKs7Eui8pFDYRLLFkNwDdiXha3bTLw/+0K68Ndqgert/j1+vFX
	 7Aie3lfJywry27yER5DLzhLjFxozXhvtJD9vZp7RA4Ee3mCOiQVdoBXqEqdvY0BhGIsAd
	 ncacMQnV+c5lxUojU9yJxd1mE4lM09uQeyRy/A3JDwolcDXXBwiV8RVxWjRohtgizT6El
	 59ZTv1OMlVksNX0g5Ha1D7ZmRH5smY4BxioTR+UgC924l8TqGnwOWMt5oYwgBcSJXiVlt
	 jgghLH0lh4URD9m+OJiBa/fYTe79hnGV78r74fVT3/UaTPhknvfcZvfrP/XFO8Ad+sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990525;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=iUb8tvfmvHbUoe+XXErAG/FGAXKePqfJCYG2Y0WYqgo=;
	b=lsaZmbPHOPNzHQQD3EudkqnHWhei2Lp3XQ43f2gE/tD92HGzexqWPl+KZ6UQjqsghxHo
	 5wdXIvEXiBmY8Nd0P6IJkKy4hVYHkXpon93stZGC/4E5cM7BJdhG3XtBOlQeTXWteT1dm
	 WtFe+KKffRBe7zgfVDZhrxeuWxvm4M9h/p+oPt73g+pBqlUntqaJz9RJ1bd+Br2QYhdNU
	 z5aE9G5AAE5iUKxAOXiZsO2Bsif56I6jQF7uaa6BIBmsSi88E+eUlDdoockVef3YvyqI8
	 A+CRv81DKVKSGvAMiaiaKxP/zsylchlzuXfsEMn6xHd9PIFMz7EYlfpUDV6AH7rZfGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iPoaXQkN;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2615606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:42:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2615606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iPoaXQkN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=iUb8tvfmvHbUoe+XXErAG/FGAXKePqfJCYG2Y0WYqgo=;
	b=iPoaXQkNuHQyYmJxnVyfR6XS9bADODiS7GZyHEBbvDBo+mxz0movSfYR2b5NDLm4kZa2r0
	uTZh31oSlYG1/Kg9lUlaOph/PUy2DOkrw/rGM/SgJS4i2r7USp0Tno2uF30rie8XOSzNuc
	QJtz8kZzoPAtw6kBOBPKrlu5ca+E5hk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-RGNR-lUQOrWzIr2uPYEecg-1; Fri,
 06 Nov 2026 13:42:00 -0500
X-MC-Unique: RGNR-lUQOrWzIr2uPYEecg-1
X-Mimecast-MFC-AGG-ID: RGNR-lUQOrWzIr2uPYEecg_1793990519
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A9881944B16;
	Fri,  6 Nov 2026 18:41:59 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 229B018002B7;
	Fri,  6 Nov 2026 18:41:57 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:41:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-thin: fix data corruption if discard races with regular
 I/O
Message-ID: <301e4823-da9f-0a00-7fed-04ed8483aa10@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bWui104vyX59WPN-sljTV3dEyKDpjzp9YjjFep_ruMw_1793990519
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

In the function break_up_discard_bio, if a discard hits the same block as
regular I/O, it was intended to skip the discard for the affected range.
However, the skip code only advances "data_begin", it doesn't advance
"virt_begin". So, the data_begin and virt_begin variables become
unsynchronized.

process_prepared_discard_passdown_pt1 calculates "data_end =
m->data_block + (m->virt_end - m->virt_begin);" - if m->data_block is
incremented and m->virt_begin isn't, it will overshoot the intended
discard range.

Cc: stable@vger.kernel.org
Fixes: e2dd8aca2d76 ("dm bio prison v1: improve concurrent IO performance")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c
+++ linux-2.6/drivers/md/dm-thin.c
@@ -1703,6 +1703,7 @@ static void break_up_discard_bio(struct
 			(void) build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
 			if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
 				/* contention, we'll give up with this range */
+				virt_begin += len;
 				data_begin += len;
 				continue;
 			}

