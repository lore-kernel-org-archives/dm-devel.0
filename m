Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADF8145B11
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 19:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970655; cv=none; b=iQMLsTryURp2EQrCo7C5VQ+ZaIM+zJpaGm3Xlw44Uhk7EXLVNOkJuKNgyhac0XIaJXAsDCAPy3vnGYUrQzsdILrz5urbZoVF7URNruS25AvONg95N+T8owKQ5URWg/0jpGggUw58rAe56nLmfBpDxQ7uwNZ4c6i/oeV2kIFnpIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970655; c=relaxed/simple;
	bh=RwZbYatIfbDv8CxmqRAXthVm/c3FwjSbmIl8byZvqGM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=qY2V+OjICbkW/Hchgdcp7ia5NQq71QVvNSwUH7t9Qb3qAEKzpUrz1+d/MpjwBPy3t6KOrv51KhqNLknrwDSpTpwM7MOb1qSRU+afOtQ2JIOhFlO59zXmFWshNu9f/FkxeF1lIrGC+yq9FgmDd/5Z6i8GdOhGZxeRerq/7xHYD/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cEfffnXx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cEfffnXx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783970653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=3NXaf3Q/yuTRylbjzgExkLGFjCuHGCHyVpaIZRSyiO4=;
	b=cEfffnXxHd4/+9lV/vhM7GnuFpwSs42vWKYl6yAwav16my8crEKBWpx+29Qb3ZpXRxeidU
	MtbXKlQI7y6SjW5GgOuBprVkqHpEk98Mx/Ooa9/ot6ee4dWIFha/E/YcKe3Ix+5ryHjS/Q
	yi4tqo58uWP/xM/pooMNWSzWwJPjzX8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-K2dI9UxxNCWVTOtrX3ZpuQ-1; Mon,
 13 Jul 2026 15:24:10 -0400
X-MC-Unique: K2dI9UxxNCWVTOtrX3ZpuQ-1
X-Mimecast-MFC-AGG-ID: K2dI9UxxNCWVTOtrX3ZpuQ_1783970649
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EB8D195608C;
	Mon, 13 Jul 2026 19:24:09 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C39B5765;
	Mon, 13 Jul 2026 19:24:07 +0000 (UTC)
Date: Mon, 13 Jul 2026 21:24:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: clean-up error handling
Message-ID: <8ed036c6-7d03-9517-be95-1a8f6e29fcb7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oxtOlyriuGTOxNdp-WrLiJtW3Xh6lm8pL5xZg6JVElc_1783970649
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Add "goto bad" to error handling. This commit doesn't fix any bug, just
cleans up the code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6

---
 drivers/md/dm-integrity.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-07-13 20:59:52.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-07-13 20:59:52.000000000 +0200
@@ -4634,6 +4634,7 @@ retest_commit_id:
 	if (!ic->journal_tree) {
 		*error = "Could not allocate memory for journal tree";
 		r = -ENOMEM;
+		goto bad;
 	}
 bad:
 	kfree(crypt_data);

