From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] dm-verity:unnecessary data blocks that need not read
 hash blocks
Date: Mon, 6 Jan 2020 19:14:29 -0800
Message-ID: <20200107031429.GA705@sol.localdomain>
References: <20200107024843.8660-1-zhou_xianrong@sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200107024843.8660-1-zhou_xianrong@sohu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhou_xianrong <zhou_xianrong@sohu.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, wanbin.wang@transsion.com, haizhou.song@transsion.com, "xianrong.zhou" <xianrong.zhou@transsion.com>, "yuanjiong . gao" <yuanjiong.gao@transsion.com>, "ruxian . feng" <ruxian.feng@transsion.com>
List-Id: dm-devel.ids

On Tue, Jan 07, 2020 at 10:48:43AM +0800, zhou_xianrong wrote:

> Subject: [PATCH] dm-verity:unnecessary data blocks that need not read

Please use a proper commit subject.  It should begin with "dm verity: " and use
the imperative tense to describe the change, e.g.

	dm verity: don't prefetch hash blocks for already-verified data

Also this should have been "PATCH v2", not simply PATCH, since you already sent
out a previous version.

You also sent out multiple copies of this email for some reason, so I just chose
one arbitrarily to reply to...

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 4fb33e7..4127711 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -611,8 +611,27 @@ static void verity_prefetch_io(struct work_struct *work)
>  
>  static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
>  {
> +	sector_t block = io->block;
> +	unsigned int n_blocks = io->n_blocks;
>  	struct dm_verity_prefetch_work *pw;
>  
> +	if (v->validated_blocks) {
> +		while (n_blocks) {
> +			if (unlikely(!test_bit(block, v->validated_blocks)))
> +				break;
> +			block++;
> +			n_blocks--;
> +		}
> +		while (n_blocks) {
> +			if (unlikely(!test_bit(block + n_blocks - 1,
> +				v->validated_blocks)))
> +				break;
> +			n_blocks--;
> +		}
> +		if (!n_blocks)
> +			return;
> +	}

This looks fine now, though it's a bit more verbose than necessary, and I don't
think unlikely() will make any difference here.  Consider simplifying it to:

	if (v->validated_blocks) {
		while (n_blocks && test_bit(block, v->validated_blocks)) {
			block++;
			n_blocks--;
		}
		while (n_blocks && test_bit(block + n_blocks - 1,
					    v->validated_blocks))
			n_blocks--;
		if (!n_blocks)
			return;
	}
