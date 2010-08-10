From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [Patch] scsi_dh_rdac: retry IO for 06/3f/03 in
 rdac_check_sense fn
Date: Mon, 09 Aug 2010 18:47:38 -0700
Message-ID: <1281404858.23351.6.camel@chandra-lucid.beaverton.ibm.com>
References: <1C9608B8A4CD534FB19C7C7543CBB24902991CCA21@inbmail02.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB24902991CCA21@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

Vijay,

Since it has to be handled at SCSI (and it is a SCSI sense), shouldn't
we be retrying it at SCSI level. James, what is your opinion ?

It looks good to me as the effect is local to LSI rdac storage.

chandra

On Mon, 2010-08-02 at 13:07 +0530, Chauhan, Vijay wrote:
> Hi,
> 
> This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer, as a reason momentarily path failure is noticed by DM multipath. 
> 
> Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
> Reviewed-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> ---
> 
> diff -uprN linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c
> --- linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-22 15:13:38.000000000 -0400
> +++ linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-27 12:13:58.000000000 -0400
> @@ -738,6 +738,11 @@ static int rdac_check_sense(struct scsi_
>  			 * Quiescence in progress , just retry.
>  			 */
>  			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
> +			/*
> +			 * INQUIRY DATA has changed, retry again.
> +			 */
> +			return ADD_TO_MLQUEUE;
>  		break;
>  	}
>  	/* success just means we do not care what scsi-ml does */
> 
> --


