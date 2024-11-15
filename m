Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3886319E98B
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712987; cv=none; b=nm5vrML0Jma7PJnZ18bW/MqZn+osr+RqCOEG1jeR0LVad7BzbZTIW3Qx7h6Fqxx1MNxKANRMBdbUNY/gzfVIpvTzv+z9Co7+4eVLFOIvFyB7057uqeXFGJCFX2goi0Lg9NugRz+XnngBYqr/ZnVkNUHZNE9QfgILdvxOnVjRmnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712987; c=relaxed/simple;
	bh=5u1fJfaqTxp5ngofSBsrH3Ty4t5CaaV50Q/BQT6r3qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLCyM5z2m4+ed2FWx1G3a9rCzDeIJgYIFQinQQZmbfrSe+3lXzDnaVxI6s/IDmcjHJHEyhU57Xm26/GPSAtZiruu2eTSRNq6DXqzonLhUet4op3OZwra9RStd0fsfnjxemFGjw/uwel+oqz6UfIAzGEZ89RQ5u8DLQuNgymYblA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZUhH/0+U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZUhH/0+U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731712984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrIsM1M6Hi4v7xXB9cBnBk0Dvf5k+gzPhDBAiU2nhoY=;
	b=ZUhH/0+UktdYYMVB7zbuCidLdH1thGKrCLo+MZ6ooir8Wb56o0ExJNuL5g+qWhlBt95K8M
	QwO6silhCCbRrE7EEnOZMf//20bv7OMc3Rx9m0HuqjRw/aPcYEM3qvl0pAARIJ7tt9chDf
	7jIYRYc8bbS+sFDa9MxTr9Bb2DoB6WU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-3v9HOHZTPzKrZ1CMdVjyAw-1; Fri,
 15 Nov 2024 18:23:01 -0500
X-MC-Unique: 3v9HOHZTPzKrZ1CMdVjyAw-1
X-Mimecast-MFC-AGG-ID: 3v9HOHZTPzKrZ1CMdVjyAw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 033FD19560A2;
	Fri, 15 Nov 2024 23:23:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A21B51956054;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AFNMw0R627972
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 18:22:58 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AFNMwdX627971;
	Fri, 15 Nov 2024 18:22:58 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 6/6] libmultipath: handle a create corner case for empty devices
Date: Fri, 15 Nov 2024 18:22:56 -0500
Message-ID: <20241115232256.627933-7-bmarzins@redhat.com>
In-Reply-To: <20241115232256.627933-1-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c2qt_nS_UqdH96rqQpQBZ2LvTPKh9xrHA3n4uj35IcM_1731712980
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Multipath already notices if there is any empty device with the same
alias and wwid as a device it is trying to create, and switches to a
reload. However, if the empty device has a different alias but the same
wwid, instead of reloading and renaming the device like it would for
a device with a table. multipath will attempt to create a new device
and fail.

Fix this by checking for these devices, and doing a reload and rename.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a7257981..d0e9c958 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -835,7 +835,6 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
 	struct config *conf;
-	char wwid[WWID_SIZE];
 
 	/*
 	 * last chance to quit before touching the devmaps
@@ -846,6 +845,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 	}
 
 	if (mpp->action == ACT_CREATE) {
+		char wwid[WWID_SIZE];
 		int rc = dm_get_wwid(mpp->alias, wwid, sizeof(wwid));
 
 		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid, sizeof(wwid))) {
@@ -863,7 +863,26 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 			mpp->action = ACT_REJECT;
 		}
 	}
+	if (mpp->action == ACT_CREATE) {
+		char alias[WWID_SIZE];
+		int rc = dm_find_map_by_wwid(mpp->wwid, alias, NULL);
 
+		if (rc == DMP_NO_MATCH) {
+			condlog(1, "%s: wwid \"%s\" already in use by non-multipath map \"%s\"",
+				mpp->alias, mpp->wwid, alias);
+			mpp->action = ACT_REJECT;
+		} else if (rc == DMP_OK || rc == DMP_EMPTY) {
+			/*
+			 * we already handled the case were rc == DMO_OK and
+			 * the alias == mpp->alias above. So the alias must be
+			 * different here.
+			 */
+			condlog(3, "%s: map already present with a different name \"%s\". reloading",
+				mpp->alias, alias);
+			strlcpy(mpp->alias_old, alias, WWID_SIZE);
+			mpp->action = ACT_RELOAD_RENAME;
+		}
+	}
 	if (mpp->action == ACT_RENAME || mpp->action == ACT_SWITCHPG_RENAME ||
 	    mpp->action == ACT_RELOAD_RENAME ||
 	    mpp->action == ACT_RESIZE_RENAME) {
-- 
2.46.2

