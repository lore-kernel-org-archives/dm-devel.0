From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] add support for next generation of Dell PV array
Date: Mon, 17 Aug 2009 17:13:15 -0700
Message-ID: <1250554395.355.15.camel@chandra-ubuntu>
References: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Yanqing_Liu@Dell.com
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Looks good to me and Moger Babu verified the vendor/product IDs

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Mon, 2009-08-17 at 14:31 -0500, Yanqing_Liu@Dell.com wrote:
> Hello,
> 
> 
> This patch is to add DM support for next generation of Dell PowerVault
> storage array.
> 
> 
> Signed-off-by: Yanqing Liu <Yanqing_Liu@Dell.com>
> 
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 2009-08-05 16:30:51.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c
> 2009-08-05 16:34:00.000000000 -0500
> @@ -631,6 +631,8 @@ static const struct scsi_dh_devlist rdac
>  	{"SUN", "LCSM100_F"},
>  	{"DELL", "MD3000"},
>  	{"DELL", "MD3000i"},
> +	{"DELL", "MD32xx"},
> +	{"DELL", "MD32xxi"},
>  	{"LSI", "INF-01-00"},
>  	{"ENGENIO", "INF-01-00"},
>  	{NULL, NULL},
> 
> Thanks,
> Yanqing
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

