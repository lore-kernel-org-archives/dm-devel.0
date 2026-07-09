Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236163B9933
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625362; cv=none; b=cQ3h7Y0QUZ30BjEvmfGstROJvgKO2pJPNpRkyXjeLhSe67OZxTRbBbpCrYADRBRYmXYxmQew/6UIvnt8iQHZRj9Z66NQ1hmflnDow5Ithg+0Hnh3upPgmF8+IT6T4A9+0eLvol6Kj+O8+R5xYlOA8zsMXeTPzVhbjxIArt8761I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625362; c=relaxed/simple;
	bh=RtcP2UmRHp7o8Z3KvNsfc1j7/Wq9miZxJbCL/Ful8H0=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=kK5RJbFw7+v/M49SiCMnrd9MWOSjNoEgFW9WIbcUTSmDl66LrDApckQbFdVk/khd1vQ0fTTanwQBjHyWKqcIequlLNF70ttOqpEKtQkQbetPZPeG8kqQihU1twz7PZaJ5aWRAHy92ZDpEQPWZOP2HGMoxDm5jiD9x+for+Oo5uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQ2B3h0l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQ2B3h0l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=HcRAGawGteDfiek6lvO8GCM23P5iO71+efQN/uiFqXo=;
	b=BQ2B3h0lCf2INZ+HrqRzU8jhEGeVK4ythXlyczpZ7nn032qylkSu238ME8D0Zuu0/Plclo
	RecMoywTut4FZApeioZ78543j4SuOrcqEO89ORaNC3Uf8Q36piW58f1Lzu9iLPQGT9BGB5
	ktbRBGIF82jMv1ciEojmbt0pENtzkyE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-zw870jNYNluJSa9taMvwkg-1; Thu,
 09 Jul 2026 15:29:18 -0400
X-MC-Unique: zw870jNYNluJSa9taMvwkg-1
X-Mimecast-MFC-AGG-ID: zw870jNYNluJSa9taMvwkg_1783625357
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B742918052D8;
	Thu,  9 Jul 2026 19:29:17 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7998F180058F;
	Thu,  9 Jul 2026 19:29:16 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:29:11 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm_early_create: fix freeing used table on dm_resume
 failure
Message-ID: <de1c4d6b-fc26-9d83-225b-ad3f7a7b9b33@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jqSishMA4tb8ZND6AtdVZKixOQ-keBuOTQ_nveCsnt8_1783625357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_resume fails, the kernel attempts to free table with
dm_table_destroy, but the table was already instantiated with
dm_swap_table. This commit skips the call to dm_table_destroy in this
case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-05-25 11:06:07.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-06-23 12:59:17.000000000 +0200
@@ -2387,7 +2387,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);

