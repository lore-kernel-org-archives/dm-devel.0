Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36316200A0
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850725; cv=none; b=RYDngrdMtByqxYAcxHhSina8+o8g6dNj2DuUZtPp09OlLswA4iXk72Buiubm+XkkkyfBHec9fCisymEaGgIleeh66dvRi3xNU/9LqolDyeQRCqaBgPhXeA1Gux+B2rxa5QNeS7+xhWijvd2ApEhiZVjrJkdIm0ieOp3GvuUyd7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850725; c=relaxed/simple;
	bh=5SGw1gHJ53LojK5SiLiLfBzyUDgTMg7qPj8AE8wCq38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t/qehW6Kaj1J+kEoP/cY29I0wzZ+WZbzp0xpBpQGlbcVKuOSPOWbep8JYIC9m0wWUw0vobEqEly9tXMM2JlkcIHmeOYTuoJKJssdO7jagf/2Uqr7uRiP02lK1rIX3B7516nb2OUCRjfPGQ4FlEBQ5JS1H7VyQZqnPJEJfmpAhic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HV1sxE/e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HV1sxE/e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tx6YpNWFw5WUfSOZRRz3iv8PT2zeIEaHtowZzHg+DNI=;
	b=HV1sxE/ebey5wzTIplXop27aOXB/DJV3OFZOR9VYxbNf3RzML0HN6H5b21vWosbBlbXzyf
	uj8oAfQE6z/J8kWFjcWJyZeJnPYa0HCM0rpSdSN/fFhkzUA/VjPhnyGCPFTDls23TzYif+
	Gk68plkB36Y2H7UOp6Plj20OEN6+/Os=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-XFuZx02VPgKU-Zw7asFcEg-1; Sat,
 13 Jul 2024 02:05:12 -0400
X-MC-Unique: XFuZx02VPgKU-Zw7asFcEg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A64A19560AB;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1734019560AE;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D6592a2015550
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D659QD2015549;
	Sat, 13 Jul 2024 02:05:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 14/22] multipathd: resync map after setup_map in resize_map
Date: Sat, 13 Jul 2024 02:04:58 -0400
Message-ID: <20240713060506.2015463-15-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

In resize_map() it was possible to exit after calling setup_map()
without resyncing the mpp state with the kernel. This meant that the mpp
state in multipathd might not match with the kernel state at all.

Once setup_map() has been called, setup_multipath() and sync_map_state()
are now always called, to make sure the mpp matches the kernel state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3c84c2a0..c9cb9ac8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1534,6 +1534,7 @@ needs_ro_update(struct multipath *mpp, int ro)
 int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors * vecs)
 {
+	int ret = 0;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
 	unsigned long long orig_size = mpp->size;
 
@@ -1543,7 +1544,8 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 		condlog(0, "%s: failed to setup map for resize : %s",
 			mpp->alias, strerror(errno));
 		mpp->size = orig_size;
-		return 1;
+		ret = 1;
+		goto out;
 	}
 	mpp->action = ACT_RESIZE;
 	mpp->force_udev_reload = 1;
@@ -1551,13 +1553,14 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
 		mpp->size = orig_size;
-		return 1;
+		ret = 1;
 	}
+out:
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
 	sync_map_state(mpp);
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.45.0

