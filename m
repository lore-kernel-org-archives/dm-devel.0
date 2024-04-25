Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4923B15696F
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 23:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088126; cv=none; b=Njt2sidjzbS4/Tx776GNv/VNh1D2EwPJ/VuSPgUbzAuFXZ0a6H/j4SnJCOU0rSs1853RgxSU+5kvOK45EPt1eljgmwd8gToChYEBi+tCxgzUCAdBenh2e8c1r16cp5ImIFp8TORf6g05ag1gOM2pqnzaB8M+C8/2pM0OJjBt78w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088126; c=relaxed/simple;
	bh=NfmBLwkPLO6O022JwXSyhzIMSiM4O1p5qEZfUzAlEVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OkoHrB2BaBd7BZrOs46qrMIA371BGFHSicRgnQCjsdG/w9Xx5e6/c8mFqcHtT5mLF7pYJOMV3ufmMTwX5r4+CGIV8/woQVhGBRDPUtfvNIitCmDkLVOsMjZvyaKKvK+eBTd0LIn/NGdVIkr24CBV8xH6YyyEOf8NU46kuZcEnW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gc6kCrbD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gc6kCrbD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714088123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+hd0NZRB+CFZQIzTqOQNRFb5OgKc5V4hkQrl2MDUSw=;
	b=gc6kCrbDfni1CtZkyDPbjkj3XFhOGZ7AhY+GYOV1Ofi8annB49gypr8mNcptzpB9lF1V6F
	M/tbmFgxle5CZptZGqj/9Qmns4rs4WLTrm5BmIaZ6a1pifw/gY115WHXO2dXk7pZwU79js
	VaF0yVqq/VJBrNKAk2R2kTMNZa1fxUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-DQXrqLEGNUq4rRri0syHRg-1; Thu, 25 Apr 2024 19:35:19 -0400
X-MC-Unique: DQXrqLEGNUq4rRri0syHRg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5175804C61;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE912492BC7;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43PNZIXw2125176
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 19:35:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43PNZIaA2125175;
	Thu, 25 Apr 2024 19:35:18 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 5/5] libmultipath: fix deferred_remove function arguments
Date: Thu, 25 Apr 2024 19:35:17 -0400
Message-ID: <20240425233517.2125142-6-bmarzins@redhat.com>
In-Reply-To: <20240425233517.2125142-1-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
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

Aside from one version of dm_flush_map_nopaths(), all the callers of
_dm_flush_map() and dm_simplecmd() set deferred_remove to 0. But these
functions, as well as some helper functions they called, all treated the
deferred_remove argument as an enum deferred_remove_states, and called
do_deferred() to see if the remove should be deferred. To simplify the
code, make these functions treat deferred_remove as a boolean value
signifying whether a remove is deferred, and make dm_flush_map_nopaths()
do the work of checking if the remove should be deferred.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 19 +++++++++----------
 libmultipath/libmultipath.version |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a87abf7e..2e7b2c64 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -386,8 +386,6 @@ libmp_dm_task_create(int task)
 	return dm_task_create(task);
 }
 
-#define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
-
 static int
 dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
 	      uint16_t udev_flags, int deferred_remove __DR_UNUSED__) {
@@ -411,7 +409,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
 		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
 #ifdef LIBDM_API_DEFERRED
-	if (do_deferred(deferred_remove))
+	if (deferred_remove)
 		dm_task_deferred_remove(dmt);
 #endif
 	if (udev_wait_flag &&
@@ -1082,7 +1080,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
-	if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
+	if (!deferred_remove && partmap_in_use(mapname, NULL))
 			return DM_FLUSH_BUSY;
 
 	if (need_suspend &&
@@ -1100,7 +1098,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	if ((r = dm_remove_partmaps(mapname, need_sync, deferred_remove)))
 		return r;
 
-	if (!do_deferred(deferred_remove) && dm_get_opencount(mapname)) {
+	if (!deferred_remove && dm_get_opencount(mapname)) {
 		condlog(2, "%s: map in use", mapname);
 		return DM_FLUSH_BUSY;
 	}
@@ -1112,8 +1110,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 		r = dm_device_remove(mapname, need_sync, deferred_remove);
 
 		if (r) {
-			if (do_deferred(deferred_remove)
-			    && dm_map_present(mapname)) {
+			if (deferred_remove && dm_map_present(mapname)) {
 				condlog(4, "multipath map %s remove deferred",
 					mapname);
 				return DM_FLUSH_DEFERRED;
@@ -1147,7 +1144,10 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 int
 dm_flush_map_nopaths(const char * mapname, int deferred_remove)
 {
-	return _dm_flush_map(mapname, 1, deferred_remove, 0, 0);
+	return _dm_flush_map(mapname, 1,
+			     (deferred_remove == DEFERRED_REMOVE_ON ||
+			      deferred_remove == DEFERRED_REMOVE_IN_PROGRESS),
+			     0, 0);
 }
 
 #else
@@ -1539,8 +1539,7 @@ remove_partmap(const char *name, void *data)
 
 	if (dm_get_opencount(name)) {
 		dm_remove_partmaps(name, rd->need_sync, rd->deferred_remove);
-		if (!do_deferred(rd->deferred_remove) &&
-		    dm_get_opencount(name)) {
+		if (rd->deferred_remove && dm_get_opencount(name)) {
 			condlog(2, "%s: map in use", name);
 			return DM_FLUSH_BUSY;
 		}
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e070f296..eb511749 100644
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
-- 
2.43.0

