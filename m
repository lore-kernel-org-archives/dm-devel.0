Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71E11CEAD6
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 15:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175079; cv=none; b=Ksf43hhtSlDjppU66BWJBT09A7pjMOhfIQoyfomUN2gFAHjTjgrRvr86nINY7y9uYiz0qr5ZLJ9+o500JQxa0lGpX+eF65XRgZQcinbPSf05+0ncDb9xbyMMKUWvRK6ScL4ovI3RITL2xeeh5X3cfJ0jCPVxJ8uTSz9en3fFagM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175079; c=relaxed/simple;
	bh=/0AE1R06B8/6G7aPeVkoiqRS+PWBlmA9gvmyindTbck=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=M2jE23GpfdlP5JenuLZPZCanhlNlrhrf1VZA3kg3a4VhiFONiskG7YIDP1v5jNQZSMaXfLSaVCpcfprLCquI1WmPr6bYML7QJ7yIMTKC7VcSvWkbAHPX3MlBLdSWoI3plLimBveZR4Wd8IlREoorF2hODj7PsQ5f3ItIX6tR/MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RmD3gtl9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RmD3gtl9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743175076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=o1gKLhIf9CXZqgXFhbG67m8OP8NYY3xMhuPSfCFYHmQ=;
	b=RmD3gtl91OtbmNqecQrFvI2HCF6fgaDKKIeuV4gDcscir1dvQEocvkAa9hywcpwIUPxisH
	iOKOiZ12Qu0eqlXPfoizcylAd4fDtrfPSmFOk63EGqANdLDXlOzz7cW08YqhOXji64wptI
	X2IE1k3Hcc6g8bQFIdGA9cVdSrC8/T8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-UGijjvY6Pni60pfzgWoztQ-1; Fri,
 28 Mar 2025 11:17:55 -0400
X-MC-Unique: UGijjvY6Pni60pfzgWoztQ-1
X-Mimecast-MFC-AGG-ID: UGijjvY6Pni60pfzgWoztQ_1743175074
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E722196B37B;
	Fri, 28 Mar 2025 15:17:54 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 898F930001A1;
	Fri, 28 Mar 2025 15:17:52 +0000 (UTC)
Date: Fri, 28 Mar 2025 16:17:45 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: fix prefetch-vs-suspend race
Message-ID: <bb30199a-671d-c359-ce3d-ffbba46a8233@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 34qjGD62aou2uRri-ysXT3kNNylMqy5UGgsHa5ikRZE_1743175074
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's a possible race condition in dm-verity - the prefetch work item
may race with suspend and it is possible that prefetch continues to run
while the device is suspended. Fix this by calling flush_workqueue and
dm_bufio_client_reset in the postsuspend hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-target.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-03-27 15:43:09.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2025-03-28 15:37:05.000000000 +0100
@@ -796,6 +796,13 @@ static int verity_map(struct dm_target *
 	return DM_MAPIO_SUBMITTED;
 }
 
+static void verity_postsuspend(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+	flush_workqueue(v->verify_wq);
+	dm_bufio_client_reset(v->bufio);
+}
+
 /*
  * Status: V (valid) or C (corruption found)
  */
@@ -1766,6 +1773,7 @@ static struct target_type verity_target
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
 	.map		= verity_map,
+	.postsuspend	= verity_postsuspend,
 	.status		= verity_status,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,

