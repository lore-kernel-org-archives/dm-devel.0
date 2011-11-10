From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] dm: verity target
Date: Thu, 10 Nov 2011 08:44:08 +0100
Message-ID: <20111110074408.GE10138@secunet.com>
References: <1320902290-19050-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1320902290-19050-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 09, 2011 at 09:18:10PM -0800, Mandeep Singh Baines wrote:
>
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
> +	struct hash_desc hash_desc[NR_CPUS];  /* Container for the hash alg */

Please don't add a new user for the old hash interface. If the hashes can
be done asynchronous you can use ahash, if not use shash. Both interfaces
are reentrant, that's probaply what you want to have here. You don't
need to have this in a per cpu manner.
