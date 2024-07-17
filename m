Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107401836D3
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239879; cv=none; b=nvN6b2wuohfwLNSvNxScLhOVFit9jz3SrX15TIA9WAT5dGPe0nqgv6+1k6eGanF68a1NEgAYJIO9bomy8rzkwinQgrDo7Mx5BHOXh0e72I3XiXQ9/jlhYS43QBcEaLLr0GxJJ8Luz/Gu4O6b4PtQy6TaFKmcwpNcL60LEpCVmpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239879; c=relaxed/simple;
	bh=9pWiKf+oKnYt7Vbi/hzsSxbhwGj2uAhn7N6LS+b9oRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=om2GACRDSdxAro/FLXvzPuc0aMws3JUnOmkERXayudUDVjVJFN8ZGC6CFVMQ+SF7WQQIWEOJ6CJZcAhKwIrELmCYJu3ETnI8xeBOiYKrirA69xtp/IwF08O15G/qBcKrRbTHWcYGUM+ipID1L09Scg00N64kPb51DK8YYdbm7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYM5YgkJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYM5YgkJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vFIM3kG2QKpnkC774EI1TH9fR40t7aTcjFSWgkImPo=;
	b=UYM5YgkJr/tC9uc2YcdebkhXhsfGAZJlqauCq6kP/z/eYX54x3ERA/cgloqKTpEkYy09+k
	+n8vfGjhR19DuTUHGL7nZqIesMpqgEAY0w9CAyS8QAhyl+8kAEY9AoGvpOR92ZdnbgP5E6
	hxcci/f5uxAR64O9/l4zqVf5ltf71qE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-JLbCJAXZMQqcvX28O9hfQw-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: JLbCJAXZMQqcvX28O9hfQw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89104195608B;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD705195605A;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB90q2173616
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB9fu2173615;
	Wed, 17 Jul 2024 14:11:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 15/20] multipathd: handle changed wwid when adding partial path
Date: Wed, 17 Jul 2024 14:11:01 -0400
Message-ID: <20240717181106.2173527-16-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If multipathd noticed that the WWID didn't match the device when adding
a partial path, but removing it failed, multipathd wasn't disabling the
path. Instead of calling handle_path_wwid_change(), which doesn't make
much sense when multipathd is expecting a uevent, just manually disable
the path if ev_remove_path() fails.

Since the path hasn't actually been removed, multipathd needs to make
sure that it says failed when the path state is resynced with the
kernel. Set the state to PATH_UNCHECKED in orphan_path(), and
additionally skip all path in INIT_REMOVED in sync_map_state().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c     | 1 +
 libmultipath/structs_vec.c | 3 ++-
 multipathd/cli_handlers.c  | 6 +++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 1583e001..0a26096a 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -146,6 +146,7 @@ uninitialize_path(struct path *pp)
 		return;
 
 	pp->dmstate = PSTATE_UNDEF;
+	pp->state = PATH_UNCHECKED;
 	pp->uid_attribute = NULL;
 	pp->checker_timeout = 0;
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 60360c76..345d3069 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -723,7 +723,8 @@ sync_map_state(struct multipath *mpp)
 
 	vector_foreach_slot (mpp->pg, pgp, i){
 		vector_foreach_slot (pgp->paths, pp, j){
-			if (pp->state == PATH_UNCHECKED ||
+			if (pp->initialized == INIT_REMOVED ||
+			    pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD ||
 			    pp->state == PATH_DELAYED)
 				continue;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 772a45d0..3a935aa0 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -540,7 +540,11 @@ add_partial_path(struct path *pp, struct vectors *vecs)
 	if (strlen(wwid) && strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
 		condlog(0, "%s: path wwid changed from '%s' to '%s'. removing",
 			pp->dev, wwid, pp->wwid);
-		ev_remove_path(pp, vecs, 1);
+		if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) &&
+		    pp->mpp) {
+			pp->dmstate = PSTATE_FAILED;
+			dm_fail_path(pp->mpp->alias, pp->dev_t);
+		}
 		udev_device_unref(udd);
 		return -1;
 	}
-- 
2.45.0

