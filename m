From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH]scsi_dh_rdac: Retry for Quiescence in Progress in rdac
	device handler
Date: Mon, 26 Jan 2009 13:04:18 -0800
Message-ID: <1233003858.3759.15.camel@chandra-ubuntu>
References: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
List-Id: dm-devel.ids


On Mon, 2009-01-26 at 21:29 +0530, Chauhan, Vijay wrote:
> During device discovery read capacity fails with 0x068b02 and sets the device size to 0. As a reason any I/O submitted to this path gets killed at sd_prep_fn with BLKPREP_KILL. This patch is to retry for 0x068b02. Please apply.
> 
> From: Vijay Chauhan<vijay.chauhan@lsi.com>
> 
> This patch adds retry for Quiescence in Progress in rdac device handler.
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> ---
> --- linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig    2009-01-26 20:46:05.000000000 +0530
> +++ linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c 2009-01-26 20:47:34.000000000 +0530
> @@ -579,6 +579,11 @@ static int rdac_check_sense(struct scsi_
>                          * Power On, Reset, or Bus Device Reset, just retry.
>                          */
>                         return ADD_TO_MLQUEUE;
> +               if (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02)
> +                       /*
> +                        * Quiescence in progress , just retry.
> +                        */
> +                       return ADD_TO_MLQUEUE;
>                 break;
>         }
>         /* success just means we do not care what scsi-ml does */
> --

