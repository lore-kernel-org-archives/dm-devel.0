Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D077FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645545656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3SxXPUDIzkLjQjXsRyfNOGLQJxHlFszlTgGjocNOwVk=;
	b=gQCKGRRDbwE8TcbsIGJI9gknr/BqS6U8onekNYpf60Ie5n9YrDG7fxk/FGpTfzTugrK00P
	va/yaXraATrPFrRy8+BMm2Hi8K+AJuFdiAxNxerFIkflv2Rq2aAhwuz9XNqPbbtIxAbmJw
	FM3R4d/Efkq9i5ql2mwBakmh+PoE0dI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-dvXy3bWJMtG1f3y51hFnag-1; Tue, 22 Feb 2022 11:00:53 -0500
X-MC-Unique: dvXy3bWJMtG1f3y51hFnag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D476FC83;
	Tue, 22 Feb 2022 16:00:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3B3B7C694;
	Tue, 22 Feb 2022 16:00:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 639C81809C98;
	Tue, 22 Feb 2022 16:00:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MG0aKK010675 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 11:00:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 44EA2400C849; Tue, 22 Feb 2022 16:00:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4077F400E135
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 16:00:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2774D10AF7C3
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 16:00:36 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-349-vwQru8MRPJyOu1EKsmnXWg-1; Tue, 22 Feb 2022 11:00:34 -0500
X-MC-Unique: vwQru8MRPJyOu1EKsmnXWg-1
Received: by mail-qv1-f71.google.com with SMTP id
	fv11-20020a056214240b00b0043253a948f0so39618qvb.1
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 08:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=7j5XB5PHt4v2EZRj2xa7IPpDQY6qbeddhaMQI3ZMvR8=;
	b=GEzAskoME1v+5OFBPMlkZzjdoqUX1qxmP/RWR5tHL3HRh3wtn93HJPPcBJsz5HMjeL
	Ju/dQwHdqGE1fhLTOF7tHel17MdYUFlH7acvFQx+e+A9JfI2YDiKw9x2Vn0EtdJ2wIc0
	YJsvsblNnLZkWxFiqByCeB0Rtmh/oHrITrGIKqVXF16wrbs4GHjEKD6rUoOSkEDlivFo
	L4nMEe8l+GGdV+VVHjQ4kq7+BDDr4inpNpsT/7Jm2hZX+UCOJAizJ5DLbnYv46XH1/KS
	6pZfx9GLlx0xzjZHGbyoWJloC/xHCRd8ULUWXjUH18h/iy3J9oVct1v9G/c5Ng0xHfBd
	w52g==
X-Gm-Message-State: AOAM530bsqTjUKY43cUSFoBPhrBLG9Y+n9CCTM8p8e896g71/BgecDt0
	rW3R9DHwNyU9qnUCLGhyfXjRNjAklJxxKuETyFJjMH//fVk0EJA2o9q7NSX1fzvK3YtHdXWwmXi
	rmp7yo1hdRFod4g==
X-Received: by 2002:a37:4646:0:b0:5e9:562c:ac48 with SMTP id
	t67-20020a374646000000b005e9562cac48mr16038752qka.140.1645545633638;
	Tue, 22 Feb 2022 08:00:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxryPhmCAvy6V12tr9ic0DJ2vhMYnP9pzcqZxnXZ3eH8/ot/d3iuhUAxdNQeoKTb7fJKlWKtg==
X-Received: by 2002:a37:4646:0:b0:5e9:562c:ac48 with SMTP id
	t67-20020a374646000000b005e9562cac48mr16038726qka.140.1645545633187;
	Tue, 22 Feb 2022 08:00:33 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id h21sm18450qtb.13.2022.02.22.08.00.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 22 Feb 2022 08:00:32 -0800 (PST)
Date: Tue, 22 Feb 2022 11:00:31 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <YhUIny/Huielcit9@redhat.com>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080649epcas5p36ab21e7d33b99eac1963e637389c8be4@epcas5p3.samsung.com>
	<20220214080002.18381-9-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220214080002.18381-9-nj.shetty@samsung.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	Chaitanya Kulkarni <kch@nvidia.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 08/10] dm: Add support for copy offload.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 14 2022 at  2:59P -0500,
Nitesh Shetty <nj.shetty@samsung.com> wrote:

> Before enabling copy for dm target, check if underlying devices and
> dm target support copy. Avoid split happening inside dm target.
> Fail early if the request needs split, currently splitting copy
> request is not supported.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  drivers/md/dm-table.c         | 45 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c               |  6 +++++
>  include/linux/device-mapper.h |  5 ++++
>  3 files changed, 56 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e43096cfe9e2..8dc9ae6a6a86 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1903,6 +1903,38 @@ static bool dm_table_supports_nowait(struct dm_table *t)
>  	return true;
>  }
>  
> +static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
> +				      sector_t start, sector_t len, void *data)
> +{
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +
> +	return !blk_queue_copy(q);
> +}
> +
> +static bool dm_table_supports_copy(struct dm_table *t)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (!ti->copy_supported)
> +			return false;
> +
> +		/*
> +		 * target provides copy support (as implied by setting
> +		 * 'copy_supported') and it relies on _all_ data devices having copy support.
> +		 */
> +		if (ti->copy_supported &&
> +		    (!ti->type->iterate_devices ||
> +		     ti->type->iterate_devices(ti, device_not_copy_capable, NULL)))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
>  				      sector_t start, sector_t len, void *data)
>  {
> @@ -2000,6 +2032,19 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	} else
>  		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
>  
> +	if (!dm_table_supports_copy(t)) {
> +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
> +		/* Must also clear discard limits... */

copy-and-paste mistake: s/discard/copy/ ^

> +		q->limits.max_copy_sectors = 0;
> +		q->limits.max_hw_copy_sectors = 0;
> +		q->limits.max_copy_range_sectors = 0;
> +		q->limits.max_hw_copy_range_sectors = 0;
> +		q->limits.max_copy_nr_ranges = 0;
> +		q->limits.max_hw_copy_nr_ranges = 0;
> +	} else {
> +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
> +	}
> +
>  	if (dm_table_supports_secure_erase(t))
>  		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ab9cc91931f9..3b4cd49c489d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1372,6 +1372,12 @@ static int __split_and_process_non_flush(struct clone_info *ci)
>  	if (__process_abnormal_io(ci, ti, &r))
>  		return r;
>  
> +	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
> +				max_io_len(ti, ci->sector) < ci->sector_count)) {
> +		DMERR("%s: Error IO size(%u) is greater than maximum target size(%llu)\n",
> +				__func__, ci->sector_count, max_io_len(ti, ci->sector));
> +		return -EIO;
> +	}
>  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
>  
>  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);

There isn't a need for __func__ prefix here.

You'll also need to rebase on latest dm-5.18 (or wait until 5.18 merge
window opens) because there has been some conflicting changes since
you posted.

> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index b26fecf6c8e8..acfd4018125a 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -362,6 +362,11 @@ struct dm_target {
>  	 * zone append operations using regular writes.
>  	 */
>  	bool emulate_zone_append:1;
> +
> +	/*
> +	 * copy offload is supported
> +	 */
> +	bool copy_supported:1;
>  };

Would prefer this be "copy_offload_supported".

>  
>  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> -- 
> 2.30.0-rc0
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

