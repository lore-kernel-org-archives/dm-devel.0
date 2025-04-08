Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9E32063FA
	for <dm-devel@lists.linux.dev>; Tue,  8 Apr 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744156327; cv=none; b=tOiDDGmdeILlkIu9oZ3qPRqd/8pmojh3WDPq02CR6O5It6Y0LbO/oHYp+JFSmZ+GpYIgTUXIWyazSatg3NFIv5ORvL/4rY6XX4QonbBA9vLRXjXuAHu6BJmHvcWxenMKNZWeMhgzw6FPLiomJ4SXZUEbF6wmRZm4+uBLv1bf/ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744156327; c=relaxed/simple;
	bh=79Iz68fntPRFIZIxlkxI6B6WsLznUqgckDnCkswLdZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=P1rJ6vv27U5X2ICboMU93xDuQmshdQUsbo9jYidYAxC8N4svemScir9xmYTs2EFaaKbXZCimaYDKISLNYqXc0A4/CWx3WW/CIpwC/gUC4pS3pZ3JwaRPSPu6rFszsYT0kyUgOtL1PreKOW6x/URrG4ljS4UWPJ6MA80Xo/R2FiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGOmZefz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGOmZefz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744156323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C81+Pdz0tp6ARDKNY27QzSrdA4N9lXGz/6auv5mqWME=;
	b=cGOmZefzlbaWtZBN0jKCO7mss3g6qvBn9gbzOAShtXoGc99YJprzVWSm79Pz3rdAUBdGZY
	r/EWPJalYrXfKc8Yh5S2OIf/0k3IF2i1qhnA7JxRcy5A9ths0cLPEYdxkzkUfSFbjjpD2H
	2K0GD4drTmJiVKtTPK/NjCt5VUrVOCg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-RHHRuCLUOSWesBSMCyZGkw-1; Tue,
 08 Apr 2025 19:52:02 -0400
X-MC-Unique: RHHRuCLUOSWesBSMCyZGkw-1
X-Mimecast-MFC-AGG-ID: RHHRuCLUOSWesBSMCyZGkw_1744156321
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 762EB1800259;
	Tue,  8 Apr 2025 23:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0CE31801766;
	Tue,  8 Apr 2025 23:52:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 538NpxQr4128861
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Apr 2025 19:51:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 538NpxuS4128860;
	Tue, 8 Apr 2025 19:51:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/6] dm: free table mempools if not used in __bind
Date: Tue,  8 Apr 2025 19:51:55 -0400
Message-ID: <20250408235159.4128838-3-bmarzins@redhat.com>
In-Reply-To: <20250408235159.4128838-1-bmarzins@redhat.com>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v8GDejEnOS8PnJwEzsd-6ZWnV5fWBl6st0SjUc960ak_1744156321
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

With request-based dm, the mempools don't need reloading when switching
tables, but the unused table mempools are not freed until the active
table is finally freed. Free them immediately if they are not needed.

Fixes: 29dec90a0f1d9 ("dm: fix bio_set allocation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f5c5ccb6f8d2..292414da871d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2461,10 +2461,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 * requests in the queue may refer to bio from the old bioset,
 		 * so you must walk through the queue to unprep.
 		 */
-		if (!md->mempools) {
+		if (!md->mempools)
 			md->mempools = t->mempools;
-			t->mempools = NULL;
-		}
+		else
+			dm_free_md_mempools(t->mempools);
 	} else {
 		/*
 		 * The md may already have mempools that need changing.
@@ -2473,8 +2473,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 */
 		dm_free_md_mempools(md->mempools);
 		md->mempools = t->mempools;
-		t->mempools = NULL;
 	}
+	t->mempools = NULL;
 
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
-- 
2.48.1

