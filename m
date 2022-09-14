Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8DBECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663174377;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HhzMumW/QguG1F+qJNFOeHlSyKzzXkv7ZqGwi4ClfIk=;
	b=APmekSnkIVh1YhpP6tO3EFLgdNwPCVvzFUjijWO1izightvO3oHLXDUqAPUZ3Zc1jdMe9D
	FENG415VpUFtkK9QvZGr06s/CdHaG0NwDKTNoQga1BKHgEDfNrceO9+hehTqyEARr/9/KM
	ckYJBGPxjQSmdvY73xUdOquzNaZVRg4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-ECs4KaY4OXKi25uOWnaIAw-1; Wed, 14 Sep 2022 12:52:56 -0400
X-MC-Unique: ECs4KaY4OXKi25uOWnaIAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19EF01C05157;
	Wed, 14 Sep 2022 16:52:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC5AB408A3C3;
	Wed, 14 Sep 2022 16:52:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FA351946A55;
	Wed, 14 Sep 2022 16:52:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 203D21946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 16:52:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F21A40C6EC4; Wed, 14 Sep 2022 16:52:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B77C40C6EC3
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 16:52:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6A453C1104F
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 16:52:51 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-637-w3WPaW5DOy6JZZQRBzKmCA-1; Wed, 14 Sep 2022 12:52:48 -0400
X-MC-Unique: w3WPaW5DOy6JZZQRBzKmCA-1
Received: by mail-qt1-f198.google.com with SMTP id
 bc7-20020a05622a1cc700b0035cb7f86f46so2841249qtb.6
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 09:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=FvOBdsojWCJABXZCp0RY/6Mq8SyzuH3awK4wP3zanGs=;
 b=ZQlCGoWoOsXqT4oUBXioLJyVRj1tnG4phKEzPEe0Ho4JshbwzE/KV1EeMY8Jp1GV9l
 1jHNEpGlR93/vZGFimKzm1AX0rJAHqLF45gVm16i9Z4HTC6RI6pjMlchxone3dOvcciB
 hGUOR8ux+Smd/KaNSiO7tqeYS6zqeX88BJXYEDCu2O49dTYvvlQxj/9xKG7MMdfW2ymf
 3tSIeZI44z8BsY88FOeBe6x7UFRtUSkHzEnGKyHxmPpNkyeALl0hf87siwQjddlZU0pE
 fLrF2hB7SxnZ3O9A2c3iHtIgG3LCaodE1XM5PmFHWoPiHyYQ/6zsuGhuAcu4MarMsfOl
 XWOQ==
X-Gm-Message-State: ACgBeo3GqC2z3JOM89ERd4rNqs2N6UpAIfMEuAcG2TGLB50wlxFXLMth
 ZvG9GV5bpWFyg7MNm+uFYzenO1PB3DSaj8qRIkoa7gniMtw2t/RAf6cv2blJNmm+uC8k2zFdWoy
 7gykBGHeoz6JhBQ==
X-Received: by 2002:a05:620a:752:b0:6cd:d01f:9ae8 with SMTP id
 i18-20020a05620a075200b006cdd01f9ae8mr18106604qki.647.1663174368102; 
 Wed, 14 Sep 2022 09:52:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7OhtIaLAfMpS1s3ldH71rZneL17H9vxVroz5KeWXEFxcJUMafg4zdP+aYPnGrtT3D+VdfmQQ==
X-Received: by 2002:a05:620a:752:b0:6cd:d01f:9ae8 with SMTP id
 i18-20020a05620a075200b006cdd01f9ae8mr18106584qki.647.1663174367856; 
 Wed, 14 Sep 2022 09:52:47 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 o17-20020a05620a2a1100b006ce9e880c6fsm449286qkp.111.2022.09.14.09.52.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 14 Sep 2022 09:52:47 -0700 (PDT)
Date: Wed, 14 Sep 2022 12:52:46 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YyIG3i++QriS9Gyy@redhat.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5@eucas1p2.samsung.com>
 <20220912082204.51189-14-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220912082204.51189-14-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v13 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 12 2022 at  4:22P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> Only zoned devices with power-of-2(po2) number of sectors per zone(zone
> size) were supported in linux but now non power-of-2(npo2) zone sizes
> support has been added to the block layer.
> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zone
> sizes, it was suggested to create a dm target for npo2 zone size device to
> appear as a po2 zone size target so that file systems can initially
> work without any explicit changes.
> 
> The design of this target is very simple: remap the device zone size to
> the zone capacity and change the zone size to be the nearest power of 2
> value.
> 
> For e.g., a device with a zone size/capacity of 3M will have an equivalent
> target layout as follows:
> 
> Device layout :-
> zone capacity = 3M
> zone size = 3M
> 
> |--------------|-------------|
> 0             3M            6M
> 
> Target layout :-
> zone capacity=3M
> zone size = 4M
> 
> |--------------|---|--------------|---|
> 0             3M  4M             7M  8M
> 
> The area between target's zone capacity and zone size will be emulated
> in the target.
> The read IOs that fall in the emulated gap area will return 0 filled
> bio and all the other IOs in that area will result in an error.
> If a read IO span across the emulated area boundary, then the IOs are
> split across them. All other IO operations that span across the emulated
> area boundary will result in an error.
> 
> The target can be easily created as follows:
> dmsetup create <label> --table '0 <size_sects> po2zoned /dev/nvme<id>'
> 
> The target does not support partial mapping of the underlying
> device as there is no use-case for it.
> 
> Note:
> This target is not related to dm-zoned target, which exposes a zoned block
> device as a regular block device without any write constraint.
> 
> This target only exposes a different zone size than the underlying device.
> The underlying device's other constraints will be directly exposed to the
> target.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> ---

<snip>

> diff --git a/drivers/md/dm-po2zoned-target.c b/drivers/md/dm-po2zoned-target.c
> new file mode 100644
> index 000000000000..a48955faa978
> --- /dev/null
> +++ b/drivers/md/dm-po2zoned-target.c

<snip>

> +/*
> + * This target works on the complete zoned device. Partial mapping is not
> + * supported.
> + * Construct a zoned po2 logical device: <dev-path>
> + */
> +static int dm_po2z_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct dm_po2z_target *dmh = NULL;
> +	int ret;
> +	sector_t zone_size;
> +	sector_t dev_capacity;
> +
> +	if (argc != 1)
> +		return -EINVAL;
> +
> +	dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
> +	if (!dmh)
> +		return -ENOMEM;
> +
> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
> +			    &dmh->dev);
> +	if (ret) {
> +		ti->error = "Device lookup failed";
> +		kfree(dmh);
> +		return ret;
> +	}
> +
> +	if (!bdev_is_zoned(dmh->dev->bdev)) {
> +		DMERR("%pg is not a zoned device", dmh->dev->bdev);
> +		kfree(dmh);
> +		return -EINVAL;
> +	}
> +
> +	zone_size = bdev_zone_sectors(dmh->dev->bdev);
> +	dev_capacity = get_capacity(dmh->dev->bdev->bd_disk);
> +	if (ti->len != dev_capacity) {
> +		DMERR("%pg Partial mapping of the target is not supported",
> +		      dmh->dev->bdev);
> +		kfree(dmh);
> +		return -EINVAL;
> +	}
> +
> +	if (is_power_of_2(zone_size))
> +		DMWARN("%pg: underlying device has a power-of-2 number of sectors per zone",
> +		       dmh->dev->bdev);
> +
> +	dmh->zone_size = zone_size;
> +	dmh->zone_size_po2 = 1 << get_count_order_long(zone_size);
> +	dmh->zone_size_po2_shift = ilog2(dmh->zone_size_po2);
> +	dmh->zone_size_diff = dmh->zone_size_po2 - dmh->zone_size;
> +	ti->private = dmh;
> +	ti->max_io_len = dmh->zone_size_po2;
> +	dmh->nr_zones = npo2_zone_no(dmh, ti->len);
> +	ti->len = dmh->zone_size_po2 * dmh->nr_zones;
> +
> +	return 0;
> +}

The above error paths need to unwind the references or any other
resources acquired before failing.  Please see other targets for how
they handle sequencing of the needed operations (e.g. dm_put_device)
in the error path by using gotos, etc.

> +
> +static int dm_po2z_report_zones_cb(struct blk_zone *zone, unsigned int idx,
> +				   void *data)
> +{
> +	struct dm_report_zones_args *args = data;
> +	struct dm_target *ti = args->tgt;
> +	struct dm_po2z_target *dmh = ti->private;
> +
> +	zone->start = device_to_target_sect(ti, zone->start);
> +	zone->wp = device_to_target_sect(ti, zone->wp);
> +	zone->len = dmh->zone_size_po2;
> +	args->next_sector = zone->start + zone->len;
> +
> +	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
> +}
> +
> +static int dm_po2z_report_zones(struct dm_target *ti,
> +				struct dm_report_zones_args *args,
> +				unsigned int nr_zones)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +	sector_t sect =
> +		po2_zone_no(dmh, dm_target_offset(ti, args->next_sector)) *
> +		dmh->zone_size;
> +
> +	return blkdev_report_zones(dmh->dev->bdev, sect, nr_zones,
> +				   dm_po2z_report_zones_cb, args);
> +}
> +
> +static int dm_po2z_end_io(struct dm_target *ti, struct bio *bio,
> +			  blk_status_t *error)
> +{
> +	if (bio->bi_status == BLK_STS_OK && bio_op(bio) == REQ_OP_ZONE_APPEND)
> +		bio->bi_iter.bi_sector =
> +			device_to_target_sect(ti, bio->bi_iter.bi_sector);
> +
> +	return DM_ENDIO_DONE;
> +}
> +
> +static void dm_po2z_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +
> +	limits->chunk_sectors = dmh->zone_size_po2;
> +}

Are you certain you shouldn't at least be exposing a different
logical_block_size to upper layers?

> +
> +static void dm_po2z_status(struct dm_target *ti, status_type_t type,
> +			   unsigned int status_flags, char *result,
> +			   unsigned int maxlen)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +	size_t sz = 0;
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		DMEMIT("%s %lld", dmh->dev->name,
> +		       (unsigned long long)dmh->zone_size_po2);
> +		break;

Wouldn't it be worthwhile to expose the zone sectors (native npo2 vs
simulated po2?) You merely roundup but never expose what you're using
(unless I'm missing something about generic "zoned" device
capabilities).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

