Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629F839BFF9
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773669869; cv=none; b=kiXSmiQb3naubsKCmntOzwwHytGGqARPsw9WQhmPNx+IvbKVesA64Y8K4TNjAtiVCLm0mWN4bnNUQF9DXlLE1bqdL+/3qvBAsI7DbqJuH0736CxHXtbD/0sMHKWzV8KGjuCNUtSUco1mLNQK+xKW2wXzeJ6SDbMbWgenX1pKjJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773669869; c=relaxed/simple;
	bh=vt9tGxLmQ029phejD4+FpG4fjrmaEIn6ay3vKJ2yJMA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=EgLTUpIA5jg6h3yFnVche3t3Vn2Lrpz5Y440OoUMQDMjqjH3LnZLcYj6LPSjEiTJxPVqs5d1nuul3i39ZTM6DYkk2tO1puV+Hdc7/P/G225V+VnUvkPajJmhJv3qxq33aBdZ+mh6sfvIGihIr/AZhqK9yMiPtAkpzy9OjDkFlYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFHtqaCG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFHtqaCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773669867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=cl7Ut20tei9OI7fQ1tVv+eO+itQbgPrtE8ePmD599S4=;
	b=KFHtqaCGuPKxLHX6sgVuXfTh+2VmgrTNaOESXPwP/6wiPllSN3UhWAxYKAljyuCnAkaNN5
	nQxGPWlNisGpz9soHL6VZBDCAxciUPZtrMcmOEX2vOgi2mxr2H8bAVXbhHGZd+0sd+1JAt
	4moJ4dVJTdnSQaTIQsR6ZsDq/kUdb50=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-10JwcZQEOw2vOZJMKpET6w-1; Mon,
 16 Mar 2026 10:04:24 -0400
X-MC-Unique: 10JwcZQEOw2vOZJMKpET6w-1
X-Mimecast-MFC-AGG-ID: 10JwcZQEOw2vOZJMKpET6w_1773669863
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE5DA1944DD2;
	Mon, 16 Mar 2026 14:04:22 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A0221800107;
	Mon, 16 Mar 2026 14:04:20 +0000 (UTC)
Date: Mon, 16 Mar 2026 15:04:15 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: don't report warning when doing deferred remove
Message-ID: <bbe915c1-396e-94a7-cf7f-9f23a2fadb36@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sPT0ik4Tt21R3LNAXQ6eip0K_A9e_S2XYRZT34ILXXo_1773669863
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")

---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-02-23 19:31:52.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-03-16 14:37:37.000000000 +0100
@@ -384,7 +384,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 

