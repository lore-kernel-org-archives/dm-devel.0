Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D25339856
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623706; cv=none; b=H+qO448JttLf1SnxfOHHQ7t8tUa6EMmwv3OSI3NXA93CGFxCTUKLWj0Cs/Cxld+HV7lmMp+4eA8CO/QXr9UFGXBs3j1PAqHAS52oQ6eVnM9Ne1J33/NaGd+hBDcR0I9Rx+WPw+xp3Jo5+cTq1KeOHzK2sxDzAzYrdNsVWhU0LMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623706; c=relaxed/simple;
	bh=XhCAJNQ5gDT1xXLEILS2khQISeApWUKaBnbkvh0J2JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=L9Iu2zEVYPMN0/Nhr8lhgESNlNntOsp6BVbuS8ghRTH1+/dm4I1oDVovgZ/DcA/mjoGo3T6+j3VZ6LJ1CL37Gknz8phDt2C/fs2qm50KHXXko5KZDk3z1u2Ya7+0JHz9ppGWIno1RKLJgmDd0qcujaencGF2PSM+W0kJ32BzCD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USqYxLYI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USqYxLYI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYWBLWpdXKMXkIEtZ//NlT8ggGp8kjaXStBS24+DKSk=;
	b=USqYxLYIIrBx+PwlitPTn0uSEp2HlkQWo8v23WU51623TiG14MmPEz22rvgoQ3EnEOHj2V
	UZABcBs/iwe4m7Ij16u7neUe8RF1Vo9aOdQfT6GLNi+kwfYJE2dmHR/fchjbBEljDdd93M
	DUbhF1RtdVGDIMzHLgtgU0hccPtXsGE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-0VVfELQaMQOQEbT3YtUOaw-1; Mon,
 09 Feb 2026 02:55:01 -0500
X-MC-Unique: 0VVfELQaMQOQEbT3YtUOaw-1
X-Mimecast-MFC-AGG-ID: 0VVfELQaMQOQEbT3YtUOaw_1770623700
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4D771955F20;
	Mon,  9 Feb 2026 07:55:00 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE8C130001A8;
	Mon,  9 Feb 2026 07:54:57 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 1/7] dm cache: fix null-deref with concurrent writes in passthrough mode
Date: Mon,  9 Feb 2026 15:54:05 +0800
Message-ID: <20260209075411.860418-2-mtsai@redhat.com>
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
X-Mimecast-MFC-PROC-ID: K57eNgsfoiFOjFJw6peV1c3h6Vg396hYc0o7CBk60gA_1770623700
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In passthrough mode, when dm-cache starts to invalidate a cache
entry and bio prison cell lock fails due to concurrent write to
the same cached block, mg->cell remains NULL. The error path in
invalidate_complete() attempts to unlock and free the cell
unconditionally, causing a NULL pointer dereference:

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 134 Comm: fio Not tainted 6.19.0-rc7 #3 PREEMPT
RIP: 0010:dm_cell_unlock_v2+0x3f/0x210
<snip>
Call Trace:
 invalidate_complete+0xef/0x430
 map_bio+0x130f/0x1a10
 cache_map+0x320/0x6b0
 __map_bio+0x458/0x510
 dm_submit_bio+0x40e/0x16d0
 __submit_bio+0x419/0x870
<snip>

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

4. Write to the first cached block concurrently

fio --filename=/dev/mapper/cache --name test --rw=randwrite --bs=4k \
--randrepeat=0 --direct=1 --numjobs=2 --size 64k

Fix by checking if mg->cell is valid before attempting to unlock it.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a10d75a562db..a2e07b124901 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1462,8 +1462,10 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 	struct cache *cache = mg->cache;
 
 	bio_list_init(&bios);
-	if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
-		free_prison_cell(cache, mg->cell);
+	if (mg->cell) {
+		if (dm_cell_unlock_v2(cache->prison, mg->cell, &bios))
+			free_prison_cell(cache, mg->cell);
+	}
 
 	if (!success && mg->overwrite_bio)
 		bio_io_error(mg->overwrite_bio);
-- 
2.49.0

