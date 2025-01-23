Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EDD35963
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602211; cv=none; b=BY8NeVv+LkcypOVYQQV6/qcMrmCTDQhYOqyMMzh7c9mAf3ZorYGhWdNETx5qIyKXzLcoZJogjKbzzxUogHbvmY1XK+ZKRWSr37TIQp8xui+uHDk3QWVz77ZLtB6n5amCaOVe2MmNcZhARqoJ0xlL3ZmcjWuGUt9qRlOf0BSKUv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602211; c=relaxed/simple;
	bh=5wsTzgrii5nPXcwvEHkt1iSU8K3gZLhtiS8pY+ELa5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lmEdNlrc+LSujZZHwoIibwEgwDGNKVNzMQ0ACuWPqeHgmvrYPwvx8phAGpyRVm4TZ4ePalWerJVD2yNPhbLhMZsGbvOtCUBZQbFMazMbpaLYlqJk8IdStMzSuUhI10V5nWlzFuDJ/mGXdiWu7EUM+46qOOcrxicBRHCW0usW++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DtrL4jp0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtrL4jp0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJ81YFNVV8QsxOxNGSW3+GXNWvM0bXoYPSqxTZVjVY0=;
	b=DtrL4jp0xaRDu6iJwtv8PFaez2pBBPp0gDLeIdkIw3TCA0vFa9o4B4K1ys9jsPoOCRYxMk
	/kXMtGouxiP4iW0D9tHe1P+VrhlNRuJkrPdANBoKCUqhVo11n8pE6CeSUDc4OjYvTycBae
	2Iqmuf3uYsckgPDuSPOQlIHMndLVS7Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-u3ORVEYJPmKl4j-GVYA7jA-1; Wed,
 22 Jan 2025 22:16:46 -0500
X-MC-Unique: u3ORVEYJPmKl4j-GVYA7jA-1
X-Mimecast-MFC-AGG-ID: u3ORVEYJPmKl4j-GVYA7jA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A39AA1956087;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DEEC19560B7;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GiHK3017921
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3Gih33017920;
	Wed, 22 Jan 2025 22:16:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 02/13] multipathd: don't reload the map when waiting for udev
Date: Wed, 22 Jan 2025 22:16:32 -0500
Message-ID: <20250123031643.3017891-3-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0DNfyaiQx4zzeJmqNpwAopSbIyvTbGRqFEbMmQ0eUTA_1737602205
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In checker_finished(), if we are still waiting for the initial uevent,
we should instead set wait_for_udev to UDEV_WAIT_RELOAD, so that we
trigger a reload when we get the uevent.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3b4e61fc..b4a366ea 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2978,7 +2978,10 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 				continue;
 			}
 		} else if (prio_reload || failback_reload || ghost_reload || inconsistent) {
-			if (reload_and_sync_map(mpp, vecs) == 2) {
+			if (mpp->wait_for_udev != UDEV_WAIT_DONE) {
+				mpp->need_reload = false;
+				mpp->wait_for_udev = UDEV_WAIT_RELOAD;
+			} else if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
 				continue;
-- 
2.46.2

