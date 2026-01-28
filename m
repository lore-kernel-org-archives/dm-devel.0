Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E622F01
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559153; cv=none; b=PRCwq7DBJejlArhB7WDGyyjOBbqyQrBHMskHYRvO52L9mPEC8OO+E8L+76H078CfyyIEJu2jDCGhfP9xO1pMkAi+N4YEcNK+t5hM5hVOTu8y4ssKBOBoqq8AMHJOYuwxNCG8b+Hl1+r8Lv+yyiQicYf3fYX/yeV9LKy+TV1uVFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559153; c=relaxed/simple;
	bh=1A9d5AIUC2VKTWIlLCul/pwySvhhdKf5NvW8854uQe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=JObdjPnA9RMP2Gy16HY9scSCDSsGCBZmX+QECTxv5JyIONdrE8cMIqZhmjHL6YlM5fCCNmy9PSrCkT4Ck0p/5EVP2LOOO5Xv+MEBAY3VssuCEVaDJf/0K6+qFD8m9wuM+YFgMJdKSprXugfUW5rgc6uSxTmDRicYBHUhCp+33ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JXwZHAkw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXwZHAkw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769559150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0SFxL+rUv5aakBIlLEwO/Zia+kWr43Ni7kmcWbh61s=;
	b=JXwZHAkwU7we38eLVy2lvjYsYeWV3kgPgPBCzLPHLDlWl4nMAwpABkY+6+oRLasPCgECbk
	rO18aZSXnPwsbhBgwl70TCy+r2hAexGdXE3U/EbAJrXvs/DAKHWxes/D/iCsi5XVjd+5oW
	bjKU/TcCKK/C+2oI6k5dyd39JDLi2NY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-nUysvocrPKWXB704pE3sVg-1; Tue,
 27 Jan 2026 19:12:27 -0500
X-MC-Unique: nUysvocrPKWXB704pE3sVg-1
X-Mimecast-MFC-AGG-ID: nUysvocrPKWXB704pE3sVg_1769559146
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F8F61944F11;
	Wed, 28 Jan 2026 00:12:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39FA81956095;
	Wed, 28 Jan 2026 00:12:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60S0CPgl462773
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 19:12:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60S0CP8d462772;
	Tue, 27 Jan 2026 19:12:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm mpath: make pg_init_delay_msecs settable
Date: Tue, 27 Jan 2026 19:12:24 -0500
Message-ID: <20260128001224.462746-4-bmarzins@redhat.com>
In-Reply-To: <20260128001224.462746-1-bmarzins@redhat.com>
References: <20260128001224.462746-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w_D-RXnTVcSOHDcd84Q2Ohkgxft1WiIngvELKx8UThU_1769559146
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

"pg_init_delay_msecs X" can be passed as a feature in the multipath
table and is used to set m->pg_init_delay_msecs in parse_features().
However, alloc_multipath_stage2(), which is called after
parse_features(), resets m->pg_init_delay_msecs to its default value.
Instead, set m->pg_init_delay_msecs in alloc_multipath(), which is
called before parse_features(), to avoid overwriting a value passed in
by the table.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6f9d86f4b912..de03f9b06584 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -225,6 +225,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		mutex_init(&m->work_mutex);
 
 		m->queue_mode = DM_TYPE_NONE;
+		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 
 		m->ti = ti;
 		ti->private = m;
@@ -251,7 +252,6 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 	set_bit(MPATHF_QUEUE_IO, &m->flags);
 	atomic_set(&m->pg_init_in_progress, 0);
 	atomic_set(&m->pg_init_count, 0);
-	m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 	init_waitqueue_head(&m->pg_init_wait);
 	init_waitqueue_head(&m->probe_wait);
 
-- 
2.50.1

