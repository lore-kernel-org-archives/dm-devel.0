Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454B150295;
	Wed,  1 May 2024 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554892; cv=none; b=iLBHjOWD0N9CmZYjhnemh5SKUGT5rFOW8oXPCb1iZLq4SL1C/+uRtM/3Oesi8i5srKJc3gI5+muY8giWrBlkIG8RSFSJf+FDMomx1RrQzLHC0tyYCq3nACt5GIUdVvQxeguhOOFr4qQgBqJ/laLgvbXOqYmr+nKfFFG/El36JVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554892; c=relaxed/simple;
	bh=rCviM45bUQHCE9Hyo7/+UvbUfQmMgk9qtciStd6Ak0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvhaiQmWzVquhJttEmmOeQk+hy/vqsc/Q0b8gcwP+Z5qgzQdb3RKLudPTDDPJRwApBrjuB+xCKDQsa/B4CJrUzfhIwbgqIAYA+NdiGCxzJ4TWbNy/vEAHQsZ60Am9RHe2lHZW6eTmH8BoFXRzzilS2uHnK828GukZQiFwLB3Zyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UwJJS0qX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwJJS0qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89FFC113CC;
	Wed,  1 May 2024 09:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714554891;
	bh=rCviM45bUQHCE9Hyo7/+UvbUfQmMgk9qtciStd6Ak0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UwJJS0qX2i+0NSp8C1PviBLjtIIbTDKjZMDw1MIDpwtbY1VwZeuZgv7eUj6BPgN2G
	 TY7208aebFEV39azGFxzbEQ/ReoRtEP0B3JT+dGRW+GR23og7Bi1Xza2AT5JeWCs7w
	 kqrG+4hUuYCfrd4Q+8T4DU7chieM0Pg8WN+TG+0R7lBgBTLIvV9+ed3QOWZK5Xbh1m
	 P5aATNxK9EWJbT8eqKu4pS+76SM4Zz2Nz2qCcUXST5XmbtIitMmaD42d6sUuYsj7CK
	 UWZEfjdlJGv/nxKMxfXr4iYC+aZwwgW00rhbKtYObSpaItESa2q/y2yGThpljjsx1p
	 EPP+JIjX0kpZg==
Message-ID: <49325aa0-4e24-4dc3-9177-917044b94b41@kernel.org>
Date: Wed, 1 May 2024 18:14:49 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/14] dm: Check that a zoned table leads to a valid
 mapped device
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240501000935.100534-1-dlemoal@kernel.org>
 <20240501000935.100534-2-dlemoal@kernel.org> <ZjGx6EpCIx5QnmT5@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZjGx6EpCIx5QnmT5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/24 12:07, Benjamin Marzinski wrote:
> On Wed, May 01, 2024 at 09:09:22AM +0900, Damien Le Moal wrote:
>> +static int dm_check_zoned(struct mapped_device *md, struct dm_table *t)
>> +{
>> +	struct gendisk *disk = md->disk;
>> +	unsigned int nr_conv_zones = 0;
>> +	int ret;
>> +
>> +	/* Revalidate only if something changed. */
>> +	md->zone_revalidate_map = t;
>> +	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
>> +				  dm_check_zoned_cb, &nr_conv_zones);
> 
> Aside from not really understanding what that comment is getting at, it
> looks good.

Oops. Too much copy-paste :)
I fixed that. Sending V3 shortly.

> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks.

-- 
Damien Le Moal
Western Digital Research

