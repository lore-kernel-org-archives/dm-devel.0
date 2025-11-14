Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458533EB13
	for <dm-devel@lists.linux.dev>; Fri, 14 Nov 2025 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763135657; cv=none; b=XvAwc67ca4AfZzevIaVlX0fH7cEU1acAq1VUCqTGR8jjr0rnDPc5pDqrYXOlAU8bMZcdBOnm1GeN+dhkIZq64pLXjjIpIlKdxd5frv2nWVDPpnbCULN3P1SO9hXpletz7+zzom0IEoQIVJOFxu7bgsc8jIRL24WefClolbWHIL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763135657; c=relaxed/simple;
	bh=tKYye8Al7Iyj+FcXfiybHIL8bQ2RBLmPZA77/TSbPd4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Y2wU7Z//4MMdGRiGWNrHkU+9b4xN862z6P1sQqrjuhCnLmpvuj0BajTyKVkHTVOAAaOWn9zBQ4htVrm8EFhRYFgzoNvEGRmoesaVms1gsh0mZFIy09ch2uFqM/X1FdqHsICkNxfJegBDkSvqa58EMeCvoQYj64N0jmKqaWHOxHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwKggR8H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwKggR8H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763135653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=lrOuZy1jByok6om4UU9Fsl/UGN7hRB55KTaECNvmU9I=;
	b=JwKggR8HubHceoJa30O/3hF5g9BffWMu1Qufy9TRoDRzcUZEoM64o/phsVHvnt9J1cL6Zt
	7dXwWL4vI5lAvkzt+R5jRsoNqKg4WxLjfznPzg/x0HeEVNnY6EX3VbY57aKNn4FMop6x8H
	QM0BHuy4x11LN00X/C26xUmiVKHJJqQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-YZ9m6dSiOPqvy2eIrxWy0g-1; Fri,
 14 Nov 2025 10:54:12 -0500
X-MC-Unique: YZ9m6dSiOPqvy2eIrxWy0g-1
X-Mimecast-MFC-AGG-ID: YZ9m6dSiOPqvy2eIrxWy0g_1763135651
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F66D180048E;
	Fri, 14 Nov 2025 15:54:11 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C69719560B9;
	Fri, 14 Nov 2025 15:54:07 +0000 (UTC)
Date: Fri, 14 Nov 2025 16:54:01 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, Guangwu Zhang <guazhang@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH] dm-verity: disable recursive forward error correction
Message-ID: <75ef45cb-4c00-4b27-87cd-3c2914f5dbcc@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u5gxtIbD6qk_sUekJ6xuL_HGVFARGwzAANcf_6y9Hpk_1763135651
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

What do you think about this patch?

There are two problems with the recursive correction:

1. It may cause denial-of-service. In fec_read_bufs, there is a loop that 
has 253 iterations. For each iteration, we may call verity_hash_for_block 
recursively. There is a limit of 4 nested recursions - that means that 
there may be at most 253^4 (4 billion) iterations. Red Hat QE team 
actually created an image that that pushes dm-verity to this limit - and 
this image just makes the udev-worker process get stuck in the 'D' state.

2. It probably doesn't work. In fec_read_bufs we store data into the 
variable "fio->bufs", but fio bufs is shared between recursive 
invocations, if "verity_hash_for_block" invoked correction recursively, it 
would overwrite partially filled fio->bufs.

So, I'm suggesting to remove recursive correction at all. This patch
passed the cryptsetup testsuite. Does it pass your tests too?

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Guangwu Zhang <guazhang@redhat.com>

---
 drivers/md/dm-verity-fec.c    |    4 +---
 drivers/md/dm-verity-fec.h    |    3 ---
 drivers/md/dm-verity-target.c |    2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-fec.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.c	2025-11-14 15:15:31.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-fec.c	2025-11-14 16:33:42.000000000 +0100
@@ -417,10 +417,8 @@ int verity_fec_decode(struct dm_verity *
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
-	if (fio->level >= DM_VERITY_FEC_MAX_RECURSION) {
-		DMWARN_LIMIT("%s: FEC: recursion too deep", v->data_dev->name);
+	if (fio->level)
 		return -EIO;
-	}
 
 	fio->level++;
 
Index: linux-2.6/drivers/md/dm-verity-fec.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.h	2025-11-14 15:15:31.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-fec.h	2025-11-14 15:21:39.000000000 +0100
@@ -23,9 +23,6 @@
 #define DM_VERITY_FEC_BUF_MAX \
 	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
 
-/* maximum recursion level for verity_fec_decode */
-#define DM_VERITY_FEC_MAX_RECURSION	4
-
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"
Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-08-15 17:28:23.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2025-11-14 15:23:23.000000000 +0100
@@ -1690,7 +1690,7 @@ static struct target_type verity_target
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 12, 0},
+	.version	= {1, 13, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,

