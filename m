Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3BEC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 06:26:20 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-Lc-GTspbPqSXh4owgnlpBQ-1; Wed, 02 Mar 2022 01:26:08 -0500
X-MC-Unique: Lc-GTspbPqSXh4owgnlpBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 641F28031E1;
	Wed,  2 Mar 2022 06:26:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA0E54E2C2;
	Wed,  2 Mar 2022 06:26:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 32ACF1809C98;
	Wed,  2 Mar 2022 06:25:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 221EVdYl025242 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 09:31:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D54472144B21; Tue,  1 Mar 2022 14:31:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D11612144B20
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 14:31:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 681751C0E34B
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 14:31:33 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-182-rtWINPREMZ6gSuSRqNUPpg-1; Tue, 01 Mar 2022 09:31:31 -0500
X-MC-Unique: rtWINPREMZ6gSuSRqNUPpg-1
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id A216C2110B;
	Tue,  1 Mar 2022 14:26:01 +0000 (UTC)
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
	by relay2.suse.de (Postfix) with ESMTP id 600F3A3B81;
	Tue,  1 Mar 2022 14:26:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
	id E36AEDA80E; Tue,  1 Mar 2022 15:22:09 +0100 (CET)
Date: Tue, 1 Mar 2022 15:22:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20220301142209.GN12643@suse.cz>
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
References: <20220301084552.880256-1-hch@lst.de>
	<20220301084552.880256-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220301084552.880256-2-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Mar 2022 01:25:55 -0500
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/5] btrfs: simplify ->flush_bio handling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: dsterba@suse.cz
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 01, 2022 at 10:45:48AM +0200, Christoph Hellwig wrote:
> @@ -6962,16 +6961,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>  	if (!dev)
>  		return ERR_PTR(-ENOMEM);
>  
> -	/*
> -	 * Preallocate a bio that's always going to be used for flushing device
> -	 * barriers and matches the device lifespan
> -	 */
> -	dev->flush_bio = bio_kmalloc(GFP_KERNEL, 0);
> -	if (!dev->flush_bio) {
> -		kfree(dev);
> -		return ERR_PTR(-ENOMEM);
> -	}
> -
>  	INIT_LIST_HEAD(&dev->dev_list);
>  	INIT_LIST_HEAD(&dev->dev_alloc_list);
>  	INIT_LIST_HEAD(&dev->post_commit_list);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 005c9e2a491a1..9af7b6211920c 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -117,7 +117,7 @@ struct btrfs_device {
>  	u64 commit_bytes_used;
>  
>  	/* for sending down flush barriers */
> -	struct bio *flush_bio;

Please add this comment to the struct member declaration:

	/* Bio used for flushing device barriers */

> +	struct bio flush_bio;

Otherwise

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

