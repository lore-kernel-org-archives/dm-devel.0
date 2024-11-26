Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D381D63E8
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646552; cv=none; b=eHgdLtT7eIlxeXgxqaK6GtVP25b/5FTRUnij3aAKJEz6J+a7E+DkFC2AFZmnpilW0W0HS/kIApMfFxrfGmiVxsMyV68o++NJe1pfEMTb6AbYhLiz1YDZ0/S2Ll6Fup/K4VoEIdWFlLO82lp5nmQWEGBk8zxiDab9Cwt3O7D2H/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646552; c=relaxed/simple;
	bh=5eXCg4qdYy8ZNFAVf9Cd5x4QgBtBkicMDOAZaOPimuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=d9Agmtjp+ZWR1aTyMOWWwUcSb6YrrVD+bj/wmPfmbW4X+T2ANjDsbWsCuJuYfCbx+wmuxrFj+peOvvhXsRQqqkBbf54S4clYYXh1vJaLrodYjJyamDmGFJ0cmIRTk9LqIHQBDblxGWFf4vw3QMcnJAbhLcf0yqibWhvzCEy7HgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MCybQtzF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MCybQtzF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vGIRN505w6PKozpr25dQRCf/jCu7829Rd3lDwrAzVdI=;
	b=MCybQtzFpjvlQJT21tPUVswd/2s1cLbU63nJwmFzobWZkhWKY2f0Qn0+MHrVzyhYuFr+yl
	ymwQqCguDtj+UTYKZcA/9bR+L6fkZF+6AFuOx/BreQm3hBtc6g7oB9cnmx7ISqBzT0IQFK
	v0y+BkWdemAoZV5kcElIOOFX1zO+qT4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-JEtDzR8zNlCnwW2ceaWN7A-1; Tue,
 26 Nov 2024 13:42:28 -0500
X-MC-Unique: JEtDzR8zNlCnwW2ceaWN7A-1
X-Mimecast-MFC-AGG-ID: JEtDzR8zNlCnwW2ceaWN7A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8CC21953944;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9884430001A0;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgQUl855516
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgQXB855515;
	Tue, 26 Nov 2024 13:42:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 09/12] libmultipath: remove recursive calls in partmap_funcs
Date: Tue, 26 Nov 2024 13:42:21 -0500
Message-ID: <20241126184224.855459-10-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y5VndP78V6Dzh0rdekH9-rL6Y8qmEexqfKOmFuIC4fs_1732646548
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

cancel_remove_partmap() and rename_partmap() both could end up calling
do_foreach_partmaps() with the partition instead of the original
multipath device. This won't ever do anything, since
do_foreach_partmaps() checks that it's called with a multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 59 +++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0df9ee40..751b45d8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1421,8 +1421,6 @@ dm_remove_partmaps (const char * mapname, int flags)
 static int
 cancel_remove_partmap (const char *name, void *unused __attribute__((unused)))
 {
-	if (dm_get_opencount(name))
-		dm_cancel_remove_partmaps(name);
 	if (dm_message(name, "@cancel_deferred_remove") != 0)
 		condlog(0, "%s: can't cancel deferred remove: %s", name,
 			strerror(errno));
@@ -1481,6 +1479,34 @@ struct rename_data {
 	char *delim;
 };
 
+static int
+dm_rename__(const char *old, char *new, int skip_kpartx)
+{
+	int r = 0;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	uint32_t cookie = 0;
+	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
+
+	if (!(dmt = libmp_dm_task_create(DM_DEVICE_RENAME)))
+		return r;
+
+	if (!dm_task_set_name(dmt, old))
+		return r;
+
+	if (!dm_task_set_newname(dmt, new))
+		return r;
+
+	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
+		return r;
+
+	r = libmp_dm_task_run(dmt);
+	if (!r)
+		dm_log_error(2, DM_DEVICE_RENAME, dmt);
+
+	libmp_udev_wait(cookie);
+	return r;
+}
+
 static int
 rename_partmap (const char *name, void *data)
 {
@@ -1492,7 +1518,7 @@ rename_partmap (const char *name, void *data)
 		return 0;
 	for (offset = strlen(rd->old); name[offset] && !(isdigit(name[offset])); offset++); /* do nothing */
 	if (asprintf(&buff, "%s%s%s", rd->new, rd->delim, name + offset) >= 0) {
-		dm_rename(name, buff, rd->delim, SKIP_KPARTX_OFF);
+		dm_rename__(name, buff, SKIP_KPARTX_OFF);
 		free(buff);
 		condlog(4, "partition map %s renamed", name);
 	} else
@@ -1522,32 +1548,9 @@ dm_rename_partmaps (const char * old, char * new, char *delim)
 int
 dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 {
-	int r = 0;
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	uint32_t cookie = 0;
-	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
-
 	if (dm_rename_partmaps(old, new, delim))
-		return r;
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_RENAME)))
-		return r;
-
-	if (!dm_task_set_name(dmt, old))
-		return r;
-
-	if (!dm_task_set_newname(dmt, new))
-		return r;
-
-	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
-		return r;
-
-	r = libmp_dm_task_run(dmt);
-	if (!r)
-		dm_log_error(2, DM_DEVICE_RENAME, dmt);
-
-	libmp_udev_wait(cookie);
-	return r;
+		return 0;
+	return dm_rename__(old, new, skip_kpartx);
 }
 
 void dm_reassign_deps(char *table, const char *dep, const char *newdep)
-- 
2.46.2

