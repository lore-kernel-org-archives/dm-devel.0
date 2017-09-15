From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 1/4] discovery: sanitize NVMe discovery
Date: Fri, 15 Sep 2017 18:00:01 +0800
Message-ID: <b7d83b8e-f46d-3281-f572-6c9551e25fca@huawei.com>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
	<1505457030-119611-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-2-git-send-email-hare@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids



On 2017/9/15 14:30, Hannes Reinecke wrote:
> Bring the output of NVMe discovery inline with the other transports,
> and set the sg_id mappings to avoid ugly '#' outputs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

> -	}
> -	if (!nvme)
> +	if (sscanf(attr_path, "nvme%dn%d",
> +		   &pp->sg_id.host_no,
> +		   &pp->sg_id.scsi_id) != 2)
> +		return 1;
> +	pp->sg_id.channel = 0;
> +	pp->sg_id.lun = 0;
> +


As seen in PATCH0/4, it's better to use nvme_id fields which shows the true
topology of NVMe/NVMf storage something like this: host NQN ->portid->subsytem NQN ->
controller ID ->namespace id .
The NQN is too long may be we could select the last few bytes.

However, your current method looks fine. And some suggestions:

(1)How about assigning sg_id.channel to controller id of target (seen in the
/sys/class/nvme/nvme0/nvme0n1/device/cntlid)
(2)And assigning sg_id.lun to namespace ID of target(seen in the
:/sys/class/nvme/nvme0/nvme0n1/nsid)
