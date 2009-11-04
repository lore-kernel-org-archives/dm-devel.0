From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh_rdac: Add two new IBM devices to rdac_dev_list
Date: Wed, 04 Nov 2009 13:35:45 -0800
Message-ID: <1257370545.21609.10.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF48744CE36@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF48744CE36@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Wed, 2009-11-04 at 12:36 -0700, Moger, Babu wrote:
> This patch adds two new IBM storage devices which can use rdac device handlers.
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> ---
> --- linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-11-03 16:06:58.677451876 -0600
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-11-03 16:08:29.725570987 -0600
> @@ -666,6 +666,8 @@ static const struct scsi_dh_devlist rdac
>  	{"IBM", "1724"},
>  	{"IBM", "1726"},
>  	{"IBM", "1742"},
> +	{"IBM", "1745"},
> +	{"IBM", "1746"},
>  	{"IBM", "1814"},
>  	{"IBM", "1815"},
>  	{"IBM", "1818"},
> 
> 

