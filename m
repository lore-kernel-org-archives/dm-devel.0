Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F95C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 12:34:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-Jdgs9D7VOk2Qzkz7iY7amg-1; Tue, 17 May 2022 08:34:37 -0400
X-MC-Unique: Jdgs9D7VOk2Qzkz7iY7amg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B5293C11A08;
	Tue, 17 May 2022 12:34:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63D417B64;
	Tue, 17 May 2022 12:34:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 116A5194705F;
	Tue, 17 May 2022 12:34:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 163D81947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 12:34:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E289A1121319; Tue, 17 May 2022 12:34:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE9BF1121314
 for <dm-devel@redhat.com>; Tue, 17 May 2022 12:34:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C865D299E75D
 for <dm-devel@redhat.com>; Tue, 17 May 2022 12:34:32 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-BfsDggbBMnyHgT5n7tcNNA-1; Tue, 17 May 2022 08:34:28 -0400
X-MC-Unique: BfsDggbBMnyHgT5n7tcNNA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 4F01221CD1;
 Tue, 17 May 2022 12:34:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E47AA13305;
 Tue, 17 May 2022 12:34:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 8iC/NlKWg2KVFwAAMHmgww
 (envelope-from <dsterba@suse.cz>); Tue, 17 May 2022 12:34:26 +0000
Date: Tue, 17 May 2022 14:30:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220517123008.GC18596@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Pankaj Raghav <p.raghav@samsung.com>,
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 pankydev8@gmail.com, dsterba@suse.com, hch@lst.de,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, jiangbo.365@bytedance.com,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165428eucas1p1374b5f9592db3ca6a6551aff975537ce@eucas1p1.samsung.com>
 <20220516165416.171196-8-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220516165416.171196-8-p.raghav@samsung.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 07/13] btrfs: zoned: use generic btrfs
 zone helpers to support npo2 zoned devices
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
Reply-To: dsterba@suse.cz
Cc: axboe@kernel.dk, pankydev8@gmail.com, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com,
 hch@lst.de, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 16, 2022 at 06:54:10PM +0200, Pankaj Raghav wrote:
> Add helpers to calculate alignment, round up and round down
> for zoned devices. These helpers encapsulates the necessary handling for
> power_of_2 and non-power_of_2 zone sizes. Optimized calculations are
> performed for zone sizes that are power_of_2 with log and shifts.
> 
> btrfs_zoned_is_aligned() is added instead of reusing bdev_zone_aligned()
> helper due to some use cases in btrfs where zone alignment is checked
> before having access to the underlying block device such as in this
> function: btrfs_load_block_group_zone_info().
> 
> Use the generic btrfs zone helpers to calculate zone index, check zone
> alignment, round up and round down operations.
> 
> The zone_size_shift field is not needed anymore as generic helpers are
> used for calculation.

Overall this looks reasonable to me.

> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/btrfs/volumes.c | 24 +++++++++-------
>  fs/btrfs/zoned.c   | 72 ++++++++++++++++++++++------------------------
>  fs/btrfs/zoned.h   | 43 +++++++++++++++++++++++----
>  3 files changed, 85 insertions(+), 54 deletions(-)
> 
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1108,14 +1101,14 @@ int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
>  int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size)
>  {
>  	struct btrfs_zoned_device_info *zinfo = device->zone_info;
> -	const u8 shift = zinfo->zone_size_shift;
> -	unsigned long begin = start >> shift;
> -	unsigned long end = (start + size) >> shift;
> +	unsigned long begin = bdev_zone_no(device->bdev, start >> SECTOR_SHIFT);
> +	unsigned long end =
> +		bdev_zone_no(device->bdev, (start + size) >> SECTOR_SHIFT);

There are unsinged long types here though I'd rather see u64, better for
a separate patch. Fixed width types are cleaner here and in the zoned
code as there's always some conversion to/from sectors.

>  	u64 pos;
>  	int ret;
>  
> -	ASSERT(IS_ALIGNED(start, zinfo->zone_size));
> -	ASSERT(IS_ALIGNED(size, zinfo->zone_size));
> +	ASSERT(btrfs_zoned_is_aligned(start, zinfo->zone_size));
> +	ASSERT(btrfs_zoned_is_aligned(size, zinfo->zone_size));
>  
>  	if (end > zinfo->nr_zones)
>  		return -ERANGE;
> --- a/fs/btrfs/zoned.h
> +++ b/fs/btrfs/zoned.h
> @@ -30,6 +30,36 @@ struct btrfs_zoned_device_info {
>  	u32 sb_zone_location[BTRFS_SUPER_MIRROR_MAX];
>  };
>  
> +static inline bool btrfs_zoned_is_aligned(u64 pos, u64 zone_size)
> +{
> +	u64 remainder = 0;
> +
> +	if (is_power_of_two_u64(zone_size))
> +		return IS_ALIGNED(pos, zone_size);
> +
> +	div64_u64_rem(pos, zone_size, &remainder);
> +	return remainder == 0;
> +}
> +
> +static inline u64 btrfs_zoned_roundup(u64 pos, u64 zone_size)
> +{
> +	if (is_power_of_two_u64(zone_size))
> +		return ALIGN(pos, zone_size);

Please use round_up as the rounddown helper uses round_down

> +
> +	return div64_u64(pos + zone_size - 1, zone_size) * zone_size;
> +}
> +
> +static inline u64 btrfs_zoned_rounddown(u64 pos, u64 zone_size)
> +{
> +	u64 remainder = 0;
> +	if (is_power_of_two_u64(zone_size))
> +		return round_down(pos, zone_size);
> +
> +	div64_u64_rem(pos, zone_size, &remainder);
> +	pos -= remainder;
> +	return pos;
> +}
> +
>  #ifdef CONFIG_BLK_DEV_ZONED
>  int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
>  		       struct blk_zone *zone);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

