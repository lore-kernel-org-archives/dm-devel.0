From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 3/5] block: Provide blk_status_t decoding for retryable
 errors
Date: Mon, 8 Jan 2018 09:58:05 +0100
Message-ID: <a6ff3178-7166-1d6b-d77a-d8fc3eb2071b@suse.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-4-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104224623.8944-4-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On 01/04/2018 11:46 PM, Keith Busch wrote:
> This patch provides a common decoder for block status that may be retried
> so various entities wishing to consult this do not have to duplicate
> this decision.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  include/linux/blk_types.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index a1e628e032da..b6a8723b493c 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -39,6 +39,22 @@ typedef u8 __bitwise blk_status_t;
>  
>  #define BLK_STS_AGAIN		((__force blk_status_t)12)
>  
> +static inline bool blk_retryable(blk_status_t error)
> +{
> +	switch (error) {
> +	case BLK_STS_NOTSUPP:
> +	case BLK_STS_NOSPC:
> +	case BLK_STS_TARGET:
> +	case BLK_STS_NEXUS:
> +	case BLK_STS_MEDIUM:
> +	case BLK_STS_PROTECTION:
> +		return false;
> +	}
> +
> +	/* Anything else could be a path failure, so should be retried */
> +	return true;
> +}
> +
>  struct blk_issue_stat {
>  	u64 stat;
>  };
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
