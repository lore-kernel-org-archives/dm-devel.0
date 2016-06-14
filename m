From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add Pure Storage device to
 hardware table
Date: Tue, 14 Jun 2016 14:32:47 +0200
Message-ID: <dc5c07f3-361b-9d32-c926-a394c1543c9a@gmail.com>
References: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>, Brian Bunker <brian@purestorage.com>
List-Id: dm-devel.ids

On 06/13/2016 06:30 PM, Xose Vazquez Perez wrote:

> based on documentation provided by the manufacturer:
> https://support.purestorage.com/@api/deki/files/1733/=Pure_Storage_Oracle_DB_Best_Practices.pdf?revision=2
> 
> vendor                  "PURE"
> product                 "FlashArray"	(extracted from outputs)

Please DROP this one. It was already included by Brian Bunker <brian@purestorage.com>

> +	{
> +		.vendor        = "PURE",
> +		.product       = "FlashArray",
> +		.selector      = "round-robin 0",
> +		.pgpolicy      = MULTIBUS,
> +		.minio         = 1,
> +		.checker_name  = TUR,
> +		.fast_io_fail  = 10,
> +		.dev_loss      = 30,
> +	},

Though it's a bit different. Why ?

+               .vendor        = "PURE",
+               .product       = "FlashArray",
+               .features      = DEFAULT_FEATURES,
+               .hwhandler     = DEFAULT_HWHANDLER,
+               .selector      = "queue-length 0",
+               .pgpolicy      = MULTIBUS,
+               .pgfailback    = -FAILBACK_IMMEDIATE,
+               .checker_name  = TUR,
+               .fast_io_fail  = 10,
+               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
+               .prio_name     = DEFAULT_PRIO,
+               .no_path_retry = 0,
+               .dev_loss      = 60,
+               .prio_args     = NULL,
