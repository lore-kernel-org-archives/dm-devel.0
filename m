Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D71C9DF7
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399592; cv=none; b=AErt6lNhRExdEsQ2zdZ9v9uRqvxZhXpVUhQQ/2mlwFJqOWvzt8ON68JjzPpjYppyKh/O89BPk8jnmuqDe1XbyFdIfw8RTIfOr2pQ9CC34YsVzsCeK2xQbUQA0FTRb7kn2vylzQlAWyv0aUtJdLRUBbmUcB9pteNCrs7LWKeup3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399592; c=relaxed/simple;
	bh=Fy9HZRyibRSl9H/SPtFrsXDC5dR9qnbRCSOKtibRMhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FuJ2tQTcGyU3/1k7930Jbri6/4oPvKMYLnwrExw89HqRyOPQy4kAPeowrybW4SUUzkhKt1vXSZgUfkAcH8huotp53AiIN6DjMZv3TyF3166aR4QgXylx02gEuzSQh9hqsoG8suIAvstO9lZY8wmzFH8nEhwdU0Pn5lFtht7OsaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5ZyJXb8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5ZyJXb8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPT7BWaZF9TszqQY2FQVFMMuYrn7+9JBNM205dyOofM=;
	b=N5ZyJXb8CPVqMr5ASr7Zo2qC75olcEwcl8KkUIzJBV86zjI1tXE+8i23dcvR7pEGHJUTSs
	FN8ABuxrIJJ4zH0h43tRn3yDjYus+90kXkVSGCplgki1sMWOvZPxvoQNb6Bb3Bb2CRY+3L
	+DE+07mXmryn8PY/wiycRXCsN+npmSo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-ahVPPZ5mOiqvZMX4Kq891Q-1; Thu,
 31 Oct 2024 14:33:06 -0400
X-MC-Unique: ahVPPZ5mOiqvZMX4Kq891Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 089CA1956048;
	Thu, 31 Oct 2024 18:33:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2B6119560B2;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX3nU391462
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX365391461;
	Thu, 31 Oct 2024 14:33:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 7/8] libmultipath: fix removing device after failed creation
Date: Thu, 31 Oct 2024 14:33:00 -0400
Message-ID: <20241031183301.391416-8-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
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

dm_flush_nap_nosync() only removes a device if it has a multipath table.
On failed removes, there is no table, so this function does nothing.
Instead, if libmp_mapinfo() returns DMP_BAD_DEV, then there is an empty map,
and it is removed using dm_device_remove().

Also, since there are no longer any callers of dm_flush_map_nosync(),
remove it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 7 +++++--
 libmultipath/devmapper.h | 1 -
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6e11d5b5..0d1552f5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -556,9 +556,12 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 		 * Failing the second part leaves an empty map. Clean it up.
 		 */
 		err = errno;
-		if (dm_map_present(mpp->alias)) {
+		if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY |
+				  MAPINFO_CHECK_UUID,
+				(mapid_t) { .str = mpp->alias },
+				(mapinfo_t) { .uuid = NULL }) == DMP_BAD_DEV) {
 			condlog(3, "%s: failed to load map (a path might be in use)", mpp->alias);
-			dm_flush_map_nosync(mpp->alias);
+			dm_device_remove(mpp->alias, 0);
 		}
 		if (err != EROFS) {
 			condlog(3, "%s: failed to load map, error %d",
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a2dcfb84..16d6e04f 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -166,7 +166,6 @@ enum {
 
 int dm_flush_map__ (const char *mapname, int flags, int retries);
 #define dm_flush_map(mapname) dm_flush_map__(mapname, DMFL_NEED_SYNC, 0)
-#define dm_flush_map_nosync(mapname) dm_flush_map__(mapname, DMFL_NONE, 0)
 #define dm_suspend_and_flush_map(mapname, retries) \
 	dm_flush_map__(mapname, DMFL_NEED_SYNC|DMFL_SUSPEND, retries)
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
-- 
2.46.2

