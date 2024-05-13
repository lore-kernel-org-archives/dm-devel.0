Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485222331
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621812; cv=none; b=mCseyqC93vt4FmICEaETj1k2CZ/fzBCtPyoHpYiPnfGWijZD13eu7pjCDAxokkfguWYYgvG7yYulAF0QKHxSjaMyCb3KOGJ5FH8XewxJ9q1kmFwfdI3p8bQN2nlogl+tSunvqYe4FWtl05SJfIPEmsCNRCVcGObz0ep1VrZGiW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621812; c=relaxed/simple;
	bh=+fAKt390NpNcNL3sC77l3Oog2Isd365zFFrUV6KoDtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2P/fEN2y8aQFgOS6Mizus+FV7Bwa6MOrDt+c8SE7Ks8fKMEgJaLyGulCCe2ewInl5MIfcixxvN7VsLR8OeIwJBcJ3ylvuqvij4GfN23qpMJO48BSFzr28d29e3b5fj8JXDOEssA+nwv95AdOtx8C1WidZJVsQ6YkWDoA5+peCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DRYW996g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DRYW996g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715621809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FW8fgl7XMjEtORMNPFuPWgH9zqfwCf3tlHumymA2NeY=;
	b=DRYW996gtioSptIEMkzvckgt4+X2+8lRWd7zMEelxBo5bjdy0dipDPQgEC1fiPQmz98XLo
	yVEldYliJuW6JOkO3fQFpW+LDxB9tfb+xI9H9kZgRamXJv0dNldo7lG9At73DwknjRQyvX
	WHv377WMnp9If817rM8vlIjupQB0eP4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-V69wS147MpyH5gSMxYdcRw-1; Mon,
 13 May 2024 13:36:47 -0400
X-MC-Unique: V69wS147MpyH5gSMxYdcRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B95529ABA00;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95AA7561A;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHaldi094452
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHalsg094451;
	Mon, 13 May 2024 13:36:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 3/7] libmultipath: print all values in snprint_failback
Date: Mon, 13 May 2024 13:36:42 -0400
Message-ID: <20240513173646.94424-4-bmarzins@redhat.com>
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
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

Add the missing output for manual failback and print the defferral time
for deferred failbacks, if one isn't currently in progress.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 89813517..14e7e325 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -218,9 +218,13 @@ snprint_failback (struct strbuf *buff, const struct multipath * mpp)
 		return append_strbuf_str(buff, "immediate");
 	if (mpp->pgfailback == -FAILBACK_FOLLOWOVER)
 		return append_strbuf_str(buff, "followover");
+	if (mpp->pgfailback == -FAILBACK_MANUAL)
+		return append_strbuf_str(buff, "manual");
+	if (mpp->pgfailback == FAILBACK_UNDEF)
+		return append_strbuf_str(buff, "undef");
 
 	if (!mpp->failback_tick)
-		return append_strbuf_str(buff, "-");
+		return print_strbuf(buff, "%i", mpp->pgfailback);
 	else
 		return snprint_progress(buff, mpp->failback_tick,
 					mpp->pgfailback);
-- 
2.45.0

