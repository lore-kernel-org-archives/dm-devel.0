Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E0FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:55:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-yl5iem1ANiuB4wLhAea6Uw-1; Tue, 23 Nov 2021 17:55:00 -0500
X-MC-Unique: yl5iem1ANiuB4wLhAea6Uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DE97BAF81;
	Tue, 23 Nov 2021 22:54:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E22C19730;
	Tue, 23 Nov 2021 22:54:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0A1EE1832E84;
	Tue, 23 Nov 2021 22:54:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMssKW025839 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:54:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5681A51E5; Tue, 23 Nov 2021 22:54:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5132351E3
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:54:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EB10185A794
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:54:51 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-207-z_Fp5YVtPayQqCWVifANCA-1; Tue, 23 Nov 2021 17:54:49 -0500
X-MC-Unique: z_Fp5YVtPayQqCWVifANCA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FDCD60F5B;
	Tue, 23 Nov 2021 22:54:48 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:54:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123225448.GO266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-20-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-20-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 19/29] ext2: cleanup the dax handling in
	ext2_fill_super
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:32:59AM +0100, Christoph Hellwig wrote:
> Only call fs_dax_get_by_bdev once the sbi has been allocated and remove
> the need for the dax_dev local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/ext2/super.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index a964066a80aa7..7e23482862e69 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -802,7 +802,6 @@ static unsigned long descriptor_loc(struct super_block *sb,
>  
>  static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  {
> -	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
>  	struct buffer_head * bh;
>  	struct ext2_sb_info * sbi;
>  	struct ext2_super_block * es;
> @@ -822,17 +821,17 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
> -		goto failed;
> +		return -ENOMEM;
>  
>  	sbi->s_blockgroup_lock =
>  		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
>  	if (!sbi->s_blockgroup_lock) {
>  		kfree(sbi);
> -		goto failed;
> +		return -ENOMEM;
>  	}
>  	sb->s_fs_info = sbi;
>  	sbi->s_sb_block = sb_block;
> -	sbi->s_daxdev = dax_dev;
> +	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
>  
>  	spin_lock_init(&sbi->s_lock);
>  	ret = -EINVAL;
> @@ -946,7 +945,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
>  	if (test_opt(sb, DAX)) {
> -		if (!dax_dev) {
> +		if (!sbi->s_daxdev) {
>  			ext2_msg(sb, KERN_ERR,
>  				"DAX unsupported by block device. Turning off DAX.");
>  			clear_opt(sbi->s_mount_opt, DAX);
> @@ -1201,11 +1200,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  failed_mount:
>  	brelse(bh);
>  failed_sbi:
> +	fs_put_dax(sbi->s_daxdev);
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
> -failed:
> -	fs_put_dax(dax_dev);
>  	return ret;
>  }
>  
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

