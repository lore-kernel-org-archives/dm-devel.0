From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 4/7] scsi_dh: Update EMC handler
Date: Wed, 14 May 2008 19:47:09 -0700
Message-ID: <1210819629.21974.255.camel@chandra-ubuntu>
References: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
<snip>

> 
> @@ -438,10 +604,32 @@ static int clariion_bus_attach(struct scsi_device *sdev)
>  	sdev->scsi_dh_data = scsi_dh_data;
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> 
Can move the block above to be just before try_module_get() and avoid
undoing it in the failed path.

> -	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
> +	err = clariion_std_inquiry(sdev);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +
> +	err = clariion_send_inquiry(sdev);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +


