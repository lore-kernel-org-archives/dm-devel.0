Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A651DE2DB
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646554; cv=none; b=JJQF6WdI50Wr/9u9DScK+4jBK5x7VJrj0RhQFVqid7CiFUXuXUDcC+g4G6VW9p8xtMDogZEUwKNZJIGJPDCD1N31kNZsoWm/eb2e1MqGBtsR21ru7eIGrB0Rof8eF8qkDV8hkdE1nwOktJ6jIG0ihCbFnCsywB5Iia8eGOf59Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646554; c=relaxed/simple;
	bh=ak0leN0EgJu9ciA+tW8RgP47qWw9Vc8aPNm52ewvKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=iATPcynn4yI2DhqbW42IdTz5gDLIG/NtGTsWuZwtVbeQ51O/QOXlemHx9bOSQ3cn3f8NSOqvy7ge/B061FE756NViM33vlEkiU8y6uGH/YD954TDtNInbURvMye4ZwMgsdHfjCRBdLJ9uO2a2ReXXXbtPMB0W7dQT6U53JZ9kcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AMDaOEk9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AMDaOEk9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpcRNz/H2CM+kHBs5LD6ztwZ0gQBI9LknPsxoOar7SY=;
	b=AMDaOEk9QL3+i8PFnxwSgEOqjLl3tpaigBm565xlD/5bd0ZBcNRcrbnzHBdBy5lqXr7ae3
	HXTfH84YMWW3rzHKZttGARzknXe9V10w2o2MUJyapzPl7pwvhtesz4ryuPtLTjgkD3Aeqw
	wn/X9UtdL/K/hAUpJ4LtfmFxdUJcSEY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-TBv0g_xGNZOSQbVvC0I-XA-1; Tue,
 26 Nov 2024 13:42:28 -0500
X-MC-Unique: TBv0g_xGNZOSQbVvC0I-XA-1
X-Mimecast-MFC-AGG-ID: TBv0g_xGNZOSQbVvC0I-XA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D6B51955F2B;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 131DA195E486;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgPu7855500
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgPbX855499;
	Tue, 26 Nov 2024 13:42:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 05/12] libmultipath: check table type in dm_find_map_by_wwid
Date: Tue, 26 Nov 2024 13:42:17 -0500
Message-ID: <20241126184224.855459-6-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tShW0AOff1rCCXDX7Bp2HrIoDXM_X18ZB8SvSSYZ6Os_1732646547
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This function is only supposed to work on multipath devices (it adds the
multipath uuid prefix to the passed in wwid). Check this, and adapt
cli_add_map() to handle the corner case where there is a non-multipath
device with a multipath uuid.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c  | 2 +-
 multipathd/cli_handlers.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 38c49bd5..e5f49a5b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -892,7 +892,7 @@ int dm_find_map_by_wwid(const char *wwid, char *name, struct dm_info *dmi)
 	if (safe_sprintf(tmp, UUID_PREFIX "%s", wwid))
 		return DMP_ERR;
 
-	return libmp_mapinfo(DM_MAP_BY_UUID,
+	return libmp_mapinfo(DM_MAP_BY_UUID | MAPINFO_MPATH_ONLY,
 			     (mapid_t) { .str = tmp },
 			     (mapinfo_t) { .name = name, .dmi = dmi });
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 184c3f91..ec330d81 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -725,7 +725,13 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 		condlog(2, "%s: unknown map.", param);
 		return -ENODEV;
 	}
-	if (dm_find_map_by_wwid(refwwid, alias, &dmi) != DMP_OK) {
+	rc = dm_find_map_by_wwid(refwwid, alias, &dmi);
+	if (rc == DMP_NO_MATCH) {
+		condlog(2, "%s: wwid %s already in use by non-multipath device %s",
+			param, refwwid, alias);
+		return 1;
+	}
+	if (rc != DMP_OK) {
 		condlog(3, "%s: map not present. creating", param);
 		if (coalesce_paths(vecs, NULL, refwwid, FORCE_RELOAD_NONE,
 				   CMD_NONE) != CP_OK) {
-- 
2.46.2

