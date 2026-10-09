Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907663793BF
	for <dm-devel@lists.linux.dev>; Fri,  9 Oct 2026 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791562493; cv=none; b=O3Kwuc/NReF1EIxCzpF0Ea7G2b5APhcX4vfqW/2OHw+Cp58uwPkXpNmUV7p3dIK7hfeC/D861t31Y4dF5e+T9frl7cQDRj5U+uWD/1RBSvBFYFWIiSftO1B432Sz+wDUeTN3tw8PKmSuFq5KL7mb8YbSbKcJ7Q4dvQ4+ieFVGAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791562493; c=relaxed/simple;
	bh=HqK9TldjgigVv+Jefv+mZe+P09FDrdL+6t6Ra2llSr0=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Apt3jOoyc/6EMaPhGRPrdtu5k9Jea8+hTf9UTziPZ5soqdEL40iUb5DgMnDq+2KOXlWJFsyCshVEOdE1FCbdvH2mf05xSh+qKpTowyJeNYPXWkJDQIdMXHbH7tejvVLcMWwKFLNhZiP2hzzsjvmnG+hVAi/n80mfd5k8nsBYWsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DGDMzeqU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGDMzeqU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791562491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5pOE/OF4hwa3WETWL1De480QTshfc2ldBi83g2GJQqY=;
	b=DGDMzeqUDID/hEEKgLXH0flEjrt8wClOg+9kzPjjo9GM/Cq5BnNvj3YvS3ONeJHV+3144e
	7ZAz+AbGKTNy1SUQ1DKWGmGbEiNbGeRyu4ID4rUWYunL9iPGGdDErA1H0OgtZ2dk/7N37y
	ePeTmzWRsuac1XiiiS006nVTmYzOtRw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-aAm7tQ95MOKster2WesogA-1; Fri,
 9 Oct 2026 16:14:50 +0000
X-MC-Unique: aAm7tQ95MOKster2WesogA-1
X-Mimecast-MFC-AGG-ID: aAm7tQ95MOKster2WesogA_1791562489
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 130F51800655;
	Fri,  9 Oct 2026 16:14:49 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2D951800591;
	Fri,  9 Oct 2026 16:14:47 +0000 (UTC)
Date: Fri, 9 Oct 2026 18:14:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-snapshot: fix crash if dm_io_client_create fails
Message-ID: <c2218e29-4fe7-dbb3-210e-08ab33a691de@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: moGj6vadgn0z5RNBR3HnnevUqiOIV4ArpgBb-XNY83I_1791562489
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org

---
 drivers/md/dm-snap-persistent.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -325,8 +325,11 @@ static int read_header(struct pstore *ps
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)

