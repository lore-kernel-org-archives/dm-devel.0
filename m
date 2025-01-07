Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66EE18950A
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736268433; cv=none; b=Sx9e2hetTt6wkzNwFIQROIOKWLQOZ3IsCR32dVL4ujorhSJu8ewF/kfvIzFj+MFS4Bail81MFt0YpOn2qSb+m6b1vTWltqCSu0D/3m88Q4N04gCkiNiiwyK+Q/WLMvcFj6KGI4mCOGs9WY0wbiDaS94V1lDkDvQXuZ8GtOeDvWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736268433; c=relaxed/simple;
	bh=VCI7R33YqrhIfiPk5hzhs6Gwn2T9ph5/y81fB42K5pM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=P2zDzS6Eno2i4IuiFSTtKMbwiX6o6O0SMBxzlD2bDNDhXeX/iu89U8hHtiEDX39G9MCrAvnsfn80HJhTjymqt5epONfgiLKkrdTw+uGxIYBepUZ16tpPnh1RIM19dxaBIJM34WpuWIbmU58pyJBksi0P8tYNd28wjaWUroDmN8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H9aHdi+b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9aHdi+b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736268430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=eFFuV2Ix2BLO4MtjiKfqIacdFHXlOpdtcXnWD9UDlz4=;
	b=H9aHdi+b4czKzNpKiAe4nWv/YTxBkgKGgxW9/kyjPaJpjBvLV6IVe5zwIR46uKMJJBfUqj
	hY006C/IBnkc6RpuM8qs5H3EpNLF1maKKn0XVcb884a4Yy0ouSj1CJ7gMSKl9+PnFpbuYM
	3OwNZ9GEELitANUn1zT3BoYkF6hhAKg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-Vn1r5lghONuNVJTJG6XS2A-1; Tue,
 07 Jan 2025 11:47:09 -0500
X-MC-Unique: Vn1r5lghONuNVJTJG6XS2A-1
X-Mimecast-MFC-AGG-ID: Vn1r5lghONuNVJTJG6XS2A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64C2D1955F34;
	Tue,  7 Jan 2025 16:47:08 +0000 (UTC)
Received: from [10.45.224.27] (unknown [10.45.224.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEED9195606B;
	Tue,  7 Jan 2025 16:47:06 +0000 (UTC)
Date: Tue, 7 Jan 2025 17:47:01 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-ebs: don't set the flag DM_TARGET_PASSES_INTEGRITY
Message-ID: <0f3156b2-af3c-9276-9158-af43fcebe3b7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R9jyODvwLj139achSgEXhH1hrGXIPLn8FZriIcdXJwk_1736268428
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

dm-ebs uses dm-bufio to process requests that are not aligned on logical
sector size. dm-bufio doesn't support passing integrity data (and it is
unclear how should it do it), so we shouldn't set the
DM_TARGET_PASSES_INTEGRITY flag.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: d3c7b35c20d6 ("dm: add emulated block size target")

---
 drivers/md/dm-ebs-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-ebs-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ebs-target.c	2024-07-30 14:06:48.000000000 +0200
+++ linux-2.6/drivers/md/dm-ebs-target.c	2025-01-03 17:49:32.000000000 +0100
@@ -442,7 +442,7 @@ static int ebs_iterate_devices(struct dm
 static struct target_type ebs_target = {
 	.name		 = "ebs",
 	.version	 = {1, 0, 1},
-	.features	 = DM_TARGET_PASSES_INTEGRITY,
+	.features	 = 0,
 	.module		 = THIS_MODULE,
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,

