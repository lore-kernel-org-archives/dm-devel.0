From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm: add support for passing through
 inline crypto support
Date: Wed, 23 Sep 2020 21:21:03 -0400
Message-ID: <20200924012103.GE10500@redhat.com>
References: <20200909234422.76194-1-satyat@google.com>
	<20200909234422.76194-3-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200909234422.76194-3-satyat@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Satya Tangirala <satyat@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 09 2020 at  7:44pm -0400,
Satya Tangirala <satyat@google.com> wrote:

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
> ---
>  block/blk-crypto.c              |  1 +
>  block/keyslot-manager.c         | 34 ++++++++++++
>  drivers/md/dm-core.h            |  4 ++
>  drivers/md/dm-table.c           | 52 +++++++++++++++++++
>  drivers/md/dm.c                 | 92 ++++++++++++++++++++++++++++++++-
>  include/linux/device-mapper.h   |  6 +++
>  include/linux/keyslot-manager.h |  7 +++
>  7 files changed, 195 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index 2d5e60023b08..33555cf0e3e7 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -402,3 +402,4 @@ int blk_crypto_evict_key(struct request_queue *q,
>  	 */
>  	return blk_crypto_fallback_evict_key(key);
>  }
> +EXPORT_SYMBOL_GPL(blk_crypto_evict_key);
> diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
> index 60ac406d54b9..e0f776c38d8a 100644
> --- a/block/keyslot-manager.c
> +++ b/block/keyslot-manager.c
> @@ -416,6 +416,40 @@ void blk_ksm_unregister(struct request_queue *q)
>  {
>  	q->ksm = NULL;
>  }
> +EXPORT_SYMBOL_GPL(blk_ksm_unregister);
> +
> +/**
> + * blk_ksm_intersect_modes() - restrict supported modes by child device
> + * @parent: The keyslot manager for parent device
> + * @child: The keyslot manager for child device, or NULL
> + *
> + * Clear any crypto mode support bits in @parent that aren't set in @child.
> + * If @child is NULL, then all parent bits are cleared.
> + *
> + * Only use this when setting up the keyslot manager for a layered device,
> + * before it's been exposed yet.
> + */
> +void blk_ksm_intersect_modes(struct blk_keyslot_manager *parent,
> +			     const struct blk_keyslot_manager *child)
> +{
> +	if (child) {
> +		unsigned int i;
> +
> +		parent->max_dun_bytes_supported =
> +			min(parent->max_dun_bytes_supported,
> +			    child->max_dun_bytes_supported);
> +		for (i = 0; i < ARRAY_SIZE(child->crypto_modes_supported);
> +		     i++) {
> +			parent->crypto_modes_supported[i] &=
> +				child->crypto_modes_supported[i];
> +		}
> +	} else {
> +		parent->max_dun_bytes_supported = 0;
> +		memset(parent->crypto_modes_supported, 0,
> +		       sizeof(parent->crypto_modes_supported));
> +	}
> +}
> +EXPORT_SYMBOL_GPL(blk_ksm_intersect_modes);
>  
>  /**
>   * blk_ksm_init_passthrough() - Init a passthrough keyslot manager
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index c4ef1fceead6..4542050eebfc 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -12,6 +12,7 @@
>  #include <linux/kthread.h>
>  #include <linux/ktime.h>
>  #include <linux/blk-mq.h>
> +#include <linux/keyslot-manager.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -49,6 +50,9 @@ struct mapped_device {
>  
>  	int numa_node_id;
>  	struct request_queue *queue;
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	struct blk_keyslot_manager ksm;
> +#endif
>  
>  	atomic_t holders;
>  	atomic_t open_count;

Any reason you placed the ksm member where you did?

Looking at 'struct blk_keyslot_manager' I'm really hating adding that
bloat to every DM device for a feature that really won't see much broad
use (AFAIK).

Any chance you could allocate 'struct blk_keyslot_manager' as needed so
that most users of DM would only be carrying 1 extra pointer (set to
NULL)?

Thanks,
Mike
