Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB89B178CF6
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309905; cv=none; b=T7hWwlcJPsbOtmbew6PxICKsD5TbRB4ZHoobhj2T4lnrFkMAgfRUCQU5eWuO2tBGRpZMQGKQf2L1+r8QdyQMGml/PYehjjrgH1lLY8juj4ia96KwE6RvJQJ2VZzpi3l3l1V778hkGxQ9fyq45FKaFidNvSOdSliR5NKMHweD6q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309905; c=relaxed/simple;
	bh=hNp8aWzVrgDcvGmpvL3KKXveArT/1inn8TGDDT63C7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lZAdhW8LnLJcUHezHcj9LEIxQJhygJZ44tSrcTmj0GoKuSlAYqGIPGMpCfGfvc+wDXAhnBw2wAzLLCdt+wR3OmNAKpAdbV9bk/tYwhpnnpDY5QqygT8ugHLFMcmHehN1tj9Bymf8pdO3v8mBFBDbcAzUIBkcj0kCAHMlo/eu0lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4RieKK1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4RieKK1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47tzZZFAwY5Er/bvu2kHSwnueG5bGT0+04j0TwjAM7Q=;
	b=C4RieKK19cgOidjGYcT5USnZcqMSLSZHazZx5surtdcdh7CBBzYy/f8ifz7QVadfRPcCy5
	TYHhRL+GuhcEF7mjSkDvt1TsGV0Wsz9wL0VvIy8fISBOYjoEp9RbyyCD8za0u8rM4FqhEg
	Bbjdv6tyYCPxQRu5KykYDBfqCky4NwY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-cQNnjzaJOmuZX2ocJTm6FQ-1; Fri,
 22 Nov 2024 16:11:38 -0500
X-MC-Unique: cQNnjzaJOmuZX2ocJTm6FQ-1
X-Mimecast-MFC-AGG-ID: cQNnjzaJOmuZX2ocJTm6FQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38D70195609F;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE1811955E9E;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBZsi718919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBZSp718918;
	Fri, 22 Nov 2024 16:11:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 09/13] libmultipath: remove recursive calls in partmap_funcs
Date: Fri, 22 Nov 2024 16:11:29 -0500
Message-ID: <20241122211133.718861-10-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QhKoOmdcxHugaszoi3KGaFb6Q7j8quo7fCYhNhDMm7c_1732309897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

cancel_remove_partmap() and rename_partmap() both could end up calling
do_foreach_partmaps() with the partition instead of the original
multipath device. This won't ever do anything, since
do_foreach_partmaps() checks that it's called with a multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0df9ee40..daaeebb4 100644
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
@@ -1481,6 +1479,9 @@ struct rename_data {
 	char *delim;
 };
 
+static int
+dm_rename__(const char *old, char *new, int skip_kpartx);
+
 static int
 rename_partmap (const char *name, void *data)
 {
@@ -1492,7 +1493,7 @@ rename_partmap (const char *name, void *data)
 		return 0;
 	for (offset = strlen(rd->old); name[offset] && !(isdigit(name[offset])); offset++); /* do nothing */
 	if (asprintf(&buff, "%s%s%s", rd->new, rd->delim, name + offset) >= 0) {
-		dm_rename(name, buff, rd->delim, SKIP_KPARTX_OFF);
+		dm_rename__(name, buff, SKIP_KPARTX_OFF);
 		free(buff);
 		condlog(4, "partition map %s renamed", name);
 	} else
@@ -1519,17 +1520,14 @@ dm_rename_partmaps (const char * old, char * new, char *delim)
 	return do_foreach_partmaps(old, rename_partmap, &rd);
 }
 
-int
-dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
+static int
+dm_rename__(const char *old, char *new, int skip_kpartx)
 {
 	int r = 0;
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint32_t cookie = 0;
 	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
-	if (dm_rename_partmaps(old, new, delim))
-		return r;
-
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_RENAME)))
 		return r;
 
@@ -1550,6 +1548,14 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 	return r;
 }
 
+int
+dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
+{
+	if (dm_rename_partmaps(old, new, delim))
+		return 0;
+	return dm_rename__(old, new, skip_kpartx);
+}
+
 void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 {
 	char *n, *newtable;
-- 
2.46.2

