Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14483C2BBCF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 10:06:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98CB2217A0
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 10:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98CB2217A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607422017;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4LkM7d6FnPxA7vzD/3XWU6NGPFS5u3CQM0FpsucvHG4=;
	b=XBr0I7qqfC8TBdAo+6Yj+IR8U1r2Gn7CvLPaA4SH9enTGPgp8Xi+9vYQ3CgysPhMveh4EP
	IQ3oUVDlP5lNs9fgiYBUq2AxecoAUuBcvIQuw/ZYlT3V7Tz5Wc9demQs4QI43nMR0JjqUg
	mhBTZlrqrI+Wedz4A5X2h1YPzMe9pQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-Yy0xjgiZNLaQyKwuqL-OCA-1; Tue, 08 Dec 2020 05:06:54 -0500
X-MC-Unique: Yy0xjgiZNLaQyKwuqL-OCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 626211005D4D;
	Tue,  8 Dec 2020 10:06:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D8266E505;
	Tue,  8 Dec 2020 10:06:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DDF954A7C6;
	Tue,  8 Dec 2020 10:06:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8A6i3O030985 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 05:06:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5728460C13; Tue,  8 Dec 2020 10:06:44 +0000 (UTC)
Received: from T590 (ovpn-12-237.pek2.redhat.com [10.72.12.237])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0471960BE2;
	Tue,  8 Dec 2020 10:06:26 +0000 (UTC)
Date: Tue, 8 Dec 2020 18:06:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201208100621.GB1202995@T590>
References: <20201207131918.2252553-1-hch@lst.de>
	<20201207131918.2252553-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201207131918.2252553-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
	Mike Snitzer <snitzer@redhat.com>, Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/6] block: remove the NULL bdev check in
	bdev_read_only
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, Dec 07, 2020 at 02:19:14PM +0100, Christoph Hellwig wrote:
> Only a single caller can end up in bdev_read_only, so move the check there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/genhd.c | 3 ---
>  fs/super.c    | 3 ++-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 09ff6cef028729..c87013879b8650 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1445,11 +1445,8 @@ EXPORT_SYMBOL(set_disk_ro);
>  
>  int bdev_read_only(struct block_device *bdev)
>  {
> -	if (!bdev)
> -		return 0;
>  	return bdev->bd_read_only;
>  }
> -
>  EXPORT_SYMBOL(bdev_read_only);
>  
>  /*
> diff --git a/fs/super.c b/fs/super.c
> index 2c6cdea2ab2d9e..5a1f384ffc74f6 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -865,7 +865,8 @@ int reconfigure_super(struct fs_context *fc)
>  
>  	if (fc->sb_flags_mask & SB_RDONLY) {
>  #ifdef CONFIG_BLOCK
> -		if (!(fc->sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
> +		if (!(fc->sb_flags & SB_RDONLY) && sb->s_bdev &&
> +		    bdev_read_only(sb->s_bdev))
>  			return -EACCES;
>  #endif
>  
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

