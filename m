From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/3] block: keyslot-manager: Introduce passthrough
 keyslot manager
Date: Mon, 21 Sep 2020 17:27:25 -0700
Message-ID: <20200922002725.GB32959@sol.localdomain>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-2-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200909234422.76194-2-satyat@google.com>
To: Satya Tangirala <satyat@google.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 09, 2020 at 11:44:20PM +0000, Satya Tangirala wrote:
> The device mapper may map over devices that have inline encryption
> capabilities, and to make use of those capabilities, the DM device must
> itself advertise those inline encryption capabilities. One way to do this
> would be to have the DM device set up a keyslot manager with a
> "sufficiently large" number of keyslots, but that would use a lot of
> memory. Also, the DM device itself has no "keyslots", and it doesn't make
> much sense to talk about "programming a key into a DM device's keyslot
> manager", so all that extra memory used to represent those keyslots is just
> wasted. All a DM device really needs to be able to do is advertise the
> crypto capabilities of the underlying devices in a coherent manner and
> expose a way to evict keys from the underlying devices.
> 
> There are also devices with inline encryption hardware that do not
> have a limited number of keyslots. One can send a raw encryption key along
> with a bio to these devices (as opposed to typical inline encryption
> hardware that require users to first program a raw encryption key into a
> keyslot, and send the index of that keyslot along with the bio). These
> devices also only need the same things from the keyslot manager that DM
> devices need - a way to advertise crypto capabilities and potentially a way
> to expose a function to evict keys from hardware.

To be a bit more concrete, FMP (Flash Memory Protector) on Exynos SoCs is an
example of hardware that supports inline encryption without having the concept
of keyslots.  On that hardware, each request takes an actual key, rather than a
keyslot number.  Likewise, some Mediatek SoCs are like this too.

So support for inline encryption without keyslots is something that is useful
for real hardware, in addition to the device-mapper support which is the initial
use case included in this patchset.

> So we introduce a "passthrough" keyslot manager that provides a way to
> represent a keyslot manager that doesn't have just a limited number of
> keyslots, and for which do not require keys to be programmed into keyslots.
> DM devices can set up a passthrough keyslot manager in their request
> queues, and advertise appropriate crypto capabilities based on those of the
> underlying devices. Blk-crypto does not attempt to program keys into any
> keyslots in the passthrough keyslot manager. Instead, if/when the bio is
> resubmitted to the underlying device, blk-crypto will try to program the
> key into the underlying device's keyslot manager.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Generally looks good, feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

However, maybe it's worth reconsidering the suggestion I've made previously
(https://lkml.kernel.org/linux-block/20200326062213.GF858@sol.localdomain) of
separating the crypto capabilities from the keyslot manager.  If we did that,
then this case could be handled by a NULL keyslot manager, rather than a special
kind of keyslot manager that doesn't actually do the keyslot management.

I realize that it's a bit tricky because the key eviction callback would still
be needed.  So maybe it's not really better.  Also, previously other people have
seemed to prefer just the keyslot manager, e.g.
https://lkml.kernel.org/linux-block/20200327170047.GA24682@infradead.org.

Does anyone have any new thoughts on this?

Also, a couple minor comments below.

> @@ -353,6 +372,9 @@ void blk_ksm_reprogram_all_keys(struct blk_keyslot_manager *ksm)
>  {
>  	unsigned int slot;
>  
> +	if (WARN_ON(blk_ksm_is_passthrough(ksm)))
> +		return;
> +

I think the above WARN_ON() should just be removed:

	if (blk_ksm_is_passthrough(ksm))
		return;

Otherwise callers might need to conditionally call blk_ksm_reprogram_all_keys()
depending on whether there are keyslots or not.

> +/**
> + * blk_ksm_init_passthrough() - Init a passthrough keyslot manager
> + * @ksm: The keyslot manager to init
> + *
> + * Initialize a passthrough keyslot manager.
> + * Called by e.g. storage drivers to set up a keyslot manager in their
> + * request_queue, when the storage driver wants to manage its keys by itself.
> + * This is useful for inline encryption hardware that don't have a small fixed
> + * number of keyslots, and for layered devices.
> + *

Maybe:

"inline encryption hardware that don't have a small fixed number of keyslots"

=>

"inline encryption hardware that doesn't have the concept of keyslots"
