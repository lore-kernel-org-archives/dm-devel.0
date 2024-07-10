Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8255B19538B
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 19:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720640257; cv=none; b=GZPDdOtaH+Wfv/s2jj2oOEiN4nDp+sJdHhwNroFeRx5tJwVWmjeaSx1BoLjKqoPX7Brl5a7cMF8CCI69cUpfQAyUk2l7SXtqCbnGMOZFJzlw58W/+iggklKac6wsiESdjyu0hEd68WhW41Ms5xXVPkPnItNMP+1dImmwmuvkM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720640257; c=relaxed/simple;
	bh=z2habFVkLxJSEXDeConeSAwJK3XZAkeIMZw4BmXSJ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YEI2cKUKWOdY4/SAqxS6swKk97FncqRmQTcCKkd0xDhsQvn7DNhnmj2w8PJiBcbmtW/KFPWVfi+78KOBTYggHMWlRoFh3mYcEN6CDecdpTssMuMX36wi/9oC6sUnP0nFx8Cac0pX1TBBclQfbqRvYpZwxeTmkVrG7W7GS8QoBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DDQ/Rl9/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDQ/Rl9/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720640254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7yV/oNAE1fxcHI1s2enJTKJtFIoJvZZC5nB0pRFugsY=;
	b=DDQ/Rl9/0VIvn47g7mfUr9hGP79Bi8rhheS0uiN2i0KOs4mY63utZ5Eo6yAibOKHRcONII
	rlTlfEdrQrX+hoziz9D9Q/f81S/dc8G9rD3pA3DZ1RbgY8/H/8TlyTJQAkYD+2Ie3rYVv4
	fFmxcUMwKKdt/wpzK4o3nB4pj6dJLek=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-VrGwTzoFNw-PqRrndPPXbQ-1; Wed,
 10 Jul 2024 15:37:32 -0400
X-MC-Unique: VrGwTzoFNw-PqRrndPPXbQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6D5719560AE
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 19:37:31 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 822001954217;
	Wed, 10 Jul 2024 19:37:31 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id F1DBE52D42; Wed, 10 Jul 2024 15:37:30 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: replace max_discard_sectors with max_hw_discard_sectors
Date: Wed, 10 Jul 2024 15:37:30 -0400
Message-ID: <a99e5c45b2c8f7e85e2cd25d02560deb2120c4a3.1720640089.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

Commit 4f563a64732d ("block: add a max_user_discard_sectors queue
limit") changed block core to set max_discard_sectors to:
min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors)

Commit 825d8bbd2f32 ("dm: always manage discard support in terms
of max_hw_discard_sectors") fixed most dm targetss to deal with
this, by replacing max_discard_sectors with max_hw_discard_sectors.
Unfortunately, dm-vdo did not get fixed at that time.

Fixes: 825d8bbd2f32 ("dm: always manage discard support in terms of max_hw_discard_sectors")
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 5a4b0a927f56..af77084969e0 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -945,7 +945,7 @@ static void vdo_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * The value is used by dm-thin to determine whether to pass down discards. The block layer
 	 * splits large discards on this boundary when this is set.
 	 */
-	limits->max_discard_sectors =
+	limits->max_hw_discard_sectors =
 		(vdo->device_config->max_discard_blocks * VDO_SECTORS_PER_BLOCK);
 
 	/*
-- 
2.45.2

