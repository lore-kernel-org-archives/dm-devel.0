Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BB1DE2A8
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646554; cv=none; b=GgoS0uMLAg0j0Z3WmRCFfOOg06XX9S29mwFqUiDr9LKYsTeB0EPvgAWIMYD1mYCe3DwBtc2jHRQmzYHKIuut7RP9D2Qn9CT2ym7R33h8AZxscH9Sjsrl4jnNAlfUY5J/PzMjFQ+O1NNQhgM2fmdkgyeyxZrY1D2pyXKa/yMm6hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646554; c=relaxed/simple;
	bh=XUhD4O4t5lAtiOSYesm9OOWKk35/5NlsG2pgIeLPHOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=m/OB4eqfPTqFRVT+KFqacnbdMNAzrAZtYBCBca9Iiw/Rdhj6xv/MaGzOXEV5XJeMYbl09IjkaMTVRYSJ146MY7kLOqNjekdKjj5wwH1KIQQFpy4hhpq0jO7dvu8eyYF3A/oHkCqeyJJI21eMLWSnmqwX3rtujCdnD7YyTLkm7Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DaxY7sRy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DaxY7sRy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wewTApdoEdysViJ2N/bLQt5p3SE2PNk6llAxlDshnYE=;
	b=DaxY7sRyrLta2s4GW7qSV1IIEsv33KEvL0Cji8X24cWidsOtx75FsU63v9t0I/vg+3aBCr
	4ijLqC1qQrpX6aKMTUVoNZJEB1L8n8da8zPltPJEUg9gaudXewSUYXm5k8m/pXjIe5ZnTF
	bj2A02vL1Kb3vFYVky7B9HVMPnEvUL8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-413-VJI6_Ms1N3qW4BidQ7HHsw-1; Tue,
 26 Nov 2024 13:42:27 -0500
X-MC-Unique: VJI6_Ms1N3qW4BidQ7HHsw-1
X-Mimecast-MFC-AGG-ID: VJI6_Ms1N3qW4BidQ7HHsw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6FFC1955D4D;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F8A41944CC9;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgPei855492
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgP7x855491;
	Tue, 26 Nov 2024 13:42:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 03/12] libmultipath: fix removing device after failed creation
Date: Tue, 26 Nov 2024 13:42:15 -0500
Message-ID: <20241126184224.855459-4-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YPjQYNe8f3s7p0Y2gW4T-jIf7qqo8m3fOO3Ivmu_JBM_1732646547
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm_flush_nap_nosync() only removes a device if it has a multipath table.
On failed removes, there is no table, so this function does nothing.
Instead, if libmp_mapinfo() returns DMP_EMPTY, then there is an empty map,
and it is removed using dm_device_remove().

Also, since there are no longer any callers of dm_flush_map_nosync(),
remove it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 7 +++++--
 libmultipath/devmapper.h | 1 -
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 33425d02..42176667 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -557,9 +557,12 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 		 * Failing the second part leaves an empty map. Clean it up.
 		 */
 		err = errno;
-		if (dm_map_present(mpp->alias)) {
+		if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY |
+				  MAPINFO_CHECK_UUID,
+				(mapid_t) { .str = mpp->alias },
+				(mapinfo_t) { .uuid = NULL }) == DMP_EMPTY) {
 			condlog(3, "%s: failed to load map (a path might be in use)", mpp->alias);
-			dm_flush_map_nosync(mpp->alias);
+			dm_device_remove(mpp->alias, 0);
 		}
 		if (err != EROFS) {
 			condlog(3, "%s: failed to load map, error %d",
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 23926e3f..0bd2b907 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -174,7 +174,6 @@ enum {
 
 int dm_flush_map__ (const char *mapname, int flags, int retries);
 #define dm_flush_map(mapname) dm_flush_map__(mapname, DMFL_NEED_SYNC, 0)
-#define dm_flush_map_nosync(mapname) dm_flush_map__(mapname, DMFL_NONE, 0)
 #define dm_suspend_and_flush_map(mapname, retries) \
 	dm_flush_map__(mapname, DMFL_NEED_SYNC|DMFL_SUSPEND, retries)
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
-- 
2.46.2

