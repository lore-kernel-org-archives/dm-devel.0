Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E12D3206
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869306; cv=none; b=fdGGJ8S+7CzXJEyRRA4nK9F0e4X3ev9z/HwWsY3Za2qOvlMr9QzWuFMU6tY3gmTL3P0/r3sudv94nh87PIP1tuZw9tcq1OQJJyu06WeWYH+R2T7clLUEVGude/NvzItPreYprJ+BEdWrUp6rBv1y4mNDZjBykLojsrGIO8azeCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869306; c=relaxed/simple;
	bh=uSU+CVRzDhuBCrylHIKqb/5LynTGVouo2ht+0eBU3mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vr3gx1OKaz4d2EEKF7PTo7fbYUCizo+GKm1WCJ+7+bYuCIYIyJwEn3Lfv3k6DRQ6cFyhJNBiHRuy36BWMeAc0P5I4XRj9yhKDY3DaTkiWOc+BZg/bS4oPplVzvmDYPxblwnKUdVnC+eTGz5ucliv7Z8O+PyT01NPVnOCm949d/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TArdKjsv; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TArdKjsv"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bS6qQ1LDqzlgqyQ;
	Wed, 25 Jun 2025 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750869296; x=1753461297; bh=6TsA/MXe2+bDQ40v8gre2JKK
	Le1cqMtu6plLxc69bWY=; b=TArdKjsvDF9MxIEMy1QZ7AbtmsUkdsJoNpep1fCc
	jzMEWJ5NE3wyC2/GX8Yic7uLwV3L4bfnW34Rp0hmfBmE+/PD+EF6Ec6NUW1TVrMP
	CyinjmTdFx8JlJJY8aa5YqUeTFPtWu3eWkVikFvQ0qKW84jMtje2LIM1gX+3qpAE
	2s3+GtCfftzl0e4kuR2qrCqEMyJ9N2ox1J8JiHr9S+WfiZBvlks+1iDE16rFuF9f
	3Mik/9SRs2344xvxDQnnj0bHHVr/OkT6inRWjm3QiHZWwI8VZGflcTQc0JKLeJfZ
	fR27Sx2P8YeXf1nY8ay0/dVmAqfSBZcTWR9aTh7+rYpZ7Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mBI3-OVvIk-e; Wed, 25 Jun 2025 16:34:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bS6qK02vQzlgqVH;
	Wed, 25 Jun 2025 16:34:52 +0000 (UTC)
Message-ID: <654fed1e-ce53-4386-a966-97c50931e9b5@acm.org>
Date: Wed, 25 Jun 2025 09:34:51 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] dm: Always split write BIOs to zoned device limits
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-4-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250625093327.548866-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 2:33 AM, Damien Le Moal wrote:
> +	/*
> +	 * Mapped devices that require zone append emulation will use the block
> +	 * layer zone write plugging. In such case, we must split any large BIO
> +	 * to the mapped device limits to avoid potential deadlocks with queue
> +	 * freeze operations.
> +	 */
> +	if (!dm_emulate_zone_append(md))
> +		return false;
> +	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);

Changing the dm_emulate_zone_append() call into a
disk_need_zone_resources() call or a disk->zone_wplugs_hash test
probably would make the intention of the if-statement more clear.

Additionally, bio_needs_zone_write_plugging() already tests
disk->zone_wplugs_hash. Isn't the dm_emulate_zone_append() call
superfluous because of this?

Thanks,

Bart.
