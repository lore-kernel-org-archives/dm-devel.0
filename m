Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D22044375
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088108; cv=none; b=OnLK4ohRoI+pZeDvu8ww8R4jSAvjMwPEwjTJ+mszR7AF3SPM1keg+reQIbi6T0bIEtb2HZVfXwRevS70L/NVUvcoWsWdgGsi1rbi5quwIefaK6cGftffSfHqBIgMkjroBC5RE9Pm/UGNYqkhT2CFr8NhNnf2cbGkIqyGzbjQL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088108; c=relaxed/simple;
	bh=vXrltSBhcOl8RUM2XpdpAQ5qbnRaVDNhQE4mloGHMSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1FpzVLJauqNHBY7F9zrzhhTMHJ5nuNcncHNyF89xkSWNKMbsaFTRGU3dI5o7ln+lC6z0jELTQouAc7j1x8RCNX1uGR1KMgISe4fqR+EJ6pi+VC2YMfM5YdDpo8C0zDM8pPq7GdfJxUk7UP8G2rIg6I3M9m4Tvk04Eh6riuwla0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=doiZMOrb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="doiZMOrb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FyF3tCF9P6FravQ9QIhim5/Q5lbmC5LjVXK55dnTMec=;
	b=doiZMOrbALIPBNSomYvrIGTTq0pXLccjx6RmjxJoiPRVjdftqcBMjGFZvic7Qmbeddex9n
	WJ4kcBRvZZRy4pMFud+SQHSgGR+loZBET6lMYVQOgVg8s9XiUugXOGT9U7+xGUib3PE4JL
	ZpCNueX3N3V23yJJsA4abauC5TFPEhA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-VRlvktPEPdiaLMFbQe5TVQ-1; Thu,
 30 May 2024 12:55:02 -0400
X-MC-Unique: VRlvktPEPdiaLMFbQe5TVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45B8229AA381;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C17F3C27;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt2dM397033
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt2ol397032;
	Thu, 30 May 2024 12:55:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/7] multipath-tools man pages: don't assume multipath.socket is enabled
Date: Thu, 30 May 2024 12:54:55 -0400
Message-ID: <20240530165500.397009-3-bmarzins@redhat.com>
In-Reply-To: <20240530165500.397009-1-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Add "If enabled, " to the sentence about multipathd.socket, since it is
no longer enabled by default.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

