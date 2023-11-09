Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0052239845
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 23:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/7Ok4lM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699573583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tC1a4dUUdVaiuc7gPDnLmspR9xV+W18nhoUKn2XnYB0=;
	b=O/7Ok4lMCLpXwlER4UZZKQPPH7025MEzNpgn/923lPZE3VwVpxS7Pw8w6ecfCqrFEY5r5J
	1d/DtZrp07BaRjJ4kZfAK85eLeL2Y0kOCz5Za67N5B/VYaezdbbeL9MEDAY+yW6UhSU/WF
	nUA0DTOA3GAr+wXtkeJMpsf1OHTueyg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-ayxZ8TEsMgqO0CpPHs5jFQ-1; Thu,
 09 Nov 2023 18:46:18 -0500
X-MC-Unique: ayxZ8TEsMgqO0CpPHs5jFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C483B380662D;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE93F492A;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A9NkHhf100143
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Nov 2023 18:46:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A9NkHBJ100142;
	Thu, 9 Nov 2023 18:46:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 3/6] multipathd: check and update all paths when in cli_resize
Date: Thu,  9 Nov 2023 18:46:13 -0500
Message-ID: <20231109234616.100125-4-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-1-bmarzins@redhat.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When resizing a multipath device, make sure that all the paths have
been updated to the new size first.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index c9addfbb..37a999ac 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -845,9 +845,11 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 	char * mapname = get_keyparam(v, KEY_MAP);
 	struct multipath *mpp;
 	int minor;
-	unsigned long long size;
+	unsigned long long size = 0;
 	struct pathgroup *pgp;
 	struct path *pp;
+	unsigned int i, j;
+	bool mismatch = false;
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: resize map (operator)", mapname);
@@ -867,21 +869,24 @@ cli_resize(void *v, struct strbuf *reply, void *data)
 		return 1;
 	}
 
-	pgp = VECTOR_SLOT(mpp->pg, 0);
-
-	if (!pgp){
-		condlog(0, "%s: couldn't get path group. cannot resize",
-			mapname);
-		return 1;
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			sysfs_get_size(pp, &pp->size);
+			if (!pp->size)
+				continue;
+			if (!size)
+				size = pp->size;
+			else if (pp->size != size)
+				mismatch = true;
+		}
 	}
-	pp = VECTOR_SLOT(pgp->paths, 0);
-
-	if (!pp){
-		condlog(0, "%s: couldn't get path. cannot resize", mapname);
+	if (!size) {
+		condlog(0, "%s: couldn't get size from sysfs. cannot resize",
+			mapname);
 		return 1;
 	}
-	if (!pp->udev || sysfs_get_size(pp, &size)) {
-		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
+	if (mismatch) {
+		condlog(0, "%s: path size not consistent. cannot resize",
 			mapname);
 		return 1;
 	}
-- 
2.41.0

