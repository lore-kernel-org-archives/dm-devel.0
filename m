From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm: add support for passing through inline crypto
 support
Date: Wed, 23 Sep 2020 21:14:39 -0400
Message-ID: <20200924011438.GD10500@redhat.com>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-3-satyat@google.com>
 <20200922003255.GC32959@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200922003255.GC32959@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Satya Tangirala <satyat@google.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 21 2020 at  8:32pm -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Sep 09, 2020 at 11:44:21PM +0000, Satya Tangirala wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Update the device-mapper core to support exposing the inline crypto
> > support of the underlying device(s) through the device-mapper device.
> > 
> > This works by creating a "passthrough keyslot manager" for the dm
> > device, which declares support for encryption settings which all
> > underlying devices support.  When a supported setting is used, the bio
> > cloning code handles cloning the crypto context to the bios for all the
> > underlying devices.  When an unsupported setting is used, the blk-crypto
> > fallback is used as usual.
> > 
> > Crypto support on each underlying device is ignored unless the
> > corresponding dm target opts into exposing it.  This is needed because
> > for inline crypto to semantically operate on the original bio, the data
> > must not be transformed by the dm target.  Thus, targets like dm-linear
> > can expose crypto support of the underlying device, but targets like
> > dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> > 
> > When a key is evicted from the dm device, it is evicted from all
> > underlying devices.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Co-developed-by: Satya Tangirala <satyat@google.com>
> > Signed-off-by: Satya Tangirala <satyat@google.com>
> 
> Looks good as far as Satya's changes from my original patch are concerned.
> 
> Can the device-mapper maintainers take a look at this?

In general it looks like these changes were implemented very carefully
and are reasonable if we _really_ want to enable passing through inline
crypto.

I do have concerns about the inability to handle changes at runtime (due
to a table reload that introduces new devices without the encryption
settings the existing devices in the table are using).  But the fallback
mechanism saves it from being a complete non-starter.

Can you help me better understand the expected consumer of this code?
If you have something _real_ please be explicit.  It makes justifying
supporting niche code like this more tolerable.

Thanks,
Mike
