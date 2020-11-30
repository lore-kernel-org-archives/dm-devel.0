Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756E0C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 21:01:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8D98206D4
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 21:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8D98206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-3bGPAwlOOd6jsE53mL8Inw-1; Mon, 30 Nov 2020 16:01:21 -0500
X-MC-Unique: 3bGPAwlOOd6jsE53mL8Inw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B451800D42;
	Mon, 30 Nov 2020 21:01:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6FD819C71;
	Mon, 30 Nov 2020 21:01:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96FD14A7C6;
	Mon, 30 Nov 2020 21:01:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUL1B0m029385 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 16:01:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 186542166B2C; Mon, 30 Nov 2020 21:01:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1340A2166B2B
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 21:01:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACD50811E84
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 21:01:08 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-546-ak-ok3m2MAaYN1-YEUMH-Q-1; Mon, 30 Nov 2020 16:01:03 -0500
X-MC-Unique: ak-ok3m2MAaYN1-YEUMH-Q-1
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0AUHt6sJ032368; Mon, 30 Nov 2020 17:55:35 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by aserp2130.oracle.com with ESMTP id 353c2apjs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Mon, 30 Nov 2020 17:55:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0AUHk2nh011017; Mon, 30 Nov 2020 17:55:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserp3020.oracle.com with ESMTP id 3540ewv77j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Nov 2020 17:55:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUHtSUK012345;
	Mon, 30 Nov 2020 17:55:28 GMT
Received: from localhost (/67.169.218.210)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Mon, 30 Nov 2020 09:55:28 -0800
Date: Mon, 30 Nov 2020 09:55:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201130175526.GA143012@magnolia>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-5-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0 phishscore=0
	suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011300116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1
	lowpriorityscore=0
	clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
	spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011300117
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
Cc: Jens Axboe <axboe@kernel.dk>, Chao Yu <yuchao0@huawei.com>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 04/45] fs: simplify freeze_bdev/thaw_bdev
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Nov 28, 2020 at 05:14:29PM +0100, Christoph Hellwig wrote:
> Store the frozen superblock in struct block_device to avoid the awkward
> interface that can return a sb only used a cookie, an ERR_PTR or NULL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: Chao Yu <yuchao0@huawei.com>		[f2fs]
> ---
>  drivers/md/dm-core.h      |  5 -----
>  drivers/md/dm.c           | 20 ++++++--------------
>  fs/block_dev.c            | 37 +++++++++++++++----------------------
>  fs/buffer.c               |  2 +-
>  fs/ext4/ioctl.c           |  2 +-
>  fs/f2fs/file.c            | 14 +++++---------
>  fs/xfs/xfs_fsops.c        |  7 ++-----

For the xfs part:
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

(I did glance at the other 44 patches and didn't see anything that
screamed 'wrong' but I wouldn't call that a strong review...)

--D

>  include/linux/blk_types.h |  1 +
>  include/linux/blkdev.h    |  4 ++--
>  9 files changed, 33 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index d522093cb39dda..aace147effcacb 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -96,11 +96,6 @@ struct mapped_device {
>  	 */
>  	struct workqueue_struct *wq;
>  
> -	/*
> -	 * freeze/thaw support require holding onto a super block
> -	 */
> -	struct super_block *frozen_sb;
> -
>  	/* forced geometry settings */
>  	struct hd_geometry geometry;
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 54739f1b579bc8..50541d336c719b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2392,27 +2392,19 @@ static int lock_fs(struct mapped_device *md)
>  {
>  	int r;
>  
> -	WARN_ON(md->frozen_sb);
> +	WARN_ON(test_bit(DMF_FROZEN, &md->flags));
>  
> -	md->frozen_sb = freeze_bdev(md->bdev);
> -	if (IS_ERR(md->frozen_sb)) {
> -		r = PTR_ERR(md->frozen_sb);
> -		md->frozen_sb = NULL;
> -		return r;
> -	}
> -
> -	set_bit(DMF_FROZEN, &md->flags);
> -
> -	return 0;
> +	r = freeze_bdev(md->bdev);
> +	if (!r)
> +		set_bit(DMF_FROZEN, &md->flags);
> +	return r;
>  }
>  
>  static void unlock_fs(struct mapped_device *md)
>  {
>  	if (!test_bit(DMF_FROZEN, &md->flags))
>  		return;
> -
> -	thaw_bdev(md->bdev, md->frozen_sb);
> -	md->frozen_sb = NULL;
> +	thaw_bdev(md->bdev);
>  	clear_bit(DMF_FROZEN, &md->flags);
>  }
>  
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index d8664f5c1ff669..33c29106c98907 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -548,55 +548,47 @@ EXPORT_SYMBOL(fsync_bdev);
>   * count down in thaw_bdev(). When it becomes 0, thaw_bdev() will unfreeze
>   * actually.
>   */
> -struct super_block *freeze_bdev(struct block_device *bdev)
> +int freeze_bdev(struct block_device *bdev)
>  {
>  	struct super_block *sb;
>  	int error = 0;
>  
>  	mutex_lock(&bdev->bd_fsfreeze_mutex);
> -	if (++bdev->bd_fsfreeze_count > 1) {
> -		/*
> -		 * We don't even need to grab a reference - the first call
> -		 * to freeze_bdev grab an active reference and only the last
> -		 * thaw_bdev drops it.
> -		 */
> -		sb = get_super(bdev);
> -		if (sb)
> -			drop_super(sb);
> -		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -		return sb;
> -	}
> +	if (++bdev->bd_fsfreeze_count > 1)
> +		goto done;
>  
>  	sb = get_active_super(bdev);
>  	if (!sb)
> -		goto out;
> +		goto sync;
>  	if (sb->s_op->freeze_super)
>  		error = sb->s_op->freeze_super(sb);
>  	else
>  		error = freeze_super(sb);
> +	deactivate_super(sb);
> +
>  	if (error) {
> -		deactivate_super(sb);
>  		bdev->bd_fsfreeze_count--;
> -		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -		return ERR_PTR(error);
> +		goto done;
>  	}
> -	deactivate_super(sb);
> - out:
> +	bdev->bd_fsfreeze_sb = sb;
> +
> +sync:
>  	sync_blockdev(bdev);
> +done:
>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -	return sb;	/* thaw_bdev releases s->s_umount */
> +	return error;
>  }
>  EXPORT_SYMBOL(freeze_bdev);
>  
>  /**
>   * thaw_bdev  -- unlock filesystem
>   * @bdev:	blockdevice to unlock
> - * @sb:		associated superblock
>   *
>   * Unlocks the filesystem and marks it writeable again after freeze_bdev().
>   */
> -int thaw_bdev(struct block_device *bdev, struct super_block *sb)
> +int thaw_bdev(struct block_device *bdev)
>  {
> +	struct super_block *sb;
>  	int error = -EINVAL;
>  
>  	mutex_lock(&bdev->bd_fsfreeze_mutex);
> @@ -607,6 +599,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  	if (--bdev->bd_fsfreeze_count > 0)
>  		goto out;
>  
> +	sb = bdev->bd_fsfreeze_sb;
>  	if (!sb)
>  		goto out;
>  
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 23f645657488ba..a7595ada9400ff 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -523,7 +523,7 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
>  
>  void emergency_thaw_bdev(struct super_block *sb)
>  {
> -	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
> +	while (sb->s_bdev && !thaw_bdev(sb->s_bdev))
>  		printk(KERN_WARNING "Emergency Thaw on %pg\n", sb->s_bdev);
>  }
>  
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index f0381876a7e5b0..524e134324475e 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -624,7 +624,7 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
>  	case EXT4_GOING_FLAGS_DEFAULT:
>  		freeze_bdev(sb->s_bdev);
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
> -		thaw_bdev(sb->s_bdev, sb);
> +		thaw_bdev(sb->s_bdev);
>  		break;
>  	case EXT4_GOING_FLAGS_LOGFLUSH:
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index ee861c6d9ff026..a9fc482a0e60a5 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -2230,16 +2230,12 @@ static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
>  
>  	switch (in) {
>  	case F2FS_GOING_DOWN_FULLSYNC:
> -		sb = freeze_bdev(sb->s_bdev);
> -		if (IS_ERR(sb)) {
> -			ret = PTR_ERR(sb);
> +		ret = freeze_bdev(sb->s_bdev);
> +		if (ret)
>  			goto out;
> -		}
> -		if (sb) {
> -			f2fs_stop_checkpoint(sbi, false);
> -			set_sbi_flag(sbi, SBI_IS_SHUTDOWN);
> -			thaw_bdev(sb->s_bdev, sb);
> -		}
> +		f2fs_stop_checkpoint(sbi, false);
> +		set_sbi_flag(sbi, SBI_IS_SHUTDOWN);
> +		thaw_bdev(sb->s_bdev);
>  		break;
>  	case F2FS_GOING_DOWN_METASYNC:
>  		/* do checkpoint only */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ef1d5bb88b93ab..b7c5783a031c69 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -433,13 +433,10 @@ xfs_fs_goingdown(
>  {
>  	switch (inflags) {
>  	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
> -		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
> -
> -		if (sb && !IS_ERR(sb)) {
> +		if (!freeze_bdev(mp->m_super->s_bdev)) {
>  			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
> -			thaw_bdev(sb->s_bdev, sb);
> +			thaw_bdev(mp->m_super->s_bdev);
>  		}
> -
>  		break;
>  	}
>  	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index d9b69bbde5cc54..ebfb4e7c1fd125 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -46,6 +46,7 @@ struct block_device {
>  	int			bd_fsfreeze_count;
>  	/* Mutex for freeze */
>  	struct mutex		bd_fsfreeze_mutex;
> +	struct super_block	*bd_fsfreeze_sb;
>  } __randomize_layout;
>  
>  /*
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 05b346a68c2eee..12810a19edebc4 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -2020,7 +2020,7 @@ static inline int sync_blockdev(struct block_device *bdev)
>  #endif
>  int fsync_bdev(struct block_device *bdev);
>  
> -struct super_block *freeze_bdev(struct block_device *bdev);
> -int thaw_bdev(struct block_device *bdev, struct super_block *sb);
> +int freeze_bdev(struct block_device *bdev);
> +int thaw_bdev(struct block_device *bdev);
>  
>  #endif /* _LINUX_BLKDEV_H */
> -- 
> 2.29.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

