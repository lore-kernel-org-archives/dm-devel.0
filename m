From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH][RESUBMIT] scsi_dh_rdac: Fix for returning correct mode
	select cmd return info
Date: Fri, 28 Aug 2009 10:50:51 -0700
Message-ID: <1251481851.20333.3.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F39@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474C65F39@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
List-Id: dm-devel.ids


On Fri, 2009-08-28 at 08:18 -0600, Moger, Babu wrote:
> The function mode_select_handle_sense returns SCSI_DH_OK even when there is a sense code which is incorrect. Removing it so that it returns SCSI_DH_IO when there is sense that is not handled by this function.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-22 06:20:45.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-22 06:18:36.000000000 -0500
> @@ -455,8 +455,6 @@ static int mode_select_handle_sense(stru
>  	if (!ret)
>  		goto done;
> 
> -	err = SCSI_DH_OK;
> -
>  	switch (sense_hdr.sense_key) {
>  	case NO_SENSE:
>  	case ABORTED_COMMAND:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

