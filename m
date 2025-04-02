Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0B91FC7CA
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743635610; cv=none; b=NNjfmy/2TFA7ISfCjwaCGtBqmC6a04c/blH59inrh8bN1C8b28KjAcrsqvBHHiMHQJp4Ejh1O1fr/h3puDTWZ/5HZo0ewLUqlM22S7NQvBzfB/6INMnl4y3Pc5Nqygl0XKjb/hQJOQFuOhETdyQv3xC6T0cEKf+LIhIruIBLlOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743635610; c=relaxed/simple;
	bh=zfej/LHdBiZ/zF47SgXz15+FbKYY9AYORajG+VicVm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Emg9Ero+6thxaUYBHmV03QkK+rjY6Gx16ULVHNQcfm++LCVkV4Lkcf/J84OuUEvTgMoluhgqj/uZGRNwRBV4RNSr/peQrltXuBENZ9i4S/kKfMqjEgtQDmYVAcDdGh83nch5yhbJPO3zcthoPxRy4p8v9ANS/MAeFj21Ls/jaTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=epQJaWOT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epQJaWOT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743635607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+dIOWtXho6/gXoFh2i/yxa9canc0lXLKFdj9ISjrG8=;
	b=epQJaWOTRe3puqQeNXw8bQqV+9+JjQTXznXG4IRYHGDXqc+HEB65sqzqacbU1yowfS2jiw
	OdPOZ/6RXeo4J/kbfv453b4U9FEb+ZomVoxGmOAEZFWTcfWg1t/7VFCoqc7UlgxuZfTndl
	YegKYptKN0e34h5BkOOL8Etx5+L4uQo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-337KYjmiNTiUv2JF63frcg-1; Wed,
 02 Apr 2025 19:13:26 -0400
X-MC-Unique: 337KYjmiNTiUv2JF63frcg-1
X-Mimecast-MFC-AGG-ID: 337KYjmiNTiUv2JF63frcg_1743635605
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42CAB1801A07;
	Wed,  2 Apr 2025 23:13:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4BF91955BC2;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 532NDNKb3044085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 2 Apr 2025 19:13:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 532NDNTw3044084;
	Wed, 2 Apr 2025 19:13:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 2/4] libmultipath: add helper function check_path_wwid_change
Date: Wed,  2 Apr 2025 19:13:20 -0400
Message-ID: <20250402231322.3044064-3-bmarzins@redhat.com>
In-Reply-To: <20250402231322.3044064-1-bmarzins@redhat.com>
References: <20250402231322.3044064-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ELpryb6XKoZ13YsfJEy9kbjhrD3T_pwlsaCIZCQeP7g_1743635605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Wrap some code from select_recheck_wwid() in a helper function. A future
patch will call this code from a different function.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 12 +++++++++++-
 libmultipath/discovery.h |  2 +-
 libmultipath/propsel.c   |  4 +---
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 846101d0..c4bc6df6 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2245,7 +2245,7 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 	return len;
 }
 
-bool has_uid_fallback(struct path *pp)
+static bool has_uid_fallback(const struct path *pp)
 {
 	/*
 	 * Falling back to direct WWID determination is dangerous
@@ -2266,6 +2266,16 @@ bool has_uid_fallback(struct path *pp)
 		  !strcmp(pp->uid_attribute, ""))));
 }
 
+bool can_recheck_wwid(const struct path *pp)
+{
+	/*
+	 * check_path_wwid_change() only works for scsi devices, and it
+	 * is only guaranteed to give the same WWID if the path uses
+	 * the default uid_attribute
+	 */
+	return (pp->bus == SYSFS_BUS_SCSI && has_uid_fallback(pp));
+}
+
 int
 get_uid (struct path * pp, int path_state, struct udev_device *udev,
 	 int allow_fallback)
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 2b39eb04..2ef1d94b 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -55,7 +55,7 @@ ssize_t sysfs_get_inquiry(struct udev_device *udev,
 			  unsigned char *buff, size_t len);
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
-bool has_uid_fallback(struct path *pp);
+bool can_recheck_wwid(const struct path *pp);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev,
 	    int allow_fallback);
 bool is_vpd_page_supported(int fd, int pg);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 664e62fc..367a9839 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -739,9 +739,7 @@ int select_recheck_wwid(struct config *conf, struct path * pp)
 	pp_set_conf(recheck_wwid);
 	pp_set_default(recheck_wwid, DEFAULT_RECHECK_WWID);
 out:
-	if (pp->recheck_wwid == RECHECK_WWID_ON &&
-	    (pp->bus != SYSFS_BUS_SCSI ||
-	     !has_uid_fallback(pp))) {
+	if (pp->recheck_wwid == RECHECK_WWID_ON && !can_recheck_wwid(pp)) {
 		pp->recheck_wwid = RECHECK_WWID_OFF;
 		origin = "(setting: unsupported by device type/config)";
 	}
-- 
2.48.1

