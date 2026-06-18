Received: from mail-108-mta203.mxroute.com (mail-108-mta203.mxroute.com [136.175.108.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D23314D26
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781784228; cv=none; b=foQ6AvlEmJ9rZFBCgAsCHhNpUGY7EZuOHLHTtbzrHXCJh7Ob+x8pDSS/OCd5xhllAJXzQdRwrr3WIFywo9gzHX4ZktgcW/42/hG1o8ejvRMCwao/5pHQNeLyTrxVCvXoOHfqFOv8SN/Um7fnqbpzPrJbJo7a/iPVWGgAXGyvGpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781784228; c=relaxed/simple;
	bh=HIMakmGhdbQBvvvgaTYtfkr10gYYniUixYzsLu2VB0o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oCk7jsVsFohebei4/c1tsZiL9AUwHPRSrekxFpHO1/GAfoxbJfxnWeGe3045ytmafRp+s8uOolT1ltNmVcK84okxOWt8RfQsZmdy/S3nEaQNkxBZa02w8oRKaxpXBF3Uj3gBYmPrTDoVbxHfGlQn5I9U6yFWO5Q0C9IztYVoKa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=PDy5kE3F; arc=none smtp.client-ip=136.175.108.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="PDy5kE3F"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta203.mxroute.com (ZoneMTA) with ESMTPSA id 19eda98f08700067f7.004
 for <dm-devel@lists.linux.dev>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 18 Jun 2026 11:58:36 +0000
X-Zone-Loop: fab93f367048576aa238bcd4070f4d332d18663ae583
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EhJY3pnVfg1LazCsI/d4S/4TCQvcqhsw3d1w9JycFtU=; b=PDy5kE3F6EeDdoeTqZRqOc5oxQ
	LKZ3FwMNTO+xdBvFQgysMNR+epayyp9vW4M1+UrflOKcTSOpXA7hAV4Q87FK9Ul5nYsSl/uMZEkl6
	r/d5+0aePcCBHWD0ifQTo2owQ4kvCPo30ZQpsB5Tp/NH7imXSGBiRkXdWdj1/5SuD9NqP7vGfdqX3
	lDspp3D4gnDRVLiN6uHRGeOPc5bfJdn0nZPYHAwZigyYjK+zfYvLWZlraBzNHgG1JgYq+j+KL16b3
	g1NdTC4XkoFubT9pC65f1zLOMhXCTY0BqPtq47a9i0HKtFO96tGiMnCDpZsOdJxRqjOs0PqIH3dLi
	OG7hPdYQ==;
From: Su Yue <l@damenly.org>
To: ghuicao@163.com
Cc: Mike Snitzer <snitzer@kernel.org>,  Alasdair Kergon <agk@redhat.com>,
  Mikulas Patocka <mpatocka@redhat.com>,  Benjamin Marzinski
 <bmarzins@redhat.com>,  dm-devel@lists.linux.dev,
  linux-kernel@vger.kernel.org,  Cao Guanghui <caoguanghui@kylinos.cn>
Subject: Re: [PATCH 2/2] dm era: fix error code propagation in era_ctr()
In-Reply-To: <20260617060053.71051-3-ghuicao@163.com> (ghuicao@163.com's
	message of "Wed, 17 Jun 2026 14:00:53 +0800")
References: <20260617060053.71051-1-ghuicao@163.com>
	<20260617060053.71051-3-ghuicao@163.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Thu, 18 Jun 2026 19:58:27 +0800
Message-ID: <ik7gt5zw.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Wed 17 Jun 2026 at 14:00, ghuicao@163.com wrote:

> From: Cao Guanghui <caoguanghui@kylinos.cn>
>
> era_ctr() replaces the actual error codes returned by 
> dm_get_device()
> and dm_set_target_max_io_len() with hardcoded -EINVAL, 
> discarding
> the real reason for the failure (e.g. -ENODEV, -ENOMEM).  This 
> makes
> it harder for users to diagnose problems and is inconsistent 
> with
> other dm targets (dm-thin, dm-verity, dm-flakey, dm-ebs) which
> propagate the original error.
>
> Fix all three sites to return 'r' instead of -EINVAL.
>
> Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
>
Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>  drivers/md/dm-era-target.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-era-target.c 
> b/drivers/md/dm-era-target.c
> index 08ce96e8cf4f..4eb1c4f90e1b 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -1488,7 +1488,7 @@ static int era_ctr(struct dm_target *ti, 
> unsigned int argc, char **argv)
>  	if (r) {
>  		ti->error = "Error opening metadata device";
>  		era_destroy(era);
> -		return -EINVAL;
> +		return r;
>  	}
>
>  	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE,
> @@ -1496,7 +1496,7 @@ static int era_ctr(struct dm_target *ti, 
> unsigned int argc, char **argv)
>  	if (r) {
>  		ti->error = "Error opening data device";
>  		era_destroy(era);
> -		return -EINVAL;
> +		return r;
>  	}
>
>  	r = sscanf(argv[2], "%u%c", &era->sectors_per_block, &dummy);
> @@ -1510,7 +1510,7 @@ static int era_ctr(struct dm_target *ti, 
> unsigned int argc, char **argv)
>  	if (r) {
>  		ti->error = "could not set max io len";
>  		era_destroy(era);
> -		return -EINVAL;
> +		return r;
>  	}
>
>  	if (!valid_block_size(era->sectors_per_block)) {
