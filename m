From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 3/3] dm: enable may_passthrough_inline_crypto on some
 targets
Date: Mon, 21 Sep 2020 17:49:10 -0700
Message-ID: <20200922004910.GD32959@sol.localdomain>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-4-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200909234422.76194-4-satyat@google.com>
To: Satya Tangirala <satyat@google.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 09, 2020 at 11:44:22PM +0000, Satya Tangirala wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> dm-linear and dm-flakey obviously can pass through inline crypto support.
> 
> dm-zero should declare that it passes through inline crypto support, since
> any reads from dm-zero should return zeroes, and blk-crypto should not
> attempt to decrypt data returned from dm-zero.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>
> ---
>  drivers/md/dm-flakey.c | 1 +
>  drivers/md/dm-linear.c | 1 +
>  drivers/md/dm-zero.c   | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index a2cc9e45cbba..655286dacc35 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -253,6 +253,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ti->num_discard_bios = 1;
>  	ti->per_io_data_size = sizeof(struct per_bio_data);
>  	ti->private = fc;
> +	ti->may_passthrough_inline_crypto = true;
>  	return 0;
>  
>  bad:
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index e1db43446327..6d81878e2ca8 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ti->num_secure_erase_bios = 1;
>  	ti->num_write_same_bios = 1;
>  	ti->num_write_zeroes_bios = 1;
> +	ti->may_passthrough_inline_crypto = true;
>  	ti->private = lc;
>  	return 0;
>  
> diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
> index b65ca8dcfbdc..07e02f3a9cd1 100644
> --- a/drivers/md/dm-zero.c
> +++ b/drivers/md/dm-zero.c
> @@ -26,6 +26,7 @@ static int zero_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	 * Silently drop discards, avoiding -EOPNOTSUPP.
>  	 */
>  	ti->num_discard_bios = 1;
> +	ti->may_passthrough_inline_crypto = true;
>  
>  	return 0;
>  }

Isn't it wrong to set may_passthrough_inline_crypto on dm-zero?  First, there's
no actual underlying device associated with dm-zero, so the idea of dm-zero
"passing through" anything is strange.

Second, inline encryption is supposed to semantically operate on the original
bio.  I.e. if someone reads some data from dm-zero and they use a bio_crypt_ctx
that indicates the data should be decrypted, then I'd expect that either the bio
would fail, *or* it would return back data which is equal to the decryption of
the all-zeroes ciphertexts.

may_passthrough_inline_crypto=false would give that behavior.  Whereas with
may_passthrough_inline_crypto=true, the bio's encryption context may just be
ignored and reads will return all zeroes.

Of course, setting an encryption context for I/O to/from dm-zero isn't really
something that people would do anyway...  But it seems we shouldn't bother
setting may_passthrough_inline_crypto on it when it seems wrong.

- Eric
