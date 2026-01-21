Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763C1238C1A
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 21:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029406; cv=none; b=rFzzMmVMFF0e9Tdf+H3ZuR5BKSB/Rc0YPqNfzoelzkhfU4Vh71OTnH57Ah05xIA+1uOHXReq3TkrlSejMF6I6RAKxHT7QJ6kP46JF6iPGv0pQIzwRBM2ZUWATgw/CTed9ud8c2b+/arcpNC2FQCVzv+JixOOzWaKlWGG9AV5eYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029406; c=relaxed/simple;
	bh=Li56FM5bAMxUdduGH87Yaqca8Oruv9mAOjKIPDEXGVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=aAqBGRDqCAk1W7tuDmtVXNnv+N2eQEGT8xih0TaOG4SEN7fSDh4qWIK1UgncxfwkH7xvaGVcXCB3e6g5s78zf4x8ImQG4McKlF/TvIqrKr+11MAbYtzcutQN0ep3PSjU/rFQTdLbxI0VxNjW+5rhyAzdlNxeIUS80mNMaN5Cg8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=De+b1+QX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="De+b1+QX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769029401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c1S6Ks/hMf658ZFwPFBp1jjy4ZT1RrBy83T3QBlrVEk=;
	b=De+b1+QXGaV/XudAfKZJ0K8heNKziMSdLVXMAShigDIdyfLUwgAo6lljTZ922bUTtR557B
	+hW2TWED9B8XlaWOhaq6kXa6q77poTcm4EK0MTihUOs0WyZmrEUMU+SbdhGz9DFTm121+B
	rV8mNiIHdNrbsHvQz3JcdZBS8vJB7YA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-VnVlxN9EOv2REb6CsTXvxA-1; Wed,
 21 Jan 2026 16:03:17 -0500
X-MC-Unique: VnVlxN9EOv2REb6CsTXvxA-1
X-Mimecast-MFC-AGG-ID: VnVlxN9EOv2REb6CsTXvxA_1769029395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C7621800342;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 173D918004D8;
	Wed, 21 Jan 2026 21:03:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LL3Dwp3942748
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 16:03:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LL3DdC3942747;
	Wed, 21 Jan 2026 16:03:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 2/4] multipathd: finish initalization of paths added while offline
Date: Wed, 21 Jan 2026 16:03:11 -0500
Message-ID: <20260121210313.3942727-3-bmarzins@redhat.com>
In-Reply-To: <20260121210313.3942727-1-bmarzins@redhat.com>
References: <20260121210313.3942727-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xt35M070PdtgOxxLI3v8MSZIV68mf5AGWjtOmnP3Cds_1769029395
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a path in a mulitpath device is offline while multipathd is
reconfigured, it will get added to the updated multipath device, just
like it was in the old multipath device. However the device will still
be in the INIT_NEW state because it can't get initilized while offline.
This is different than the INIT_PARTIAL state because the path was
discovered in path_discovery(). INIT_PARTIAL is for paths that
multipathd did not discover in path_discovery() or receive a uevent for,
but are part of a multipath device that was added, and which should
receive a uevent shortly. There is no reason to expect a uevent for
these offline paths.

When the path comes back online, multipathd will run the checker and
prioritizer on it. The only two pathinfo checks that won't happen
are the DI_WWID and DI_IOCTL ones. Modify pathinfo() to make sure
that if DI_IOCTL was skipped for offline paths, it gets called the
next time pathinfo() is called after the fd can be opened. Also,
make sure that when one of these offline paths becomes usable, its
WWID is rechecked. With those changes, all the DI_ALL checks will
be accounted for, and the path can be marked INIT_OK.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |  2 ++
 multipathd/main.c        | 53 ++++++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0c5e5ca6..0efb8213 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2585,6 +2585,8 @@ blank:
 	 * Recoverable error, for example faulty or offline path
 	 */
 	pp->chkrstate = pp->state = PATH_DOWN;
+	if (mask & DI_IOCTL && pp->ioctl_info == IOCTL_INFO_NOT_REQUESTED)
+		pp->ioctl_info = IOCTL_INFO_SKIPPED;
 	if (pp->initialized == INIT_NEW || pp->initialized == INIT_FAILED)
 		memset(pp->wwid, 0, WWID_SIZE);
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 61e0ea34..90472d69 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2572,6 +2572,26 @@ static int sync_mpp(struct vectors *vecs, struct multipath *mpp, unsigned int ti
 	return do_sync_mpp(vecs, mpp);
 }
 
+/*
+ * pp->wwid should never be empty when this function is called, but if it
+ * is, this function can set it.
+ */
+static bool new_path_wwid_changed(struct path *pp, int state)
+{
+	char wwid[WWID_SIZE];
+
+	strlcpy(wwid, pp->wwid, WWID_SIZE);
+	if (get_uid(pp, state, pp->udev, 1) != 0) {
+		strlcpy(pp->wwid, wwid, WWID_SIZE);
+		return false;
+	}
+	if (strlen(wwid) && strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+		strlcpy(pp->wwid, wwid, WWID_SIZE);
+		return true;
+	}
+	return false;
+}
+
 static int
 update_path_state (struct vectors * vecs, struct path * pp)
 {
@@ -2601,14 +2621,33 @@ update_path_state (struct vectors * vecs, struct path * pp)
 		return CHECK_PATH_SKIPPED;
 	}
 
-	if (pp->recheck_wwid == RECHECK_WWID_ON &&
-	    (newstate == PATH_UP || newstate == PATH_GHOST) &&
+	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    ((pp->state != PATH_UP && pp->state != PATH_GHOST) ||
-	     pp->dmstate == PSTATE_FAILED) &&
-	    check_path_wwid_change(pp)) {
-		condlog(0, "%s: path wwid change detected. Removing", pp->dev);
-		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
-							  CHECK_PATH_SKIPPED;
+	     pp->dmstate == PSTATE_FAILED)) {
+		bool wwid_changed = false;
+
+		if (pp->initialized == INIT_NEW) {
+			/*
+			 * Path was added to map while offline, mark it as
+			 * initialized.
+			 * DI_SYSFS was checked when the path was added
+			 * DI_IOCTL was checked when the checker was selected
+			 * DI_CHECKER just got checked
+			 * DI_WWID is about to be checked
+			 * DI_PRIO will get checked at the end of this checker
+			 * loop
+			 */
+			pp->initialized = INIT_OK;
+			wwid_changed = new_path_wwid_changed(pp, newstate);
+		} else if (pp->recheck_wwid == RECHECK_WWID_ON)
+			wwid_changed = check_path_wwid_change(pp);
+		if (wwid_changed) {
+			condlog(0, "%s: path wwid change detected. Removing",
+				pp->dev);
+			return handle_path_wwid_change(pp, vecs)
+				       ? CHECK_PATH_REMOVED
+				       : CHECK_PATH_SKIPPED;
+		}
 	}
 	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
-- 
2.50.1

