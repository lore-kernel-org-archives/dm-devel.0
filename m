Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08EEC88CB2
	for <dm-devel@archiver.kernel.org>; Fri, 25 Aug 2023 02:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692931526;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n2uWQEWgWHy7Mf2g0Q7Eceo9+N3kI3C6qoDD3ukqi4A=;
	b=apHsYQCQDKJiqY91wePClt1M3y/ECHK4GlKSTVnD16zfUlBJpQvHgO+Za7B+LVa1IneRtn
	FulDeF6qgPImKeQt5HBHgWHys/tsZ2QlbJaj6qPr6pDGjj/+CmIXy8ASj4C7NrBpQ/RiR7
	axh/m6gALpYwgsfjDlG2OH1sEPPOImE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-Q6Ne-oXLMOiaYLpEbcV7MQ-1; Thu, 24 Aug 2023 22:45:23 -0400
X-MC-Unique: Q6Ne-oXLMOiaYLpEbcV7MQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 960A6803DBE;
	Fri, 25 Aug 2023 02:45:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47CF66B2B2;
	Fri, 25 Aug 2023 02:45:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2741119465A3;
	Fri, 25 Aug 2023 02:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A90741946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Aug 2023 02:45:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 926BC40C6F4E; Fri, 25 Aug 2023 02:45:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B14F40C6F4C
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 02:45:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 628F11C0897D
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 02:45:19 +0000 (UTC)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-_KRNsSXTN1GzbDZJ4Nk2kw-1; Thu,
 24 Aug 2023 22:45:16 -0400
X-MC-Unique: _KRNsSXTN1GzbDZJ4Nk2kw-1
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1qZMoj-000edp-26; Fri, 25 Aug 2023 02:44:57 +0000
Date: Fri, 25 Aug 2023 03:44:57 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230825024457.GD95084@ZenIV>
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230608110258.189493-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 01/30] block: also call ->open for
 incremental partition opens
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: zeniv.linux.org.uk
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 08, 2023 at 01:02:29PM +0200, Christoph Hellwig wrote:

> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -683,9 +683,6 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
>  	struct gendisk *disk = part->bd_disk;
>  	int ret;
>  
> -	if (atomic_read(&part->bd_openers))
> -		goto done;
> -
>  	ret = blkdev_get_whole(bdev_whole(part), mode);
>  	if (ret)
>  		return ret;
> @@ -694,9 +691,10 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
>  	if (!bdev_nr_sectors(part))
>  		goto out_blkdev_put;
>  
> -	disk->open_partitions++;
> -	set_init_blocksize(part);
> -done:
> +	if (!atomic_read(&part->bd_openers)) {
> +		disk->open_partitions++;
> +		set_init_blocksize(part);
> +	}

[with apologies for very late (and tangential) reply]

That got me curious about the ->bd_openers - do we need it atomic?
Most of the users (and all places that do modifications) are
under ->open_mutex; the only exceptions are
	* early sync logics in blkdev_put(); it's explicitly racy -
see the comment there.
	* callers of disk_openers() in loop and nbd (the ones in
zram are under ->open_mutex).  There's driver-private exclusion
around those, but in any case - READ_ONCE() is no worse than
atomic_read() in those cases.

Is there something subtle I'm missing here?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

