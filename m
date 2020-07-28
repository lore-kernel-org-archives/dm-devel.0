From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v5 06/11] dm-verity: move signature check after tree
 validation
Date: Tue, 28 Jul 2020 14:50:41 -0700
Message-ID: <20200728215041.GF4053562@gmail.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200728213614.586312-7-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200728213614.586312-7-deven.desai@linux.microsoft.com>
Sender: linux-block-owner@vger.kernel.org
To: Deven Bowers <deven.desai@linux.microsoft.com>
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, viro@zeniv.linux.org.uk, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com, tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatashin@soleen.com
List-Id: dm-devel.ids

On Tue, Jul 28, 2020 at 02:36:06PM -0700, Deven Bowers wrote:
> The CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG introduced by Jaskaran was
> intended to be used to allow an LSM to enforce verifications for all
> dm-verity volumes.
> 
> However, with it's current implementation, this signature verification
> occurs after the merkel-tree is validated, as a result the signature can
> pass initial verification by passing a matching root-hash and signature.
> This results in an unreadable block_device, but that has passed signature
> validation (and subsequently, would be marked as verified).
> 
> This change moves the signature verification to after the merkel-tree has
> finished validation.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> ---
>  drivers/md/dm-verity-target.c     |  44 ++++------
>  drivers/md/dm-verity-verify-sig.c | 140 ++++++++++++++++++++++--------
>  drivers/md/dm-verity-verify-sig.h |  24 +++--
>  drivers/md/dm-verity.h            |   2 +-
>  4 files changed, 134 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index eec9f252e935..fabc173aa7b3 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -471,9 +471,9 @@ static int verity_verify_io(struct dm_verity_io *io)
>  	struct bvec_iter start;
>  	unsigned b;
>  	struct crypto_wait wait;
> +	int r;
>  
>  	for (b = 0; b < io->n_blocks; b++) {
> -		int r;
>  		sector_t cur_block = io->block + b;
>  		struct ahash_request *req = verity_io_hash_req(v, io);
>  
> @@ -530,6 +530,16 @@ static int verity_verify_io(struct dm_verity_io *io)
>  			return -EIO;
>  	}
>  
> +	/*
> +	 * At this point, the merkel tree has finished validating.
> +	 * if signature was specified, validate the signature here.
> +	 */
> +	r = verity_verify_root_hash(v);
> +	if (r < 0) {
> +		DMERR_LIMIT("signature mismatch");
> +		return r;
> +	}
> +
>  	return 0;
>  }

This doesn't make any sense.

This just moves the signature verification to some random I/O.

The whole point of dm-verity is that data is verified on demand.  You can't know
whether any particular data or hash block is consistent with the root hash or
not until it is read and verified.

When the first I/O completes it might have just checked one block of a billion.

Not to mention that you didn't consider locking at all.

- Eric
