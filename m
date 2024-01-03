Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9751CA92
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGHtVU7v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KGYNS4zat8gK4T/ximc2sUVpztjHmYVWb3SfSrG272g=;
	b=DGHtVU7vVT3smJXXqXOJuqWVXdfkQtX7LZgZm4lpprJfldP9AAFOj0RJE0AjAy+hN0NViT
	XHDm1Kt97EWzRlx4Kf0gpAsObOXxRf0OSGlqgACenfnJHuuhoW66ewCLCCJKAfQ6Xo1PY6
	xRuqfljGuJ28Xg9vodcIG/OS1dtMwxk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-lZBXUJF1PmqYpo6BeQgzVw-1; Wed,
 03 Jan 2024 12:56:45 -0500
X-MC-Unique: lZBXUJF1PmqYpo6BeQgzVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82003C02746;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0E7351D5;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HuiDP018491
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HuiUa018490;
	Wed, 3 Jan 2024 12:56:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/18] libmultipath: make dm_remove_partmaps() a static function
Date: Wed,  3 Jan 2024 12:56:31 -0500
Message-ID: <20240103175643.18438-7-bmarzins@redhat.com>
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

dm_remove_partmaps() is only used in devmapper.c, so make it static. It
does need to be declared early, since remove_partmaps() and it call
eachother.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 4 +++-
 libmultipath/devmapper.h | 2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f5b4f4c0..73bb6fe7 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -53,6 +53,8 @@ static int dm_cancel_remove_partmaps(const char * mapname);
 #define __DR_UNUSED__ __attribute__((unused))
 #endif
 
+static int dm_remove_partmaps (const char * mapname, int need_sync,
+			       int deferred_remove);
 static int do_foreach_partmaps(const char * mapname,
 			       int (*partmap_func)(const char *, void *),
 			       void *data);
@@ -1544,7 +1546,7 @@ remove_partmap(const char *name, void *data)
 	return 0;
 }
 
-int
+static int
 dm_remove_partmaps (const char * mapname, int need_sync, int deferred_remove)
 {
 	struct remove_data rd = { need_sync, deferred_remove };
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 9d484dab..3fc8473b 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -74,8 +74,6 @@ int dm_geteventnr (const char *name);
 int dm_is_suspended(const char *name);
 int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
-int dm_remove_partmaps (const char * mapname, int need_sync,
-			int deferred_remove);
 int dm_get_uuid(const char *name, char *uuid, int uuid_len);
 bool has_dm_info(const struct multipath *mpp);
 int dm_get_info (const char * mapname, struct dm_info *dmi);
-- 
2.43.0

