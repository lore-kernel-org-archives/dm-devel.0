Received: from delivery.antispam.mailspamprotection.com (delivery.antispam.mailspamprotection.com [185.56.87.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C6280035
	for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.56.87.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774561734; cv=pass; b=ZgKonEhIKWosWNhUViD4ANnIW6t5teOPPS4pQnMqAJUxSxzZ2VdWl4s/rI475C6FGcy6aW3/32bEYhiWxzOyWFt1iC6cOiZjAsLUHcM0JjviZwnkADE2riT7WTG7aY0iF7u6P+Yis+OUK9EGzqitJ+BeY/So545Mr6xOYEEDoCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774561734; c=relaxed/simple;
	bh=TD6QzufwjRbyRho7i+euphSon2LVQrATAr4yg/zjNJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cD6mBcqbquthaChJ4pFe3WyV6JeBugA8XjyXA8DV+7mIcyG77v1qS9AQUCfWRMcYz2Rub8Nj5BBG2M2Oneu4Ak686FrDzHKz8ujir86RzTDlHfJsXuFkiWGF15h5tqG00kJDCghyRwyxtKef+obPLG8GD9H2W8nH8kvclu2FPJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valla.it; spf=pass smtp.mailfrom=valla.it; dkim=pass (1024-bit key) header.d=antispam.mailspamprotection.com header.i=@antispam.mailspamprotection.com header.b=wZ0i/Fff; dkim=pass (1024-bit key) header.d=valla.it header.i=@valla.it header.b=RFrZFFB2; arc=pass smtp.client-ip=185.56.87.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valla.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valla.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antispam.mailspamprotection.com header.i=@antispam.mailspamprotection.com header.b="wZ0i/Fff";
	dkim=pass (1024-bit key) header.d=valla.it header.i=@valla.it header.b="RFrZFFB2"
ARC-Seal: i=1; cv=none; a=rsa-sha256; d=outgoing.instance-europe-west4-xwfb.prod.antispam.mailspamprotection.com; s=arckey; t=1774561731;
	 b=hKEC6DyZh1eWu9JNvO9F7Ks2S2jxyZChAg8D07mm9bRzDe0SZl6YktySKX6Pw2tgq28VeOaiUp
	  xjO/JVJvI/BlsgtPXIJJbNqeiOL5GpRtthZAQZKgHO/dOJ86pqMRk0l2P4kAY2ZsoF2ZL4vXoT
	  Qctm1IhWeF+IgNHO8MIfOJgtc7s8WlQw0VGVddpxY5G8vSCPfAFM1GULxqiWo+HyLhVb4R+249
	  CxzhIiqec2T7RyjszqX0UIVjUt4QbZms8i6/G+xgnLOad7oq8BfQo136lZHYNcHxZDkL/uyT09
	  ijpGmvBfojOBzBFT+Y4GZYAznC6yu8eBg9BU6xCDPow7oA==;
ARC-Authentication-Results: i=1; outgoing.instance-europe-west4-xwfb.prod.antispam.mailspamprotection.com; smtp.remote-ip=35.214.173.214;
	iprev=pass (214.173.214.35.bc.googleusercontent.com) smtp.remote-ip=35.214.173.214;
	auth=pass (LOGIN) smtp.auth=esm19.siteground.biz;
	dkim=pass header.d=valla.it header.s=default header.a=rsa-sha256;
	arc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed; d=outgoing.instance-europe-west4-xwfb.prod.antispam.mailspamprotection.com; s=arckey; t=1774561731;
	bh=TD6QzufwjRbyRho7i+euphSon2LVQrATAr4yg/zjNJ0=;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:
	  From:Date:DKIM-Signature:DKIM-Signature;
	b=wL7yAO/dotWnsKAtDpa1mRCAu57NAfNOhk+Oq9ESbFHK4q+ukaoNruwbE6yG1LGFWnojFRKv7w
	  vajtCqKy5sY3bwdeOxKYplwOlxEDUxkjoi4rJxoNvtIh8IYvUcKvgd7GtMQ8eBoJqR5Rnllo5T
	  BnryANqANohe9P3LrBIEcywIFTKyymkf/BrIshVG5sBxOrxwAFX1nBhl648WGxEjmoYicPVjyb
	  rUD8lqw1icdgjvvlwFcPJfi3QWd8tAkE7WeBVFyP1jN0gvR9kCBghhxtN9WLpy61qQ6lBMR7kX
	  VKnumQop+DdHnu8wdJxAq0JWi0FFxY0HpAWzNTDVd8cMaw==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=antispam.mailspamprotection.com; s=default; h=CFBL-Feedback-ID:CFBL-Address
	:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	List-Unsubscribe:Content-Transfer-Encoding;
	bh=IE8UXNQghoxYUP5G4/PQqWXQx/CNBEavtp/EjW4PSPw=; b=wZ0i/FfftnFW/IuZfql3zDPpnM
	EfuwOcN4XejuzFf7wN6aOcxXfXzYZvrkqK8BtOar6J4a4TKNQvp6OOlXzo4o/aNWv/zqZKT2+GO82
	SKNPhMmzYKk/OGoiobmij5KHC0nnhivT+Y29rWGZ/wmL/J9CibMHpVdreW3/06KAaUkA=;
Received: from 214.173.214.35.bc.googleusercontent.com ([35.214.173.214] helo=esm19.siteground.biz)
	by instance-europe-west4-xwfb.prod.antispam.mailspamprotection.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.1)
	(envelope-from <francesco@valla.it>)
	id 1w5sRv-0000000CQMV-3k2z
	for dm-devel@lists.linux.dev;
	Thu, 26 Mar 2026 21:41:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=valla.it;
	s=default; h=Subject:Cc:To:From:Date:list-help:list-unsubscribe:
	list-subscribe:list-post:list-owner:list-archive;
	bh=IE8UXNQghoxYUP5G4/PQqWXQx/CNBEavtp/EjW4PSPw=; b=RFrZFFB261G64UG6ljIxzg6KGH
	uWL8TCbC1OZwIxBdYKdV+knST67L+gjohduBOwsll3pVR/NO9sI6FXGclapHWc8G3wUbs2vemQp/k
	FAXA/WKCxjCZksgZM5hZLXkYhCEr4xRbbIlI8UZ7og8lU/COWmHG0Qo38i5yDKy1biIA=;
Received: from [95.248.129.24] (port=63479 helo=bywater)
	by esm19.siteground.biz with essmtpa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <francesco@valla.it>)
	id 1w5sRh-00000000DRW-0ciV;
	Thu, 26 Mar 2026 21:40:53 +0000
Date: Thu, 26 Mar 2026 22:40:51 +0100
From: Francesco Valla <francesco@valla.it>
To: Guillaume Gonnet <ggonnet.linux@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Peter Korsgaard <peter@korsgaard.com>, dm-devel@schwermer.no, chanho.min@lge.com, jaeyuel.im@lge.com, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
Message-ID: <acWk8Gq7DJYTCcIW@bywater>
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317213229.18371-1-ggonnet.linux@gmail.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - esm19.siteground.biz
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - valla.it
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-SGantispam-id: 04dc100493c081a74f4d44cfcd363901
X-AntiAbuse: ID - 04dc100493c081a74f4d44cfcd363901
AntiSpam-DLS: false
AntiSpam-DLSP: 
AntiSpam-DLSRS: 
AntiSpam-TS: 1.0
CFBL-Address: feedback@antispam.mailspamprotection.com; report=arf
CFBL-Feedback-ID: 1w5sRv-0000000CQMV-3k2z-feedback@antispam.mailspamprotection.com
Authentication-Results: outgoing.instance-europe-west4-xwfb.prod.antispam.mailspamprotection.com;
	iprev=pass (214.173.214.35.bc.googleusercontent.com) smtp.remote-ip=35.214.173.214;
	auth=pass (LOGIN) smtp.auth=esm19.siteground.biz;
	dkim=pass header.d=valla.it header.s=default header.a=rsa-sha256;
	arc=none

Hello Guillaume,

On Tue, Mar 17, 2026 at 10:32:28PM +0100, Guillaume Gonnet wrote:
> The early_lookup_bdev() function returns successfully when the disk
> device is present but not necessarily its partitions. In this situation,
> dm_early_create() fails as the partition block device does not exist
> yet.
> 
> In my case, this phenomenon occurs quite often because the device is
> an SD card with slow reading times, on which kernel takes time to
> enumerate available partitions.
> 

I am now in the same situation, but I have seen the behavior also on
"fast" eMMC devices probing on slow single-core processors.

> Fortunately, the underlying device is back to "probing" state while
> enumerating partitions. Waiting for all probing to end is enough to fix
> this issue.
> 
> That's also the reason why this problem never occurs with rootwait=
> parameter: the while loop inside wait_for_root() explicitly waits for
> probing to be done and then the function calls async_synchronize_full().
> These lines were omitted in 035641b, even though the commit says it's
> based on the rootwait logic...
> 
> Anyway, calling wait_for_device_probe() after our while loop does the
> job (it both waits for probing and calls async_synchronize_full).
> 
> Fixes: 035641b01e72 ("dm init: add dm-mod.waitfor to wait for asynchronously probed block devices")
> Signed-off-by: Guillaume Gonnet <ggonnet.linux@gmail.com>
> ---
> 
> Hello,
> 
> This patch is my attempt to fix the dm-mod.waitfor= issue. I had this
> fix for quite a while now, but I've never made the effort to contribute
> until recently.
> 
> Some have tried to fix it this issue in the past but without finding
> its real root cause (ie. not waiting for device probe to end).
> 
> Here are the links to those patches, for reference:
> https://lore.kernel.org/all/b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no/
> https://lore.kernel.org/all/20250410080056.43247-1-chanho.min@lge.com/
> https://lore.kernel.org/dm-devel/20251211073426.123026-1-jaeyuel.im@lge.com/
> 
>  drivers/md/dm-init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index 7403823384c5..c1bacba92c65 100644
> --- a/drivers/md/dm-init.c
> +++ b/drivers/md/dm-init.c
> @@ -303,8 +303,10 @@ static int __init dm_init_init(void)
>  		}
>  	}
>  
> -	if (waitfor[0])
> +	if (waitfor[0]) {
> +		wait_for_device_probe();
>  		DMINFO("all devices available");
> +	}
>  
>  	list_for_each_entry(dev, &devices, list) {
>  		if (dm_early_create(&dev->dmi, dev->table,
> -- 
> 2.43.0
>

Reviewed-by: Francesco Valla <francesco@valla.it>
Tested-by: Francesco Valla <francesco@valla.it>


Thank you!

Regards,
Francesco

