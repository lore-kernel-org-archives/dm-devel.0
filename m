Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005351CAA1
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iweLhq6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ombRiu7Dq+zCsEA/IMbGWcQEYF7RlL4qaz5togIAiH4=;
	b=iweLhq6aAFJJ8gvFsFnWh90gDuhilgVMepHCRaE8ZCSvSOex31sKeiLYTyqLVRxriL6r7Y
	QdPU4vQ06ZidGyuvri8TMsjrk2C+9oJ/e7n3lKwRtVn2Ev5lTT7x3E0Sw7tziXlVVbemQF
	TEYitc514lye+5Ci5ipx1KKvlsulr6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-kghPIZVLO7CXPEH1Sdb2uQ-1; Wed, 03 Jan 2024 12:56:45 -0500
X-MC-Unique: kghPIZVLO7CXPEH1Sdb2uQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 570E2882082;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 511EE51D5;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403Huj8V018503
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HujMm018502;
	Wed, 3 Jan 2024 12:56:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/18] multipathd: handle busy devices in cli_del_maps()
Date: Wed,  3 Jan 2024 12:56:34 -0500
Message-ID: <20240103175643.18438-10-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Make cli_del_maps() return -EBUSY like cli_del_map() if it fails because
a device is in use and it doesn't run into any other type of failures.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  | 10 +++++++---
 multipath/main.c          |  3 ++-
 multipathd/cli_handlers.c | 19 +++++++++++++------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6bbe784d..e970e71b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1163,7 +1163,7 @@ dm_flush_map_nopaths(const char * mapname,
 
 int dm_flush_maps (int retries)
 {
-	int r = 1;
+	int r = DM_FLUSH_FAIL;
 	struct dm_task *dmt;
 	struct dm_names *names;
 	unsigned next = 0;
@@ -1181,12 +1181,16 @@ int dm_flush_maps (int retries)
 	if (!(names = dm_task_get_names (dmt)))
 		goto out;
 
-	r = 0;
+	r = DM_FLUSH_OK;
 	if (!names->dev)
 		goto out;
 
 	do {
-		r |= dm_suspend_and_flush_map(names->name, retries) != DM_FLUSH_OK;
+		int ret;
+		ret = dm_suspend_and_flush_map(names->name, retries);
+		if (ret == DM_FLUSH_FAIL ||
+		    (r != DM_FLUSH_FAIL && ret == DM_FLUSH_BUSY))
+			r = ret;
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/multipath/main.c b/multipath/main.c
index 48d684e3..664f7b97 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1082,7 +1082,8 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	else if (cmd == CMD_FLUSH_ALL) {
-		r = dm_flush_maps(retries) ? RTVL_FAIL : RTVL_OK;
+		r = (dm_flush_maps(retries) != DM_FLUSH_OK) ?
+		    RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
 	while ((r = configure(conf, cmd, dev_type, dev)) == RTVL_RETRY)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b49bc73a..af211a6b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -767,18 +767,25 @@ cli_del_maps (void *v, struct strbuf *reply, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	struct multipath *mpp;
-	int i, ret = 0;
+	int i, ret, r = 0;
 
 	condlog(2, "remove maps (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (flush_map(mpp, vecs))
-			ret++;
-		else
+		ret = flush_map(mpp, vecs);
+		if (ret == DM_FLUSH_OK)
 			i--;
+		else if (ret == DM_FLUSH_BUSY && r != 1)
+			r = -EBUSY;
+		else
+			r = 1;
 	}
 	/* flush any multipath maps that aren't currently known by multipathd */
-	ret |= dm_flush_maps(0);
-	return ret;
+	ret = dm_flush_maps(0);
+	if (ret == DM_FLUSH_BUSY && r != 1)
+		r = -EBUSY;
+	else if (ret != DM_FLUSH_OK)
+		r = 1;
+	return r;
 }
 
 static int
-- 
2.43.0

