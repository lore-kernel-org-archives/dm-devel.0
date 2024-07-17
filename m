Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB47470
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239874; cv=none; b=p2rTKyPOueNrddKrK57I7rSqSJatRfS/dhZ4gDFKLgi9cESaHZ4uxJt+xLF1aSOlXN+yBM2WF+WM48ZUIP/7ayQgFJYaeIe0eR8bT4Bb9fyCoJT/frDRN9yPQr08tckW5U3bBmdh72lyAZp+/nxju8VdihU6YG31IUtH9ZBCLyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239874; c=relaxed/simple;
	bh=hEQ2G+6ciD1ynuLJRz6N7W9UvqV7BhKvDgOR8I0XCyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrxDKUnj4p1jQDm0XqVo/8j0GJqxHRkNZ+b2bgbQoXzY+YhTo0vsYc/VbWGvfG2TUVsZJRX/sQzr1p9lKMOeOnrBMboZJa7BUqnSp+X1NS+CNVyM6Q4lEjIYH9DqfKEYTtGQDNocc6asRD8xS3M2jLMcCJ0WVISleZc/XOzWgdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfU06IUF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfU06IUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lfyWsfYu1u/vV8zv8J5I7DL/1kM861ywCTQUO0RXkGk=;
	b=BfU06IUFQ0UWtMFbYL+sGO875loWSXJhfDA6CkbNjE3vFSM8e9/5jAVaav76euQgAculRR
	GofnjMboBRN5jTUd3Cd2BdPBeEdSJ9t8aim9/8zC7ahisl9awVo6yqprz8RJjerN7AoUb8
	Agz5y4xOx11enByS3jd0IJQWPVGRUvM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-vwFiPN4FNbOnDoakfFfzyg-1; Wed,
 17 Jul 2024 14:11:10 -0400
X-MC-Unique: vwFiPN4FNbOnDoakfFfzyg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 040721955D4F;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D0911955F40;
	Wed, 17 Jul 2024 18:11:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB7X92173560
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB7pE2173559;
	Wed, 17 Jul 2024 14:11:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 01/20] libmultipath: rename dm_map_present_by_wwid() and add outputs
Date: Wed, 17 Jul 2024 14:10:47 -0400
Message-ID: <20240717181106.2173527-2-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

add arguments to dm_map_present_by_wwid() to allow optionally fetching
the device name and dm info for the devices found by WWID.  These will
be used by a later patch. Since it can now also be used to get the name
and dm info of a device from its WWID, rename it to
dm_find_map_by_wwid()

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c |  5 +++--
 libmultipath/devmapper.h |  2 +-
 libmultipath/valid.c     |  2 +-
 tests/valid.c            | 13 +++++++------
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3d256d38..9af0a80e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -874,7 +874,8 @@ int dm_is_mpath(const char *name)
 	}
 }
 
-int dm_map_present_by_wwid(const char *wwid)
+/* if name is non-NULL, it must point to an array of WWID_SIZE bytes */
+int dm_find_map_by_wwid(const char *wwid, char *name, struct dm_info *dmi)
 {
 	char tmp[DM_UUID_LEN];
 
@@ -883,7 +884,7 @@ int dm_map_present_by_wwid(const char *wwid)
 
 	return libmp_mapinfo(DM_MAP_BY_UUID,
 			     (mapid_t) { .str = tmp },
-			     (mapinfo_t) { .name = NULL });
+			     (mapinfo_t) { .name = name, .dmi = dmi });
 }
 
 static int dm_dev_t (const char *mapname, char *dev_t, int len)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index f6d0017e..a26dc1e5 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -132,7 +132,7 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
-int dm_map_present_by_wwid(const char *uuid);
+int dm_find_map_by_wwid(const char *wwid, char *name, struct dm_info *dmi);
 
 enum {
 	DM_IS_MPATH_NO,
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index 9267cef9..b7e0cc9b 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -360,7 +360,7 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 	if (check_wwids_file(pp->wwid, 0) == 0)
 		return PATH_IS_VALID_NO_CHECK;
 
-	if (dm_map_present_by_wwid(pp->wwid) == DMP_OK)
+	if (dm_find_map_by_wwid(pp->wwid, NULL, NULL) == DMP_OK)
 		return PATH_IS_VALID;
 
 	/* all these act like FIND_MULTIPATHS_STRICT for finding if a
diff --git a/tests/valid.c b/tests/valid.c
index a93bbe50..ecaeb467 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -189,10 +189,11 @@ int __wrap_check_wwids_file(char *wwid, int write_wwid)
 		return -1;
 }
 
-int __wrap_dm_map_present_by_wwid(const char *uuid)
+int __wrap_dm_find_map_by_wwid(const char *wwid, char *name,
+			       struct dm_info *dmi)
 {
 	int ret = mock_type(int);
-	assert_string_equal(uuid, mock_ptr_type(char *));
+	assert_string_equal(wwid, mock_ptr_type(char *));
 	return ret;
 }
 
@@ -271,8 +272,8 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 	will_return(__wrap_check_wwids_file, wwid);
 	if (stage == STAGE_CHECK_WWIDS)
 		return;
-	will_return(__wrap_dm_map_present_by_wwid, 0);
-	will_return(__wrap_dm_map_present_by_wwid, wwid);
+	will_return(__wrap_dm_find_map_by_wwid, 0);
+	will_return(__wrap_dm_find_map_by_wwid, wwid);
 }
 
 static void test_bad_arguments(void **state)
@@ -516,8 +517,8 @@ static void test_check_uuid_present(void **state)
 	memset(&pp, 0, sizeof(pp));
 	conf.find_multipaths = FIND_MULTIPATHS_STRICT;
 	setup_passing(name, wwid, CHECK_MPATHD_RUNNING, STAGE_CHECK_WWIDS);
-	will_return(__wrap_dm_map_present_by_wwid, 1);
-	will_return(__wrap_dm_map_present_by_wwid, wwid);
+	will_return(__wrap_dm_find_map_by_wwid, 1);
+	will_return(__wrap_dm_find_map_by_wwid, wwid);
 	assert_int_equal(is_path_valid(name, &conf, &pp, true),
 			 PATH_IS_VALID);
 	assert_string_equal(pp.dev, name);
-- 
2.45.0

