From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/5] nvme: Add more command status translation
Date: Mon, 8 Jan 2018 09:39:50 +0100
Message-ID: <15f7ae47-58cf-58b4-1a3a-6d6c2fd85eb4@suse.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-2-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104224623.8944-2-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On 01/04/2018 11:46 PM, Keith Busch wrote:
> This adds more NVMe status code translations to blk_status_t values,
> and captures all the current status codes NVMe multipath uses.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/nvme/host/core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 2a69d735efbc..f1cf1f6c5b28 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -156,14 +156,20 @@ static blk_status_t nvme_error_status(struct request *req)
>  	case NVME_SC_SUCCESS:
>  		return BLK_STS_OK;
>  	case NVME_SC_CAP_EXCEEDED:
> +	case NVME_SC_LBA_RANGE:
>  		return BLK_STS_NOSPC;
> +	case NVME_SC_BAD_ATTRIBUTES:
>  	case NVME_SC_ONCS_NOT_SUPPORTED:
> +	case NVME_SC_INVALID_OPCODE:
> +	case NVME_SC_INVALID_FIELD:
> +	case NVME_SC_INVALID_NS:
>  		return BLK_STS_NOTSUPP;
>  	case NVME_SC_WRITE_FAULT:
>  	case NVME_SC_READ_ERROR:
>  	case NVME_SC_UNWRITTEN_BLOCK:
>  	case NVME_SC_ACCESS_DENIED:
>  	case NVME_SC_READ_ONLY:
> +	case NVME_SC_COMPARE_FAILED:
>  		return BLK_STS_MEDIUM;
>  	case NVME_SC_GUARD_CHECK:
>  	case NVME_SC_APPTAG_CHECK:
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
