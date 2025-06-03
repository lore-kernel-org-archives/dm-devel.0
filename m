Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F7FC2E0
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748969608; cv=none; b=Vwr6B6U3rzgVG8MzaosWt2FbfnL24vN9Ry56O6+31kRDOxEResPHKJOC6gw1L2w8sdh+fAq9MWWTrycXxgKxTCHvsa64+Zl6LBZkQm4I1ArTlZcEEL+piItzmx8UDynr+KAy3ZoaofD9AU9kRazjuusgivfR/4XK+VoT2i43uhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748969608; c=relaxed/simple;
	bh=n9ZByok2skatzCCBLvdB2Peth4kN2044JVS7cs/1nYc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=FrufKPxEpJS+32u18iuFS56+ojnuXFmc64oJc13JVuAw94+/2xzjf3mG4oEeByRDTa2616zIu52RyEEHM1S0HtAioqyD/jVaIWlsNEjhtjOrua9MI7P8+SOEv4S6KRyoo19MirPy4GVhRPdXqspJFzFXUsT1O+oT5PsQ6lRIvic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JweXXwjZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JweXXwjZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748969605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ZRRc7bc/3E3mCLSG2+ZVbV7MXgDorb7IM7mVVzQuAEc=;
	b=JweXXwjZ4e7lNLQ8piLaVd3Y2MamTPR5rowDFMGjyH6GFuKHuJnkLlkdPKPmiyp1HHn0DM
	vHSwM7UXgV+qJNSFclpbvH+jzfcfuOc2RWX43pIGd7wAtVt6SkqdMDVvXb8wVihWnk3OXF
	KipcVOIBFpipdgSZo5K1+Z/zWmgwjc8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-251-gO_3xQ2jOdiWyStR_GQoxA-1; Tue,
 03 Jun 2025 12:53:24 -0400
X-MC-Unique: gO_3xQ2jOdiWyStR_GQoxA-1
X-Mimecast-MFC-AGG-ID: gO_3xQ2jOdiWyStR_GQoxA_1748969603
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CB8F18001D6;
	Tue,  3 Jun 2025 16:53:23 +0000 (UTC)
Received: from [10.22.80.20] (unknown [10.22.80.20])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EDE018003FC;
	Tue,  3 Jun 2025 16:53:21 +0000 (UTC)
Date: Tue, 3 Jun 2025 18:53:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm-mirror: fix a tiny race condition
Message-ID: <7a6f9601-931e-ea00-9aa7-af0d3b1b3ba7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HJ8sSOA4DpE_empHMEG0gg7R57-7B3f4TM9cELnwoRg_1748969603
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's a tiny race condition in dm-mirror. The functions queue_bio and
write_callback grab a spinlock, add a bio to the list, drop the spinlock
and wake up the mirrord thread that processes bios in the list.

It may be possible that the mirrord thread processes the bio just after
spin_unlock_irqrestore is called, before wakeup_mirrord. This spurious
wake-up is normally harmless, however if the device mapper device is
unloaded just after the bio was processed, it may be possible that
wakeup_mirrord(ms) uses invalid "ms" pointer.

Fix this bug by moving wakeup_mirrord inside the spinlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-raid1.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c	2025-04-14 16:01:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid1.c	2025-06-02 14:51:19.000000000 +0200
@@ -133,10 +133,9 @@ static void queue_bio(struct mirror_set
 	spin_lock_irqsave(&ms->lock, flags);
 	should_wake = !(bl->head);
 	bio_list_add(bl, bio);
-	spin_unlock_irqrestore(&ms->lock, flags);
-
 	if (should_wake)
 		wakeup_mirrord(ms);
+	spin_unlock_irqrestore(&ms->lock, flags);
 }
 
 static void dispatch_bios(void *context, struct bio_list *bio_list)
@@ -646,9 +645,9 @@ static void write_callback(unsigned long
 	if (!ms->failures.head)
 		should_wake = 1;
 	bio_list_add(&ms->failures, bio);
-	spin_unlock_irqrestore(&ms->lock, flags);
 	if (should_wake)
 		wakeup_mirrord(ms);
+	spin_unlock_irqrestore(&ms->lock, flags);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)

