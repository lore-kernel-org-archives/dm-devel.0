Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5381B2765D1
	for <dm-devel@lists.linux.dev>; Wed, 20 Aug 2025 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755715178; cv=none; b=VtTn8IaOnOmuWzaRXJhYWmzsrqNUi6X8btrZ02DxBabMEfm8DOCPg1caIhF27fQPrK9q9spPw2drIFOvWSF8tWjWkQiPHOd9v6jmRhdnaw0fVXtLS3iL1ZngAinU8AfXHGXTjqSdTjQzXHwEnLGaANeFTy07eRGhhqytNI6UEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755715178; c=relaxed/simple;
	bh=xF+GhMFvLCnfLF/Od1pkjenIsZyivbSLshmgt6NUvrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=cLWbSsJVg6I/hH8rDkJql7sQt58SWYOXwV7BufMuYJsXK44Oss2lR0xT5becB3f+lBKMj+DcgbgLuKcvf/g9qCicXt4PJCnJkWeAVMR1PHCDrQSu2mUeZuxQ5fe648Vog9esa0qXxd4BVeh8exhpuLwIq84MVLyftsZJbNCiQFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AhJjWIMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AhJjWIMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755715176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kPb3kcmDvNY+xI/C21BZe0VSiRU1HdsMbMoUWK/gPVM=;
	b=AhJjWIMXvAZffDdubi3l4zpc2uQjTxMpddAp6PMzATLJOAaBD1XrBtBq4iwl1MzIgmdl0b
	N+YEj5T8GdKy1YUQo/tPVhag8RVFtRSKXCyQYpkwqZDlK0X7rgQ3r2FolqCEdv4/rAOsqS
	5ELAcd4ugMm1X/QXPcifArQRJxZuWxE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-rydiPGuvMXGtBC0OpsqzPg-1; Wed,
 20 Aug 2025 14:39:32 -0400
X-MC-Unique: rydiPGuvMXGtBC0OpsqzPg-1
X-Mimecast-MFC-AGG-ID: rydiPGuvMXGtBC0OpsqzPg_1755715171
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A77D1800357;
	Wed, 20 Aug 2025 18:39:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AAD319A4C99;
	Wed, 20 Aug 2025 18:39:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57KIdTXw037411
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 20 Aug 2025 14:39:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57KIdTrW037410;
	Wed, 20 Aug 2025 14:39:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: fix crash in print_foreign_topology
Date: Wed, 20 Aug 2025 14:39:28 -0400
Message-ID: <20250820183928.37402-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SiyCdbmcwNZNnqYlSvgy1tC1o-97n2TRRgwm0eWjLwY_1755715171
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

print_foreign_topology() called get_paths() to get a vector of
(struct gen_path *) items and then called get_multipath_layout__(),
which expects a vector of (struct gen_multipath *) items, with the path
vector. This can easily end badly. Fix it to correctly call
get_path_layout__(), and rename width to p_width in the functions that
end up calling snprint_multipath_topology__(), which is expecting to get
passed the path field widths.

Fixes: d54f271ef ("libmultipath: introduce width argument for pretty-printing functions")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/foreign.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 138b2eb3..72fef8b0 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -488,7 +488,7 @@ void foreign_multipath_layout(fieldwidth_t *width)
 }
 
 static int snprint_foreign_topology__(struct strbuf *buf, int verbosity,
-				      const fieldwidth_t *width)
+				      const fieldwidth_t *p_width)
 {
 	struct foreign *fgn;
 	int i;
@@ -506,7 +506,7 @@ static int snprint_foreign_topology__(struct strbuf *buf, int verbosity,
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gm, j) {
 				if (snprint_multipath_topology__(
-					    gm, buf, verbosity, width) < 0)
+					    gm, buf, verbosity, p_width) < 0)
 					break;
 			}
 		}
@@ -518,7 +518,7 @@ static int snprint_foreign_topology__(struct strbuf *buf, int verbosity,
 }
 
 int snprint_foreign_topology(struct strbuf *buf, int verbosity,
-			     const fieldwidth_t *width)
+			     const fieldwidth_t *p_width)
 {
 	int rc;
 
@@ -528,7 +528,7 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity,
 		return 0;
 	}
 	pthread_cleanup_push(unlock_foreigns, NULL);
-	rc = snprint_foreign_topology__(buf, verbosity, width);
+	rc = snprint_foreign_topology__(buf, verbosity, p_width);
 	pthread_cleanup_pop(1);
 	return rc;
 }
@@ -538,9 +538,9 @@ void print_foreign_topology(int verbosity)
 	STRBUF_ON_STACK(buf);
 	struct foreign *fgn;
 	int i;
-	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
-	if ((width = alloc_path_layout()) == NULL)
+	if ((p_width = alloc_path_layout()) == NULL)
 		return;
 	rdlock_foreigns();
 	if (foreigns == NULL) {
@@ -554,11 +554,11 @@ void print_foreign_topology(int verbosity)
 		fgn->lock(fgn->context);
 		pthread_cleanup_push(fgn->unlock, fgn->context);
 		vec = fgn->get_paths(fgn->context);
-		get_multipath_layout__(vec, LAYOUT_RESET_NOT, width);
+		get_path_layout__(vec, LAYOUT_RESET_NOT, p_width);
 		fgn->release_paths(fgn->context, vec);
 		pthread_cleanup_pop(1);
 	}
-	snprint_foreign_topology__(&buf, verbosity, width);
+	snprint_foreign_topology__(&buf, verbosity, p_width);
 	pthread_cleanup_pop(1);
 	printf("%s", get_strbuf_str(&buf));
 }
-- 
2.50.1

