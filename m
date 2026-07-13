Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325D5346A07
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 19:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970731; cv=none; b=Z9v7G8/aX4um8/C7a0QxPt+y5WzPGCUUGab2AfK9BCJwhhEQiIV4NoAbHvo3G7xEvpu4FplzO9GeqJGdhoRnHR10vP2JGqUSr/CJPanhQIgElhYq6rbNiv5pJqOla1Jgxp3RMGRHmRTsYk90CFqiOhXZq2cYhVU0RBiShb1MHBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970731; c=relaxed/simple;
	bh=+8aXh3+ze7tPexBsJBqJOeIR20s0kij54sZVOV3ofG4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=ENaZ8Qjt0EYnKrQ0uWTGS2jSOkZzenyH3CYBlRzvS1mWXYlNcMr/DmBy82oh+GRAyPHzfrxSgyUqjH7uVR+I+9ykQom06R9uRjTM+LiTocJ9VaMwSsyxCuystSnF/Cw78EBJ015ohjP4smYHdnF2JsT91rvNKS6hhnTqhRVZcLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcFf+aQS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcFf+aQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783970729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=ImvWBEj9n6rM0A6jsb/3HoNQgGky2Czjlgvc28rvqVw=;
	b=dcFf+aQSht5Oyrbw1PpPZjJF0PUBgFT6qQZ0lGbaDqDjzefb7UGJQPuuHuACk0TOs1mOtE
	q+OL8Et6PFD8+OQakGOwpfWRGPWqv5I/ngvcOeKYFPV6Za+KruUc47zpmMoBTkkJ77jAO2
	pgkDMdr5TjhD4ihLVqOMsn/hgE1pdD0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-XEtKVSNjO-uY6NPyPh7mcg-1; Mon,
 13 Jul 2026 15:25:26 -0400
X-MC-Unique: XEtKVSNjO-uY6NPyPh7mcg-1
X-Mimecast-MFC-AGG-ID: XEtKVSNjO-uY6NPyPh7mcg_1783970725
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27B2119560A1;
	Mon, 13 Jul 2026 19:25:25 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBD2F1956047;
	Mon, 13 Jul 2026 19:25:23 +0000 (UTC)
Date: Mon, 13 Jul 2026 21:25:21 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-ioctl: delete a useless condition
Message-ID: <034d2c5b-3d80-49d9-2c25-f300a84ae562@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yxyQwv41sh_jfgEBvmsRfY20mQuqjDpVYygY9AYhBYI_1783970725
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The condition "remaining <= 0" can never be true. The variable remaining
has type size_t, thus it can't be negative. It can't be zero because we
made sure earlier that "remaining > sizeof(struct dm_target_spec)" and
then we added "sizeof(struct dm_target_spec)" to "outptr" (this means
that we subtraceted "sizeof(struct dm_target_spec)" from "remaining").

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6

---
 drivers/md/dm-ioctl.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-07-09 21:41:36.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-07-09 21:41:36.000000000 +0200
@@ -1444,10 +1444,6 @@ static void retrieve_status(struct dm_ta
 
 		outptr += sizeof(struct dm_target_spec);
 		remaining = len - (outptr - outbuf);
-		if (remaining <= 0) {
-			param->flags |= DM_BUFFER_FULL_FLAG;
-			break;
-		}
 
 		/* Get the status/table string from the target driver */
 		if (ti->type->status) {

