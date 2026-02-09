Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE238339847
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623732; cv=none; b=VC+OQ1rA6Kq1wFsvagQc9Y2Eq6/dG6LoJNs1DegHNrGWwyqWbG1f1/fVZH1I84QeUEqFal0agGPuUIK7BgaI5EcScn+uto8sODUiY9wNQuey41/s07GCQjDAuMbNaZKoU0RoboPkqs7dGGt/52Sz2y1KxKDhid4NOuYQaqxM0gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623732; c=relaxed/simple;
	bh=+2WkRQTrgHQYRbYJEBDxajdZbzD+6iG62CaeutdXKOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hYIX6zAglSVbJhtQCrFAEa1sc/CbXpbhGr64sgCRy77fTKizh6DJOYS/xqf+SC7OnPgJU279Vvs6JVwSEPPqCqnvi+ZhLMsKgFwb+xZILr4bcq2Jg3xr4E8Ggpkhbi5dakdTvTlNUalFqNWOY7IfNqeb59X53GacePDHSkcp1DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V1CZwfdb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V1CZwfdb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZpPYehbfCCFJURIB2tLHFt2T7EBqZDGcFk7rsbo8MQ8=;
	b=V1CZwfdbvGzDNUAl1yG5Ervg7Jdaam4nO1wA1OTtvnrhUFf1aRwCw9+nR9Bu14EBJLrF4l
	3YSq6hsv76l3twdubgvFZoe4QiydC6EUZ9CbO2IRQnVN/QmZPPK7Pu8VArXIPYds9VoMzR
	4oy30P0sAlp8TgIUW0bVlfFwzPZzyvw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-pP6wJhb3P4iDSt6NWXmOOw-1; Mon,
 09 Feb 2026 02:55:29 -0500
X-MC-Unique: pP6wJhb3P4iDSt6NWXmOOw-1
X-Mimecast-MFC-AGG-ID: pP6wJhb3P4iDSt6NWXmOOw_1770623729
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBF9B180057E;
	Mon,  9 Feb 2026 07:55:28 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFFDF30002D8;
	Mon,  9 Feb 2026 07:55:25 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 5/7] dm cache: fix concurrent write failure in passthrough mode
Date: Mon,  9 Feb 2026 15:54:09 +0800
Message-ID: <20260209075411.860418-6-mtsai@redhat.com>
In-Reply-To: <20260209075411.860418-1-mtsai@redhat.com>
References: <20260209075411.860418-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eZK9T1ToL625uwTW2h-n9vtfEparbkmzb4MNuml3q2w_1770623729
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When bio prison cell lock acquisition fails due to concurrent writes to
the same block in passthrough mode, dm-cache incorrectly returns an I/O
error instead of properly handling the concurrency. This can occur in
both process and workqueue contexts when invalidate_lock() is called for
exclusive access to a data block. Fix this by deferring the write bios
to ensure proper block device behavior.

Reproduce steps:

1. Create a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Promote the first data block into cache

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the first cached block concurrently. Sometimes one of the
   processes will receive I/O errors.

fio --filename=/dev/mapper/cache --name test --rw=randwrite --bs=4k \
--randrepeat=0 --direct=1 --numjobs=2 --size 64k

 <snip>
 fio-3.41
 fio: io_u error on file /dev/mapper/cache: Input/output error: write offset=4096, buflen=4096
 fio: pid=106, err=5/file:io_u.c:2008, func=io_u error, error=Input/output error
 test: (groupid=0, jobs=1): err= 0: pid=105
 test: (groupid=0, jobs=1): err= 5 (file:io_u.c:2008, func=io_u error, error=Input/output error): pid=106
 <snip>

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 8b62fe69722d..eb9d738704d0 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1561,6 +1561,15 @@ static int invalidate_lock(struct dm_cache_migration *mg)
 			    READ_WRITE_LOCK_LEVEL, prealloc, &mg->cell);
 	if (r < 0) {
 		free_prison_cell(cache, prealloc);
+
+		/* Defer the bio for retrying the cell lock */
+		if (mg->overwrite_bio) {
+			struct bio *bio = mg->overwrite_bio;
+
+			mg->overwrite_bio = NULL;
+			defer_bio(cache, bio);
+		}
+
 		invalidate_complete(mg, false);
 		return r;
 	}
-- 
2.49.0

