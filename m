Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DC8C147;
	Wed, 13 Dec 2023 05:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPqmlW9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79E6C433C8;
	Wed, 13 Dec 2023 05:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702443614;
	bh=gC1lI3x4vsiQ2Y+IPRczMggA/qnBBXkC9wbtK1snAjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BPqmlW9JQYQlGE3yHwf4cPkd0c5YBzdIU1rOS063bQ7ze5ymieEBqLPQ1YiXRIMMH
	 h044fS0Mn8kaUsY1io0PFKV79y1EHayMztCy52QlmJhBL8/MgDgD5MYoXWM87VIScT
	 wZsvv5MKHoLwS8+e3DQjitaZ716HuCtB964zlZYGjNNL/qe71F/gW7YxMz+80snL25
	 R56YU4xRJrsc8c+iaGtvkw1BQBTLXZCi1t7/Pw2oXIt4vVu4ymguwVRJIVik5tV3lU
	 rSumXjFwxKbyrtm5qm2s/bq2CYTxI7Y7sgXDXp44mPUVtp9gvC4M7ieuMlSKm/Tkpg
	 0wXBy5F7m4xQQ==
Date: Tue, 12 Dec 2023 21:00:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Hongyu Jin <hongyu.jin.cn@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	axboe@kernel.dk, zhiguo.niu@unisoc.com, ke.wang@unisoc.com,
	yibin.ding@unisoc.com, hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 3/5] dm-bufio: Support I/O priority
Message-ID: <20231213050012.GD1127@sol.localdomain>
References: <ZXeJ9jAKEQ31OXLP@redhat.com>
 <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
 <20231212111150.18155-4-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212111150.18155-4-hongyu.jin.cn@gmail.com>

On Tue, Dec 12, 2023 at 07:11:48PM +0800, Hongyu Jin wrote:
>  static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
> -		     unsigned int n_sectors, unsigned int offset)
> +		     unsigned int n_sectors, unsigned int offset, unsigned short ioprio)

The ioprio argument to this function is unused.

>  bool dm_bm_is_read_only(struct dm_block_manager *bm)
> diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
> index 75e7d8cbb532..d270d48891f7 100644
> --- a/include/linux/dm-bufio.h
> +++ b/include/linux/dm-bufio.h
> @@ -11,6 +11,7 @@
>  #define _LINUX_DM_BUFIO_H
>  
>  #include <linux/blkdev.h>
> +#include <linux/ioprio.h>
>  #include <linux/types.h>

It's not necessary to include linux/ioprio.h here.

- Eric
