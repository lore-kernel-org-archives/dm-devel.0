Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C8A1C84D0
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748969937; cv=none; b=UDva9EGZlOFMq9lUN9YsRDxiai64BedbB0IwZM30IMsPsbCQWE6Za+WYF9XikmkxjGrMaJbvRRejc6Fa6s3NPWHuo/e+J4KIuuaf1H/LOEsiwC1s6ZcsWEJtSYmU5sDb5UHG13xtwTHehsVo6AkiBtvFxF3Io6wYVDVerwTXrgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748969937; c=relaxed/simple;
	bh=ABHkDCsA2HXymAFdpgP38WlyUMOKyDcekbuVyACaO+U=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=XflrWU21PfuQeEJJMUPPP5cEjCFsC+xwn/NDfK5H4/JZqgmdpyYSGp1tRbTDEDeqQyMZD9UA1W3Ksg1xMsbU+omCtOupRRjm/DbCjokOPc+fPXq4yZDnZQVfFhOSL6gZE7IKw1PSfEwX5GXM0pbYLM3+b5q8D099P1tKxWHx5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E4KzAmHz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4KzAmHz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748969935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=gIRVoj6NoqDC0o2BrjN/UexwA4OAkFESKrE8KC/ACx0=;
	b=E4KzAmHzM9cs8/e4+04RyJD2MyV3GiK2fL940SCnU75RRECCTlPZXzMcVwN34BQSYTa/UP
	dJCfpAwH6H0FUQy+mgzuCFT13bAE83SHqGS8oHp2JDcXzFFHNcmYteQPdcEJ86dQ1PS7xC
	ImK5NCW0tytE6i//x0FErHBLyC88ldw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-EVh0azkdOzGoS8DkwXHT8g-1; Tue,
 03 Jun 2025 12:58:54 -0400
X-MC-Unique: EVh0azkdOzGoS8DkwXHT8g-1
X-Mimecast-MFC-AGG-ID: EVh0azkdOzGoS8DkwXHT8g_1748969933
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFB34180036D;
	Tue,  3 Jun 2025 16:58:52 +0000 (UTC)
Received: from [10.22.80.20] (unknown [10.22.80.20])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC67130002C2;
	Tue,  3 Jun 2025 16:58:51 +0000 (UTC)
Date: Tue, 3 Jun 2025 18:58:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH] dm-stripe: small code cleanup
Message-ID: <15eb071d-4178-d944-c531-20f02deffc6e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OzB0gINWavlltRvXEEjZ7bseiRBiQs8o-3F0GyDvSxA_1748969933
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

This commit doesn't fix any bug, it is just code cleanup. Use the
function format_dev_t instead of sprintf, because format_dev_t does the
same thing.

Remove the useless memset call.

An unsigned integer can take at most 10 digits, so extend the array size 
to 22. (note that because the range of minor and major numbers is limited, 
the size 16 could not be exceeded, thus this function couldn't write 
beyond string end)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2025-06-02 16:14:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-stripe.c	2025-06-02 16:26:46.000000000 +0200
@@ -405,7 +405,7 @@ static int stripe_end_io(struct dm_targe
 		blk_status_t *error)
 {
 	unsigned int i;
-	char major_minor[16];
+	char major_minor[22];
 	struct stripe_c *sc = ti->private;
 
 	if (!*error)
@@ -417,8 +417,7 @@ static int stripe_end_io(struct dm_targe
 	if (*error == BLK_STS_NOTSUPP)
 		return DM_ENDIO_DONE;
 
-	memset(major_minor, 0, sizeof(major_minor));
-	sprintf(major_minor, "%d:%d", MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)));
+	format_dev_t(major_minor, bio_dev(bio));
 
 	/*
 	 * Test to see which stripe drive triggered the event

