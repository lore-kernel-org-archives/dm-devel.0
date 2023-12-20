Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28C048780;
	Wed, 20 Dec 2023 18:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AC0Tyquj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748A1C433C8;
	Wed, 20 Dec 2023 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703097182;
	bh=f144gnrYx3aALxmr2qylKbFvhC7hG8a5SPA1LFipwBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AC0Tyquje3iOPa46ITKpWlffLd/0bqIOx25x9i7qR1UmMU5pjJ2BRehOgxhER8vnc
	 Uqu7wCvhKOUR312AYXP4qUO1Km1xIcLTo0FvzjL5yH5r9AvRq/ftkOYwaLKDENDX/V
	 Wes1AdBADinCi9dzeSAmKODWmJDd5W6kaRz7ulJDJ2PxxxlZKEVnCth1PomgStXSj7
	 o+mgKJcr271dCo/gObr+1ic1hewS6iKeL/UupIYvSNPXNaybIPpyjKS0OljRnncYKw
	 fxZgD2eWhXPVdhpV3fu4ddCiQzfxxxMKkYI/b7WSjKhUXhqw0ydNftEKe/LIDYuG+B
	 CUr5uKV+qVCjw==
Date: Wed, 20 Dec 2023 12:32:55 -0600
From: Eric Biggers <ebiggers@kernel.org>
To: Hongyu Jin <hongyu.jin.cn@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	axboe@kernel.dk, zhiguo.niu@unisoc.com, ke.wang@unisoc.com,
	yibin.ding@unisoc.com, hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v6 4/5] dm verity: Fix I/O priority lost when read FEC
 and hash
Message-ID: <20231220183255.GA119068@quark.localdomain>
References: <20231213104216.27845-6-hongyu.jin.cn@gmail.com>
 <20231220100333.107049-1-hongyu.jin.cn@gmail.com>
 <20231220100333.107049-5-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220100333.107049-5-hongyu.jin.cn@gmail.com>

On Wed, Dec 20, 2023 at 06:03:32PM +0800, Hongyu Jin wrote:
> +static inline struct dm_verity_io *verity_io(struct dm_verity *v, struct dm_verity_fec_io *fio)
> +{
> +	return (struct dm_verity_io *)
> +		((char *)fio + sizeof(struct dm_verity_fec_io) - v->ti->per_io_data_size);
> +}
[...]
> @@ -129,8 +136,10 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
>  	struct dm_buffer *buf;
>  	unsigned int n, i, offset;
>  	u8 *par, *block;
> +	struct dm_verity_io *io = verity_io(v, fio);
> +	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);

How about passing 'io' as an argument to fec_decode_bufs() instead of adding the
verity_io() helper function?

- Eric
