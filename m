Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D00F18C05
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850716; cv=none; b=mSg5Fk3MY1XvmRKcBo05+DN2XfeyAcnfuf/gGy+7UKGnLsjsXpTCjTUgtcPvSr8bm3Osz9oYmyYxY2I5OfVr63pRZqedByCrAyzycSOYcLSiYWO6O1PO1iC3waLIdPBSn/dEOeYogITCGt93b0jXk+fOPI5zIXX2pqwCZMBGlYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850716; c=relaxed/simple;
	bh=D85aTLVA4iVcaBJBVSq3Lqr2gfaZpWsFSd3gAVs5E1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYtOCsuNzyims2QNNqoa+LR+lV9dXbnApSQLcU6T1KVSpF2hml3+tsZ72BSoB8vIEKdT9kRwcSuhI5D5AKnY3L7sFRHNzNzlnkFWg8BQUCKvFfKUQX70QaNILChe5A1UsDTVLiLK9g6vnvuEF/ASzVto4rvNPgd+J1ZCD+vEX2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b1BA2UN4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1BA2UN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BqUH7BeXziyi7bmuSpx/iosOsKz2cyeKRHJu015htM=;
	b=b1BA2UN4ZMjhvkCgrQ/H/xm3giMJzbZbBQb785JcPj5xvztspCfMx4NvbN1lQbDSlYK9Pq
	NAR6pZXS0UQWCnhNwSR0Y6UukMcNc68BWiRF4viLoPETwdjX730DqWgZAlHHlu5AQzxeEh
	BmjABNj50TTwYJnmFD7cyF7iwGN+gJY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-DGAgHC52NtuEM_wluilHjg-1; Sat,
 13 Jul 2024 02:05:10 -0400
X-MC-Unique: DGAgHC52NtuEM_wluilHjg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5897519560B0;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFFCF3000181;
	Sat, 13 Jul 2024 06:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D657GY2015498
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D657S32015497;
	Sat, 13 Jul 2024 02:05:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 01/22] libmultipath: rename dm_map_present_by_wwid() and add outputs
Date: Sat, 13 Jul 2024 02:04:45 -0400
Message-ID: <20240713060506.2015463-2-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

add arguments to dm_map_present_by_wwid() to allow optionally fetching
the device name and minor number for the devices found by WWID.  These
will be used by a later patch. Since it can now also be used to get the
name and minor number of a device from its WWID, rename it to
dm_find_map_by_wwid()

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 16 ++++++++++++----
 libmultipath/devmapper.h |  2 +-
 libmultipath/valid.c     |  2 +-
 tests/valid.c            | 12 ++++++------
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index bbbadeee..60d786c6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -872,16 +872,24 @@ int dm_is_mpath(const char *name)
 	}
 }
 
-int dm_map_present_by_wwid(const char *wwid)
+/* if name is non-NULL, it must point to an array of WWID_SIZE bytes */
+int dm_find_map_by_wwid(const char *wwid, char *name, int *minor)
 {
 	char tmp[DM_UUID_LEN];
+	struct dm_info dmi;
+	int rc;
 
 	if (safe_sprintf(tmp, UUID_PREFIX "%s", wwid))
 		return DMP_ERR;
 
-	return libmp_mapinfo(DM_MAP_BY_UUID,
-			     (mapid_t) { .str = tmp },
-			     (mapinfo_t) { .name = NULL });
+	rc = libmp_mapinfo(DM_MAP_BY_UUID,
+			   (mapid_t) { .str = tmp },
+			   (mapinfo_t) { .name = name,
+					 .dmi = minor ? &dmi : NULL });
+	if (rc == DMP_OK && minor)
+		*minor = dmi.minor;
+
+	return rc;
 }
 
 static int dm_dev_t (const char *mapname, char *dev_t, int len)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index c28991fb..1de694c9 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -132,7 +132,7 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
-int dm_map_present_by_wwid(const char *uuid);
+int dm_find_map_by_wwid(const char *wwid, char *name, int *minor);
 
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
index a93bbe50..d9325f8b 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -189,10 +189,10 @@ int __wrap_check_wwids_file(char *wwid, int write_wwid)
 		return -1;
 }
 
-int __wrap_dm_map_present_by_wwid(const char *uuid)
+int __wrap_dm_find_map_by_wwid(const char *wwid, char *name, int *minor)
 {
 	int ret = mock_type(int);
-	assert_string_equal(uuid, mock_ptr_type(char *));
+	assert_string_equal(wwid, mock_ptr_type(char *));
 	return ret;
 }
 
@@ -271,8 +271,8 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 	will_return(__wrap_check_wwids_file, wwid);
 	if (stage == STAGE_CHECK_WWIDS)
 		return;
-	will_return(__wrap_dm_map_present_by_wwid, 0);
-	will_return(__wrap_dm_map_present_by_wwid, wwid);
+	will_return(__wrap_dm_find_map_by_wwid, 0);
+	will_return(__wrap_dm_find_map_by_wwid, wwid);
 }
 
 static void test_bad_arguments(void **state)
@@ -516,8 +516,8 @@ static void test_check_uuid_present(void **state)
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

