Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43B92E414
	for <dm-devel@lists.linux.dev>; Mon,  2 Mar 2026 03:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772421712; cv=none; b=h4vlG7tFsLjhUDDRiMGfPCu07gvGnqjND1xp2gLckoYJeHy0rK7K++nIrSH3dBSPwB056xZLdQi2IfawvLmF0TGqjzPcjTly8YCOtdHmLPja5IF3h69mJkBkdWe6aAzi+5OoJRNSxOdTS7ma8CAkDLuhxxKWUNvJQhNihHSbunk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772421712; c=relaxed/simple;
	bh=y6z9ZW7G9x4KQm6Gpu5+sdcZ3xRHqV2Qku8hwRu0ErY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=K9UVLtuM9TODFY29LAg1G9KsczXlFDcqdkYCjSmtS1IGGSK91Z3tmGhT3CtN/6UqvXwmddb8s574PuNy2VrTHqVbO1oct9Uu5qpHb5Gk4JFa3PBArfNmKN+1BWQjEMjtomyfIvyek4KugmoEKpPmbrPqI0osUenM50EsQv0m9qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iNTnTSoj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNTnTSoj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772421709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lr1K3+67qIkavCXb7dXKJoUo01SRTqdLi2G1D317JG8=;
	b=iNTnTSojhbaXQolfOX30r/dMRGm9bdf3vzm1vjo+jJZyzT/qHSr4tAlXhdMxhXFcEuCFJ4
	u/6p8NNE6iWy6OEviycA/yU8eKYapQTbf04ntFB9WQ7LHTCp10hqA0gbTQ90s3+4ObnLdA
	hztX3chMcwcUMWMC/lXDLP9qAQ/kJdY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-LPdki3zNORyns8xHFA34QQ-1; Sun,
 01 Mar 2026 22:21:48 -0500
X-MC-Unique: LPdki3zNORyns8xHFA34QQ-1
X-Mimecast-MFC-AGG-ID: LPdki3zNORyns8xHFA34QQ_1772421706
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A342C1800342;
	Mon,  2 Mar 2026 03:21:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 714C61800297;
	Mon,  2 Mar 2026 03:21:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6223LhRu1830920
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Mar 2026 22:21:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6223LhVm1830919;
	Sun, 1 Mar 2026 22:21:43 -0500
Date: Sun, 1 Mar 2026 22:21:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/24] scsi-multipath: clone each bio
Message-ID: <aaUCR-IoNItKVZCh@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-8-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260225153627.1032500-8-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 8WiMVCn2CeoFZdFP3M1m8PWN6w2-AvE0N1g3W7ONe_Y_1772421706
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2026 at 03:36:10PM +0000, John Garry wrote:
> For failover handling, we must resubmit each bio.
> 
> However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
> is either all or none completed.
> 
> As such, for SCSI, for failover handling we will take the approach to
> just re-submit the original bio. For this clone and submit each bio.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_multipath.c | 51 ++++++++++++++++++++++++++++++++++-
>  include/scsi/scsi_multipath.h |  1 +
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 4b7984e7e74ba..d79a92ec0cf6c 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -89,6 +89,14 @@ module_param_call(iopolicy, scsi_set_iopolicy, scsi_get_iopolicy,
>  MODULE_PARM_DESC(iopolicy,
>  	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
>  
> +struct scsi_mpath_clone_bio {
> +	struct bio		*master_bio;
> +	struct bio		clone;
> +};

If the only extra information you need for your clone bios is a pointer
to the original bio, I think you can just store that in bi_private. So
you shouldn't actually need to allocate any front pad for your bioset.

> +
> +#define scsi_mpath_to_master_bio(clone) \
> +		container_of(clone, struct scsi_mpath_clone_bio, clone)
> +
>  static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
>  {
>  	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;

> @@ -260,6 +269,39 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>  	return 0;
>  }
>  
> +static void scsi_mpath_clone_end_io(struct bio *clone)
> +{
> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio =
> +			scsi_mpath_to_master_bio(clone);
> +	struct bio *master_bio = scsi_mpath_clone_bio->master_bio;
> +
> +	master_bio->bi_status = clone->bi_status;
> +	bio_put(clone);
> +	bio_endio(master_bio);
> +}
> +
> +static struct bio *scsi_mpath_clone_bio(struct bio *bio)
> +{
> +	struct mpath_disk *mpath_disk = bio->bi_bdev->bd_disk->private_data;
> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
> +	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
> +	struct bio *clone;
> +
> +	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOWAIT,
> +				&scsi_mpath_head->bio_pool);

Why use GFP_NOWAIT? It's more likely to fail than GFP_NOIO. If the bio
has REQ_NOWAIT set, I can see where you would need this, but otherwise,
I don't see why GFP_NOIO wouldn't be better here.

> +	if (!clone)
> +		return NULL;
> +
> +	clone->bi_end_io = scsi_mpath_clone_end_io;
> +
> +	scsi_mpath_clone_bio = container_of(clone,
> +					struct scsi_mpath_clone_bio, clone);
> +	scsi_mpath_clone_bio->master_bio = bio;
> +
> +	return clone;
> +}
> +
>  static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_head)
>  {
>  	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
> @@ -269,6 +311,7 @@ static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_he
>  
>  struct mpath_head_template smpdt_pr = {
>  	.get_iopolicy = scsi_mpath_get_iopolicy,
> +	.clone_bio = scsi_mpath_clone_bio,
>  };
>  
>  static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
> @@ -283,9 +326,13 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>  	ida_init(&scsi_mpath_head->ida);
>  	mutex_init(&scsi_mpath_head->lock);
>  
> +	if (bioset_init(&scsi_mpath_head->bio_pool, SCSI_MAX_QUEUE_DEPTH,
> +			offsetof(struct scsi_mpath_clone_bio, clone),
> +			BIOSET_NEED_BVECS|BIOSET_PERCPU_CACHE))

You don't need 4096 cached bios to guarantee forward progress. I don't
see why BIO_POOL_SIZE won't work fine here. Also, since you are cloning
bios, they are sharing the original bio's iovecs, so you don't need
BIOSET_NEED_BVECS.

-Ben

