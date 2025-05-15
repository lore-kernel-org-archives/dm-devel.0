Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3C61FAC54
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 12:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747313040; cv=none; b=PN+Cd6LmmTITzU0oFKN9+TCo+ZlQN6EGdGa+Q+fIF1OXstHo1gHDK8muiF87B7THiPVjiJQY3i1bBt2Ib5Pwis9Fv38qo5sVUHm6V+1dZt/bZm7w4ATQcWth2LHnlWIekPb2lvJ0h5d5Ja65ikNS2lGk/GfzeRrbQ9iboUJNq50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747313040; c=relaxed/simple;
	bh=h6VKZvpWpezEhOsqO2v6E8VvZK/irc0tTPmyYvY5Mew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nafaOTsiFw7fVPS1sDUH/V4FhaIQ9tysZajcyu6zapQr7ubnAVXB37VjpGbvVI2vrF1Ej97co8TMoNzY1Oa1SzHd2eU07Pyv/1oqdanKbm5ouPWp8TEFVsDmNatmKE7rdCFSzTl7NZzzh/kSxmpgG9TFqY13lMVVt3KgVkMNM5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUHokTp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUHokTp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A10C4CEE7;
	Thu, 15 May 2025 12:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747313039;
	bh=h6VKZvpWpezEhOsqO2v6E8VvZK/irc0tTPmyYvY5Mew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FUHokTp/0cBXuHG4sOc9N+6+KhoCr8HuKcE6nt9J+yKe2EiUb2fdnA/qnnb9s+VuY
	 lLBjLsNEQcmYvgd3hR1OzspuG0tdlVJC2TRbY+8nR2vQaNlyJiXgluIhbYGnIAhebV
	 Nlge+n+huhoUYrdezmBHGN19Gb+nODIbnQmMn6LdCoaBfPE76J/CBkaXCM5wvB4p02
	 gbTYpP90+n2cEAHyhdcNBKryttpnIbvaftEHGkkbtZ+N2WLoRPCaSjUptLCGhgZbs9
	 EKMJsFsPIwEsnouuPr4XBvg3jH+g8SAAczC+lOpPXThLAiz1QIk3TY2mL0+S4zqTK0
	 nWFB6Mu+8p5nA==
Message-ID: <63e1601b-28e7-492a-9b45-eeea7c087044@kernel.org>
Date: Thu, 15 May 2025 14:43:55 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-zone: Use bdev_*() helper functions where
 applicable
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Pankaj Raghav <p.raghav@samsung.com>
References: <20250514205033.2108129-1-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250514205033.2108129-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/25 22:50, Bart Van Assche wrote:
> Improve code readability by using bdev_is_zone_aligned() and
> bdev_offset_from_zone_start() where applicable. No functionality
> has been changed.
> 
> This patch is a reworked version of a patch from Pankaj Raghav.
> 
> See also https://lore.kernel.org/linux-block/20220923173618.6899-11-p.raghav@samsung.com/.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
