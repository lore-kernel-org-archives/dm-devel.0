From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/3] block: fix up bio_crypt_ctx allocation
Date: Mon, 28 Sep 2020 13:59:34 -0700
Message-ID: <20200928205934.GA1340@sol.localdomain>
References: <20200916035315.34046-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200916035315.34046-1-ebiggers@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Satya Tangirala <satyat@google.com>, Miaohe Lin <linmiaohe@huawei.com>
List-Id: dm-devel.ids

On Tue, Sep 15, 2020 at 08:53:12PM -0700, Eric Biggers wrote:
> This series makes allocation of encryption contexts either able to fail,
> or explicitly require __GFP_DIRECT_RECLAIM (via WARN_ON_ONCE).
> 
> This applies to linux-block/for-next.
> 
> Changed since v1 (https://lkml.kernel.org/r/20200902051511.79821-1-ebiggers@kernel.org):
>     - Added patches 2 and 3.
>     - Added kerneldoc for bio_crypt_clone().
>     - Adjusted commit message.
> 
> Eric Biggers (3):
>   block: make bio_crypt_clone() able to fail
>   block: make blk_crypto_rq_bio_prep() able to fail
>   block: warn if !__GFP_DIRECT_RECLAIM in bio_crypt_set_ctx()

Jens, any interest in applying these patches for 5.10?

- Eric
