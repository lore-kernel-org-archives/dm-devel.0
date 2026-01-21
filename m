Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2E636E49D
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 04:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768969411; cv=none; b=E6efWtyKGWfV+Y5RCimQ6DOFGJQj9SLPhIqr2e2TRyF12SGm2cNo8ISLkRvtcI5Lxx66Ng9DhgW5RRcWfVUYUtwrnK6Q0karjECRPMN4qqXekzAhpY2eCnabra228WdiHT/Ok/u6UQoVEatFByg99LT1geL6yXRDdmUQJkxijHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768969411; c=relaxed/simple;
	bh=PYWl80TG1pkQjgO0thm6QofRiMO94pPJ98NKKJfY+1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EybKN7HfCbj6zGAq0plIYSn6NPTnHr6i2sEQgJIskECqPv1e6Lq0L6cHp7B/mdKjVYGhKHDTMZ/JS9+hCgnC7JDJ4OrlHh2z3PdzTozwykf6INocLXFd3ZIPZPBQIlw3cDEj0MpvDUMtnjf78r8Ln4tU0oBzm97LD3boCQioW1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MiAtwa/2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MiAtwa/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768969400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bw0e28zYYYq2ex8A5csKYsItEN677idPBXk5Xq+cwIo=;
	b=MiAtwa/2Gd6XKutFXSC/CmA3QJu5W9F2Gh/M+keuyXvt3axr5QwhR3UcDZcSC2BRiFadaS
	ZHhkDnwj1YYZSXRhUMdbOvffrvMokUwC+rQPozmY9iCxmCl8mgMimF9c5hlH5rsjTPQyCQ
	fa7JgAmp5JGRFeR/IU37m3GVR56Qj7A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-ryszZEMuNH6vUrtdvJjCcA-1; Tue,
 20 Jan 2026 23:23:18 -0500
X-MC-Unique: ryszZEMuNH6vUrtdvJjCcA-1
X-Mimecast-MFC-AGG-ID: ryszZEMuNH6vUrtdvJjCcA_1768969397
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40A7A19560B2;
	Wed, 21 Jan 2026 04:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F109430001A2;
	Wed, 21 Jan 2026 04:23:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60L4NFbE3914728
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 23:23:15 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60L4NF9A3914727;
	Tue, 20 Jan 2026 23:23:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/4] multipathd: finish initalization of paths added while offline
Date: Tue, 20 Jan 2026 23:23:13 -0500
Message-ID: <20260121042315.3914707-3-bmarzins@redhat.com>
In-Reply-To: <20260121042315.3914707-1-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0STZyUhokWHNG5VwtoKFrqApZtUy8xfLa-q_xOlJYpk_1768969397
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
 multipathd/main.c        | 52 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 6 deletions(-)

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
index 61e0ea34..2140e432 100644
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
+	strcpy(wwid, pp->wwid);
+	if (get_uid(pp, state, pp->udev, 1) != 0) {
+		strcpy(pp->wwid, wwid);
+		return false;
+	}
+	if (strlen(wwid) && strcmp(wwid, pp->wwid) != 0) {
+		strcpy(pp->wwid, wwid);
+		return true;
+	}
+	return false;
+}
+
 static int
 update_path_state (struct vectors * vecs, struct path * pp)
 {
@@ -2601,14 +2621,34 @@ update_path_state (struct vectors * vecs, struct path * pp)
 		return CHECK_PATH_SKIPPED;
 	}
 
-	if (pp->recheck_wwid == RECHECK_WWID_ON &&
+	if ((pp->recheck_wwid == RECHECK_WWID_ON || pp->initialized == INIT_NEW) &&
 	    (newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    ((pp->state != PATH_UP && pp->state != PATH_GHOST) ||
-	     pp->dmstate == PSTATE_FAILED) &&
-	    check_path_wwid_change(pp)) {
-		condlog(0, "%s: path wwid change detected. Removing", pp->dev);
-		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
-							  CHECK_PATH_SKIPPED;
+	     pp->dmstate == PSTATE_FAILED)) {
+		bool wwid_changed;
+
+		if (pp->initialized == INIT_NEW)
+			wwid_changed = new_path_wwid_changed(pp, newstate);
+		else
+			wwid_changed = check_path_wwid_change(pp);
+		if (wwid_changed) {
+			condlog(0, "%s: path wwid change detected. Removing",
+				pp->dev);
+			return handle_path_wwid_change(pp, vecs)
+				       ? CHECK_PATH_REMOVED
+				       : CHECK_PATH_SKIPPED;
+		}
+		/*
+		 * Path was added to map while offline, mark it as
+		 * initialized.
+		 * DI_SYSFS was checked when the path was added
+		 * DI_IOCTL was checked when the checker was selected
+		 * DI_CHECKER just got checked
+		 * DI_WWID just got checked
+		 * DI_PRIO will get checked at the end of this checker loop
+		 */
+		if (pp->initialized == INIT_NEW)
+			pp->initialized = INIT_OK;
 	}
 	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
 	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
-- 
2.50.1

