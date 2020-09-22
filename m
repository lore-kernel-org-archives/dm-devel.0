From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 2/3] dm: add support for passing through inline crypto
 support
Date: Mon, 21 Sep 2020 17:32:55 -0700
Message-ID: <20200922003255.GC32959@sol.localdomain>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-3-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200909234422.76194-3-satyat@google.com>
To: Satya Tangirala <satyat@google.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 09, 2020 at 11:44:21PM +0000, Satya Tangirala wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Update the device-mapper core to support exposing the inline crypto
> support of the underlying device(s) through the device-mapper device.
> 
> This works by creating a "passthrough keyslot manager" for the dm
> device, which declares support for encryption settings which all
> underlying devices support.  When a supported setting is used, the bio
> cloning code handles cloning the crypto context to the bios for all the
> underlying devices.  When an unsupported setting is used, the blk-crypto
> fallback is used as usual.
> 
> Crypto support on each underlying device is ignored unless the
> corresponding dm target opts into exposing it.  This is needed because
> for inline crypto to semantically operate on the original bio, the data
> must not be transformed by the dm target.  Thus, targets like dm-linear
> can expose crypto support of the underlying device, but targets like
> dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> 
> When a key is evicted from the dm device, it is evicted from all
> underlying devices.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>

Looks good as far as Satya's changes from my original patch are concerned.

Can the device-mapper maintainers take a look at this?

- Eric
