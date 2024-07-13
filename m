Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F597210EE
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850718; cv=none; b=Nc3A2xfZy1ca7FzdY2NnuQJgn2cjFjNHOj5bQFbKQ4GtITRBYob7qLB/u9crfEfiUWNgZEMtZ99NbTXQyC0XTblFeMTchKeuC4fScZKoLi94sqfh8SOlJu+y/aVTESXBVk2nS2UJk0VTLLi0ThSruUsewj6dq5SON7fyLh3C0Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850718; c=relaxed/simple;
	bh=7qu/Bi0KGbrx6bqYMjTbrsniQnycbjNi0H/35mFfwPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvWbvPeDcw8ttjbfhqsNqtipGlSwEzqISDst4IqtdRcVFQwaZfn/DkaAtWraKDF+eS7he6KmfMjjWXwmW/COrsCg9glPVy6ACQkWs+TaPa9A2INMo+JvL++l4M2JVaPRwleDrDZqi9fl6skfhUB4XNOofaGOdvhWcN3XMRKm3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UsfMGDUW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UsfMGDUW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQ1Bx7uCpTeAyC/q0kBlyJOhxiqMyMu2wPlUh7IoZbY=;
	b=UsfMGDUWL+ujz9l4JfCuP0d08GHZ+VO/Iue7TTREmQSXDcc+dIcLXqZiVYXlgDkHW8pruw
	prR7LgcwYcVoVAcWmCAv8i1eTOPPacEYHklW/yfZervAbjFHYbV8yftsXQPAzkpjr/hqQ3
	5hYmePjehdG9gJvsS8eVS1rUegqN7Ig=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-g4S1flmYM2mXYYMBUzTsXQ-1; Sat,
 13 Jul 2024 02:05:12 -0400
X-MC-Unique: g4S1flmYM2mXYYMBUzTsXQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2ED4E19560A1;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90D761955F3B;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D659Fn2015538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D659vu2015537;
	Sat, 13 Jul 2024 02:05:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 11/22] multipathd: reorder path state checks
Date: Sat, 13 Jul 2024 02:04:55 -0400
Message-ID: <20240713060506.2015463-12-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
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

Reorder the path state checks in check_path(), so that it first does
all the checks which can result in returning with the path unchecked or
removed from the multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 43bd5936..fbd253ca 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2385,19 +2385,8 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	pp->tick = checkint;
 
 	newstate = check_path_state(pp);
-	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
+	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return 0;
-	} else if ((newstate != PATH_UP && newstate != PATH_GHOST &&
-		    newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
-		/* If path state become failed again cancel path delay state */
-		pp->state = newstate;
-		/*
-		 * path state bad again should change the check interval time
-		 * to the shortest delay
-		 */
-		pp->checkint = checkint;
-		return 1;
-	}
 	/*
 	 * Async IO in flight. Keep the previous path state
 	 * and reschedule as soon as possible
@@ -2436,6 +2425,17 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		return 0;
 	}
 
+	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
+	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
+		/* If path state become failed again cancel path delay state */
+		pp->state = newstate;
+		/*
+		 * path state bad again should change the check interval time
+		 * to the shortest delay
+		 */
+		pp->checkint = checkint;
+		return 1;
+	}
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    (san_path_check_enabled(pp->mpp) ||
 	     marginal_path_check_enabled(pp->mpp))) {
-- 
2.45.0

