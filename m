Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95F14388F
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 22:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713911141; cv=none; b=S/NMzNnHFbRmAhPX6QYEZwY1rv7V4CdPDEMcleyKyVcA52RevitYCMbV6OvgRsVgwELMdL3m9F8N/1bONo9gR+dqoQ8G8DLbuiDyY7kfi9LSo+bpb/tJUhG8R3lyV9B68M/Jb4Evws9+ISqH5ic3e276B/E9/wQEA6HzcvCYeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713911141; c=relaxed/simple;
	bh=6PRtYt+T8bgwH/DGwEdKIJk2367IdtigKyAiTG6oC1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ug7iEbSPmPBmTxDfgOZjiy2UEekHY0xgVVxksntY8qahj4IXECoR5jIeO8QQvuM/LZpkh3A+dLiz1/Rr4H96qNJtWWwiF6lBqDZrhOzAPSOKLVGzTYXu6BmLry0SFHQ1AlAx61QngW9hmaogSJHHGhrci1IEeI2nOln/9Zzda5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vzty98JJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vzty98JJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713911139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y4LLD+dnUtc9yH8/ZbmIKSf8hyFGxlrI5WW5Mpgxxs=;
	b=Vzty98JJFs5pZpza5egaPCl5lwV7mIcQZd6KQMM9ShLCH5F7rmorCmbmLNSlXDMf0eXa0M
	POXqt1TJI70Q3hnK+BCFqTvnudE/BU5ctTYHeEUjAjZtyD/I3XQNbazTkV7Zgc/0z3o5bj
	kwu4gxLumt6jTtRFsHFbpyGk51dihhU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-bnh0xfznPaGmDVDoMjNWpQ-1; Tue, 23 Apr 2024 18:25:37 -0400
X-MC-Unique: bnh0xfznPaGmDVDoMjNWpQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C41B18065AF;
	Tue, 23 Apr 2024 22:25:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44CFB40F183;
	Tue, 23 Apr 2024 22:25:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43NMPbYX2096510
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 18:25:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43NMPbbC2096509;
	Tue, 23 Apr 2024 18:25:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/3] libmultipath: simplify dm_flush_map_nopaths
Date: Tue, 23 Apr 2024 18:25:36 -0400
Message-ID: <20240423222536.2096486-4-bmarzins@redhat.com>
In-Reply-To: <20240423222536.2096486-1-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Now that flush_map_nopaths(), its only caller, needs to deal with
whether or not a remove is deferred, dm_flush_map_nopaths()
doesn't need to worry if LIBDM_API_DEFERRED is defined. It can just
trust that the caller took care of making sure deferred_remove is
correct.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 19 -------------------
 libmultipath/devmapper.h          |  3 ++-
 libmultipath/libmultipath.version |  3 +--
 3 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 24d03e83..dc8c4d17 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1140,25 +1140,6 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	return DM_FLUSH_FAIL;
 }
 
-#ifdef LIBDM_API_DEFERRED
-
-int
-dm_flush_map_nopaths(const char * mapname, int deferred_remove)
-{
-	return _dm_flush_map(mapname, 1, deferred_remove, 0, 0);
-}
-
-#else
-
-int
-dm_flush_map_nopaths(const char * mapname,
-		     int deferred_remove __attribute__((unused)))
-{
-	return _dm_flush_map(mapname, 1, 0, 0, 0);
-}
-
-#endif
-
 int dm_flush_maps (int retries)
 {
 	int r = DM_FLUSH_FAIL;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 2987a1b5..8599ee98 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -61,7 +61,8 @@ enum {
 
 int partmap_in_use(const char *name, void *data);
 int _dm_flush_map (const char *, int, int, int, int);
-int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
+#define dm_flush_map_nopaths(mapname, deferred) \
+	_dm_flush_map(mapname, 1, deferred, 0, 0)
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
 #define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0, 0, 0)
 #define dm_suspend_and_flush_map(mapname, retries) \
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e070f296..806676bf 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_23.0.0 {
+LIBMULTIPATH_24.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -74,7 +74,6 @@ global:
 	dm_enablegroup;
 	dm_fail_path;
 	_dm_flush_map;
-	dm_flush_map_nopaths;
 	dm_flush_maps;
 	dm_geteventnr;
 	dm_get_info;
-- 
2.43.0

