Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8CF54BEE
	for <dm-devel@lists.linux.dev>; Tue, 21 Nov 2023 23:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSb6iZKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671D7C433C8;
	Tue, 21 Nov 2023 23:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700607666;
	bh=QAfrBafS2Xedk/FBg4PhLH+uYFOCkILDjpuxPhlJVkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSb6iZKC0i48lXMnjLAJ2ww+33n/jKVtodY28O7MO5TIR7EzKqfqI7zK0YiK4lTh0
	 7KLy50Z+JTrofssxAistPkMkJ1b+U8w+ldlsHfdjLO/mZEJh3xnIC0JbEJm8FyVh6p
	 B1sx3u5xw5s9wcAOan/R9y2DbQID6uRzzxnd19Y9gZB1rp47OyLlAnQvd5GoZUxSD1
	 U7YtSA2k0zFe5ye58eB46HWRuq+ZYD17zdCyE19ME0m8e6kel23I4Y2ekEwZoiyGTM
	 L3mEXFrmfd6mXFBx9c6MsYwnS4401p5jEvTVL/9RgI0lzxhFPuUiTi1HBYmo4viBRS
	 Fs7/t3lGhjv5Q==
Date: Tue, 21 Nov 2023 15:01:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Wu Bo <bo.wu@vivo.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, Wu Bo <wubo.oduw@gmail.com>
Subject: Re: [PATCH 2/2] dm verity: don't verity if readahead failed
Message-ID: <20231121230104.GB2172@sol.localdomain>
References: <cover.1700555778.git.bo.wu@vivo.com>
 <e18ec7ad7449f2aba885b93467005848745f4853.1700555778.git.bo.wu@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e18ec7ad7449f2aba885b93467005848745f4853.1700555778.git.bo.wu@vivo.com>

On Tue, Nov 21, 2023 at 01:55:29AM -0700, Wu Bo wrote:
> We found an issue under Android OTA scenario that many BIOs have to do
> FEC where the data under dm-verity is 100% complete and no corruption.
> 
> Android OTA has many dm-block layers, from upper to lower:
> dm-verity
> dm-snapshot
> dm-origin & dm-cow
> dm-linear
> ufs
> 
> Dm tables have to change 2 times during Android OTA merging process.
> When doing table change, the dm-snapshot will be suspended for a while.
> During this interval, we found there are many readahead IOs are
> submitted to dm_verity from filesystem. Then the kverity works are busy
> doing FEC process which cost too much time to finish dm-verity IO. And
> cause system stuck.
> 
> We add some debug log and find that each readahead IO need around 10s to
> finish when this situation occurred. Because here has a IO
> amplification:
> 
> dm-snapshot suspend
> erofs_readahead     // 300+ io is submitted
> 	dm_submit_bio (dm_verity)
> 		dm_submit_bio (dm_snapshot)
> 		bio return EIO
> 		bio got nothing, it's empty
> 	verity_end_io
> 	verity_verify_io
> 	forloop range(0, io->n_blocks)    // each io->nblocks ~= 20
> 		verity_fec_decode
> 		fec_decode_rsb
> 		fec_read_bufs
> 		forloop range(0, v->fec->rsn) // v->fec->rsn = 253
> 			new_read
> 			submit_bio (dm_snapshot)
> 		end loop
> 	end loop
> dm-snapshot resume
> 
> Readahead BIO got nothing during dm-snapshot suspended. So all of them
> will do FEC.
> Each readahead BIO need to do io->n_blocks ~= 20 times verify.
> Each block need to do fec, and every block need to do v->fec->rsn = 253
> times read.
> So during the suspend interval(~200ms), 300 readahead BIO make
> 300*20*253 IOs on dm-snapshot.
> 
> As readahead IO is not required by user space, and to fix this issue,
> I think it would be better to pass it to upper layer to handle it.
> 
> Signed-off-by: Wu Bo <bo.wu@vivo.com>
> ---
>  drivers/md/dm-verity-target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 42b2483eb08c..d242e50ec869 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -668,7 +668,9 @@ static void verity_end_io(struct bio *bio)
>  
>  	verity_fec_init_io(io);
>  	if (bio->bi_status &&
> -	    (!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
> +	    (!verity_fec_is_enabled(io->v) ||
> +	     verity_is_system_shutting_down() ||
> +	     (bio->bi_opf & REQ_RAHEAD))) {
>  		verity_finish_io(io, bio->bi_status);
>  		return;
>  	}

Thanks, this seems reasonable to me.  As with your previous patch: what commit
introduced this issue?  To me this looks like a longstanding issue, maybe dating
back to the original addition of FEC support to dm-verity by commit a739ff3f543a
("dm verity: add support for forward error correction"); do you agree?  Can you
please add Fixes and "Cc stable" tags to your patch?  Thanks!

- Eric
