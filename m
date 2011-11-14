From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2] dm: verity target
Date: Mon, 14 Nov 2011 10:22:52 +0100
Message-ID: <20111114092252.GA11359@secunet.com>
References: <20111110074408.GE10138@secunet.com>
 <1321032884-14621-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1321032884-14621-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Nov 11, 2011 at 09:34:44AM -0800, Mandeep Singh Baines wrote:
>
> +/**
> + * dm_bht_compute_hash: hashes a page of data
> + */
> +static int dm_bht_compute_hash(struct dm_bht *bht, struct page *pg,
> +			       unsigned int offset, u8 *digest)
> +{
> +	struct shash_desc *hash_desc = bht->hash_desc[smp_processor_id()];
> +	void *data;
> +	int err;

You don't need to have one shash_desc per cpu. As the shash interface is
synchronous, you could either allocate a new shash_desc with every call
to dm_bht_compute_hash, or just place the shash_desc with the context to
the stack of this function. The easiest thing would be to add the
shash transformation direct to dm_bht and then something like

        struct {
                struct shash_desc desc;        
                char ctx[crypto_shash_descsize(bht->tfm)];                                                
        } hash_desc;

	hash_desc.desc.tfm = bmt->tfm;

The intermediate and final digest values are stored to hash_desc.ctx.
This is local, hence it's reentrant.

> +
> +	/* Note, this is synchronous. */
> +	if (crypto_shash_init(hash_desc)) {
> +		DMCRIT("failed to reinitialize crypto hash (proc:%d)",
> +			smp_processor_id());
> +		return -EINVAL;
> +	}
> +	data = kmap_atomic(pg);
> +	err = crypto_shash_update(hash_desc, data + offset, PAGE_SIZE);
> +	kunmap_atomic(data);
> +	if (err) {
> +		DMCRIT("crypto_hash_update failed");
> +		return -EINVAL;
> +	}
> +	if (crypto_shash_update(hash_desc, bht->salt, sizeof(bht->salt))) {
> +		DMCRIT("crypto_hash_update failed");
> +		return -EINVAL;
> +	}
> +	if (crypto_shash_final(hash_desc, digest)) {
> +		DMCRIT("crypto_hash_final failed");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +

[snip]

> + * TODO(wad): All hash storage memory is pre-allocated and freed once an
> + * entire branch has been verified.
> + */
> +struct dm_bht {
> +	/* Configured values */
> +	int depth;  /* Depth of the tree including the root */
> +	unsigned int block_count;  /* Number of blocks hashed */
> +	unsigned int block_size;  /* Size of a hash block */
> +	char hash_alg[CRYPTO_MAX_ALG_NAME];
> +	unsigned char salt[DM_BHT_SALT_SIZE];
> +
> +	/* Computed values */
> +	unsigned int node_count;  /* Data size (in hashes) for each entry */
> +	unsigned int node_count_shift;  /* first bit set - 1 */
> +	/* There is one per CPU so that verified can be simultaneous. */
> +	struct shash_desc *hash_desc[NR_CPUS];  /* Container for the hash alg */

As mentioned above, you don't need to have one shash_desc per cpu.
Replace this with a 'struct crypto_shash *tfm;' and add this transformation
to the local hash_desc.
