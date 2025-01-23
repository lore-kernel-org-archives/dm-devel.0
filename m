Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5FD81741
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602214; cv=none; b=h6wYTWfeQ+RPDsUxx+vDU+xU0Mz+/BNZCgbJaUPz5mdLcrnmD05Wf60QEMoETG5+4o6soSUmrJTyi045aXzoOQkPeXtIb0njrA5sQ2lHkGn2kPbDX0LViyTwvLoPzJ4t8YuYCcchyH22y5DR1UL/rxCXioaXVgwJCER/ljTVKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602214; c=relaxed/simple;
	bh=11rleTVwmSB1nUPaomHGx29yQ7wWTiq9rkIqu09iZ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=KeSmSaZhs1XMx2WiJ+zNO1RDYBYdjr5uQOsAaj/H8Qe+AcsiGFr+pG1on8hGb6kIQag6UGk4ujmfuwLzz2OUBU+lDe0Hy/0xJKSVKGX/VEr9tx4nqXQ3xeHEfqSLsWtKZOFyhYTqyOz4Qlt2OemOKJAUdTEd97LDCyucTxQdMOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H//OQ/uM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H//OQ/uM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcytcrqYUjPVae6BucmxX12STAaxmI/kXpiLUb0TKMM=;
	b=H//OQ/uMjSrBVJuNko9kRIQ3822DKDxM/Ha4lqu+pRMPIMYOzJNyARYIXX9jB/jIXsckYX
	ur7EgF0vcAm8QBLVJdJ+49wiiVvYWr4stszvLtARMhuENV4y5AaTiTEon4isb7ETJ3MUSc
	xGQh6M5Tk5v3zGyGHvLL9kekM319Nww=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-eMSIkK_cPyOS4bTOi0D7Nw-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: eMSIkK_cPyOS4bTOi0D7Nw-1
X-Mimecast-MFC-AGG-ID: eMSIkK_cPyOS4bTOi0D7Nw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D61A19560A3;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66DA119560B7;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3Gj5U3017949
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GjIK3017948;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 09/13] libmultipath: retry DI_IOCTL functions if they were skipped
Date: Wed, 22 Jan 2025 22:16:39 -0500
Message-ID: <20250123031643.3017891-10-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -pZNQhJgGxc211967R_fTQ_B_txm0ZxyS7HUDB4OR28_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

pathinfo() shouldn't call any of the DI_IOCTL functions if path_state is
not PATH_UP (It only actually checked this for scsi_ioctl_pathinfo).
But since pathinfo() is rarely called with the DI_IOCTL flag, this
information might never be gathered if a path is added, and pathinfo is
first called, while it's offline. Make paths remember if they skipped
the DI_IOCTL calls because the path was offline, and try again on future
pathinfo() calls that don't set DI_NOIO.

Also make dm_setgeometry check all paths, since it's possible that
set_geometry() was skipped (in the past, the ioctls would just fail for
the offline device, with the same result).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 22 ++++++++++++++--------
 libmultipath/discovery.c | 24 ++++++++++++------------
 libmultipath/structs.h   |  7 +++++++
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 55052cf5..8e632ba8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1704,7 +1704,10 @@ int dm_reassign(const char *mapname)
 int dm_setgeometry(struct multipath *mpp)
 {
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	struct pathgroup *pgp;
 	struct path *pp;
+	int i, j;
+	bool found = false;
 	char heads[4], sectors[4];
 	char cylinders[10], start[32];
 	int r = 0;
@@ -1712,15 +1715,18 @@ int dm_setgeometry(struct multipath *mpp)
 	if (!mpp)
 		return 1;
 
-	pp = first_path(mpp);
-	if (!pp) {
-		condlog(3, "%s: no path for geometry", mpp->alias);
-		return 1;
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (pp->geom.cylinders != 0 &&
+			    pp->geom.heads != 0 &&
+			    pp->geom.sectors != 0) {
+				found = true;
+				break;
+			}
+		}
 	}
-	if (pp->geom.cylinders == 0 ||
-	    pp->geom.heads == 0 ||
-	    pp->geom.sectors == 0) {
-		condlog(3, "%s: invalid geometry on %s", mpp->alias, pp->dev);
+	if (!found) {
+		condlog(3, "%s: no path with valid geometry", mpp->alias);
 		return 1;
 	}
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 8a780d69..2015a32f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1908,13 +1908,10 @@ sysfs_pathinfo(struct path *pp, const struct vector_s *hwtable)
 }
 
 static void
-scsi_ioctl_pathinfo (struct path * pp, int mask)
+scsi_ioctl_pathinfo (struct path * pp)
 {
 	int vpd_id;
 
-	if (!(mask & DI_IOCTL))
-		return;
-
 	select_vpd_vendor_id(pp);
 	vpd_id = pp->vpd_vendor_id;
 
@@ -2433,14 +2430,17 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		goto blank;
 	}
 
-	if (mask & DI_IOCTL)
-		get_geometry(pp);
-
-	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI)
-		scsi_ioctl_pathinfo(pp, mask);
-
-	if (pp->bus == SYSFS_BUS_CCISS && mask & DI_IOCTL)
-		cciss_ioctl_pathinfo(pp);
+	if (mask & DI_IOCTL || pp->ioctl_info == IOCTL_INFO_SKIPPED) {
+		if (path_state == PATH_UP) {
+			get_geometry(pp);
+			if (pp->bus == SYSFS_BUS_SCSI)
+				scsi_ioctl_pathinfo(pp);
+			else if (pp->bus == SYSFS_BUS_CCISS)
+				cciss_ioctl_pathinfo(pp);
+			pp->ioctl_info = IOCTL_INFO_COMPLETED;
+		} else if (pp->ioctl_info == IOCTL_INFO_NOT_REQUESTED)
+			pp->ioctl_info = IOCTL_INFO_SKIPPED;
+	}
 
 	if (mask & DI_CHECKER) {
 		if (path_state == PATH_UP) {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 1b5a878b..28de9a7f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -353,6 +353,12 @@ struct hd_geometry {
 
 #define GROUP_ID_UNDEF -1
 
+enum ioctl_info_states {
+	IOCTL_INFO_NOT_REQUESTED = 0,
+	IOCTL_INFO_SKIPPED,
+	IOCTL_INFO_COMPLETED,
+};
+
 struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
@@ -412,6 +418,7 @@ struct path {
 	vector hwe;
 	struct gen_path generic_path;
 	int tpg_id;
+	enum ioctl_info_states ioctl_info;
 };
 
 typedef int (pgpolicyfn) (struct multipath *, vector);
-- 
2.46.2

