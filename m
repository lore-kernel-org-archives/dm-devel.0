Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE1C186E2F
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941586; cv=none; b=mzQ4ncYMYrqbCqUZAm2JKobSU5Pfl4JdEgHRUzkYJQfL7hyzSIIMLp7hEqe5zLg8pCmsAuhdtGph2FKpVDfbLTnHe65z26shceN3nEPrPeLWItIPp1jRtAekweFmRDQ6tFwaOlgyxv14nTq6muuvynEuIMLy+kYj/5BTKH/fhv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941586; c=relaxed/simple;
	bh=QwqeMlChCkrO1NeOVJLcSSyD5n0e9tFjhsXDJc3/3DA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AmwaQli/HaQzIAJiIlWQ3XLLGleNgUcDNeoc71vJjnb9lswpGlvMNkGj0+2VH0WOEfKNita2EkdnZjH8w5tOZ75LjxDUZyBNvBVXindetWYLiF4xZoMIJDrjtCvD+Dxom0RoSazXSBqfuOlpZax13eebrF78SvQndKw7ov84LHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VX9KyqLb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VX9KyqLb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731941584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6KJDz4iza2kN8QeGs+OXbXOvHDBB6acoq0CHzeE1nn0=;
	b=VX9KyqLbrpu9JiUyUK7oLM9qm1v8CqlLaZ0DIRzd2Ow5OzSTW21Nx29qJvGZb0ttu9ZFMh
	FNWYxgXiXLPwOhLWjKaWMD2/KI8SKHKWl1gdtWAYO2khNZB7J+I3GBSXm5joTdwwKSLmv8
	SB6mn/j2jQqRciUB7GzJ8D1RU94ou5U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-8_lhfk4fNP2L5CI5rKiNUw-1; Mon,
 18 Nov 2024 09:52:58 -0500
X-MC-Unique: 8_lhfk4fNP2L5CI5rKiNUw-1
X-Mimecast-MFC-AGG-ID: 8_lhfk4fNP2L5CI5rKiNUw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACE9B1955F67;
	Mon, 18 Nov 2024 14:52:56 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 380441956056;
	Mon, 18 Nov 2024 14:52:52 +0000 (UTC)
Date: Mon, 18 Nov 2024 15:52:50 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dap581 <dap581@protonmail.com>
cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@lst.de>, 
    Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>, 
    Ilya Dryomov <idryomov@gmail.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] blk-settings: round down io_opt to physical_block_size
In-Reply-To: <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com>
Message-ID: <3dc0014b-9690-dc38-81c9-4a316a2d4fb2@redhat.com>
References: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com> <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r0toPx0Z5NgvWOr93Lc4TD-XdCgZeiKWgSvWvBr6gzY_1731941576
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 18 Nov 2024, Mikulas Patocka wrote:

> On Sat, 16 Nov 2024, dap581 wrote:
> 
> > Hello,
> > Starting with kernel 6.11.x series up to current 6.12-rc7
> > when I unlock my encrypted hdd (storage, not root) with cryptsetup:
> > 
> > cryptsetup luksOpen /dev/sda1 hdd5 -d keyfile_hdd5
> > 
> > it triggers an alignment inconsistency:
> > In dmesg log, I read:
> > ----
> > [  105.841278] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > [  105.841292] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > [  105.841601] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > [  105.841607] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > ----

Hi

Does this patch fix it?

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

There was a bug report [1] where the user got a warning alignment
inconsistency. The user has optimal I/O 16776704 (0xFFFE00) and physical
block size 4096. Note that the optimal I/O size may be set by the DMA
engines or SCSI controllers and they have no knowledge about the disks
attached to them, so the situation with optimal I/O not aligned to
physical block size may happen.

This commit makes blk_validate_limits round down optimal I/O size to the
physical block size of the block device.

Closes: https://lore.kernel.org/dm-devel/1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com/T/ [1]
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a23634644afc ("block: take io_opt and io_min into account for max_sectors")
Cc: stable@vger.kernel.org	# v6.11+

---
 block/blk-settings.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2024-11-18 15:24:18.000000000 +0100
+++ linux-2.6/block/blk-settings.c	2024-11-18 15:29:24.000000000 +0100
@@ -250,6 +250,13 @@ static int blk_validate_limits(struct qu
 		lim->io_min = lim->physical_block_size;
 
 	/*
+	 * The optimal I/O size may not be aligned to physical block size
+	 * (because it may be limited by dma engines which have no clue about
+	 * block size of the disks attached to them), so we round it down here.
+	 */
+	lim->io_opt = round_down(lim->io_opt, lim->physical_block_size);
+
+	/*
 	 * max_hw_sectors has a somewhat weird default for historical reason,
 	 * but driver really should set their own instead of relying on this
 	 * value.

