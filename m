Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72637174EF0
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629782; cv=none; b=URrPOU2NyBP0yHdmy9x1ataIlmT6vynEhglomtJp8Uzpa3yDBsOcU3jbS6iH12BGrIcLQLaoxUm4EKTKrps8C69V+bT3bIX/UR29OINehMgRI+Pb6WPHHFQgaCKeJIc25vB8t9L3iCVDDGFhObFQg6kp532rWVFbRzoQdmgaPmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629782; c=relaxed/simple;
	bh=XXPt93P4+lRD3Jvmb1s/RsBLeG8qamwtVCVM93LKp98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RcdGFJ/swRHG7M1qCOBsrrDI8mPg9b8DKcufeIOs4F6vRS5aT0gEdIfnDfx9Ps81dp424311yET32JUHoeREtSK8GqTwnXp2RI+s2sSYJi/pvxo/X+zIL0iUxG78Q8uWf/FgrCamJdIhXbIqysyqQs1jEgnoBHqtJ3WecT5t8JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRco2Zgi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRco2Zgi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SqBA2g2qkzN61mkhEHViKXAw9vbRK8sDH2TG1Me+u8=;
	b=CRco2Zgiv5BookowMrO7Pbj0D0BzFjerjOqZCYtCTTls40eQumfOwnzpJ9Sfi1Dz/5N/r2
	7mBXGSXq+FMvBgtJ1TJnKY+0262LA8j4VMEoyEYNUuKJ9ciMwNKJUqRoqLjBthe6RRqT21
	QoCsUxC5bkEamcOKp9KEoQS0OlC+Be4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-Rg3DeZ-hOa6G2NZPMOPUvA-1; Wed,
 05 Jun 2024 19:22:56 -0400
X-MC-Unique: Rg3DeZ-hOa6G2NZPMOPUvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 987053806704;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9243B2166AFA;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMtP3623322
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMtPi623321;
	Wed, 5 Jun 2024 19:22:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 4/7] libmultipath: add name and minor outputs for dm_map_present_by_uuid()
Date: Wed,  5 Jun 2024 19:22:51 -0400
Message-ID: <20240605232254.623290-5-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

add arguments to dm_map_present_by_uuid() to allow optionally fetching
the device name and minor number for the devices found by WWID. These
will be used by a later patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 11 ++++++++++-
 libmultipath/devmapper.h          |  2 +-
 libmultipath/libmultipath.version |  2 +-
 libmultipath/valid.c              |  2 +-
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 08bb3c51..7fe68841 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -936,7 +936,7 @@ out:
  *  -1 : error
  */
 int
-dm_map_present_by_uuid(const char *uuid)
+dm_map_present_by_uuid(const char *uuid, char **name_p, int *minor)
 {
 	struct dm_task *dmt;
 	struct dm_info info;
@@ -966,6 +966,15 @@ dm_map_present_by_uuid(const char *uuid)
 		goto out_task;
 
 	r = !!info.exists;
+	if (!r)
+		goto out_task;
+
+	if (name_p) {
+		const char *name = dm_task_get_name(dmt);
+		*name_p = (name && strlen(name)) ? strdup(name) : NULL;
+	}
+	if (minor)
+		*minor = info.minor;
 
 out_task:
 	dm_task_destroy(dmt);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 19b79c5b..d9c71e92 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -43,7 +43,7 @@ int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present (const char *name);
-int dm_map_present_by_uuid(const char *uuid);
+int dm_map_present_by_uuid(const char *uuid, char **name_p, int *minor);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
 int dm_type(const char *name, char *type);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index eb511749..600de394 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_24.0.0 {
+LIBMULTIPATH_25.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index f2237787..3b060192 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -360,7 +360,7 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 	if (check_wwids_file(pp->wwid, 0) == 0)
 		return PATH_IS_VALID_NO_CHECK;
 
-	if (dm_map_present_by_uuid(pp->wwid) == 1)
+	if (dm_map_present_by_uuid(pp->wwid, NULL, NULL) == 1)
 		return PATH_IS_VALID;
 
 	/* all these act like FIND_MULTIPATHS_STRICT for finding if a
-- 
2.45.0

