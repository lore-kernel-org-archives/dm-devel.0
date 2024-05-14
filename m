Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689381EB2B
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 07:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715672366; cv=none; b=RRq0injYJlRlRt+USABvrYuaPw48ZeYuAzS68hpisnPiaXSrzyx5X063sAG8+otiGUtCKlde+IYgPOu1YZZA5tvf/ud3J6/LrDQLyVUlvJ0s01Szm2UBfK9pLW5OjpbXEeSicW5iJ+576rKxfyLGq/KbMM9MPuNMdF3KuirYk90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715672366; c=relaxed/simple;
	bh=/zbNmJnrBYof+TFZ1f9IC1pLr1xpwQrseSt/5531pW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TDsJJEYMN0TnaC9jcgVrRGrvfPGVjF/uXAzZp4c5wfyLjVuDh9oxho63A0rONkrFlanmOyCOTIvm8IMH8tM88PiKdBoXYFq8hlit43SzCeLaV3+UJiErYgcN55jDl8BI/9vgLp9JSyA8sAPD7xmnf+5XiU/xl3HvVHc5BpM7CaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KNTti/Rb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNTti/Rb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715672363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rCyrSqY6tNdEEVYrLErxV8jAv56KZFmfGB/kOU6LsTE=;
	b=KNTti/RbHiwVQFV8vZGfnfraGgk1MJRYKgUiUVqgBw7IYU8OS9R4oD0XJpFEDv/5pSGO5+
	bLTY055x6tNgHdAOWqAYk1KDc6I0me3irrPqDtAQ6XIzWm7eFFuzLaHnMDyrcr3M67e/C7
	rsLwGWkFlyL6RBnArm+49A82H5fp6GE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-aFFh9axqP9evKjC_viTaEA-1; Tue, 14 May 2024 03:28:03 -0400
X-MC-Unique: aFFh9axqP9evKjC_viTaEA-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so5343340a12.1
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 00:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715671682; x=1716276482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rCyrSqY6tNdEEVYrLErxV8jAv56KZFmfGB/kOU6LsTE=;
        b=nrTQYfmuaLcdIV1TQyEUt6drGSOv9K9ORstpxdGzY+XmuZK0k7kGToiObas7zWkhtF
         xDmKfLIU1Vrwq6UcsBrM+u24WQkuvspwajRGpH64VCWPE8uwj5UVyNsoDuB94qTids1M
         HieUYJjwYL2Kvc681swo+WeDbqbFQhUGF6vhi9J++/0maFHYrTRCa5ss2QBxuu7V9loT
         HXaV+8SipIO9c2dL6BhVMfPNJZyYFQGlAKZBgBytHSnAytwogYqk9ouOC4WP9bFtXjH3
         ndBBfjidsLfsosI2r9MzcavVXFv0YEeilpv6dp/W8BZwlhYwgAR2CTXPnurNvcD3UtJ2
         P09w==
X-Gm-Message-State: AOJu0YyCJcNOHERYcmTyNuDtOUCGolQ+AoKjsHQFwz5kstM9Ka04tfNe
	Y27opMXLwwEcyulO8anJ2dy5y7w/eyZhxYKz5DNPvCegLuRPPR2XwLduzIY1OwyJ/Ilsh/mOcws
	asB7KsPfN0Tc/p4Uom5rDim1TSb9I4ytH0PmX/65sgkGWnJCG7819vaV7
X-Received: by 2002:a05:6a21:6802:b0:1af:9321:8ac3 with SMTP id adf61e73a8af0-1afde10debemr11738097637.36.1715671681839;
        Tue, 14 May 2024 00:28:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHra1DAm/uRiLAzU5PNgm685JCcjDtOry36q06hMMN8aWCTMkQTvupLI92LgQ6KHGdt3jGnDw==
X-Received: by 2002:a05:6a21:6802:b0:1af:9321:8ac3 with SMTP id adf61e73a8af0-1afde10debemr11738075637.36.1715671681472;
        Tue, 14 May 2024 00:28:01 -0700 (PDT)
Received: from [10.72.120.5] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b62863cd9dsm10903410a91.12.2024.05.14.00.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 00:28:01 -0700 (PDT)
Message-ID: <5a1ff1a3-3197-40b4-8b9c-f2ec567ff24e@redhat.com>
Date: Tue, 14 May 2024 15:27:56 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.10 8/9] md: factor out helpers for different
 sync_action in md_do_sync()
To: Yu Kuai <yukuai1@huaweicloud.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-9-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20240509011900.2694291-9-yukuai1@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/5/9 上午9:18, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Make code cleaner by replace if else if with switch, and it's more
> obvious now what is doning for each sync_action. There are no

Hi Kuai

type error s/doning/doing/g

Regards

Xiao

> functional changes.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 123 ++++++++++++++++++++++++++++--------------------
>   1 file changed, 73 insertions(+), 50 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2fc81175b46b..42db128b82d9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8928,6 +8928,77 @@ void md_allow_write(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL_GPL(md_allow_write);
>   
> +static sector_t md_sync_max_sectors(struct mddev *mddev,
> +				    enum sync_action action)
> +{
> +	switch (action) {
> +	case ACTION_RESYNC:
> +	case ACTION_CHECK:
> +	case ACTION_REPAIR:
> +		atomic64_set(&mddev->resync_mismatches, 0);
> +		fallthrough;
> +	case ACTION_RESHAPE:
> +		return mddev->resync_max_sectors;
> +	case ACTION_RECOVER:
> +		return mddev->dev_sectors;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
> +{
> +	sector_t start = 0;
> +	struct md_rdev *rdev;
> +
> +	switch (action) {
> +	case ACTION_CHECK:
> +	case ACTION_REPAIR:
> +		return mddev->resync_min;
> +	case ACTION_RESYNC:
> +		if (!mddev->bitmap)
> +			return mddev->recovery_cp;
> +		return 0;
> +	case ACTION_RESHAPE:
> +		/*
> +		 * If the original node aborts reshaping then we continue the
> +		 * reshaping, so set again to avoid restart reshape from the
> +		 * first beginning
> +		 */
> +		if (mddev_is_clustered(mddev) &&
> +		    mddev->reshape_position != MaxSector)
> +			return mddev->reshape_position;
> +		return 0;
> +	case ACTION_RECOVER:
> +		start = MaxSector;
> +		rcu_read_lock();
> +		rdev_for_each_rcu(rdev, mddev)
> +			if (rdev->raid_disk >= 0 &&
> +			    !test_bit(Journal, &rdev->flags) &&
> +			    !test_bit(Faulty, &rdev->flags) &&
> +			    !test_bit(In_sync, &rdev->flags) &&
> +			    rdev->recovery_offset < start)
> +				start = rdev->recovery_offset;
> +		rcu_read_unlock();
> +
> +		/* If there is a bitmap, we need to make sure all
> +		 * writes that started before we added a spare
> +		 * complete before we start doing a recovery.
> +		 * Otherwise the write might complete and (via
> +		 * bitmap_endwrite) set a bit in the bitmap after the
> +		 * recovery has checked that bit and skipped that
> +		 * region.
> +		 */
> +		if (mddev->bitmap) {
> +			mddev->pers->quiesce(mddev, 1);
> +			mddev->pers->quiesce(mddev, 0);
> +		}
> +		return start;
> +	default:
> +		return MaxSector;
> +	}
> +}
> +
>   #define SYNC_MARKS	10
>   #define	SYNC_MARK_STEP	(3*HZ)
>   #define UPDATE_FREQUENCY (5*60*HZ)
> @@ -9046,56 +9117,8 @@ void md_do_sync(struct md_thread *thread)
>   		spin_unlock(&all_mddevs_lock);
>   	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
>   
> -	j = 0;
> -	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> -		/* resync follows the size requested by the personality,
> -		 * which defaults to physical size, but can be virtual size
> -		 */
> -		max_sectors = mddev->resync_max_sectors;
> -		atomic64_set(&mddev->resync_mismatches, 0);
> -		/* we don't use the checkpoint if there's a bitmap */
> -		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> -			j = mddev->resync_min;
> -		else if (!mddev->bitmap)
> -			j = mddev->recovery_cp;
> -
> -	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
> -		max_sectors = mddev->resync_max_sectors;
> -		/*
> -		 * If the original node aborts reshaping then we continue the
> -		 * reshaping, so set j again to avoid restart reshape from the
> -		 * first beginning
> -		 */
> -		if (mddev_is_clustered(mddev) &&
> -		    mddev->reshape_position != MaxSector)
> -			j = mddev->reshape_position;
> -	} else {
> -		/* recovery follows the physical size of devices */
> -		max_sectors = mddev->dev_sectors;
> -		j = MaxSector;
> -		rcu_read_lock();
> -		rdev_for_each_rcu(rdev, mddev)
> -			if (rdev->raid_disk >= 0 &&
> -			    !test_bit(Journal, &rdev->flags) &&
> -			    !test_bit(Faulty, &rdev->flags) &&
> -			    !test_bit(In_sync, &rdev->flags) &&
> -			    rdev->recovery_offset < j)
> -				j = rdev->recovery_offset;
> -		rcu_read_unlock();
> -
> -		/* If there is a bitmap, we need to make sure all
> -		 * writes that started before we added a spare
> -		 * complete before we start doing a recovery.
> -		 * Otherwise the write might complete and (via
> -		 * bitmap_endwrite) set a bit in the bitmap after the
> -		 * recovery has checked that bit and skipped that
> -		 * region.
> -		 */
> -		if (mddev->bitmap) {
> -			mddev->pers->quiesce(mddev, 1);
> -			mddev->pers->quiesce(mddev, 0);
> -		}
> -	}
> +	max_sectors = md_sync_max_sectors(mddev, action);
> +	j = md_sync_position(mddev, action);
>   
>   	pr_info("md: %s of RAID array %s\n", desc, mdname(mddev));
>   	pr_debug("md: minimum _guaranteed_  speed: %d KB/sec/disk.\n", speed_min(mddev));

