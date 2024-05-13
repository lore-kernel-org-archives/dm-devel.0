Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A603221342
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621821; cv=none; b=Sk0k+POYRtgoKJ9S8bLSBCX7Lt6YZ0NCpL5pBeMJx194MIZ4zoodQxcWehDdEpBufEZLTTUdwj1bX9hl7lf7E8uPWVO+Ofl0etXN9vjaJOyQgRoIx29G2Qud34puo0G/Y4qrt0CHTLAfL8SI2Z7pMJcZSHn0d4/4JNJOQS0ttW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621821; c=relaxed/simple;
	bh=DCJiW4F6GKIPbtxZoJOL5c8rrMimdkWiLgsC/9Ff3yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lE8yFW3W0exTJxA4IlKoth5a1LLx8fsDsj5aigvT0xZ15L0wjCOiDofYTYGbWTiVaZ/NlJWxikU5WjOdel6Mb6/ENdP0VK7GnIrHCGk1lMFhV1cSWIZuLF8KTKAcFsY11IQjzvU0I9tgDEHhbvXBthtQaNnFlxWc4kPzneYzjwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UIL/gZSD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UIL/gZSD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715621815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7O+2vIpuwi4H1sej82WHrazmT5ZqH2acdh7MazwzW1o=;
	b=UIL/gZSDu3oeoFQzuHJceDt2khONojacLhFS6BclIF+lFrEflLSGJ412zlY3XM+xlpXY7a
	6yoCMibWbEBWjeQnwzlY9zrBg4Lvhaq85LVXGa7XVL+dAZY0x3T5bjBTWMTiwuM3ff62YN
	gaiKoS10zmtGgJtWKZolr36t5xTvaRs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-mboMOfjHPQSryCgmf-io6A-1; Mon, 13 May 2024 13:36:48 -0400
X-MC-Unique: mboMOfjHPQSryCgmf-io6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 747C4800656;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D0202028B55;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHalvb094448
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHalhG094447;
	Mon, 13 May 2024 13:36:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 2/7] multipath-tools man pages: don't assume multipath.socket is enabled
Date: Mon, 13 May 2024 13:36:41 -0400
Message-ID: <20240513173646.94424-3-bmarzins@redhat.com>
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Add "If enabled, " to the sentence about multipathd.socket, since it is
no longer enabled by default.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.8.in | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 12b77156..06d91c06 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -339,12 +339,13 @@ Stop multipathd.
 .\" ----------------------------------------------------------------------------
 .
 When compiled with systemd support two systemd service files are installed,
-\fImultipathd.service\fR and \fImultipathd.socket\fR The \fImultipathd.socket\fR
-service instructs systemd to intercept the CLI command socket, so that any call
-to the CLI interface will start-up the daemon if required.
-The \fImultipathd.service\fR file carries the definitions for controlling the
-multipath daemon. The daemon itself uses the \fBsd_notify\fR(3) interface to
-communicate with systemd. The following unit keywords are recognized:
+\fImultipathd.service\fR and \fImultipathd.socket\fR. If enabled, the
+\fImultipathd.socket\fR service instructs systemd to intercept the CLI command
+socket, so that any call to the CLI interface will start-up the daemon if
+required. The \fImultipathd.service\fR file carries the definitions for
+controlling the multipath daemon. The daemon itself uses the \fBsd_notify\fR(3)
+interface to communicate with systemd. The following unit keywords are
+recognized:
 .
 .TP
 .B WatchdogSec=
-- 
2.45.0

