Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D99403B1E
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797334; cv=none; b=GFllLTfLywajKLGfQs7M08lCrl9NY+ht+B91r+DG3PlbwbmT+sHMh4KsUdPZ5U8PxGcCOumgU0WdBHYKzCFefnfQ4Nfrd1Gs85x7or/uOMRmBZ3DcDj8ILJ3Hm7ztRRXjUQ3LYOzH2jt9l0ZIuWbq+BmOzGFLNDoAog9xSSNkJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797334; c=relaxed/simple;
	bh=33w97XO6s+JRzBcuO3sMyj/OQhegmxAy9w2Bi1L7Lyg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=a7tVfGAUlPTCoRTXmpr+4cVaeRyck8XiQbrZk65jN8iXBUkELJp0PtOGY4mbYe1Sxt2fgW1cO3PlGaKgtLOMDUKY+lZHl4JnE5W/HuYJCXVp01aupIIMDzvlqxHBKSqaZnWwtAFzUk7fkeDPzR3OHM7GJJAZew+HV2XRcobMOCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMG4PY5Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMG4PY5Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790797331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5c2MHgilJuN8BI0ihD10TE0BHkGDTej8dCNlL/TQWHM=;
	b=SMG4PY5Ys1BXkVzqEUQJpYB9y5G9TOQb+VBJpA+hesZljZVX65g28amwkfBt5G+/oxnFCS
	4LAk3V0Mxo4bzruUpapmgwy3AqlOn/DZ2TDxOXiT+nhvFaZA0rk0AN6vTzuiCzwlwNvp7Q
	eAmN+a9ySi/AaIolvQWGEOXPsCYboZM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-GTWYceTQP_WXuCFPXM2C6Q-1; Wed,
 30 Sep 2026 15:42:07 -0400
X-MC-Unique: GTWYceTQP_WXuCFPXM2C6Q-1
X-Mimecast-MFC-AGG-ID: GTWYceTQP_WXuCFPXM2C6Q_1790797326
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A58CA1954B17;
	Wed, 30 Sep 2026 19:42:06 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CFAA180056E;
	Wed, 30 Sep 2026 19:42:05 +0000 (UTC)
Date: Wed, 30 Sep 2026 21:42:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 4/5] dm-writecache: fix uncommitted_blocks underflow
Message-ID: <5b2f69dd-547b-a95d-0759-f7ed97772e66@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2A68i8TvD0q0zJG1dgXvDL-a_98zZDbzVi_5cwduKG0_1790797326
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-writecache.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -899,8 +899,6 @@ static void writecache_discard(struct dm
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 

