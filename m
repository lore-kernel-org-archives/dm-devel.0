Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4413EC7EE45
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206960;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t/jUQhMqKQYbL2GQr3pNrhV6xOmcVP+sK3RhAShoPWY=;
	b=UXw3JFOewSw5i7r2X1o7TkW4izJxMMSIRaymCYaR6qz8bsHKCrz2qaOhSss9XvnrFUC1Gz
	t8RHiLaR65ULtcCkZZXr32MRuhRF17OM/yDlfSVwYyGLtlwH5SSf3cOTVyN3N86vpLydI4
	p1WOx4Yqrg9aVWTrOSTS5COzmaAxwN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-KKWeizlcOUOllO5Hs8sqlQ-1; Thu, 08 Jun 2023 02:49:17 -0400
X-MC-Unique: KKWeizlcOUOllO5Hs8sqlQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B13B28EC110;
	Thu,  8 Jun 2023 06:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31118C034A3;
	Thu,  8 Jun 2023 06:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D0D819376EE;
	Thu,  8 Jun 2023 06:48:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF5A719465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 13:14:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 939F0C1603B; Wed,  7 Jun 2023 13:14:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BFE4C16044
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 13:14:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60E42101B055
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 13:14:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-oovL067VOLuX4DnyiExJZQ-1; Wed,
 07 Jun 2023 09:14:36 -0400
X-MC-Unique: oovL067VOLuX4DnyiExJZQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A641A219FE;
 Wed,  7 Jun 2023 13:14:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7308A1346D;
 Wed,  7 Jun 2023 13:14:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id uiivG7uCgGS9YAAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 07 Jun 2023 13:14:35 +0000
Message-ID: <04517ec2-bf6c-0783-9494-fb12a89d07a0@suse.de>
Date: Wed, 7 Jun 2023 15:14:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-31-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230606073950.225178-31-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 30/31] block: store the holder in
 file->private_data
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
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/6/23 09:39, Christoph Hellwig wrote:
> Store the file struct used as the holder in file->private_data as an
> indicator that this file descriptor was opened exclusively to  remove
> the last use of FMODE_EXCL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/fops.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index c40b9f978e3bc7..915e0ef7560993 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -478,7 +478,7 @@ blk_mode_t file_to_blk_mode(struct file *file)
>   		mode |= BLK_OPEN_READ;
>   	if (file->f_mode & FMODE_WRITE)
>   		mode |= BLK_OPEN_WRITE;
> -	if (file->f_mode & FMODE_EXCL)
> +	if (file->private_data)
>   		mode |= BLK_OPEN_EXCL;
>   	if ((file->f_flags & O_ACCMODE) == 3)
>   		mode |= BLK_OPEN_WRITE_IOCTL;
> @@ -501,12 +501,15 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>   	filp->f_flags |= O_LARGEFILE;
>   	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
>   
> +	/*
> +	 * Use the file private data to store the holder, file_to_blk_mode
> +	 * relies on this.
> +	 */

Can you update the comment to reflect that we're only use the
->private_data field for exclusive open?
I know it's indicated by the condition, but we really should
be clarify this usage.

>   	if (filp->f_flags & O_EXCL)
> -		filp->f_mode |= FMODE_EXCL;
> +		filp->private_data = filp;
>   
>   	bdev = blkdev_get_by_dev(inode->i_rdev, file_to_blk_mode(filp),
> -				 (filp->f_mode & FMODE_EXCL) ? filp : NULL,
> -				 NULL);
> +				 filp->private_data, NULL);
>   	if (IS_ERR(bdev))
>   		return PTR_ERR(bdev);
>   
> @@ -517,8 +520,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>   
>   static int blkdev_release(struct inode *inode, struct file *filp)
>   {
> -	blkdev_put(I_BDEV(filp->f_mapping->host),
> -		   (filp->f_mode & FMODE_EXCL) ? filp : NULL);
> +	blkdev_put(I_BDEV(filp->f_mapping->host), filp->private_data);
>   	return 0;
>   }
>   
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

