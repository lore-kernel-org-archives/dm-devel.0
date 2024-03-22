Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F1B4A07;
	Fri, 22 Mar 2024 02:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711075149; cv=none; b=ZtfXnc8NB3mwtvcTjhCqA7cymYhhZqRNlnO3J6nxKXa7trgRRyWsrQxOpExmMZH+mdiyLK8TwF73CM/rJnUJgbxpvybODdZGgRTiwl3kMyXw7kIaIrfN6pYu/HPoEqDfpXagxHT7Jb6QN1kU5GbKqxl53xSvMnSEjrghJ2caarU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711075149; c=relaxed/simple;
	bh=Mi7NaBek0aMBNBMcyXiE2xZDu39mqx6MXKwzwjxGtes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEwPV2Z4La6j07mNpRMNojRFAXDPpFmBlGtWpkUMI51kyVhpTHKQ1WtcoLebkUZOAv6ruSsM63RJlRnQFBL9J8hAxdJWENEBMx5sGlWU9M7EoIaROKUpEA1W7fWf8yLkMaX5vnWjh/v5iTC54CMbAu+d/+pRbt2dhkjnE/GDoNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dq2eeCAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dq2eeCAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EEEC433F1;
	Fri, 22 Mar 2024 02:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711075149;
	bh=Mi7NaBek0aMBNBMcyXiE2xZDu39mqx6MXKwzwjxGtes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dq2eeCAFLbrGS1T9jufZislIDhi8tgq5Bq7ylrcrYUcWS6j0krtBfWVxfHTuqOZn6
	 uscgI02k3DyRK8h3/c65EIaWWOkJicWrHKApQPpKffEuWXJa2H64dKSm3T/pPmQOT6
	 Z8FVPFE86JqL0DpKK/uFg1C+MXcFM1+tylQUATVV2UWn262upHEY1wM13tgsXZeAFt
	 t5P2nUuGJmXIpWbF2aPJ3pg4KUNh8baS6BOVquMvU6Zlpo32fMlMTfeDID8CmDxvxO
	 ZZI+GnmbazuslIAqiECkjdr2B7zpPztTUmgVkH4lCARWbdqH/XS6oMuAyIlTWnL8Y/
	 ywWgknjeB3tlw==
Date: Thu, 21 Mar 2024 20:39:06 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: block: fail unaligned bio from submit_bio_noacct()
Message-ID: <ZfzvSguRii37MErS@kbusch-mbp>
References: <20240321131634.1009972-1-ming.lei@redhat.com>
 <ZfxVqkniO-6jFFH5@redhat.com>
 <ea8a13c-ee40-47f9-a7be-17b84bd1f686@redhat.com>
 <ZfzoC/V07nExJ+0x@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfzoC/V07nExJ+0x@fedora>

On Fri, Mar 22, 2024 at 10:08:11AM +0800, Ming Lei wrote:
> On Thu, Mar 21, 2024 at 06:01:41PM +0100, Mikulas Patocka wrote:
> > I would change it to
> > 
> > if (unlikely(((bi_iter.bi_sector | bio_sectors(bio)) & ((queue_logical_block_size(q) >> 9) - 1)) != 0))
> > 	return false;
> 
> What if bio->bi_iter.bi_size isn't aligned with 512? The above check
> can't find that at all.

Shouldn't that mean this check doesn't apply to REQ_OP_DRV_IN/OUT?
Those ops don't necessarily imply any alignment requirements. It may not
matter here since it looks like all existing users go through
blk_execute_rq() instead of submit_bio(), but there are other checks for
DRV_IN/OUT in this path, so I guess it is supposed to be supported?
