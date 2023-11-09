Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F58374E0
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 23:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRU+uVLC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699573579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9QAE/1P9ItVuzoseRUCI628tzbxrWWWaHLqmJVfmVSc=;
	b=FRU+uVLCzrcMKpAxn7VABfRa+AxsBuqj3pFiqCgBVyLL3E4J9jFmBlpjSxKOOARtP+CjJm
	rFFnlV6SIMaTLjlvIShdxaCItFG8D5hTvb2QNCUqjQMpqENXc6DfXOh42IFf6Fo67xOyNC
	4808griR0ODrDynqzDLG/QJ+BcJl9uw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-VHh_feE_NKC3Mg_s2JYU0g-1; Thu, 09 Nov 2023 18:46:18 -0500
X-MC-Unique: VHh_feE_NKC3Mg_s2JYU0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED388101A5C5;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E63462166B26;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A9NkHND100147
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Nov 2023 18:46:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A9NkH8p100146;
	Thu, 9 Nov 2023 18:46:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/6] multipathd: move post-reloading commands into resize_map()
Date: Thu,  9 Nov 2023 18:46:14 -0500
Message-ID: <20231109234616.100125-5-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-1-bmarzins@redhat.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

In preparation for reusing resize_map() in other code, move all code
necessary to resize the map to the resize_map() function. Also track if
map was removed in the function.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 37a999ac..cf75b45f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -835,6 +835,10 @@ static int resize_map(struct multipath *mpp, unsigned long long size,
 		mpp->size = orig_size;
 		return 1;
 	}
+	if (setup_multipath(vecs, mpp) != 0)
+		return 2;
+	sync_map_state(mpp);
+
 	return 0;
 }
 
@@ -848,7 +852,7 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	unsigned long long size = 0;
 	struct pathgroup *pgp;
 	struct path *pp;
-	unsigned int i, j;
+	unsigned int i, j, ret;
 	bool mismatch = false;
 
 	mapname = convert_dev(mapname, 0);
@@ -898,14 +902,12 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	condlog(3, "%s old size is %llu, new size is %llu", mapname, mpp->size,
 		size);
 
-	if (resize_map(mpp, size, vecs) != 0)
-		return 1;
+	ret = resize_map(mpp, size, vecs);
 
-	if (setup_multipath(vecs, mpp) != 0)
-		return 1;
-	sync_map_state(mpp);
+	if (ret == 2)
+		condlog(0, "%s: map removed while trying to resize", mapname);
 
-	return 0;
+	return (ret != 0);
 }
 
 static int
-- 
2.41.0

