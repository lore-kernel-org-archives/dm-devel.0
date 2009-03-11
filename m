From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH]:[multipath-tools] Adding the hwtable for
	LSI generic rdac storage devices
Date: Tue, 10 Mar 2009 18:17:49 -0700
Message-ID: <1236734269.11383.1.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF46675B0E8@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF46675B0E8@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Fri, 2009-03-06 at 09:38 -0700, Moger, Babu wrote:
> This patch adds the hwtable for LSI rdac generic storage. Also sets the feature pg_init_retries to maximum(50).
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> 
> ---
> 
> --- multipath-tools/libmultipath/hwtable.c.orig	2009-03-04 14:33:11.000000000 -0600
> +++ multipath-tools/libmultipath/hwtable.c	2009-03-04 14:43:57.000000000 -0600
> @@ -837,6 +837,22 @@ static struct hwentry default_hw[] = {
>  		.checker_name  = RDAC,
>  		.prio_name     = PRIO_RDAC,
>  	},
> +	/* LSI Generic rdac storage */
> +	{
> +		.vendor        = "(LSI|ENGENIO)",
> +		.product       = "INF-01-00",
> +		.getuid        = DEFAULT_GETUID,
> +		.features      = "2 pg_init_retries 50",
> +		.hwhandler     = "1 rdac",
> +		.selector      = DEFAULT_SELECTOR,
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = 15,

you don't want to use "queue" for no path retry ?
 
> +		.minio         = DEFAULT_MINIO,
> +		.checker_name  = RDAC,
> +		.prio_name     = PRIO_RDAC,
> +	},
>  	/*
>  	 * EOL
>  	 */
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
