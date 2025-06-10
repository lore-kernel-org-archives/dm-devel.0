Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85224EF88
	for <dm-devel@lists.linux.dev>; Tue, 10 Jun 2025 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749581621; cv=none; b=Gx9nODA3PmhyJI4uSjZ5/RDtkmyKTXXEiVPAh4EHRtYiSpZKawTV4dDhebz5QIYj7wT2hXaBURrCuy2pvsX8QIVSxIQbwoNoO16CaKl7yNL8TVNscqIstKfXyrQSEaBtZcUbNIy8a2tGHFAVtu5ycXQABZrC0MrZ32AcRVaf+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749581621; c=relaxed/simple;
	bh=g5dwzh/yHOAAT01yn2aZbq5mPG+Tam022tjZ264mhco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=qFD/EFTijtU37W51M/E5dHcuSlXZ3uKEUPRjyyXL/Jwnp5nplcFE9Udjp2TikY9AEX3wmGBFMGQJuEVauYGYkMp5exZt7spl5cTDrwj889AgnJ1/cVUCyt55hgj/yK4aBCzq6DRLOIY/WyfR+r4Dh32yWsMdVMR/5RKQmW3/ptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFBmFnOf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFBmFnOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749581615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qX7zaHBl+hdWbpdsHWVXEs4Y1sgqwf9s2dEyJBJG+iw=;
	b=KFBmFnOfw8d2EBF/dvPix638KGnjQC6/GF5LE7+5Rgxl9UYuhXngMTtGQZ9NnkSUyRMlPf
	/O43p3hixsRwrs6rsbIdl4zlaclg+pyQPZt6BVmncOQnuKlMvTSxja82XDsmQk9G+g0lsc
	yGEGKxNe/8AOu9zV7N+tdzmdIU/CnhA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-p6j1gt4-OkyQf0crBD4CbQ-1; Tue,
 10 Jun 2025 14:53:34 -0400
X-MC-Unique: p6j1gt4-OkyQf0crBD4CbQ-1
X-Mimecast-MFC-AGG-ID: p6j1gt4-OkyQf0crBD4CbQ_1749581613
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40E3C180136B
	for <dm-devel@lists.linux.dev>; Tue, 10 Jun 2025 18:53:33 +0000 (UTC)
Received: from o.redhat.com (unknown [10.45.226.56])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CE2319560A3;
	Tue, 10 Jun 2025 18:53:31 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
Subject: [PATCH] dm raid: fix variable in journal device check
Date: Tue, 10 Jun 2025 20:53:30 +0200
Message-ID: <62c4102aae63d2c7bbd5e140353194b7e6b8678c.1749581474.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: e0DcxFOj8-7REga7rTKKdeiW3Q440NxBIgthyUoBzDY_1749581613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Heinz Mauelshagen <heinzm@redhat.com>

Replace "rdev" wih correct loop variable name "r".

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5ae3f059e072..99e15a005bfb 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2407,7 +2407,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 	 */
 	sb_retrieve_failed_devices(sb, failed_devices);
 	rdev_for_each(r, mddev) {
-		if (test_bit(Journal, &rdev->flags) ||
+		if (test_bit(Journal, &r->flags) ||
 		    !r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);
-- 
2.49.0

