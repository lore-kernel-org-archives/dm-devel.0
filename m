Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AC7125A0
	for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 11:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763636937; cv=none; b=YPDdG/0RgwdhqA1/9WZf/Yvu+9xuFI+QVgS5WSy+Zia1z4TDL1LAuX8s4BG2kBZF4ewjWVAlSg0aXJu9HfsVdisUXINx4aq/xu1QMeMK/PEybKxnKTOtZpsV3htvm+Lb8VLSKBgUPD5jPcWUGekSX08EbcIOn0wJMRx9PH3DxT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763636937; c=relaxed/simple;
	bh=EE/Z+h2PRaNvCYqHac2mE5v+O2LTVq/0uWavuzXbJLI=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=bZ64uEikRCqCP22cTDDI9ctgPZCAkjdcRKTVu4PBWXUthxLDtjNO7ol8fLgQDvSGGeDK2T7kt60NOCw3IaoFRAK/GWa62xDJuhh+jbLvRlC/tWub4ZiNNlJeaf5phryA22tCkfQZ5KCTNgk2mSavL8G43vh92evFPxWRINcuMFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/gpC9hR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/gpC9hR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763636934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GiV1Cdqddk6lNPD2+ilLJID0GSqzk+R/hcnpTERtIJs=;
	b=M/gpC9hRVF7KkAbBwUBPM+JIJPD+BvjPoDitqc4wD+tZmJjgaTUN28jyo7IVM9wQsF8R3+
	NQc8v5YU1TV9sfe8uC04ZlGEKU3ebeUM0lsNzmdbWsFq7jYLFmyj9JNJmhcQRBlEsAZarR
	HVlmnCeYVYgU6GBKc9FVkJ2PRFSFZeA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-248-ZjMzgm_7PsGmYsw4RZpbbQ-1; Thu,
 20 Nov 2025 06:08:53 -0500
X-MC-Unique: ZjMzgm_7PsGmYsw4RZpbbQ-1
X-Mimecast-MFC-AGG-ID: ZjMzgm_7PsGmYsw4RZpbbQ_1763636932
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 273A41956080;
	Thu, 20 Nov 2025 11:08:52 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28A391800451;
	Thu, 20 Nov 2025 11:08:49 +0000 (UTC)
Date: Thu, 20 Nov 2025 12:08:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: fix failure when empty flush's bi_sector points beyond
 the device end
Message-ID: <f99a8124-4b72-e049-3265-908fc48b7148@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qzt_AjZly5S6SWfB4_wdI9WURTSOdCXggwood7oPk9I_1763636932
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

An empty flush bio can have arbitrary bi_sector. The commit 2b1c6d7a890a
introduced a regression that device mapper would fail an empty flush bio
with -EIO if the sector pointed beyond the end of the device.

The commit introduced an optimization, that optimization would pass
flushes to __split_and_process_bio and __split_and_process_bio is not
prepared to handle empty bios. Fix this bug by passing only non-empty
flushes to __split_and_process_bio - non-empty flushes must have valid
bi_sector. Empty bios will go through __send_empty_flush, as they did
before the optimization.

This problem can be reproduced by running the lvm2 test:
make check_local T=lvconvert-thin.sh LVM_TEST_PREFER_BRD=0

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 2b1c6d7a890a ("dm: optimize REQ_PREFLUSH with data when using the linear target")
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2025-11-19 15:08:07.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2025-11-19 15:08:35.000000000 +0100
@@ -2005,7 +2005,7 @@ static void dm_split_and_process_bio(str
 		 * linear target or multiple linear targets pointing to the same
 		 * device), we can send the flush with data directly to it.
 		 */
-		if (map->flush_bypasses_map) {
+		if (bio->bi_iter.bi_size && map->flush_bypasses_map) {
 			struct list_head *devices = dm_table_get_devices(map);
 			if (devices->next == devices->prev)
 				goto send_preflush_with_data;

