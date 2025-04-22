Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D2FB666
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 19:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745349524; cv=none; b=YWI5t37Y5FSONBfHH28sBu6DQAh6RbshnnftzaIeE1TgkPF3p3FABdND3VWCnCoNn5OosrV5qrBv9jdlo+p3iZ17h3HhS3lC8nfDGB0zXk6n8QcogqgIOLpkKxL8+IVtV6x3/b/GtDBlzMczwxKSWq+Qzt6R0Smx45kSa6NW+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745349524; c=relaxed/simple;
	bh=N1ixLMwqc99Mr+Qz0nXFrSdhQp4NJBWSd6jPODxLqZw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=LVle75Xf8Sb1WUO14/Yrs/6Y/1otuncXotcM2DvmprB+Xk2m31kHlM5GKZUi4F2Z46BmBx0GPgeOrvLKdIrtg8ANNmfhRm9lsJryYWCgHZ58sNlDqUm6sjAIPPJALOn7lHoY/aeCk/bjo1WUY0fHpTIypAO3G4JUYv5QWTJ1Hm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MqeaFt51; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MqeaFt51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745349521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=VnWhcM59tzt+ug96x0hFxjQeDqxcxQVI37fNX4Mm5ew=;
	b=MqeaFt51VklW3GUKVhDfF8DCRb6pIcKGamBpEx6A4BsHHuyVPrtXv1NFlw8uB5+Y0SREq9
	eS2TDjO1p1PIbkGHBdAlFXATy0ePj+vUgGD77d2bL3OK0McgOxjCpS8E1BVjOxwuyUNig/
	7UBNXoATBZr3nWSo42CK93BWZWr/DIM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-5nP5OUy6MGu-4XnvVim6gQ-1; Tue,
 22 Apr 2025 15:18:37 -0400
X-MC-Unique: 5nP5OUy6MGu-4XnvVim6gQ-1
X-Mimecast-MFC-AGG-ID: 5nP5OUy6MGu-4XnvVim6gQ_1745349517
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D50B81956095;
	Tue, 22 Apr 2025 19:18:36 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF5E918001D7;
	Tue, 22 Apr 2025 19:18:35 +0000 (UTC)
Date: Tue, 22 Apr 2025 21:18:33 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH]dm-integrity: fix a warning on invalid table line
Message-ID: <5285dddb-3e16-15ac-bf15-48177ab5ef30@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 48qR48OtlSqi4k_V7o1GJE6yj8bJmWxfBuxeKVCYvB4_1745349517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If we use the 'B' mode and we have an invalit table line,
cancel_delayed_work_sync would trigger a warning. This commit avoids the
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-04-14 16:02:07.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-04-14 16:02:07.000000000 +0200
@@ -5164,7 +5164,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);

