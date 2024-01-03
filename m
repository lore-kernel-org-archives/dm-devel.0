Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9001CA9B
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="McqHqizD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6DuKHOcdY90mx0/ZLPqPWb1ZXgcL4Gug1gzRunbTHmI=;
	b=McqHqizDdYasYBvwwXWFJCZcdS+sgaQuFtxmWRH74PtJwDO5fB4eEfwxBDHs7a+fGjk+0b
	2BrUBpFPtn4ZhNuk5qKI6znDPCj8OuMlS6PWLhrzEebWoIqCGLDwcKznk3gVCWSef3AQTt
	aLB4S2v7tv4Kmo2/zo3xI7cMV4DDUOg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-rZousqCbPh2AMbqd4L2_Qw-1; Wed, 03 Jan 2024 12:56:44 -0500
X-MC-Unique: rZousqCbPh2AMbqd4L2_Qw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58313185A780;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 522302026D66;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HuiY1018477
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hui1G018476;
	Wed, 3 Jan 2024 12:56:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/18] multipathd: disable queueing when removing unknown maps
Date: Wed,  3 Jan 2024 12:56:28 -0500
Message-ID: <20240103175643.18438-4-bmarzins@redhat.com>
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

Make cli_del_maps() call dm_suspend_and_flush_map() for the unknown
multipath devices as well.

After this change, all callers of cli_del_maps() set need_suspend, so
simplify dm_flush_maps().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  | 7 ++-----
 libmultipath/devmapper.h  | 2 +-
 multipath/main.c          | 2 +-
 multipathd/cli_handlers.c | 2 +-
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 36b9d274..1646110b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1159,7 +1159,7 @@ dm_flush_map_nopaths(const char * mapname,
 
 #endif
 
-int dm_flush_maps (int need_suspend, int retries)
+int dm_flush_maps (int retries)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -1184,10 +1184,7 @@ int dm_flush_maps (int need_suspend, int retries)
 		goto out;
 
 	do {
-		if (need_suspend)
-			r |= dm_suspend_and_flush_map(names->name, retries);
-		else
-			r |= dm_flush_map(names->name);
+		r |= dm_suspend_and_flush_map(names->name, retries);
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index d1790df5..1eacd966 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -55,7 +55,7 @@ int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_suspend_and_flush_map(mapname, retries) \
 	_dm_flush_map(mapname, 1, 0, 1, retries)
 int dm_cancel_deferred_remove(struct multipath *mpp);
-int dm_flush_maps (int need_suspend, int retries);
+int dm_flush_maps (int retries);
 int dm_fail_path(const char * mapname, char * path);
 int dm_reinstate_path(const char * mapname, char * path);
 int dm_queue_if_no_path(struct multipath *mpp, int enable);
diff --git a/multipath/main.c b/multipath/main.c
index 9e1c5052..c51884f2 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1075,7 +1075,7 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	else if (cmd == CMD_FLUSH_ALL) {
-		r = dm_flush_maps(1, retries) ? RTVL_FAIL : RTVL_OK;
+		r = dm_flush_maps(retries) ? RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
 	while ((r = configure(conf, cmd, dev_type, dev)) == RTVL_RETRY)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 2d90f0fe..dc547be8 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -781,7 +781,7 @@ cli_del_maps (void *v, struct strbuf *reply, void *data)
 			i--;
 	}
 	/* flush any multipath maps that aren't currently known by multipathd */
-	ret |= dm_flush_maps(0, 0);
+	ret |= dm_flush_maps(0);
 	return ret;
 }
 
-- 
2.43.0

