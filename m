Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228A91F791C
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 06:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747205306; cv=none; b=iQgis04cTVwdNehnj1WQs303jeEjBsDxtc6fk/NpQhLI6W+ULPotQCgG+VwVkz4WBHkganrD9UmnWOKCQD/lw/AFUquVI7K548XSlBm8Wm8uME0UJ/hla//Oa7Bqj0exB4Kl1AwaAu+MBrn1LHbTbpbNQnJar/hyWRC1m4VhJcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747205306; c=relaxed/simple;
	bh=qNSymnRe/EM6hXUuvpNROO4Xr/XcC9VXTixj1vfG2Kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h7hcQlPKeA+1qLpRGA97ja9E5Hl9fgudBWYJx8OEAMOR+en3ZPgu9Fh+B1g9/9emE2lMTFsvNiyTckZvnUPWbLCU4Nva3WWFv4B9oV5RVPXxhkIGozTJ6laB0YqX8u02grmdepGzVxLcoGKNsMumw+2OHHkqLekEnTmeiS+lQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOCYidnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOCYidnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E75C4CEE9;
	Wed, 14 May 2025 06:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747205305;
	bh=qNSymnRe/EM6hXUuvpNROO4Xr/XcC9VXTixj1vfG2Kc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KOCYidnAii8b67XyTBUvAyTWFYABDB/mgj7U1PIJG+leuMYdkwueu9cks3X+2uyaJ
	 vrzL2/Pc0lXn6uCJGz7y0+o3mEc7uT8WOCAs1Dk1S7AYqeGgutNN7NO5+8GlbAcJZx
	 EBL/JiKokwcVIy2qnMYCOie4XiJqiZ8IACO8fZQOLH6H99B/U6MfJ7knTPzeCvKESb
	 0kJaHdmomWd7X9w1uMRU1uINB0iJBROg4V9j9kayP+OpbngmUVtMZKXFDKAHv5vYxh
	 G2eZ/Dc4cMD19vgqvxr9lKG8q2cLI+/5weytov16w7tUK+6CCe7t5wbAZ9kjYG0Eaf
	 lLZOESdk95huA==
Message-ID: <4afed853-9c4d-487d-91be-509c6eb81939@kernel.org>
Date: Wed, 14 May 2025 15:48:21 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-zone: Use bdev_*() helper functions where applicable
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: dm-devel@lists.linux.dev, Pankaj Raghav <p.raghav@samsung.com>
References: <20250512231027.251751-1-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250512231027.251751-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/25 08:10, Bart Van Assche wrote:
> Improve code readability by using bdev_is_zone_start() and
> bdev_offset_from_zone_start() where applicable. No functionality
> has been changed.
> 
> This patch includes a subset of a patch from Pankaj Raghav.
> 
> See also https://lore.kernel.org/linux-block/20220923173618.6899-11-p.raghav@samsung.com/.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/md/dm-table.c | 4 ++--
>  drivers/md/dm-zone.c  | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 6b23e777e10e..4e2a5fe8986f 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -257,7 +257,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  	if (bdev_is_zoned(bdev)) {
>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>  
> -		if (start & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_start(bdev, start)) {
>  			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
>  			      dm_device_name(ti->table->md),
>  			      (unsigned long long)start,
> @@ -274,7 +274,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		 * devices do not end up with a smaller zone in the middle of
>  		 * the sector range.
>  		 */
> -		if (len & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_start(bdev, len)) {

This is odd. While the calculation is the same, this checks that the length is
zone aligned. Changing this to testing if length is a zone start sector makes it
hard to understand. So maybe add a synonym helper for that to avoid such odd
naming/code ? E.g.:

/*
 * Check if val is aligned to the device zone size.
 */
static inline bool bdev_is_zone_aligned(struct block_device *bdev, sector_t val)
{
	return bdev_is_zone_start(bdev, val);
}

Other than this, this looks good to me.

>  			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
>  			      dm_device_name(ti->table->md),
>  			      (unsigned long long)len,
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 20edd3fabbab..7e184ffba252 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -423,9 +423,9 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  	 */
>  	if (clone->bi_status == BLK_STS_OK &&
>  	    bio_op(clone) == REQ_OP_ZONE_APPEND) {
> -		sector_t mask = bdev_zone_sectors(disk->part0) - 1;
> -
> -		orig_bio->bi_iter.bi_sector += clone->bi_iter.bi_sector & mask;
> +		orig_bio->bi_iter.bi_sector +=
> +			bdev_offset_from_zone_start(disk->part0,
> +						    clone->bi_iter.bi_sector);
>  	}
>  
>  	return;
> 


-- 
Damien Le Moal
Western Digital Research
