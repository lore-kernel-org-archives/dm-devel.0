Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2D71CA9F
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1zQwgNx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVBCq0r1r1X7ROm+Wh0M0dhgIBpKXO/cvyxNEUWj0SA=;
	b=g1zQwgNxyq7EDOavvalYupelidxrBQq2vj0z9dZ4czfN5Yc5JufMzTme8PF+6SV9BOsWa1
	qbbdTOre6CJgmP9cNvhT7Fe3GuaCZ+HhOddmc1qOPQSqU5R1MQ/tFGk2y4dtXKYZwu0BhB
	v/a/9/BVzoVvGI85+TWXwLtBkFELyKQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-IZSPBgdTOQuAu5gy-FsN8w-1; Wed, 03 Jan 2024 12:56:45 -0500
X-MC-Unique: IZSPBgdTOQuAu5gy-FsN8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3070885A58A;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A05D2026D66;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HuiTh018499
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HuioI018498;
	Wed, 3 Jan 2024 12:56:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/18] multipathd: print extra default reply msg for busy devices
Date: Wed,  3 Jan 2024 12:56:33 -0500
Message-ID: <20240103175643.18438-9-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If removing a multipath device fails because the device is in use,
return DM_FLUSH_BUSY from remove_functions, which causes cli_del_map()
to return -EBUSY, which will now print extra information in
default_reply().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  | 14 +++++++-------
 libmultipath/devmapper.h  |  1 +
 multipathd/cli_handlers.c |  9 ++++++++-
 multipathd/uxlsnr.c       |  3 +++
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 73bb6fe7..6bbe784d 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1083,7 +1083,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
 	if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
-			return DM_FLUSH_FAIL;
+			return DM_FLUSH_BUSY;
 
 	if (need_suspend &&
 	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
@@ -1097,12 +1097,12 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	free(params);
 	params = NULL;
 
-	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
-		return DM_FLUSH_FAIL;
+	if ((r = dm_remove_partmaps(mapname, need_sync, deferred_remove)))
+		return r;
 
 	if (!do_deferred(deferred_remove) && dm_get_opencount(mapname)) {
 		condlog(2, "%s: map in use", mapname);
-		return DM_FLUSH_FAIL;
+		return DM_FLUSH_BUSY;
 	}
 
 	do {
@@ -1506,7 +1506,7 @@ do_foreach_partmaps (const char * mapname,
 		    (p = strstr(params, dev_t)) &&
 		    !isdigit(*(p + strlen(dev_t)))
 		   ) {
-			if (partmap_func(names->name, data) != 0)
+			if ((r = partmap_func(names->name, data)) != 0)
 				goto out;
 		}
 
@@ -1538,12 +1538,12 @@ remove_partmap(const char *name, void *data)
 		if (!do_deferred(rd->deferred_remove) &&
 		    dm_get_opencount(name)) {
 			condlog(2, "%s: map in use", name);
-			return 1;
+			return DM_FLUSH_BUSY;
 		}
 	}
 	condlog(4, "partition map %s removed", name);
 	dm_device_remove(name, rd->need_sync, rd->deferred_remove);
-	return 0;
+	return DM_FLUSH_OK;
 }
 
 static int
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 3fc8473b..fa9c6114 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -53,6 +53,7 @@ enum {
 	DM_FLUSH_OK = 0,
 	DM_FLUSH_FAIL,
 	DM_FLUSH_DEFERRED,
+	DM_FLUSH_BUSY,
 };
 
 int _dm_flush_map (const char *, int, int, int, int);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 9a0cd065..b49bc73a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -31,6 +31,7 @@
 #include "foreign.h"
 #include "strbuf.h"
 #include "cli_handlers.h"
+#include "devmapper.h"
 
 static int
 show_paths (struct strbuf *reply, struct vectors *vecs, char *style, int pretty)
@@ -743,6 +744,7 @@ cli_del_map (void * v, struct strbuf *reply, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
 	struct multipath *mpp;
+	int r;
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: remove map (operator)", param);
@@ -752,7 +754,12 @@ cli_del_map (void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return 1;
 
-	return flush_map(mpp, vecs);
+	r = flush_map(mpp, vecs);
+	if (r == DM_FLUSH_OK)
+		return 0;
+	else if (r == DM_FLUSH_BUSY)
+		return -EBUSY;
+	return 1;
 }
 
 static int
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 4df01666..707ed396 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -411,6 +411,9 @@ void default_reply(struct client *c, int r)
 	case -ETIMEDOUT:
 		append_strbuf_str(&c->reply, "timeout\n");
 		break;
+	case -EBUSY:
+		append_strbuf_str(&c->reply, "map or partition in use\n");
+		break;
 	}
 }
 
-- 
2.43.0

