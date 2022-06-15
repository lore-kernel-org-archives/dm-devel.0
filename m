Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB735C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 11:50:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-_JDVHWN9Pg-5n2F_UfMZzg-1; Wed, 15 Jun 2022 07:50:03 -0400
X-MC-Unique: _JDVHWN9Pg-5n2F_UfMZzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CAD6802D1C;
	Wed, 15 Jun 2022 11:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 145991678F;
	Wed, 15 Jun 2022 11:50:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7DB81947040;
	Wed, 15 Jun 2022 11:50:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB20919466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 11:49:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 936161131D; Wed, 15 Jun 2022 11:49:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E02A111F5
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:49:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D89E3AF42A3
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:49:58 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-2SetODPTNnuJRmEE5nFUiQ-1; Wed, 15 Jun 2022 07:49:56 -0400
X-MC-Unique: 2SetODPTNnuJRmEE5nFUiQ-1
X-IronPort-AV: E=Sophos;i="5.91,302,1647273600"; d="scan'208";a="201930740"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 15 Jun 2022 19:49:55 +0800
IronPort-SDR: 7jIMLqzvNg1oTq53Ov7uk3j9JySe3Vwyl9yo34CQfhCCq9Bx449PaZK5luX/k0tIYM3Z3Y6JPa
 5fFwaxZS1HAWx8wDpMAsRz7jI1TcNZrMbbqCmHvABqb35RvvrrFe1YpsP6KBOqBmVE02Q6atz+
 cyqnynTs+S9d/x9v5MDeXVZXWkpbpgGbiMvFtY39sYONIs7PJDLfWxTf9ekXVxKCxCGvQZ+GYg
 ZDUszGovI904jfRe1irYw41Kdep5At1aJGtJfDfqfW+hGfjoFZIXxDe4FPUjkULxqXJ5T9sCjS
 M1XfilneS9XWN0lJ7XFLRvH1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:08:19 -0700
IronPort-SDR: Gy4gpJdh34q+twy1ZyxdCenGd1Oeqv/o38aMNOj9EX4bIaUinKTDPNgAlAt/1gqBQZYwJ5R3hS
 bm7Db6NpflCAaEA8YdvNfAYz3CW9auAffFEv4ZwvT1lh2tO5XB3peZIi/jizb4zQkaqAB+pvZZ
 f+zEYfiLPEN7BMuFGm7vBc0uVjsHrdkL26eIa1fMxH54q1KB/V2qUBHAUXnSrLDJ7wuFbR8ez1
 4bjpi7sWhN3FU8BhSl5lbfITYEwR+33PmW38kNSJ1by3+RukRPNuijCtNh6mGUyBnNoGHJyQBC
 PeE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:49:56 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LNNry2dpLz1SVny
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 04:49:54 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id antYttLtVd6R for <dm-devel@redhat.com>;
 Wed, 15 Jun 2022 04:49:50 -0700 (PDT)
Received: from [10.225.163.82] (unknown [10.225.163.82])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LNNrr1LdFz1Rvlc;
 Wed, 15 Jun 2022 04:49:47 -0700 (PDT)
Message-ID: <63b0cfb6-eb24-f058-e502-2637039c5a98@opensource.wdc.com>
Date: Wed, 15 Jun 2022 20:49:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102011eucas1p220368db4a186181b1927dea50a79e5d4@eucas1p2.samsung.com>
 <20220615101920.329421-14-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220615101920.329421-14-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v7 13/13] dm: add non power of 2 zoned target
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/15/22 19:19, Pankaj Raghav wrote:
> Only power of 2(po2) zoned devices were supported in linux but now non
> power of 2(npo2) zoned device support has been added to the block layer.
> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zoned
> devices, it was suggested to create a dm target for npo2 zoned device to
> appear as po2 device so that file systems can initially work without any
> explicit changes by using this target.
> 
> The design of this target is very simple: introduce gaps between the zone
> capacity and the po2 zone size of the underlying device. All IOs will be
> remapped from target to the actual device location. For devices that use
> zone append, the bi_sector is remapped from device to target's layout.

Nothing special for zone append in this respect. All IOs are remapped
likewise, right ?

> 
> The read IOs that fall in the "emulated" gap area will return 0 and all
> the other IOs in that area will result in an error. If an read IO span
> across the zone capacity boundary, then the IOs are split between the
> boundary. All other IO operations that span across a zone capacity
> boundary will result in an error.
> 
> The target can be easily updated as follows:

Updated ? you mean created, no ?

> dmsetup create <label> --table '0 <size_sects> zoned-npo2 /dev/nvme<id>'
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/Kconfig                |   9 +
>  drivers/md/Makefile               |   2 +
>  drivers/md/dm-zone.c              |   9 +
>  drivers/md/dm-zoned-npo2-target.c | 268 ++++++++++++++++++++++++++++++
>  4 files changed, 288 insertions(+)
>  create mode 100644 drivers/md/dm-zoned-npo2-target.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 998a5cfdb..773314536 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -518,6 +518,15 @@ config DM_FLAKEY
>  	help
>  	 A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_ZONED_NPO2
> +	tristate "Zoned non power of 2 target"
> +	depends on BLK_DEV_DM
> +	depends on BLK_DEV_ZONED
> +	help
> +	A target that converts a zoned device with non power of 2 zone size to
> +	be power of 2. This is done by introducing gaps in between the zone
> +	capacity and the power of 2 zone size.
> +
>  config DM_VERITY
>  	tristate "Verity target support"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 0454b0885..2863a94a7 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -26,6 +26,7 @@ dm-era-y	+= dm-era-target.o
>  dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
>  dm-verity-y	+= dm-verity-target.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
> +dm-zoned-npo2-y       += dm-zoned-npo2-target.o

This naming is in my opinion very bad as it seems related to the dm-zoned
target. e.g. dm-po2z, dm-zp2, etc.

>  
>  md-mod-y	+= md.o md-bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
> @@ -60,6 +61,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> +obj-$(CONFIG_DM_ZONED_NPO2)	+= dm-zoned-npo2.o
>  obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
>  obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
>  obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index af36d33f9..5efb31ba0 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -210,6 +210,11 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>  		}
>  		md->zwp_offset[idx] = dm_get_zone_wp_offset(zone);
>  
> +		if (q->limits.chunk_sectors != zone->len) {

Why is this if needed ?

> +			blk_queue_chunk_sectors(q, zone->len);
> +			q->nr_zones = blkdev_nr_zones(md->disk);
> +		}
> +
>  		break;
>  	default:
>  		DMERR("Invalid zone type 0x%x at sectors %llu",
> @@ -307,6 +312,9 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	if (dm_table_supports_zone_append(t)) {
>  		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
>  		dm_cleanup_zoned_dev(md);
> +

no need for the blank line.

> +		if (!is_power_of_2(blk_queue_zone_sectors(q)))
> +			goto revalidate_zones;
>  		return 0;
>  	}

Why do you need to change dm_set_zones_restrictions() at all ?

>  
> @@ -318,6 +326,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	if (!get_capacity(md->disk))
>  		return 0;
>  
> +revalidate_zones:
>  	return dm_revalidate_zones(md, t);
>  }
>  
> diff --git a/drivers/md/dm-zoned-npo2-target.c b/drivers/md/dm-zoned-npo2-target.c
> new file mode 100644
> index 000000000..c1373d3ea
> --- /dev/null
> +++ b/drivers/md/dm-zoned-npo2-target.c
> @@ -0,0 +1,268 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/device-mapper.h>
> +
> +#define DM_MSG_PREFIX "zoned-npo2"
> +
> +struct dmz_npo2_target {
> +	struct dm_dev *dev;
> +	sector_t zsze;
> +	sector_t zsze_po2;
> +	sector_t zsze_diff;

zsze ? is that zone size ? Spell this out please. This is not nvme.

> +	u32 nr_zones;
> +};
> +
> +enum dmz_npo2_io_cond {
> +	DMZ_NPO2_IO_INSIDE_ZONE,
> +	DMZ_NPO2_IO_ACROSS_ZONE,
> +	DMZ_NPO2_IO_OUTSIDE_ZONE,
> +};
> +
> +static inline u32 npo2_zone_no(struct dmz_npo2_target *dmh, sector_t sect)
> +{
> +	return div64_u64(sect, dmh->zsze);
> +}
> +
> +static inline u32 po2_zone_no(struct dmz_npo2_target *dmh, sector_t sect)
> +{
> +	return sect >> ilog2(dmh->zsze_po2);
> +}
> +
> +static inline sector_t target_to_device_sect(struct dmz_npo2_target *dmh,
> +					     sector_t sect)
> +{
> +	u32 zone_idx = po2_zone_no(dmh, sect);
> +
> +	sect -= (zone_idx * dmh->zsze_diff);

	return sect - (po2_zone_no(dmh, sect) * dmh->zsze_diff);
> +
> +	return sect;
> +}
> +
> +static inline sector_t device_to_target_sect(struct dmz_npo2_target *dmh,
> +					     sector_t sect)
> +{
> +	u32 zone_idx = npo2_zone_no(dmh, sect);
> +
> +	sect += (zone_idx * dmh->zsze_diff);

see above. Simplify.

> +
> +	return sect;
> +}
> +
> +/*
> + * <dev-path>

What is this above line intended meaning ?

> + * This target works on the complete zoned device. Partial mapping is not
> + * supported
> + */
> +static int dmz_npo2_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct dmz_npo2_target *dmh = NULL;
> +	int ret = 0;
> +	sector_t zsze;
> +	sector_t disk_size;
> +
> +	if (argc < 1)
> +		return -EINVAL;
> +
> +	dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
> +	if (!dmh)
> +		return -ENOMEM;
> +
> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
> +			    &dmh->dev);

No error check ?

> +
> +	zsze = blk_queue_zone_sectors(bdev_get_queue(dmh->dev->bdev));
> +
> +	disk_size = get_capacity(dmh->dev->bdev->bd_disk);

s/disk_size/dev_capacity

> +
> +	if (ti->len != disk_size || ti->begin) {
> +		DMERR("%pg Partial mapping of the target not supported",

missing a verb ("is not...")

> +		      dmh->dev->bdev);
> +		return -EINVAL;
> +	}
> +
> +	if (is_power_of_2(zsze)) {
> +		DMERR("%pg zone size is power of 2", dmh->dev->bdev);

Hmmm... You would end up with no remapping needed so it would still
work... Why error this ? A warning would work too.

> +		return -EINVAL;
> +	}
> +
> +	dmh->zsze = zsze;
> +	dmh->zsze_po2 = 1 << get_count_order_long(zsze);
> +	dmh->zsze_diff = dmh->zsze_po2 - dmh->zsze;
> +
> +	ti->private = dmh;
> +	ti->num_flush_bios = 1;
> +	ti->num_discard_bios = 1;
> +	ti->num_secure_erase_bios = 1;
> +	ti->num_write_zeroes_bios = 1;

Why all these ? I know dm-linear do that but I do not see why they would
be necessary for a single device target.

> +
> +	dmh->nr_zones = npo2_zone_no(dmh, ti->len);
> +	ti->len = dmh->zsze_po2 * dmh->nr_zones;
> +
> +	return 0;
> +}
> +
> +static int dmz_npo2_report_zones_cb(struct blk_zone *zone, unsigned int idx,
> +				    void *data)
> +{
> +	struct dm_report_zones_args *args = data;
> +	struct dmz_npo2_target *dmh = args->tgt->private;
> +
> +	zone->start = device_to_target_sect(dmh, zone->start);
> +	zone->wp = device_to_target_sect(dmh, zone->wp);
> +	zone->len = dmh->zsze_po2;
> +	args->next_sector = zone->start + zone->len;
> +
> +	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
> +}
> +
> +static int dmz_npo2_report_zones(struct dm_target *ti,
> +				 struct dm_report_zones_args *args,
> +				 unsigned int nr_zones)
> +{
> +	struct dmz_npo2_target *dmh = ti->private;
> +	int ret = 0;

no need for the = 0. No need for ret at all in fact.

> +	sector_t sect = po2_zone_no(dmh, args->next_sector) * dmh->zsze;
> +
> +	ret = blkdev_report_zones(dmh->dev->bdev, sect, nr_zones,
> +				  dmz_npo2_report_zones_cb, args);
> +	if (ret < 0)
> +		DMERR("report zones error");

Not useful. just "return blkdev_report_zones();"

> +
> +	return ret;
> +}
> +
> +static int check_zone_boundary_violation(struct dmz_npo2_target *dmh,
> +					 sector_t sect, sector_t size)
> +{
> +	u32 zone_idx = po2_zone_no(dmh, sect);
> +	sector_t relative_sect = 0;

No need for "= 0".

> +
> +	sect = target_to_device_sect(dmh, sect);
> +	relative_sect = sect - (zone_idx * dmh->zsze);

ofst_in_zone ? or sect_osft ?

> +
> +	if ((relative_sect + size) <= dmh->zsze)

no need for the inner brackets.

> +		return DMZ_NPO2_IO_INSIDE_ZONE;
> +	else if (relative_sect >= dmh->zsze)

no need for the else. And this is super confusing. This case correspond to
the BIO going beyond the zone capacity in the target address space,
meaning it is still WITHIN the target zone. But you call that "outside"
because it is for the device zone. Super confusing. It took me a lot of
rereading to finally get it.

> +		return DMZ_NPO2_IO_OUTSIDE_ZONE;
> +
> +	return DMZ_NPO2_IO_ACROSS_ZONE;

So you BIO is eeither fully contained within the zone or it is not. So why
not just return a bool ?

> +}
> +
> +static void split_io_across_zone_boundary(struct dmz_npo2_target *dmh,
> +					  struct bio *bio)
> +{
> +	sector_t sect = bio->bi_iter.bi_sector;
> +	sector_t sects_from_zone_start;
> +
> +	sect = target_to_device_sect(dmh, sect);

	sect = target_to_device_sect(dmh, bio->bi_iter.bi_sector);

is more readable.

> +	div64_u64_rem(sect, dmh->zsze, &sects_from_zone_start);
> +	dm_accept_partial_bio(bio, dmh->zsze - sects_from_zone_start);

So if this is a read BIO starting exactly at the target zone capacity
(sects_from_zone_start == zsze), then you accept 0 sectors ? What am I
missing here ?

> +	bio->bi_iter.bi_sector = sect;
> +}
> +
> +static int handle_zone_boundary_violation(struct dmz_npo2_target *dmh,
> +					  struct bio *bio,
> +					  enum dmz_npo2_io_cond cond)
> +{
> +	/* Read should return zeroed page */
> +	if (bio_op(bio) == REQ_OP_READ) {
> +		if (cond == DMZ_NPO2_IO_ACROSS_ZONE) {
> +			split_io_across_zone_boundary(dmh, bio);
> +			return DM_MAPIO_REMAPPED;
> +		}
> +		zero_fill_bio(bio);
> +		bio_endio(bio);
> +		return DM_MAPIO_SUBMITTED;
> +	}
> +	return DM_MAPIO_KILL;
> +}
> +
> +static int dmz_npo2_end_io(struct dm_target *ti, struct bio *bio,
> +			   blk_status_t *error)
> +{
> +	struct dmz_npo2_target *dmh = ti->private;
> +
> +	if (bio->bi_status == BLK_STS_OK && bio_op(bio) == REQ_OP_ZONE_APPEND)
> +		bio->bi_iter.bi_sector =
> +			device_to_target_sect(dmh, bio->bi_iter.bi_sector);
> +
> +	return DM_ENDIO_DONE;
> +}
> +
> +static int dmz_npo2_map(struct dm_target *ti, struct bio *bio)
> +{
> +	struct dmz_npo2_target *dmh = ti->private;
> +	enum dmz_npo2_io_cond cond;
> +
> +	bio_set_dev(bio, dmh->dev->bdev);
> +	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
> +		cond = check_zone_boundary_violation(dmh, bio->bi_iter.bi_sector,
> +						     bio->bi_iter.bi_size >> SECTOR_SHIFT);

Why check this for zone management BIOs ? These have length = 0, always.

> +
> +		/*
> +		 * If the starting sector is in the emulated area then fill
> +		 * all the bio with zeros. If bio is across boundaries,
> +		 * split the bio across boundaries and fill zeros only for the
> +		 * bio that is outside the zone capacity
> +		 */
> +		switch (cond) {
> +		case DMZ_NPO2_IO_INSIDE_ZONE:
> +			bio->bi_iter.bi_sector = target_to_device_sect(dmh,
> +								       bio->bi_iter.bi_sector);
> +			break;
> +		case DMZ_NPO2_IO_ACROSS_ZONE:
> +		case DMZ_NPO2_IO_OUTSIDE_ZONE:
> +			return handle_zone_boundary_violation(dmh, bio, cond);
> +		}
> +	}
> +	return DM_MAPIO_REMAPPED;

This entire function is very hard to read because everything is hidden in
helpers that are not super useful in my opinion. I would prefer seeing
cases for:
* zone management BIOs
* Reads and writes
* Everything else

where tests against the bio sector and length are visible, so one can
understand what is going on. If you need helpers, have handle_zone_mgmt(),
handle_read() etc. Something clear.

> +}
> +
> +static int dmz_npo2_iterate_devices(struct dm_target *ti,
> +				    iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dmz_npo2_target *dmh = ti->private;
> +	sector_t len = 0;
> +
> +	len = dmh->nr_zones * dmh->zsze;

Move this to the declaration instead of setting len to 0 for nothing.

> +	return fn(ti, dmh->dev, 0, len, data);
> +}
> +
> +static struct target_type dmz_npo2_target = {
> +	.name = "zoned-npo2",
> +	.version = { 1, 0, 0 },
> +	.features = DM_TARGET_ZONED_HM,
> +	.map = dmz_npo2_map,
> +	.end_io = dmz_npo2_end_io,
> +	.report_zones = dmz_npo2_report_zones,
> +	.iterate_devices = dmz_npo2_iterate_devices,
> +	.module = THIS_MODULE,
> +	.ctr = dmz_npo2_ctr,
> +};
> +
> +static int __init dmz_npo2_init(void)
> +{
> +	int r = dm_register_target(&dmz_npo2_target);
> +
> +	if (r < 0)
> +		DMERR("register failed %d", r);
> +
> +	return r;
> +}
> +
> +static void __exit dmz_npo2_exit(void)
> +{
> +	dm_unregister_target(&dmz_npo2_target);
> +}
> +
> +/* Module hooks */
> +module_init(dmz_npo2_init);
> +module_exit(dmz_npo2_exit);
> +
> +MODULE_DESCRIPTION(DM_NAME " non power 2 zoned target");
> +MODULE_AUTHOR("Pankaj Raghav <p.raghav@samsung.com>");
> +MODULE_LICENSE("GPL");
> +


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

