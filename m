From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] block: make bio_crypt_clone() able to fail
Date: Wed, 23 Sep 2020 20:56:47 -0400
Message-ID: <20200924005647.GB10500@redhat.com>
References: <20200916035315.34046-1-ebiggers@kernel.org>
 <20200916035315.34046-2-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200916035315.34046-2-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Miaohe Lin <linmiaohe@huawei.com>, dm-devel@redhat.com, Satya Tangirala <satyat@google.com>
List-Id: dm-devel.ids

On Tue, Sep 15 2020 at 11:53pm -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> bio_crypt_clone() assumes its gfp_mask argument always includes
> __GFP_DIRECT_RECLAIM, so that the mempool_alloc() will always succeed.
> 
> However, bio_crypt_clone() might be called with GFP_ATOMIC via
> setup_clone() in drivers/md/dm-rq.c, or with GFP_NOWAIT via
> kcryptd_io_read() in drivers/md/dm-crypt.c.
> 
> Neither case is currently reachable with a bio that actually has an
> encryption context.  However, it's fragile to rely on this.  Just make
> bio_crypt_clone() able to fail, analogous to bio_integrity_clone().
> 
> Reported-by: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Satya Tangirala <satyat@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
