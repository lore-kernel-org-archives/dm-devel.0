Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E50C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 12:47:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-1rM0ner6Pnu4F50PwGgV2A-1; Tue, 17 May 2022 08:47:24 -0400
X-MC-Unique: 1rM0ner6Pnu4F50PwGgV2A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A683A803D7C;
	Tue, 17 May 2022 12:47:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 58255492C14;
	Tue, 17 May 2022 12:47:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F04D9194705F;
	Tue, 17 May 2022 12:47:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 684491947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 12:47:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C38740C1421; Tue, 17 May 2022 12:47:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 389B1400E114
 for <dm-devel@redhat.com>; Tue, 17 May 2022 12:47:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1826A384F805
 for <dm-devel@redhat.com>; Tue, 17 May 2022 12:47:20 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-dzTwbWrENS2fFUv7GLnGPw-1; Tue, 17 May 2022 08:47:17 -0400
X-MC-Unique: dzTwbWrENS2fFUv7GLnGPw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 441B71F8B9;
 Tue, 17 May 2022 12:47:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D82C413305;
 Tue, 17 May 2022 12:47:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id x6q+M1OZg2KuHgAAMHmgww
 (envelope-from <dsterba@suse.cz>); Tue, 17 May 2022 12:47:15 +0000
Date: Tue, 17 May 2022 14:42:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220517124257.GD18596@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Pankaj Raghav <p.raghav@samsung.com>,
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 pankydev8@gmail.com, dsterba@suse.com, hch@lst.de,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, jiangbo.365@bytedance.com,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220516165416.171196-9-p.raghav@samsung.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone
 devices align with sb log offsets
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
 dm-devel@redhat.com, dsterba@suse.com, hch@lst.de, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 16, 2022 at 06:54:11PM +0200, Pankaj Raghav wrote:
> Superblocks for zoned devices are fixed as 2 zones at 0, 512GB and 4TB.
> These are fixed at these locations so that recovery tools can reliably
> retrieve the superblocks even if one of the mirror gets corrupted.
> 
> power of 2 zone sizes align at these offsets irrespective of their
> value but non power of 2 zone sizes will not align.
> 
> To make sure the first zone at mirror 1 and mirror 2 align, write zero
> operation is performed to move the write pointer of the first zone to
> the expected offset. This operation is performed only after a zone reset
> of the first zone, i.e., when the second zone that contains the sb is FULL.

Is it a good idea to do the "write zeros", instead of a plain "set write
pointer"? I assume setting write pointer is instant, while writing
potentially hundreds of megabytes may take significiant time. As the
functions may be called from random contexts, the increased time may
become a problem.

> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/btrfs/zoned.c | 68 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 63 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 3023c871e..805aeaa76 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -760,11 +760,44 @@ int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info)
>  	return 0;
>  }
>  
> +static int fill_sb_wp_offset(struct block_device *bdev, struct blk_zone *zone,
> +			     int mirror, u64 *wp_ret)
> +{
> +	u64 offset = 0;
> +	int ret = 0;
> +
> +	ASSERT(!is_power_of_two_u64(zone->len));
> +	ASSERT(zone->wp == zone->start);
> +	ASSERT(mirror != 0);

This could simply accept 0 as the mirror offset too, the calculation is
trivial.

> +
> +	switch (mirror) {
> +	case 1:
> +		div64_u64_rem(BTRFS_SB_LOG_FIRST_OFFSET >> SECTOR_SHIFT,
> +			      zone->len, &offset);
> +		break;
> +	case 2:
> +		div64_u64_rem(BTRFS_SB_LOG_SECOND_OFFSET >> SECTOR_SHIFT,
> +			      zone->len, &offset);
> +		break;
> +	}
> +
> +	ret =  blkdev_issue_zeroout(bdev, zone->start, offset, GFP_NOFS, 0);
> +	if (ret)
> +		return ret;
> +
> +	zone->wp += offset;
> +	zone->cond = BLK_ZONE_COND_IMP_OPEN;
> +	*wp_ret = zone->wp << SECTOR_SHIFT;
> +
> +	return 0;
> +}
> +
>  static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
> -			   int rw, u64 *bytenr_ret)
> +			   int rw, int mirror, u64 *bytenr_ret)
>  {
>  	u64 wp;
>  	int ret;
> +	bool zones_empty = false;
>  
>  	if (zones[0].type == BLK_ZONE_TYPE_CONVENTIONAL) {
>  		*bytenr_ret = zones[0].start << SECTOR_SHIFT;
> @@ -775,13 +808,31 @@ static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
>  	if (ret != -ENOENT && ret < 0)
>  		return ret;
>  
> +	if (ret == -ENOENT)
> +		zones_empty = true;
> +
>  	if (rw == WRITE) {
>  		struct blk_zone *reset = NULL;
> +		bool is_sb_offset_write_req = false;
> +		u32 reset_zone_nr = -1;
>  
> -		if (wp == zones[0].start << SECTOR_SHIFT)
> +		if (wp == zones[0].start << SECTOR_SHIFT) {
>  			reset = &zones[0];
> -		else if (wp == zones[1].start << SECTOR_SHIFT)
> +			reset_zone_nr = 0;
> +		} else if (wp == zones[1].start << SECTOR_SHIFT) {
>  			reset = &zones[1];
> +			reset_zone_nr = 1;
> +		}
> +
> +		/*
> +		 * Non po2 zone sizes will not align naturally at
> +		 * mirror 1 (512GB) and mirror 2 (4TB). The wp of the
> +		 * 1st zone in those superblock mirrors need to be
> +		 * moved to align at those offsets.
> +		 */

Please move this comment to the helper fill_sb_wp_offset itself, there
it's more discoverable.

> +		is_sb_offset_write_req =
> +			(zones_empty || (reset_zone_nr == 0)) && mirror &&
> +			!is_power_of_2(zones[0].len);

Accepting 0 as the mirror number would also get rid of this wild
expression substituting and 'if'.

>  
>  		if (reset && reset->cond != BLK_ZONE_COND_EMPTY) {
>  			ASSERT(sb_zone_is_full(reset));
> @@ -795,6 +846,13 @@ static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
>  			reset->cond = BLK_ZONE_COND_EMPTY;
>  			reset->wp = reset->start;
>  		}
> +
> +		if (is_sb_offset_write_req) {

And get rid of the conditional. The point of supporting both po2 and
nonpo2 is to hide any implementation details to wrappers as much as
possible.

> +			ret = fill_sb_wp_offset(bdev, &zones[0], mirror, &wp);
> +			if (ret)
> +				return ret;
> +		}
> +
>  	} else if (ret != -ENOENT) {
>  		/*
>  		 * For READ, we want the previous one. Move write pointer to

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

