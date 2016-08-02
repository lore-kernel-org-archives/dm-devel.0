From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add template to add new
	hardware
Date: Tue, 2 Aug 2016 22:34:04 +0200
Message-ID: <b03717f3-b371-a4bb-19d2-d1b4af54d00d@gmail.com>
References: <1468334507-7531-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468334507-7531-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/12/2016 04:41 PM, Xose Vazquez Perez wrote:

> +	/*
> +	 * Copy this TEMPLATE to add new hardware.
> +	 *
> +	 * Keep only mandatory and modified attributes.
> +	 * Standard attributes must be removed.
> +	 *
> +	 * COMPANY_NAME
> +	 *
> +	 * Maintainer : XXX
> +	 * Mail : XXX
> +	 */
> +	{
> +		.vendor        = "VENDOR", (Mandatory)
> +		.product       = "PRODUCT", (Mandatory)
> +		.revision      = "REVISION",
> +		.bl_product    = "BL_PRODUCT",
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.uid_attribute = "ID_SERIAL",
> +		.selector      = "service-time 0",
> +		.checker_name  = TUR,
> +		.features      = "0",
> +		.hwhandler     = "0",
> +		.prio_name     = "const",
> +		.prio_args     = "",
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = NO_PATH_RETRY_UNDEF,
> +		.minio         = 1000,
> +		.minio_rq      = 1,
> +		.flush_on_last_del = FLUSH_DISABLED,
> +		.fast_io_fail  = 5,
> +		.dev_loss      = 600,
> +		.retain_hwhandler = RETAIN_HWHANDLER_ON,
> +		.detect_prio   = DETECT_PRIO_ON,
> +		.deferred_remove = DEFERRED_REMOVE_OFF,
> +		.delay_watch_checks = DELAY_CHECKS_OFF,
> +		.delay_wait_checks = DELAY_CHECKS_OFF,

Note that ".getuid" ".alias_prefix" and ".user_friendly_names" were hidden
consciously from the TEMPLATE.
