From: Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH 2/3] dm: add support for passing through inline crypto
 support
Date: Thu, 24 Sep 2020 07:17:21 +0000
Message-ID: <20200924071721.GA1883346@google.com>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-3-satyat@google.com>
 <20200922003255.GC32959@sol.localdomain>
 <20200924011438.GD10500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200924011438.GD10500@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 23, 2020 at 09:14:39PM -0400, Mike Snitzer wrote:
> On Mon, Sep 21 2020 at  8:32pm -0400,
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > On Wed, Sep 09, 2020 at 11:44:21PM +0000, Satya Tangirala wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Update the device-mapper core to support exposing the inline crypto
> > > support of the underlying device(s) through the device-mapper device.
> > > 
> > > This works by creating a "passthrough keyslot manager" for the dm
> > > device, which declares support for encryption settings which all
> > > underlying devices support.  When a supported setting is used, the bio
> > > cloning code handles cloning the crypto context to the bios for all the
> > > underlying devices.  When an unsupported setting is used, the blk-crypto
> > > fallback is used as usual.
> > > 
> > > Crypto support on each underlying device is ignored unless the
> > > corresponding dm target opts into exposing it.  This is needed because
> > > for inline crypto to semantically operate on the original bio, the data
> > > must not be transformed by the dm target.  Thus, targets like dm-linear
> > > can expose crypto support of the underlying device, but targets like
> > > dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> > > 
> > > When a key is evicted from the dm device, it is evicted from all
> > > underlying devices.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > Co-developed-by: Satya Tangirala <satyat@google.com>
> > > Signed-off-by: Satya Tangirala <satyat@google.com>
> > 
> > Looks good as far as Satya's changes from my original patch are concerned.
> > 
> > Can the device-mapper maintainers take a look at this?
> 
> In general it looks like these changes were implemented very carefully
> and are reasonable if we _really_ want to enable passing through inline
> crypto.
> 
> I do have concerns about the inability to handle changes at runtime (due
> to a table reload that introduces new devices without the encryption
> settings the existing devices in the table are using).  But the fallback
> mechanism saves it from being a complete non-starter.
Unfortunately, the fallback doesn't completely handle that situation
right now. The DM device could be suspended while an upper layer like
fscrypt is doing something like "checking if encryption algorithm 'A'
is supported by the DM device". It's possible that fscrypt thinks
the DM device supports 'A' even though the DM device is suspended, and
the table is about to be reloaded to introduce a new device that doesn't
support 'A'. Before the DM device is resumed with the new table, fscrypt
might send a bio that uses encryption algorithm 'A' without initializing
the blk-crypto-fallback ciphers for 'A', because it believes that the DM
device supports 'A'. When the bio gets processed by the DM (or when
blk-crypto does its checks to decide whether to use the fallback on that
bio), the bio will fail because the fallback ciphers aren't initialized.

Off the top of my head, one thing we could do is to always allocate the
fallback ciphers when the device mapper is the target device for the bio
(by maybe adding a "encryption_capabilities_may_change_at_runtime" flag
to struct blk_keyslot_manager that the DM will set to true, and that
the block layer will check for and decide to appropriately allocate
the fallback ciphers), although this does waste memory on systems
where we know the DM device tables will never change....

This patch also doesn't handle the case when the encryption capabilities
of the new table are a superset of the old capabilities.  Currently, a
DM device's capabilities can only shrink after the device is initially
created. They can never "expand" to make use of capabilities that might
be added due to introduction of new devices via table reloads.  I might
be forgetting something I thought of before, but looking at it again
now, I don't immediately see anything wrong with expanding the
advertised capabilities on table reload....I'll look carefully into that
again.
> 
> Can you help me better understand the expected consumer of this code?
> If you have something _real_ please be explicit.  It makes justifying
> supporting niche code like this more tolerable.
So the motivation for this code was that Android currently uses a device
mapper target on top of a phone's disk for user data. On many phones,
that disk has inline encryption support, and it'd be great to be able to
make use of that. The DM device configuration isn't changed at runtime.
> 
> Thanks,
> Mike
> 
