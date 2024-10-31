Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CE71C9EA4
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399593; cv=none; b=uGIaAy4DwjawugpY1BoorHfz0ZXrGSNqVXkHbX6OGGfN7psmvB0P4NVl8MgWe+WrFvzhfiNsh0OUxmPItDAh/UByCIMZFtDA5ge2wQj8vfLWl6812u6hzdkOcYGZACIof3eHMhRuuI+MNZR3y5fv5GZ+Rv3cRvb39Onq3c9YOMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399593; c=relaxed/simple;
	bh=prqdH0rBIyhmZtQ7obmHcCsRaZSiNVWOsG07f/WVn98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuOqyntAZv/HswuPQ6b3ucgGDeoHQz/TmPQcoaU2eUKOH64tyGpBtF8APQSaLV7ZP3PC5cItsu8Y0PIgIpkEL54x255oWHPao4mhE0+dlFMJLVVXn3asyPvaixfslAcy304h7uN2hXX7+voreiD1/5R99L1cFbCJgQ/pMnhwq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WR6t6FWh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WR6t6FWh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+R1mMtYdb+8tCMgmDuWHuVAyapTiGe2xtuVW/eeQNIw=;
	b=WR6t6FWhFmd3cAB3pKjuK/Oi0eubGp+SFFPznpMBATq4ugCJ/C0kgvziyqFtmJev6I1MD4
	laawcekisERjQO+LarPIny1JOef0TjIPrgAXLQRScpfRiZ2D5wo+NTrWqhKcXdjDHzAJF5
	pd+wk/D4DUB75k1FD1wnArfI5UrsTmk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-YRhZrxZqO8-qdUpMGkRkCQ-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: YRhZrxZqO8-qdUpMGkRkCQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8FB01955EA5;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 874A21956086;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX3Dv391458
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX3XO391457;
	Thu, 31 Oct 2024 14:33:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 6/8] libmultipath: signal multipath UUID device with no table
Date: Thu, 31 Oct 2024 14:32:59 -0400
Message-ID: <20241031183301.391416-7-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

if libmp_mapinfo() is run on a device that has a multipath prefixed DM
UUID but no table (either active or inactive), it will now return with a
new exit code, DMP_BAD_DEV, to signal that this is an invalid multipath
device. Currently all code paths treat this identically to
DMP_NOT_FOUND.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 18 ++++++++++++++++++
 libmultipath/devmapper.h |  5 ++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 13d8c1e5..6e11d5b5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -726,6 +726,22 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	}
 
 	if (info.target || info.status || info.size || flags & MAPINFO_TGT_TYPE__) {
+		if (!dmi.live_table) {
+			/*
+			 * If this is device has a multipath uuid but no
+			 * table, flag it, so multipath can clean it up
+			 */
+			if (flags & MAPINFO_CHECK_UUID &&
+			    !dmi.inactive_table) {
+				condlog(2, "%s: multipath map %s has no table",
+					fname__, map_id);
+				return DMP_BAD_DEV;
+			} else {
+				condlog(2, "%s: map %s has no table", fname__,
+					map_id);
+				return DMP_NOT_FOUND;
+			}
+		}
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
 			condlog(2, "%s: map %s has multiple targets", fname__, map_id);
@@ -869,6 +885,7 @@ int dm_is_mpath(const char *name)
 		return DM_IS_MPATH_YES;
 	case DMP_NOT_FOUND:
 	case DMP_NO_MATCH:
+	case DMP_BAD_DEV:
 		return DM_IS_MPATH_NO;
 	case DMP_ERR:
 	default:
@@ -1262,6 +1279,7 @@ int dm_get_maps(vector mp)
 			}
 			vector_set_slot(mp, mpp);
 			break;
+		case DMP_BAD_DEV:
 		case DMP_NO_MATCH:
 		case DMP_NOT_FOUND:
 			break;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index ba05e0a1..a2dcfb84 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -35,6 +35,7 @@ enum {
 	DMP_OK,
 	DMP_NOT_FOUND,
 	DMP_NO_MATCH,
+	DMP_BAD_DEV,
 	DMP_LAST__,
 };
 
@@ -99,7 +100,9 @@ typedef struct libmp_map_info {
  * @returns:
  *     DMP_OK if successful.
  *     DMP_NOT_FOUND if the map wasn't found, or has no or multiple targets.
- *     DMP_NO_MATCH if the map didn't match @tgt_type (see above).
+ *     DMP_NO_MATCH if the map didn't match @tgt_type (see above) or didn't
+ *                  have a multipath uuid prefix.
+ *     DMP_BAD_DEV if the map has a multipath uuid prefix but no table.
  *     DMP_ERR if some other error occurred.
  *
  * This function obtains the requested information for the device-mapper map
-- 
2.46.2

