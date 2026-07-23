Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9494536655D
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 20:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838226; cv=none; b=X3l8R5MaojqHSAcyx0Swrgm/4iPiezXczkHaFRjoJrWpU2gc7qfcUj9JBC5ZKm4l0PoOCeQyacFloivpxDXXb24lK3D6EyRMrEsrDsz+QxZvMmUktbga582MQ5zhcZoNDW/ucOM5lj8xKlpV0VdRPkQFRyx7u/0nZy2xkiMDsKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838226; c=relaxed/simple;
	bh=MRnqp89HL1tNoLZi07lqIEXm5Ht9KSnlFOZ5ZUX1LkE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OLg4tEoMUTDGcpU43YSDa9H/R2IwaphBZ7iBkegjl80MsF1x9Ga25t36Hsf+ooU56nfhR6nnnOx2tkCZZTSEX07oqSuYO8b3v1KJfsQIQug/VMV2lRn9ZYAjzacBZPqlSVI0P5Q0yHciJSvZbbGrlx0nQiFVTBd4H/XNW24cgeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TeCFTGnd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TeCFTGnd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784838223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6OViHldasiPfP2D1GAOMKGOG0pD468tLDeLYAtl8Q/k=;
	b=TeCFTGndVpJpvH1zG55n/b27dO+FG7pp9e/fqdH6gPo60eZjzOLo5T7uj6ra/uXGIc+qcY
	BUSP8LcjEb0suX3VS9q6MQ+zXgaQjYfiEMLFjcD6PRQ1HaLPRDpePxihXpb00BTsZNsYtB
	vpHt4k/rhBrr4kGnwcoTIMrTZHKFtLM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-GVOEpyRFOVKn-A5t8sB1qw-1; Thu,
 23 Jul 2026 16:23:41 -0400
X-MC-Unique: GVOEpyRFOVKn-A5t8sB1qw-1
X-Mimecast-MFC-AGG-ID: GVOEpyRFOVKn-A5t8sB1qw_1784838221
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AED12195398A;
	Thu, 23 Jul 2026 20:23:40 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDEFE15A2;
	Thu, 23 Jul 2026 20:23:38 +0000 (UTC)
Date: Thu, 23 Jul 2026 22:23:33 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Junzhe Yu <junzheyu1@gmail.com>
cc: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [BUG] dm: dm_setup_md_queue UAF walking table_devices without
 lock
In-Reply-To: <5947c25a-0a1e-4bb2-ad3e-8e4d9ecbd8c2@gmail.com>
Message-ID: <2f28baa4-d328-1a06-8a86-a7814cb2955b@redhat.com>
References: <5947c25a-0a1e-4bb2-ad3e-8e4d9ecbd8c2@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: BkY6bZuzVe3ueGyFM5Q9O1xL38_zxQQ2zRVm2PVSnWs_1784838221
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sat, 18 Jul 2026, Junzhe Yu wrote:

> Hello,
> 
> I am reporting a KASAN slab use-after-free in the device-mapper core in
> dm_setup_md_queue().
> 
> Summary
> =======
> 
> dm_setup_md_queue() walks md->table_devices without holding
> md->table_devices_lock while a concurrent failed DM_TABLE_LOAD frees a
> table_device via dm_table_destroy() -> close_table_device(). The crash
> shows as a KASAN UAF on the list walk, and often a follow-on page fault
> in bd_link_disk_holder().

Hi

Does this patch fix it?

Mikulas



dm: fix race when loading and unloading a table

If the userspace calls two concurrent table load ioctls and one of them
succeeds and the other fails, there is a race condition because
dm_setup_md_queue walks &md->table_devices without any lock. If the walk
races with dm_table_destroy -> free_devices -> dm_put_table_device, there
is access to invalid memory.

Fix this race by extending the lock over the list walk.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2026-07-23 14:13:37.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2026-07-23 18:43:19.000000000 +0200
@@ -2630,9 +2630,10 @@ int dm_setup_md_queue(struct mapped_devi
 	 */
 	mutex_lock(&md->table_devices_lock);
 	r = add_disk(md->disk);
-	mutex_unlock(&md->table_devices_lock);
-	if (r)
+	if (r) {
+		mutex_unlock(&md->table_devices_lock);
 		return r;
+	}
 
 	/*
 	 * Register the holder relationship for devices added before the disk
@@ -2643,18 +2644,21 @@ int dm_setup_md_queue(struct mapped_devi
 		if (r)
 			goto out_undo_holders;
 	}
+	mutex_unlock(&md->table_devices_lock);
 
 	r = dm_sysfs_init(md);
 	if (r)
-		goto out_undo_holders;
+		goto lock_out_undo_holders;
 
 	md->type = type;
+
 	return 0;
 
+lock_out_undo_holders:
+	mutex_lock(&md->table_devices_lock);
 out_undo_holders:
 	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
 		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
-	mutex_lock(&md->table_devices_lock);
 	del_gendisk(md->disk);
 	mutex_unlock(&md->table_devices_lock);
 	return r;

