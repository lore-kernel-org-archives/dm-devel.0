Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B619D1714A8
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962924; cv=none; b=kJAs6Osc12+rHmP1cAz/g+B5qwGE0jA9WQKiyN5BMCtWMuWnyrvbbXHDT/cHIzOz5NqdERb76WFxvHhgYdqpAoOXZjLfc7JpRVc+xAVk9kzC3VRpUOaq087ZmJLFSEoZWavBMgi5jOottwJTQtk1Jdj8hYeD9IIFccV824oMNHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962924; c=relaxed/simple;
	bh=QwWLCaoqkEO7MdxjSSX1AlBvBOqamwc2C9mCQH8UZjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzWs+R1ZBNoFrcdkzr08maQjGfFrb6m7TcC3PgWyFD0LoLcXc1UrTXIv/kNLkDZW+pxv+DNM117wXidDs2WjeW0wDT4tDZrqAuTyk7m7wHzQhgWFsrSWX/dzEmIkFvRFkrwK6VdfQoveYS0fIMEwkJtnuQdYPd7Wvv4vFNTiQzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBTKhyj/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBTKhyj/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uMHUFgDHX/rlgtd8bQh97l/dzcQRe0tvCTscS6K1NIQ=;
	b=SBTKhyj/8qvaAw0HGDHMB/zGaXLJVsQUsD6RNKYOzXs5viVRbyeVakrg5Wqp96Rn2svuk2
	ULtvI5Fg5ZYb5YHU9H2WlJRQHcL0OfoPZbB4zIQmIGzSuRzKCUt/RqqCHAuKEiUH+kcYae
	0ep7GyOXW3ENLkqh36ZbnDsRJTYwN0E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-s_ZhUqiYP1KHJCvCNlKyPw-1; Mon,
 14 Oct 2024 23:28:40 -0400
X-MC-Unique: s_ZhUqiYP1KHJCvCNlKyPw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41F919560B5;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B53181956056;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SbsS2693331
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SbE32693330;
	Mon, 14 Oct 2024 23:28:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 13/23] multipathd: fix "fail path" and "reinstate path" commands
Date: Mon, 14 Oct 2024 23:28:25 -0400
Message-ID: <20241015032835.2693247-14-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
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

Now that multipathd can drop the vecs lock and sleep in-between when the
checker runs and when the path gets updated, it is possible for the
user to either fail or reinstate the path in this window.

If a path gets manually failed in the window between when the checker
starts and the path is updated, the checker will have already been
started, on the path, and if multipathd read the results like normal,
it could simply reinstate the path. To avoid this, when a path checker
is disabled, the checker path_state and message are updated, just
like they are when checker_check() is run on a disabled path, so that
when checker_get_state() is called, it will always return the same
results for a disabled checker, regardless of when it was disabled.

Reinstating the path doesn't cause many problems, but still can be
improved. Since the checker was disabled when it would have been
started, it didn't run during this cycle, only the kernel state will get
updated. The rest of the path update changes won't happen until the next
time the checker runs. This is the case regardless of whether or not the
path was reinstated in the window between when the checker starts and
the path is updated. To make reinstated paths get updated sooner,
pp->tick is now set to 1 when the path is reinstated.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c   | 2 ++
 multipathd/cli_handlers.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index ce3e48bd..f3e98352 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -251,6 +251,8 @@ void checker_disable (struct checker * c)
 	if (!c)
 		return;
 	c->disable = 1;
+	c->msgid = CHECKER_MSGID_DISABLED;
+	c->path_state = PATH_UNCHECKED;
 }
 
 int checker_init (struct checker * c, void ** mpctxt_addr)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 42603544..184c3f91 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1108,6 +1108,7 @@ cli_reinstate(void * v, struct strbuf *reply, void * data)
 		pp->mpp->alias, pp->dev_t);
 
 	checker_enable(&pp->checker);
+	pp->tick = 1;
 	return dm_reinstate_path(pp->mpp->alias, pp->dev_t);
 }
 
-- 
2.45.0

